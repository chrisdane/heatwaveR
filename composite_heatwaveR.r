# r

# get mhw stats of arbitrary variable, e.g. mld mean over all detected mhw events
# based on event indices obtained by post_calc_heatwaveR.r with `calc_selection_inds=T`

# netcdf chunking (ncdump -hs) of input files is checked; error occurs if chunking is wrong
# https://github.com/ebimodeling/model-drivers/blob/master/met/cruncep/README.md

# todo: `..spatialdimnames`?

rm(list=ls())
if (!interactive()) library(ncdf4)
library(data.table)

if (T) { # awi-esm-1-1-lr_kh800_piControl
    dataname <- "awi-esm-1-1-lr_kh800_piControl"
    timedimname <- "time"
    spatialdimnames <- "nodes_2d"
    spatialdims <- 126859
    if (T) { # mhw events based on tos
        if (T) { # nchunks 82
            if (F) { # txt
                event_inds_files <- list.files(paste0("/work/ba1103/a270073/post/heatwaveR/event_inds/tos/", dataname, "/nchunks_82"),
                                                pattern=glob2rx("*ts_26860101-30001231_clim_26860101-30001231_pctile_90_minDuration_5_withTrend_locinds_*_event_inds_an_res_day.txt"),
                                                full.names=T)
            } else if (T) { # reading rdata faster than txt
                event_inds_files <- list.files(paste0("/work/ba1103/a270073/post/heatwaveR/event_inds/tos/", dataname, "/nchunks_82"),
                                                pattern=glob2rx("*ts_26860101-30001231_clim_26860101-30001231_pctile_90_minDuration_5_withTrend_locinds_*_event_inds_an_res_day.RData"),
                                                full.names=T)
            }
        } else if (F) { # nchunks 368
            event_inds_files <- list.files(paste0("/work/ba1103/a270073/post/heatwaveR/event_inds/tos/", dataname, "/nchunks_368"),
                                            pattern=glob2rx("*ts_26860101-30001231_clim_26860101-30001231_pctile_90_minDuration_5_withTrend_locinds_*_event_inds_an_res_day.RData"),
                                            full.names=T)
        } else if (F) { # nchunks 1065
            event_inds_files <- list.files(paste0("/work/ba1103/a270073/post/heatwaveR/event_inds/tos/", dataname, "/nchunks_1065"),
                                            pattern=glob2rx("*ts_26860101-30001231_clim_26860101-30001231_pctile_90_minDuration_5_withTrend_locinds_*_event_inds_an_res_day.RData"),
                                            full.names=T)
        }
    }
    if (T) { # will be replaced by composite_heatwaveR_loop.r
        event_inds_files <- event_inds_files[1]
    }
    #varname <- "tos"
    #varname <- "tauuo"
    #varname <- "tauvo"
    #varname <- "mlotst"
    #varname <- "omldamax"
    varname <- "sic"
    data_files <- list.files("/work/ba1103/a270073/out/awicm-1.0-recom/awi-esm-1-1-lr_kh800/piControl/outdata/post/fesom/chunked_ntime_nod2",
                             pattern=glob2rx(paste0(varname, "_fesom_????0101.nc")), full.names=T)
    if (F) { # test
        data_files <- data_files[1:2]
    }
    data_seas_file <- paste0("/work/ba1103/a270073/post/fesom/ydaymean/", varname, "/awi-esm-1-1-lr_kh800_piControl_fesom_ydaymean_", varname, "_global_Jan-Dec_2686-3000.nc")
    outpath <- paste0("/work/ba1103/a270073/post/heatwaveR/composite/", varname, "/", dataname)
}

##########################################################################################

# check input files and paths
nevent_inds_files <- length(event_inds_files)
if (nevent_inds_files == 0) stop("found zero event index files")
ndata_files <- length(data_files)
if (ndata_files == 0) stop("found zero data files")
event_fext <- tools::file_ext(event_inds_files[1])
if (!any(event_fext == c("txt", "RData"))) stop("event inds files extension must be one of \"txt\", \"RData\"")
data_fext <- tools::file_ext(data_files[1])
setting_label <- substr(basename(event_inds_files[1]), 1, regexpr("_locinds_", basename(event_inds_files[1]))-1)
dir.create(outpath, recursive=T, showWarnings=F)
if (file.access(outpath, 2) == -1) stop("no write permission to `outpath` = \"", outpath, "\"")
outpath <- normalizePath(outpath)
nspatialdims <- length(spatialdimnames)

