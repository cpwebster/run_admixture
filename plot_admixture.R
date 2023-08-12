library(tidyverse)
library(ggthemes)



# ---------------------
# Data parsing and prep
# ---------------------

# read in .Q file of desired number of ancestry coefficients, default = 5
tbl <- read_table("<your_admixture_output_file_here_prunned_filtered.5.Q>",
                  col_names = FALSE)

# add column names, this needs to equal your K value you are using (from Q doc)
colnames(tbl) <- c('1', '2', '3', '4', '5')

# read in file with sample names
# tab-delimited text file with sample names in column 1, no header
pop.data <- read.table("<your_file_with_sample_names_here.txt>", sep = "\t", header = FALSE)

# create a names column
names <- rep(pop.data$V1)

# convert to data frame, add row names (samples)
tbl_1 <- data.frame(names, tbl, row.names = 1)



# -------------------
# Data transformation
# -------------------

# transform data to order by population (group by color)
# change gather line to K value (X1:XK)

plot_data <- tbl_1 %>% 
  mutate(id = rownames(tbl_1)) %>% 
  gather('pop', 'prob', X1:X5) %>% 
  group_by(id) %>% 
  mutate(likely_assignment = pop[which.max(prob)],
         assingment_prob = max(prob)) %>% 
  arrange(likely_assignment, desc(assingment_prob)) %>% 
  ungroup() %>% 
  mutate(id = forcats::fct_inorder(factor(id)))


# ----------------------
# Plot Admixture results
# ----------------------

# plot (change number of colors in scale_fill_manual() line to equal K value)

plot_data %>% 
  ggplot(aes(id, as.numeric(prob), fill=pop)) +
  geom_bar(position = "stack", stat = "identity") +
  scale_fill_manual(values=c("deeppink1","darkorchid", 
                             "darkorange1", "royalblue1",
                             "seagreen3")) +
  geom_col() +
  theme_minimal() +
  ggtitle("Admixture K=5") + 
  theme(plot.title = element_text(hjust = 0.5)) + xlab("") + 
  ylab("Ancestry") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1, size = 6),
        legend.position="none")

# save plot png

ggsave(
  "admixure_k5.png",
  device = NULL,
  scale = 1,
  width = 11,
  height = 5,
  units = c("in"),
  dpi = 300)




































       
       
       
       
       


