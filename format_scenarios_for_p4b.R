logger::log_info("Determine sectors to include in P4B scenarios for target market share calculation.")

market_share_sectors <- c(
  "Automotive",
  "Coal",
  "Oil&Gas",
  "Power"
)

logger::log_info("Determine sectors to include in P4B scenarios for emission intensity/SDA calculation.")

emission_intensity_sectors <- c(
  "Aviation",
  "Cement",
  "Steel"
)

logger::log_info("Ingerit reference year from config_name.")

if (nchar(gsub("Q.$", "", config_name)) == 4 & as.integer(gsub("Q.$", "", config_name)) >= 2020) {
  reference_year <- as.integer(gsub("Q.$", "", config_name))

  logger::log_info("config_name valid as a reference year. Preparing P4B scenarios with reference year {reference_year}.")
} else {
  logger::log_error("{config_name} cannot be used as a reference year.")
  stop()
}

logger::log_info("Read processed scenarios: {scenarios_to_include}.")

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

logger::log_info("Derive common final year across scenarios used.")

final_year <- dplyr::summarise(
  scenarios_p4b,
  final_year_source = max(year, na.rm = TRUE),
  .by = "source"
)

logger::log_info("Define interpolation groups for interpolation of yearly values.")

interpolation_groups <- c(
  "source",
  "scenario",
  "sector",
  "technology",
  "scenario_geography",
  "indicator",
  "units"
)

logger::log_info("Prepare processed scenarios for use in P4B market share calculation.")

scenario_input_p4b <- pacta.scenario.data.preparation::interpolate_yearly(
  data = scenarios_p4b,
  !!!rlang::syms(interpolation_groups)
)

scenario_input_p4b <- dplyr::filter(
  scenario_input_p4b,
  .data$year >= .env$reference_year,
  .data$sector %in% .env$market_share_sectors
)

final_year_by_sector_market_share <- dplyr::summarise(
  scenario_input_p4b,
  final_year = max(.data$year, na.rm = TRUE),
  .by = "sector"
)

final_year_market_share <- min(final_year_by_sector_market_share$final_year, na.rm = TRUE)

scenario_input_p4b <- dplyr::filter(
  scenario_input_p4b,
  .data$year <= .env$final_year_market_share
)

scenario_input_p4b <- pacta.scenario.data.preparation::add_market_share_columns(
  data = scenario_input_p4b,
  reference_year = reference_year
)

scenario_input_p4b <- pacta.scenario.data.preparation::format_p4b(scenario_input_p4b)

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

logger::log_info("Prepare processed scenarios for use in P4B EI/SDA calculation.")

scenario_input_p4b_ei <- pacta.scenario.data.preparation::interpolate_yearly(
    data = scenarios_p4b,
    !!!rlang::syms(interpolation_groups)
)

scenario_input_p4b_ei <- dplyr::filter(
  scenario_input_p4b_ei,
  .data$year >= .env$reference_year,
  .data$sector %in% .env$emission_intensity_sectors
)

final_year_by_sector_ei <- dplyr::summarise(
  scenario_input_p4b,
  final_year = max(.data$year, na.rm = TRUE),
  .by = "sector"
)

final_year_ei <- min(final_year_by_sector_ei$final_year, na.rm = TRUE)

scenario_input_p4b <- dplyr::filter(
  scenario_input_p4b,
  .data$year <= .env$final_year_ei
)

scenario_input_p4b_ei <- pacta.scenario.data.preparation::format_p4b_ei(scenario_input_p4b_ei)

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
