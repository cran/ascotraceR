## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(fig.width = 7, fig.height = 7)

## ---- load-libs, message=FALSE------------------------------------------------
library("ascotraceR")
library("lubridate")
library("ggplot2")
library("data.table")

## ----load-weather-------------------------------------------------------------
# weather data
Billa_Billa <- fread(
  system.file(
    "extdata",
    "2020_Billa_Billa_weather_data_ozforecast.csv",
    package = "ascotraceR"
  )
)

# format time column
Billa_Billa[, local_time := dmy_hm(local_time)]

# specify the station coordinates of the Billa Billa weather station
Billa_Billa[, c("lat", "lon") := .(-28.1011505, 150.3307084)]

head(Billa_Billa)

## ----format-weather-----------------------------------------------------------
Billa_Billa <- format_weather(
  x = Billa_Billa,
  POSIXct_time = "local_time",
  temp = "mean_daily_temp",
  ws = "ws",
  wd_sd = "wd_sd",
  rain = "rain_mm",
  wd = "wd",
  station = "location",
  time_zone = "Australia/Brisbane",
  lon = "lon",
  lat = "lat"
)

## ----trace-asco---------------------------------------------------------------
# Predict Ascochyta blight spread for the year 2020 at Billa Billa
traced <- trace_asco(
  weather = Billa_Billa,
  paddock_length = 20,
  paddock_width = 20,
  initial_infection = "2020-07-17",
  sowing_date = "2020-06-04",
  harvest_date = "2020-10-27",
  time_zone = "Australia/Brisbane",
  seeding_rate = 40,
  gp_rr = 0.0065,
  spores_per_gp_per_wet_hour = 0.6,
  latent_period_cdd = 150,
  primary_inoculum_intensity = 100,
  primary_infection_foci = "centre"
)

## ----tidy---------------------------------------------------------------------
tidied <- tidy_trace(traced)
tidied

## ----summarise----------------------------------------------------------------
summarised <- summarise_trace(traced)
summarised

## ----plot---------------------------------------------------------------------
ggplot(data = subset(tidied, i_day == 132),
       aes(x = x, y = y, fill = infectious_gp)) +
  geom_tile()

