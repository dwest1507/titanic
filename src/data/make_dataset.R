# Loading the data
train <- read.csv(here::here("data","raw","train.csv"))
test <- read.csv(here::here("data","raw","test.csv"))
submission_example <- read.csv(here::here("data","raw","gender_submission.csv"))
# Adding correct answers to test data set
full <- read.csv(here::here("data","raw","full_data.csv"))


# Changing Survived from an integer to a factor for ML models
train$Survived <- factor(train$Survived)
full$survived <- factor(full$survived)

# Before joining full to test, the column names need to match
# Also, there was some weird stuff going on with quotation marks.
# So I had to remove quotation markes in the column Name before
# the data merge and then add them back in after.
names(full) <- str_to_title(names(full))

full <- full %>% 
  rename(SibSp = Sibsp) %>% 
  select(-c(Boat, Body, Home.dest)) %>% 
  mutate(Name = str_remove_all(Name, '\\"'))

test2 <- test %>% 
  mutate(Name = str_remove_all(Name, '\\"')) %>% 
  left_join(full) %>% 
  select(-Name)

test <- test2 %>% 
  left_join(test)

rm(test2)