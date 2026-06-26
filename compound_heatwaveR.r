# r

# find union of multi-variable extreme events in time (= compound events)
# based on results of calc_heatwaveR.r
# 1) load global calc data to check if global spatial info agrees for all variables
# 2) apply potential location_inds subset
# 3) identify compound events

rm(list=ls())
if (!interactive()) {
    library(ncdf4)
    source("/home/a/a270073/scripts/r/functions/myfunctions.r") # identical_list
}
library(data.table) # quicker adding to df of unknown length (number of compound events to be deteced is unknown)?
library(tibble) # to mimic heatwaveR::detect_event()

verbose <- F
#options(warn=2)

if (T) { # mhw + lox compounds; ce_tos_bgc22
    if (T) { # awi-esm-1-1-lr_kh800
        varnames <- c("tos", "bgc22")
        if (T) { # historical3_and_ssp585_2
            dataname <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2"
            if (F) { # surface; fixed baseline with trend
                depths <- c(NA, "0m")
                nchunks <- c(82, 82)
                files <- list(list.files(path=paste0("/work/ba1103/a270073/post/heatwaveR/calc/tos/", dataname, "/nchunks_", nchunks[1]),
                                         pattern=glob2rx(paste0(dataname, "_calc_mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_fixed_baseline_withTrend*.RData")),
                                         full.names=T),
                              list.files(path=paste0("/work/ba1103/a270073/post/heatwaveR/calc/bgc22/", dataname, "/nchunks_", nchunks[2]),
                                         pattern=glob2rx(paste0(dataname, "_calc_mcs_bgc22_", depths[2], "_ts_19820101-21001231_clim_19820101-20111231_pctile_10_minDuration_5_fixed_baseline_withTrend*.RData")),
                                         full.names=T))
                setting_label <- paste0(dataname, "_calc_ce",
                                        "_mhw_", varnames[1], ifelse(!is.na(depths[1]), paste0("_", depths[1]), ""), "_pctile_90",
                                        "_mcs_", varnames[2], ifelse(!is.na(depths[2]), paste0("_", depths[2]), ""), "_pctile_10",
                                        "_ts_19820101-21001231_clim_19820101-20111231_minDuration_5_fixed_baseline_withTrend")
            } else if (F) { # surface; fixed baseline wout trend
                depths <- c(NA, "0m")
                nchunks <- c(82, 82)
                files <- list(list.files(path=paste0("/work/ba1103/a270073/post/heatwaveR/calc/tos/", dataname, "/nchunks_", nchunks[1]),
                                         pattern=glob2rx(paste0(dataname, "_calc_mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_fixed_baseline_woutTrend*.RData")),
                                         full.names=T),
                              list.files(path=paste0("/work/ba1103/a270073/post/heatwaveR/calc/bgc22/", dataname, "/nchunks_", nchunks[2]),
                                         pattern=glob2rx(paste0(dataname, "_calc_mcs_bgc22_", depths[2], "_ts_19820101-21001231_clim_19820101-20111231_pctile_10_minDuration_5_fixed_baseline_woutTrend*.RData")),
                                         full.names=T))
                setting_label <- paste0(dataname, "_calc_ce",
                                        "_mhw_", varnames[1], ifelse(!is.na(depths[1]), paste0("_", depths[1]), ""), "_pctile_90",
                                        "_mcs_", varnames[2], ifelse(!is.na(depths[2]), paste0("_", depths[2]), ""), "_pctile_10",
                                        "_ts_19820101-21001231_clim_19820101-20111231_minDuration_5_fixed_baseline_woutTrend")
            } else if (F) { # surface; 31-yr running mean
                depths <- c(NA, "0m")
                nchunks <- c(160, 160)
                files <- list(list.files(path=paste0("/work/ba1103/a270073/post/heatwaveR/calc/tos/", dataname, "/nchunks_", nchunks[1]),
                                         pattern=glob2rx(paste0(dataname, "_calc_mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend*.RData")),
                                         full.names=T),
                              list.files(path=paste0("/work/ba1103/a270073/post/heatwaveR/calc/bgc22/", dataname, "/nchunks_", nchunks[2]),
                                         pattern=glob2rx(paste0(dataname, "_calc_mcs_bgc22_", depths[2], "_ts_19820101-21001231_clim_19820101-21001231_pctile_10_minDuration_5_runmean_31a_withTrend*.RData")),
                                         full.names=T))
                setting_label <- paste0(dataname, "_calc_ce",
                                        "_mhw_", varnames[1], ifelse(!is.na(depths[1]), paste0("_", depths[1]), ""), "_pctile_90",
                                        "_mcs_", varnames[2], ifelse(!is.na(depths[2]), paste0("_", depths[2]), ""), "_pctile_10",
                                        "_ts_19820101-21001231_clim_19820101-20111231_minDuration_5_runmean_31a_withTrend")
            } else if (F) { # surface; 15-yr running mean
                depths <- c(NA, "0m")
                nchunks <- c(160, 160)
                files <- list(list.files(path=paste0("/work/ba1103/a270073/post/heatwaveR/calc/tos/", dataname, "/nchunks_", nchunks[1]),
                                         pattern=glob2rx(paste0(dataname, "_calc_mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_15a_withTrend*.RData")),
                                         full.names=T),
                              list.files(path=paste0("/work/ba1103/a270073/post/heatwaveR/calc/bgc22/", dataname, "/nchunks_", nchunks[2]),
                                         pattern=glob2rx(paste0(dataname, "_calc_mcs_bgc22_", depths[2], "_ts_19820101-21001231_clim_19820101-21001231_pctile_10_minDuration_5_runmean_15a_withTrend*.RData")),
                                         full.names=T))
                setting_label <- paste0(dataname, "_calc_ce",
                                        "_mhw_", varnames[1], ifelse(!is.na(depths[1]), paste0("_", depths[1]), ""), "_pctile_90",
                                        "_mcs_", varnames[2], ifelse(!is.na(depths[2]), paste0("_", depths[2]), ""), "_pctile_10",
                                        "_ts_19820101-21001231_clim_19820101-20111231_minDuration_5_runmean_15a_withTrend")
            } else if (T) { # test different chunks per variable
                depths <- c(NA, "0m")
                nchunks <- c(82, 160)
                files <- list(list.files(path=paste0("/work/ba1103/a270073/post/heatwaveR/calc/tos/", dataname, "/nchunks_", nchunks[1]),
                                         pattern=glob2rx(paste0(dataname, "_calc_mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_fixed_baseline_withTrend*.RData")),
                                         full.names=T),
                              list.files(path=paste0("/work/ba1103/a270073/post/heatwaveR/calc/bgc22/", dataname, "/nchunks_", nchunks[2]),
                                         pattern=glob2rx(paste0(dataname, "_calc_mcs_bgc22_", depths[2], "_ts_19820101-21001231_clim_19820101-21001231_pctile_10_minDuration_5_runmean_15a_withTrend*.RData")),
                                         full.names=T))
                setting_label <- paste0(dataname, "_calc_ce",
                                        "_mhw_", varnames[1], ifelse(!is.na(depths[1]), paste0("_", depths[1]), ""), "_pctile_90",
                                        "_mcs_", varnames[2], ifelse(!is.na(depths[2]), paste0("_", depths[2]), ""), "_pctile_10",
                                        "_ts_19820101-21001231_clim_19820101-20111231_minDuration_5_tos_fixed_bgc22_runmean_15a_withTrend")
            } # which heatwaveR setting
        } # which period/experiments
    } # which data
} # which variables for compound

