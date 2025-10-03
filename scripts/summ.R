
# from ug h-1 m-2 to ug d-1 m-2
HMRds[, f0.h := f0 * 24]

#summarizing results based on treatment
HMRds.summ <- HMRds[, .(flux.mn = mean(f0), flux.sd = sd(f0)),
                    by = .(date, treat)]
