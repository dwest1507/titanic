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