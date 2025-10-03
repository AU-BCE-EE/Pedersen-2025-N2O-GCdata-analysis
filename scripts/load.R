
###### times for GC sampling 
dt <- fread('../data/sample times.csv')
setnames(dt, as.character(unlist(dt[2, ])))
dt <- dt[-c(1:2), c(1:8)]


###### GC data 
# make load function:
load_gc_file <- function(file_path, date_str, sheet = 1) {
  dt <- as.data.table(read.xlsx(file_path, sheet = sheet))
  dt <- dt[-c(1:24), -c(1:20)]
  dt[, date := date_str]
  return(dt)
}

# define file path
f <- '../data/GC data.xlsx'

# list of sampling dates
dates <- c('2021-06-01')

# load all GC data into one list
dfs <- mapply(function(id, sheet) {
  load_gc_file(f, id, sheet = sheet)
}, id = dates, sheet = dates, SIMPLIFY = FALSE)


# add the same header to all 
dfs <- lapply(dfs, function(df) {
  colnames(df) <- c('sample', 'chamber', 'treatment', 'round', 'N2Oppm', 'CH4ppm', 'CO2ppm', 'date')
  df
})

# combine all GC data
df <- do.call(rbind, dfs)

# removing NA rows
df <- df[! is.na(df$sample)]

# check of the right number of observations is present in the GC data 
## 6 treatments in the trial (SBcc, SBgc, GC2, MS, MScc, GC1)
## 3 replicates of each treatment except SBcc that has 6 replicates
no.chambers <- 5 * 3 + 6
no.days <- 1 # number of sampling days
no.samp <- 4 # GC samples pr data point (t0, t1, t2, t3)

no.tot <- no.chambers * no.days * no.samp

nrow(df) - no.tot # should be 0

###### average collar height
dh <- read.xlsx('../data/collar height.xlsx')
dh <- as.data.table(dh)

## Volume and area of chambers
# average height within each chamber
dh[, vol.m3 := 0.75^2 * 0.4 + 0.74^2 * (avg.height / 100)] # m3
dh[, vol.L := vol.m3 * 10^3] # L
dh[, area := 0.74 * 0.74] # m2


###### weather data
dw <- fread('../data/climate.csv')