#nchunks_out <- max(nchunks) # old; better use more chunks = smaller files
#pathout <- paste0("/work/ba1103/a270073/post/heatwaveR/calc/ce_", paste(varnames, collapse="_"), "/", dataname, "/nchunks_160") # same nchunks as njobs_wanted in compound_heatwaveR_loop
pathout <- paste0("/work/ab1095/a270073/post/heatwaveR/calc/ce_", paste(varnames, collapse="_"), "/", dataname, "/nchunks_160")

if (F) { # old: does not take into account different nchunks per variable
    files <- lapply(files, "[", 28) # will be replaced by compound_heatwaveR_loop.r
}
if (T) { # new: apply location_inds later to take different chunks per variable into account
    location_inds <- 7:20 # will be replaced by compound_heatwaveR_loop.r
}

# runtime
# fesom, 119 years, 2 variables, 40 jobs: 309[4-5] locations (=2 files of nchunks=82, 154[7-8]): 20 to 75 min = 0.33 to 1.25 h
# fesom, 119 years, 2 variables, 40 jobs: 317[1-2] locations (=4 files of nchunks=160, 79[2-3]): 32 to 51 min = 0.53 to 0.85 h (only n=2)
# fesom, 119 years, 2 variables, 40 jobs: 4642 locations (=3 files of nchunks=82, 154[7-8]): 24 to 148 min = 0.4 to 2.46 h

