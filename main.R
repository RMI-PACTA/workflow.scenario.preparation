logger::log_threshold("INFO")
logger::log_formatter(logger::formatter_glue)


# config -----------------------------------------------------------------------

logger::log_info("Loading configuration file.")

config_name <- Sys.getenv("R_CONFIG_ACTIVE")

logger::log_info("Getting config: {config_name}")

config <- config::get(
  file = "config.yml",
  config = config_name,
  use_parent = FALSE
)

logger::log_info("Setting general config.")
scenario_preparation_inputs_path <- config$scenario_preparation_inputs_path
scenario_preparation_outputs_path <- config$scenario_preparation_outputs_path
technology_bridge_filename <- config$technology_bridge_filename

logger::log_info("Setting GECO 2022 config.")
geco_2022_automotive_filename <- config$geco_2022_automotive_filename
geco_2022_aviation_filename <- config$geco_2022_aviation_filename
geco_2022_fossil_fuels_15c_filename <- config$geco_2022_fossil_fuels_15c_filename
geco_2022_fossil_fuels_ndc_filename <- config$geco_2022_fossil_fuels_ndc_filename
geco_2022_fossil_fuels_ref_filename <- config$geco_2022_fossil_fuels_ref_filename
geco_2022_power_15c_filename <- config$geco_2022_power_15c_filename
geco_2022_power_ndc_filename <- config$geco_2022_power_ndc_filename
geco_2022_power_ref_filename <- config$geco_2022_power_ref_filename
geco_2022_steel_filename <- config$geco_2022_steel_filename


# input filepaths --------------------------------------------------------------

# general files
technology_bridge_filepath <- fs::path(
  scenario_preparation_inputs_path,
  technology_bridge_filename
)

# geco 2022 specific files
# Raw data with scenario formula is in:
# Dropbox (RMI)/PACTA Dropbox/Portcheck_v2/00_Data/RawScenarioData/GECO2022
geco2022_raw_path <- fs::path(scenario_preparation_inputs_path, "GECO2022")


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

logger::log_info("Checking that filepaths exist.")
stopifnot(fs::file_exists(technology_bridge_filepath))
stopifnot(fs::file_exists(geco_2022_automotive_filepath))
stopifnot(fs::file_exists(geco_2022_aviation_filepath))
stopifnot(fs::file_exists(geco_2022_fossil_fuels_15c_filepath))
stopifnot(fs::file_exists(geco_2022_fossil_fuels_ndc_filepath))
stopifnot(fs::file_exists(geco_2022_fossil_fuels_ref_filepath))
stopifnot(fs::file_exists(geco_2022_power_15c_filepath))
stopifnot(fs::file_exists(geco_2022_power_ndc_filepath))
stopifnot(fs::file_exists(geco_2022_power_ref_filepath))
stopifnot(fs::file_exists(geco_2022_steel_filepath))

# load data ---------------------------------------------------------------
logger::log_info("Loading data.")
technology_bridge <- readr::read_csv(
  technology_bridge_filepath,
  na = "",
  col_types = readr::cols(
    TechnologyAll = "c",
    TechnologyName = "c"
  )
)

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

# format automotive ------------------------------------------------------------

# TODO: currently still using retirement rates from geco2021
# needs to be revisited, once we get an update
logger::log_info("Formatting GECO 2022 automotive data.")
geco_2022_automotive <- janitor::clean_names(geco_2022_automotive_raw)
geco_2022_automotive <- dplyr::left_join(
  geco_2022_automotive,
  technology_bridge,
  by = c("technology" = "TechnologyAll")
)
geco_2022_automotive <- dplyr::mutate(
  geco_2022_automotive,
  technology = NULL
)
geco_2022_automotive <- dplyr::rename(
  geco_2022_automotive,
  technology = TechnologyName
)

