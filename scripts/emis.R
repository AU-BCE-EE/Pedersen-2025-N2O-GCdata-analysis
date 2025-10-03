
# calculating deploy time
dd[, deploy := as.numeric(difftime(date.time, date.time.t0, units = "hours"))]

## calculating N2O concentration (ug/L)
# constants
R <- 0.082056 # L atm K−1 mol−1
P.conv <- 1013.25 # hPa atm-1
K.0 <- 273.15 # K at 0C
Nn <- 28 # g mol-1
Cc <- 12 # g mol-1

# volume of 1 mol of N2O gas:
# PV = nRT => V / 1 mol = R * T / P
# L mol-1 <- L atm K-1 mol-1 * K * atm-1
dd[, L.mol := R * (K.0 + metp) / (pres / P.conv)]

# from ppm to ug L-1
dd[, N2Oppm := as.numeric(dd$N2Oppm)]
dd[, N2Oug.L := N2Oppm / L.mol * Nn]

dd[, CH4ppm := as.numeric(dd$CH4ppm)]
dd[, CH4ug.L := CH4ppm / L.mol * Cc]

dd[, CO2ppm := as.numeric(dd$CO2ppm)]
dd[, CO2ug.L := CO2ppm / L.mol * Cc]

# make a combined ID for the HMR calc in order to track date, ID, and treatment after
dd$com.id <- paste(dd$date.y, '-', dd$ID, '-', dd$treatment)

ddd <- dd[, c('com.id', 'vol.L', 'area', 'deploy', 'N2Oug.L', 'CH4ug.L', 'CO2ug.L')]
ds <- dd[, c('com.id', 'vol.L', 'area', 'deploy', 'N2Oug.L')]

# making a csv file to be used to calculate the N2O flux with the HMR package
write.csv(ds, '../scripts/ds.csv', row.names = FALSE, quote = FALSE)

# using the HMR package to calulate the N2O flux
HMR(filename = 'ds.csv', dec = '.', sep = ',', LR.always = TRUE, FollowHMR = TRUE,
    pfvar = 0.0001, IfNoSignal = 'LR', SatPct = 90, SatTimeMin = 2)

HMRds <- fread('HMR - ds.csv')

# adding dates, plot ID, and treatment columns to HMRds data
HMRds[, c('date', 'ID', 'treat') := tstrsplit(Series, ' - ')]