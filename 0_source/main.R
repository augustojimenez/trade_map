rm(list = ls())

library(dplyr)

source("./0_source/functions.R")

reporter <- read.csv("./1_data/0_raw/reporterAreas.csv")$id
partner <- read.csv("./1_data/0_raw/partnerAreas.csv")$id
product <- jsonlite::fromJSON("https://comtrade.un.org/Data/cache/classificationHS.json") %>%
      as.data.frame() %>%
      .$results.id

null.df <- data.frame(r = character(),
                      p = character(),
                      cc = character(),
                      year = character())
# Period 2012- 2020
i <- 0
j <- 9
for (r in reporter) {
      for (p in partner) {
            for (cc in product) {
                  for (year in 2012:2020){
                        print(paste("Working on reporter ", r,
                                    ", partner ", p,
                                    ", product ", cc,
                                    ", year ", year))
                        temp <- get.Comtrade(r = r, p = p,
                                             ps = year, cc = cc)$data
                        if (!is.null(temp)){
                              data <- data %>%
                                    rbind(temp)
                        } else {
                              null.temp <- data.frame(r = r, p = p,
                                                      cc = cc, year = year)
                              null.df <- null.df %>%
                                    rbind(null.temp)
                        }
                        i <- i + 1
                        if (i == j) {
                              Sys.sleep(30)
                              i <- 0
                        }
                  }
            }
      }
}
