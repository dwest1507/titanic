# Loading the data
train <- read_csv(here::here("data","train.csv"))
test <- read_csv(here::here("data","test.csv"))
submission_example <- read_csv(here::here("data","gender_submission.csv"))