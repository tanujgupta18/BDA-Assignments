# Load the dataset
data(iris)

# Remove the species column (as K-Means is unsupervised)
iris_data <- iris[, -5]  # Only numerical features

# Perform K-Means clustering with 3 clusters (since we know there are 3 species)
set.seed(42)  # Set seed for reproducibility
kmeans_result <- kmeans(iris_data, centers = 3, nstart = 20)

# Print clustering results
print(kmeans_result)

# Add the cluster results to the original dataset
iris$Cluster <- as.factor(kmeans_result$cluster)

# Visualizing the clusters using ggplot2
library(ggplot2)
ggplot(iris, aes(x = Petal.Length, y = Petal.Width, color = Cluster)) +
  geom_point(size = 3) +
  labs(title = "K-Means Clustering on Iris Dataset", x = "Petal Length", y = "Petal Width") +
  theme_minimal()
