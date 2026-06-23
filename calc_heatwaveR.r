# r

# run heatwaveR functions to identify extreme event indices on any native grid
# https://cran.r-project.org/web/packages/heatwaveR
# https://robwschlegel.github.io/heatwaveR/index.html
# todo: check new package heatwave3: https://robwschlegel.github.io/heatwave3/index.html

# fixed baseline vs detrending vs running mean:
# https://github.com/robwschlegel/heatwaveR/issues/22

# netcdf chunking (ncdump -hs) of input files is checked; error occurs if chunking is wrong
# https://github.com/ebimodeling/model-drivers/blob/master/met/cruncep/README.md

# run this script with a sufficiently small `length(location_inds)` <= ~3000 or
# `end/njobs_wanted` ~ 3000 in `calc_heatwaveR_loop.r`; `njobs_wanted` there equals `nchunks` here
# --> see runtime stats below

# todo: automated chunking

# todo: non-daily data

# todo: depth dim must be of length zero, i.e. select your wanted depth level and
#       squeeze aka flat aka reduce the depth dim before running the scripts
#       --> calc_ and post_ work with depth dim but composite_ not yet

# todo:
#Error in `dplyr::mutate()`:
#ℹ In argument: `event_name_letter = dplyr::case_when(...)`.
#ℹ In group 10: `event_name = "Event 2017"`.
#Caused by error:
#! `env` must be an environment
#Backtrace:
#     ▆
#  1. ├─heatwaveR::detect_event(...)
#  2. │ └─heatwaveR::category(data_res, ...)
#  3. │   └─... %>% dplyr::select(-event_count, -event_name_letter)
#  4. ├─dplyr::select(., -event_count, -event_name_letter)
#  5. ├─dplyr::mutate(...)
#  6. ├─dplyr::ungroup(.)
#  7. ├─dplyr::mutate(...)
#  8. ├─dplyr:::mutate.data.frame(...)
#  9. │ └─dplyr:::mutate_cols(.data, dplyr_quosures(...), by)
# 10. │   ├─base::withCallingHandlers(...)
# 11. │   └─dplyr:::mutate_col(dots[[i]], data, mask, new_columns)
# 12. │     └─mask$eval_all_mutate(quo)
# 13. │       └─dplyr (local) eval()
# 14. └─rlang::abort(message = message)
## --> bug in dplyr package; works when rerun

# todo:
#Error in dplyr::ungroup(.) : bad generic call environment
#Calls: <Anonymous> ... category -> %>% -> <Anonymous> -> <Anonymous> -> <Anonymous>
# --> bug in dplyr package; works when rerun

rm(list=ls()); graphics.off()
op_warn <- options()$warn
op_width <- options()$width
library(ncdf4)
library(heatwaveR)

# default heatwaveR package options
heatwaveR_opts <- list(minDuration=5,    # for heatwaveR::detect_event(); default: 5 days
                       clim_runmean=NA,  # for heatwaveR::tsclm(); default: NA; odd number of years for running mean
                       #clim_runmean=31,
                       #clim_runmean=15,
                       MCScorrect=F,     # for heatwaveR::detect_event(); default: F; passed to heatwaveR::category(): do not let seawater temp threshold go below -1.8°C
                       calc_trend=T,     # save trend of original data
                       remove_trend=F,   # remove trend of original data before extreme event detection
                       climatology=F,    # for heatwaveR::detect_event(); default: F; passed to hewatwaveR::category(): returns more details
                       var=T,            # for heatwaveR::detect_event(); default: F; calc var in addition; if true, will run heatwaveR:::clim_calc_cpp and not clim_calc
                       roundClm=F        # for heatwaveR::ts2clm(); default: 4; round clim and thres values; !!! this actually depends on the variable; keep F !!!
                       )

# variable-specific heatwaveR options
# - `coldSpells` flips signs:
# ```
# in heatwaveR:
# if (coldSpells) {
#      t_series$ts_y <- -t_series$ts_y
#      t_series$ts_seas <- -t_series$ts_seas
#      t_series$ts_thresh <- -t_series$ts_thresh
#      events$intensity_mean <- -events$intensity_mean
#      ...
# in heatwave3:
#  if (coldSpells) {
#      t_series[, (2:4) := list(-ts_y, -ts_seas, -ts_thresh)]
#      intensity_mean = -intensity_mean,
#      ...
# ```
# - `MCScorrect` limits threshold to -1.8°C (in category() only)
# ```
# if (MCScorrect) {
#     clim_diff <- clim_diff %>% dplyr::mutate(diff = round(dplyr::case_when(thresh_4x +
#                     diff <= -1.8 ~ -(thresh + 1.8)/4, TRUE ~ diff), roundVal),
# ```

