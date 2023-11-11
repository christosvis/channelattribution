# Install these libraries 
install.packages("ChannelAttribution")
install.packages("reshape")
install.packages("ggplot2")

# Load these libraries 
library(ChannelAttribution)
library(reshape)
library(ggplot2)

# This loads the demo data. You can load your own data by importing a dataset or reading in a file
data(PathData)

# Build the simple heuristic models 
#(First Click / first_touch, Last Click / last_touch, 
# and Linear Attribution / linear_touch):
H <- heuristic_models(Data, 'path', 'total_conversions', var_value='total_conversion_value')

# Build the Markov model (markov_model):
M <- markov_model(Data, 'path', 'total_conversions', var_value='total_conversion_value', order = 1) 
# You can specify the Markov order by adding the "order" argument. By default, it will run as Order 1.

# NOTE: The same steps apply from building the heuristics models in order to pass in your own data for building the markov_model.

# Merges the two data frames on the "channel_name" column.
R <- merge(H, M, by='channel_name') 

# Selects only relevant columns
R1 <- R[, (colnames(R)%in%c('channel_name', 'first_touch_conversions', 'last_touch_conversions', 'linear_touch_conversions', 'total_conversion'))]

# Renames the columns
colnames(R1) <- c('channel_name', 'first_touch', 'last_touch', 'linear_touch', 'markov_model') 

# Transforms the dataset into a data frame that ggplot2 can use to graph the outcomes
R1 <- melt(R1, id='channel_name')



# Plot the total conversions
ggplot(R1, aes(channel_name, value, fill = variable)) +
  geom_bar(stat='identity', position='dodge') +
  ggtitle('TOTAL CONVERSIONS') + 
  theme(axis.title.x = element_text(vjust = -2)) +
  theme(axis.title.y = element_text(vjust = +2)) +
  theme(title = element_text(size = 16)) +
  theme(plot.title=element_text(size = 20)) +
  ylab("")

# NOTE: The "+" allows you to split the code over multiple lines without running each line individually.

R2 <- R[, (colnames(R)%in%c('channel_name', 'first_touch_value', 'last_touch_value', 'linear_touch_value', 'total_conversion_value'))]

colnames(R2) <- c('channel_name', 'first_touch', 'last_touch', 'linear_touch', 'markov_model')

R2 <- melt(R2, id='channel_name')

ggplot(R2, aes(channel_name, value, fill = variable)) +
  geom_bar(stat='identity', position='dodge') +
  ggtitle('TOTAL VALUE') + 
  theme(axis.title.x = element_text(vjust = -2)) +
  theme(axis.title.y = element_text(vjust = +2)) +
  theme(title = element_text(size = 16)) +
  theme(plot.title=element_text(size = 20)) +
  ylab("")



# Run the same but with Shiny app
install.packages("ChannelAttributionApp")
library(ChannelAttributionApp)
help(ChannelAttributionApp)
# Package contains function CAapp which launches a Shiny Web Application.
CAapp()
