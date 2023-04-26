library(tidyverse)
library(rnoaa)

fxn_fetch_daily_stations <- function(
    .site_latitude,
    .site_longitude,
    .distance_radius_mi = 20) {
  ## get a list of stations in the US. This takes A WHILE to run.
  station_data <- ghcnd_stations()

  ## then get list of stations nearby your selected site coordinates.
  nearby_stations <- meteo_nearby_stations(
    lat_lon_df =
      tribble(
        ~id, ~latitude, ~longitude,
        "site", .site_latitude, .site_longitude
      ),
    station_data = station_data,
    limit = 15,
    var = c("TMAX", "TMIN", "TAVG", "TOBS"),
    year_min = 1985,
    year_max = as.numeric(format(Sys.Date(), "%Y")) - 1,
    radius = .distance_radius_mi * 1.60934
  )

  # pull the daily weather data from nearest stations. This takes a few minutes
  nearest_weather <- meteo_pull_monitors(
    monitors = nearby_stations$site$id,
    var = c("TMAX", "TMIN", "TAVG"),
    date_min = NULL,
    date_max = paste0(as.numeric(format(Sys.Date(), "%Y")) - 1, "-12-31")
  )

  nearest_weather["tavg"[!("tavg" %in% colnames(nearest_weather))]] = NA_real_

  daily_temps <- inner_join(nearby_stations$site, nearest_weather) %>%
    mutate( # prcp = prcp / 10 / 25.4, #inches
      tavg = (tavg / 10 * 9 / 5) + 32, # farenheight
      tmin = (tmin / 10 * 9 / 5) + 32,
      tmax = (tmax / 10 * 9 / 5) + 32
    ) %>%
    mutate(
      year = as.numeric(format(date, "%Y")),
      tavg = if_else(is.na(tavg), (tmax + tmin) / 2, tavg)
    )

  return(daily_temps)
}



fxn_process_daily <- function(.df = x,
                              .temp_extreme_cold = NULL,
                              .temp_extreme_hot = NULL,
                              .temp_middle = NULL) {
  daily_averages <- .df %>%
    filter(year >= min_year) %>%
    group_by(date) %>%
    summarise(
      tmax = mean(tmax, na.rm = T),
      tmin = mean(tmin, na.rm = T),
      tavg = mean(tavg, na.rm = T)
    ) %>%
    mutate(
      year = as.numeric(format(date, "%Y")),
      doy = lubridate::yday(date)
    ) %>%
    select(year, doy, tmax, tmin, tavg) %>%
    mutate(tavg = (tmax + tmin) / 2) %>%
    full_join(expand(., year, doy)) %>%
    arrange(year, doy) %>%
    mutate(flag = if_else(is.na(tavg) & doy > 364, 1, 2)) %>%
    fill(tavg, .direction = c("up")) %>%
    filter(!is.na(tavg))

  if (is.null(.temp_extreme_cold)) {
    .temp_extreme_cold <- floor(quantile(daily_averages$tavg, .03))
  }

  if (is.null(.temp_extreme_hot)) {
    .temp_extreme_hot <- ceiling(quantile(daily_averages$tavg, .97))
  }

  if (is.null(.temp_middle)) {
    .temp_middle <- round(quantile(daily_averages$tavg, .5), 0)
  }

  assign_color_thresholds <- daily_averages %>%
    mutate(temp_category = case_when(
      tavg <= .temp_extreme_cold ~ "extreme cold",
      tavg < .temp_middle ~ "cold",
      tavg < .temp_extreme_hot ~ "hot",
      tavg >= .temp_extreme_hot ~ "extreme hot"
    ))

  assign_color_thresholds$temp_category <- factor(assign_color_thresholds$temp_category,
    levels = c(
      "extreme cold",
      "cold",
      "hot",
      "extreme hot"
    )
  )

  assign_colors <- assign_color_thresholds %>%
    ungroup() %>%
    arrange(temp_category, tavg) %>% # 30692
    add_column(color = c(
      colorRampPalette(RColorBrewer::brewer.pal(9, "Blues")[9]) # 2 steps darker makes the extremes stand out
      (nrow(filter(assign_color_thresholds, temp_category == "extreme cold"))),
      colorRampPalette(RColorBrewer::brewer.pal(9, "Blues")[7:2])
      (nrow(filter(assign_color_thresholds, temp_category == "cold"))),
      colorRampPalette(RColorBrewer::brewer.pal(9, "Reds")[1:7])
      (nrow(filter(assign_color_thresholds, temp_category == "hot"))),
      colorRampPalette(RColorBrewer::brewer.pal(9, "Reds")[9]) # 2 steps darker makes the extremes stand out
      (nrow(filter(assign_color_thresholds, temp_category == "extreme hot")))
    ))

  return(assign_colors)
}

fxn_plot_daily <- function(.df = x,
                           .add_points = FALSE) {
  daily_plot <- .df %>%
    ggplot(aes(y = doy, x = year)) +
    geom_tile(fill = .df$color) +
    geom_point(data = if(isFALSE(.add_points)) {NULL} else {.add_points},
               size = if(isFALSE(.add_points)) {0} else {.5},
               stroke = if(isFALSE(.add_points)) {0} else {.3},
               color = "grey25") +
    theme_void() +
    annotate("text",
      x = (2023 - min_year) / 2 + min_year,
      y = 15, label = "bold(January)",
      family = "amatic-sc", color = "white", parse = T,
      size = 20
    ) +
    annotate("text",
      x = (2023 - min_year) / 2 + min_year,
      y = 196, label = "bold(July)", parse = T,
      family = "amatic-sc", color = "white",
      size = 20
    ) +
    annotate("text",
      x = (2023 - min_year) / 2 + min_year,
      y = 349, label = "bold(December)",
      family = "amatic-sc", color = "white",
      parse = T,
      size = 20
    ) +
    theme(
      axis.title = element_blank(),
      text = element_text(family = "amatic-sc", color = "white", face = "bold"),
      axis.text = element_text(size = 30, color = "white"),
      axis.text.y = element_blank(),
      axis.text.x = element_blank()
    ) +
    scale_y_reverse(
      expand = c(0, 0),
      breaks = c(60, 182, 305),
      labels = c("Mar 1", "Jul 1", "Nov 1")
    ) +
    scale_x_continuous(expand = c(0, 0))
  return(daily_plot)
}
