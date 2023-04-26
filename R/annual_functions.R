library(tidyverse)

fxn_process_annual <- function(.annual_df,
                           .extreme_cold_anomaly = NULL,
                           .extreme_heat_anomaly = NULL){

   raw_annual <- read_csv(file.path(here::here(), "data-raw", .annual_df),
                         skip = 3) %>%
    filter(Value != -99) %>%
     rename(temp = Value) %>%
    mutate(Date = as.numeric(substr(Date, start = 1, stop = 4))) %>%

     #filter the data before beautifying
     filter(Date >= min_year) %>%
     mutate(longterm_avg = mean(temp),
            temp_anomaly = temp - longterm_avg)


   if(is.null(.extreme_cold_anomaly)){
     .extreme_cold_anomaly <- quantile(raw_annual$temp_anomaly, .05)
   }

   if(is.null(.extreme_heat_anomaly)){
     .extreme_heat_anomaly <- quantile(raw_annual$temp_anomaly, .95)
   }

   annual_temp_categories <- raw_annual %>%
     mutate(temp_category = case_when(temp_anomaly < .extreme_cold_anomaly ~ "extreme cold",
                                      temp_anomaly <= 0 ~ "cold",
                                      temp_anomaly < .extreme_heat_anomaly ~ "hot",
                                      temp_anomaly >= .extreme_heat_anomaly ~ "extreme hot"))

   annual_temp_categories$temp_category <- factor(annual_temp_categories$temp_category,
                                                  levels = c("extreme cold",
                                                             "cold",
                                                             "hot",
                                                             "extreme hot"))


   annual_colors <- annual_temp_categories %>%
     ungroup() %>%
    arrange(temp_category, temp_anomaly) %>%
    mutate(color = c(colorRampPalette(RColorBrewer::brewer.pal(9,"Blues")[8])# while the daily plots use [9] for extreme, the annual plot needs a bit brighter data to stand out against the background
                    (nrow(filter(annual_temp_categories, temp_category == "extreme cold"))),

                    colorRampPalette(RColorBrewer::brewer.pal(9,"Blues")[7:2])
                    (nrow(filter(annual_temp_categories, temp_category == "cold"))),

                    colorRampPalette(RColorBrewer::brewer.pal(9,"Reds")[1:7])
                    (nrow(filter(annual_temp_categories, temp_category == "hot"))),

                    colorRampPalette(RColorBrewer::brewer.pal(9,"Reds")[8]) # while the daily plots use [9] for extreme, the annual plot needs a bit brighter data to stand out against the background
                    (nrow(filter(annual_temp_categories, temp_category == "extreme hot")))
    ))

   return(annual_colors)
}

fxn_plot_annual <- function(.df = x,
                        .label_remove = NULL){

  date_label_raw <- .df %>%
      filter(temp_category %in% c("extreme cold", "extreme hot")) %>%
      .$Date

  date_label <- if(is.null(.label_remove)) {
    date_label_raw
  } else {
    date_label_raw[!date_label_raw %in% .label_remove]
  }

  annual_plot <- .df %>%
    mutate(
      label = if_else(Date %in% date_label, Date, NA_real_),
      nudge = if_else(temp_category == "extreme cold", -1, 1)
    )  %>%
    ggplot(aes(x = Date, y = temp_anomaly, fill = color,
               label = label)) +
    geom_bar(stat = "identity") +
    scale_fill_identity() +
  geom_text(aes(y = temp_anomaly + nudge),
              size = 12,
              family = "amatic-sc",
              color = "white",
              fontface = "bold")+
    theme_minimal()  +
    theme(axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          panel.grid = element_blank(),
          axis.text.y = element_blank(),
          axis.text.x = element_blank(),
          # axis.text.x = element_text(size = 30, color = "black", face = "bold"),
          legend.position = "none",
          text = element_text(family="amatic-sc", color = "white"),
          plot.background = element_rect(fill = "grey25", color = "grey25")) +
    scale_x_continuous(expand = c(0,0),
                       n.breaks = 13,
                       breaks = c(seq(1910, 2020, 10)),
                       labels = c(seq(1910, 2020, 10))) +
    scale_y_continuous(expand = c(.1,.1))

   return(annual_plot)

}