##########################################################################################

# check
names(files) <- varnames
if (any(sapply(files, function(x) all(is.na(x))))) stop("provided zero files for some variable")
nfiles <- sapply(files, length)
if (any(nfiles == 0)) stop("provided zero files for some variable")
if (!exists("pathout")) stop("provide `pathout`")
dir.create(pathout, recursive=T, showWarnings=F)
if (!dir.exists(pathout)) stop("could not create pathout ", pathout)
if (exists("location_inds")) {
    if (!is.null(location_inds)) {
        if (!is.vector(location_inds)) stop("non-NULL `location_inds` must be vector")
        if (!all(is.finite(location_inds))) stop("non-NULL `location_inds` must all be finite")
        if (any(location_inds < 1)) stop("non-NULL `location_inds` must all be larger or equal 1")
    }
} else {
    location_inds <- NULL
}

# get location chunks if calc_heatwaveR.r ran with `location_inds`
files2 <- NULL
for (vi in seq_along(files)) {
    files2[[vi]] <- data.frame(file=files[[vi]])
    locs <- NULL # default
    if (any(grepl("_locinds_", files[[vi]]))) {
        loc_starts <- regexpr("_locinds_", files[[vi]])
        loc_ends <- regexpr("_nloc_", files[[vi]])
        loc_start_inds <- which(loc_starts != -1)
        loc_end_inds <- which(loc_ends != -1)
        if (length(loc_start_inds) == 0 || length(loc_end_inds) == 0 ||
            length(loc_start_inds) != length(loc_end_inds)) {
            stop("this should not happen")
        }
        locs <- substr(files[[vi]][loc_start_inds], loc_starts+9, loc_ends-1) # e.g. "0136725-0138515"
        locs <- strsplit(locs, "-")
        locs <- data.frame(from_char=sapply(locs, "[", 1), to_char=sapply(locs, "[", 2)) # e.g. "0136725"    "0138515"
        locs <- cbind(locs, from=as.integer(locs$from_char), to=as.integer(locs$to_char)) # e.g. 136725     138515
        loc_inds <- sort(locs$from, index.return=T)$ix
        locs <- locs[loc_inds,] # sort
        files[[vi]] <- files[[vi]][loc_inds]
        if (nfiles[vi] > 1) {
            loc_diffs_between_files <- c(NA, locs$from[2:nfiles[vi]] - locs$to[1:(nfiles[vi]-1)])
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
                    paste(paste0("file ", inds_from, " ", files[[vi]][inds_from], " from ", locs$from[inds_from], " to ", locs$to[inds_from], "\n",
                                 "file ", inds_to, " ", files[[vi]][inds_to], " from ", locs$from[inds_to], " to ", locs$to[inds_to], "\n--> diff = ",
                                 loc_diffs_between_files[inds_to]), collapse="\n"))
            options(warn=warn) # restore old value
        }
        files2[[vi]] <- data.frame(file=files2[[vi]]$file,
                                   loc_from=locs$from, loc_to=locs$to,
                                   loc_from_char=locs$from_char, loc_to_char=locs$to_char)
    } # if any filename has "_locinds_" pattern
} # for vi
files <- files2
rm(locs, files2)

if (F) { # old; check if nchunks_out makes sense
    nchunks_in <- sapply(files, nrow) # might differ to `nchunks` (of calc result) due to running this compound job in chunks as well
    nchunks_out_loop <- nchunks_out
    if (!any(nchunks_out_loop == nchunks_in)) { # e.g. wanted nchunks_out 82 does not fit to loaded nchunks_in 10
        message("input nchunks (nfiles) of ", length(varnames), " variables are (", paste(nchunks_in, collapse=", "),
                ") and wanted `nchunks_out_loop` = `nchunks_out` = ", nchunks_out_loop)
        if (length(unique(nchunks_in)) != 1) {
            stop("in this case input chunks of all variables must be equal. the case that they differ across variables is not yet implemented")
        }
        nchunks_out_loop <- nchunks_in[1] # e.g. 10 if this compound job was run with 10 chunks (files) of calc result
        message("--> update `nchunks_out_loop` to ", nchunks_out_loop)
    }
    chunks_out_varind <- which(nchunks_in == nchunks_out_loop)[1]
    if (is.na(chunks_out_varind) || length(chunks_out_varind) == 0) stop("this should not happen")
}