# which setting
depth <- NULL # default
if (F) { # oisst daily from downloads.psl.noaa.gov: combination of v2 and v2.1
    dataname <- "oisst_v2.1"
    varname <- "sst"
    heatwaveR_opts$pctile <- 90
    timedimname <- "time"
    spatialdimnames <- c("lon", "lat") # order does not matter
    #ts_from <- 1981 # incomplete year
    ts_from <- as.POSIXct("1982-1-1", tz="UTC") # first complete year
    #ts_from <- as.POSIXct("1992-1-1", tz="UTC")
    #ts_to <- as.POSIXct("1992-12-31 23:59:59", tz="UTC")
    #ts_to <- as.POSIXct("2014-12-31 23:59:59", tz="UTC")
    ts_to <- as.POSIXct("2021-12-31 23:59:59", tz="UTC")
    clim_from <- ts_from
    clim_to <- ts_to
    workpath <- "/work/ba1103/a270073"
    if (F) { # time,lat,lon; sst:_ChunkSizes = 1, 720, 1440; 3-4 min
        pathin <- paste0(workpath, "/data/oisst/data/v2/daily")
        files <- list.files(pathin, pattern=glob2rx("sst.day.mean.????.v2.nc"), full.names=T)
        pathin <- paste0(workpath, "/data/oisst/data/v2.1/daily")
        files <- c(files, list.files(pathin, pattern=glob2rx("sst.day.mean.????.v2.nc"), full.names=T))
    } else if (F) { # time,lat,lon; sst:_ChunkSizes = 366, 720, 1; 0.195861 sec
        pathin <- paste0(workpath, "/data/oisst/data/v2/daily/chunked_ntime_nlat720_nlon1")
        files <- list.files(pathin, pattern=glob2rx("sst.day.mean.????.v2.nc"), full.names=T)
        pathin <- paste0(workpath, "/data/oisst/data/v2.1/daily/chunked_ntime_nlat720_nlon1")
        files <- c(files, list.files(pathin, pattern=glob2rx("sst.day.mean.????.v2.nc"), full.names=T))
    } else if (T) { # time,lat,lon; sst:_ChunkSizes = 366, 1, 1440; 0.008778555 sec
        pathin <- paste0(workpath, "/data/oisst/data/v2/daily/chunked_ntime_nlat1_nlon1440")
        files <- list.files(pathin, pattern=glob2rx("sst.day.mean.????.v2.nc"), full.names=T)
        pathin <- paste0(workpath, "/data/oisst/data/v2.1/daily/chunked_ntime_nlat1_nlon1440")
        files <- c(files, list.files(pathin, pattern=glob2rx("sst.day.mean.????.v2.nc"), full.names=T))
    }
    files_from <- substr(basename(files), 14, 17) # sst.day.mean.YYYY.v2.nc
    files_to <- files_from
    files_from <- paste0(files_from, "-01-01") # per
    files_to <- paste0(files_to, "-12-31")     # file
    pathout <- paste0(workpath, "/post/heatwaveR/calc/", varname, "/", dataname, "/nchunks_30")
    #location_inds <- 181067
    #location_inds <- 14:20
    #location_inds <- 1:50
    #location_inds <- 181067:181100
    location_inds <- read.table(paste0(workpath, "/data/oisst/data/sea_inds_lsmask.oisst.v2.txt"), header=T, quote="") # only seapoints
    location_inds <- location_inds$ind
    if (T) {
        location_inds <- location_inds[14:20] # this line will be replaced by calc_heatwaveR_loop.r
    }

} else if (T) { # awi-esm-1-1-lr_kh800
    timedimname <- "time"
    if (F) { # piControl
        dataname <- "awi-esm-1-1-lr_kh800_piControl"
        ts_from <- as.POSIXct("2686-1-1", tz="UTC")
        #ts_from <- as.POSIXct("2997-1-1", tz="UTC")
        ts_to <- as.POSIXct("3000-12-31 23:59:59", tz="UTC")
        if (F) { # not chunked
            varname <- "tos"
            heatwaveR_opts$pctile <- 90
            spatialdimnames <- "nodes_2d" # order does not matter
            files <- list.files("/work/ba1103/a270073/out/awicm-1.0-recom/awi-esm-1-1-lr_kh800/piControl/outdata/fesom",
                                pattern=glob2rx("tos_fesom_????0101.nc"), full.names=T)
            files_from <- substr(basename(files), 11, 14) # tos_fesom_29990101.nc
        } else if (T) { # chunked
            varname <- "tos"
            heatwaveR_opts$pctile <- 90
            spatialdimnames <- "nodes_2d" # order does not matter
            files <- list.files("/work/ba1103/a270073/out/awicm-1.0-recom/awi-esm-1-1-lr_kh800/piControl/outdata/post/fesom/chunked_ntime_nod2",
                                pattern=glob2rx("tos_fesom_????0101.nc"), full.names=T)
            files_from <- substr(basename(files), 11, 14) # tos_fesom_29990101.nc
        }
        clim_from <- ts_from
        clim_to <- ts_to
    } else if (F) { # historical2
        dataname <- "awi-esm-1-1-lr_kh800_historical2"
        #ts_from <- as.POSIXct("1850-1-1", tz="UTC")
        ts_from <- as.POSIXct("1982-1-1", tz="UTC")
        ts_to <- as.POSIXct("2014-12-31 23:59:59", tz="UTC")
        clim_from <- ts_from
        clim_to <- ts_to
        varname <- "tos"
        heatwaveR_opts$pctile <- 90
        spatialdimnames <- "nodes_2d" # order does not matter
        files <- list.files("/work/ba1103/a270073/out/awicm-1.0-recom/awi-esm-1-1-lr_kh800/historical2/outdata/post/fesom/chunked_ntime_nod2",
                            pattern=glob2rx("tos_fesom_????0101.nc"), full.names=T)
        files_from <- substr(basename(files), 11, 14) # tos_fesom_29990101.nc
    } else if (F) { # ssp585_2
        dataname <- "awi-esm-1-1-lr_kh800_ssp585_2"
        ts_from <- as.POSIXct("2015-1-1", tz="UTC")
        ts_to <- as.POSIXct("2100-12-31 23:59:59", tz="UTC")
        clim_from <- ts_from
        clim_to <- ts_to
        varname <- "bgc22"; units <- "mmol m-3" # oxygen
        heatwaveR_opts$pctile <- 10
        spatialdimnames <- "ncells" # order does not matter
        files <- list.files("/work/ba1103/a270073/out/awicm-1.0-recom/awi-esm-1-1-lr_kh800/ssp585_2/outdata/post/recom/chunked_ntime_nod2",
                            pattern=glob2rx("bgc22_fesom_????0101.nc"), full.names=T)
        files_from <- substr(basename(files), 13, 16) # bgc22_fesom_29990101.nc
    } else if (T) { # historical3_and_ssp585_2
        dataname <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2"
        ts_from <- as.POSIXct("1982-1-1", tz="UTC")
        ts_to <- as.POSIXct("2100-12-31 23:59:50", tz="UTC")
        clim_from <- as.POSIXct("1982-1-1", tz="UTC")
        #clim_to <- as.POSIXct("2011-12-31 23:59:59", tz="UTC")
        clim_to <- as.POSIXct("2021-12-31 23:59:59", tz="UTC")
        if (F) { # tos
            varname <- "tos"; units <- "°C"
            heatwaveR_opts$pctile <- 90
            spatialdimnames <- "nodes_2d" # order does not matter
            files <- list.files(c("/work/ab1095/a270073/out/awicm-1.0-recom/awi-esm-1-1-lr_kh800/historical3/outdata/post/fesom/chunked_ntime_nod2",
                                  "/work/ab1095/a270073/out/awicm-1.0-recom/awi-esm-1-1-lr_kh800/ssp585_2/outdata/post/fesom/chunked_ntime_nod2"),
                                pattern=glob2rx("tos_fesom_????0101*.nc"), full.names=T)
            if (F) { # from 1982 to 2021 only
                files <- files[1:40]
                ts_to <- as.POSIXct("2021-12-31 23:59:50", tz="UTC")
            }
            files_from <- substr(basename(files), 11, 14) # tos_fesom_29990101.nc
        } else if (F) { # thetao
            varname <- "thetao"; units <- "°C"
            heatwaveR_opts$pctile <- 90
            depth <- "200m"
            spatialdimnames <- "ncells" # order does not matter
            files <- list.files(c("/work/ab1095/a270073/out/awicm-1.0-recom/awi-esm-1-1-lr_kh800/historical3/outdata/post/fesom/levelwise/chunked_ntime_nod2",
                                  "/work/ab1095/a270073/out/awicm-1.0-recom/awi-esm-1-1-lr_kh800/ssp585_2/outdata/post/fesom/levelwise/chunked_ntime_nod2"),
                                pattern=glob2rx(paste0("thetao_fesom_????0101*_", depth, ".nc")), full.names=T)
            files_from <- substr(basename(files), 14, 17) # thetao_fesom_29990101_levelwise...
        } else if (T) { # chlorophyll bgc06
            varname <- "bgc06"; units <- "mmol m-3"
            heatwaveR_opts$pctile <- 10
            depth <- "0m"
            spatialdimnames <- "ncells" # order does not matter
            #spatialdimnames <- c("ncells", "depth") # order does not matter
            files <- list.files(c("/work/ab1095/a270073/out/awicm-1.0-recom/awi-esm-1-1-lr_kh800/historical3/outdata/post/recom/levelwise/chunked_ntime_nod2",
                                  "/work/ab1095/a270073/out/awicm-1.0-recom/awi-esm-1-1-lr_kh800/ssp585_2/outdata/post/recom/levelwise/chunked_ntime_nod2"),
                                pattern=glob2rx(paste0("bgc06_fesom_????0101*_", depth, ".nc")), full.names=T)
            files_from <- substr(basename(files), 13, 16) # bgc06_fesom_29990101.nc
        } else if (F) { # oxygen bgc22
            varname <- "bgc22"; units <- "mmol m-3"
            heatwaveR_opts$pctile <- 10
            depth <- "0m"
            #depth <- "200m"
            spatialdimnames <- "ncells" # order does not matter
            #spatialdimnames <- c("ncells", "depth") # order does not matter
            files <- list.files(c("/work/ab1095/a270073/out/awicm-1.0-recom/awi-esm-1-1-lr_kh800/historical3/outdata/post/recom/levelwise/chunked_ntime_nod2",
                                  "/work/ab1095/a270073/out/awicm-1.0-recom/awi-esm-1-1-lr_kh800/ssp585_2/outdata/post/recom/levelwise/chunked_ntime_nod2"),
                                pattern=glob2rx(paste0("bgc22_fesom_????0101*_", depth, ".nc")), full.names=T)
            files_from <- substr(basename(files), 13, 16) # bgc22_fesom_29990101.nc
        }
    }

    files_to <- files_from
    files_from <- paste0(files_from, "-01-01") # per
    files_to <- paste0(files_to, "-12-31")     # file
    #pathout <- paste0("/work/ba1103/a270073/post/heatwaveR/calc/", varname, "/", dataname, "/nchunks_1")
    #pathout <- paste0("/work/ba1103/a270073/post/heatwaveR/calc/", varname, "/", dataname, "/nchunks_10")
    #pathout <- paste0("/work/ba1103/a270073/post/heatwaveR/calc/", varname, "/", dataname, "/nchunks_20")
    #pathout <- paste0("/work/ba1103/a270073/post/heatwaveR/calc/", varname, "/", dataname, "/nchunks_40")
    #pathout <- paste0("/work/ba1103/a270073/post/heatwaveR/calc/", varname, "/", dataname, "/nchunks_82")
    #pathout <- paste0("/work/ba1103/a270073/post/heatwaveR/calc/", varname, "/", dataname, "/nchunks_160")
    pathout <- paste0("/work/ab1095/a270073/post/heatwaveR/calc/", varname, "/", dataname, "/nchunks_160")
    if (T) {
        location_inds <- 14:20 # 92813 # 14:20 # this line will be replaced by calc_heatwaveR_loop.r
    }

} # which setting

