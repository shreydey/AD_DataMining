
library(tidyverse)
read_csv(AI)

data <- read_csv(AI)

#Turning variables into factors


#Turning variables into numerics
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
