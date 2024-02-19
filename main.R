library(readr)
library(dplyr)
library(pacta.data.validation)
library(stringr)
library(tidyr)
source(here::here("data-raw/utils.R"))
library(dotenv)

# Important - Raw data with scenario formula is in:
# Dropbox (RMI)/PACTA Dropbox/Portcheck_v2/00_Data/RawScenarioData/GECO2022

# define paths ------------------------------------------------------------
dotenv::load_dot_env()

input_path_scenario <- Sys.getenv("DIR_SCENARIO")
geco2022_raw_path <-file.path(input_path_scenario, "GECO2022")


# load data ---------------------------------------------------------------

# GECO only provides retirement and stocks, Antoine had to manually compute the
# sales on excel
#processed data, calculation are made in /Users/antoinelalechere/RMI Dropbox/Antoine Lalechere/PACTA Dropbox/Portcheck_v2/00_Data/RawScenarioData/GECO2022/processed_data/where_calculation_are_made

auto_scenario <- readr::read_csv(
  file.path(geco2022_raw_path, "processed_data/used_in_pacta.scenario.preparation/geco2022_automotive_stocks_geco2021_retirement_rates_CORRECTED.csv"),
  na = "",
  col_types = cols(
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

#processed data, calculation are made in /Users/antoinelalechere/RMI Dropbox/Antoine Lalechere/PACTA Dropbox/Portcheck_v2/00_Data/RawScenarioData/GECO2022/processed_data/where_calculation_are_made

aviation_scenario <- readr::read_csv(
  file.path(geco2022_raw_path, "processed_data/used_in_pacta.scenario.preparation/GECO2022_Aviation_processed_data.csv"),
  na = "",
  col_types = cols(
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

# Raw data has been sent to us by JRC GECO in /Users/antoinelalechere/RMI Dropbox/Antoine Lalechere/PACTA Dropbox/Portcheck_v2/00_Data/RawScenarioData/GECO2022/20230213_PACTA data request_GECO data template_NDC-LTS_data_reg.xlsx
# Next file is a csv formatting of sheet "Fossil Fuel Extraction"

ff_scenario_15c <- readr::read_csv(
  file.path(geco2022_raw_path, "formatted_from_raw_data/used/geco2022_15c_ff_rawdata.csv"),
  na = "",
  col_types = cols(
    GECO = "c",
    Scenario = "c",
    Variable = "c",
    Fuel = "c",
    Unit = "c",
    Region = "c",
    .default = "d"
  )
)


# Raw data has been sent to us by JRC GECO in /Users/antoinelalechere/RMI Dropbox/Antoine Lalechere/PACTA Dropbox/Portcheck_v2/00_Data/RawScenarioData/GECO2022/20230213_PACTA data request_GECO data template_NDC-LTS_data_reg.xlsx
# Next file is a csv formatting of sheet "Fossil Fuel Extraction"

ff_scenario_ndc <- readr::read_csv(
  file.path(geco2022_raw_path, "formatted_from_raw_data/used/geco2022_ndc_ff_rawdata.csv"),
  na = "",
  col_types = cols(
    GECO = "c",
    Scenario = "c",
    Variable = "c",
    Fuel = "c",
    Unit = "c",
    Region = "c",
    .default = "d"
  )
)

# Raw data has been sent to us by JRC GECO in /Users/antoinelalechere/RMI Dropbox/Antoine Lalechere/PACTA Dropbox/Portcheck_v2/00_Data/RawScenarioData/GECO2022/20230213_PACTA data request_GECO data template_ref_data_reg.xlsx
# Next file is a csv formatting of sheet "Fossil Fuel Extraction"

ff_scenario_ref <- readr::read_csv(
  file.path(geco2022_raw_path, "formatted_from_raw_data/used/geco2022_ref_ff_rawdata.csv"),
  na = "",
  col_types = cols(
    GECO = "c",
    Scenario = "c",
    Variable = "c",
    Fuel = "c",
    Unit = "c",
    Region = "c",
    .default = "d"
  )
)

power_scenario_15c <- readr::read_csv(
  file.path(geco2022_raw_path, "formatted_from_raw_data/used/geco2022_15c_power_rawdata_region.csv"),
  na = "",
  col_types = cols(
    GECO = "c",
    Scenario = "c",
    Variable = "c",
    Unit = "c",
    Region = "c",
    Technology = "c",
    .default = "d"
  )
)

# Raw data has been sent to us by JRC GECO in /Users/antoinelalechere/RMI Dropbox/Antoine Lalechere/PACTA Dropbox/Portcheck_v2/00_Data/RawScenarioData/GECO2022/20230213_PACTA data request_GECO data template_NDC-LTS_data_reg.xlsx
# Next file is a csv formatting of sheet "Capacity"

power_scenario_ndc <- readr::read_csv(
  file.path(geco2022_raw_path, "formatted_from_raw_data/used/geco2022_ndc_power_rawdata_region.csv"),
  na = "",
  col_types = cols(
    GECO = "c",
    Scenario = "c",
    Variable = "c",
    Unit = "c",
    Region = "c",
    Technology = "c",
    .default = "d"
  )
)

# Raw data has been sent to us by JRC GECO in /Users/antoinelalechere/RMI Dropbox/Antoine Lalechere/PACTA Dropbox/Portcheck_v2/00_Data/RawScenarioData/GECO2022/20230213_PACTA data request_GECO data template_ref_data_reg.xlsx
# Next file is a csv formatting of sheet "Capacity"

power_scenario_ref <- readr::read_csv(
  file.path(geco2022_raw_path, "formatted_from_raw_data/used/geco2022_ref_power_rawdata_region.csv"),
  na = "",
  col_types = cols(
    GECO = "c",
    Scenario = "c",
    Variable = "c",
    Unit = "c",
    Region = "c",
    Technology = "c",
    .default = "d"
  )
)

# Raw data related to steel come from /Users/antoinelalechere/RMI Dropbox/Antoine Lalechere/PACTA Dropbox/Portcheck_v2/00_Data/RawScenarioData/GECO2022/20230213_PACTA data request_GECO data template_XXX_data_reg.xlsx
# Raw data related to power generation come from /Users/antoinelalechere/RMI Dropbox/Antoine Lalechere/PACTA Dropbox/Portcheck_v2/00_Data/RawScenarioData/GECO2022/GECO2022_20221221_15C.xlsx - line 26 & 110
# Calculation are made in GECO2022_Steel_processed_data.xlsx

steel_scenario <- readr::read_csv(
  file.path(geco2022_raw_path, "processed_data/used_in_pacta.scenario.preparation/GECO2022_Steel_processed_data.csv"),
  na = "",
  col_types = cols(
    Source = "c",
    Sector = "c",
    Scenario = "c",
    Region = "c",
    .default = "d"
  )
)

technology_bridge <- readr::read_csv(
  here::here("data-raw/technology_bridge.csv"),
  na = "",
  col_types = cols(
    TechnologyName = "c",
    TechnologyAll = "c"
  )
)


# format automotive ------------------------------------------------------------

# TODO: currently still using retirement rates from geco2021
# needs to be revisited, once we get an update

auto_scenario_cleaned_names <- janitor::clean_names(auto_scenario)

auto_harmonized_technology_names <- auto_scenario_cleaned_names %>%
  left_join(technology_bridge, by = c("technology" = "TechnologyAll")) %>%
  select(-"technology") %>%
  rename(technology = "TechnologyName")

auto_long <- auto_harmonized_technology_names %>%
  pivot_longer(
    cols = matches("x20[0-9]{2}$"),
    names_to = "year",
    names_prefix = "x",
    names_transform = list(year = as.numeric),
    values_to = "value",
    values_ptypes = numeric()
  )

auto_harmonized_values <- auto_long %>%
  select(-"vehicle")

auto_harmonized_names <- auto_harmonized_values %>%
  rename(
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

auto_aggregated <- auto_harmonized_names %>%
  summarise(
    value = sum(.data$value, na.rm = TRUE),
    .by = all_of(scenario_groups)
  )

geco2022_auto <- auto_aggregated %>%
  mutate(
    sector = ifelse(
      .data$sector == "Light vehicles", "Automotive", "HDV"
    )
  )


# format fossil fuels ----------------------------------------------------------

ff_scenario <- ff_scenario_15c %>%
  bind_rows(ff_scenario_ndc) %>%
  bind_rows(ff_scenario_ref)

ff_scenario_cleaned_names <- janitor::clean_names(ff_scenario)

ff_harmonized_names <- ff_scenario_cleaned_names %>%
  rename(
    source = "geco",
    scenario_geography = "region",
    technology = "fuel",
    units = "unit",
    indicator = "variable"
  ) %>%
  select(-"x1")

ff_with_sector <- ff_harmonized_names %>%
  mutate(
    sector = ifelse(.data$technology == "Coal", "Coal", "Oil&Gas")
  )

ff_harmonized_technology_names <- ff_with_sector %>%
  left_join(technology_bridge, by = c("technology" = "TechnologyAll")) %>%
  select(-"technology") %>%
  rename(technology = "TechnologyName")

ff_long <- ff_harmonized_technology_names %>%
  pivot_longer(
    cols = matches("x20[0-9]{2}$"),
    names_to = "year",
    names_prefix = "x",
    names_transform = list(year = as.numeric),
    values_to = "value",
    values_ptypes = numeric()
  )

geco2022_ff <- ff_long %>%
  mutate(year = as.double(.data$year))


# format power -----------------------------------------------------------------

power_scenario <- power_scenario_15c %>%
  bind_rows(power_scenario_ndc) %>%
  bind_rows(power_scenario_ref) %>%
  filter(!Technology %in% c("Coal with CCUS", "Gas with CCUS", "Biomass & Waste CCUS")) # actually those technology are already included in Coal/Gas/Biomass and capacities are actually double counted if we don't filter

power_scenario_cleaned_names <- janitor::clean_names(power_scenario)

power_harmonized_names <- power_scenario_cleaned_names %>%
  rename(
    source = "geco",
    scenario_geography = "region",
    units = "unit",
    indicator = "variable"
  )

power_with_sector <- power_harmonized_names %>%
  mutate(
    sector = "Power"
  )

power_harmonized_technology_names <- power_with_sector %>%
  mutate(
    technology = case_when(
      .data$indicator == "Capacity" & grepl("Coal", .data$technology) ~ "CoalCap",
      .data$indicator == "Capacity" & grepl("Oil", .data$technology) ~ "OilCap",
      .data$indicator == "Capacity" & grepl("Gas", .data$technology) ~ "GasCap",
      .data$technology == "Other" ~ "RenewablesCap",
      TRUE ~ .data$technology
    )
  ) %>%
  left_join(technology_bridge, by = c("technology" = "TechnologyAll")) %>%
  select(-"technology") %>%
  rename(technology = "TechnologyName")

power_long <- power_harmonized_technology_names %>%
  pivot_longer(
    cols = matches("x20[0-9]{2}$"),
    names_to = "year",
    names_prefix = "x",
    names_transform = list(year = as.numeric),
    values_to = "value",
    values_ptypes = numeric()
  ) %>%
  # raw data is off by a magnitude of 1000. Provided capacity values are MW, but
  # unit displays GW. We fix by dividing by 1000 and thus keep ourr standardized
  # unit of GW power capacity
  dplyr::mutate(
    value = .data$value / 1000
  )

power_relevant_regions <- power_long %>%
  mutate(
    scenario_geography = case_when(
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
  ) %>%
  filter(
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

power_geco_aggregated <- power_long %>%
  summarise(
    value = sum(.data$value, na.rm = TRUE),
    .by = all_of(scenario_groups)
  )

geco2022_power <- power_geco_aggregated


# format steel ------------------------------------------------------------

steel_scenario_cleaned_names <- janitor::clean_names(steel_scenario)

steel_scenario_harmonized_names <- steel_scenario_cleaned_names %>%
  rename(scenario_geography = "region")

steel_scenario_complete_variables <- steel_scenario_harmonized_names %>%
  mutate(
    units = "tCO2/t Steel",
    indicator = "Emission Intensity",
    technology = NA_character_
  )

steel_long <- steel_scenario_complete_variables %>%
  pivot_longer(
    cols = matches("x[0-9]{4}$"),
    names_to = "year",
    names_prefix = "x",
    names_transform = list(year = as.numeric),
    values_to = "value",
    values_ptypes = numeric()
  )

geco2022_steel <- steel_long %>%
  relocate(c("source", "scenario", "indicator", "sector", "technology", "units", "scenario_geography", "year", "value")) %>%
  mutate(year = as.double(.data$year))

# format aviation ------------------------------------------------------------

aviation_scenario_cleaned_names <- janitor::clean_names(aviation_scenario)

aviation_scenario_harmonized_names <- aviation_scenario_cleaned_names %>%
  rename(
    source = "geco",
    scenario_geography = "region",
    units = "unit",
    indicator = "variable"
  ) %>%
  select(-"passenger_freight") %>%
  mutate(
    sector = "Aviation",
    indicator = stringr::str_to_title(.data$indicator)
  )

aviation_long <- aviation_scenario_harmonized_names %>%
  pivot_longer(
    cols = matches("x[0-9]{4}$"),
    names_to = "year",
    names_prefix = "x",
    names_transform = list(year = as.numeric),
    values_to = "value",
    values_ptypes = numeric()
  )

geco2022_aviation <- aviation_long %>%
  relocate(
    c("source", "scenario", "indicator", "sector", "technology", "units", "scenario_geography", "year", "value")
  ) %>%
  mutate(year = as.double(.data$year))


# combine and format ------------------------------------------------------

geco_total <- rbind(
  geco2022_power,
  geco2022_auto,
  geco2022_ff,
  geco2022_aviation,
  geco2022_steel
)

geco_2022_formatted_technologies <- geco_total %>%
  mutate(
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
  ) %>%
  mutate(
    technology = ifelse(
      .data$sector == "hdv", paste0(.data$technology, "_hdv"), .data$technology
    )
  )

geco_2022_harmonized_geographies <- geco_2022_formatted_technologies %>%
  mutate(
    scenario_geography = case_when(
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
  ) %>%
  ungroup() %>%
  filter(.data$source == "GECO2022")

geco_2022_harmonized_scenario_names <- geco_2022_harmonized_geographies %>%
  mutate(
    scenario = case_when(
      grepl("1.5", .data$scenario) ~ "1.5C",
      grepl("NDC", .data$scenario) ~ "NDC_LTS",
      grepl("Ref", .data$scenario) ~ "Reference",
      TRUE ~ NA_character_
    )
  )

if (any(is.na(unique(geco_2022_harmonized_scenario_names$scenario)))) {
  stop("Unique scenario names are not well-defined. Please review!")
}

geco_2022 <- select(
  geco_2022_harmonized_scenario_names,
  standardized_scenario_columns()
)

if (validate_intermediate_scenario_output(geco_2022)) {
  usethis::use_data(
    geco_2022,
    overwrite = TRUE
  )
}