## slurm job runtime stats (combination of nyears and nchunks->nloc sets runtime)
# oisst,  nyears  40, nchunks:  30 -> nloc  2303[8-9]: 4.60h
# fesom1, nyears  40, nchunks:  20 -> nloc   634[2-3]: 1.43h, sd = 0.38h --> 2h
# fesom1, nyears  40, nchunks:  20 -> nloc   634[2-3]: 1.37h, sd = 0.48h --> 2h
# fesom1, nyears  40, nchunks:  82 -> nloc   154[7-8]: 0.22h, sd = 0.04h --> 0.3h
# fesom1, nyears 119, nchunks:  82 -> nloc   154[7-8]: 0.88h, sd = 0.75h --> 2h
# fesom1, nyears 119, nchunks:  82 -> nloc   154[7-8]: 1.12h, sd = 0.56h --> 2h
# fesom1, nyears 119, nchunks:  82 -> nloc   154[7-8]: 1.28h, sd = 1.31h --> 3h # trend removed
# fesom1, nyears 119, nchunks:  82 -> nloc   154[7-8]: 1.59h, sd = 1.43h --> 4h
# fesom1, nyears 119, nchunks:  82 -> nloc   154[7-8]: 2.06h; sd = 1.5h --> 4h
# fesom1, nyears 119, nchunks:  82 -> nloc   154[7-8]: 2.77h, sd = 1.4h --> 5h
# fesom1, nyears 119, nchunks: 160 -> nloc    79[2-3]: 0.41h, sd = 0.4h --> 1h
# fesom1, nyears 119, nchunks: 160 -> nloc    79[2-3]: 0.6h, sd = 0.46h --> 2h
# fesom1, nyears 119, nchunks: 160 -> nloc    79[2-3]: 0.77h, sd = 0.5h --> 2h # trend removed
# fesom1, nyears 119, nchunks: 160 -> nloc    79[2-3]: 1.79h, sd = 1.37h --> 4h # trend removed
# fesom1, nyears 119, nchunks: 160 -> nloc    79[2-3]: 3.61h, sd = 0.77h --> 5h # running mean 15a
# fesom1, nyears 119, nchunks: 160 -> nloc    79[2-3]: 3.37h, sd = 0.67h --> 5h # running mean 15a
# fesom1, nyears 119, nchunks: 160 -> nloc    79[2-3]: 3.99h, sd = 0.81h --> 5h # running mean 31a
# fesom1, nyears 119, nchunks: 160 -> nloc    79[2-3]: 4.08h, sd = 0.81h --> 5h # running mean 31a
# fesom1, nyears 119, nchunks: 160 -> nloc    79[2-3]: 4.09h, sd = 0.38h --> 5h # running mean 15a
# fesom1, nyears 119, nchunks: 160 -> nloc    79[2-3]: 4.23h, sd = 0.97h --> 6h # running mean 15a
# fesom1, nyears 119, nchunks: 160 -> nloc    79[2-3]: 4.91h, sd = 0.63h --> 6h # running mean 31a
# fesom1, nyears 119, nchunks: 160 -> nloc    79[2-3]: 5.91h, sd = 0.96h --> 7h # running mean 31a
# fesom1, nyears 165, nchunks:  40 -> nloc   317[1-2]: 2.23h
# fesom1, nyears 315, nchunks:  82 -> nloc   158[5-7]: 2.69h
# composite_heatwaveR.r needs not more than nloc = ~350
if (F) { # plot runtime
    nyears <- c(40, 40, 40, 40, 119, 119, 119, 119, 165, 315)
    nchunks <- c(30, 20, 20, 82, 82, 82, 82, 82, 40, 82)
    nlocs <- c(23038.5, 6342.5, 6342.5, 1547.5, 1547.5, 1547.5, 1547.5, 1547.5, 3171.5, 1585.5)
    elapseds <- c(4.6, 1.43, 1.37, 0.22, 2.77, 1.59, 1.12, 0.88, 2.23, 2.69)
    if (length(nyears) != length(nchunks)) stop("asd")
    if (length(nlocs) != length(elapseds)) stop("asd")
    if (length(nyears) != length(nlocs)) stop("asd")
    plot(nlocs, nyears, t="n", xlab="nlocs x 1e3", ylab="nyears", xaxt="n", yaxt="n")
    axis(1, pretty(nlocs, n=10), labels=pretty(nlocs/1e3, n=10))
    axis(2, pretty(nyears, n=10), las=2)
    text(nlocs, nyears, paste0(elapseds, "h"))
    par(new=T)
    plot(nchunks, nyears, t="n", xlim=rev(range(nchunks)), xlab="", ylab="", axes=F)
    axis(3, pretty(nchunks))
    mtext("nchunks", side=3, line=2)
}

#############################################

# check
if (!exists("dataname")) stop("provide `dataname <- \"<unique_name_of_dataset>\"`")
if (!exists("varname")) stop("provide `varname <- \"<name_of_variable_to_calc_mhw_from>\"`")
message("check user input for variable ", varname, " of dataset ", dataname, " ...")
if (!exists("timedimname")) stop("provide `timedimname <- \"<name_of_time_dim>\"")
if (length(timedimname) != 1) stop("`timedimname` = ", timedimname, " must be of length 1")
if (!exists("spatialdimnames")) {
    stop("provide `spatialdimnames <- c(\"<name_of_lon_dim>\", \"<name_of_lat_dim>\")` or \"<name_of_spatial_dim>\"")
}
nspatialdims <- length(spatialdimnames)
if (!exists("ts_from")) stop("provide `ts_from` as posix")
if (!exists("ts_to")) stop("provide `ts_to` as posix")
if (!any(grep("POSIX", class(ts_from)))) stop("`ts_from` must be of class POSIX*")
if (!any(grep("POSIX", class(ts_to)))) stop("`ts_to` must be of class POSIX*")
ts_from_posixlt <- as.POSIXlt(ts_from)
ts_to_posixlt <- as.POSIXlt(ts_to)

# check heatwaveR settings
if (!any(names(heatwaveR_opts) == "minDuration")) stop("set `heatwaveR_opts$minDuration`")
if (!any(names(heatwaveR_opts) == "pctile")) stop("set `heatwaveR_opts$pctile`")
if (heatwaveR_opts$pctile == 90) { # mhw -> extremes above high percentile
    heatwaveR_opts$pctile <- 90        # for heatwaveR::ts2clm(); default: 90
    heatwaveR_opts$coldSpells <- F     # for heatwaveR::detect_event(); default: F
} else if (heatwaveR_opts$pctile == 10) { # mcs -> extremes below low percentile
    heatwaveR_opts$pctile <- 10
    heatwaveR_opts$coldSpells <- T
    if (any(varname == c("sst", "tos", "thetao"))) { # add seawater temperature names here
        heatwaveR_opts$MCScorrect <- T
    }
} else {
    stop("`heatwaveR_opts$pctile` ", heatwaveR_opts$pctile, " not yet implemented")
}
if (!any(names(heatwaveR_opts) == "clim_runmean")) stop("set `heatwaveR_opts$clim_runmean`")
if (!any(names(heatwaveR_opts) == "coldSpells")) stop("set `heatwaveR_opts$coldSpells`")
if (!any(names(heatwaveR_opts) == "MCScorrect")) stop("set `heatwaveR_opts$MCScorrect`")
if (!any(names(heatwaveR_opts) == "remove_trend")) heatwaveR_opts$remove_trend <- F
if (!any(names(heatwaveR_opts) == "climatology")) heatwaveR_opts$climatology <- F
if (!any(names(heatwaveR_opts) == "calc_trend")) heatwaveR_opts$calc_trend <- T
if (!any(names(heatwaveR_opts) == "var")) heatwaveR_opts$var <- T
if (!any(names(heatwaveR_opts) == "roundClm")) heatwaveR_opts$roundClm <- F
if (!any(names(heatwaveR_opts) == "packageVersion")) heatwaveR_opts$packageVersion <- utils::packageVersion("heatwaveR")
message("\nheatwaveR_opts:")
cat(capture.output(str(heatwaveR_opts)), sep="\n")