geco_2022_automotive <- tidyr::pivot_longer(
  geco_2022_automotive,
  cols = tidyr::matches("x20[0-9]{2}$"),
  names_to = "year",
  names_prefix = "x",
  names_transform = list(year = as.numeric),
  values_to = "value",
  values_ptypes = numeric()
)

geco_2022_automotive <- dplyr::mutate(
  geco_2022_automotive,
  vehicle = NULL
)

geco_2022_automotive <- dplyr::rename(
  geco_2022_automotive,
  source = "geco",
  scenario_geography = "region",
  units = "unit",
  indicator = "variable"
)

scenario_groups <- c(
  "source",
  "sector",
  "scenario_geography",
  "scenario",
  "indicator",
  "units",
  "technology",
  "year"
)

geco_2022_automotive <- dplyr::summarise(
  geco_2022_automotive,
  value = sum(.data$value, na.rm = TRUE),
  .by = tidyr::all_of(scenario_groups)
)

geco_2022_automotive <- dplyr::mutate(
  geco_2022_automotive,
  sector = ifelse(
    .data$sector == "Light vehicles", "Automotive", "HDV"
  )
)


# format fossil fuels ----------------------------------------------------------
logger::log_info("Formatting GECO 2022 fossil fuels data.")
geco_2022_fossil_fuels <- dplyr::bind_rows(
  geco_2022_fossil_fuels_15c_raw,
  geco_2022_fossil_fuels_ndc_raw,
  geco_2022_fossil_fuels_ref_raw
)

geco_2022_fossil_fuels <- janitor::clean_names(geco_2022_fossil_fuels)

geco_2022_fossil_fuels <- dplyr::rename(
  geco_2022_fossil_fuels,
  source = "geco",
  scenario_geography = "region",
  technology = "fuel",
  units = "unit",
  indicator = "variable"
)

geco_2022_fossil_fuels <- dplyr::mutate(
  geco_2022_fossil_fuels,
  x1 = NULL
)

geco_2022_fossil_fuels <- dplyr::mutate(
  geco_2022_fossil_fuels,
  sector = ifelse(.data$technology == "Coal", "Coal", "Oil&Gas")
)

geco_2022_fossil_fuels <- dplyr::left_join(
  geco_2022_fossil_fuels,
  technology_bridge,
  by = c("technology" = "TechnologyAll")
)

geco_2022_fossil_fuels <- dplyr::mutate(
  geco_2022_fossil_fuels,
  technology = NULL
)

geco_2022_fossil_fuels <- dplyr::rename(
  geco_2022_fossil_fuels,
  technology = "TechnologyName"
)

geco_2022_fossil_fuels <- tidyr::pivot_longer(
  geco_2022_fossil_fuels,
  cols = matches("x20[0-9]{2}$"),
  names_to = "year",
  names_prefix = "x",
  names_transform = list(year = as.numeric),
  values_to = "value",
  values_ptypes = numeric()
)

geco_2022_fossil_fuels <- dplyr::mutate(
  geco_2022_fossil_fuels,
  year = as.double(.data$year)
)


# format power -----------------------------------------------------------------
logger::log_info("Formatting GECO 2022 power data.")
geco_2022_power <- dplyr::bind_rows(
  geco_2022_power_15c_raw,
  geco_2022_power_ndc_raw,
  geco_2022_power_ref_raw
)

geco_2022_power <- dplyr::filter(
  geco_2022_power,
  # actually those technology are already included in Coal/Gas/Biomass and capacities are actually double counted if we don't filter
  !Technology %in% c("Coal with CCUS", "Gas with CCUS", "Biomass & Waste CCUS")
)

geco_2022_power <- janitor::clean_names(geco_2022_power)

geco_2022_power <- dplyr::rename(
  geco_2022_power,
  source = "geco",
  scenario_geography = "region",
  units = "unit",
  indicator = "variable"
)


geco_2022_power <- dplyr::mutate(
  geco_2022_power,
  sector = "Power"
)

