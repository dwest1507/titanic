library(tidyverse)
library(randomForest)

# Loading the data
train <- read.csv(here::here("data","raw","train.csv"))
test <- read.csv(here::here("data","raw","test.csv"))
submission_example <- read.csv(here::here("data","raw","gender_submission.csv"))

# Changing Survived from an integer to a factor for ML models
train$Survived <- factor(train$Survived)

# Feature Engineering from inital data exploration
data <- train %>% 
  # Combine train and test data
  bind_rows(test) %>% 
  # Assumes median for all NAs for Age and Fare
  mutate(
    Age = case_when(
      is.na(Age) ~ median(Age, na.rm = T),
      TRUE ~ Age),
    Fare = case_when(
      is.na(Fare) ~ median(Fare, na.rm = T),
      TRUE ~ Fare)) %>% 
  # Add new features
  mutate(
    Title = factor(str_extract(Name, "(?<=, )[^.]*")),
    AgeBin = cut(Age,
                 breaks = unique(c(0,quantile(Age, seq(0,1,0.05), na.rm = T),Inf)),
                 right = F),
    FareBin = cut(Fare,
                  breaks = unique(c(0,quantile(Fare, seq(0,1,0.05), na.rm = T),Inf)),
                  right = F),
    TicketPrefix =
      fct_explicit_na(
        str_to_lower(
          str_remove_all(
            str_extract(Ticket, "^.*(?= \\d{3})"), "\\.|\\/|\\s"))),
    CabinLevel = fct_explicit_na(str_extract(Cabin,"^.")),
    CabinQty = 
      fct_explicit_na(
        factor(
          case_when(
            as.character(Cabin)==as.character(CabinLevel) ~ 1L,
            TRUE ~ str_count(Cabin, "[:alpha:]\\d{1,3}")))))

# Separate test and train data again
train <- data %>% 
  filter(is.na(Survived)==FALSE)

test <- data %>% 
  filter(is.na(Survived)) %>% 
  select(-Survived)

rm(data)

# Creating a randomForest model
# remove factors with too many levels
train2 <- train %>% 
  select(-c(Name, PassengerId, Ticket, Cabin))

# set seed for reproducibility
set.seed(123)

# create model
rf_model1 <- randomForest(Survived ~ ., data = train2)

# make predictions on test data
rf_model1_predictions <- predict(object = rf_model1,
                                 newdata = test,
                                 type = "class")

# map predictions to test data
rf_model1_submission <- test %>% 
  as_tibble() %>% 
  mutate(Survived = rf_model1_predictions) %>% 
  select(PassengerId, Survived)

# export results
write.csv(rf_model1_submission,
          here::here("data","processed","rf_model1_submission.csv"),
          row.names = F)


