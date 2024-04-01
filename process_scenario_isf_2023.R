logger::log_info("ISF 2023: Setting ISF 2023 config.")

isf_2023_raw_path <- config[["isf_2023_raw_path"]]
isf_2023_scope_global_raw_filepath <- config[["isf_2023_scope_global_raw_filepath"]]
isf_2023_s_global_raw_filepath <- config[["isf_2023_s_global_raw_filepath"]]
isf_2023_country_annex_path <- config[["isf_2023_country_annex_path"]]

logger::log_info("ISF 2023: Setting ISF 2023 paths.")

isf_2023_raw_full_path <-
  file.path(
    scenario_preparation_inputs_path,
    isf_2023_raw_path
  )

isf_2023_scope_global_raw_full_filepath <-
  file.path(
    isf_2023_raw_full_path,
    isf_2023_scope_global_raw_filepath
  )

isf_2023_s_global_raw_full_filepath <-
  file.path(
    isf_2023_raw_full_path,
    isf_2023_s_global_raw_filepath
  )

isf_2023_country_annex_full_path <-
  file.path(
    isf_2023_raw_full_path,
    isf_2023_country_annex_path
  )

isf_2023_annex_countries_filepaths <-
  list.files(isf_2023_country_annex_full_path, pattern = "[.]xlsx", full.names = TRUE)

logger::log_info("ISF 2023: Checking that ISF 2023 filepaths exist.")

stopifnot(fs::file_exists(isf_2023_scope_global_raw_full_filepath))
stopifnot(fs::file_exists(isf_2023_s_global_raw_full_filepath))
stopifnot(length(isf_2023_annex_countries_filepaths) > 0)

logger::log_info("ISF 2023: Loading ISF 2023 raw data.")

read_xlsx_and_formats <- function(path, ...) {
  cells <- tidyxl::xlsx_cells(path, ...)
  formats <- tidyxl::xlsx_formats(path)
  attr(cells, "formats") <- formats
  cells
}

isf_2023_scope_global_raw <-
  read_xlsx_and_formats(
    path = isf_2023_scope_global_raw_full_filepath,
    sheets = "Scope_Global"
  )

isf_2023_s_global_raw <-
  read_xlsx_and_formats(
    path = isf_2023_s_global_raw_full_filepath,
    sheets = "S_Global"
  )

isf_2023_annex_countries_raw <-
  purrr::map(isf_2023_annex_countries_filepaths, read_xlsx_and_formats)

logger::log_info("ISF 2023: Processing ISF 2023 data.")

isf_2023 <- pacta.scenario.data.preparation::prepare_isf_2023_scenario(
  isf_2023_scope_global_raw,
  isf_2023_s_global_raw,
  isf_2023_annex_countries_raw
)

if (pacta.data.validation::validate_intermediate_scenario_output(isf_2023)) {
  logger::log_info("ISF 2023: ISF 2023 data is valid.")

  output_path <- fs::path(scenario_preparation_outputs_path, "isf_2023.csv")

  readr::write_csv(
    x = isf_2023,
    file = output_path
  )

  logger::log_info("ISF 2023: ISF 2023 data saved to {output_path}.")

} else {
  logger::log_error("ISF 2023 data is not valid.")
}
