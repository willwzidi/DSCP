rm(list=ls())

args = (commandArgs(trailingOnly=TRUE))
if(length(args) == 1){
  data_directory = args[1]
} else {
  cat('usage: Rscript model.R <data_directory>\n', file=stderr())
  stop()
}


if (require("FITSio")) {
  print("Loaded package FITSio.")
} else {
  print("Failed to load package FITSio.")
}

require("FITSio")
require("tidyverse")
require("randomForest")

if (require("randomForest")) {
  print("Loaded package randomForest.")
} else {
  print("Failed to load package randomForest.")
}

df_raw <- read.csv(data_directory)

# remove row with NA
df_nona <- df_raw[complete.cases(df_raw),]
# colSums(is.na(df_nona))

# scale the fare and remove those are beyond 3 sigma


df_scaled <- df_nona
#df_scaled <- na.omit(df_scaled)
rm(df_raw)


df_scaled$searchDate <- as.Date(df_scaled$searchDate)
df_scaled$flightDate <- as.Date(df_scaled$flightDate)
df_scaled$flight_month <- as.numeric(format(df_scaled$flightDate, "%m"))
df_scaled$flight_weekday <- as.numeric(format(df_scaled$flightDate, "%u"))
df_scaled$days_diff <- df_scaled$flightDate - df_scaled$searchDate
print("df_scaled_after")
colSums(is.na(df_scaled))

# Variables seleection

selected_features <- c(
  # Continous variables
  "baseFare",
  # Discrete variables
  "flight_month", "flight_weekday", "days_diff", "elapsedDays", "isBasicEconomy", "isRefundable", "seatsRemaining"
)

df_rf <- df_scaled[, c(selected_features, "totalFare")]
df_rf$isBasicEconomy <- as.factor(df_rf$isBasicEconomy)
df_rf$isRefundable <- as.factor(df_rf$isRefundable)
df_rf$flight_month <- as.factor(df_rf$flight_month)
df_rf$flight_weekday <- as.factor(df_rf$flight_weekday)
rm(df_scaled)

set.seed(605)
sample_size <- floor(0.9 * nrow(df_rf))
train_index <- sample(seq_len(nrow(df_rf)), size = sample_size)
train_data <- df_rf[train_index, c(selected_features, "totalFare")]
test_data <- df_rf[-train_index, c(selected_features, "totalFare")]
colSums(is.na(train_data))

rf_model <- randomForest(
    totalFare ~ .,
    data = train_data,
    ntree = 500,
    mtry = sqrt(length(selected_features)),
    importance = TRUE
)



#save(rf_model, file = "ATL_CLT_Non-stop_Flights_rf.RData")
rds_directory = sub("\\.csv$", "", data_directory)
output_file = paste0(rds_directory, ".rds")
saveRDS(rf_model, output_file)
#saveRDS(rf_model, "output.rds")
