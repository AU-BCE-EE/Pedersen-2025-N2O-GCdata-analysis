
## times for GC sampling time
# changing to long format
dt <- melt(
  dt,
  id.vars = c( 'date', 'chamber', 'treat', 'ID', 't0'),
  measure.vars = c('t0', 't1', 't2', 't3'), 
  variable.name = "round", 
  value.name = "time"   
)

# correct time
dt[, time := gsub('\\.', ':', time)]
dt[, t0 := gsub('\\.', ':', t0)]

# making date.time stamps for initiation of sampling (.ini), first sampling of each id (t0) and sampling (.samp)
dt[, date.time.t0 := paste(date, t0)]
dt[, date.time.t0 := as.POSIXct(date.time.t0, format = '%y%m%d %H:%M')]

dt[, date.time := paste(date, time)]
dt[, date.time := as.POSIXct(date.time, format = '%y%m%d %H:%M')]


# rounding date.time to nearest hour to combine with weather data in mearge.R
dt[, date.time.w := round_date(date.time, unit = "hour")]


# changing date column to fit df
dt[, date := as.character(as.Date(date, format = "%y%m%d"))]


# creating id column in df
df[, id := as.integer(sub("-.*", "", sample))]


## weather data
# make date.time for combining with dt (GC data)
dw[, date.time.w := as.POSIXct(Timestamp, format = "%d-%m-%y %H:%M")]
