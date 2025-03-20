# Install necessary packages if not already installed
install.packages(c("caret", "ggplot2", "dplyr", "readr"))

# Load the libraries
library(caret)
library(ggplot2)
library(dplyr)
library(readr)

# Step 2: Import Dataset
# We'll use the built-in 'mtcars' dataset for demonstration purposes
data(mtcars)

# View the first few rows of the dataset
head(mtcars)

# Step 3: Clean the Dataset
# Check for missing values (mtcars dataset has no missing values)
sum(is.na(mtcars))

# Step 4: Split the Dataset into Training and Testing Sets
# Set a seed for reproducibility
set.seed(123)

# Split the data (80% for training, 20% for testing)
trainIndex <- createDataPartition(mtcars$mpg, p = 0.8, list = FALSE)
trainData <- mtcars[trainIndex, ]
testData <- mtcars[-trainIndex, ]

# Step 5: Build the Linear Regression Model
# Fit a linear regression model to predict 'mpg' using all other variables
lmModel <- lm(mpg ~ ., data = trainData)

# View the model summary
summary(lmModel)

# Step 6: Make Predictions on the Test Data
# Make predictions on the test set
predictions <- predict(lmModel, newdata = testData)

# Step 7: Model Evaluation
# RMSE Calculation
rmse <- sqrt(mean((predictions - testData$mpg)^2))
cat("RMSE: ", rmse, "\n")

# R-squared Calculation
rss <- sum((predictions - testData$mpg)^2)  # Residual sum of squares
tss <- sum((testData$mpg - mean(testData$mpg))^2)  # Total sum of squares
r_squared <- 1 - (rss / tss)
cat("R-squared: ", r_squared, "\n")

# Step 8: Visualize Model Performance (Optional)
# Create a data frame for ggplot
results <- data.frame(Actual = testData$mpg, Predicted = predictions)

# Plot actual vs predicted values
ggplot(results, aes(x = Actual, y = Predicted)) +
  geom_point(color = "blue") +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "red") +
  ggtitle("Actual vs Predicted") +
  xlab("Actual MPG") +
  ylab("Predicted MPG")

# Step 9: Additional Model Evaluation (Optional)
# Calculate additional metrics (MAE, MSE, etc.)
model_eval <- postResample(predictions, testData$mpg)
print(model_eval)