# check if spatialdimnames of event index files fit to dimnames provided by user
if (event_fext == "txt") {
    header <- readLines(event_inds_files[1], n=1)
    header <- strsplit(header, ",")[[1]]
} else if (event_fext == "RData") {
    objname <- load(event_inds_files[1])
    header <- eval(parse(text=paste0("names(", objname, ")")))
} else {
    stop("file extension ", event_fext, " of event files ", event_inds_files[1], " not defined")
}
for (si in seq_along(spatialdimnames)) {
    if (any(is.na(match(spatialdimnames[si], header)))) {
        stop("provided spatialdimname \"", spatialdimnames[si], "\" not found in header ",
             paste(header, collapse=", "))
    }
}

# check nc infos
data_seas_nc <- ncdf4::nc_open(data_seas_file)
if (!any(names(data_seas_nc$var) == varname)) {
    stop("could not find provided variable \"", varname, "\" in seasonal climatology file. choose one of ",
         paste(names(data_seas_nc$var), collapse=", "), " or choose another file.")
}

# load event indices
message("\nread ", nevent_inds_files, " ", event_fext, " files with event indices (header = ",
        length(header), " columns \"", paste(header, collapse="\", \""), "\") ...")
elapsed <- system.time({
    for (fi in seq_len(nevent_inds_files)) {
        cat("\rread event index file ", sprintf(paste0("%0", nchar(nevent_inds_files), "i"), fi), "/", nevent_inds_files, sep="")
        if (event_fext == "txt") {
            if (fi == 1) { # initialize dt
                event_inds <- data.table::fread(event_inds_files[fi], skip=1, showProgress=F)
            } else {
                event_inds <- data.table::rbindlist(list(event_inds,
                                                    data.table::fread(event_inds_files[fi], skip=1, showProgress=F)))
            }
        } else if (event_fext == "RData") {
            if (fi == 1) {
                # data of first file was already loaded before
                eval(parse(text=paste0("event_inds <- ", objname)))
            } else {
                load(event_inds_files[fi])
                eval(parse(text=paste0("tmp <- ", objname)))
                event_inds <- data.table::rbindlist(list(event_inds, tmp))
            }
        }
    } # for fi
})[3]
message(" --> took ", round(elapsed), " sec = ", round(elapsed/60, 2), " min to load ", nrow(event_inds), " rows")
colnames(event_inds) <- header

if (F) { # save smaller event index chunks
    stop("asd")
    # save ~350 instead of 1587 locs per file --> 4.5 times more files
    #tmp <- "/work/ba1103/a270073/post/heatwaveR/event_inds/tos/awi-esm-1-1-lr_kh800_piControl/nchunks_368"
    # save ~125 instead of 1587 locs per file --> 13 times more files
    tmp <- "/work/ba1103/a270073/post/heatwaveR/event_inds/tos/awi-esm-1-1-lr_kh800_piControl/nchunks_1065"
    nfiles_new <- nevent_inds_files*13
    rowinds_tot <- as.integer(seq(1, nrow(event_inds), l=round(nfiles_new)))
    for (fi in seq_len(length(rowinds_tot)-1)) {
        if (fi == length(rowinds_tot)-1) { # last
            rowinds <- seq(rowinds_tot[fi], rowinds_tot[fi+1], b=1)
        } else {
            rowinds <- seq(rowinds_tot[fi], rowinds_tot[fi+1]-1, b=1)
        }
        dt <- event_inds[rowinds]
        locs <- range(dt[,..spatialdimnames])
        fout <- basename(event_inds_files[1]) # placeholder
        locinds_pattern <- substr(fout, regexpr("_locinds_", fout), regexpr("_event_inds_", fout))
        locinds_repl <- paste0("_locinds_",
                               sprintf(paste0("%0", nchar(spatialdims), "i"), locs[1]), "-",
                               sprintf(paste0("%0", nchar(spatialdims), "i"), locs[2]),
                               "_nloc_", length(locs[1]:locs[2]), "_")
        message(fi, ": ", locinds_repl, ": ", length(rowinds), " rows from ", min(rowinds), " to ", max(rowinds))
        fout <- paste0(tmp, "/", sub(locinds_pattern, locinds_repl, fout))
        save(dt, file=fout)
    } # for fi
    stop("asd")
}

