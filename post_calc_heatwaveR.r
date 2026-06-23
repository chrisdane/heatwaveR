 # r

# summarize heatwaveR results created with `calc_heatwaveR.r` into nc files and get event indices for composite/compound

rm(list=ls()); graphics.off()
if (!interactive()) {
    library(ncdf4)
    source("~/scripts/r/functions/myfunctions.r") # identical_list
}

workpath <- "/work/ba1103/a270073"
#pathout <- paste0(workpath, "/post/heatwaveR")
pathout <- paste0("/work/ab1095/a270073/post/heatwaveR")
subset_from <- subset_to <- NULL

# which variable
depth <- NULL # default
if (F) { # sst
    if (T) { # oisst
        dataname <- "oisst_v2.1"
        nchunks <- 30
        pathin <- paste0(workpath, "/post/heatwaveR/calc/sst/", dataname, "/nchunks_", nchunks)
        #files <- list.files(pathin, glob2rx("oisst_v2.1_calc_mhw_sst_ts_19820101-20141231_clim_19820101-20141231_pctile_90_minDuration_5_fixed_baseline_withTrend*.RData"))
        #files <- list.files(pathin, glob2rx("oisst_v2.1_calc_mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_fixed_baseline_withTrend*.RData"))
        files <- list.files(pathin, glob2rx("oisst_v2.1_calc_mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_fixed_baseline_woutTrend*.RData"))
    }

} else if (T) { # tos
    if (T) { # awi-esm-1-1-lr_kh800
        if (F) { # piControl
            dataname <- "awi-esm-1-1-lr_kh800_piControl"
            if (F) { # test
                nchunks <- 1
                pathin <- paste0(workpath, "/post/heatwaveR/calc/tos/", dataname, "/nchunks_", nchunks)
                files <- list.files(pathin, glob2rx("awi-esm-1-1-lr_kh800_piControl_calc_mhw_tos_ts_29970101-30001231_clim_29970101-30001231_pctile_90_minDuration_5_fixed_baseline_withTrend*.RData"))
            } else if (T) { # complete piControl
                nchunks <- 82
                pathin <- paste0(workpath, "/post/heatwaveR/calc/tos/", dataname, "/nchunks_", nchunks)
                files <- list.files(pathin, glob2rx("awi-esm-1-1-lr_kh800_piControl_calc_mhw_tos_ts_26860101-30001231_clim_26860101-30001231_pctile_90_minDuration_5_fixed_baseline_withTrend*.RData"))
            }
        } else if (F) { # historical2
            dataname <- "awi-esm-1-1-lr_kh800_historical2"
            if (F) { # clim 1850-2014
                nchunks <- 40
                pathin <- paste0(workpath, "/post/heatwaveR/calc/tos/", dataname, "/nchunks_", nchunks)
                files <- list.files(pathin, glob2rx("awi-esm-1-1-lr_kh800_historical2_calc_mhw_tos_ts_18500101-20141231_clim_18500101-20141231_pctile_90_minDuration_5_fixed_baseline_withTrend*.RData"))
            } else if (T) { # clim 1982-2014
                nchunks <- 10
                pathin <- paste0(workpath, "/post/heatwaveR/calc/tos/", dataname, "/nchunks_", nchunks)
                files <- list.files(pathin, glob2rx("awi-esm-1-1-lr_kh800_historical2_calc_mhw_tos_ts_19820101-20141231_clim_19820101-20141231_pctile_90_minDuration_5_fixed_baseline_withTrend*.RData"))
            }
        } else if (T) { # historical3_and_ssp585_2
            dataname <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2"
            if (F) {
                nchunks <- 20
                pathin <- paste0(workpath, "/post/heatwaveR/calc/tos/", dataname, "/nchunks_", nchunks)
                files <- list.files(pathin, glob2rx("awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_calc_mhw_tos_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_fixed_baseline_withTrend*.RData"))
                #files <- list.files(pathin, glob2rx("awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_calc_mhw_tos_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_fixed_baseline_woutTrend*.RData"))
            } else if (F) {
                nchunks <- 82
                pathin <- paste0(workpath, "/post/heatwaveR/calc/tos/", dataname, "/nchunks_", nchunks)
                #files <- list.files(pathin, glob2rx("awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_calc_mhw_tos_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_fixed_baseline_withTrend*.RData"))
                #files <- list.files(pathin, glob2rx("awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_calc_mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_fixed_baseline_withTrend*.RData"))
                files <- list.files(pathin, glob2rx("awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_calc_mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_fixed_baseline_woutTrend*.RData"))
                #files <- list.files(pathin, glob2rx("awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_calc_mhw_tos_ts_19820101-21001231_clim_19820101-20211231_pctile_90_minDuration_5_fixed_baseline_withTrend*.RData"))
                #files <- list.files(pathin, glob2rx("awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_calc_mhw_tos_ts_19820101-21001231_clim_19820101-20211231_pctile_90_minDuration_5_fixed_baseline_woutTrend*.RData"))
            } else if (T) {
                nchunks <- 160
                pathin <- paste0(workpath, "/post/heatwaveR/calc/tos/", dataname, "/nchunks_", nchunks)
                #files <- list.files(pathin, glob2rx("awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_calc_mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_15a_withTrend*.RData"))
                #files <- list.files(pathin, glob2rx("awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_calc_mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend*.RData"))
                files <- list.files(pathin, glob2rx("mhw_calc_tos_ts_19820101-21001231_clim_19820101-20220101_pctile_90_minDuration_5_fixed_baseline_withTrend_locinds_000014-000020_nloc_7.RData"))
            }
            #subset_from <- as.POSIXct("2080-12-31 23:59:59", tz="UTC")
            #subset_to <- as.POSIXct("1982-12-31 23:59:59", tz="UTC")
        }
    }

} else if (F) { # thetao
    depth <- "200m"
    if (T) { # awi-esm-1-1-lr_kh800
        if (T) { # historical3_and_ssp585_2
            dataname <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2"
            nchunks <- 160
            pathin <- paste0(workpath, "/post/heatwaveR/calc/thetao/", dataname, "/nchunks_", nchunks)
            #files <- list.files(pathin, glob2rx(paste0(dataname, "_calc_mhw_thetao_", depth, "_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_fixed_baseline_withTrend*.RData")))
            #files <- list.files(pathin, glob2rx(paste0(dataname, "_calc_mhw_thetao_", depth, "_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_fixed_baseline_woutTrend*.RData")))
            #files <- list.files(pathin, glob2rx(paste0(dataname, "_calc_mhw_thetao_", depth, "_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_15a_withTrend*.RData")))
            files <- list.files(pathin, glob2rx(paste0(dataname, "_calc_mhw_thetao_", depth, "_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend*.RData")))
        }
    }

} else if (F) { # bgc22
    if (T) { # historical3_and_ssp585_2
        dataname <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2"
        if (F) {
            nchunks <- 82
            depth <- "0m"
            pathin <- paste0(workpath, "/post/heatwaveR/calc/bgc22/", dataname, "/nchunks_", nchunks)
            #files <- list.files(pathin, glob2rx(paste0(dataname, "_calc_mcs_bgc22_", depth, "_ts_19820101-21001231_clim_19820101-20111231_pctile_10_minDuration_5_fixed_baseline_withTrend*.RData")))
            files <- list.files(pathin, glob2rx(paste0(dataname, "_calc_mcs_bgc22_", depth, "_ts_19820101-21001231_clim_19820101-20111231_pctile_10_minDuration_5_fixed_baseline_woutTrend*.RData")))
        } else if (T) {
            nchunks <- 160
            #depth <- "0m"
            depth <- "200m"
            pathin <- paste0(workpath, "/post/heatwaveR/calc/bgc22/", dataname, "/nchunks_", nchunks)
            #files <- list.files(pathin, glob2rx(paste0(dataname, "_calc_mcs_bgc22_", depth, "_ts_19820101-21001231_clim_19820101-20111231_pctile_10_minDuration_5_fixed_baseline_withTrend*.RData")))
            #files <- list.files(pathin, glob2rx(paste0(dataname, "_calc_mcs_bgc22_", depth, "_ts_19820101-21001231_clim_19820101-20111231_pctile_10_minDuration_5_fixed_baseline_woutTrend*.RData")))
            #files <- list.files(pathin, glob2rx(paste0(dataname, "_calc_mcs_bgc22_", depth, "_ts_19820101-21001231_clim_19820101-21001231_pctile_10_minDuration_5_runmean_15a_withTrend*.RData")))
            files <- list.files(pathin, glob2rx(paste0(dataname, "_calc_mcs_bgc22_", depth, "_ts_19820101-21001231_clim_19820101-21001231_pctile_10_minDuration_5_runmean_31a_withTrend*.RData")))
        }
        #subset_to <- as.POSIXct("2014-12-31 23:59:59", tz="UTC")
    }

} else if (F) { # ce_tos_bgc22
    if (T) { # historical3_and_ssp585_2
        dataname <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2"
        if (F) {
            nchunks <- 82
            depth <- "0m"
            pathin <- paste0(workpath, "/post/heatwaveR/calc/ce_tos_bgc22/", dataname, "/nchunks_", nchunks)
            files <- list.files(pathin, glob2rx(paste0(dataname, "_calc_ce_mhw_tos_pctile_90_mcs_bgc22_", depth,
                                                       "_pctile_10_ts_19820101-21001231_clim_19820101-20111231_minDuration_5_fixed_baseline_withTrend*.RData")))
        } else if (T) {
            nchunks <- 160
            depth <- "0m"
            pathin <- paste0(workpath, "/post/heatwaveR/calc/ce_tos_bgc22/", dataname, "/nchunks_", nchunks)
            #files <- list.files(pathin, glob2rx(paste0(dataname, "_calc_ce_mhw_tos_pctile_90_mcs_bgc22_", depth,
            #                                           "_pctile_10_ts_19820101-21001231_clim_19820101-20111231_minDuration_5_runmean_31a_withTrend*.RData")))
            files <- list.files(pathin, glob2rx(paste0(dataname, "_calc_ce_mhw_tos_pctile_90_mcs_bgc22_", depth,
                                                       "_pctile_10_ts_19820101-21001231_clim_19820101-20111231_minDuration_5_runmean_15a_withTrend*.RData")))
        }
    }

} # which var

if (F) { # will be replaced by post_calc_heatwaveR_loop.r
    files <- files[1:2]
}

# setgrid/remap if wanted
setgrid_cmd <- remap_cmd <- NULL
if (T && grepl("awi-", dataname)) {
    setgrid_cmd <- "cdo -setgrid,/pool/data/AWICM/FESOM1/MESHES/core/griddes.nc <fin> <fout>"
    #remap_cmd <- c("global_0.25"=paste0("cdo -P ", system("nproc", intern=T), " -remapycon,global_0.25 -setgrid,/pool/data/AWICM/FESOM1/MESHES/core/griddes.nc <fin> <fout>")) # 0.25° as oisst
    remap_cmd <- c("global_1"=paste0("cdo -P ", system("nproc", intern=T), " -remapycon,global_1 -setgrid,/pool/data/AWICM/FESOM1/MESHES/core/griddes.nc <fin> <fout>"))
} # if setgrid/remap

