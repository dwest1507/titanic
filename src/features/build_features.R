# Feature Engineering from inital data exploration
data <- train %>% 
  # Combine train and test data
  bind_rows(test) %>% 
  # Add new features
  mutate(
    Title = factor(str_extract(Name, "(?<=, )[^.]*")))

# Separate test and train data again
train <- data %>% 
  filter(is.na(Survived)==FALSE)

test <- data %>% 
  filter(is.na(Survived))

rm(data)