# check clim
if (is.na(heatwaveR_opts$clim_runmean)) { # fixed baseline
    if (!exists("clim_from")) stop("`heatwaveR_opts$clim_runmean` is false --> provide `clim_from` as posix")
    if (!exists("clim_to")) stop("`heatwaveR_opts$clim_runmean` is false --> provide `clim_to` as posix")
    if (!any(grep("POSIX", class(clim_from)))) stop("`clim_from` must be of class POSIX*")
    if (!any(grep("POSIX", class(clim_to)))) stop("`clim_to` must be of class POSIX*")
    clim_from_posixlt <- as.POSIXlt(clim_from)
    clim_to_posixlt <- as.POSIXlt(clim_to)
    clim_nyears <- clim_to_posixlt$year - clim_from_posixlt$year + 1
    climatologyPeriod <- format(c(clim_from, clim_to), "%Y-%m-%d")
} else if (is.numeric(heatwaveR_opts$clim_runmean)) { # apply running mean
    if (heatwaveR_opts$remove_trend) {
        stop("cannot do both, applying running mean AND removing trend --> decide for one or none")
    }
    if (heatwaveR_opts$clim_runmean %% 2 != 1) { # must be odd number
        stop("`heatwaveR_opts$clim_runmean` must be NA or odd number of years")
    }
    clim_nyears <- heatwaveR_opts$clim_runmean
    clim_from <- ts_from # use all years of time
    clim_to <- ts_to     # series for running mean
    clim_from_posixlt <- as.POSIXlt(clim_from)
    clim_to_posixlt <- as.POSIXlt(clim_to)
} else {
    stop("`heatwaveR_opts$clim_runmean` must either be NA or the number of years of the running mean")
}
if (clim_nyears < 3) {
    stop("provided climatology period of ", clim_nyears, " yrs < minimum 3 yrs")
}

# check
if (!exists("files")) stop("provide `files <- \"/abs/paths/to/files\"`")
if (length(files) == 0) stop("provided zero `files`")
if (!exists("files_from")) stop("provide `files_from <- \"start dates per file as \"YYYY-MM-DD\"`")
if (!exists("files_to")) stop("provide `files_to <- \"end dates per file as \"YYYY-MM-DD\"`")
files_from <- as.POSIXct(files_from, tz="UTC")
files_to <- as.POSIXct(files_to, tz="UTC")
if (!exists("pathout")) stop("provide `pathout <- \"/path/to/save/results/which/can/be/huge\"`")
if (!dir.exists(pathout)) dir.create(pathout, recursive=T, showWarnings=F)
if (file.access(pathout, 2) == -1) stop("no write permission to `pathout` = \"", pathout, "\"")
pathout <- normalizePath(pathout)
if (exists("location_inds")) {
    if (!is.null(location_inds)) {
        if (!is.vector(location_inds)) stop("non-NULL `location_inds` must be vector")
        if (!all(is.finite(location_inds))) stop("non-NULL `location_inds` must all be finite")
        if (any(location_inds < 1)) stop("non-NULL `location_inds` must all be larger or equal 1")
    }
} else {
    location_inds <- NULL
}

# check if files are not in temporal order
inds <- order(files_from)
if (!all(diff(inds) == 1)) stop("`files_from` from files are not in temporal increasing order")
inds <- order(files_to)
if (!all(diff(inds) == 1)) stop("`files_to` from files are not in temporal increasing order")

# filter files
ts_inds <- which(files_from >= ts_from & files_to <= ts_to)
if (length(ts_inds) == 0) stop("found zero files from ts_from=", ts_from, " to ts_to=", ts_to)
clim_inds <- which(files_from >= clim_from & files_to <= clim_to)
if (length(clim_inds) == 0) stop("found zero files from clim_from=", clim_from, " to clim_to=", clim_to)
inds <- sort(union(ts_inds, clim_inds)) # sort not necessary?
nfiles <- length(inds)
if (nfiles != length(files)) {
    message("\nfilter ", nfiles, "/", length(files), " files between\n",
            "ts_from=", ts_from, " to ts_to=", ts_to, " and\n",
            "clim_from=", clim_from, " to clim_to=", clim_to, " ...")
}
files <- data.frame(file=files[inds], from=files_from[inds], to=files_to[inds])
message("\nprocess ", nfiles, " files:")
options(width=400)
print(files)
options(width=op_width)

