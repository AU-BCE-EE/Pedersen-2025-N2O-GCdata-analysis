
# checking times for sampling
dt[, chamber := as.numeric(chamber)]

ggplot(dt, aes(chamber, time, color = round)) +
  geom_point() +
  facet_wrap(~ date)
ggsave2x('../plots/chamber_times', height = 10, width = 10)


# checking CO2 levels
unique_dates <- unique(dd$date.y)

for (d in unique_dates){
  df_subset <- dd[dd$date.y == d, ]
  
  p <- ggplot(df_subset, aes(deploy, CO2ug.L)) + 
    geom_point() + 
    geom_line() + 
    facet_wrap(~ chamber, scales = 'free_y') + 
    ggtitle(paste('CO2 on', d)) + 
    theme_bw() 
  
  ggsave(filename = paste0('../plots/CO2 check/CO2_free_y_', d, '.png'), plot = p, width = 10, height = 10)
}

# checking N2O levels
# adding chamber number data to HMRds
unique_dates <- unique(dd$date.y)

HMRds <- merge(HMRds, unique(dd[, .(ID, chamber)]), by = 'ID', all.x = TRUE)

for (d in unique_dates){
  df_subset <- dd[dd$date.y == d, ]
  
  labels_df <- unique(
    HMRds[HMRds$date == d & HMRds$chamber %in% df_subset$chamber, c('chamber', 'Method')]
  )
  
  # Label positions per chamber
  labels_df$x <- tapply(df_subset$deploy, df_subset$chamber, max, na.rm = TRUE)[labels_df$chamber]
  labels_df$y <- tapply(df_subset$N2Oug.L, df_subset$chamber, max, na.rm = TRUE)[labels_df$chamber]
  
  p <- ggplot(df_subset, aes(deploy, N2Oug.L)) + 
    geom_point() + 
    geom_line() + 
    facet_wrap(~ chamber, scales = 'free_y') + 
    ggtitle(paste('N2O on', d)) +
    geom_text(data = labels_df, aes(x = x, y = y, label = Method), inherit.aes = FALSE, hjust = 1, vjust = 1, color = "red", size = 5) +
    theme_bw()
  
  ggsave(filename = paste0('../plots/N2O check/N2O_free_y_', d, '.png'), plot = p, width = 10, height = 10)
}


for (d in unique_dates){
  df_subset <- dd[dd$date.y == d, ]
  
  labels_df <- unique(
    HMRds[HMRds$date == d & HMRds$chamber %in% df_subset$chamber, c('chamber', 'Method')]
  )
  
  # Label positions per chamber
  labels_df$x <- tapply(df_subset$deploy, df_subset$chamber, max, na.rm = TRUE)[labels_df$chamber]
  labels_df$y <- tapply(df_subset$N2Oug.L, df_subset$chamber, max, na.rm = TRUE)[labels_df$chamber]
  
  p <- ggplot(df_subset, aes(deploy, N2Oug.L)) + 
    geom_point() + 
    geom_line() + 
    facet_wrap(~ chamber) + 
    ggtitle(paste('N2O on', d)) + 
    geom_text(data = labels_df, aes(x = 1.25, y = y, label = Method), inherit.aes = FALSE, hjust = 1, vjust = 1, color = "red", size = 5) +
    theme_bw() + 
    ylim(0, 3.1)
  
  ggsave(filename = paste0('../plots/N2O check/N2O_fixed_y_', d, '.png'), plot = p, width = 10, height = 10)
}
