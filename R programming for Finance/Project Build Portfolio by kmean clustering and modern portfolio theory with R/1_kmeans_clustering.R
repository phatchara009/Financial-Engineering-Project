##### Library packages #####

library(tidyverse) # data manipulation
library(tidyquant) # for finance data
library(factoextra) # clustering visualization for k-means
library(dendextend) # for comparing two dendrograms for k-means

#############################################################################################################

# Set working directory
path = "C:\\Users\\Admin\\Documents\\Project_R/"

# Set date
date_from_kmeans = "2021-01-01"
date_to_kmeans = "2021-12-31"

#############################################################################################################
##### K-means Clustering Portfolio ##########################################################################
#############################################################################################################

##### CAPM to get Beta of each stock #####

#-----------------------------------------------------------------------------#

# Create name of stock in SET50 (exclude AWC.BK, BRGRIM.BK, CRC.BK, GULF.BK, 
# ,OSP.BK, SCGP.BK, SCB.BK, TIDLOR.BK and OR.BK) 
# summary 41 symbols
symbols_set50 <- c("ADVANC.BK", "AOT.BK", "BANPU.BK", "BBL.BK", "BDMS.BK",
                   "BEM.BK", "BH.BK", "BLA.BK", "BTS.BK", "CBG.BK", 
                   "CPALL.BK", "CPF.BK", "CPN.BK", "DTAC.BK", "EA.BK",
                   "EGCO.BK", "GLOBAL.BK", "GPSC.BK", "HMPRO.BK", "INTUCH.BK",
                   "IRPC.BK", "IVL.BK", "JMART.BK", "JMT.BK", "KBANK.BK", 
                   "KCE.BK", "KTB.BK", "KTC.BK", "LH.BK", "MINT.BK", 
                   "MTC.BK", "PTT.BK", "PTTEP.BK", "PTTGC.BK", "SAWAD.BK", 
                   "SCC.BK",  "TISCO.BK", "TOP.BK", "TRUE.BK", "TTB.BK", 
                   "TU.BK")

#-----------------------------------------------------------------------------#

# Get stock data in SET50
stocks_return<- tq_get(symbols_set50,
                       from = date_from_kmeans,
                       to = date_to_kmeans) %>% 
  na.omit() %>%
  group_by(symbol) %>%
  tq_transmute(select = adjusted, 
               mutate_fun = periodReturn,
               period = "daily",
               col_rename = "stock_ret")

# Get SET Index return data
set_index_return <- tq_get("^SET.BK",
                           from = date_from_kmeans,
                           to = date_to_kmeans) %>% 
  na.omit() %>%
  tq_transmute(select = adjusted, 
               mutate_fun = periodReturn,
               period = "daily",
               col_rename = "set_ret")

#-----------------------------------------------------------------------------#

# Joining data for CAPM model
return_data <- stocks_return %>% 
  inner_join(set_index_return,
             by = "date")

# Analysis with CAPM and get stock beta
beta_capm <- return_data %>% 
  tq_performance(Ra = stock_ret,
                 Rb = set_ret,
                 performance_fun = table.CAPM) %>%
  select(symbol, Beta)

#-----------------------------------------------------------------------------#

#############################################################################################################

##### Prepare data to Clustering #####

# Join mean of stock return data and financial ratio of each stock (exclude SCB.BK, TIDLOR.BK and OR.BK)
dataset <- 
  # Calculating mean of stock return
  stocks_return %>%
  group_by(symbol) %>%
  summarize(mean_return = mean(stock_ret)) %>%
  # Inner join with beta_capm
  inner_join(beta_capm,
             by = "symbol") %>%
  # Inner join with financial ratio
  inner_join(read.csv(paste0(path,"data/financial_ratio.csv")),
             by = "symbol")

#-----------------------------------------------------------------------------#

# Use Z-score to normalize data if attribute type is numeric
scaled_df <- dataset %>% 
  data.frame(row.names="symbol") %>%
  scale()
head(scaled_df)

#-----------------------------------------------------------------------------#

#############################################################################################################

## k-means clustering algorithm

# Elbow method for find best k
# fviz_nbclust(scaled_df,
#              FUN = kmeans,
#              k.max = 10,
#              method = "wss") +
#   labs(subtitle = "Elbow method")

## Elbow method for find best k
elbow_df <- data.frame(
  k = 1:10,
  tot_withiness = 
    map_dbl(1:10, function(k){
      model <- kmeans(x=scaled_df, center = k)
      model$tot.withinss
    }))
elbow_df

# plot elbow graph and export graph to .png
png(file=paste0(path, "graph/elbow_plot.png"))
ggplot(data = elbow_df) + 
  geom_line(mapping = aes(x = k, y = tot_withiness), color = "red", size=1) + 
  geom_point(mapping = aes(x = k, y = tot_withiness), size = 1) +
  scale_x_continuous(breaks = 1:10) + 
  theme_bw() +
  labs(x = "Number of cluster (k)",
       y = "Total Within Sum of Square",
       title = "Elbow Method")
dev.off()

# Silhouette method for find best k and export graph to .png
png(file=paste0(path, "graph/silhouette_plot.png"))
fviz_nbclust(scaled_df, 
             FUN = kmeans,
             k.max = 8,
             method = "silhouette") +
  labs(subtitle = "Silhouette method")
dev.off()

#-----------------------------------------------------------------------------#

# k-means modeling
set.seed(123) # set seed
km <- kmeans(scaled_df, centers = 7)
km

# plot graph and export graph to .png
png(file=paste0(path, "graph/cluster_scatter_plot.png"))
fviz_cluster(km, data = scaled_df)
dev.off()

# Create cluster group dataframes and mutate symbol by row names
km_df <- data.frame(km$cluster) %>% 
  rownames_to_column("symbol")

# Join with dataset
cluster <- dataset %>% 
  inner_join(km_df, by = "symbol")

# Write cluster to csv
cluster %>% 
  write.csv(paste0(path, "data/all_cluster.csv"),
            row.names = FALSE)

#-----------------------------------------------------------------------------#

# Print for look characteristic of each cluster
for (i in 1:max(cluster["km.cluster"])) {
  print(cluster %>% filter(km.cluster==i))
}

#-----------------------------------------------------------------------------#