# open all files
message("\nopen ", ndata_files, " data files ...")
ncs <- time_list <- vector("list", l=ndata_files)
for (fi in seq_along(data_files)) {

    message("open file ", fi, "/", ndata_files, ": ", data_files[fi])
    ncs[[fi]] <- ncdf4::nc_open(data_files[fi])

    if (fi == 1) {
        # check varname
        if (!any(names(ncs[[fi]]$var) == varname)) {
            stop("not any variable is called `varname` = \"", varname, "\".\n",
                 length(ncs[[fi]]$var), " available variables: \"",
                 paste(names(ncs[[fi]]$var), collapse="\", \""), "\".")
        }
        varname_atts <- ncatt_get(ncs[[fi]], varname)
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
        spatial_dims <- vector("list", l=nspatialdims)
        names(spatial_dims) <- spatialdimnames
        for (si in seq_len(nspatialdims)) {
            spatial_dims[[si]] <- list(len=ncs[[fi]]$dim[[spatialdimnames[si]]]$len,
                                       vals=ncs[[fi]]$dim[[spatialdimnames[si]]]$vals,
                                       units=ncs[[fi]]$dim[[spatialdimnames[si]]]$units)
        }
        nspatial_vals <- sapply(spatial_dims, "[[", "len")
    } # if fi == 1

    # check chunks of current file
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
    timevals <- as.POSIXct(ncs[[fi]]$dim[[timedimname]]$vals*timefac, o=timeorigin, tz="UTC")
    timelen <- length(timevals)
    timerange <- range(timevals)
    message("--> converted ", timelen, " time points in ", timeunit, " (origin=", timeorigin,
            ", fac=", timefac, ") to posix from ", timerange[1], " to ", timerange[2])
    time_list[[fi]] <- list(len=timelen, unit=timeunit, origin=timeorigin, fac=timefac, vals=timevals)

} # for fi

# checks after file reading
time_numeric <- unlist(lapply(time_list, "[[", "vals")) # same effect as `as.numeric`
data_dates <- as.POSIXlt(time_numeric, origin="1970-1-1", tz="UTC")
# set hour, min and sec to zero
data_dates$hour <- data_dates$min <- data_dates$sec <- 0
data_dates <- as.POSIXct(data_dates)
ntime <- length(data_dates)
data_from <- min(data_dates)
data_to <- max(data_dates)
message("--> loaded ", ntime, " time series timepoints from ", data_from, " to ", data_to)

# check time vals of event index files, data files, and seasonal climatology file
event_inds_from_to <- substr(event_inds_files[1],
                              start=regexpr("_clim_", event_inds_files[1])+6,
                              stop=regexpr("_clim_", event_inds_files[1])+22)
event_inds_from_to <- strsplit(event_inds_from_to, "-")[[1]]
event_inds_from_to <- as.POSIXct(event_inds_from_to, tz="UTC", format="%Y%m%d")
data_seas_dates <- system(paste0("cdo -s showdate ", data_seas_file), intern=T)
data_seas_dates <- strsplit(trimws(data_seas_dates), "\\s+")[[1]] # arbitrary number of spaces blanks
data_seas_dates <- as.POSIXct(data_seas_dates, tz="UTC")
if (data_from < event_inds_from_to[1]) {
    stop("start of data files ", data_from,
         " < start of event inds files ", event_inds_from_to[1])
}
if (data_to > event_inds_from_to[2]) {
    stop("end of data files ", data_to,
         " > end of event inds files ", event_inds_from_to[2])
}