# open all files
message("\nopen ", nfiles, " files ...")
ncs <- time_list <- vector("list", length=nfiles)
for (fi in seq_along(files$file)) {

    message("open file ", fi, "/", nfiles, ": ", files$file[fi])
    ncs[[fi]] <- ncdf4::nc_open(files$file[fi])

    if (fi == 1) {
        # check varname
        if (!any(names(ncs[[fi]]$var) == varname)) {
            stop("not any variable is called `varname` = \"", varname, "\".\n",
                 length(ncs[[fi]]$var), " available variables: \"",
                 paste(names(ncs[[fi]]$var), collapse="\", \""), "\".")
        }
        varname_atts <- ncatt_get(ncs[[fi]], varname)
        if (is.null(varname_atts$units)) {
            message("this variable has no attribute called \"units\"\n",
                    "--> use user provided `units` ...")
            if (!exists("units")) stop("provide `units <- \"<unit of this variable\"` in header part")
            varname_atts$units <- units
        }
        # check dimnames
        vardimids <- sapply(ncs[[fi]]$var[[varname]]$dim, "[[", "id") + 1
        dimids <- sapply(ncs[[fi]]$dim, "[[", "id") + 1
        vardimnames_in <- names(dimids)[vardimids]
        if ((nspatialdims + 1) != length(vardimnames_in)) { # +1 for time dim
            stop("provided 1 time dim and ", nspatialdims, " spatial dims (\"",
                 paste(spatialdimnames, collapse="\", \""), "\"), i.e. ", nspatialdims + 1,
                 " dims but variable ", varname, " has ", length(vardimnames_in), " dims: \"",
                 paste(vardimnames_in, collapse="\", \""),
                 "\". modify `spatialdimnames` and rerun script")
        }
        # check spatial dim(s)
        spatial_dims <- vector("list", length=nspatialdims)
        names(spatial_dims) <- spatialdimnames
        for (si in seq_len(nspatialdims)) {
            spatial_dims[[si]] <- list(len=ncs[[fi]]$dim[[spatialdimnames[si]]]$len,
                                       vals=ncs[[fi]]$dim[[spatialdimnames[si]]]$vals,
                                       units=ncs[[fi]]$dim[[spatialdimnames[si]]]$units)
        }
        nspatial_vals <- sapply(spatial_dims, "[[", "len")
        ntot <- prod(nspatial_vals)
        if (!is.null(location_inds)) {
            if (any(location_inds > ntot)) stop("non-NULL `location_inds` must all be less or equal ", ntot)
        }
    } # if fi == 1

    # check chunks of current variable
    chunksizes <- ncs[[fi]]$var[[varname]]$chunksizes
    msg <- NULL
    if (all(is.na(chunksizes))) { # variable is not chunked
        msg <- paste0("variable ", varname, " of this file is not chunked: `ncdump -hs ", ncs[[fi]]$filename,
                      " | grep ", varname, ":_ChunkSizes` returns nothing\n")
    } else { # if file is chunked
        if (length(chunksizes) != length(vardimnames_in)) stop("never happened")
        names(chunksizes) <- vardimnames_in
        # does the time dim chunk length equal the complete time dim length?
        if (chunksizes[which(vardimnames_in == timedimname)] != ncs[[fi]]$dim[[timedimname]]$len) {
            msg <- paste0("variable ", varname, " of this file is chunked (",
                          paste(paste0(names(chunksizes), "=", chunksizes), collapse=","), ")\n")
        }
    }
    if (!is.null(msg)) {
        msg_dims <- rep(1, t=nspatialdims)
        if (nspatialdims == 1) {
            msg_dims[1] <- spatial_dims[[1]]$len
        } else if (nspatialdims == 2) {
            # tested so far: chunk the longest of all spatial dims, e.g. (366,1,1440) and not (366,720,1)
            msg_dims[which.max(nspatial_vals)] <- nspatial_vals[which.max(nspatial_vals)]
        } else {
            stop(nspatialdims, "-dim case ", paste(spatialdimnames, collapse=","), " not defined")
        }
        msg <- paste0(msg,
                      "--> this is inefficient for reading time series\n",
                      "--> prepare the data by running `nccopy -u -w -c time/", ncs[[fi]]$dim[[timedimname]]$len, ",",
                      paste(paste0(spatialdimnames, "/", msg_dims), collapse=","), " $fin $fout`\n",
                      "    and rerun this script with $fout.")
        stop(msg)
    } # is msg is not null

    # get time of current file
    timeunit <- ncs[[fi]]$dim[[timedimname]]$unit
    if (grepl(" since ", timeunit)) {
        timeorigin <- substr(timeunit,
                             regexpr(" since ", timeunit) + 7,
                             nchar(timeunit))
        if (grepl("days ", timeunit)) {
            timefac <- 86400 # day --> sec
        } else if (grepl("seconds ", timeunit)) {
            timefac <- 1 # sec --> sec
        } else {
            stop("relative timeunit interval \"", timeunit, "\" not defined")
        }
    } else {
        stop("timeunit \"", timeunit, "\" not defined")
    }
    # todo: is this faster than using `cdo showtimestamp`?
    timevals <- as.POSIXct(ncs[[fi]]$dim[[timedimname]]$vals*timefac, origin=timeorigin, tz="UTC")
    timelen <- length(timevals)
    timerange <- range(timevals)
    message("converted ", timelen, " time points in ", timeunit, " (origin=", timeorigin,
            ", fac=", timefac, ") to posix from ", timerange[1], " to ", timerange[2])
    if (timerange[1] < files$from[fi]) {
        tmp1 <- as.POSIXlt(timerange[1])
        tmp2 <- as.POSIXlt(files$from[fi])
        message("earliest date of this file (", tmp1, ") is before given filename year ", tmp2, appendLF=F)
        if (tmp1$year == tmp2$year && tmp1$mon == tmp2$mon && tmp1$mday == tmp2$mday) { # same year,month,day
            message(" --> but its the same day. continue")
        } else {
            stop("\nchange time range of files")
        }
    }
    if (timerange[2] > files$to[fi]) {
        tmp1 <- as.POSIXlt(timerange[2])
        tmp2 <- as.POSIXlt(files$to[fi])
        message("--> latest date of this file (", tmp1, ") is after given filename year ", tmp2, appendLF=F)
        if (tmp1$year == tmp2$year && tmp1$mon == tmp2$mon && tmp1$mday == tmp2$mday) { # same year,month,day
            message(" --> but its the same day. continue")
        } else {
            stop("\nchange time range of files")
        }
    }
    time_list[[fi]] <- list(len=timelen, unit=timeunit, origin=timeorigin, fac=timefac, vals=timevals)

} # for fi
time_numeric <- unlist(lapply(time_list, "[[", "vals")) # same effect as `as.numeric`
time <- as.POSIXct(time_numeric, origin="1970-1-1", tz="UTC")
ntime <- length(time)
message("\ntime:")
cat(capture.output(str(time, vec.len=20)), sep="\n")
dt_day <- difftime(time[2:ntime], time[1:(ntime-1)], units="day")
if (!all(unique(dt_day) == 1)) { # todo: allow non-daily data?
    stop("dt of input time is ", paste(unique(dt_day), collapse=", "), " day(s) != 1 day")
}
rm(dt_day)

# for running mean below
time_posixlt <- as.POSIXlt(time)
years_unique <- unique(time_posixlt$year+1900L)

# update initially provided ts_from, ts_to, clim_from, clim_to with actual time series time dim vals
ts_from_ind <- which.min(abs(time - ts_from))
ts_to_ind <- which.min(abs(time - ts_to))
ts_from <- time[ts_from_ind]
ts_to <- time[ts_to_ind]
ts_from_posixlt <- as.POSIXlt(ts_from)
ts_to_posixlt <- as.POSIXlt(ts_to)
clim_from_ind <- which.min(abs(time - clim_from))
clim_to_ind <- which.min(abs(time - clim_to))
clim_from <- time[clim_from_ind]
clim_to <- time[clim_to_ind]
clim_from_posixlt <- as.POSIXlt(clim_from)
clim_to_posixlt <- as.POSIXlt(clim_to)
message("\ngot ", ntime, " input timepoints from ", min(time), " to ", max(time), "\n",
        "--> ts_from = ", ts_from, " to ts_to = ", ts_to, "\n",
        "--> clim_from = ", clim_from, " to clim_to = ", clim_to)

# get dt of complete time series in years
ts_to_p1d <- ts_to + 86400L # plus 1 day
ts_to_p1d_posixlt <- as.POSIXlt(ts_to_p1d)
dpm <- c(Jan=31, Feb=28, Mar=31, Apr=30, May=31, Jun=30, Jul=31, Aug=31, Sep=30, Oct=31, Nov=30, Dec=31)
if (ts_from_posixlt$mon+1 == 2 &&
    ((((ts_from_posixlt$year+1900) %% 4 == 0) & ((ts_from_posixlt$year+1900) %% 100 != 0)) | ((ts_from_posixlt$year+1900) %% 400 == 0))) { # leap year
    ts_from_yr <- ts_from_posixlt$year+1900 +       # assuming
                    (ts_from_posixlt$mon)/12 +      # start of day
                    (ts_from_posixlt$mday-1)/29/12  # --> hour = min = sec = 0
} else {
    ts_from_yr <- ts_from_posixlt$year+1900 +                               # assuming
                    (ts_from_posixlt$mon)/12 +                              # start of day
                    (ts_from_posixlt$mday-1)/dpm[ts_from_posixlt$mon+1]/12  # --> hour = min = sec = 0
}
if (ts_to_p1d_posixlt$mon+1 == 2 &&
    ((((ts_to_p1d_posixlt$year+1900) %% 4 == 0) & ((ts_to_p1d_posixlt$year+1900) %% 100 != 0)) | ((ts_to_p1d_posixlt$year+1900) %% 400 == 0))) { # leap year
    ts_to_yr <- ts_to_p1d_posixlt$year+1900 +
                    (ts_to_p1d_posixlt$mon)/12 +
                    (ts_to_p1d_posixlt$mday-1)/29/12# +
                    #23/24/29/12 +       # assuming
                    #59/60/24/29/12 +    # full day
                    #59/60/60/24/29/12   # by using +1 day
} else {
    ts_to_yr <- ts_to_p1d_posixlt$year+1900 +
                    (ts_to_p1d_posixlt$mon)/12 +
                    (ts_to_p1d_posixlt$mday-1)/dpm[ts_to_p1d_posixlt$mon+1]/12# +
                    #23/24/dpm[ts_to_posixlt$mon+1]/12 +       # assuming
                    #59/60/24/dpm[ts_to_posixlt$mon+1]/12 +    # full day
                    #59/60/60/24/dpm[ts_to_posixlt$mon+1]/12   # by using + 1 day
}
ts_dt_yrs <- unname(ts_to_yr - ts_from_yr) # e.g. from 1982-05-31 to 1983-05-31 = 1983.417 - 1982.414 =   1.002688 yrs
                                           #      from 1982-01-01 to 2101-12-31 = 2101     - 1982     = 119        yrs
