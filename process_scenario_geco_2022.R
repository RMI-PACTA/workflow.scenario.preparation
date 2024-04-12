logger::log_info("GECO 2022: Setting GECO 2022 config.")
geco_2022_path <- config[["geco_2022_path"]]
geco_2022_automotive_filename <- config$geco_2022_automotive_filename
geco_2022_aviation_filename <- config$geco_2022_aviation_filename
geco_2022_fossil_fuels_15c_filename <- config$geco_2022_fossil_fuels_15c_filename
geco_2022_fossil_fuels_ndc_filename <- config$geco_2022_fossil_fuels_ndc_filename
geco_2022_fossil_fuels_ref_filename <- config$geco_2022_fossil_fuels_ref_filename
geco_2022_power_15c_filename <- config$geco_2022_power_15c_filename
geco_2022_power_ndc_filename <- config$geco_2022_power_ndc_filename
geco_2022_power_ref_filename <- config$geco_2022_power_ref_filename
geco_2022_steel_filename <- config$geco_2022_steel_filename


# set filepaths ----------------------------------------------------------------

# geco 2022 specific files
geco2022_raw_path <- fs::path(scenario_preparation_inputs_path, geco_2022_path)

# GECO only provides retirement and stocks, @Antoine-Lalechere had to manually compute the
# sales on excel
# processed data, calculation are made in:
# /Users/antoinelalechere/RMI Dropbox/Antoine Lalechere/PACTA Dropbox/Portcheck_v2/00_Data/RawScenarioData/GECO2022/processed_data/where_calculation_are_made
geco_2022_automotive_filepath <- fs::path(
  geco2022_raw_path,
  "processed_data",
  "used_in_pacta.scenario.preparation",
  geco_2022_automotive_filename
)

# processed data, calculation are made in:
#/Users/antoinelalechere/RMI Dropbox/Antoine Lalechere/PACTA Dropbox/Portcheck_v2/00_Data/RawScenarioData/GECO2022/processed_data/where_calculation_are_made
geco_2022_aviation_filepath <- fs::path(
  geco2022_raw_path,
  "processed_data",
  "used_in_pacta.scenario.preparation",
  geco_2022_aviation_filename
)

# Raw data has been sent to us via email by JRC GECO in:
# /Users/antoinelalechere/RMI Dropbox/Antoine Lalechere/PACTA Dropbox/Portcheck_v2/00_Data/RawScenarioData/GECO2022/20230213_PACTA data request_GECO data template_NDC-LTS_data_reg.xlsx
# Next file is a csv formatting of sheet "Fossil Fuel Extraction"
geco_2022_fossil_fuels_15c_filepath <- fs::path(
  geco2022_raw_path,
  "formatted_from_raw_data",
  "used",
  geco_2022_fossil_fuels_15c_filename
)

geco_2022_fossil_fuels_ndc_filepath <- fs::path(
  geco2022_raw_path,
  "formatted_from_raw_data",
  "used",
  geco_2022_fossil_fuels_ndc_filename
)

geco_2022_fossil_fuels_ref_filepath <- fs::path(
  geco2022_raw_path,
  "formatted_from_raw_data",
  "used",
  geco_2022_fossil_fuels_ref_filename
)

# Raw data has been sent to us by JRC GECO in:
# /Users/antoinelalechere/RMI Dropbox/Antoine Lalechere/PACTA Dropbox/Portcheck_v2/00_Data/RawScenarioData/GECO2022/20230213_PACTA data request_GECO data template_NDC-LTS_data_reg.xlsx
# Next file is a csv formatting of sheet "Capacity"
geco_2022_power_15c_filepath <- fs::path(
  geco2022_raw_path,
  "formatted_from_raw_data",
  "used",
  geco_2022_power_15c_filename
)

geco_2022_power_ndc_filepath <- fs::path(
  geco2022_raw_path,
  "formatted_from_raw_data",
  "used",
  geco_2022_power_ndc_filename
)

geco_2022_power_ref_filepath <- fs::path(
  geco2022_raw_path,
  "formatted_from_raw_data",
  "used",
  geco_2022_power_ref_filename
)

# Raw data related to steel come from:
# /Users/antoinelalechere/RMI Dropbox/Antoine Lalechere/PACTA Dropbox/Portcheck_v2/00_Data/RawScenarioData/GECO2022/20230213_PACTA data request_GECO data template_XXX_data_reg.xlsx
# Raw data related to power generation come from:
# /Users/antoinelalechere/RMI Dropbox/Antoine Lalechere/PACTA Dropbox/Portcheck_v2/00_Data/RawScenarioData/GECO2022/GECO2022_20221221_15C.xlsx - line 26 & 110
# Calculation are made in:
# GECO2022_Steel_processed_data.xlsx
geco_2022_steel_filepath <- fs::path(
  geco2022_raw_path,
  "processed_data",
  "used_in_pacta.scenario.preparation",
  geco_2022_steel_filename
)