# what to post-process?
calc_timmean <- F # only makes sense with all calc result files, i.e. global
calc_ts <- T # only makes sense with all calc result files, i.e. global; needs large mem
vars_ts_wanted <- c("duration", "nevents", "intensity_mean", "intensity_var", "intensity_max", "intensity_cumulative")
if (F) vars_ts_wanted <- "duration"
if (F) vars_ts_wanted <- "nevents"
if (F) vars_ts_wanted <- "intensity_mean"
if (F) vars_ts_wanted <- "intensity_var"
if (T) vars_ts_wanted <- "intensity_max"
if (F) vars_ts_wanted <- "intensity_cumulative"
calc_ts_verbose <- F # log will be ~GB
calc_event_inds <- F # can run on specific locations, i.e. chunks
#append_method <- "rbind"
append_method <- "rbindlist"
if (calc_event_inds && append_method == "rbindlist") library(data.table)

# all names of `events`:
# "event_no", "index_start", "index_peak", "index_end", "duration",
# "date_start", "date_peak", "date_end", "intensity_mean", "intensity_max",
# "intensity_var", "intensity_cumulative", "intensity_mean_relThresh",
# "intensity_max_relThresh", "intensity_var_relThresh", "intensity_cumulative_relThresh",
# "intensity_mean_abs", "intensity_max_abs", "intensity_var_abs",
# "intensity_cumulative_abs", "rate_onset", "rate_decline", "event_name",
# "category", "p_moderate", "p_strong", "p_severe", "p_extreme",
# "season"
# additional:
# nevents = number of events
# oliver 2019:
# exposure = sum(duration)
# froelicher et al. 2018:
# probability ratio PR = P1/P0, where P1 is the probability of exceeding a relative
# threshold at any given point in time (for example, today) and P0 the probability of
# exceeding that threshold during the preindustrial control or satellite climatological period.
# relative change in the annual spatial extent = the average area of an individual heatwave
# maximum annual intensity = maximum exceedance of the 99th percentile
# oliver et al. 2021:
# permanent MHW = duration = 365 days per
# marin et al. 2021a:
# TAR = trend attributional ratio; >0: mhw trend due to sst trend; <0: mhw trend due to internal variability

known_vars <- list(
    # heatwaveR vars:
    "duration"=list(units="days",
                    longname="duration of event"),
    "intensity_mean"=list(units="<varunits>",
                          longname="mean intensity wrt seasonal climatology"),
    "intensity_max"=list(units="<varunits>",
                         longname="maximum (peak) intensity wrt seasonal climatology"),
    "intensity_var"=list(units="<varunits>",
                         longname="intensity variability (standard deviation) wrt seasonal climatology"),
    "intensity_cumulative"=list(units="<varunits> x days",
                                longname="cumulative intensity wrt seasonal climatology"),
    "intensity_mean_relThresh"=list(units="<varunits>",
                                    longname="mean intensity wrt threshold"),
    "intensity_max_relThresh"=list(units="<varunits>",
                                   longname="maximum (peak) intensity wrt threshold"),
    "intensity_var_relThresh"=list(units="<varunits>",
                                   longname="intensity variability (standard deviation) wrt threshold"),
    "intensity_cumulative_relThresh"=list(units="<varunits> x days",
                                          longname="cumulative intensity wrt threshold"),
    "intensity_mean_abs"=list(units="<varunits>",
                              longname="mean intensity"),
    "intensity_max_abs"=list(units="<varunits>",
                             longname="maximum (peak) intensity"),
    "intensity_var_abs"=list(units="<varunits>",
                             longname="intensity variability (standard deviation)"),
    "intensity_cumulative_abs"=list(units="<varunits> x days",
                                    longname="cumulative intensity"),
    "p_moderate"=list(units="percent",
                      longname="the proportion of the total duration (days) spent at or above the first threshold, but below any further thresholds"),
    "p_strong"=list(units="percent",
                    longname="the proportion of the total duration (days) spent at or above the second threshold, but below any further thresholds"),
    "p_severe"=list(units="percent",
                    longname="the proportion of the total duration (days) spent at or above the third threshold, but below the fourth threshold"),
    "p_extreme"=list(units="percent",
                     longname="the proportion of the total duration (days) spent at or above the fourth and final threshold"),
    # my additional vars:
    "nevents"=list(units="#",
                   longname="total number of events in <ts_dt_yrs> years"),
    "nevents_pyr"=list(units="#",
                       longname="total number of events per year"),
    "exposure"=list(units="days",
                    longname="sum of duration of all events in <ts_dt_yrs> years"),
    "exposure_pyr"=list(units="days",
                        longname="sum of duration of all events per year"),
    "trend_total"=list(units="<varunits> / <ts_dt_yrs> yrs",
                       longname="significant (p lt 0.05) linear total <varname> trend"),
    "trend_pyr"=list(units="<varunits> / yr",
                     longname="significant (p lt 0.05) linear <varname> trend per year"),
    "trend_pdec"=list(units="<varunits> / decade",
                      longname="significant (p lt 0.05) linear <varname> trend per decade")
                   )

dpm <- c(Jan=31, Feb=28, Mar=31, Apr=30, May=31, Jun=30, Jul=31, Aug=31, Sep=30, Oct=31, Nov=30, Dec=31)

# runtime 1 var:
# fesom1, nyears 119, nchunks:  82 -> nloc  154[7-8]: max 2h
# fesom1, nyears 119, nchunks: 160 -> nloc   79[2-3]: max 2h but shorter than 82 nchunks
# runtime 4 vars:
# oisst,  nyears  40, nchunks: 30 -> nloc 2303[8-9]:    30h
# fesom1, nyears  40, nchunks: 20 -> nloc  634[2-3]:   3.3h
# fesom1, nyears 119, nchunks: 82 -> nloc  154[7-8]: 18.05h +- 3.98h (sd)

#################################################

# check
if (all(is.na(files))) stop("provided zero files")
nfiles <- length(files)
if (nfiles == 0) stop("provided zero files")
if (!exists("nchunks")) stop("provide `nchunks`")
if (any(calc_timmean || calc_ts) && calc_event_inds) {
    stop("either run with `calc_timmean` and/or `calc_ts` in one job OR with `calc_event_inds` with many jobs")
}
if (any(grepl(" ", names(known_vars)))) stop("names of `known_vars` must not contain space")
if (!is.null(subset_from)) {
    if (!any(grep("POSIXct", class(subset_from)))) stop("`subset_from` must be of class POSIXct")
}
if (!is.null(subset_to)) {
    if (!any(grep("POSIXct", class(subset_to)))) stop("`subset_to` must be of class POSIXct")
}

# get location chunks if calc_heatwaveR.r ran with `locations_inds`
locs <- NULL # default
if (any(grepl("_locinds_", files))) {
    loc_starts <- regexpr("_locinds_", files)
    loc_ends <- regexpr("_nloc_", files)
    loc_start_inds <- which(loc_starts != -1)
    loc_end_inds <- which(loc_ends != -1)
    if (length(loc_start_inds) == 0 || length(loc_end_inds) == 0 ||
        length(loc_start_inds) != length(loc_end_inds)) {
        stop("this should not happen")
    }
    locs <- substr(files[loc_start_inds], loc_starts+9, loc_ends-1) # e.g. "0136725-0138515"
    locs <- strsplit(locs, "-")
    locs <- data.frame(from_char=sapply(locs, "[", 1), to_char=sapply(locs, "[", 2)) # e.g. "0136725"    "0138515"
    locs <- cbind(locs, from=as.integer(locs$from_char), to=as.integer(locs$to_char)) # e.g. 136725     138515
    loc_inds <- sort(locs$from, index.return=T)$ix
    locs <- locs[loc_inds,] # sort
    files <- files[loc_inds]
    if (nfiles > 1) {
        loc_diffs_between_files <- c(NA, locs$from[2:nfiles] - locs$to[1:(nfiles-1)])
    } else {
        loc_diffs_between_files <- 1
    }
    #loc_diffs_between_files[c(3, 10)] <- 2 # test
    if (any(loc_diffs_between_files != 1, na.rm=T)) {
        inds_to <- which(loc_diffs_between_files != 1)
        inds_from <- inds_to - 1
        warn <- options()$warn
        options(warn=0) # dont stop on warnings
        warning("there are location ind gaps != 1 between ", length(inds_from), " pairs of files:\n",
                paste(paste0("file ", inds_from, " ", files[inds_from], " from ", locs$from[inds_from], " to ", locs$to[inds_from], "\n",
                             "file ", inds_to, " ", files[inds_to], " from ", locs$from[inds_to], " to ", locs$to[inds_to], "\n--> diff = ",
                             loc_diffs_between_files[inds_to]), collapse="\n"))
        options(warn=warn) # restore old value
    }
} # if any filename has "_locinds_" pattern
files <- data.frame(file=files)
if (!is.null(locs)) files <- cbind(files,
                                   loc_from=locs$from, loc_to=locs$to,
                                   loc_from_char=locs$from_char, loc_to_char=locs$to_char)
rm(locs)

# mystuff
if (F) { # test
    message("test")
    files <- files[1:2,]
    nfiles <- length(files$file)
}
if (F) { # split large calc_heatwaveR.r results into smaller chunks
    for (fi in seq_along(files$file)) {
        message("load ", fi, "/", nfiles, ": ", files$file[fi], " ...")
        datnames <- load(paste0(pathin, "/", files$file[fi]))
        # subsetting `save(obj[1:n])` not supported by `save()` O_O
        for (di in seq_along(datnames)) {
            cmd <- paste0(datnames[di], "_tmp <- ", datnames[di])
            eval(parse(text=cmd))
        }
        from <- files$loc_from[fi]
        to <- files$loc_to[fi]
        if (length(from:to) > 3000) { # split large file
            tmp <- ceiling(seq(from, to, l=3))
            from_new <- c(from, tmp[2]+1)
            to_new <- c(tmp[2], to)
            from_new_inds <- c(1, length(from_new[1]:to_new[1])+1)
            to_new_inds <- c(length(from_new[1]:to_new[1]), from_new_inds[2]-1+length(from_new[2]:to_new[2]))
            if (length(from_new[1]:to_new[1]) != length(from_new_inds[1]:to_new_inds[1])) stop("asd")
            if (length(from_new[2]:to_new[2]) != length(from_new_inds[2]:to_new_inds[2])) stop("asd")
            for (fj in seq_along(from_new)) {
                # subsetting `save(obj[1:n])` not supported by `save()` O_O
                for (di in seq_along(datnames)) {
                    if (datnames[di] == "opts_global") {
                        cmd <- paste0(datnames[di], " <- ", datnames[di], "_tmp")
                    } else {
                        cmd <- paste0(datnames[di], " <- ", datnames[di], "_tmp[", from_new_inds[fj], ":", to_new_inds[fj], "]")
                    }
                    message("   ", cmd)
                    eval(parse(text=cmd))
                }
                fout <- sub(paste0("_locinds_",
                                   files$loc_from_char[fi], "-",
                                   files$loc_to_char[fi],
                                   "_nloc_", length(from:to)),
                            paste0("_locinds_",
                                   sprintf(paste0("%0", nchar(files$loc_to_char[fi]), "i"), from_new[fj]), "-",
                                   sprintf(paste0("%0", nchar(files$loc_to_char[fi]), "i"), to_new[fj]),
                                   "_nloc_", length(from_new[fj]:to_new[fj])),
                            files$file[fi])
                message("   save ", fout, " ...")
                cmd <- paste0("save(", paste(datnames, collapse=", "),
                              ", file=\"", pathin, "/tmp/", fout, "\")")
                eval(parse(text=cmd))
            } # for fj
        } # if split large file
    } # for fi
} # TF

file_sizes_byte <- file.size(paste0(pathin, "/", files$file))
file_sizes_pretty <- sapply(file_sizes_byte, utils:::format.object_size, "auto")
file_sizes_total_pretty <- utils:::format.object_size(sum(file_sizes_byte), units="auto")
width <- options()$width
options(width=2000)
message("provided ", nfiles, " files (total ", file_sizes_total_pretty, ") :")
print(files)
options(width=width) # restore old value

