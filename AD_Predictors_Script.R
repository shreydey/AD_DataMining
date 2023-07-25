# 1. SETUP ----

## set working directory ----
setwd("/Users/shreyadey/Documents/GitHub/Mangobar_Research")

## load libraries ----
library(tidyverse)
library(caret)
library(ggplot2)

# 2. DATA CLEANING ----
## Read in data ----
data <- read_csv("AI.csv")

## Changing variable types ----

## Turning variables into factors
data <- data %>%
  mutate(
    MHPSYCH = as.factor(MHPSYCH),
    MH2NEURL = as.factor(MH2NEURL),
    MH4CARD = as.factor(MH4CARD),
    MH6HEPAT = as.factor(MH6HEPAT),
    MH8MUSCL = as.factor(MH8MUSCL),
    MH9ENDO = as.factor(MH9ENDO),
    MH10GAST = as.factor(MH10GAST),
    MH12RENA = as.factor(MH12RENA),
    MH16SMOK = as.factor(MH16SMOK),
    MH17MALI = as.factor(MH17MALI),
    DXCURREN = as.factor(DXCURREN),
    DXNORM = as.factor(DXNORM),
    DXMCI = as.factor(DXMCI),
    DXAD = as.factor(DXAD)
  )

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
    LDELTOTAL = as.numeric(LDELTOTAL),
    age = as.numeric(Examyear-PTDOBYear)
  )


# 3. MODELING ----

## Split data ----

set.seed(1234)

data$id <- 1:nrow(data)
train <- data %>% dplyr::sample_frac(0.80)
test  <- dplyr::anti_join(data, train, by = 'id')

# Train_x and test_x
train_x <- train %>% select(-c("DXAD","DXNORM", "DXMCI", "id", "MH17MALI","BAT126","RCT6","MH9ENDO","HMT13","HMT7","MH6HEPAT", "APGEN2", "PTDOBYear","RCT11","MHPSYCH","MH10GAST","MH2NEURL", "Examyear", "APTyear", "age"))
test_x <- test %>% select(-c("DXAD","DXNORM", "DXMCI", "id", "MH17MALI","BAT126","RCT6","MH9ENDO","HMT13","HMT7","MH6HEPAT", "APGEN2", "PTDOBYear","RCT11","MHPSYCH","MH10GAST", "MH2NEURL", "Examyear","APTyear", "age"))

# Train_y and test_y
train_y <- train %>% select(c("DXAD"))
test_y <- test %>% select(c("DXAD"))

#Convert to a vector
train_y <- unlist(train_y)
test_y <- unlist(test_y)

## Fit initial Random forest model ----

# load the randomForest library
library(randomForest)

rf_model <- randomForest(
  x = train_x,
  y = train_y,
  xtest = test_x,
  ytest = test_y,
  importance = TRUE,
  ntree = 600
)
## Tune model ----

mtry <- tuneRF(
  x = train_x,
  y = train_y,
  xtest = test_x,
  ytest = test_y,
  ntreeTry = 600,
  stepFactor = 1.5,
  improve = 0.01,
  trace = TRUE,
  plot = TRUE
)

# The code below will save the best value for the mtry and print it out
best.m <- mtry[mtry[, 2] == min(mtry[, 2]), 1]
print(mtry)
print(best.m)


## Fit final model ----
rf_final_model <-
  randomForest(
    x = train_x,
    y = train_y,
    mtry = 6,
    importance = TRUE,
    ntree = 5000
  )

# Show final accuracy and save model
rf_final_model
saveRDS(rf_final_model, file = "rf_model.rds")

## Evaluate model performance (accuracy) ----

# 4. PLOTTING ----
rf_features <- as.data.frame(varImp(rf_final_model))
## Rename the column name to rf_imp
colnames(rf_features) <- "rf_imp"

## convert rownames to column
rf_features$feature <- rownames(rf_features)

## Selecting only relevant columns for mapping
features <- rf_features %>% dplyr::select(c(feature, rf_imp))
## Determining and Plotting Best Features ----
rf_features <- as.data.frame(varImp(rf_final_model))
## Rename the column name to rf_imp
colnames(rf_features) <- "rf_imp"

## convert row names to column
rf_features$feature <- rownames(rf_features)

## Selecting only relevant columns for mapping
features <- rf_features %>% dplyr::select(c(feature, rf_imp))

### Plot the feature importance
plot <- features %>%
  ggplot(aes(x =  rf_imp, y = feature , color = "#2E86AB")) +
  # Creates a point for the feature importance
  geom_point(position = position_dodge(0.5)) 
 
print(plot)

# A nicer graph displaying the features
 
plot +
  # Connecting line between 0 and the feature
  geom_linerange(aes(xmin = 0, xmax = rf_imp),
                 linetype = "solid",
                 position = position_dodge(.5)) +
  # Vertical line at 0
  geom_vline(xintercept = 0,
             linetype = "solid",
             color = "blue") +
  # Adjust the scale if you need to based on your importance
  scale_x_continuous(limits = c(-1, 70)) +
  # Label the x and y axes
  labs(x = "Importance", y = "Feature") +
  # Make the theme pretty
  theme_bw() +
  theme(legend.position = "none",
        text = element_text(family = "serif")) +
  guides(color = guide_legend(title = NULL)) +
  # Plot them in order of importance
  scale_y_discrete(limits = features$feature[order(features$rf_imp, decreasing = FALSE)])

## Boxplot/Distribution of importance features, split by groups of positive/negative patients ----

ggplot(data, aes(x = as.factor(DXAD), y = as.numeric(MMSCORE))) +
  geom_boxplot() +  # Use geom_density() for density plot instead of boxplot
  labs(title = "Effect of MMSCORE on Alzheimer's Disease",
       x = "DXAD",
       y = "MMSCORE") +
  theme_linedraw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))