message("--> ts_dt_yrs = ", ts_dt_yrs, " years")

if (F) { # update
    message("climatology from clim_from=", clim_from, " to clim_to=", clim_to)
    if (clim_from < min(time)) {
        message("--> start of clim period is before first date of time series data")
        tmp1 <- as.POSIXlt(clim_from)
        if (tmp1$year == ts_from_posixlt$year && tmp1$mon == ts_from_posixlt$mon && tmp1$mday == ts_from_posixlt$mday) { # same year,month,day
            message("--> but its the same day --> continue")
        } else {
            stop("change time range of data and/or `clim_from`")
        }
    }
    if (clim_to > max(time)) {
        message("--> end of clim period is later than last date of time series data")
        tmp1 <- as.POSIXlt(clim_to)
        if (tmp1$year == ts_to_posixlt$year && tmp1$mon == ts_to_posixlt$mon && tmp1$mday == ts_to_posixlt$mday) { # same year,month,day
            message("--> but its the same day --> continue")
        } else {
            stop("change time range of data and/or `clim_to`")
        }
    }
}

# make spatial index mapping for looping through locations
message("\nmake mapping (", nspatialdims, "-spatial-dims inds) <--> (1-spatial-dim inds) for looping through locations ...")
if (nspatialdims == 1) { # e.g. irregular fesom
    mapping_df <- as.data.frame(seq_len(nspatial_vals[1])) # (ntot,1)
} else if (nspatialdims == 2) { # e.g. lon, lat
    mapping_df <- expand.grid(seq_len(nspatial_vals[1]), seq_len(nspatial_vals[2]), KEEP.OUT.ATTRS=F) # (ntot,2)
} else {
    stop("mapping not defined yet for this ", nspatialdims, "-dim case")
}
names(mapping_df) <- spatialdimnames

# find spatial locations if wanted
message("\nselect locations for mhw calculation ...")
if (!is.null(location_inds)) {
    nloc <- length(location_inds)
    message("`location_inds` is not NULL --> continue with ", nloc, "/", ntot,
            " locations from ", location_inds[1], " to ", location_inds[nloc], " ...")
    mapping_df <- mapping_df[location_inds,,drop=F]
} else { # `location_inds` not given --> use all values
    nloc <- ntot
    message("`location_inds` is NULL --> use all ", nloc, " locations ...")
    location_inds <- seq_len(nloc)
}

# construct fout
fout <- paste0(pathout, "/",
               ifelse(heatwaveR_opts$coldSpells, "mcs", "mhw"),
               "_calc_", varname,
               ifelse(is.null(depth), "", paste0("_", depth)),
               "_ts_", format(ts_from, "%Y%m%d"), "-", format(ts_to, "%Y%m%d"),
               "_clim_",  format(clim_from, "%Y%m%d"), "-", format(clim_to, "%Y%m%d"),
               "_pctile_", heatwaveR_opts$pctile,
               "_minDuration_", heatwaveR_opts$minDuration,
               "_", ifelse(is.na(heatwaveR_opts$clim_runmean), "fixed_baseline", paste0("runmean_", heatwaveR_opts$clim_runmean, "a")),
               "_", ifelse(heatwaveR_opts$remove_trend, "wout", "with"), "Trend",
               "_locinds_",
               sprintf(paste0("%0", nchar(ntot), "i"), location_inds[1]), "-",
               sprintf(paste0("%0", nchar(ntot), "i"), location_inds[nloc]),
               "_nloc_", nloc,
               ".RData")
message("\nsave results to fout = ", fout)
if (file.exists(fout)) stop("this file already exists")

# calc and save MHW stuff for nloc time series
message("\ncalc heatwaveR (version ", heatwaveR_opts$packageVersion, ") parameters at ", nloc, "/", ntot," locations from (",
        paste(paste0(names(mapping_df), "=", mapping_df[1,]), collapse=","), ") to (",
        paste(paste0(names(mapping_df), "=", mapping_df[nloc,]), collapse=","), ") ...")
