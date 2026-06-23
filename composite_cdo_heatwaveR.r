# r

# get variable stats (e.g. mean) of event dates (e.g. peak_date) per event location
# --> loop over millions of events splitted by annual or monthly files is too much IO
# --> provide potentially huge concatenated input file `data_select_file`

rm(list=ls())
if (!interactive()) library(ncdf4)
library(data.table)

if (T) {
    dataname <- "awi-esm-1-1-lr_kh800_piControl"
    timedimname <- "time"
    spatialdimnames <- "nodes_2d"
    spatialdims <- 126859
    varname <- "tos"
    if (F) {
        select_inds_files <- list.files(paste0("/work/ba1103/a270073/post/heatwaveR/select/", varname, "/", dataname), 
                                        pattern=glob2rx("*ts_26860101-30001231_clim_26860101-30001231_pctile_90_minDuration_5_withTrend_locinds_*_select_an_res_day.txt"), 
                                        full.names=T)
    } else if (F) { # reading rdata faster than txt
        select_inds_files <- list.files(paste0("/work/ba1103/a270073/post/heatwaveR/select/", varname, "/", dataname), 
                                        pattern=glob2rx("*ts_26860101-30001231_clim_26860101-30001231_pctile_90_minDuration_5_withTrend_locinds_*_select_an_res_day.RData"), 
                                        full.names=T)
    } else if (F) { # nloc 350
        select_inds_files <- list.files(paste0("/work/ba1103/a270073/post/heatwaveR/select/", varname, "/", dataname, "/nloc_350"), 
                                        pattern=glob2rx("*ts_26860101-30001231_clim_26860101-30001231_pctile_90_minDuration_5_withTrend_locinds_*_select_an_res_day.RData"), 
                                        full.names=T)
    } else if (T) { # nloc 125
        select_inds_files <- list.files(paste0("/work/ba1103/a270073/post/heatwaveR/select/", varname, "/", dataname, "/nloc_125"), 
                                        pattern=glob2rx("*ts_26860101-30001231_clim_26860101-30001231_pctile_90_minDuration_5_withTrend_locinds_*_select_an_res_day.RData"), 
                                        full.names=T)
    }
    if (T) { # test
        select_inds_files <- select_inds_files[1]
    }    
    data_select_file <- "/work/ba1103/a270073/post/fesom/select/tos/awi-esm-1-1-lr_kh800_piControl_fesom_select_tos_global_Jan-Dec_2686-3000.nc"
    data_seas_file <- "/work/ba1103/a270073/post/fesom/ydaymean/tos/awi-esm-1-1-lr_kh800_piControl_fesom_ydaymean_tos_global_Jan-Dec_2686-3000.nc"
    outpath <- paste0("/work/ba1103/a270073/post/heatwaveR/timmean/", varname)
}

##########################################################################################

# check selection index files
nselect_inds_files <- length(select_inds_files)
if (nselect_inds_files == 0) stop("found zero select files")
setting_label <- substr(basename(select_inds_files), 1, regexpr("_locinds_", basename(select_inds_files))-1)
select_fext <- tools::file_ext(select_inds_files[1])
if (!any(select_fext == c("txt", "RData"))) stop("selection inds files extension must be one of \"txt\", \"RData\"")
data_fext <- tools::file_ext(data_select_file)

# check if selection index files and data seas file refer to same time period
ntime_data <- system(paste0("cdo -s ntime ", data_select_file), intern=T)
ntime_seas <- system(paste0("cdo -s ntime ", data_seas_file), intern=T)
message("\ncheck if filename dates of ", nselect_inds_files, " selection index files, ", 
        ntime_data, " dates of data select file and ", ntime_seas, 
        " dates of seasonal climatology file fit together ...")
select_inds_from_to <- substr(select_inds_files[1], 
                              start=regexpr("_clim_", select_inds_files[1])+6,
                              stop=regexpr("_clim_", select_inds_files[1])+22)