# load data
message("\nload ", nfiles, " heatwaveR calc results files ...")
events_all <- opts_all <- opts_global_all <- lms_all <- vector("list", l=nfiles) # outputs of `calc_heatwaveR.r`
tic <- Sys.time()
for (fi in seq_len(nfiles)) {
    message("load file ", fi, "/", nfiles, " (", file_sizes_pretty[fi], "): ", files$file[fi], " ...")
    datnames <- load(paste0(pathin, "/", files$file[fi])) # "events", "opts", "opts_global"; if calc_trend or remove_trend: "lms"
    if (any(is.na(match(c("events", "opts", "opts_global"), datnames)))) {
        stop("this should not happen")
    }
    events_all[[fi]] <- events
    opts_all[[fi]] <- opts
    opts_global_all[[fi]] <- opts_global
    if (any(datnames == "lms")) {
        lms_all[[fi]] <- lms
    }
} # for fi
toc <- Sys.time()
elapsed_sec <- difftime(toc, tic, units="sec")
message("--> took ", round(elapsed_sec), " sec = ", round(elapsed_sec/60), " min for ", nfiles, " files")
if (all(sapply(lms_all, is.null))) rm(lms_all)

if (F) { # repair my own stupidity
    stop("asd")
    opts_global <- opts_global_all[[1]][1:10]
    for (fi in seq_len(nfiles)) {
        events <- events_all[[fi]]
        opts <- opts_all[[fi]]
        lms <- lms_all[[fi]]
        fout <- paste0(pathin, "/tmp/", files$file[fi])
        message("save ", fi, "/", nfiles, ": ", fout)
        save(events, opts, opts_global, lms, file=fout)
    }
}

# check if all `opt_global_all` are identical for all files, which should be the case for one dataset
if (any(names(opts_global_all[[1]]) == "dataname")) { # extreme events based on one variable (the default case)
    if (!identical_list(opts_global_all)) { # of all chunks = files
        stop("`opts_global_all` objects of ", nfiles, " files are not identical. that means not all `files` refer to the same data")
    }
    is_compound <- F
} else if (!any(names(opts_global_all[[1]]) == "dataname")) { # extreme events based on multiple variables --> compound events
    if (!identical_list(lapply(opts_global_all, "[[", 1))) { # of first variable (e.g. tos) of all chunks = files
        stop("`opts_global_all` objects of ", nfiles, " files are not identical. that means not all `files` refer to the same data")
    }
    is_compound <- T
}
message("\nall ", nfiles, " loaded `opts_global_all` objects are identical --> continue with the first ...")
opts_global <- opts_global_all[[1]] # of first chunk = file
rm(opts_global_all)

# add an additional layer for the variable to be compatible for the compound event case
if (!is_compound) { # todo: repair this in calc_heatwaveR that it becomes default
    opts_global <- list(opts_global)
    names(opts_global) <- opts_global[[1]]$varname
}

# repair my stupidity
for (vari in seq_along(opts_global)) {
    if (is.null(opts_global[[vari]]$clim_from) || is.null(opts_global[[vari]]$clim_to)) {
        if (!is.null(opts_global[[vari]]$heatwaveR_opts$clim_runmean)) { # new
            if (!is.na(opts_global[[vari]]$heatwaveR_opts$clim_runmean)) { # runmean
                clim_from <- opts_global[[vari]]$ts_from
                clim_to <- opts_global[[vari]]$ts_to
            } else {
                if (!is.null(opts_global[[vari]]$heatwaveR_opts$climatologyPeriod_posix)) { # old
                    clim_from <- opts_global[[vari]]$heatwaveR_opts$climatologyPeriod_posix[1]
                    clim_to <- opts_global[[vari]]$heatwaveR_opts$climatologyPeriod_posix[2]
                } else {
                    stop("fix here")
                }
            }
        } else if (!is.null(opts_global[[vari]]$heatwaveR_opts$climatologyPeriod_posix)) { # old
            clim_from <- opts_global[[vari]]$heatwaveR_opts$climatologyPeriod_posix[1]
            clim_to <- opts_global[[vari]]$heatwaveR_opts$climatologyPeriod_posix[2]
            opts_global[[vari]]$heatwaveR_opts$clim_runmean <- NA
        } else {
            stop("this should not happen")
        }
        if (is.null(clim_from) || is.null(clim_to)) {
            stop("fix here")
        }
        opts_global[[vari]]$clim_from <- clim_from
        opts_global[[vari]]$clim_to <- clim_to
    }
    if (F && substr(opts_global[[vari]]$clim_from, 1, 10) == "1849-12-31") {
        message("\nspecial: repair wrong `clim_from` = ", opts_global[[vari]]$clim_from)
        opts_global[[vari]]$clim_from <- as.POSIXct("1850-1-1", tz=as.POSIXlt(clim_to)$zone)
        message("--> to ", opts_global[[vari]]$clim_from)
    }
    if (is.null(opts_global[[vari]]$varname_atts)) {
        if (!is.null(opts_global[[vari]]$varname_infos)) {
            opts_global[[vari]]$varname_atts <- opts_global[[vari]]$varname_infos
        } else {
            stop("should not happen")
        }
    }
    if (is.null(opts_global[[vari]]$depth)) { # old
        if (!is.null(depth)) {
            if (any(opts_global[[vari]]$varname == c("sst", "tos"))) { # ce case
                opts_global[[vari]]$depth <- NULL
            } else {
                opts_global[[vari]]$depth <- depth
            }
        } else {
            opts_global[[vari]]$depth <- depth
        }
    }

    # check spatial mapping
    nspatialdims <- length(opts_global[[vari]]$spatial_dims)
    spatialdimnames <- names(opts_global[[vari]]$spatial_dims)
    spatialdims <- sapply(opts_global[[vari]]$spatial_dims, "[[", "len")
    if (nspatialdims > 2) {
        stop(nspatialdims, "D spatial dims case not defined")
    }
} # for vari

message("\n`opts_global`:")
cat(capture.output(str(opts_global)), sep="\n")

# global atts _per variable_
varname <- sapply(opts_global, "[[", "varname")
varunits <- sapply(lapply(opts_global, "[[", "varname_atts"), "[[", "units")
clim_from <- lapply(opts_global, "[[", "clim_from")
clim_to <- lapply(opts_global, "[[", "clim_to")
ts_from <- lapply(opts_global, "[[", "ts_from")
ts_to <- lapply(opts_global, "[[", "ts_to")
ts_dt_yrs <- sapply(opts_global, "[[", "ts_dt_yrs")

# todo: differnet dates bwtween variables not yet implemented
if (!identical_list(clim_from)) { print(clim_from); stop("--> `clim_from` not identical for all variables") }
if (!identical_list(clim_to)) { print(clim_to); stop("--> `clim_to` not identical for all variables") }
if (!identical_list(ts_from)) { print(ts_from); stop("--> `ts_from` not identical for all variables") }
if (!identical_list(ts_to)) { print(ts_to); stop("--> `ts_to` not identical for all variables") }
if (length(unique(ts_dt_yrs)) != 1) stop("`ts_dt_yrs` differ: ", paste(ts_dt_yrs, collapse=", "))
clim_from <- clim_from[[1]]
clim_to <- clim_to[[1]]
ts_from <- ts_from[[1]]
ts_to <- ts_to[[1]]
ts_dt_yrs <- ts_dt_yrs[1]

# check special for compound event case
if (is_compound) {
    varname <- paste0("ce_", paste(varname, collapse="_")) # as in compound_heatwaveR
    rm(varunits)

    # the following was already checked in compound_heatwaveR but do it here again for sanity
    spatialdim_opts <- vector("list", l=length(opts_global))
    names(spatialdim_opts) <- names(opts_global)
    for (vari in seq_along(spatialdim_opts)) {
        spatialdim_opts[[vari]]$nspatialdims <- length(opts_global[[vari]]$spatial_dims)
        spatialdim_opts[[vari]]$spatialdimnames <- names(opts_global[[vari]]$spatial_dims)
        spatialdim_opts[[vari]]$spatialdims <- sapply(opts_global[[vari]]$spatial_dims, "[[", "len")
        if (spatialdim_opts[[vari]]$nspatialdims > 2) {
            stop(spatialdim_opts[[vari]]$nspatialdims, "D spatial dims case not defined (variable ", vari, ")")
        }
    }
    cat(capture.output(str(spatialdim_opts)), sep="\n")
    if (!identical_list(spatialdim_opts)) {
        # special case 1: fesom spatial dim names "nodes_2d" and "ncells" represent the same thing --> ok
        if (all(sapply(spatialdim_opts, "[[", "nspatialdims") == 1) && # all have one spatial dim
            length(unique(sapply(spatialdim_opts, "[[", "spatialdims"))) == 1 && # all of same length
            !any(is.na(match(c("nodes_2d", "ncells"), sapply(spatialdim_opts, "[[", "spatialdimnames"))))) { # all spatial dims called "nodes_2d" or "ncells"
        } else {
            stop("not all loaded data from all variables have same spatial infos")
        }
    }
    message("--> ok; look all the same")
    nspatialdims <- spatialdim_opts[[1]]$nspatialdims
    spatialdimnames <- spatialdim_opts[[1]]$spatialdimnames
    spatialdims <- spatialdim_opts[[1]]$spatialdims

} else {
    if (length(varname) != 1) {
        stop("implement")
    }
} # if is_compound
names(clim_from) <- names(clim_to) <- names(ts_from) <- names(ts_to) <- names(ts_dt_yrs) <- varname
ts_dt_yrs <- ceiling(ts_dt_yrs) # repair; e.g. 314.99 yrs --> 315 yrs

message("\ncheck if `setgrid_cmd` is not null, i.e. setting a specific grid is wanted ...")
if (!is.null(setgrid_cmd)) {
    message("--> yes, `setgrid_cmd` = `", setgrid_cmd, "` ...")
    if (!grepl("<fin>", setgrid_cmd)) stop("setgrid_cmd must contain \"<fin>\"")
    if (!grepl("<fout>", setgrid_cmd)) stop("setgrid_cmd must contain \"<fout>\"")
}

message("\ncheck if `remap_cmd` is not null, i.e. remapping is wanted ...")
if (!is.null(remap_cmd)) {
    message("--> yes, `remap_cmd` = `", remap_cmd, "` ...")
    if (is.null(names(remap_cmd))) stop("remap_cmd must be named vector, e.g. `remap_cmd <- c(\"myname\"=\"myvalue\")")
    if (!grepl("<fin>", remap_cmd)) stop("remap_cmd must contain \"<fin>\"")
    if (!grepl("<fout>", remap_cmd)) stop("remap_cmd must contain \"<fout>\"")
}

# update known_vars based on loaded data
for (vi in seq_along(known_vars)) {
    # replace placeholders in longname
    inds1 <- gregexpr("<", known_vars[[vi]]$longname)[[1]]
    inds2 <- gregexpr(">", known_vars[[vi]]$longname)[[1]]
    if (any(inds1 != -1)) {
        for (pati in seq_along(inds1)) {
            repl <- substr(known_vars[[vi]]$longname,
                           regexpr("<", known_vars[[vi]]$longname)+1,
                           regexpr(">", known_vars[[vi]]$longname)-1)
            if (exists(repl)) {
                known_vars[[vi]]$longname <- sub(paste0("<", repl, ">"), eval(parse(text=repl)), known_vars[[vi]]$longname)
            }
        }
    }
    # replace placeholder in units
    inds1 <- gregexpr("<", known_vars[[vi]]$units)[[1]]
    inds2 <- gregexpr(">", known_vars[[vi]]$units)[[1]]
    if (any(inds1 != -1)) {
        for (pati in seq_along(inds1)) {
            repl <- substr(known_vars[[vi]]$units,
                           inds1[pati]+1, inds2[pati]-1)
            if (exists(repl)) {
                known_vars[[vi]]$units <- sub(paste0("<", repl, ">"), eval(parse(text=repl)), known_vars[[vi]]$units)
            }
        }
    }
} # for vi

