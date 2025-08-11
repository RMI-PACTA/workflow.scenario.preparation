logger::log_info("WEO 2024: Setting WEO 2024 config.")

weo_2024_raw_path <- config[["weo_2024_raw_path"]]
weo_2024_ext_data_regions_raw_filename <- config[["weo_2024_ext_data_regions_raw_filename"]]
weo_2024_ext_data_world_raw_filename <- config[["weo_2024_ext_data_world_raw_filename"]]
iea_global_ev_2024_raw_filename <- config[["iea_global_ev_raw_filename"]]
weo_2024_fig_chptr_3_raw_full_filename <- config[["weo_2024_fig_chptr_3_raw_full_filename"]]
mpp_ats_raw_path <- config[["mpp_ats_raw_path"]]
mpp_ats_raw_filename <- config[["mpp_ats_raw_filename"]]

logger::log_info("WEO 2024: Setting WEO 2024 paths.")

weo_2024_raw_full_path <-
  file.path(
    scenario_preparation_inputs_path,
    weo_2024_raw_path
  )

weo_2024_ext_data_regions_raw_full_filepath <-
  file.path(
    weo_2024_raw_full_path,
    weo_2024_ext_data_regions_raw_filename
  )

weo_2024_ext_data_world_raw_full_filepath <-
  file.path(
    weo_2024_raw_full_path,
    weo_2024_ext_data_world_raw_filename
  )

iea_global_ev_2024_raw_full_filepath <-
  file.path(
    weo_2024_raw_full_path,
    iea_global_ev_2024_raw_filename
  )

weo_2024_fig_chptr_3_raw_full_filepath <-
  file.path(
    weo_2024_raw_full_path,
    weo_2024_fig_chptr_3_raw_full_filename
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

logger::log_info("WEO 2024: Checking that WEO 2024 filepaths exist.")

stopifnot(fs::file_exists(weo_2024_ext_data_regions_raw_full_filepath))
stopifnot(fs::file_exists(weo_2024_ext_data_world_raw_full_filepath))
stopifnot(fs::file_exists(weo_2024_fig_chptr_3_raw_full_filepath))
stopifnot(fs::file_exists(iea_global_ev_2024_raw_full_filepath))
stopifnot(fs::file_exists(mpp_ats_raw_full_filepath))

logger::log_info("WEO 2024: Loading WEO 2024 raw data.")

weo_2024_ext_data_regions_raw <-
  readr::read_csv(
    file = weo_2024_ext_data_regions_raw_full_filepath,
    show_col_types = FALSE
  )

weo_2024_ext_data_world_raw <-
  readr::read_csv(
    file = weo_2024_ext_data_world_raw_full_filepath,
    show_col_types = FALSE
  )

weo_2024_fig_chptr_3_raw <-
  tidyxl::xlsx_cells(
    path = weo_2024_fig_chptr_3_raw_full_filepath
  )

iea_global_ev_2024_raw <-
  read_xlsx(
    path = iea_global_ev_2024_raw_full_filepath,
    sheet = "electric-vehicle-sales-by-regio"
  )

iea_sales_share_ev <- read_xlsx(
  path = iea_global_ev_2024_raw_full_filepath,
  sheet = "electric vehicle share-ev"
)

iea_sales_share_bev_phev <- read_xlsx(
  path = iea_global_ev_2024_raw_full_filepath,
  sheet = "electric-vehicle-share-bev-phev"
)

mpp_ats_raw <-
  tidyxl::xlsx_cells(
    path = mpp_ats_raw_full_filepath
  )

logger::log_info("WEO 2024: Processing WEO 2024 data.")

weo_2024 <-
  prepare_weo_2024_scenario(
    weo_2024_ext_data_regions_raw,
    weo_2024_ext_data_world_raw,
    weo_2024_fig_chptr_3_raw,
    iea_global_ev_2024_raw,
    iea_sales_share_ev,
    iea_sales_share_bev_phev,
    hybrid_methodology,
    mpp_ats_raw
  )

if (pacta.data.validation::validate_intermediate_scenario_output(weo_2024)) {
  logger::log_info("WEO 2024: WEO 2024 data is valid.")

  output_path <- fs::path(scenario_preparation_outputs_path, "weo_2024.csv")

  readr::write_csv(
    x = weo_2024,
    file = output_path
  )

  logger::log_info("WEO 2024: WEO 2024 data saved to {output_path}.")

} else {
  logger::log_error("WEO 2024 data is not valid.")
  stop()
}