logger::log_info("GECO 2022: Checking that filepaths exist.")
stopifnot(fs::file_exists(geco_2022_automotive_filepath))
stopifnot(fs::file_exists(geco_2022_aviation_filepath))
stopifnot(fs::file_exists(geco_2022_fossil_fuels_15c_filepath))
stopifnot(fs::file_exists(geco_2022_fossil_fuels_ndc_filepath))
stopifnot(fs::file_exists(geco_2022_fossil_fuels_ref_filepath))
stopifnot(fs::file_exists(geco_2022_power_15c_filepath))
stopifnot(fs::file_exists(geco_2022_power_ndc_filepath))
stopifnot(fs::file_exists(geco_2022_power_ref_filepath))
stopifnot(fs::file_exists(geco_2022_steel_filepath))


# file i/o ---------------------------------------------------------------------

logger::log_info("GECO 2022: Loading data.")

geco_2022_automotive_raw <- readr::read_csv(
  geco_2022_automotive_filepath,
  na = "",
  col_types = readr::cols(
    GECO = "c",
    Scenario = "c",
    Vehicle = "c",
    Sector = "c",
    Technology = "c",
    Variable = "c",
    Unit = "c",
    Region = "c",
    .default = "d"
  )
)

geco_2022_aviation_raw <- readr::read_csv(
  geco_2022_aviation_filepath,
  na = "",
  col_types = readr::cols(
    GECO = "c",
    Scenario = "c",
    Variable = "c",
    `Passenger/Freight` = "c",
    Technology = "c",
    Unit = "c",
    Region = "c",
    .default = "d"
  )
)

geco_2022_fossil_fuels_15c_raw <- readr::read_csv(
  geco_2022_fossil_fuels_15c_filepath,
  na = "",
  name_repair = "unique_quiet",
  col_types = readr::cols(
    GECO = "c",
    Scenario = "c",
    Variable = "c",
    Fuel = "c",
    Unit = "c",
    Region = "c",
    .default = "d"
  )
)

geco_2022_fossil_fuels_ndc_raw <- readr::read_csv(
  geco_2022_fossil_fuels_ndc_filepath,
  na = "",
  name_repair = "unique_quiet",
  col_types = readr::cols(
    GECO = "c",
    Scenario = "c",
    Variable = "c",
    Fuel = "c",
    Unit = "c",
    Region = "c",
    .default = "d"
  )
)

geco_2022_fossil_fuels_ref_raw <- readr::read_csv(
  geco_2022_fossil_fuels_ref_filepath,
  na = "",
  name_repair = "unique_quiet",
  col_types = readr::cols(
    GECO = "c",
    Scenario = "c",
    Variable = "c",
    Fuel = "c",
    Unit = "c",
    Region = "c",
    .default = "d"
  )
)

geco_2022_power_15c_raw <- readr::read_csv(
  geco_2022_power_15c_filepath,
  na = "",
  col_types = readr::cols(
    GECO = "c",
    Scenario = "c",
    Variable = "c",
    Unit = "c",
    Region = "c",
    Technology = "c",
    .default = "d"
  )
)

geco_2022_power_ndc_raw <- readr::read_csv(
  geco_2022_power_ndc_filepath,
  na = "",
  col_types = readr::cols(
    GECO = "c",
    Scenario = "c",
    Variable = "c",
    Unit = "c",
    Region = "c",
    Technology = "c",
    .default = "d"
  )
)

geco_2022_power_ref_raw <- readr::read_csv(
  geco_2022_power_ref_filepath,
  na = "",
  col_types = readr::cols(
    GECO = "c",
    Scenario = "c",
    Variable = "c",
    Unit = "c",
    Region = "c",
    Technology = "c",
    .default = "d"
  )
)

geco_2022_steel_raw <- readr::read_csv(
  geco_2022_steel_filepath,
  na = "",
  col_types = readr::cols(
    Source = "c",
    Sector = "c",
    Scenario = "c",
    Region = "c",
    .default = "d"
  )
)


# prepare data -----------------------------------------------------------------

geco_2022 <- pacta.scenario.data.preparation::prepare_geco_2022_scenario(
  geco_2022_automotive_raw,
  geco_2022_aviation_raw,
  geco_2022_fossil_fuels_15c_raw,
  geco_2022_fossil_fuels_ndc_raw,
  geco_2022_fossil_fuels_ref_raw,
  geco_2022_power_15c_raw,
  geco_2022_power_ndc_raw,
  geco_2022_power_ref_raw,
  geco_2022_steel_raw
)


# check output data ------------------------------------------------------------

if (pacta.data.validation::validate_intermediate_scenario_output(geco_2022)) {
  logger::log_info("GECO 2022: GECO 2022 data is valid.")

  output_path <- fs::path(scenario_preparation_outputs_path, "geco_2022.csv")

  readr::write_csv(
    x = geco_2022,
    file = output_path
  )

  logger::log_info("GECO 2022: GECO 2022 data saved to {output_path}.")

} else {
  logger::log_error("GECO 2022: GECO 2022 data is not valid.")
}
