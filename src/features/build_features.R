# Feature Engineering from inital data exploration
data <- train %>% 
  # Combine train and test data
  bind_rows(test) %>% 
  # Add new features
  mutate(
    LastName = str_extract(Name, "^.*(?=,)"),
    Title = str_extract(Name, "(?<=, )[^.]*"),
    OtherName = str_extract(Name, "(?<=\\()[^\\)]*"),
    OtherNameExists = is.na(OtherName)==FALSE,
    AgeBin = case_when(
      is.na(Age) ~ NA_integer_,
      Age < quantile(train2$Age,0.05, na.rm = T) ~  1L,
      Age < quantile(train2$Age,0.10, na.rm = T) ~  2L,
      Age < quantile(train2$Age,0.15, na.rm = T) ~  3L,
      Age < quantile(train2$Age,0.20, na.rm = T) ~  4L,
      Age < quantile(train2$Age,0.25, na.rm = T) ~  5L,
      Age < quantile(train2$Age,0.30, na.rm = T) ~  6L,
      Age < quantile(train2$Age,0.35, na.rm = T) ~  7L,
      Age < quantile(train2$Age,0.40, na.rm = T) ~  8L,
      Age < quantile(train2$Age,0.45, na.rm = T) ~  9L,
      Age < quantile(train2$Age,0.50, na.rm = T) ~ 10L,
      Age < quantile(train2$Age,0.55, na.rm = T) ~ 11L,
      Age < quantile(train2$Age,0.60, na.rm = T) ~ 12L,
      Age < quantile(train2$Age,0.65, na.rm = T) ~ 13L,
      Age < quantile(train2$Age,0.70, na.rm = T) ~ 14L,
      Age < quantile(train2$Age,0.75, na.rm = T) ~ 15L,
      Age < quantile(train2$Age,0.80, na.rm = T) ~ 16L,
      Age < quantile(train2$Age,0.85, na.rm = T) ~ 17L,
      Age < quantile(train2$Age,0.90, na.rm = T) ~ 18L,
      Age < quantile(train2$Age,0.95, na.rm = T) ~ 19L,
      TRUE ~ 20L),
    TicketPrefix = str_extract(Ticket, "^.*(?= \\d{3})"),
    TicketPrefix = str_remove_all(TicketPrefix, "\\."),
    TicketNo = case_when(
      str_detect(Ticket, " ") ~ str_extract(Ticket, "\\d*$"),
      TRUE ~ Ticket),
    FareBin = case_when(
      Fare < quantile(train4$Fare,0.05) ~  1L,
      Fare < quantile(train4$Fare,0.10) ~  2L,
      Fare < quantile(train4$Fare,0.15) ~  3L,
      Fare < quantile(train4$Fare,0.20) ~  4L,
      Fare < quantile(train4$Fare,0.25) ~  5L,
      Fare < quantile(train4$Fare,0.30) ~  6L,
      Fare < quantile(train4$Fare,0.35) ~  7L,
      Fare < quantile(train4$Fare,0.40) ~  8L,
      Fare < quantile(train4$Fare,0.45) ~  9L,
      Fare < quantile(train4$Fare,0.50) ~ 10L,
      Fare < quantile(train4$Fare,0.55) ~ 11L,
      Fare < quantile(train4$Fare,0.60) ~ 12L,
      Fare < quantile(train4$Fare,0.65) ~ 13L,
      Fare < quantile(train4$Fare,0.70) ~ 14L,
      Fare < quantile(train4$Fare,0.75) ~ 15L,
      Fare < quantile(train4$Fare,0.80) ~ 16L,
      Fare < quantile(train4$Fare,0.85) ~ 17L,
      Fare < quantile(train4$Fare,0.90) ~ 18L,
      Fare < quantile(train4$Fare,0.95) ~ 19L,
      TRUE ~ 20L),
    CabinLevel = str_extract(Cabin,"^."),
    CabinQty = 
      str_count(Cabin, "[:alpha:]\\d{1,3}"),
    NoCabin = is.na(Cabin))

# Separate test and train data again
train <- data %>% 
  filter(is.na(Survived)==FALSE)

test <- data %>% 
  filter(is.na(Survived))

rm(data)