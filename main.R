logger::log_threshold(Sys.getenv("LOG_LEVEL", "INFO"))
logger::log_formatter(logger::formatter_glue)

# set general i/o paths --------------------------------------------------------

scenario_preparation_inputs_path <- Sys.getenv(
  "SCENARIO_PREPARATION_INPUTS_PATH",
  "./inputs"
)

if (fs::dir_exists(scenario_preparation_inputs_path)) {
  logger::log_info("Setting scenario preparation inputs path: {scenario_preparation_inputs_path}")
} else {
  logger::log_error("Scenario preparation inputs path does not exist: {scenario_preparation_inputs_path}")
  stop()
}


scenario_preparation_outputs_path <- Sys.getenv(
  "SCENARIO_PREPARATION_OUTPUTS_PATH",
  "./outputs"
)

if (fs::dir_exists(scenario_preparation_outputs_path)) {
  logger::log_info("Setting scenario preparation outputs path: {scenario_preparation_outputs_path}")
} else {
  logger::log_error("Scenario preparation outputs path does not exist: {scenario_preparation_outputs_path}")
  stop()
}


# config -----------------------------------------------------------------------

logger::log_info("Loading configuration file.")

config_name <- Sys.getenv("R_CONFIG_ACTIVE")

logger::log_info("Getting config: {config_name}")

config <- config::get(
  file = "config.yml",
  config = config_name,
  use_parent = FALSE
)


# create timestamped output directory ------------------------------------------

system_timestamp <-
  format(
    Sys.time(),
    format = "%Y%m%d_T%H%M%SZ",
    tz = "UTC"
  )

scenario_preparation_outputs_path <-
  file.path(
    scenario_preparation_outputs_path,
    paste0(config_name, "_", system_timestamp)
  )

if (dir.exists(scenario_preparation_outputs_path)) {
  logger::log_warn("POTENTIAL DATA LOSS: Output directory already exists, and files may be overwritten ({scenario_preparation_outputs_path}).")
  warning("Output directory exists. Files may be overwritten.")
} else {
  logger::log_trace("Creating output directory: \"{scenario_preparation_outputs_path}\"")
  dir.create(scenario_preparation_outputs_path, recursive = TRUE)
}

logger::log_info("Files will be saved in directory: \"{scenario_preparation_outputs_path}\"")


# building scenarios -----------------------------------------------------------

logger::log_info("Determining scenarios to include.")

scenarios_to_include <- config$inherits

logger::log_info("Scenarios to be included: {scenarios_to_include}")

logger::log_info("Processing scenarios.")

for (scenario in scenarios_to_include) {
  source(paste0("process_scenario_", scenario, ".R"))
}

logger::log_info("Finished processing scenarios.")


# format and save scenarios for use in P4B -------------------------------------

logger::log_info("Determining scenarios to include.")

scenarios_to_include <- config$inherits

logger::log_info("Scenarios to be included: {scenarios_to_include}")

logger::log_info("Processing scenarios for P4B input.")

library(dplyr)

market_share_sectors <- c(
  "Automotive",
  "Coal",
  "Oil&Gas",
  "Power"
)

emission_intensity_sectors <- c(
  "Aviation",
  "Cement",
  "Steel"
)

if (nchar(gsub("Q.$", "", config_name)) == 4 & as.integer(gsub("Q.$", "", config_name)) >= 2020) {
  reference_year <- as.integer(gsub("Q.$", "", config_name))

  logger::log_info("config_name valid as a reference year. Preparing P4B scenarios with reference year {reference_year}.")
} else {
  logger::log_error("{config_name} cannot be used as a reference year.")
  stop()
}

scenarios_p4b <- NULL

for (scenario in scenarios_to_include) {
  scenario_i <- readr::read_csv(
    file.path(scenario_preparation_outputs_path, paste0(scenario, ".csv")),
    col_types = readr::cols_only(
      source = "c",
      scenario = "c",
      scenario_geography = "c",
      sector = "c",
      indicator = "c",
      units = "c",
      year = "i",
      technology = "c",
      value = "d"
    )
  )

  scenarios_p4b <- dplyr::bind_rows(scenarios_p4b, scenario_i)
}

# get the common final year across scenario sources
final_year <- dplyr::summarise(
  scenarios_p4b,
  final_year_source = max(year, na.rm = TRUE),
  .by = "source"
)

final_year <- min(final_year$final_year_source, na.rm = TRUE)

interpolation_groups <- c(
  "source",
  "scenario",
  "sector",
  "technology",
  "scenario_geography",
  "indicator",
  "units"
)

scenario_input_p4b <- scenarios_p4b %>%
  pacta.scenario.data.preparation::interpolate_yearly(!!!rlang::syms(interpolation_groups)) %>%
  filter(
    .data$year >= .env$reference_year,
    .data$year <= .env$final_year,
    .data$sector %in% .env$market_share_sectors
  ) %>%
  pacta.scenario.data.preparation::add_market_share_columns(reference_year = reference_year) %>%
  pacta.scenario.data.preparation::format_p4b()

if (pacta.data.validation::validate_intermediate_scenario_output(scenarios_p4b)) {
  logger::log_info("{reference_year} scenarios for P4B input are valid.")

  output_path <- fs::path(scenario_preparation_outputs_path, paste0("p4b_scenarios_", reference_year, ".csv"))

  readr::write_csv(
    x = scenario_input_p4b,
    file = output_path
  )

  logger::log_info("P4B {reference_year}: P4B {reference_year} scenario data saved to {output_path}.")

} else {
  logger::log_error("P4B {reference_year} scenario data is not valid.")
  stop()
}

scenario_input_p4b_ei <- scenarios_p4b %>%
  pacta.scenario.data.preparation::interpolate_yearly(!!!rlang::syms(interpolation_groups)) %>%
  filter(
    .data$year >= .env$reference_year,
    .data$year <= .env$final_year,
    .data$sector %in% .env$emission_intensity_sectors
  ) %>%
  pacta.scenario.data.preparation::format_p4b_ei()

if (pacta.data.validation::validate_intermediate_scenario_output(scenarios_p4b)) {
  logger::log_info("{reference_year} scenarios for P4B EI input are valid.")

  output_path <- fs::path(scenario_preparation_outputs_path, paste0("p4b_ei_scenarios_", reference_year, ".csv"))

  readr::write_csv(
    x = scenario_input_p4b_ei,
    file = output_path
  )

  logger::log_info("P4B EI {reference_year}: P4B EI {reference_year} scenario data saved to {output_path}.")

} else {
  logger::log_error("P4B EI {reference_year} scenario data is not valid.")
  stop()
}
