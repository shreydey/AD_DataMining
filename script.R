# 1. SETUP ----

## set working directory ----
setwd("/Users/shreyadey/Documents/GitHub/Mangobar_Research")

## load libraries ----
library(tidyverse)

# 2. DATA CLEANING ----
## Read in data ----
data <- read_csv("AI.csv")

## Changing variable types ----

## Turning variables into factors
##  Turning variables into numerics
data <- data %>%
  mutate(
    APGEN1 = as.numeric(APGEN1),
    APGEN2 = as.numeric(APGEN2),
    CDGLOBAL = as.numeric(CDGLOBAL),
    AXT117 = as.numeric(AXT117),
    BAT126 = as.numeric(BAT126),
    HMT3 = as.numeric(HMT3),
    HMT7 = as.numeric(HMT7),
    HMT13 = as.numeric(HMT13),
    HMT40 = as.numeric(HMT40),
    HMT100 = as.numeric(HMT100),
    HMT102 = as.numeric(HMT102),
    RCT6 = as.numeric(RCT6),
    RCT11 = as.numeric(RCT11),
    RCT20 = as.numeric(RCT20),
    RCT392 = as.numeric(RCT392),
    MMSCORE = as.numeric(MMSCORE),
    LIMMTOTAL = as.numeric(LIMMTOTAL),
    LDELTOTAL = as.numeric(LDELTOTAL)
  )


# 3. MODELING ----

## Split data ----

## Fit initial Random forest model ----

## Tune model ----

## Fit final model ----

## Evaluate model performance (accuracy) ----

# 4. FIGURES ----

## Variable/Feature importance plot ----

## Boxplot/Distribution of importance features, split by groups of positive/negative patients ----

