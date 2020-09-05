# Loading the data
train <- read.csv(here::here("data","raw","train.csv"))
test <- read.csv(here::here("data","raw","test.csv"))
submission_example <- read.csv(here::here("data","raw","gender_submission.csv"))

# Changing Survived from an integer to a factor for ML models
train$Survived <- factor(train$Survived)
test$Survived <- factor(test$Survived)