# reorder so that every entry is one location
if (!is.null(files$loc_from)) {
    message("\nreorder objects from ", nfiles, " files so that every entry is one location ...")
    events <- opts <- list()
    if (exists("lms_all")) lms <- events
    cnt <- 0
    tic <- Sys.time()
    for (fi in seq_len(nfiles)) {
        msg <- paste0("file ", fi, "/", nfiles, ": `events` (",
                      utils:::format.object_size(object.size(events_all[[fi]]), units="auto"), "), `opts` (",
                      utils:::format.object_size(object.size(opts_all[[fi]]), units="auto"), ")")
        if (exists("lms_all")) {
            msg <- paste0(msg, ", `lms` (", utils:::format.object_size(object.size(lms_all[[fi]]), units="auto"), ")")
        }
        msg <- paste0(msg, " ...")
        message(msg)
        for (loci in seq_along(events_all[[fi]])) {
            cnt <- cnt + 1
            events[cnt] <- events_all[[fi]][loci]
            opts[cnt] <- opts_all[[fi]][loci]
            events_all[[fi]][[loci]] <- NA # reduce work space
            opts_all[[fi]][[loci]] <- NA
            if (exists("lms_all")) {
                lms[cnt] <- lms_all[[fi]][loci]
                lms_all[[fi]][[loci]] <- NA
            }
        } # for loci
    } # for fi
    toc <- Sys.time()
    elapsed_sec <- difftime(toc, tic, units="sec")
    message("--> took ", round(elapsed_sec), " sec = ", round(elapsed_sec/60), " min for objects of ", nfiles, " files")
    rm(events_all, opts_all)
    if (exists("lms")) rm(lms_all)
} else { # if is.null(files$loc_from)
    stop("implement")
} # if !is.null(files$loc_from)
nloc <- length(events)

# subset in time; useful for calc_timmean
if (!is.null(subset_from) || !is.null(subset_to)) {
    message("\nsubset data before post processing")
    if (!is.null(subset_from)) {
        message("--> `subset_from` = ", subset_from)
        if (subset_from < ts_from) stop("this is before `ts_from` = ", ts_from)
    } else {
        subset_from <- ts_from
    }
    if (!is.null(subset_to)) {
        message("--> `subset_to` = ", subset_to)
        if (subset_to > ts_to) stop("this is after `ts_to` = ", ts_to)
    } else {
        subset_to <- ts_to
    }
    if (exists("lms")) {
        message("--> need to remove `lms` since the trend does not fit to new time")
        rm(lms)
    }
    colnames <- colnames(events[[1]])
    for (loci in seq_along(events)) {
        if (loci %% 10000 == 0) message("loci ", loci, "/", nloc, " = ", round(loci/nloc*100), "%")
        inds <- which(as.POSIXct(events[[loci]]$date_start, tz="UTC") >= subset_from &
                      as.POSIXct(events[[loci]]$date_start, tz="UTC") <= subset_to)
        if (length(inds) == 0) { # subsetting removed all events at current location
            #events[[loci]] <- tibble::tibble(!!!colnames, .rows=0, .name_repair=~colnames) # tibble with nrow=0
                                                                                            # --> problem: if there are zero events at a location,
                                                                                            #     heatwaveR::detect_events returns tibble with
                                                                                            #     nrow=1 all columns NA
                                                                                            #     --> have to mimic this here
            tmp <- events[[loci]][1,]
            tmp[] <- NA
            events[[loci]] <- tmp
        } else {
            events[[loci]] <- events[[loci]][inds,]
        }
    } # for loci

    # update
    ts_dt_yrs <- as.POSIXlt(subset_to)$year - as.POSIXlt(subset_from)$year + 1
    ts_from <- subset_from
    ts_to <- subset_to
} # if subsetting

# remove locations that have zero events
# --> usually not happening when using a fixed baseline as climatology
# --> might happen when using a (short) running mean
# --> might happen due to temporal subsetting above
# --> might happen when compound events
message("\ncheck for locations with zero events ...")
inds <- sapply(lapply(events, is.na), all) # heatwaveR::detect_events returns tibble with nrow=1 all columns NA
if (any(inds)) {
    inds <- which(inds)
    message("--> there are ", length(inds), " locations without any events:")
    print(inds)
    message("--> remove them ...")
    events[inds] <- opts[inds] <- NULL
    if (exists("lms")) lms[inds] <- NULL
    nloc <- length(events) # update
}

## start post processing
message("\nstart postprocessing heatwaveR calc results of\n",
        "variable ", varname, " of data ",  dataname, " from\n",
        ts_from, " to ", ts_to, " over clim period from\n", clim_from, " to ", clim_to,
        " at ", nloc, " locations ...")

# nevents at all locations
nevents_tot <- sapply(events, nrow)
if (any(nevents_tot == 0)) stop("this should not happen")
if (any(is.na(nevents_tot))) stop("this should not happen")
if (length(nevents_tot) != nloc) stop("this should not happen")
nevents_pyr <- nevents_tot/ts_dt_yrs

# calc timmean
if (!calc_timmean) {
    message("\n`calc_timmean`=F --> dont calc timmean of heatwaveR calc results ...")

} else if (calc_timmean) {

    stop("update or better remove completely?!")

    message("\n`calc_timmean`=T --> calc timmean of heatwaveR calc results ...")
    # timmean nc output fname
    fout <- paste0(pathout, "/timmean/", varname, "/", dataname, "/",
                   ifelse(opts_global$heatwaveR_opts$coldSpells, "mcs", "mhw"),
                   "_", varname,
                   "_ts_", format(ts_from, "%Y%m%d"), "-", format(ts_to, "%Y%m%d"),
                   "_clim_", format(clim_from, "%Y%m%d"), "-", format(clim_to, "%Y%m%d"),
                   "_pctile_", opts_global$heatwaveR_opts$pctile,
                   "_minDuration_", opts_global$heatwaveR_opts$minDuration,
                   "_", ifelse(opts_global$heatwaveR_opts$remove_trend, "wout", "with"), "Trend",
                   "_locinds_")
    stop("add runmean to fout")
    if (!is.null(files$loc_from)) {
        fout <- paste0(fout, files$loc_from_char[1], "-", files$loc_to_char[nfiles])
    } else {
        fout <- paste0(fout,
                       sprintf(paste0("%0", nchar(prod(spatialdims)), "i"), 1), "-",
                       sprintf(paste0("%0", nchar(prod(spatialdims)), "i"), prod(spatialdims)))
    }
    fout <- paste0(fout, "_nloc_", nloc, "_timmean.nc")
    #stop("asd")
    if (file.exists(fout)) {
        message("\nfout\n   ", fout, "\nalready exists. skip timmean calculation")
    } else {
        dir.create(dirname(fout), recursive=T, showWarnings=F)
        if (!dir.exists(dirname(fout))) stop("could not create dir ", dirname(fout))

        #options(warn=2) # stop on warnings
        vars_timmean <- known_vars
        if (!exists("lms")) {
            vars_timmean[c("trend_total", "trend_pyr", "trend_pdec")] <- NULL # removes entries
        }
        datas_timmean <- vector("list", l=length(vars_timmean))
        names(datas_timmean) <- names(vars_timmean)
        for (vi in seq_along(datas_timmean)) {
            message("calc timmean var ", vi, "/", length(datas_timmean), ": ", names(datas_timmean)[vi],
                    " at ", nloc, " locations ...")

            # calc variable at every location over complete time period
            data <- array(NA, dim=spatialdims)
            for (loci in seq_len(nloc)) {
                loc_inds <- matrix(opts[[loci]]$locinds, nrow=1)
                if (names(datas_timmean)[vi] == "nevents") {
                    data[loc_inds] <- nevents_tot[loci]
                } else if (names(datas_timmean)[vi] == "nevents_pyr") {
                    data[loc_inds] <- nevents_pyr[loci]
                } else if (names(datas_timmean)[vi] == "exposure") {
                    data[loc_inds] <- sum(events[[loci]]$duration, na.rm=T)
                } else if (names(datas_timmean)[vi] == "exposure_pyr") {
                    data[loc_inds] <- sum(events[[loci]]$duration, na.rm=T)/ts_dt_yrs
                } else if (names(datas_timmean)[vi] == "trend_total") {
                    if (lms[[loci]]$p < 0.05) data[loc_inds] <- lms[[loci]]$slope_pyr*ts_dt_yrs
                } else if (names(datas_timmean)[vi] == "trend_pyr") {
                    if (lms[[loci]]$p < 0.05) data[loc_inds] <- lms[[loci]]$slope_pyr
                } else if (names(datas_timmean)[vi] == "trend_pdec") {
                    if (lms[[loci]]$p < 0.05) data[loc_inds] <- lms[[loci]]$slope_pyr*10
                } else { # default: mean over n events at current location loci
                    data[loc_inds] <- mean(events[[loci]][[names(datas_timmean)[vi]]], na.rm=T)
                }
            } # for loci
            datas_timmean[[vi]] <- data
        } # for vi datas_timmean

        # nc output
        message("\nsave timmean ", fout, " ...")

        # regridding needs a time dim
        ncdim_time <- ncdf4::ncdim_def(name="time",
                                       units="seconds since 1970-1-1",
                                       vals=as.numeric(mean(opts_global$time_dim$vals))) # mean over time series time

        ncdims_spatial <- vector("list", l=nspatialdims)
        for (si in seq_along(ncdims_spatial)) {
            ncdims_spatial[[si]] <- ncdf4::ncdim_def(name=spatialdimnames[si],
                                                     units=opts_global$spatial_dims[[si]]$units,
                                                     vals=opts_global$spatial_dims[[si]]$vals)
        }
        ncvars <- vector("list", l=length(datas_timmean))
        names(ncvars) <- names(datas_timmean)
        for (vi in seq_along(datas_timmean)) {
            ncvars[[vi]] <- ncdf4::ncvar_def(name=names(datas_timmean)[vi],
                                             units=vars_timmean[[vi]]$units,
                                             dim=c(ncdims_spatial, list(ncdim_time)), # time dim needs to be first (=last in r)
                                             missval=NA, longname=vars_timmean[[vi]]$longname)
        }
        outnc <- ncdf4::nc_create(fout, vars=ncvars, force_v4=T)
        for (vi in seq_along(datas_timmean)) {
            ncdf4::ncvar_put(outnc, ncvars[[vi]], datas_timmean[[vi]])
            #if (nspatialdims == 1) { # spatial mapping needed from 1D to 2D lon,lat
            #    ncdf4::ncatt_put(outnc, ncvars[[vi]], "CDI_grid_type", "unstructured") # test; not needed
            #}
        }
        ncdf4::ncatt_put(outnc, 0, "dataname", dataname)
        ncdf4::ncatt_put(outnc, 0, "varname", varname)
        ncdf4::ncatt_put(outnc, 0, "clim_from", as.character(clim_from))
        ncdf4::ncatt_put(outnc, 0, "clim_to", as.character(clim_to))
        ncdf4::ncatt_put(outnc, 0, "ts_from", as.character(ts_from))
        ncdf4::ncatt_put(outnc, 0, "ts_to", as.character(ts_to))
        ncdf4::ncatt_put(outnc, 0, "ts_dt_yrs", opts_global$ts_dt_yrs)
        ncdf4::ncatt_put(outnc, 0, "pctile", opts_global$heatwaveR_opts$pctile)
        ncdf4::ncatt_put(outnc, 0, "minDuration", opts_global$heatwaveR_opts$minDuration)
        ncdf4::ncatt_put(outnc, 0, "remove_trend", as.character(opts_global$heatwaveR_opts$remove_trend))
        ncdf4::ncatt_put(outnc, 0, "heatwaveR_packageVersion", as.character(opts_global$heatwaveR_opts$packageVersion))
        ncdf4::nc_close(outnc)

        # setgrid if wanted
        if (!is.null(setgrid_cmd) && is.null(remap_cmd)) {
            message("\nsetgrid timmean result")
            fin_setgrid <- fout
            fout_setgrid <- paste0(tools::file_path_sans_ext(fin_setgrid), "_setgrid.", tools::file_ext(fin_setgrid))
            cmd <- sub("<fin>", fin_setgrid, setgrid_cmd)
            cmd <- sub("<fout>", fout_setgrid, cmd)
            message("run `", cmd, "` ...")
            check <- system(cmd)
            if (check != 0) stop("error")
            invisible(file.rename(fout_setgrid, fout))
        }

        # remap if necessary
        if (!is.null(remap_cmd)) {
            message("\nremap timmean result")
            fin_remap <- fout
            fout_remap <- paste0(tools::file_path_sans_ext(fin_remap), "_remap_", names(remap_cmd), ".", tools::file_ext(fin_remap))
            cmd <- sub("<fin>", fin_remap, remap_cmd)
            cmd <- sub("<fout>", fout_remap, cmd)
            message("run `", cmd, "` ...")
            check <- system(cmd)
            if (check != 0) stop("error")
            invisible(file.rename(fout_remap, fout))
        }

    } # if timmean fout already exists or not
} # if calc_timmean


