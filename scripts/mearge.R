
# mearging GC sample times (dt), GC data (df), and weather data (dw)

# mearge GC conc data and sampling times
dd <- merge(df, dt, by = c('date', 'chamber', 'round'))

# mearge above with weather data
dd <- merge(dd, dw, by = 'date.time.w', all.x = TRUE)

# mearge above with frame volume and area data
dh$ID <- as.character(dh$ID)
dd <- merge(dd, dh, by = 'ID', all.x = TRUE)

# check data table for incomplete cases
dd[!complete.cases(dd), ]