# load data
events_all_var <- vector("list", length=length(files)) # outputs of `calc_heatwaveR.r`
names(events_all_var) <- varnames
opts_all_var <- opts_global_all_var <- lms_all_var <- events_all_var
for (vi in seq_along(varnames)) {
    file_sizes_byte <- file.size(files[[vi]]$file)
    file_sizes_pretty <- sapply(file_sizes_byte, utils:::format.object_size, "auto")
    file_sizes_total_pretty <- utils:::format.object_size(sum(file_sizes_byte), units="auto")
    width <- options()$width
    options(width=2000)
    message("\nprovided ", nfiles[vi], " ", varnames[vi], " files (total ", file_sizes_total_pretty, ") :")
    print(files[[vi]])
    options(width=width) # restore old value
    events_all <- opts_all <- opts_global_all <- lms_all <- vector("list", length=nfiles[vi]) # outputs of `calc_heatwaveR.r`
    tic <- Sys.time()
    message("\nload ", nfiles[vi], " ", varnames[vi], " calc_heatwaveR result .RData files ...")
    for (fi in seq_len(nfiles[vi])) {
        message("load ", varnames[vi], " file ", fi, "/", nfiles[vi], " (", file_sizes_pretty[fi], "): ", files[[vi]]$file[fi], " ...")
        datnames <- base::load(files[[vi]]$file[fi]) # "events", "opts", "opts_global"; if calc_trend or remove_trend: "lms"
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
    message("--> took ", round(elapsed_sec), " sec = ", round(elapsed_sec/60), " min for ", nfiles[vi], " ", varnames[vi], " files")
    if (all(sapply(lms_all, is.null))) rm(lms_all)
    events_all_var[[vi]] <- events_all
    opts_all_var[[vi]] <- opts_all
    opts_global_all_var[[vi]] <- opts_global_all
    if (exists("lms_all")) lms_all_var[[vi]] <- lms_all
} # for vi
events_all <- events_all_var; rm(events_all_var) # fesom1, core, 119 years, 2 vars: 2 x 13G = 26G
opts_all <- opts_all_var; rm(opts_all_var)
opts_global_all <- opts_global_all_var; rm(opts_global_all_var)
if (exists("lms_all")) { lms_all <- lms_all_var; rm(lms_all_var) }
# events_all[[1]][[1]][[1]] --> var/chunk/loc: (nevents x 28)

# check if all `opt_global_all` are identical, which is normally the case for one dataset
opts_global <- vector("list", length=length(varnames))
names(opts_global) <- varnames
for (vi in seq_along(varnames)) {
    if (identical_list(opts_global_all[[vi]])) {
        message("\nall ", nfiles[vi], " ", varnames[vi], " `opts_global_all` objects are identical --> continue with the first ...")
        opts_global[[vi]] <- opts_global_all[[vi]][[1]]
    } else {
        stop("`opts_global_all[[", vi, "]]` objects of ", nfiles[vi], " ", varnames[vi], " files are not identical. that means not all `files` refer to the same data")
    }
} # for vi
rm(opts_global_all)
message("\n`opts_global`:")
cat(capture.output(str(opts_global)), sep="\n")
varunits <- sapply(lapply(opts_global, "[[", "varname_atts"), "[[", "units")
clim_from <- lapply(opts_global, "[[", "clim_from")
clim_to <- lapply(opts_global, "[[", "clim_to")
ts_from <- lapply(opts_global, "[[", "ts_from")
ts_to <- lapply(opts_global, "[[", "ts_to")
ts_dt_yrs <- sapply(opts_global, "[[", "ts_dt_yrs")

# repair my stupidity
for (vi in seq_along(varnames)) {
    ts_dt_yrs[vi] <- ceiling(ts_dt_yrs[vi]) # e.g. 314.99 yrs --> 315 yrs
    if (is.null(clim_from[[vi]]) || is.null(clim_to[[vi]])) {
        if (!is.null(opts_global[[vi]]$heatwaveR_opts$clim_runmean)) { # new
            if (!is.na(opts_global[[vi]]$heatwaveR_opts$clim_runmean)) { # runmean
                clim_from[[vi]] <- ts_from[[vi]]
                clim_to[[vi]] <- ts_to[[vi]]
            } else { # fixed baseline
                stop("not yet")
            }
        } else if (!is.null(opts_global[[vi]]$heatwaveR_opts$climatologyPeriod_posix)) { # old
            clim_from[[vi]] <- opts_global[[vi]]$heatwaveR_opts$climatologyPeriod_posix[1]
            clim_to[[vi]] <- opts_global[[vi]]$heatwaveR_opts$climatologyPeriod_posix[2]
            opts_global[[vi]]$heatwaveR_opts$clim_runmean <- NA
        } else {
            stop("this should not happen")
        }
    }
    if (is.null(clim_from[[vi]]) || is.null(clim_to[[vi]])) {
        stop("fix here")
    }
    if (F && substr(clim_from[[vi]], 1, 10) == "1849-12-31") {
        message("\nspecial: repair wrong `clim_from[[", vi, "]]` = ", clim_from[[vi]])
        clim_from[[vi]] <- as.POSIXct("1850-1-1", tz=as.POSIXlt(clim_to[[vi]])$zone)
        message("--> to ", clim_from[[vi]])
    }
} # for vi

# check spatial mapping
message("\ncheck spatial dims of all vars ...")
spatialdim_opts <- vector("list", length=length(varnames))
names(spatialdim_opts) <- varnames
for (vi in seq_along(varnames)) {
    spatialdim_opts[[vi]]$nspatialdims <- length(opts_global[[vi]]$spatial_dims)
    spatialdim_opts[[vi]]$spatialdimnames <- names(opts_global[[vi]]$spatial_dims)
    spatialdim_opts[[vi]]$spatialdims <- sapply(opts_global[[vi]]$spatial_dims, "[[", "len")
    spatialdim_opts[[vi]]$ntot <- prod(spatialdim_opts[[vi]]$spatialdims)
}
cat(capture.output(str(spatialdim_opts)), sep="\n")
for (vi in seq_along(varnames)) {
    if (spatialdim_opts[[vi]]$nspatialdims > 2) {
        stop(spatialdim_opts[[vi]]$nspatialdims, "D spatial dims case not defined (variable ", vi, ")")
    }
}
if (!identical_list(spatialdim_opts)) {
    # special case 1: fesom spatial dim names "nodes_2d" and "ncells" represent the same thing --> ok
    if (all(sapply(spatialdim_opts, "[[", "nspatialdims") == 1) && # all have one spatial dim
        length(unique(sapply(spatialdim_opts, "[[", "spatialdims"))) == 1 && # all of same length
        !any(is.na(match(c("nodes_2d", "ncells"), sapply(spatialdim_opts, "[[", "spatialdimnames"))))) { # all spatial dims called "nodes_2d" or "ncells"
    } else {
        stop("not all variables have same spatial infos")
    }
}
message("--> all look the same --> ok")

# reorder so that every entry is one location
# --> bring possibly differently chunked (`nchunks`) variables onto same spatial dims
for (vi in seq_along(varnames)) {
    if (!is.null(files[[vi]]$loc_from)) {
        message("\nreorder objects from ", nfiles[vi], " ", varnames[vi], " files so that every entry is one location ...")
        events <- opts <- list()
        if (exists("lms_all")) lms <- events
        cnt <- 0
        tic <- Sys.time()
        for (fi in seq_len(nfiles[vi])) {
            msg <- paste0("vi ", vi, "/", length(varnames), " var ", varnames[vi], " file ", fi, "/", nfiles[vi], ": `events_all[[vi=", vi, "]]` (",
                          utils:::format.object_size(object.size(events_all[[vi]][[fi]]), units="auto"), "), `opts_all[[vi=", vi, "]]` (",
                          utils:::format.object_size(object.size(opts_all[[vi]][[fi]]), units="auto"), ")")
            if (exists("lms_all")) {
                msg <- paste0(msg, ", `lms` (", utils:::format.object_size(object.size(lms_all[[vi]][[fi]]), units="auto"), ")")
            }
            msg <- paste0(msg, " ...")
            message(msg)
            for (loci in seq_along(events_all[[vi]][[fi]])) {
                cnt <- cnt + 1
                events[cnt] <- events_all[[vi]][[fi]][loci]
                opts[cnt] <- opts_all[[vi]][[fi]][loci]
                events_all[[vi]][[fi]][[loci]] <- NA # reduce work space
                opts_all[[vi]][[fi]][[loci]] <- NA
                if (exists("lms_all")) {
                    lms[cnt] <- lms_all[[vi]][[fi]][loci]
                    lms_all[[vi]][[fi]][[loci]] <- NA
                }
            } # for loci
        } # for fi
        toc <- Sys.time()
        elapsed_sec <- difftime(toc, tic, units="sec")
        message("--> took ", round(elapsed_sec), " sec = ", round(elapsed_sec/60), " min for objects of ", nfiles[vi], " ", varnames[vi], " files")
        events_all[[vi]] <- events
        opts_all[[vi]] <- opts
        if (exists("lms")) lms_all[[vi]] <- lms
    } else { # if is.null(files$loc_from)
        stop("implement")
    }
} # for vi
# events_all[[1]][[1]] --> var/loc: (nevents x 28)

# get number of locations per variable
# --> should be ntot for all vars since all data was loaded
nlocs <- sapply(events_all, length)
nloc <- unique(nlocs)
if (length(nloc) != 1) {
    stop("`nlocs` = ", paste(nlocs, collapse=", "),
         ", i.e. the number of locations differ between variables --> maybe you've loaded data from different depths/locations?")
}
ntot <- nloc
for (vi in seq_along(varnames)) {
    if (spatialdim_opts[[vi]]$ntot != ntot) {
        stop("`spatialdim_opts[[vi]]$ntot` = ", spatialdim_opts[[vi]]$ntot, " != ntot = ", ntot, ". this should not happen")
    }
}

message("\ncheck for location subset ...")
if (!is.null(location_inds)) { # new location subset
    message("--> `location_inds` = ", min(location_inds), ":", max(location_inds),
            "\n--> subset ", length(location_inds), " locations ...")
    for (vi in seq_along(varnames)) {
        events_all[[vi]] <- events_all[[vi]][location_inds]
        opts_all[[vi]] <- opts_all[[vi]][location_inds]
        if (exists("lms")) lms_all[[vi]] <- lms[[vi]][location_inds]
    }
    nloc <- length(location_inds) # update
} else { # `location_inds` not given --> use all locations
    nloc <- ntot
    message("--> `location_inds` is NULL --> use all ", nloc, " locations ...")
    location_inds <- seq_len(nloc) # all: 1,...,n
} # if !is.null(location_inds)

# construct fout
fout <- paste0(setting_label, "_locinds_",
               sprintf(paste0("%0", nchar(ntot), "i"), location_inds[1]), "-",
               sprintf(paste0("%0", nchar(ntot), "i"), location_inds[nloc]),
               "_nloc_", nloc,
               ".RData")
fout <- paste0(pathout, "/", fout)
message("\nsave results to fout = ", fout)
if (file.exists(fout)) stop("this file already exists")

# find compound events at every location
message("\nfind compound events of ", length(varnames), " variables ",
        paste(varnames, collapse=", "), " at ", nloc, " locations ...")
nevents_loci <- rep(NA, times=length(varnames))
events_ce <- vector("list", length=nloc)
tic <- Sys.time()
for (loci in seq_len(nloc)) {
#for (loci in 100) { # test

    if (loci == 1 || loci == nloc || loci %% 1e2 == 0) {
        message("loci ", loci, "/", nloc, " = ", round(loci/nloc*100), "%")
    }

    # todo: howto append data of unknown length as fast as possible?
    # --> data.table better than data.frame?
    # --> tibble better than data.table?
    # --> other alternatives?
    events_ce_dt <- data.frame(date_start=numeric(), date_end=numeric(), duration=numeric())
    events_ce_dt <- data.table::as.data.table(events_ce_dt)
    cnt_ce <- 0

    # loop through smallest number of events per variable
    #if (opts[[loci]]$loci == 41870) stop("asd") # --> loci = 100
    for (vi in seq_along(varnames)) {
        nevents_loci[vi] <- nrow(events_all[[vi]][[loci]])
        if (nevents_loci[vi] == 1) {
            if (all(is.na(events_all[[vi]][[loci]]))) stop("need to check if thats correct")
            nevents_loci[vi] <- 0 # heatwaveR detected zero events at that location
        }
    } # for vi
    if (any(nevents_loci) == 0) { # for some variable zero events were found at that location --> skip to next location

        # mimic heatwaveR::detect_event()
        events_ce[[loci]] <- tibble::as_tibble(data.frame(date_start=NA, date_end=NA, duration=NA))
        # --> looks like:
        # $ : tibble [0 × 3] (S3: tbl_df/tbl/data.frame)
        #  ..- attr(*, ".internal.selfref")=<externalptr>

    } else { # some events were found for each variable at current loci

        # to save time, loop through all events of that variable with the smallest number of events at current loci
        varind <- which.min(nevents_loci)
        other_varinds <- seq_along(varnames)[-varind]
        for (eventi in seq_len(nevents_loci[varind])) {

            days <- vector("list", length=length(varnames))
            names(days) <- varnames
            date_start_eventi <- events_all[[varind]][[loci]]$date_start[eventi]
            date_end_eventi <- events_all[[varind]][[loci]]$date_end[eventi]
            days[[varind]] <- list(base::seq.Date(date_start_eventi, date_end_eventi, by="1 day")) # list per event --> here for variable varind always just one
            if (verbose) {
                message("****************************************************************\n",
                        "loci ", loci, " eventi ", eventi, " from ", date_start_eventi, " to ", date_end_eventi)
            }

            # loop through all events of all other variables and check if there is any temporal overlap with current event
            for (vj in seq_along(other_varinds)) {
                tmp <- list() # list per event --> here for variable vj possibly more than one
                cnt <- 0
                for (eventj in seq_len(nevents_loci[other_varinds[vj]])) { # test: loci = 100; eventi = 8; eventj = 20
                    date_start_eventj <- events_all[[other_varinds[vj]]][[loci]]$date_start[eventj]
                    date_end_eventj <- events_all[[other_varinds[vj]]][[loci]]$date_end[eventj]
                    if (any(!is.na(match(c(date_start_eventj, date_end_eventj), days[[varind]][[1]])))) {
                        # eventj of variable vj has _any_ overlap with eventi of variable varind
                        # --> for CEs, there is usually no minimum day constraint as for individual extreme events (e.g. 5 days for MHWs, LOXs, ...)
                        cnt <- cnt + 1
                        tmp[[cnt]] <- base::seq.Date(date_start_eventj, date_end_eventj, by="1 day")
                    } # if eventj has any days within eventi
                } # for eventj
                days[[other_varinds[vj]]] <- tmp
            } # for vj

            if (F) { # add vars and events for test
                days[[other_varinds[vj]]][[length(days[[other_varinds[vj]]])+1]] <- seq.Date(days[[other_varinds[vj]]][[1]][11], days[[2]][[1]][14], by="1 day")
                days[[length(days)+1]] <- list()
                names(days)[length(days)] <- paste0("var", length(days))
                days[[length(days)]][[1]] <- seq.Date(days[[1]][[1]][1], days[[1]][[1]][5], by="1 day")
                days[[length(days)]][[2]] <- seq.Date(days[[1]][[1]][2], days[[1]][[1]][6], by="1 day")
            }

            # get common days of current eventi of vari and all other events of all other vars
            nevents_to_compare <- sapply(days, length)
            if (any(nevents_to_compare == 0)) { # no common days were found for all other variables for current eventi of vari
                if (verbose) {
                    message("no overlap with any of other variables events:")
                    for (vj in seq_along(other_varinds)) {
                        message("vj ", vj, ":")
                        print(paste0(events_all[[other_varinds[vj]]][[loci]]$date_start, " to ", events_all[[other_varinds[vj]]][[loci]]$date_end), width=500) # all events of var vj
                    }
                }
                # skip to next eventi of vari
            } else { # common days were found for all variables for current eventi of vari

                # restructure from e.g.
                #   list(var1=list(event1, event2), var2=list(event1, event2, event3), var3=list(event1)) # one of varX is always of length 1
                # to
                #   list(event1=list(var1, var2, var3), event2=list(var1, var2, var3), event3=list(var1, var2, var3),
                #        event4=list(var1, var2, var3), event5=list(var1, var2, var3), event6=list(var1, var2, var3))
                # --> maximum 2 x 3 = 6 possible CE combinations
                days_ce <- vector("list", length=prod(nevents_to_compare[-varind]))
                if (verbose) {
                    message("loci ", loci, "/", nloc, " variable ", varind, " ", varnames[varind],
                            " eventi ", eventi, "/", nrow(events_all[[varind]][[loci]]), ": append ",
                            length(days_ce), " compound events")
                }
                inds <- expand.grid(lapply(nevents_to_compare[-varind], seq_len)) # (n_event_combinations,n_vars)
                # e.g.:
                #   var1 var2 var3
                # 1    1    1    1
                # 2    2    1    1
                # 3    1    2    1
                # 4    2    2    1
                # 5    1    3    1
                # 6    2    3    1
                if (nrow(inds) != length(days_ce)) stop("this should not happen")
                if (ncol(inds) != length(other_varinds)) stop("this should not happen")
                for (cei in seq_along(days_ce)) {
                    tmp <- list(days[[varind]][[1]]) # always just one event of variable with least number of events at loci
                    for (vj in seq_along(other_varinds)) {
                        tmp[[length(tmp)+1]] <- days[[other_varinds[vj]]][[inds[cei,vj]]]
                    }
                    days_ce[[cei]] <- tmp
                }
                days_ce <- lapply(days_ce, function(x) base::Reduce(base::intersect, x))
                inds <- which(sapply(days_ce, length) > 0)
                if (length(inds) == 0) stop("this should not happen")
                days_ce <- days_ce[inds]

                # save start and end dates and duration of all compound events at current location loci
                dates_start <- as.Date(sapply(lapply(days_ce, range), "[[", 1), origin="1970-1-1")
                dates_end <- as.Date(sapply(lapply(days_ce, range), "[[", 2), origin="1970-1-1")
                durations <- sapply(days_ce, length)
                #inds <- order(dates_start)

                cnt_ce <- cnt_ce + 1
                rows <- data.frame(date_start=dates_start, date_end=dates_end, duration=durations)
                #if (cnt_ce == 2) stop("asd")
                if (cnt_ce == 1) {
                    events_ce_dt <- data.table::as.data.table(rows)
                } else {
                    events_ce_dt <- data.table::rbindlist(list(events_ce_dt, rows))
                }

            } # if there are common days for all variables or not

        } # for eventi

        # save results for current location
        events_ce[[loci]] <- tibble::as_tibble(events_ce_dt) # mimic heatwaveR::detect_event()

    } # if some events were found for each variable at current loci

    #stop("asd")

} # for loci
toc <- Sys.time()
elapsed_sec <- difftime(toc, tic, units="sec")
message("--> took ", round(elapsed_sec), " sec ~ ", round(elapsed_sec/60, 1), " min ~ ", round(elapsed_sec/60/60, 2), "h for ", nloc,
        " locations --> ", round(elapsed_sec/nloc, 5), " seconds per location")

#nevents_ce <- sapply(events_ce, nrow)

if (F) { # old
         # output chunk-wise to mimic result of calc_heatwaveR_loop.r that can be used by post_heatwaveR
    message("\nsave ce results ...")
    loc_inds_abs <- loc_inds_chunk <- vector("list", length=nchunks_out_loop)
    for (chunki in seq_len(nchunks_out_loop)) {

        loc_inds_abs[[chunki]] <- seq(files[[chunks_out_varind]]$loc_from[chunki], files[[chunks_out_varind]]$loc_to[chunki], by=1)
        if (chunki == 1) {
            loc_inds_chunk[[chunki]] <- seq(1, length(loc_inds_abs[[chunki]]), by=1)
        } else {
            loc_inds_chunk[[chunki]] <- seq(range(loc_inds_chunk[[chunki-1]])[2]+1, by=1, length.out=length(loc_inds_abs[[chunki]]))
        }
        fout <- paste0(setting_label, "_locinds_",
                       files[[chunks_out_varind]]$loc_from_char[chunki], "-", files[[chunks_out_varind]]$loc_to_char[chunki],
                       "_nloc_", length(loc_inds_abs[[chunki]]), ".RData")
        fout <- paste0(pathout, "/", fout)
        message("save chunk ", chunki, "/", nchunks_out_loop, " ces from locs ",
                paste(range(loc_inds_chunk[[chunki]]), collapse=" to "), " (n=",
                length(loc_inds_chunk[[chunki]]), "):\n", fout, " ...")
        if (file.exists(fout)) {
            message("--> file already exists. skip")
        } else {
            events <- events_ce[loc_inds_chunk[[chunki]]] # cannot `base::save(x[inds])` directly o_O
            opts <- opts_all[[1]][loc_inds_chunk[[chunki]]]
            base::save(events, opts, opts_global, file=fout) # must be same names as in calc_heatwaveR.r
        }

    } # for chunki

} else if (T) { # new
    message("\nsave ce results from ", nloc, " locations to\n   ", fout, " ...")
    events <- events_ce
    opts <- opts_all[[1]] # same location opts for all vars; was already checked earlier
    base::save(events, opts, opts_global, file=fout) # must be same names as in calc_heatwaveR.r

} # old/new

message("\nfinished\n")