geco_2022_power <- dplyr::mutate(
  geco_2022_power,
  technology = dplyr::case_when(
    .data$indicator == "Capacity" & grepl("Coal", .data$technology) ~ "CoalCap",
    .data$indicator == "Capacity" & grepl("Oil", .data$technology) ~ "OilCap",
    .data$indicator == "Capacity" & grepl("Gas", .data$technology) ~ "GasCap",
    .data$technology == "Other" ~ "RenewablesCap",
    TRUE ~ .data$technology
  )
)

geco_2022_power <- dplyr::left_join(geco_2022_power, technology_bridge, by = c("technology" = "TechnologyAll"))
geco_2022_power <- dplyr::mutate(geco_2022_power, technology = NULL)
geco_2022_power <- dplyr::rename(geco_2022_power, technology = "TechnologyName")


geco_2022_power <- tidyr::pivot_longer(
  geco_2022_power,
  cols = tidyr::matches("x20[0-9]{2}$"),
  names_to = "year",
  names_prefix = "x",
  names_transform = list(year = as.numeric),
  values_to = "value",
  values_ptypes = numeric()
)

geco_2022_power <- dplyr::mutate(
  # raw data is off by a magnitude of 1000. Provided capacity values are MW, but
  # unit displays GW. We fix by dividing by 1000 and thus keep ourr standardized
  # unit of GW power capacity
  geco_2022_power,
  value = .data$value / 1000
)


geco_2022_power <- dplyr::mutate(
  geco_2022_power,
  scenario_geography = dplyr::case_when(
    .data$scenario_geography == "United Kingdom" ~ "UK",
    .data$scenario_geography == "Mediterranean Middle-East" ~ "Mediteranean Middle East",
    .data$scenario_geography == "Tunisia, Morocco and Western Sahara" ~ "Morocco & Tunisia",
    .data$scenario_geography == "Algeria and Libya" ~ "Algeria & Libya",
    .data$scenario_geography == "Rest of Central America and Caribbean" ~ "Rest Central America",
    .data$scenario_geography == "Rest of Balkans" ~ "Others Balkans",
    .data$scenario_geography == "Rest of Persian Gulf" ~ "Rest Gulf",
    .data$scenario_geography == "Rest of Pacific" ~ "Rest Pacific",
    .data$scenario_geography == "Rest of Sub-Saharan Africa" ~ "Rest Sub Saharan Africa",
    .data$scenario_geography == "Rest of South America" ~ "Rest South America",
    .data$scenario_geography == "Rest of South Asia" ~ "Rest South Asia",
    .data$scenario_geography == "Rest of South-East Asia" ~ "Rest South East Asia",
    .data$scenario_geography == "Russian Federation" ~ "Russia",
    .data$scenario_geography == "Saudi Arabia" ~ "SaudiArabia",
    .data$scenario_geography == "United States" ~ "US",
    .data$scenario_geography == "South Africa" ~ "SouthAfrica",
    .data$scenario_geography == "European Union" ~ "EU",
    .data$scenario_geography == "Korea (Republic)" ~ "South Korea",
    .data$scenario_geography == "Rest of CIS" ~ "Other CIS",
    TRUE ~ .data$scenario_geography
  )
)

geco_2022_power <- dplyr::filter(
  geco_2022_power,
  .data$scenario_geography != "Switzerland",
  .data$scenario_geography != "Iceland",
  .data$scenario_geography != "Norway"
)

scenario_groups <- c(
  "source",
  "sector",
  "scenario_geography",
  "scenario",
  "indicator",
  "units",
  "technology",
  "year"
)

geco_2022_power <- dplyr::summarise(
  geco_2022_power,
  value = sum(.data$value, na.rm = TRUE),
  .by = tidyr::all_of(scenario_groups)
)


# format steel ------------------------------------------------------------
logger::log_info("Formatting GECO 2022 steel data.")
geco_2022_steel <- janitor::clean_names(geco_2022_steel_raw)

