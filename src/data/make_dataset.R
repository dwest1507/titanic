# Loading the data
train <- read.csv(here::here("data","raw","train.csv"))
test <- read.csv(here::here("data","raw","test.csv"))
submission_example <- read.csv(here::here("data","raw","gender_submission.csv"))