clms <- events <- cats <- opts <- list()
if (heatwaveR_opts$calc_trend || heatwaveR_opts$remove_trend) lms <- clms
cnt <- 0
elapsed_all <- rep(NA, t=nloc)
for (loci in seq_len(nloc)) {
    locinds <- unlist(mapping_df[loci,])
    locvals <- rep(NA, t=nspatialdims)
    names(locvals) <- names(locinds)
    for (si in seq_len(nspatialdims)) {
        locvals[si] <- spatial_dims[[si]]$vals[locinds[si]]
    }
    start <- rep(1, t=length(vardimnames_in))
    names(start) <- vardimnames_in
    count <- start
    start[match(spatialdimnames, vardimnames_in)] <- locinds
    count[match(timedimname, vardimnames_in)] <- -1 # all values of time dim
    message("read chunk loc ", loci, "/", nloc, " (tot loc ", location_inds[loci], "/", ntot,
            "), inds: (", paste(paste0(names(mapping_df), "=", locinds, "/", nspatial_vals), collapse=","),
            "), vals: (", paste(paste0(names(mapping_df), "=", locvals), collapse=","), ") from ",
            nfiles, " files ... ", appendLF=F) # keep line for elapsed
    #print(start)
    #stop("asd")
    #if (loci == 100) stop("asd")
    data <- vector("list", length=nfiles)
    elapsed <- system.time({
        for (fi in seq_along(ncs)) {
            #count[which(vardimnames_in == vardimnames["time"])] <- ncs[[fi]]$dim[[vardimnames["time"]]]$len
            #print(count)
            data[[fi]] <- ncdf4::ncvar_get(ncs[[fi]], varname, start=start, count=count)
        } # for fi
        data <- unlist(data)
    })
    # time,lat,lon chunked 1,720,1440
    # ntime 366: 7.473 sec = 0.12 min
    # ntime 10958: 206 sec = 3.43 min, 274 sec = 4.56 min, 209 sec = 3.48 min, 225.814 sec = 3.76 min
    # lon,lat,time chunked 720,1440,1
    # ntime 366: 8.348 sec = 0.14 min, 8.109 sec = 0.14 min
    # ntime 10958: 247.93 sec = 4.13 min, 253.45 sec = 4.224 min
    # time,lat,lon chunked 366,720,1:
    # ntime: 8766: 0.352 sec = 0.006 min
    # ntime: 10958: 0.626 sec = 0.01 min, 0.527 sec = 0.009 min, 0.271 sec = 0.005 min, 0.735 sec = 0.012 min
    # mean over 4000 locations * 30 files = 0.195861 sec
    # time,lat,lon chunked 366,1,1440:
    # ntime: 10958: 0.441 sec = 0.007 min, 0.222 sec = 0.004 min, 0.436 sec = 0.007 min, 0.148 sec = 0.002 min
    # mean over 4000 locations * 30 files = 0.008778555 sec
    elapsed_all[loci] <- elapsed[3] # sec
    message(round(elapsed[3], 3), " sec = ", round(elapsed[3]/60, 3), " min")
    if (all(is.na(data))) {
        # skip to next location
    } else {

        # calc linear trend of time series
        if (heatwaveR_opts$calc_trend || heatwaveR_opts$remove_trend) {
            message("`heatwaveR_opts$calc_trend`=", ifelse(heatwaveR_opts$calc_trend, "T", "F"),
                    " (`heatwaveR_opts$remove_trend`=", ifelse(heatwaveR_opts$remove_trend, "T", "F"),
                    ") --> run stats::lm ... ", appendLF=F)
            if (ntime <= 3) {
                message("ts length ", ntime, " <= 3 too short for lm. skip")
                lm <- NA
            } else {
                lm <- stats::lm(data ~ as.numeric(time))
                lm_summary <- summary(lm)
                if (!is.na(lm_summary$coefficients[2,4])) { # if lm was successfull
                    lm_slope_pyr <- unname((lm$fitted.values[ntime] - lm$fitted.values[1])/ts_dt_yrs)
                    attr(lm_slope_pyr, "units") <- varname_atts$units
                    lm_label <- paste0("r=", round(sqrt(lm_summary$r.squared), 2), ", p")
                    lm_pval <- lm_summary$coefficients[2,4]
                    if (lm_pval < 1e-4) {
                        lm_label <- paste0(lm_label, "<1e-4")
                    } else {
                        lm_label <- paste0(lm_label, "=", round(lm_pval, 4))
                    }
                    lm_label <- paste0(lm_label, ", df=", lm_summary$fstatistic["dendf"])
                    message("ok (", round(lm_slope_pyr, 5), " ", varname_atts$units, " / yr; ", lm_label, ")")
                    # save lm summary only
                    lm_summary$call <- lm_summary$terms <- lm_summary$residuals <- lm_summary$aliased <- NULL
                    if (heatwaveR_opts$remove_trend) lm_fit <- lm$fitted.values
                    lm <- list(summary=lm_summary,
                               slope_pyr=lm_slope_pyr,
                               r=sqrt(lm_summary$r.squared),
                               df=unname(lm_summary$fstatistic["dendf"]),
                               p=lm_pval,
                               label=lm_label) # 5.6 Kb per location
                } else { # if lm was not successfull
                    lm <- NA
                }
            } # if ntime > 3
        } # if heatwaveR_opts$calc_trend || heatwaveR_opts$remove_trend

        # remove linear trend of time series before heatwaveR calculations
        if (heatwaveR_opts$remove_trend && all(is.na(lm))) {
            message("linear trend calculation was not successfull. skip location")
            # skip to next location

        } else { # calc extreme events

            # detrend time series from `ts_from` to `ts_to`
            if (heatwaveR_opts$remove_trend) {
                message("`heatwaveR_opts$remove_trend` is true --> remove linear temporal trend from original time series ...")
                data <- data - lm_fit
                rm(lm_fit)
            }

            # prepare for heatwaveR functions
            data <- data.frame(t=as.Date(time), temp=data) # todo: column names must be t and temp

            # get climatology and threshold
            if (!is.na(heatwaveR_opts$clim_runmean)) { # calc clim/thresh wrt running mean
                message("`heatwaveR_opts$clim_runmean` = ", heatwaveR_opts$clim_runmean,
                        " != NA --> run heatwaveR::ts2lim ", length(years_unique), " times for every year ...")
                seas <- thresh <- rep(NA, t=ntime)
                for (yi in seq_along(years_unique)) {
                    climatologyPeriod <- as.POSIXlt(c(paste0(max(years_unique[yi] - floor(heatwaveR_opts$clim_runmean/2), ts_from_posixlt$year+1900L), format(clim_from, "-%m-%d")),
                                                      paste0(min(years_unique[yi] + floor(heatwaveR_opts$clim_runmean/2), ts_to_posixlt$year+1900L), format(clim_to, "-%m-%d"))))
                    message("--> year ", yi, "/", length(years_unique), ": ", years_unique[yi],
                            ": climatologyPeriod = ", paste(climatologyPeriod, collapse=" to "), " (", climatologyPeriod$year[2] - climatologyPeriod$year[1] + 1, " years)")
                    clm <- heatwaveR::ts2clm(data,
                                             climatologyPeriod=climatologyPeriod,
                                             pctile=heatwaveR_opts$pctile,
                                             var=heatwaveR_opts$var,
                                             roundClm=heatwaveR_opts$roundClm
                                             )
                    inds <- which(time_posixlt$year+1900L == years_unique[yi])
                    if (length(inds) == 0) stop("this should not happen")
                    if (length(inds) > 366) stop("this should not happen")
                    seas[inds] <- clm$seas[seq_along(inds)] # first 365/366
                    thresh[inds] <- clm$thresh[seq_along(inds)] # first 365/366
                } # for yi
                clm$seas <- seas
                clm$thresh <- thresh
                rm(seas, thresh)

            } else { # calc clim/thresh wrt fixed baseline or detrended
                message("`heatwaveR_opts$clim_runmean` is NA --> run heatwaveR::ts2lim with climatologyPeriod from ",
                        paste(climatologyPeriod, collapse=" to "), " ...")
                clm <- heatwaveR::ts2clm(data,
                                         climatologyPeriod=climatologyPeriod,
                                         pctile=heatwaveR_opts$pctile,
                                         var=heatwaveR_opts$var,
                                         roundClm=heatwaveR_opts$roundClm
                                         ) # ~480K for ~11k ntime
            }

            # calls in `ts2clm`:
            # 1)    ts_xy <- data.table::data.table(ts_x = ts_x, ts_y = ts_y)[base::order(ts_x)]
            # --> Classes ‘data.table’ and 'data.frame':  43464 obs. of  2 variables:
            # $ ts_x: Date, format: "1982-01-01" "1982-01-02" ...
            # $ ts_y: num  -1.62 -1.63 -1.63 -1.63 -1.62 ...
            # 2)    ts_whole <- make_whole_fast(ts_xy)
            # --> Classes ‘data.table’ and 'data.frame':  43464 obs. of  3 variables:
            # $ doy : int  1 2 3 4 5 6 7 8 9 10 ...
            # $ ts_x: Date, format: "1982-01-01" "1982-01-02" ...
            # $ ts_y: num  -1.62 -1.63 -1.63 -1.63 -1.62 ...
            # 3)    ts_wide <- clim_spread(ts_whole, clim_start, clim_end, windowHalfWidth)
            # ts_clim <- data.table::as.data.table(data)[ts_x %between% c(clim_start, clim_end)]
            # --> num [1:376, 1:119] -0.3379 -0.1992 -0.0399 0.2993 0.8453 ...
            # --> [dpy(+/- smoothing window), nyears]
            # - attr(*, "dimnames")=List of 2
            #  ..$ : NULL
            #  ..$ : chr [1:119] "1982" "1983" "1984" "1985" ...
            # 4)    ts_mat <- clim_calc(ts_wide, windowHalfWidth, pctile)
            # --> default windowHalfWidth = 5 days
            # for (i in (windowHalfWidth + 1):((nrow(data) - windowHalfWidth))) {
            #    seas[i] <- mean(c(t(data[(i - (windowHalfWidth)):(i +
            #        windowHalfWidth), seq_len(ncol(data))])), na.rm = TRUE)
            #    thresh[i] <- stats::quantile(c(t(data[(i - (windowHalfWidth)):(i +
            #        windowHalfWidth), seq_len(ncol(data))])), probs = pctile/100,
            #        type = 7, na.rm = TRUE, names = FALSE)
            # } # for i
            # -->   seas[doy i] = mean(    data[doy i, all years], na.rm=T)
            # --> thresh[doy i] = quantile(data[doy i, all years], quant=90/100)
            # len_clim_year <- 366
            # seas <- seas[(windowHalfWidth + 1):((windowHalfWidth) + len_clim_year)]
            # thresh <- thresh[(windowHalfWidth + 1):((windowHalfWidth) + len_clim_year)]
            # --> num [1:366, 1:4] 1 2 3 4 5 6 7 8 9 10 ...
            # - attr(*, "dimnames")=List of 2
            #  ..$ : NULL
            #  ..$ : chr [1:4] "doy" "seas" "thresh" "var"
            # 5) ts_clim <- smooth_percentile(ts_mat, smoothPercentileWidth, var)
            # --> default smoothPercentileWidth = 31 days
            # prep <- rbind(utils::tail(data[, -1], smoothPercentileWidth),
            #               data[, -1],
            #               utils::head(data[, -1], smoothPercentileWidth))
            # len_clim_year <- 366
            # seas <- RcppRoll::roll_mean(as.numeric(prep[, 1]), n = smoothPercentileWidth, na.rm = FALSE)
            # thresh <- RcppRoll::roll_mean(as.numeric(prep[, 2]), n = smoothPercentileWidth, na.rm = FALSE)
            # clim <- data.table::data.table(doy = seq_len(len_clim_year),
            #                                seas   =   seas[(smoothPercentileWidth/2 + 2):((smoothPercentileWidth/2 + 1) + len_clim_year)],
            #                                thresh = thresh[(smoothPercentileWidth/2 + 2):((smoothPercentileWidth/2 + 1) + len_clim_year)])
            # --> take `RcppRoll::roll_mean` result from `inds=c(17.5,18.5,...,381.5,382.5)` (smoothPercentileWidth=31; get coerced down: 17,...)
            # 6) ts_res <- merge(ts_whole, ts_clim, all = TRUE)
            # --> repeat clim/thresh for all years
            # --> tibble [43,464 × 5] (S3: tbl_df/tbl/data.frame)
            # $ doy   : int [1:43464] 1 2 3 4 5 6 7 8 9 10 ...
            # $ t     : Date[1:43464], format: "1982-01-01" "1982-01-02" ...
            # $ temp  : num [1:43464] -1.62 -1.63 -1.63 -1.63 -1.62 ...
            # $ seas  : num [1:43464] 2.04 2.12 2.21 2.29 2.37 ...
            # $ thresh: num [1:43464] 4.37 4.46 4.54 4.62 4.7 ...

            # new heatwave3 package:
            # 1) heatwave3::detect3():
            # Create temp+seas+clim rasters
            # nc_seas <- terra::app(x = nc_daily_no_NA, fun = detect3clim,
            #                       time_dim = terra::time(nc_daily_no_NA),
            #                       clim_period = clim_period, ...)
            # 2) heatwave3::detect3clim():
            # df_seas <- heatwaveR::ts2clm3(data.frame(t = as.Date(time_dim), temp = x),
            #                               climatologyPeriod = clim_period, ...)
            # 3) heatwaveR::ts2clm3():
            # ts_mat <- clim_calc(ts_mat, windowHalfWidth, pctile)
            # --> uses heatwaveR::clim_calc
            # --> climatology and threshold calculation identical as in old heatwaveR package

            if (all(is.na(clm$thresh))) {
                event <- NA
            } else {

                message("run heatwaveR::detect_event with `categories=T` ...")
                event <- heatwaveR::detect_event(clm,
                                                 minDuration=heatwaveR_opts$minDuration,
                                                 coldSpells=heatwaveR_opts$coldSpells,
                                                 categories=T,
                                                 S=T, # for category(): southern hemisphere? can be ignored: just determines `season`; keep default T
                                                 climatology=heatwaveR_opts$climatology, # for category(): if true, returns more detailed information
                                                 MCScorrect=heatwaveR_opts$MCScorrect # for category(): limit MCS temperature threshold to -1.8°C
                                                ) # ~850K for ~11k ntime

                # calls in `detect_event`:
                # 1) heatwaveR::detect_event():
                # t_series <- data.frame(ts_x, ts_y, ts_seas, ts_thresh)
                # t_series$threshCriterion <- t_series$ts_y > t_series$ts_thresh
                # t_series$threshCriterion[is.na(t_series$threshCriterion)] <- FALSE
                # --> `ts_thresh` = thresh[doy i] = quantile(data[doy i, all years], quant=90/100)
                # 2)
                # events_clim <- proto_event(t_series, criterion_column = t_series$threshCriterion,
                #     minDuration = minDuration, joinAcrossGaps = joinAcrossGaps,
                #     maxGap = maxGap)
                # 3)
                # events <- data.frame(events_clim, row_index = base::seq_len(nrow(events_clim)),
                #     mhw_rel_seas = events_clim$ts_y - events_clim$ts_seas,
                #     mhw_rel_thresh = events_clim$ts_y - events_clim$ts_thresh)
                # events <- events[stats::complete.cases(events$event_no), ]
                # events <- plyr::ddply(events, c("event_no"), .fun = plyr::summarise,
                #     index_start = min(row_index),
                #     index_peak = row_index[mhw_rel_seas == max(mhw_rel_seas)][1], index_end = max(row_index),
                #     duration = index_end - index_start + 1, date_start = min(ts_x),
                #     date_peak = ts_x[mhw_rel_seas == max(mhw_rel_seas)][1],
                #     date_end = max(ts_x), intensity_mean = mean(mhw_rel_seas),
                #     intensity_max = max(mhw_rel_seas), intensity_var = sqrt(stats::var(mhw_rel_seas)),
                #     intensity_cumulative = sum(mhw_rel_seas), intensity_mean_relThresh = mean(mhw_rel_thresh),
                #     intensity_max_relThresh = max(mhw_rel_thresh),
                #     intensity_var_relThresh = sqrt(stats::var(mhw_rel_thresh)),
                #     intensity_cumulative_relThresh = sum(mhw_rel_thresh),
                #     intensity_mean_abs = mean(ts_y), intensity_max_abs = max(ts_y),
                #     intensity_var_abs = sqrt(stats::var(ts_y)), intensity_cumulative_abs = sum(ts_y))

                # new heatwave3 package:
                # 1) heatwave3::detect3():
                # nc_event <- terra::app(x = nc_seas, fun = detect3event,
                #             time_dim = terra::time(nc_rast_daily),
                #             min_dur = min_dur, max_gap = max_gap, ...)
                # 2) heatwave3::detect3event():
                # df_event <- heatwaveR::detect_event3(df_sub, minDuration = min_dur, maxGap = max_gap, ...)$event
                # --> uses heatwaveR::detect_event3

                # if `heatwaveR_opts$climatology` is true, for 30a time series, the complete `event` object is ~41M for 50 locations
                # --> 41/50*691150 = 566743M = 553G = 0.54T for 691150 sea locations
                # --> save only the `event$event` object --> only ~1M for 50 locations
                # --> 1/50*691150 = 13823M = 13.5G = for 691150 sea locations
                # --> still may kill job due to memory limit exceedence --> choose sufficiently small `location_inds` chunks
                if (heatwaveR_opts$climatology) event <- event$event # continue with event summary only

                # remove `season` result since `S` arg was ignored in `detect_event`
                # call to keep this script independent of latitude of data points
                # season can be inferred later in post_heatwaveR.r
                event$season <- NULL

                #heatwaveR::event_line(event)

            } # some non-NA?

            # save results
            cnt <- cnt + 1
            events[[cnt]] <- event
            opts[[cnt]] <- list(loci=location_inds[loci],
                                locinds=locinds, locvals=locvals)
            if (heatwaveR_opts$calc_trend || heatwaveR_opts$remove_trend) lms[[cnt]] <- lm

        } # if remove_trend and lm not successful
    } # if there are any non-NA at current location
} # for loci
message("\nfinished. seconds needed to read time series of length ", ntime,
        " from ", nfiles, " files per location (nloc=", nloc, "):")
elapsed_all <- elapsed_all[-1] # remove first elapsed value which is biased way too large
print(summary(elapsed_all))

# save results to disk
if (cnt > 0) {
    opts_global <- list(dataname=dataname,
                        varname=varname, varname_atts=varname_atts, depth=depth,
                        clim_from=clim_from, clim_to=clim_to,
                        ts_from=ts_from, ts_to=ts_to, ts_dt_yrs=ts_dt_yrs,
                        heatwaveR_opts=heatwaveR_opts,
                        files=files,
                        time_dim=list(name=timedimname,
                                      len=ntime,
                                      vals=time,
                                      origin="1970-1-1"),
                        spatial_dims=spatial_dims)
    message("\nsave results from ", nloc, " locations to\n   ", fout, " ...")
    if (heatwaveR_opts$calc_trend || heatwaveR_opts$remove_trend) {
        base::save(events, opts, opts_global, lms, file=fout)
    } else {
        base::save(events, opts, opts_global, file=fout)
    }
} # if length(clms) > 0

message("\nfinished")