# calc ts
if (!calc_ts) {
    message("\n`calc_ts`=F --> dont calc ts of heatwaveR calc results ...")

} else if (calc_ts) {
    message("\n`calc_ts`=T --> calc ts of heatwaveR calc results ...")
    vars_ts <- known_vars
    inds <- match(vars_ts_wanted, names(vars_ts))
    if (any(is.na(inds))) stop("for `vars_ts_wanted` choose any of `known_vars`")
    vars_ts <- vars_ts[inds]
    if (any(names(vars_ts) == "nevents")) { # turn total events to events per output time interval
        vars_ts$nevents$longname <- "number of events"
    }

    # todo: so far only monthly output
    ts_from_lt <- as.POSIXlt(ts_from)
    ts_to_lt <- as.POSIXlt(ts_to)
    # use middle of month; could be any dom; does not matter
    time_out_mon <- seq.POSIXt(as.POSIXct(paste0(ts_from_lt$year+1900, "-", ts_from_lt$mon+1, "-15"), tz="UTC"),
                               as.POSIXct(paste0(ts_to_lt$year+1900, "-", ts_to_lt$mon+1, "-15"), tz="UTC"),
                               b="1 mon")
    time_out_mon <- as.POSIXlt(time_out_mon)
    message("`time_out_mon` from ", min(time_out_mon), " to ", max(time_out_mon), ":")
    cat(capture.output(str(time_out_mon)), sep="\n")

    # one (space,time) output file for each mhw variable to better handle large output files
    for (vi in seq_along(vars_ts)) {
        message("******************************************************\n",
                "calc ts var ", vi, "/", length(vars_ts), ": ", names(vars_ts)[vi],
                " at ", nloc, " locations ...")

        # ts nc output fname
        for (vari in seq_along(opts_global)) {
            if (vari == 1) fout <- ""
            if (vari > 1) fout <- paste0(fout, "_")
            fout <- paste0(fout,
                           ifelse(opts_global[[vari]]$heatwaveR_opts$coldSpells, "mcs", "mhw"),
                           "_", opts_global[[vari]]$varname,
                           ifelse(!is.null(opts_global[[vari]]$depth), paste0("_", opts_global[[vari]]$depth), ""),
                           "_pctile_", opts_global[[vari]]$heatwaveR_opts$pctile)
        } # for vari
        if (is_compound) fout <- paste0("ce_", fout)
        # todo: assume that following opts are identical for all variables
        fout <- paste0(fout,
                       "_ts_", format(ts_from, "%Y%m%d"), "-", format(ts_to, "%Y%m%d"),
                       "_clim_", format(clim_from, "%Y%m%d"), "-", format(clim_to, "%Y%m%d"),
                       "_minDuration_", opts_global[[1]]$heatwaveR_opts$minDuration,
                       "_", ifelse(is.na(opts_global[[1]]$heatwaveR_opts$clim_runmean), "fixed_baseline", paste0("runmean_", opts_global[[1]]$heatwaveR_opts$clim_runmean, "a")),
                       "_", ifelse(opts_global[[1]]$heatwaveR_opts$remove_trend, "wout", "with"), "Trend",
                       "_locinds_")
        fout <- paste0(pathout, "/select/", varname, "/", dataname, "/", fout)
        if (!is.null(files$loc_from)) {
            fout <- paste0(fout, files$loc_from_char[1], "-", files$loc_to_char[nfiles])
        } else {
            fout <- paste0(fout,
                           sprintf(paste0("%0", nchar(prod(spatialdims)), "i"), 1), "-",
                           sprintf(paste0("%0", nchar(prod(spatialdims)), "i"), prod(spatialdims)))
        }
        fout <- paste0(fout, "_nloc_", nloc, "_", names(vars_ts)[vi], ".nc")
        #stop("asd")
        if (file.exists(fout)) {
            message("\nfout\n   ", fout, "\nalready exists. skip ts calculation")
        } else {
            if (nchar(basename(fout)) > 255) stop("fout is > 255 characters long")
            dir.create(dirname(fout), recursive=T, showWarnings=F)
            if (!dir.exists(dirname(fout))) stop("could not create dir ", dirname(fout))

            # calc variable at every location
            data <- dataN <- array(0, dim=c(spatialdims, length(time_out_mon)))
            # oisst,         33 years, monthly: 1440 x 720 x  396 = 3.1G
            # oisst,         40 years, monthly: 1440 x 720 x  480 = 3.7G
            # fesom1, core,  33 years, monthly:     126859 x  396 = 383M
            # fesom1, core, 119 years, monthly:     126859 x 1428 = 1.3G

            for (loci in seq_len(nloc)) {
                if (loci %% 10000 == 0) message("loci ", loci, "/", nloc, " = ", round(loci/nloc*100), "%")
                loc_inds <- opts[[loci]]$locinds
                nevents_per_loc <- nrow(events[[loci]])
                for (eventi in seq_len(nevents_per_loc)) {
                    from_to <- as.POSIXlt(c(events[[loci]]$date_start[eventi], events[[loci]]$date_end[eventi]))
                    if (anyNA(from_to)) stop("this should not happen")
                    if (calc_ts_verbose) {
                        dt <- diff(from_to) + 1
                        message("eventi ", eventi, " from ", from_to[1], " to ",
                                from_to[2], " --> ", dt, " ", attributes(dt)$units)
                    }
                    time_inds_mon <- c(which(time_out_mon$year == from_to[1]$year & # from
                                             time_out_mon$mon == from_to[1]$mon),
                                       which(time_out_mon$year == from_to[2]$year & # to
                                             time_out_mon$mon == from_to[2]$mon))
                    if (length(time_inds_mon) == 1) { # event started and/or ended outside of wanted output time
                                                      # --> this might happen when `subset_from` and/or `subset_to` are set
                        if (from_to[1] < min(time_out_mon)) { # event starts before wanted output_time
                            time_inds_mon <- c(1, time_inds_mon) # from start of wanted time
                        } else if (from_to[2] > max(time_out_mon)) { # event ends after wanted output_time
                            time_inds_mon[2] <- length(time_out_mon) # until end of wanted time
                        }
                    } else if (length(time_inds_mon) > 2) {
                        stop("this should not happen")
                    }
                    time_inds_mon <- time_inds_mon[1]:time_inds_mon[2]
                    if (calc_ts_verbose) {
                        message("--> ", length(time_inds_mon), " out times from ",
                                paste(range(time_out_mon[time_inds_mon]), collapse=" to "))
                    }

                    # repeat spatial inds for all output time inds
                    inds <- base::cbind(t(matrix(rep(loc_inds, t=length(time_inds_mon)), ncol=length(time_inds_mon))), time_inds_mon,
                                        deparse.level=0) # deparse.level=0: do not make labels
                    # e.g. output time points 5,6,7 at location 3 (1D space dim):
                    # 3 5
                    # 3 6
                    # 3 7
                    # e.g. output time points 5,6,7 at location (664,47) (2D space dim):
                    # 664 47 5
                    # 664 47 6
                    # 664 47 7
                    if (F && calc_ts_verbose) {
                        message("inds:")
                        print(inds)
                    }
                    #if (length(time_inds_mon) > 1) stop("asd") # event longer than 1 output time interval
                    #if (nrow(inds) > 1) stop("asd") # event longer than 1 output time interval

                    if (names(vars_ts)[vi] == "nevents") {
                        # map number of events from event-space to nc output frequency:
                        # --> nevents in event-space:
                        # event 1 1982-01-09 1982-01-23
                        # event 2 1983-11-30 1983-12-05
                        # event 3 1984-01-09 1984-03-05
                        # event 4 1986-01-24 1986-01-31
                        # event 5 1987-09-02 1987-09-09
                        # event 6 1987-09-16 1987-09-21
                        # --> nevents in monthly nc file
                        # time 1  1982-01 1/1 --> event 1
                        # time ...          0
                        # time 23 1983-11 1/2 --> event 2
                        # time 24 1983-12 1/2 --> event 2
                        # time 25 1984-01 1/3 --> event 3
                        # time 26 1984-02 1/3 --> event 3
                        # time 27 1984-03 1/3 --> event 3
                        # time ...          0
                        # time 49 1986-01 1/1 --> event 4
                        # time ...          0
                        # time 69 1987-09 2/1 --> events 5 and 6
                        # --> annual number of events = yearsum(nevents_monthly)
                        data[inds] <- data[inds] + 1/length(time_inds_mon)

                    } else if (names(vars_ts)[vi] == "duration") {
                        # map event duration (days) from event-space to nc output frequency:
                        # -> duration in event-space:
                        #         date_start   date_end   duration
                        # event 1 1982-01-09 1982-01-23         15
                        # event 2 1983-11-30 1983-12-05          6
                        # event 3 1984-01-09 1984-03-05         57
                        # event 4 1986-01-24 1986-01-31          8
                        # event 5 1987-09-02 1987-09-09          8
                        # event 6 1987-09-16 1987-09-21          6
                        # -> duration in monthly nc file:
                        # time 1  1982-01  15 --> event 1
                        # time ...        nan
                        # time 23 1983-11   1 --> event 2
                        # time 24 1983-12   5 --> event 2 (6)
                        # time 25 1984-01  23 --> event 3
                        # time 26 1984-02  29 --> event 3 (52)
                        # time 27 1984-03   5 --> event 3 (57)
                        # time ...        nan
                        # time 49 1986-01   8 --> event 4
                        # time ...        nan
                        # time 69 1987-09   7 --> mean over 2 events 5 and 6: (8+6)/2 = 14/2 = 7
                        # --> annual mean event duration = yearsum(duration_monthly)/yearsum(nevents_monthly)
                        if (length(time_inds_mon) == 1) { # event within one month
                            data[inds] <- data[inds] + events[[loci]]$duration[eventi] # month gets duration of event
                        } else if (length(time_inds_mon) > 1) { # event longer than 1 month
                            ndays_of_start_month <- dpm[from_to[1]$mon+1] # e.g. 28 for Feb (posixlt$mon starts from 0)
                            if (from_to[1]$mon+1 == 2) { # event start month is Feb
                                if ((((from_to[1]$year+1900) %% 4 == 0) &
                                     ((from_to[1]$year+1900) %% 100 != 0)) |
                                    ((from_to[1]$year+1900) %% 400 == 0)) { # event start year is leap year
                                    ndays_of_start_month <- 29
                                }
                            }
                            duration_of_start_month <- ndays_of_start_month - from_to[1]$mday + 1 # e.g. mday = 26 for Dec 26th --> 31 - 26 + 1 = 6 days
                            duration_of_end_month <- from_to[2]$mday
                            if (length(time_inds_mon) > 2) { # event longer than 2 months
                                time_inds_between <- time_inds_mon[-c(1, length(time_inds_mon))]
                                days_per_month_between <- dpm[time_out_mon[time_inds_between]$mon+1] # e.g. 28 for Feb (posixlt$mon starts from 0)
                                feb_inds <- time_out_mon[time_inds_between]$mon+1 == 2 # months of times between start and end are Feb
                                leap_inds <- (((time_out_mon[time_inds_between]$year+1900) %% 4 == 0) &  # years of times between start and end are leap
                                              ((time_out_mon[time_inds_between]$year+1900) %% 100 != 0)) |
                                             ((time_out_mon[time_inds_between]$year+1900) %% 400 == 0)
                                feb29_inds <- feb_inds & leap_inds
                                if (any(feb29_inds)) days_per_month_between[feb29_inds] <- 29 # days for all leap-Feb between start and end month of event
                                rhs <- c(duration_of_start_month, days_per_month_between, duration_of_end_month)
                            } else { # event longer than 1 month but within 2 months
                                rhs <- c(duration_of_start_month, duration_of_end_month)
                            }
                            if (calc_ts_verbose) message("--> rhs = ", paste(rhs, collapse=", "),  " (sum = ", sum(rhs), ")")
                            if (sum(rhs) != events[[loci]]$duration[eventi]) stop("this should not happen")
                            data[inds] <- data[inds] + rhs
                        } # event across more than 1 month or not
                        dataN[inds] <- dataN[inds] + 1 # +1 event

                    } else { # default
                        # add values over events and divide through number of events if
                        # more than one event per output frequency (e.g. monthly)
                        # --> annual mean = yearmean(default_monthly)
                        data[inds] <- data[inds] + events[[loci]][[names(vars_ts)[vi]]][eventi]
                        dataN[inds] <- dataN[inds] + 1 # +1 event
                    }

                    #stop("asd")
                } # for eventi
                #stop("asd")
            } # for loci
            if (any(dataN > 1)) data <- data/dataN # average quantity per event, e.g. duration or mean intensity of 2 events at loction loci in one month
                                                   # 1/0 = Inf here
                                                   #     = -nan in nc output
            #stop("asd")

            # nc output
            message("\nsave ts ", fout, " ...")

            ncdim_time <- ncdf4::ncdim_def(name="time",
                                           units="seconds since 1970-1-1",
                                           vals=as.numeric(time_out_mon))

            ncdims_spatial <- vector("list", l=nspatialdims)
            for (si in seq_along(ncdims_spatial)) {
                ncdims_spatial[[si]] <- ncdf4::ncdim_def(name=spatialdimnames[si],
                                                         units=opts_global[[1]]$spatial_dims[[si]]$units,
                                                         vals=opts_global[[1]]$spatial_dims[[si]]$vals)
            }

            ncvar <- ncdf4::ncvar_def(name=names(vars_ts)[vi],
                                      units=vars_ts[[vi]]$units,
                                      dim=c(ncdims_spatial, list(ncdim_time)), # time dim needs to be first (=last in r)
                                      missval=NA, longname=vars_ts[[vi]]$longname)
            outnc <- ncdf4::nc_create(fout, vars=ncvar, force_v4=T)
            ncdf4::ncvar_put(outnc, ncvar, data)
            ncdf4::ncatt_put(outnc, 0, "dataname", dataname)
            ncdf4::ncatt_put(outnc, 0, "varname", varname)
            for (vari in seq_along(opts_global)) {
                ncdf4::ncatt_put(outnc, 0, paste0("varname", vari), opts_global[[vari]]$varname)
                ncdf4::ncatt_put(outnc, 0, paste0("depth", vari), ifelse(is.null(opts_global[[vari]]$depth), "NULL", opts_global[[vari]]$depth))
                ncdf4::ncatt_put(outnc, 0, paste0("pctile", vari), opts_global[[vari]]$heatwaveR_opts$pctile)
            }
            ncdf4::ncatt_put(outnc, 0, "clim_from", as.character(clim_from))
            ncdf4::ncatt_put(outnc, 0, "clim_to", as.character(clim_to))
            ncdf4::ncatt_put(outnc, 0, "ts_from", as.character(ts_from))
            ncdf4::ncatt_put(outnc, 0, "ts_to", as.character(ts_to))
            ncdf4::ncatt_put(outnc, 0, "ts_dt_yrs", ts_dt_yrs)
            ncdf4::ncatt_put(outnc, 0, "minDuration", opts_global[[1]]$heatwaveR_opts$minDuration)
            ncdf4::ncatt_put(outnc, 0, "remove_trend", as.character(opts_global[[1]]$heatwaveR_opts$remove_trend))
            ncdf4::ncatt_put(outnc, 0, "heatwaveR_packageVersion", as.character(opts_global[[1]]$heatwaveR_opts$packageVersion))
            ncdf4::nc_close(outnc)

            # setgrid if wanted
            if (!is.null(setgrid_cmd)) {
                message("\nsetgrid ts result")
                fout_setgrid <- paste0(tools::file_path_sans_ext(fout), "_setgrid.", tools::file_ext(fout))
                cmd <- sub("<fin>", fout, setgrid_cmd)
                cmd <- sub("<fout>", fout_setgrid, cmd)
                message("run `", cmd, "` ...")
                check <- system(cmd)
                if (check != 0) stop("error")
                invisible(file.rename(fout_setgrid, fout))
            }

        } # if fout already exists or not
    } # for vi

} # if calc_ts


