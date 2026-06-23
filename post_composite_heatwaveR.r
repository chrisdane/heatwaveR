 # r

# summarize results created with `composite_heatwaveR.r`

rm(list=ls()); graphics.off()
if (!interactive()) {
    library(ncdf4)
}

remap_cmd <- NULL

if (T) { # awi-esm-1-1-lr_kh800_piControl
    #varname <- "tos"
    #varname <- "tauuo"
    #varname <- "tauvo"
    #varname <- "mlotst"
    #varname <- "omldamax"
    varname <- "sic"
    files <- list.files(paste0("/work/ba1103/a270073/post/heatwaveR/composite/", varname, "/awi-esm-1-1-lr_kh800_piControl"), 
                        glob2rx(paste0("awi-esm-1-1-lr_kh800_piControl_mhw_tos_ts_26860101-30001231_clim_26860101-30001231_pctile_90_minDuration_5_withTrend_*_composite_", varname, "_*.nc")),
                        full.names=T)
    if (F) { # test
        files <- files[1:2]
    }
    remap_cmd <- paste0("cdo -P ", system("nproc", intern=T), " -remapycon,global_0.25 -setgrid,/pool/data/AWICM/FESOM1/MESHES/core/griddes.nc <fin> <fout>")
}

#################################################

# check files
data_files <- files[which(grepl(paste0("_composite_", varname, "_data"), files))]
seas_files <- files[which(grepl(paste0("_composite_", varname, "_seas"), files))]
nfiles <- length(data_files)
if (nfiles == 0) stop("provided zero files")
if (length(data_files) != length(seas_files)) {
    stop("found ", length(data_files), " data files != ", length(seas_files), " seas files")
}

# timmean nc output fname
pathout <- dirname(dirname(data_files[1]))
fout_data <- paste0(pathout, "/",
                    substr(basename(data_files[1]), 1, regexpr("Trend_", basename(data_files[1]))+4),
                    "_composite_", varname, "_", c("data", "seas", "anom", "anom_pcnt"),
                    ifelse(tools::file_ext(data_files[1]) == "", "", "."), 
                    tools::file_ext(data_files[1]))
fout_seas <- fout_data[2]
fout_anom <- fout_data[3]
fout_anom_pcnt <- fout_data[4]
fout_data <- fout_data[1]

# put individual composite results into global array
nc_data <- ncdf4::nc_open(data_files[1])
arr_data <- arr_seas <- array(NA, dim=nc_data$var[[varname]]$size)
for (fi in seq_along(data_files)) {
    cat("\rread file ", sprintf(paste0("%0", nchar(nfiles), "i"), fi), "/", nfiles, sep="")
    if (fi > 1) nc_data <- ncdf4::nc_open(data_files[fi])
    nc_seas <- ncdf4::nc_open(seas_files[fi])
    data <- ncdf4::ncvar_get(nc_data, varname, collapse_degen=F)
    seas <- ncdf4::ncvar_get(nc_seas, varname, collapse_degen=F)
    inds_data <- !is.na(data)
    inds_seas <- !is.na(seas)
    if (!identical(inds_data, inds_seas)) {
        stop("inds of data and seas are not identical. this should not happen")
    }
    if (any(!is.na(arr_data[inds_data]))) {
        stop("data array already has values at inds from ", min(inds_data), " to ", max(inds_data), 
             ". that means some result files from composite_heatwaveR.r saved values at the same locations")
    } else {
        arr_data[inds_data] <- data[inds_data]
    }
    if (any(!is.na(arr_seas[inds_seas]))) {
        stop("seas array already has values at inds from ", min(inds_seas), " to ", max(inds_seas), 
             ". that means some result files from composite_heatwaveR.r saved values at the same locations")
    } else {
        arr_seas[inds_seas] <- seas[inds_seas]
    }
} # for fi
message()

# calc anomaly = mean_over_events minus seas
arr_anom <- arr_data - arr_seas

# calc anomaly in percent = data/seas*100
arr_anom_pcnt <- arr_data/arr_seas*100

# nc output
ncdims <- nc_data$dim
ncvar <- nc_data$var[[varname]]
ncvar$chunksizes <- NA

message("\nsave ", fout_data, " ...")
outnc <- ncdf4::nc_create(fout_data, vars=ncvar, force_v4=T)
ncdf4::ncvar_put(outnc, ncvar, arr_data)
ncdf4::nc_close(outnc)

message("save ", fout_seas, " ...")
outnc <- ncdf4::nc_create(fout_seas, vars=ncvar, force_v4=T)
ncdf4::ncvar_put(outnc, ncvar, arr_seas)
ncdf4::nc_close(outnc)

message("save ", fout_anom, " ...")
outnc <- ncdf4::nc_create(fout_anom, vars=ncvar, force_v4=T)
ncdf4::ncvar_put(outnc, ncvar, arr_anom)
ncdf4::nc_close(outnc)

message("save ", fout_anom_pcnt, " ...")
outnc <- ncdf4::nc_create(fout_anom_pcnt, vars=ncvar, force_v4=T)
ncdf4::ncvar_put(outnc, ncvar, arr_anom_pcnt)
ncdf4::nc_close(outnc)

# spatial remapping of postprocessing result if necessary
if (!is.null(remap_cmd)) {
    
    message("\nremap ", fout_data)
    fin <- fout_data
    fout <- paste0(tools::file_path_sans_ext(fin), "_remap.", tools::file_ext(fin))
    cmd <- sub("<fin>", fin, remap_cmd)
    cmd <- sub("<fout>", fout, cmd)
    message("run `", cmd, "` ...")
    system(cmd)
    
    message("\nremap ", fout_seas)
    fin <- fout_seas
    fout <- paste0(tools::file_path_sans_ext(fin), "_remap.", tools::file_ext(fin))
    cmd <- sub("<fin>", fin, remap_cmd)
    cmd <- sub("<fout>", fout, cmd)
    message("run `", cmd, "` ...")
    system(cmd)
    
    message("\nremap ", fout_anom)
    fin <- fout_anom
    fout <- paste0(tools::file_path_sans_ext(fin), "_remap.", tools::file_ext(fin))
    cmd <- sub("<fin>", fin, remap_cmd)
    cmd <- sub("<fout>", fout, cmd)
    message("run `", cmd, "` ...")
    system(cmd)
    
    message("\nremap ", fout_anom_pcnt)
    fin <- fout_anom_pcnt
    fout <- paste0(tools::file_path_sans_ext(fin), "_remap.", tools::file_ext(fin))
    cmd <- sub("<fin>", fin, remap_cmd)
    cmd <- sub("<fout>", fout, cmd)
    message("run `", cmd, "` ...")
    system(cmd)

} # if !is.null(spatial_mapping_cmd)

message("\nfinished\n")

