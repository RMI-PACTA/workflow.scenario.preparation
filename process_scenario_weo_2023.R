logger::log_info("WEO 2023: Setting WEO 2023 config.")

weo_2023_raw_path <- config[["weo_2023_raw_path"]]
weo_2023_ext_data_regions_raw_filename <- config[["weo_2023_ext_data_regions_raw_filename"]]
weo_2023_ext_data_world_raw_filename <- config[["weo_2023_ext_data_world_raw_filename"]]
weo_2023_fig_chptr_3_raw_filename <- config[["weo_2023_fig_chptr_3_raw_filename"]]
iea_global_ev_raw_path <- config[["iea_global_ev_raw_path"]]
iea_global_ev_raw_filename <- config[["iea_global_ev_raw_filename"]]
mpp_ats_raw_path <- config[["mpp_ats_raw_path"]]
mpp_ats_raw_filename <- config[["mpp_ats_raw_filename"]]

logger::log_info("WEO 2023: Setting WEO 2023 paths.")

weo_2023_raw_full_path <-
  file.path(
    scenario_preparation_inputs_path,
    weo_2023_raw_path
  )

weo_2023_ext_data_regions_raw_full_filepath <-
  file.path(
    weo_2023_raw_full_path,
    weo_2023_ext_data_regions_raw_filename
  )

weo_2023_ext_data_world_raw_full_filepath <-
  file.path(
    weo_2023_raw_full_path,
    weo_2023_ext_data_world_raw_filename
  )

weo_2023_fig_chptr_3_raw_full_filepath <-
  file.path(
    weo_2023_raw_full_path,
    weo_2023_fig_chptr_3_raw_filename
  )

iea_global_ev_raw_full_path <-
  file.path(
    scenario_preparation_inputs_path,
    iea_global_ev_raw_path
  )

iea_global_ev_raw_full_filepath <-
  file.path(
    iea_global_ev_raw_full_path,
    iea_global_ev_raw_filename
  )

mpp_ats_raw_full_path <-
  file.path(
    scenario_preparation_inputs_path,
    mpp_ats_raw_path
  )

mpp_ats_raw_full_filepath <-
  file.path(
    mpp_ats_raw_full_path,
    mpp_ats_raw_filename
  )

logger::log_info("WEO 2023: Checking that WEO 2023 filepaths exist.")

stopifnot(fs::file_exists(weo_2023_ext_data_regions_raw_full_filepath))
stopifnot(fs::file_exists(weo_2023_ext_data_world_raw_full_filepath))
stopifnot(fs::file_exists(weo_2023_fig_chptr_3_raw_full_filepath))
stopifnot(fs::file_exists(iea_global_ev_raw_full_filepath))
stopifnot(fs::file_exists(mpp_ats_raw_full_filepath))

logger::log_info("WEO 2023: Loading WEO 2023 raw data.")

read_xlsx_and_formats <- function(path, ...) {
  cells <- tidyxl::xlsx_cells(path, ...)
  formats <- tidyxl::xlsx_formats(path)
  attr(cells, "formats") <- formats
  cells
}

weo_2023_ext_data_regions_raw <-
  readr::read_csv(
    file = weo_2023_ext_data_regions_raw_full_filepath,
    show_col_types = FALSE
  )

weo_2023_ext_data_world_raw <-
  readr::read_csv(
    file = weo_2023_ext_data_world_raw_full_filepath,
    show_col_types = FALSE
  )

weo_2023_fig_chptr_3_raw <-
  read_xlsx_and_formats(
    path = weo_2023_fig_chptr_3_raw_full_filepath
  )

iea_global_ev_raw <-
  readr::read_csv(
    file = iea_global_ev_raw_full_filepath,
    show_col_types = FALSE
  )

mpp_ats_raw <-
  read_xlsx_and_formats(
    path = mpp_ats_raw_full_filepath
  )

logger::log_info("WEO 2023: Processing WEO 2023 data.")

weo_2023 <-
  pacta.scenario.data.preparation::prepare_weo_2023_scenario(
    weo_2023_ext_data_regions_raw,
    weo_2023_ext_data_world_raw,
    weo_2023_fig_chptr_3_raw,
    iea_global_ev_raw,
    mpp_ats_raw
  )

if (pacta.data.validation::validate_intermediate_scenario_output(weo_2023)) {
  logger::log_info("WEO 2023: WEO 2023 data is valid.")

  output_path <- fs::path(scenario_preparation_outputs_path, "weo_2023.csv")

  readr::write_csv(
    x = weo_2023,
    file = output_path
  )

  logger::log_info("WEO 2023: WEO 2023 data saved to {output_path}.")

} else {
  logger::log_error("WEO 2023 data is not valid.")
}