select_inds_from_to <- strsplit(select_inds_from_to, "-")[[1]]
select_inds_from_to <- as.POSIXct(select_inds_from_to, tz="UTC", format="%Y%m%d")
data_select_dates <- system(paste0("cdo -s showdate ", data_select_file), intern=T)
data_select_dates <- strsplit(trimws(data_select_dates), "\\s+")[[1]] # arbitrary number of spaces blanks
data_select_dates <- as.POSIXct(data_select_dates, tz="UTC")
message("--> selection index file dates from ", select_inds_from_to[1], " to ", select_inds_from_to[2], "\n",
        "--> data file dates from ", min(data_select_dates), " to ", max(data_select_dates), "\n",
        "--> basename of seas file ", basename(data_seas_file))
if (select_inds_from_to[1] < min(data_select_dates)) {
    stop("start of selection inds files ", select_inds_from_to[1], 
         " < start of data select file ", min(data_select_dates))
}
if (select_inds_from_to[2] > max(data_select_dates)) {
    stop("end of selection inds files ", select_inds_from_to[2], 
         " > end of data select file ", max(data_select_dates))
}
data_seas_dates <- system(paste0("cdo -s showdate ", data_seas_file), intern=T)
data_seas_dates <- strsplit(trimws(data_seas_dates), "\\s+")[[1]] # arbitrary number of spaces blanks
data_seas_dates <- as.POSIXct(data_seas_dates, tz="UTC")

# check outpath 
dir.create(outpath, recursive=T, showWarnings=F)
if (file.access(outpath, 2) == -1) stop("no write permission to `outpath` = \"", outpath, "\"")
outpath <- normalizePath(outpath)

# check spatialdimnames
if (select_fext == "txt") {
    header <- readLines(select_inds_files[1], n=1)
    header <- strsplit(header, ",")[[1]]
} else if (select_fext == "RData") {
    objname <- load(select_inds_files[1])
    header <- eval(parse(text=paste0("names(", objname, ")")))
} else {
    stop("file extension ", select_fext, " of selection files ", select_inds_files[1], " not defined")
}
for (si in seq_along(spatialdimnames)) {
    if (any(is.na(match(spatialdimnames[si], header)))) {
        stop("provided spatialdimname \"", spatialdimnames[si], "\" not found in header ",
             paste(header, collapse=", "))
    }
}

# check nc infos
data_nc <- ncdf4::nc_open(data_seas_file)
if (!any(names(data_nc$var) == varname)) {
    stop("could not find provided variable \"", varname, "\" in this file. choose one of ", 
         paste(names(data_nc$var), collapse=", "), " or chosse other data files")
}

# load selection indices
message("\nread ", nselect_inds_files, " ", select_fext, " files with selection indices (header = ", 
        length(header), " columns \"", paste(header, collapse="\", \""), "\") ...")
elapsed <- system.time({
    for (fi in seq_len(nselect_inds_files)) {
        cat("\rread selection index file ", sprintf(paste0("%0", nchar(nselect_inds_files), "i"), fi), "/", nselect_inds_files, sep="")
        if (select_fext == "txt") {
            if (fi == 1) { # initialize dt
                select_inds <- data.table::fread(select_inds_files[fi], skip=1, showProgress=F)
            } else {
                select_inds <- data.table::rbindlist(list(select_inds,
                                                     data.table::fread(select_inds_files[fi], skip=1, showProgress=F)))
            }
        } else if (select_fext == "RData") {
            if (fi == 1) {
                # data of first file was already loaded before
                eval(parse(text=paste0("select_inds <- ", objname)))
            } else {
                load(select_inds_files[fi])
                eval(parse(text=paste0("tmp <- ", objname)))
                select_inds <- data.table::rbindlist(list(select_inds, tmp))
            }
        }
    } # for fi
})[3]
message(" --> took ", round(elapsed), " sec = ", round(elapsed/60, 2), " min to load ", nrow(select_inds), " rows")
colnames(select_inds) <- header

