logger::log_threshold("INFO")
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
}


scenario_preparation_outputs_path <- Sys.getenv(
  "SCENARIO_PREPARATION_OUTPUTS_PATH",
  "./outputs"
)

if (fs::dir_exists(scenario_preparation_outputs_path)) {
  logger::log_info("Setting scenario preparation outputs path: {scenario_preparation_outputs_path}")
} else {
  logger::log_error("Scenario preparation outputs path does not exist: {scenario_preparation_outputs_path}")
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

logger::log_info("Determining scenarios to include.")

scenarios_to_include <- config$inherits

logger::log_info("Scenarios to be included: {scenarios_to_include}")

logger::log_info("Processing scenarios.")

for (scenario in scenarios_to_include) {
  source(paste0("process_scenario_", scenario, ".R"))
}

logger::log_info("Finished processing scenarios.")
