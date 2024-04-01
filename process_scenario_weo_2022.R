logger::log_info("WEO 2022: Setting WEO 2022 config.")

weo_2022_raw_path <- config[["weo_2022_raw_path"]]
weo_2022_ext_data_regions_raw_filepath <- config[["weo_2022_ext_data_regions_raw_filepath"]]
weo_2022_ext_data_world_raw_filepath <- config[["weo_2022_ext_data_world_raw_filepath"]]
weo_2022_fossil_fuels_raw_filepath <- config[["weo_2022_fossil_fuels_raw_filepath"]]
weo_2022_nze_auto_raw_filepath <- config[["weo_2022_nze_auto_raw_filepath"]]
weo_2022_nze_steel_raw_filepath <- config[["weo_2022_nze_steel_raw_filepath"]]
weo_2022_sales_aps_auto_raw_filepath <- config[["weo_2022_sales_aps_auto_raw_filepath"]]
weo_2022_electric_sales_aps_auto_raw_filename <- config[["weo_2022_electric_sales_aps_auto_raw_filename"]]

logger::log_info("WEO 2022: Setting WEO 2022 paths.")

weo_2022_raw_full_path <-
  file.path(
    scenario_preparation_inputs_path,
    weo_2022_raw_path
  )

weo_2022_ext_data_regions_raw_full_filepath <-
  file.path(
    weo_2022_raw_full_path,
    weo_2022_ext_data_regions_raw_filepath
  )

weo_2022_ext_data_world_raw_full_filepath <-
  file.path(
    weo_2022_raw_full_path,
    weo_2022_ext_data_world_raw_filepath
  )

weo_2022_fossil_fuels_raw_full_filepath <-
  file.path(
    weo_2022_raw_full_path,
    weo_2022_fossil_fuels_raw_filepath
  )

weo_2022_nze_auto_raw_full_filepath <-
  file.path(
    weo_2022_raw_full_path,
    weo_2022_nze_auto_raw_filepath
  )

weo_2022_nze_steel_raw_full_filepath <-
  file.path(
    weo_2022_raw_full_path,
    weo_2022_nze_steel_raw_filepath
  )

weo_2022_sales_aps_auto_raw_full_filepath <-
  file.path(
    weo_2022_raw_full_path,
    weo_2022_sales_aps_auto_raw_filepath
  )

weo_2022_electric_sales_aps_auto_raw_full_filename <-
  file.path(
    weo_2022_raw_full_path,
    weo_2022_electric_sales_aps_auto_raw_filename
  )

logger::log_info("WEO 2022: Checking that WEO 2022 filepaths exist.")

stopifnot(fs::file_exists(weo_2022_ext_data_regions_raw_full_filepath))
stopifnot(fs::file_exists(weo_2022_ext_data_world_raw_full_filepath))
stopifnot(fs::file_exists(weo_2022_fossil_fuels_raw_full_filepath))
stopifnot(fs::file_exists(weo_2022_nze_auto_raw_full_filepath))
stopifnot(fs::file_exists(weo_2022_nze_steel_raw_full_filepath))
stopifnot(fs::file_exists(weo_2022_sales_aps_auto_raw_full_filepath))
stopifnot(fs::file_exists(weo_2022_electric_sales_aps_auto_raw_full_filename))

logger::log_info("WEO 2022: Loading WEO 2022 raw data.")

read_xlsx_and_formats <- function(path, ...) {
  cells <- tidyxl::xlsx_cells(path, ...)
  formats <- tidyxl::xlsx_formats(path)
  attr(cells, "formats") <- formats
  cells
}

weo_2022_ext_data_regions_raw <-
  readr::read_csv(
    file = weo_2022_ext_data_regions_raw_full_filepath
  )

weo_2022_ext_data_world_raw <-
  readr::read_csv(
    file = weo_2022_ext_data_world_raw_full_filepath
  )

weo_2022_fossil_fuels_raw <-
  readr::read_csv(
    file = weo_2022_fossil_fuels_raw_full_filepath
  )

weo_2022_nze_auto_raw <-
  read_xlsx_and_formats(
    path = weo_2022_nze_auto_raw_full_filepath,
    sheets = ""
  )

weo_2022_nze_steel_raw <-
  readr::read_csv(
    file = weo_2022_nze_steel_raw_full_filepath
  )

weo_2022_sales_aps_auto_raw <-
  readr::read_csv(
    file = weo_2022_sales_aps_auto_raw_full_filepath
  )

weo_2022_electric_sales_aps_auto_raw <-
  readr::read_csv(
    file = weo_2022_electric_sales_aps_auto_raw_full_filename
  )

logger::log_info("WEO 2022: Processing WEO 2022 data.")

weo_2022 <-
  pacta.scenario.data.preparation::prepare_weo_2022_scenario(
    weo_2022_ext_data_regions_raw,
    weo_2022_ext_data_world_raw,
    weo_2022_fossil_fuels_raw,
    weo_2022_nze_auto_raw,
    weo_2022_nze_steel_raw,
    weo_2022_sales_aps_auto_raw,
    weo_2022_electric_sales_aps_auto_raw
  )

if (pacta.data.validation::validate_intermediate_scenario_output(weo_2022)) {
  logger::log_info("WEO 2022: WEO 2022 data is valid.")

  output_path <- fs::path(scenario_preparation_outputs_path, "weo_2022.csv")

  readr::write_csv(
    x = weo_2022,
    file = output_path
  )

  logger::log_info("WEO 2022: WEO 2022 data saved to {output_path}.")

} else {
  logger::log_error("WEO 2022 data is not valid.")
}
