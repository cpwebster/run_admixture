library(ggplot2)
library(readr)
library(ggthemes)

# Read in file with cross validation values
cv <- read_table("<admixture_cross_validations.txt>")

# Plot
my_cross_val <- ggplot(cv, aes(x=K, y=CV)) + 
  geom_line(color = "turquoise3") + 
  geom_point(color = "turquoise3") + 
  scale_x_continuous(n.breaks=15) +
  theme_minimal() + 
  labs(title="Cross validation errors by K value") +
  ylab("Cross validation") +
  xlab("Ancestry coefficient") +
  theme(plot.title=element_text(hjust=0.5))
my_cross_val

# Save png
ggsave(
  "cross_validation_plot.png",
  device = NULL,
  scale = 1,
  width = 9,
  height = 5,
  bg = "white",
  units = c("in"),
  dpi = 300)
