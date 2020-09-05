# Loading the data
train <- read_csv(here::here("data","raw","train.csv"))
test <- read_csv(here::here("data","raw","test.csv"))
submission_example <- read_csv(here::here("data","raw","gender_submission.csv"))