geco_2022_steel <- dplyr::rename(geco_2022_steel, scenario_geography = "region")

geco_2022_steel <- dplyr::mutate(
  geco_2022_steel,
  units = "tCO2/t Steel",
  indicator = "Emission Intensity",
  technology = NA_character_
)

geco_2022_steel <- tidyr::pivot_longer(
  geco_2022_steel,
  cols = tidyr::matches("x[0-9]{4}$"),
  names_to = "year",
  names_prefix = "x",
  names_transform = list(year = as.numeric),
  values_to = "value",
  values_ptypes = numeric()
)

geco_2022_steel <- dplyr::relocate(
  geco_2022_steel,
  c("source", "scenario", "indicator", "sector", "technology", "units", "scenario_geography", "year", "value")
)

geco_2022_steel <- dplyr::mutate(geco_2022_steel, year = as.double(.data$year))

# format aviation ------------------------------------------------------------
logger::log_info("Formatting GECO 2022 aviation data.")
geco_2022_aviation <- janitor::clean_names(geco_2022_aviation_raw)

geco_2022_aviation <- dplyr::rename(
  geco_2022_aviation,
  source = "geco",
  scenario_geography = "region",
  units = "unit",
  indicator = "variable"
)

geco_2022_aviation <- dplyr::mutate(
  geco_2022_aviation,
  passenger_freight = NULL
)


geco_2022_aviation <- dplyr::mutate(
  geco_2022_aviation,
  sector = "Aviation",
  indicator = stringr::str_to_title(.data$indicator)
)

geco_2022_aviation <- tidyr::pivot_longer(
  geco_2022_aviation,
  cols = tidyr::matches("x[0-9]{4}$"),
  names_to = "year",
  names_prefix = "x",
  names_transform = list(year = as.numeric),
  values_to = "value",
  values_ptypes = numeric()
)

geco_2022_aviation <- dplyr::relocate(
  geco_2022_aviation,
  c("source", "scenario", "indicator", "sector", "technology", "units", "scenario_geography", "year", "value")
)

geco_2022_aviation <- dplyr::mutate(
  geco_2022_aviation,
  year = as.double(.data$year)
)


# combine and format ------------------------------------------------------
logger::log_info("Combining and formatting GECO 2022 data.")
geco_2022 <- rbind(
  geco_2022_power,
  geco_2022_automotive,
  geco_2022_fossil_fuels,
  geco_2022_aviation,
  geco_2022_steel
)

geco_2022 <- dplyr::filter(geco_2022, .data$source == "GECO2022")

geco_2022 <- dplyr::mutate(
  geco_2022,
  technology = gsub("oil", "Oil", .data$technology),
  technology = gsub("gas", "Gas", .data$technology),
  technology = gsub("coal", "Coal", .data$technology),
  technology = gsub("cap", "Cap", .data$technology),
  technology = gsub("hybrid", "Hybrid", .data$technology),
  technology = gsub("electric", "Electric", .data$technology),
  technology = gsub("ice", "ICE", .data$technology),
  technology = gsub("fuelcell", "FuelCell", .data$technology),
  technology = gsub("renewables", "Renewables", .data$technology),
  technology = gsub("hydro", "Hydro", .data$technology),
  technology = gsub("nuclear", "Nuclear", .data$technology),
  sector = gsub("oil&gas", "Oil&Gas", .data$sector),
  sector = gsub("coal", "Coal", .data$sector),
  sector = gsub("power", "Power", .data$sector),
  sector = gsub("automotive", "Automotive", .data$sector),
  sector = gsub("heavy-duty vehicles", "HDV", .data$sector)
)

geco_2022 <- dplyr::mutate(
  geco_2022,
  technology = ifelse(
    .data$sector == "hdv", paste0(.data$technology, "_hdv"), .data$technology
  )
)