# combine all events at same locations to reduce location loop
message("\naggregate ", nrow(event_inds), " events into unique locations ...")
#event_locs <- as.data.table(data.frame(a=c(1,2,3,4,5,1,2,1), b=c(2,3,4,5,6,1,3,2)))
#event_locs <- event_inds[event_year_inds,..spatialdimnames]
event_locs <- event_inds[,..spatialdimnames]
event_locs <- event_locs[event_locs[, .N, by=names(event_locs)][N>1L], on=names(event_locs), .(N, locs=.(.I)), by=.EACHI]
nloc <- nrow(event_locs)
locinds_from_to_tot <- apply(event_locs[,..spatialdimnames], 2, range)
locinds_tot_label <- paste(paste0(spatialdimnames, "_",
                           sprintf(paste0("%0", nchar(spatialdims), "i"), locinds_from_to_tot[1,]), "-",
                           sprintf(paste0("%0", nchar(spatialdims), "i"), locinds_from_to_tot[2,])), collapse="_")
message("--> ", nloc, " unique locations: ", locinds_tot_label)
stop("asd")

# output fname
fout <- paste0(outpath, "/", setting_label, "_", locinds_tot_label, "_composite_", varname, "_",
               c("data", "seas"), ifelse(data_fext == "", "", "."), data_fext)
fout_seas <- fout[2]
fout <- fout[1]
dir.create(dirname(outpath), recursive=T, showWarnings=F)
if (file.access(outpath, 2) == -1) stop("no write permission to `outpath` = \"", outpath, "\"")

# loop through unique locations and event periods
message("\naverage data over event dates at ", nloc, " locations ...")
elapsed_all <- rep(NA, t=nloc)
arr <- arr_seas <- array(NA, dim=spatialdims) # save event means
for (loci in seq_len(nloc)) {

    # current location
    locinds <- event_locs[loci,..spatialdimnames] # with respect to complete dims, e.g. 1401th lon and 667th lat positions with vals 350.1° and 76.6°
    locvals <- rep(NA, t=nspatialdims)
    names(locvals) <- spatialdimnames
    for (si in seq_len(nspatialdims)) {
        locvals[si] <- spatial_dims[[si]]$vals[as.integer(locinds[si])]
    }
    locinds_label <- paste(paste0(spatialdimnames, "_",
                                  sprintf(paste0("%0", nchar(spatialdims), "i"), as.integer(locinds))), collapse="_")
    locinds_dt <- event_locs$locs[[loci]]

    # event start and end dates
    event_froms <- event_inds[locinds_dt]$from
    event_tos <- event_inds[locinds_dt]$to
    # set hour, min and sec of event end dates to zero
    event_tos <- as.POSIXlt(event_tos)
    event_tos$hour <- event_tos$min <- event_tos$sec <- 0
    event_tos <- as.POSIXct(event_tos)
    nevents <- length(event_froms)

    # all event dates within dates of data files
    event_froms_inds <- which(event_froms >= data_from & event_froms <= data_to)
    event_tos_inds <- which(event_tos >= data_from & event_tos <= data_to)
    if (length(event_froms_inds) == 0 && length(event_tos_inds) == 0) {
        # all events of current location are not within data dates; skip to next location
        message("loc ", loci, "/", nloc, ",inds:(",
                paste(paste0(spatialdimnames, "=", locinds, "/", nspatial_vals), collapse=","),
                "),vals:(", paste(paste0(spatialdimnames, "=", locvals), collapse=","), ")",
                ": found zero/", nevents, " events (all events ", min(event_froms), " to ",
                max(event_tos), ")")
    } else {
        if (length(event_froms_inds) != length(event_tos_inds)) { # last event ends later than last time of last data file
            stop("not implemented")
            tmp <- tmp2 <- rep(NA, t=max(length(event_froms_inds), length(event_tos_inds)))
            tmp[1:length(event_froms_inds)] <- event_froms_inds
            tmp2[1:length(event_tos_inds)] <- event_tos_inds
            data.frame(event_froms[tmp], event_tos[tmp2])
        }
        seltimesteps <- vector("list", l=length(event_froms_inds))
        for (eventi in seq_along(seltimesteps)) {
            event_from_ind <- which.min(abs(data_dates - event_froms[event_froms_inds[eventi]]))
            event_to_ind <- which.min(abs(data_dates - event_tos[event_tos_inds[eventi]]))
            seltimesteps[[eventi]] <- seq(event_from_ind, event_to_ind, b=1)
        }
        seltimesteps <- unlist(seltimesteps)

        # all event dates in seasonal climatology file
        seas_froms_inds <- seas_tos_inds <- rep(NA, t=length(event_froms_inds))
        for (eventi in seq_along(seas_froms_inds)) { # get same month and day of data seas file
            seas_froms_inds[eventi] <- which(format(data_seas_dates, "-%m-%d") == format(event_froms[eventi], "-%m-%d"))
            seas_tos_inds[eventi] <- which(format(data_seas_dates, "-%m-%d") == format(event_tos[eventi], "-%m-%d"))
        }
        seas_froms <- data_seas_dates[seas_froms_inds]
        seas_tos <- data_seas_dates[seas_tos_inds]
        seltimesteps_seas <- vector("list", l=length(seas_froms))
        for (eventi in seq_along(seltimesteps_seas)) {
            seltimesteps_seas[[eventi]] <- seq(seas_froms_inds[eventi], seas_tos_inds[eventi], b=1)
        }
        seltimesteps_seas <- unlist(seltimesteps_seas)
        seltimesteps_seas <- sort(unique(seltimesteps_seas))

        # load data time series at current location
        start <- rep(1, t=length(vardimnames_in))
        names(start) <- vardimnames_in
        count <- start
        start[match(spatialdimnames, vardimnames_in)] <- as.integer(locinds)
        count[match(timedimname, vardimnames_in)] <- -1 # all values
        message("loc ", loci, "/", nloc, ",inds:(",
                paste(paste0(spatialdimnames, "=", locinds, "/", nspatial_vals), collapse=","),
                "),vals:(", paste(paste0(spatialdimnames, "=", locvals), collapse=","), ")",
                ":", length(seltimesteps), " timesteps of ",
                length(event_froms_inds), "/", nevents, " events from ", event_froms[min(event_froms_inds)],
                " to ", event_tos[max(event_tos_inds)], " (all events ", min(event_froms), " to ",
                max(event_tos), ") of ", ndata_files, " files: ", appendLF=F) # keep line for elapsed
        #print(start)
        #stop("asd")
        #if (loci == 100) stop("asd")
        data <- vector("list", l=ndata_files)
        elapsed <- system.time({
            for (fi in seq_along(ncs)) {
                data[[fi]] <- ncdf4::ncvar_get(ncs[[fi]], varname, start=start, count=count)
            } # for fi
            data <- unlist(data)
            arr[as.integer(locinds)] <- mean(data[seltimesteps])
            data_seas <- ncdf4::ncvar_get(data_seas_nc, varname, start=start, count=count)
            arr_seas[as.integer(locinds)] <- mean(data_seas[seltimesteps_seas])
        })
        elapsed_all[loci] <- elapsed[3] # sec
        message(round(elapsed[3], 2), "s->",
                nloc, " locs need ", round(mean(elapsed_all, na.rm=T)*nloc/60, 2),
                "m=", round(mean(elapsed_all, na.rm=T)*nloc/60/60, 2), "h")

    } # if there are some events within data period at current location
} # for loci

