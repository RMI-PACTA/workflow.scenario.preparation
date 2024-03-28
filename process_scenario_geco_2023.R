logger::log_info("GECO 2023: Setting GECO 2023 config.")

geco_2023_raw_path <- config[["geco_2023_raw_path"]]
geco_2023_15c_raw_filename <- config[["geco_2023_15c_raw_filename"]]
geco_2023_ndc_raw_filename <- config[["geco_2023_ndc_raw_filename"]]
geco_2023_ref_raw_filename <- config[["geco_2023_ref_raw_filename"]]
geco_2023_supplement_path <- config[["geco_2023_supplement_path"]]
geco_2023_supplement_15c_raw_filename <- config[["geco_2023_supplement_15c_raw_filename"]]
geco_2023_supplement_ndc_raw_filename <- config[["geco_2023_supplement_ndc_raw_filename"]]
geco_2023_supplement_ref_raw_filename <- config[["geco_2023_supplement_ref_raw_filename"]]


logger::log_info("GECO 2023: Setting GECO 2023 paths.")

geco_2023_raw_full_path <-
  file.path(
    scenario_preparation_inputs_path,
    geco_2023_raw_path
  )

geco_2023_15c_raw_filepath <-
  file.path(
    geco_2023_raw_full_path,
    geco_2023_15c_raw_filename
  )

geco_2023_ndc_raw_filepath <-
  file.path(
    geco_2023_raw_full_path,
    geco_2023_ndc_raw_filename
  )

geco_2023_ref_raw_filepath <-
  file.path(
    geco_2023_raw_full_path,
    geco_2023_ref_raw_filename
  )

geco_2023_supplement_full_path <-
  file.path(
    scenario_preparation_inputs_path,
    geco_2023_supplement_path
  )

geco_2023_supplement_15c_raw_filepath <-
  file.path(
    geco_2023_supplement_full_path,
    geco_2023_supplement_15c_raw_filename
  )

geco_2023_supplement_ndc_raw_filepath <-
  file.path(
    geco_2023_supplement_full_path,
    geco_2023_supplement_ndc_raw_filename
  )

geco_2023_supplement_ref_raw_filepath <-
  file.path(
    geco_2023_supplement_full_path,
    geco_2023_supplement_ref_raw_filename
  )


logger::log_info("GECO 2023: Checking that GECO 2023 filepaths exist.")

stopifnot(fs::file_exists(geco_2023_15c_raw_filepath))
stopifnot(fs::file_exists(geco_2023_ndc_raw_filepath))
stopifnot(fs::file_exists(geco_2023_ref_raw_filepath))
stopifnot(fs::file_exists(geco_2023_supplement_15c_raw_filepath))
stopifnot(fs::file_exists(geco_2023_supplement_ndc_raw_filepath))
stopifnot(fs::file_exists(geco_2023_supplement_ref_raw_filepath))


logger::log_info("GECO 2023: Loading GECO 2023 raw data.")

geco_2023_aviation_15c_raw <-
  readxl::read_xlsx(
    path = geco_2023_15c_raw_filepath,
    na = "",
    sheet = "Aviation"
  )

geco_2023_aviation_ndc_raw <-
  readxl::read_xlsx(
    path = geco_2023_ndc_raw_filepath,
    na = "",
    sheet = "Aviation"
  )

geco_2023_aviation_ref_raw <-
  readxl::read_xlsx(
    path = geco_2023_ref_raw_filepath,
    na = "",
    sheet = "Aviation"
  )

geco_2023_fossil_fuels_15c_raw <-
  readxl::read_xlsx(
    path = geco_2023_15c_raw_filepath,
    na = "",
    sheet = "Fossil Fuel Extraction"
  )

geco_2023_fossil_fuels_ndc_raw <-
  readxl::read_xlsx(
    path = geco_2023_ndc_raw_filepath,
    na = "",
    sheet = "Fossil Fuel Extraction"
  )

geco_2023_fossil_fuels_ref_raw <-
  readxl::read_xlsx(
    path = geco_2023_ref_raw_filepath,
    na = "",
    sheet = "Fossil Fuel Extraction"
  )

geco_2023_power_cap_15c_raw <-
  readxl::read_xlsx(
    path = geco_2023_15c_raw_filepath,
    na = "",
    sheet = "Capacity"
  )

geco_2023_power_cap_ndc_raw <-
  readxl::read_xlsx(
    path = geco_2023_ndc_raw_filepath,
    na = "",
    sheet = "Capacity"
  )

geco_2023_power_cap_ref_raw <-
  readxl::read_xlsx(
    path = geco_2023_ref_raw_filepath,
    na = "",
    sheet = "Capacity"
  )

geco_2023_steel_15c_raw <-
  readxl::read_xlsx(
    path = geco_2023_15c_raw_filepath,
    na = "",
    sheet = "Steel"
  )

geco_2023_steel_ndc_raw <-
  readxl::read_xlsx(
    path = geco_2023_ndc_raw_filepath,
    na = "",
    sheet = "Steel"
  )

geco_2023_steel_ref_raw <-
  readxl::read_xlsx(
    path = geco_2023_ref_raw_filepath,
    na = "",
    sheet = "Steel"
  )

geco_2023_supplement_15c_raw <-
  readxl::read_xlsx(
    path = geco_2023_supplement_15c_raw_filepath,
    na = "",
    sheet = "World",
    range = "A3:J109"
  )

geco_2023_supplement_ndc_raw <-
  readxl::read_xlsx(
    path = geco_2023_supplement_ndc_raw_filepath,
    na = "",
    sheet = "World",
    range = "A3:J109"
  )

geco_2023_supplement_ref_raw <-
  readxl::read_xlsx(
    path = geco_2023_supplement_ref_raw_filepath,
    na = "",
    sheet = "World",
    range = "A3:J109"
  )


logger::log_info("GECO 2023: Processing GECO 2023 data.")

geco_2023 <- pacta.scenario.data.preparation::prepare_geco_2023_scenario(
  geco_2023_aviation_15c_raw,
  geco_2023_aviation_ndc_raw,
  geco_2023_aviation_ref_raw,
  geco_2023_fossil_fuels_15c_raw,
  geco_2023_fossil_fuels_ndc_raw,
  geco_2023_fossil_fuels_ref_raw,
  geco_2023_power_cap_15c_raw,
  geco_2023_power_cap_ndc_raw,
  geco_2023_power_cap_ref_raw,
  geco_2023_steel_15c_raw,
  geco_2023_steel_ndc_raw,
  geco_2023_steel_ref_raw,
  geco_2023_supplement_15c_raw,
  geco_2023_supplement_ndc_raw,
  geco_2023_supplement_ref_raw
)

if (pacta.data.validation::validate_intermediate_scenario_output(geco_2023)) {
  logger::log_info("GECO 2023: GECO 2023 data is valid.")

  output_path <- fs::path(scenario_preparation_outputs_path, "geco_2023.csv")
  
  readr::write_csv(
    x = geco_2023,
    file = output_path

    logger::log_info("GECO 2023: GECO 2023 data saved to {output_path}.")
  )
} else {
  logger::log_error("GECO 2023 data is not valid.")
}
