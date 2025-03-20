# Install and Load Required Libraries
install.packages("ggplot2", dependencies = TRUE)
install.packages("dplyr", dependencies = TRUE)
install.packages("nycflights13", dependencies = TRUE)

library(ggplot2)
library(dplyr)
library(nycflights13)

# Load the NYC Flights dataset
data <- nycflights13::flights

# Inspect Data
head(data)
str(data)
summary(data)

# Scatter Plot: Departure Delay vs Arrival Delay
ggplot(data, aes(x = dep_delay, y = arr_delay)) +
  geom_point(color = "blue", alpha = 0.5) +
  labs(title = "Scatter Plot: Departure Delay vs Arrival Delay",
       x = "Departure Delay (minutes)",
       y = "Arrival Delay (minutes)") +
  theme_minimal()

# Bar Plot: Number of Flights per Carrier
ggplot(data, aes(x = carrier, fill = carrier)) +
  geom_bar() +
  labs(title = "Bar Plot: Number of Flights per Carrier",
       x = "Carrier",
       y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Box Plot: Arrival Delay by Airline Carrier
ggplot(data, aes(x = carrier, y = arr_delay, fill = carrier)) +
  geom_boxplot() +
  labs(title = "Box Plot: Arrival Delay by Carrier",
       x = "Carrier",
       y = "Arrival Delay (minutes)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Line Plot: Average Departure Delay per Month
data_summary <- data %>%
  group_by(month) %>%
  summarise(avg_dep_delay = mean(dep_delay, na.rm = TRUE))

ggplot(data_summary, aes(x = month, y = avg_dep_delay)) +
  geom_line(color = "blue", size = 1) +
  geom_point(color = "red", size = 3) +
  labs(title = "Line Plot: Avg Departure Delay by Month",
       x = "Month",
       y = "Average Departure Delay (minutes)") +
  theme_minimal()

# Facetted Scatter Plot: Departure Delay vs Arrival Delay by Carrier
ggplot(data, aes(x = dep_delay, y = arr_delay, color = carrier)) +
  geom_point(alpha = 0.5) +
  facet_wrap(~carrier) +
  labs(title = "Facetted Scatter Plot: Departure vs Arrival Delay by Carrier",
       x = "Departure Delay (minutes)",
       y = "Arrival Delay (minutes)") +
  theme_minimal()

# Scatter Plot with Regression Line: Departure Delay vs Arrival Delay
ggplot(data, aes(x = dep_delay, y = arr_delay)) +
  geom_point(color = "blue", alpha = 0.3) +
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  labs(title = "Scatter Plot with Regression Line",
       x = "Departure Delay (minutes)",
       y = "Arrival Delay (minutes)") +
  theme_minimal()