geco_2022 <- dplyr::mutate(
  geco_2022,
  scenario_geography = dplyr::case_when(
    .data$scenario_geography == "NOAP" ~ "Algeria & Libya",
    .data$scenario_geography == "MEME" ~ "Mediteranean Middle East",
    .data$scenario_geography == "NOAN" ~ "Morocco & Tunisia",
    .data$scenario_geography == "NZL" ~ "New Zealand",
    .data$scenario_geography == "RCIS" ~ "Other CIS",
    .data$scenario_geography == "RCAM" ~ "Rest Central America",
    .data$scenario_geography == "RCEU" ~ "Other Balkan",
    .data$scenario_geography == "RSAM" ~ "Rest South America",
    .data$scenario_geography == "RSAS" ~ "Rest South Asia",
    .data$scenario_geography == "RSEA" ~ "Rest South East Asia",
    .data$scenario_geography == "RSAF" ~ "Rest Sub Saharan Africa",
    .data$scenario_geography == "RGLF" ~ "Rest Gulf",
    .data$scenario_geography == "RPAC" ~ "Rest Pacific",
    .data$scenario_geography == "KOR" ~ "South Korea",
    .data$scenario_geography == "World" ~ "Global",
    .data$scenario_geography == "THA" ~ "Thailand",
    .data$scenario_geography == "EU" ~ "EU27",
    .data$scenario_geography == "NOR" ~ "Norway",
    .data$scenario_geography == "ISL" ~ "Iceland",
    .data$scenario_geography == "CHE" ~ "Switzerland",
    .data$scenario_geography == "TUR" ~ "Turkey",
    .data$scenario_geography == "RUS" ~ "Russia",
    .data$scenario_geography == "USA" ~ "US",
    .data$scenario_geography == "CAN" ~ "Canada",
    .data$scenario_geography == "BRA" ~ "Brazil",
    .data$scenario_geography == "ARG" ~ "Argentina",
    .data$scenario_geography == "CHL" ~ "Chile",
    .data$scenario_geography == "AUS" ~ "Australia",
    .data$scenario_geography == "JPN" ~ "Japan",
    .data$scenario_geography == "CHN" ~ "China",
    .data$scenario_geography == "IND" ~ "India",
    .data$scenario_geography == "SAU" ~ "Saudi Arabia",
    .data$scenario_geography == "IRN" ~ "Iran",
    .data$scenario_geography == "EGY" ~ "Egypt",
    .data$scenario_geography == "ZAF" ~ "South Africa",
    .data$scenario_geography == "MEX" ~ "Mexico",
    .data$scenario_geography == "IDN" ~ "Indonesia",
    .data$scenario_geography == "UKR" ~ "Ukraine",
    .data$scenario_geography == "MYS" ~ "Malaysia",
    .data$scenario_geography == "VNM" ~ "Vietnam",
    .data$scenario_geography == "GBR" ~ "UK",
    TRUE ~ .data$scenario_geography
  )
)


geco_2022 <- dplyr::mutate(
  geco_2022,
  scenario = dplyr::case_when(
    grepl(pattern = "1.5", x = .data$scenario) ~ "1.5C",
    grepl("NDC", .data$scenario) ~ "NDC_LTS",
    grepl("Ref", .data$scenario) ~ "Reference",
    TRUE ~ NA_character_
  )
)

if (any(is.na(unique(geco_2022$scenario)))) {
  logger::log_error("`NA` scenario names are not well-defined. Please review!")
}

geco_2022 <- dplyr::select(
  geco_2022,
  pacta.scenario.data.preparation:::standardized_scenario_columns()
)

if (pacta.data.validation::validate_intermediate_scenario_output(geco_2022)) {
  logger::log_info("GECO 2022 data is valid.")
  readr::write_csv(
    geco_2022,
    fs::path(scenario_preparation_outputs_path, "geco_2022.csv")
  )
} else {
  logger::log_error("GECO 2022 data is not valid.")
}