# output

ncdim_time <- ncdf4::ncdim_def(name="time",
                               units="seconds since 1970-1-1",
                               vals=as.numeric(mean(data_dates))) # placeholder: mean over data dates
ncdims_spatial <- vector("list", l=length(spatialdims))
for (si in seq_along(ncdims_spatial)) {
    ncdims_spatial[[si]] <- ncdf4::ncdim_def(name=spatialdimnames[si],
                                             units=data_seas_nc$dim[[spatialdimnames[si]]]$units,
                                             vals=data_seas_nc$dim[[spatialdimnames[si]]]$vals)
}
ncvar <- ncdf4::ncvar_def(name=varname,
                          units=data_seas_nc$var[[varname]]$units,
                          # regridding 1) needs a time dim and 2) time dim needs to be first (=last in r):
                          dim=c(ncdims_spatial, list(ncdim_time)),
                          missval=NA, longname=data_seas_nc$var[[varname]]$longname)

message("\nsave ", fout, " ...")
outnc <- ncdf4::nc_create(fout, vars=ncvar, force_v4=T)
ncdf4::ncvar_put(outnc, ncvar, arr)
ncdf4::nc_close(outnc)

message("save ", fout_seas, " ...")
outnc <- ncdf4::nc_create(fout_seas, vars=ncvar, force_v4=T)
ncdf4::ncvar_put(outnc, ncvar, arr_seas)
ncdf4::nc_close(outnc)

message("\nfinished\n")