if (F) { # save smaller select index chunks
    stop("asd")
    # save ~350 instead of 1587 locs per file --> 4.5 times more files
    #tmp <- "/work/ba1103/a270073/post/heatwaveR/select/tos/awi-esm-1-1-lr_kh800_piControl/nloc_350"
    # save ~125 instead of 1587 locs per file --> 13 times more files
    tmp <- "/work/ba1103/a270073/post/heatwaveR/select/tos/awi-esm-1-1-lr_kh800_piControl/nloc_125"
    nfiles_new <- nselect_inds_files*13
    rowinds_tot <- as.integer(seq(1, nrow(select_inds), l=round(nfiles_new)))
    for (fi in seq_len(length(rowinds_tot)-1)) {
        if (fi == length(rowinds_tot)-1) { # last
            rowinds <- seq(rowinds_tot[fi], rowinds_tot[fi+1], b=1)
        } else {
            rowinds <- seq(rowinds_tot[fi], rowinds_tot[fi+1]-1, b=1)
        }
        dt <- select_inds[rowinds]
        locs <- range(dt[,..spatialdimnames])
        fout <- basename(select_inds_files[1]) # placeholder
        locinds_pattern <- substr(fout, regexpr("_locinds_", fout), regexpr("_select_", fout))
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

# combine all events at same locations to reduce location loop
#event_locs <- as.data.table(data.frame(a=c(1,2,3,4,5,1,2,1), b=c(2,3,4,5,6,1,3,2)))
#event_locs <- select_inds[select_year_inds,..spatialdimnames]
event_locs <- select_inds[,..spatialdimnames]
event_locs <- event_locs[event_locs[, .N, by=names(event_locs)][N>1L], on=names(event_locs), .(N, locs=.(.I)), by=.EACHI]
locinds_from_to_tot <- apply(event_locs[,..spatialdimnames], 2, range)
locinds_tot_label <- paste(paste0(spatialdimnames, "_", 
                           sprintf(paste0("%0", nchar(spatialdims), "i"), locinds_from_to_tot[1,]), "-", 
                           sprintf(paste0("%0", nchar(spatialdims), "i"), locinds_from_to_tot[2,])), collapse="_")

# loop through unique locations and select event periods
nloc <- dim(event_locs)[1] 
fouts <- data.frame(file=character(nloc))
for (si in seq_along(spatialdimnames)) {
    fouts <- cbind(fouts, data.frame(integer(nloc)))
}
colnames(fouts) <- c("file", spatialdimnames)
fouts <- fouts_seas <- data.table::as.data.table(fouts)
message("\nselect data from ", nloc, " locations ...")
for (loci in seq_len(nloc)) {

    # current location
    locinds <- event_locs[loci,..spatialdimnames] # with respect to complete dims, e.g. 1401th lon and 667th lat positions with vals 350.1° and 76.6°
    locinds_label <- paste(paste0(spatialdimnames, "_", 
                                  sprintf(paste0("%0", nchar(spatialdims), "i"), as.integer(locinds))), collapse="_")
    locinds_dt <- event_locs$locs[[loci]]
    
    # event start and end dates
    select_froms <- select_inds[locinds_dt]$from
    select_tos <- select_inds[locinds_dt]$to
    nevents <- length(select_froms)

    # event start and end dates in data select file
    select_froms_inds <- sapply(select_froms, function(x) which.min(abs(data_select_dates - x)))
    select_tos_inds <- sapply(select_tos, function(x) which.min(abs(data_select_dates - x)))
    seltimesteps <- vector("list", l=nevents)
    for (di in seq_along(seltimesteps)) {
        seltimesteps[[di]] <- seq(select_froms_inds[di], select_tos_inds[di], b=1)
    } # for di
    seltimesteps <- unlist(seltimesteps)
    seltimesteps_char <- paste(seltimesteps, collapse=",")
    
    # event start and dates in data seas file
    seas_froms_inds <- seas_tos_inds <- rep(NA, t=nevents)
    for (eventi in seq_along(seas_froms_inds)) { # get same month and day of data seas file
        seas_froms_inds[eventi] <- which(format(data_seas_dates, "-%m-%d") == format(select_froms[eventi], "-%m-%d"))
        seas_tos_inds[eventi] <- which(format(data_seas_dates, "-%m-%d") == format(select_tos[eventi], "-%m-%d"))
    }
    seas_froms <- data_seas_dates[seas_froms_inds] 
    seas_tos <- data_seas_dates[seas_tos_inds] 
    seltimesteps_seas <- vector("list", l=nevents)
    for (di in seq_along(seltimesteps_seas)) {
        seltimesteps_seas[[di]] <- seq(seas_froms_inds[di], seas_tos_inds[di], b=1)
    } # for di
    seltimesteps_seas <- unlist(seltimesteps_seas)
    seltimesteps_seas <- sort(unique(seltimesteps_seas))
    seltimesteps_seas_char <- paste(seltimesteps_seas, collapse=",")

    # fout
    fout <- paste0(outpath, "/", dataname, "/", locinds_tot_label, "/", 
                   setting_label, "_", locinds_label, "_composite")
    fout_seas <- fout
    fout <- paste0(fout, "_data", ifelse(data_fext == "", "", "."), data_fext)
    fout_seas <- paste0(fout_seas, "_seas", ifelse(data_fext == "", "", "."), data_fext)
    dir.create(dirname(fout), recursive=T, showWarnings=F)
    fouts[loci] <- list(fout, t(locinds))
    fouts_seas[loci] <- list(fout_seas, t(locinds))
    
    # construct data selection cmd
    message("loc ", loci, "/", nloc, ": average data over ", length(seltimesteps), " timesteps from ", nevents, " events (and ", 
            length(seltimesteps_seas), " timesteps from seasonal climatology)")
    if (F) { # if nco
        # e.g. `ncks -d time,\"3000-06-22\",\"3000-06-28 23:59:59\" -d nodes_2d,14 fin fout`
        # or directly `ncwa` to calculate the average over time of the selected time points
        # ncwa -b: keep dimensions of length 1, e.g.:
        #    time = UNLIMITED ; // (1 currently)
        #    nodes_2d = 1
        # todo: too slow
        cmd <- paste0(paste(paste0("-d ", timedimname, ",\"", select_froms, "\",\"", select_tos, "\""), collapse=" "), " ", 
                      paste(paste0("-d ", spatialdimnames, ",", locinds), collapse=" "))
        cmd_seas <- paste0(paste(paste0("-d ", timedimname, ",\"", seas_froms, "\",\"", seas_tos, "\""), collapse=" "), " ", 
                           paste(paste0("-d ", spatialdimnames, ",", locinds), collapse=" "))
        if (T) message(cmd)
        cmd <- paste0("ncwa -O -b ", cmd, " ", data_select_file, " ", fout)
        cmd_seas <- paste0("ncwa -O -b ", cmd_seas, " ", data_seas_file, " ", fout_seas)
    } else if (T) { # if cdo
        cmd <- paste0("cdo -timmean -seltimestep,", seltimesteps_char, " ", data_select_file, " ", fout)
        cmd_seas <- paste0("cdo -timmean -seltimestep,", seltimesteps_seas_char, " ", data_seas_file, " ", fout_seas)
    }
    
    # run data selection cmd
    elapsed <- system.time({
        system(cmd)
        system(cmd_seas)
        if (T) { # if cdo; select current location
            cmd <- paste0("ncks -O ", paste(paste0("-d ", spatialdimnames, ",", locinds), collapse=" "), " ", fout, " ", fout)
            system(cmd)
            cmd_seas <- paste0("ncks -O ", paste(paste0("-d ", spatialdimnames, ",", locinds), collapse=" "), " ", fout_seas, " ", fout_seas)
            system(cmd_seas)
        }
    })[3]
    message("--> took ", elapsed, " sec = ", round(elapsed/60, 2), " min --> ", 
            nloc, " locs will need ", round(nloc*elapsed/60, 2), " min = ", round(nloc*elapsed/60/60, 2), " h")
    #if (loci == 10) stop("asd")

} # for loci
    
# cat files of all locations together
message("\ncat selection files from ", nloc, " locations ...") 
if (!any(is.na(match("nodes_2d", spatialdimnames)))) {
    arr <- arr_seas <- array(NA, dim=spatialdims)
    #for (loci in seq_len(nloc)) {
    for (loci in 1:loci) { # todo: what?!
        cat("\rloc ", sprintf(paste0("%0", nchar(nloc), "i"), loci), "/", nloc, sep="")
        nc <- ncdf4::nc_open(fouts$file[loci])
        spatial_inds <- as.integer(fouts[loci,..spatialdimnames])
        cmd <- paste0("arr[", paste(spatial_inds, collapse=","), "] <- ncdf4::ncvar_get(nc, \"", varname, "\")")
        if (F) message(cmd)
        eval(parse(text=cmd))
        ncdf4::nc_close(nc)
        nc_seas <- ncdf4::nc_open(fouts_seas$file[loci])
        cmd <- paste0("arr_seas[", paste(spatial_inds, collapse=","), "] <- ncdf4::ncvar_get(nc_seas, \"", varname, "\")")
        if (F) message(cmd)
        eval(parse(text=cmd))
        ncdf4::nc_close(nc_seas)
    } # for loci
    message()

} else if (!any(is.na(match(c("lon", "lat"), spatialdimnames)))) {
    stop("not yet defined for lon lat spatialdimnames")

} else {
    stop("spatialdimnames = ", paste(spatialdimnames, collapse=", "), " not defined")

} # which spatialdims
    
# output
fout <- paste0(outpath, "/", dataname, "/", locinds_tot_label, "/", 
               setting_label, "_", locinds_tot_label, "_composite")
fout_seas <- fout
fout <- paste0(fout, "_data", ifelse(data_fext == "", "", "."), data_fext)
fout_seas <- paste0(fout_seas, "_seas", ifelse(data_fext == "", "", "."), data_fext)

ncdim_time <- ncdf4::ncdim_def(name="time",
                               units="seconds since 1970-1-1",
                               vals=as.numeric(mean(data_select_dates))) # placeholder: mean over data dates
ncdims_spatial <- vector("list", l=length(spatialdims))
for (si in seq_along(ncdims_spatial)) {
    ncdims_spatial[[si]] <- ncdf4::ncdim_def(name=spatialdimnames[si], 
                                             units=data_nc$dim[[spatialdimnames[si]]]$units,
                                             vals=data_nc$dim[[spatialdimnames[si]]]$vals)
}
ncvar <- ncdf4::ncvar_def(name=varname,
                          units=data_nc$var[[varname]]$units, 
                          # regridding 1) needs a time dim and 2) time dim needs to be first (=last in r): 
                          dim=c(ncdims_spatial, list(ncdim_time)), 
                          missval=NA, longname=data_nc$var[[varname]]$longname)

message("\nsave ", fout, " ...")
outnc <- ncdf4::nc_create(fout, vars=ncvar, force_v4=T)
ncdf4::ncvar_put(outnc, ncvar, arr)
ncdf4::nc_close(outnc)

message("save ", fout_seas, " ...")
outnc <- ncdf4::nc_create(fout_seas, vars=ncvar, force_v4=T)
ncdf4::ncvar_put(outnc, ncvar, arr_seas)
ncdf4::nc_close(outnc)

# rm tmp files
message("\nremove temporary data and seasonal climatology files from ", nloc, " locations ...")
invisible(file.remove(fouts$file))
invisible(file.remove(fouts_seas$file))

message("\nfinished\n")

