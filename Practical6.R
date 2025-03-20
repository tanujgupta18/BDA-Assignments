# Step 1: Install and load necessary libraries
install.packages("rpart")
install.packages("caret")
install.packages("ggplot2")
install.packages("e1071")  # For F1-score and other metrics
install.packages("rpart.plot")
install.packages("pROC")

library(rpart)
library(caret)
library(ggplot2)
library(e1071)
library(rpart.plot)
library(pROC)

# Step 2: Load dataset
data(iris)
head(iris)

# Step 3: Split data into training and testing sets (80-20 split)
set.seed(123)
trainIndex <- createDataPartition(iris$Species, p = 0.8, list = FALSE)
trainData <- iris[trainIndex, ]
testData <- iris[-trainIndex, ]

# Step 4: Train the Decision Tree model
model <- rpart(Species ~ ., data = trainData, method = "class")

# Summary of the model
summary(model)

# Step 5: Visualize the Decision Tree
rpart.plot(model)

# Step 6: Make Predictions on Test Data
predictions <- predict(model, testData, type = "class")

# Step 7: Evaluate the Model using Confusion Matrix and Performance Metrics
confMatrix <- confusionMatrix(predictions, testData$Species)
print(confMatrix)

# Extracting accuracy and F1-score from the confusion matrix
accuracy <- confMatrix$overall['Accuracy']
f1score <- confMatrix$byClass['F1']

cat("Accuracy: ", accuracy, "\n")
cat("F1-score: ", f1score, "\n")

# Step 8: Plot the ROC curve (Optional)
probabilities <- predict(model, testData, type = "prob")
roc.multi <- multiclass.roc(testData$Species, probabilities)
plot.roc(roc.multi)
