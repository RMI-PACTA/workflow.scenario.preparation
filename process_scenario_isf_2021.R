logger::log_info("ISF 2021: Setting ISF 2021 config.")

isf_2021_raw_path <- config[["isf_2021_raw_path"]]
isf_2021_power_raw_filename <- config[["isf_2021_power_raw_filename"]]
isf_2021_not_power_raw_filename <- config[["isf_2021_not_power_raw_filename"]]

logger::log_info("ISF 2021: Setting ISF 2021 paths.")

isf_2021_raw_full_path <-
  file.path(
    scenario_preparation_inputs_path,
    isf_2021_raw_path
  )

isf_2021_power_raw_full_filepath <-
  file.path(
    isf_2021_raw_full_path,
    isf_2021_power_raw_filename
  )

isf_2021_not_power_raw_full_filepath <-
  file.path(
    isf_2021_raw_full_path,
    isf_2021_not_power_raw_filename
  )

logger::log_info("ISF 2021: Checking that ISF 2021 filepaths exist.")

stopifnot(fs::file_exists(isf_2021_power_raw_full_filepath))
stopifnot(fs::file_exists(isf_2021_not_power_raw_full_filepath))

logger::log_info("ISF 2021: Loading ISF 2021 raw data.")

read_xlsx_and_formats <- function(path, ...) {
  cells <- tidyxl::xlsx_cells(path, ...)
  formats <- tidyxl::xlsx_formats(path)
  attr(cells, "formats") <- formats
  cells
}

isf_2021_power_raw <-
  read_xlsx_and_formats(
    path = isf_2021_power_raw_full_filepath,
    sheets = "Sheet2"
  )

isf_2021_not_power_raw <-
  read_xlsx_and_formats(
    path = isf_2021_not_power_raw_full_filepath,
    sheets = "NZAOA_rawdata_notpower"
  )

logger::log_info("ISF 2021: Processing ISF 2021 data.")

isf_2021 <-
  pacta.scenario.data.preparation::prepare_isf_2021_scenario(
    isf_2021_power_raw,
    isf_2021_not_power_raw
  )

if (pacta.data.validation::validate_intermediate_scenario_output(isf_2021)) {
  logger::log_info("ISF 2021: ISF 2021 data is valid.")

  output_path <- fs::path(scenario_preparation_outputs_path, "isf_2021.csv")

  readr::write_csv(
    x = isf_2021,
    file = output_path
  )

  logger::log_info("ISF 2021: ISF 2021 data saved to {output_path}.")

} else {
  logger::log_error("ISF 2021 data is not valid.")
}