## save event date-and-location pairs for composite analyses of composite_heatwaveR.r
if (calc_event_inds) {
    message("\n`calc_event_inds` --> loop over ", nloc, " locations and save event date-and-location inds for composite/compound ...")
    stop("update run mean")

    # event_inds_an_res_day
    # year,from,to,nodes_2d
    # 1987,1987-10-06,1987-10-12 23:59:59,1
    # 1988,1988-01-02,1988-01-06 23:59:59,1
    # 1989,1989-11-22,1989-11-26 23:59:59,1
    # 1990,1990-06-05,1990-10-07 23:59:59,1
    # 1991,1991-06-23,1991-09-13 23:59:59,1
    # 1992,1992-01-05,1992-01-20 23:59:59,1
    # 1994,1994-05-14,1994-07-18 23:59:59,1
    # 1994,1994-07-22,1994-08-14 23:59:59,1
    # 1994,1994-08-30,1994-09-05 23:59:59,1

    # event_inds_an_res_mon
    # year,from,to,nodes_2d
    # 1987,1987-10-01,1987-10-31 23:59:59,1
    # 1988,1988-01-01,1988-01-31 23:59:59,1
    # 1989,1989-11-01,1989-11-30 23:59:59,1
    # 1990,1990-06-01,1990-10-31 23:59:59,1
    # 1991,1991-06-01,1991-09-30 23:59:59,1
    # 1992,1992-01-01,1992-01-31 23:59:59,1
    # 1994,1994-05-01,1994-07-31 23:59:59,1
    # 1994,1994-07-01,1994-08-31 23:59:59,1
    # 1994,1994-08-01,1994-09-30 23:59:59,1

    # event_inds_mon_res_day
    # year,month,from,to,nodes_2d
    # 1987,10,1987-10-06,1987-10-12 23:59:59,1
    # 1988,1,1988-01-02,1988-01-06 23:59:59,1
    # 1989,11,1989-11-22,1989-11-26 23:59:59,1
    # 1990,6,1990-06-05,1990-06-30 23:59:59,1
    # 1990,7,1990-07-01,1990-07-31 23:59:59,1
    # 1990,8,1990-08-01,1990-08-31 23:59:59,1
    # 1990,9,1990-09-01,1990-09-30 23:59:59,1
    # 1990,10,1990-10-01,1990-10-07 23:59:59,1
    # 1991,6,1991-06-23,1991-06-30 23:59:59,1

    # event_inds_mon_res_mon
    # year,month,from,to,nodes_2d
    # 1987,10,1987-10-01,1987-10-31 23:59:59,1
    # 1988,1,1988-01-01,1988-01-31 23:59:59,1
    # 1989,11,1989-11-01,1989-11-30 23:59:59,1
    # 1990,6,1990-06-01,1990-06-30 23:59:59,1
    # 1990,7,1990-07-01,1990-07-31 23:59:59,1
    # 1990,8,1990-08-01,1990-08-31 23:59:59,1
    # 1990,9,1990-09-01,1990-09-30 23:59:59,1
    # 1990,10,1990-10-01,1990-10-31 23:59:59,1
    # 1991,6,1991-06-01,1991-06-30 23:59:59,1

    event_inds_an_res_day_fout <- paste0(pathout, "/event_inds/", varname, "/", dataname, "/nchunks_", nchunks, "/",
                                         dataname,
                                         "_", ifelse(opts_global$heatwaveR_opts$coldSpells, "mcs", "mhw"),
                                         "_", opts_global$varname,
                                         "_ts_", format(ts_from, "%Y%m%d"), "-", format(ts_to, "%Y%m%d"),
                                         "_clim_", format(clim_from, "%Y%m%d"), "-", format(clim_to, "%Y%m%d"),
                                         "_pctile_", opts_global$heatwaveR_opts$pctile,
                                         "_minDuration_", opts_global$heatwaveR_opts$minDuration,
                                         "_", ifelse(opts_global$heatwaveR_opts$remove_trend, "wout", "with"), "Trend",
                                         "_locinds_")
    if (!is.null(files$loc_from)) {
        event_inds_an_res_day_fout <- paste0(event_inds_an_res_day_fout, files$loc_from_char[1], "-", files$loc_to_char[nfiles])
    } else {
        event_inds_an_res_day_fout <- paste0(event_inds_an_res_day_fout,
                       sprintf(paste0("%0", nchar(prod(spatialdims)), "i"), 1), "-",
                       sprintf(paste0("%0", nchar(prod(spatialdims)), "i"), prod(spatialdims)))
    }
    event_inds_an_res_day_fout <- paste0(event_inds_an_res_day_fout, "_nloc_", nloc, "_event_inds_")
    event_inds_an_res_mon_fout <- paste0(event_inds_an_res_day_fout, "an_res_mon.RData")
    event_inds_mon_res_day_fout <- paste0(event_inds_an_res_day_fout, "mon_res_day.RData")
    event_inds_mon_res_mon_fout <- paste0(event_inds_an_res_day_fout, "mon_res_mon.RData")
    event_inds_an_res_day_fout <- paste0(event_inds_an_res_day_fout, "an_res_day.RData")
    if (T && file.exists(event_inds_an_res_day_fout)) {
        message("\nfout\n   ", event_inds_an_res_day_fout, "\nalready exists. skip constructing selection commands")
    } else {

        message("save results to ", event_inds_an_res_day_fout, " ...")
        dir.create(dirname(event_inds_an_res_day_fout), recursive=T, showWarnings=F)
        if (!dir.exists(dirname(event_inds_an_res_day_fout))) stop("could not create dir ", dirname(event_inds_an_res_day_fout))

        # allocate data frames of unknown length
        event_inds_an_res_day_df <- data.frame(integer(0), character(0), character(0)) # character type will be overwritten by posixct type in loop below
        for (si in seq_len(nspatialdims)) {
            event_inds_an_res_day_df <- cbind(event_inds_an_res_day_df, data.frame(integer(0)))
        }
        colnames(event_inds_an_res_day_df) <- c("year", "from", "to", spatialdimnames)
        event_inds_an_res_mon_df <- event_inds_an_res_day_df
        event_inds_mon_res_day_df <- data.frame(integer(0), integer(0), character(0), character(0))
        for (si in seq_len(nspatialdims)) {
            event_inds_mon_res_day_df <- cbind(event_inds_mon_res_day_df, data.frame(integer(0)))
        }
        colnames(event_inds_mon_res_day_df) <- c("year", "month", "from", "to", spatialdimnames)
        event_inds_mon_res_mon_df <- event_inds_mon_res_day_df

        # appending entries to data.frame of unknown length is slow
        # --> use data.table instead
        # --> did not find a way to initialize dt of length zero with column type POSIXct
        # --> overwrite dt coltypes once in loop below if nrow=0
        if (append_method == "rbindlist") {
            event_inds_an_res_day_dt <- data.table::as.data.table(event_inds_an_res_day_df)
            event_inds_an_res_mon_dt <- data.table::as.data.table(event_inds_an_res_mon_df)
            event_inds_mon_res_day_dt <- data.table::as.data.table(event_inds_mon_res_day_df)
            event_inds_mon_res_mon_dt <- data.table::as.data.table(event_inds_mon_res_mon_df)
        }

        # for all locations
        for (loci in seq_len(nloc)) {

            if (nrow(events[[loci]]) > 0) { # if there are any events
                nevents_per_loc <- length(events[[loci]]$date_start)
                cat("\rloci ", sprintf(paste0("%0", nchar(nloc), "i"), loci), "/", nloc,
                    " (", sprintf(paste0("%0", nchar(max(nevents_tot)), "i"), nevents_per_loc), " events)", sep="")
                locinds <- opts[[loci]]$locinds

                # for all events of current location
                for (eventi in seq_len(nevents_per_loc)) {

                    # start and end of current event at current location
                    start_of_event <- as.POSIXlt(events[[loci]]$date_start[eventi])
                    end_of_event <- as.POSIXlt(events[[loci]]$date_end[eventi])
                    days_of_event <- as.POSIXlt(seq(start_of_event, end_of_event, b="1 day"))
                    months_of_event <- as.integer(unique(days_of_event$mon)+1)
                    years_of_event <- as.integer(unique(days_of_event$year)+1900)

                    # map event time-location dimensions to nc file dimensions
                    for (yi in seq_along(years_of_event)) {
                        inds <- which(days_of_event$year+1900 == years_of_event[yi])
                        start_of_event_yi <- days_of_event[inds[1]]
                        end_of_event_yi <- days_of_event[inds[length(inds)]]
                        months_of_event_yi <- seq(start_of_event_yi$mon, end_of_event_yi$mon, b=1) + 1 # +1 due to posix

                        # full day of event start date
                        end_of_event_yi$hour <- 23
                        end_of_event_yi$min <- end_of_event_yi$sec <- 59

                        # full month of event start date
                        ndays_of_month_of_start_of_event_yi <- dpm[start_of_event_yi$mon+1] # e.g. 31 if event start month is Jan
                        if (start_of_event_yi$mon+1 == 2) { # event start month is Feb
                            if (((years_of_event[yi] %% 4 == 0) &
                                 (years_of_event[yi] %% 100 != 0)) |
                                (years_of_event[yi] %% 400 == 0)) { # event year is leap year
                                ndays_of_month_of_start_of_event_yi <- 29
                            }
                        }
                        start_of_event_yi_full_month_start <- as.POSIXlt(paste0(years_of_event[yi], "-",
                                                                                start_of_event_yi$mon+1, "-",
                                                                                "1 ",
                                                                                "0:0:0"), tz="UTC")
                        start_of_event_yi_full_month_end <- as.POSIXlt(paste0(years_of_event[yi], "-",
                                                                              start_of_event_yi$mon+1, "-",
                                                                              ndays_of_month_of_start_of_event_yi, " ",
                                                                              "23:59:59"), tz="UTC")

                        # full month of event end date
                        ndays_of_month_of_end_of_event_yi <- dpm[end_of_event_yi$mon+1] # e.g. 31 if event end month is Jan
                        if (end_of_event_yi$mon+1 == 2) { # event end month is Feb
                            if (((years_of_event[yi] %% 4 == 0) &
                                 (years_of_event[yi] %% 100 != 0)) |
                                (years_of_event[yi] %% 400 == 0)) { # event year is leap year
                                ndays_of_month_of_end_of_event_yi <- 29
                            }
                        }
                        end_of_event_yi_full_month_start <- as.POSIXlt(paste0(years_of_event[yi], "-",
                                                                              end_of_event_yi$mon+1, "-",
                                                                              "1 ",
                                                                              "0:0:0"), tz="UTC")
                        end_of_event_yi_full_month_end <- as.POSIXlt(paste0(years_of_event[yi], "-",
                                                                            end_of_event_yi$mon+1, "-",
                                                                            ndays_of_month_of_end_of_event_yi, " ",
                                                                            "23:59:59"), tz="UTC")

                        # full year of event start date
                        event_yi_full_year_start <- as.POSIXlt(paste0(years_of_event[yi], "-1-1 0:0:0"), tz="UTC")
                        event_yi_full_year_end <- as.POSIXlt(paste0(years_of_event[yi], "-12-31 23:59:59"), tz="UTC")

                        # construct selection cmd from annual files
                        if (length(years_of_event) == 1) { # event is completely within 1 year

                            # case: annual files, daily res, event completely within 1 year
                            row <- data.frame(years_of_event[yi], start_of_event_yi, end_of_event_yi, t(locinds)) # data.frame coerces POSIXlt to POSIXct
                            colnames(row) <- colnames(event_inds_an_res_day_df)
                            if (append_method == "rbind") { # default rbind slow
                                event_inds_an_res_day_df <- rbind(event_inds_an_res_day_df, row)
                            } else if (append_method == "rbindlist") {
                                if (nrow(event_inds_an_res_day_dt) == 0) { # did not find a way to initialize dt of length zero with column type POSIXct
                                    event_inds_an_res_day_dt <- data.table::as.data.table(row)
                                } else {
                                    event_inds_an_res_day_dt <- data.table::rbindlist(list(event_inds_an_res_day_dt, row))
                                }
                            }

                            # case: annual files, monthly res, event completely within 1 year
                            row <- data.frame(years_of_event[yi], start_of_event_yi_full_month_start, end_of_event_yi_full_month_end, t(locinds))
                            colnames(row) <- colnames(event_inds_an_res_mon_df)
                            if (append_method == "rbind") {
                                event_inds_an_res_mon_df <- rbind(event_inds_an_res_mon_df, row)
                            } else if (append_method == "rbindlist") {
                                if (nrow(event_inds_an_res_mon_dt) == 0) {
                                    event_inds_an_res_mon_dt <- data.table::as.data.table(row)
                                } else {
                                    event_inds_an_res_mon_dt <- data.table::rbindlist(list(event_inds_an_res_mon_dt, row))
                                }
                            }

                        } else { # event spreads over multiple years

                            # case: annual files, daily res, event spreads over multiple years
                            # and
                            # case: annual files, monthly res, event spreads over multiple years
                            if (yi == 1) { # first event year
                                row <- data.frame(years_of_event[yi], start_of_event_yi, event_yi_full_year_end, t(locinds))
                                colnames(row) <- colnames(event_inds_an_res_day_df)
                                if (append_method == "rbind") {
                                    event_inds_an_res_day_df <- rbind(event_inds_an_res_day_df, row)
                                } else if (append_method == "rbindlist") {
                                    if (nrow(event_inds_an_res_day_dt) == 0) {
                                        event_inds_an_res_day_dt <- data.table::as.data.table(row)
                                    } else {
                                        event_inds_an_res_day_dt <- data.table::rbindlist(list(event_inds_an_res_day_dt, row))
                                    }
                                }
                                row <- data.frame(years_of_event[yi], start_of_event_yi_full_month_start, event_yi_full_year_end, t(locinds))
                                colnames(row) <- colnames(event_inds_an_res_mon_df)
                                if (append_method == "rbind") {
                                    event_inds_an_res_mon_df <- rbind(event_inds_an_res_mon_df, row)
                                } else if (append_method == "rbindlist") {
                                    if (nrow(event_inds_an_res_mon_dt) == 0) {
                                        event_inds_an_res_mon_dt <- data.table::as.data.table(row)
                                    } else {
                                        event_inds_an_res_mon_dt <- data.table::rbindlist(list(event_inds_an_res_mon_dt, row))
                                    }
                                }

                            } else if (yi == length(years_of_event)) { # last event year
                                row <- data.frame(years_of_event[yi], event_yi_full_year_start, end_of_event_yi, t(locinds))
                                colnames(row) <- colnames(event_inds_an_res_day_df)
                                if (append_method == "rbind") {
                                    event_inds_an_res_day_df <- rbind(event_inds_an_res_day_df, row)
                                } else if (append_method == "rbindlist") {
                                    if (nrow(event_inds_an_res_day_dt) == 0) {
                                        event_inds_an_res_day_dt <- data.table::as.data.table(row)
                                    } else {
                                        event_inds_an_res_day_dt <- data.table::rbindlist(list(event_inds_an_res_day_dt, row))
                                    }
                                }
                                row <- data.frame(years_of_event[yi], event_yi_full_year_start, end_of_event_yi_full_month_end, t(locinds))
                                colnames(row) <- colnames(event_inds_an_res_mon_df)
                                if (append_method == "rbind") {
                                    event_inds_an_res_mon_df <- rbind(event_inds_an_res_mon_df, row)
                                } else if (append_method == "rbindlist") {
                                    if (nrow(event_inds_an_res_mon_dt) == 0) {
                                        event_inds_an_res_mon_dt <- data.table::as.data.table(row)
                                    } else {
                                        event_inds_an_res_mon_dt <- data.table::rbindlist(list(event_inds_an_res_mon_dt, row))
                                    }
                                }

                            } else { # year(s) in between first and last event years
                                row <- data.frame(years_of_event[yi], event_yi_full_year_start, event_yi_full_year_end, t(locinds))
                                colnames(row) <- colnames(event_inds_an_res_day_df)
                                if (append_method == "rbind") {
                                    event_inds_an_res_day_df <- rbind(event_inds_an_res_day_df, row)
                                    event_inds_an_res_mon_df <- rbind(event_inds_an_res_mon_df, row)
                                } else if (append_method == "rbindlist") {
                                    if (nrow(event_inds_an_res_day_dt) == 0) {
                                        event_inds_an_res_day_dt <- event_inds_an_res_mon_dt <- data.table::as.data.table(row)
                                    } else {
                                        event_inds_an_res_day_dt <- data.table::rbindlist(list(event_inds_an_res_day_dt, row))
                                        event_inds_an_res_mon_dt <- data.table::rbindlist(list(event_inds_an_res_mon_dt, row))
                                    }
                                }
                            }
                        } # if event is completely within 1 year or not

                        # construct selection cmd from monthly files
                        if (length(months_of_event_yi) == 1) { # event is completely within 1 month

                            # case: monthly files, daily res, event completely within 1 month
                            row <- data.frame(years_of_event[yi], months_of_event_yi, start_of_event_yi, end_of_event_yi, t(locinds))
                            colnames(row) <- colnames(event_inds_mon_res_day_df)
                            if (append_method == "rbind") {
                                event_inds_mon_res_day_df <- rbind(event_inds_mon_res_day_df, row)
                            } else if (append_method == "rbindlist") {
                                if (nrow(event_inds_mon_res_day_dt) == 0) {
                                    event_inds_mon_res_day_dt <- data.table::as.data.table(row)
                                } else {
                                    event_inds_mon_res_day_dt <- data.table::rbindlist(list(event_inds_mon_res_day_dt, row))
                                }
                            }

                            # case: monthly files, monthly res, event completely within 1 mon
                            row <- data.frame(years_of_event[yi], months_of_event_yi, start_of_event_yi_full_month_start, end_of_event_yi_full_month_end, t(locinds))
                            colnames(row) <- colnames(event_inds_mon_res_mon_df)
                            if (append_method == "rbind") {
                                event_inds_mon_res_mon_df <- rbind(event_inds_mon_res_mon_df, row)
                            } else if (append_method == "rbindlist") {
                                if (nrow(event_inds_mon_res_mon_dt) == 0) {
                                    event_inds_mon_res_mon_dt <- data.table::as.data.table(row)
                                } else {
                                    event_inds_mon_res_mon_dt <- data.table::rbindlist(list(event_inds_mon_res_mon_dt, row))
                                }
                            }

                        } else { # event spreads over multiple months

                            for (mi in seq_along(months_of_event_yi)) { # for all months of event

                                # case: monthly files, daily res, event spreads over multiple months
                                # and
                                # case: monthly files, monthly res, event spreads over multiple months
                                if (mi == 1) { # first event month
                                    row <- data.frame(years_of_event[yi], months_of_event_yi[mi], start_of_event_yi, start_of_event_yi_full_month_end, t(locinds))
                                    colnames(row) <- colnames(event_inds_mon_res_day_df)
                                    if (append_method == "rbind") {
                                        event_inds_mon_res_day_df <- rbind(event_inds_mon_res_day_df, row)
                                    } else if (append_method == "rbindlist") {
                                        if (nrow(event_inds_mon_res_day_dt) == 0) {
                                            event_inds_mon_res_day_dt <- data.table::as.data.table(row)
                                        } else {
                                            event_inds_mon_res_day_dt <- data.table::rbindlist(list(event_inds_mon_res_day_dt, row))
                                        }
                                    }

                                    row <- data.frame(years_of_event[yi], months_of_event_yi[mi], start_of_event_yi_full_month_start, start_of_event_yi_full_month_end, t(locinds))
                                    colnames(row) <- colnames(event_inds_mon_res_mon_df)
                                    if (append_method == "rbind") {
                                        event_inds_mon_res_mon_df <- rbind(event_inds_mon_res_mon_df, row)
                                    } else if (append_method == "rbindlist") {
                                        if (nrow(event_inds_mon_res_mon_dt) == 0) {
                                            event_inds_mon_res_mon_dt <- data.table::as.data.table(row)
                                        } else {
                                            event_inds_mon_res_mon_dt <- data.table::rbindlist(list(event_inds_mon_res_mon_dt, row))
                                        }
                                    }

                                } else if (mi == length(months_of_event_yi)) { # last event month
                                    row <- data.frame(years_of_event[yi], months_of_event_yi[mi], end_of_event_yi_full_month_start, end_of_event_yi, t(locinds))
                                    colnames(row) <- colnames(event_inds_mon_res_day_df)
                                    if (append_method == "rbind") {
                                        event_inds_mon_res_day_df <- rbind(event_inds_mon_res_day_df, row)
                                    } else if (append_method == "rbindlist") {
                                        if (nrow(event_inds_mon_res_day_dt) == 0) {
                                            event_inds_mon_res_day_dt <- data.table::as.data.table(row)
                                        } else {
                                            event_inds_mon_res_day_dt <- data.table::rbindlist(list(event_inds_mon_res_day_dt, row))
                                        }
                                    }
                                    row <- data.frame(years_of_event[yi], months_of_event_yi[mi], end_of_event_yi_full_month_start, end_of_event_yi_full_month_end, t(locinds))
                                    colnames(row) <- colnames(event_inds_mon_res_mon_df)
                                    if (append_method == "rbind") {
                                        event_inds_mon_res_mon_df <- rbind(event_inds_mon_res_mon_df, row)
                                    } else if (append_method == "rbindlist") {
                                        if (nrow(event_inds_mon_res_mon_dt) == 0) {
                                            event_inds_mon_res_mon_dt <- data.table::as.data.table(row)
                                        } else {
                                            event_inds_mon_res_mon_dt <- data.table::rbindlist(list(event_inds_mon_res_mon_dt, row))
                                        }
                                    }

                                } else { # month(s) in between first and last event months

                                    # full year of event start date
                                    ndays_of_event_yi_full_month_mi <- dpm[months_of_event_yi[mi]] # e.g. 31 if event month is Jan
                                    if (months_of_event_yi[mi] == 2) { # event end month is Feb
                                        if (((years_of_event[yi] %% 4 == 0) &
                                             (years_of_event[yi] %% 100 != 0)) |
                                            (years_of_event[yi] %% 400 == 0)) { # event year is leap year
                                            ndays_of_event_yi_full_month_mi <- 29
                                        }
                                    }
                                    event_yi_full_month_mi_start <- as.POSIXlt(paste0(years_of_event[yi], "-",
                                                                                      months_of_event_yi[mi], "-",
                                                                                      "1 ",
                                                                                      "0:0:0"), tz="UTC")
                                    event_yi_full_month_mi_end <- as.POSIXlt(paste0(years_of_event[yi], "-",
                                                                                    months_of_event_yi[mi], "-",
                                                                                    ndays_of_event_yi_full_month_mi, " ",
                                                                                    "23:59:59"), tz="UTC")

                                    row <- data.frame(years_of_event[yi], months_of_event_yi[mi], event_yi_full_month_mi_start, event_yi_full_month_mi_end, t(locinds))
                                    colnames(row) <- colnames(event_inds_mon_res_day_df)
                                    if (append_method == "rbind") {
                                        event_inds_mon_res_day_df <- rbind(event_inds_mon_res_day_df, row)
                                        event_inds_mon_res_mon_df <- rbind(event_inds_mon_res_mon_df, row)
                                    } else if (append_method == "rbindlist") {
                                        if (nrow(event_inds_mon_res_day_dt) == 0) {
                                            event_inds_mon_res_day_dt <- event_inds_mon_res_mon_dt <- data.table::as.data.table(row)
                                        } else {
                                            event_inds_mon_res_day_dt <- data.table::rbindlist(list(event_inds_mon_res_day_dt, row))
                                            event_inds_mon_res_mon_dt <- data.table::rbindlist(list(event_inds_mon_res_mon_dt, row))
                                        }
                                    }
                                }

                            } # for mi all event months
                        } # if event is completely within 1 month or not
                    } # for yi all event years

                    if (F) { # debug
                        message("\n********************************\neventi ", eventi)
                        message("start_of_event_yi: ", start_of_event_yi)
                        message("end_of_event_yi: ", end_of_event_yi)
                        message("event_inds_an_res_day_dt:")
                        print(event_inds_an_res_day_dt)
                        message("event_inds_an_res_mon_dt:")
                        print(event_inds_an_res_mon_dt)
                        message("event_inds_mon_res_day_dt:")
                        print(event_inds_mon_res_day_dt)
                        message("event_inds_mon_res_mon_dt:")
                        print(event_inds_mon_res_mon_dt)
                    }

                } # for eventi
                #stop("asd")

                if (F) { # debug
                    message("\n********************************\neventi ", eventi)
                    message("start_of_event_yi: ", start_of_event_yi)
                    message("end_of_event_yi: ", end_of_event_yi)
                    message("event_inds_an_res_day_dt:")
                    print(event_inds_an_res_day_dt)
                    message("event_inds_an_res_mon_dt:")
                    print(event_inds_an_res_mon_dt)
                    message("event_inds_mon_res_day_dt:")
                    print(event_inds_mon_res_day_dt)
                    message("event_inds_mon_res_mon_dt:")
                    print(event_inds_mon_res_mon_dt)
                }
                #stop("asd")

            } # if there are any events at loci
        } # for loci
        message()

        # save results
        if (append_method == "rbind") {
            message("save ",
                    nrow(event_inds_an_res_day_df), ", ", nrow(event_inds_an_res_mon_df), ", ",
                    nrow(event_inds_mon_res_day_df), ", ", nrow(event_inds_mon_res_mon_df),
                    " rows with selection inds as RData and txt ...")
            save(event_inds_an_res_day_df, file=event_inds_an_res_day_fout)
            save(event_inds_an_res_mon_df, file=event_inds_an_res_mon_fout)
            save(event_inds_mon_res_day_df, file=event_inds_mon_res_day_fout)
            save(event_inds_mon_res_mon_df, file=event_inds_mon_res_mon_fout)
            write.table(event_inds_an_res_day_df, file=paste0(tools::file_path_sans_ext(event_inds_an_res_day_fout), ".txt"), row.names=F, quote=F, sep="\t")
            write.table(event_inds_an_res_mon_df, file=paste0(tools::file_path_sans_ext(event_inds_an_res_mon_fout), ".txt"), row.names=F, quote=F, sep="\t")
            write.table(event_inds_mon_res_day_df, file=paste0(tools::file_path_sans_ext(event_inds_mon_res_day_fout), ".txt"), row.names=F, quote=F, sep="\t")
            write.table(event_inds_mon_res_mon_df, file=paste0(tools::file_path_sans_ext(event_inds_mon_res_mon_fout), ".txt"), row.names=F, quote=F, sep="\t")
        } else if (append_method == "rbindlist") {
            message("save ",
                    nrow(event_inds_an_res_day_dt), ", ", nrow(event_inds_an_res_mon_dt), ", ",
                    nrow(event_inds_mon_res_day_dt), ", ", nrow(event_inds_mon_res_mon_dt),
                    " rows with selection inds as RData and txt ...")
            save(event_inds_an_res_day_dt, file=event_inds_an_res_day_fout)
            save(event_inds_an_res_mon_dt, file=event_inds_an_res_mon_fout)
            save(event_inds_mon_res_day_dt, file=event_inds_mon_res_day_fout)
            save(event_inds_mon_res_mon_dt, file=event_inds_mon_res_mon_fout)
            write.table(event_inds_an_res_day_dt, file=paste0(tools::file_path_sans_ext(event_inds_an_res_day_fout), ".txt"), row.names=F, quote=F, sep=",")
            write.table(event_inds_an_res_mon_dt, file=paste0(tools::file_path_sans_ext(event_inds_an_res_mon_fout), ".txt"), row.names=F, quote=F, sep=",")
            write.table(event_inds_mon_res_day_dt, file=paste0(tools::file_path_sans_ext(event_inds_mon_res_day_fout), ".txt"), row.names=F, quote=F, sep=",")
            write.table(event_inds_mon_res_mon_dt, file=paste0(tools::file_path_sans_ext(event_inds_mon_res_mon_fout), ".txt"), row.names=F, quote=F, sep=",")
        }

    } # if fout does not already exist

} # if calc_event_inds

message("\nfinished\n")

