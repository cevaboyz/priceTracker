library(tidyverse)
library(openxlsx)
library(lubridate)
library(rvest)
library(stringr)
library(dplyr)
library(purrr)
library(plyr)
library(polite)
library(xml2)
library(httr)
library(svDialogs)


user.input <- dlgInput("Enter a number", Sys.info()["user"])$res

sitemap <- "https://www.mediaworld.it/sitemaps/sitemap-index.xml"


ua <- "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"

url_media <- dlgInput("Enter a mediaworld URL", Sys.info()["user"])$res


url  <-
    bow(
        url_media,
        user_agent = ua,
        force = TRUE,
        delay = 10,
        times = 10,
        verbose = TRUE
    )

span <-
    scrape(url, content = "text/html; charset=UTF-8") %>% html_nodes("span") %>% html_text2()

span_df <- as.data.frame(span)

span_df <- span_df[span_df[complete.cases(span_df),]]

numeric <- span_df[grep("[[:digit:]]", span_df$span), ]

numeric <- as.data.frame(numeric)

numeric_2 <- as.numeric(sub("(.+= )([0-9\\.]+)(.+)", "\\2", numeric$numeric, perl = T))

numeric_2 <- numeric_2[!is.na(numeric_2)]

numeric_3 <- numeric_2[duplicated(numeric_2)]

promo_price <- as.numeric(min(numeric_3)
                          )
full_price <- as.numeric(max(numeric_3))


product_name_media <- regmatches(url_media,regexpr("_+.*",url_media))

product_name_media_1 <- str_sub(product_name_media,2,-1)

product_name_media_2 <- str_sub(product_name_media_1,1,-6)

product_name_media_3 <- product_name_media_2[grep("([a-z])", product_name_media_2)]

prices <- data.frame(product_name_media_3 ,promo_price, full_price)

prices 

