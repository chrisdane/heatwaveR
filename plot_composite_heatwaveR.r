# r

# compare results of `post_calc_heatwaveR.r` and `post_composite_heatwaveR.r`

# dependencies:
# myfunctions.r (myDefaultPlotOptions, plot_sizes), image.plot.pre.r, image.plot.nxm.r

rm(list=ls()); graphics.off()
if (!interactive()) {
    source("~/scripts/r/functions/myfunctions.r")
    library(ncdf4)
}
source("~/scripts/r/functions/image.plot.pre.r")
source("~/scripts/r/functions/image.plot.nxm.r")
options(warn=2) # stop on warnings
#options(warn=0) # back to default

workpath <- "/work/ba1103/a270073"
plotpath <- paste0(workpath, "/plots/heatwaveR/composite")
plot_types <- "pdf"
#plot_types <- "png"
pdf_multi_page <- T

if (T) { # piControl
    heatwaveR_varname <- "tos"
    composite_varname <- "tos"
    f_heatwaveR <- paste0("/work/ba1103/a270073/post/heatwaveR/timmean/awi-esm-1-1-lr_kh800_piControl_mhw_", heatwaveR_varname, "_ts_26860101-30001231_clim_26860101-30001231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_timmean.nc")
    f_composite_data <- paste0("/work/ba1103/a270073/post/heatwaveR/composite/", composite_varname, "/awi-esm-1-1-lr_kh800_piControl_mhw_", heatwaveR_varname, "_ts_26860101-30001231_clim_26860101-30001231_pctile_90_minDuration_5_withTrend_composite_", composite_varname, "_data_remap.nc")
    f_composite_seas <- paste0("/work/ba1103/a270073/post/heatwaveR/composite/", composite_varname, "/awi-esm-1-1-lr_kh800_piControl_mhw_", heatwaveR_varname, "_ts_26860101-30001231_clim_26860101-30001231_pctile_90_minDuration_5_withTrend_composite_", composite_varname, "_seas_remap.nc")
    f_composite_anom <- paste0("/work/ba1103/a270073/post/heatwaveR/composite/", composite_varname, "/awi-esm-1-1-lr_kh800_piControl_mhw_", heatwaveR_varname, "_ts_26860101-30001231_clim_26860101-30001231_pctile_90_minDuration_5_withTrend_composite_", composite_varname, "_anom_remap.nc")
}

########################################################

# check plotpath
if (!dir.exists(plotpath)) dir.create(plotpath, recursive=T, showWarnings=F)
if (file.access(plotpath, 2) == -1) stop("no write permission to `plotpath` = \"", plotpath, "\"")
plotpath <- normalizePath(plotpath)

p <- myDefaultPlotOptions()

# open result of post_calc_heatwaveR.r
message("open ", f_heatwaveR)
nc_heatwaveR <- ncdf4::nc_open(f_heatwaveR)
lon_heatwaveR <- nc_heatwaveR$dim$lon$vals
lat_heatwaveR <- nc_heatwaveR$dim$lat$vals
opts_heatwaveR <- ncdf4::ncatt_get(nc_heatwaveR, 0)
message("load intensity_mean from heatwaveR results based on variable ", heatwaveR_varname, " ...")
intensity_mean_heatwaveR <- ncdf4::ncvar_get(nc_heatwaveR, "intensity_mean")
intensity_mean_heatwaveR_opts <- ncdf4::ncatt_get(nc_heatwaveR, "intensity_mean")

# open results of post_composite_heatwaveR.r
message("\nopen ", f_composite_data)
nc_composite_data <- ncdf4::nc_open(f_composite_data)
message("open ", f_composite_seas)
nc_composite_seas <- ncdf4::nc_open(f_composite_seas)
message("open ", f_composite_anom)
nc_composite_anom <- ncdf4::nc_open(f_composite_anom)
lon_composite <- nc_composite_data$dim$lon$vals
lat_composite <- nc_composite_data$dim$lat$vals
message("load composite results of variable ", composite_varname, " based on heatwaveR selection inds from variable ", heatwaveR_varname, " ...")
composite_data <- ncdf4::ncvar_get(nc_composite_data, composite_varname)
composite_seas <- ncdf4::ncvar_get(nc_composite_seas, composite_varname)
composite_anom <- ncdf4::ncvar_get(nc_composite_anom, composite_varname)

# check
if (!identical(lon_heatwaveR, lon_composite)) stop("lons of heatwaveR and composite are not identical")
if (!identical(lat_heatwaveR, lat_composite)) stop("lats of heatwaveR and composite are not identical")

# plot heatwaveR:intensity_mean (=wrt seasonal climatology) vs composite:anom (=composite:data minus composite:seas)
lon <- list(lon_heatwaveR, lon_composite)
lat <- list(lat_heatwaveR, lat_composite)
data <- list(heatwaveR=intensity_mean_heatwaveR,
             composite=composite_anom)
xlim <- range(lon, na.rm=T)
ylim <- range(lat, na.rm=T)
if (T) {
    zlim <- range(data, na.rm=T)
    ip <- image.plot.pre(zlim=zlim)
} else if (F) {
    zlim <- vector("list", l=2)
    for (i in 1:2) {
        zlim[[i]] <- unname(quantile(data[[i]], c(0, 0.1, 0.9, 1), na.rm=T))
    }
    zlevels <- sapply(zlim, "[", 2:3)
    zlim <- range(sapply(zlim, "[", c(1, 4)))
    zlevels <- pretty(range(zlevels), 11)
    if (zlim[1] < min(zlevels)) zlevels <- c(zlim[1], zlevels)
    if (zlim[2] > max(zlevels)) zlevels <- c(zlevels, zlim[2])
    ip <- image.plot.pre(zlim=zlim, zlevels=zlevels)
}
plotname <- paste0(plotpath, "/",
                   tools::file_path_sans_ext(basename(f_heatwaveR)),
                   "_and_composite.png")
message("\nplot ", plotname, " ...")
pp <- plot_sizes(width_in=p$map_width, png_ppi=300, asp=p$map_asp)
png(plotname, width=pp$pdf_width_in, height=pp$pdf_height_in,
    units="in", res=pp$png_ppi)
image.plot.nxm(lon, lat, data, xlim=xlim, ylim=ylim, ip=ip,
               xlab="Longitude [°]", ylab="Latitude [°]", 
               zlab=intensity_mean_heatwaveR_opts$units, 
               znames_labels=c("heatwaveR:intensity_mean", paste0("composite:", composite_varname)),
               add_contour=F, useRaster=T)
dev.off()

# plot anomalies [ composite:anom (=composite:data minus composite:seas) ] minus [ heatwaveR:intensity_mean (=wrt seasonal climatology) ]
lon <- lon_composite
lat <- lat_composite
data <- composite_anom - intensity_mean_heatwaveR
xlim <- range(lon, na.rm=T)
ylim <- range(lat, na.rm=T)
if (T) {
    zlim <- range(data, na.rm=T)
    ip <- image.plot.pre(zlim=zlim, center_include=T)
} else if (F) {
    zlim <- unname(quantile(data, c(0, 0.1, 0.9, 1), na.rm=T))
    zlevels <- zlim[2:3]
    zlim <- zlim[c(1, 4)]
    zlevels <- pretty(range(zlevels), 11)
    if (zlim[1] < min(zlevels)) zlevels <- c(zlim[1], zlevels)
    if (zlim[2] > max(zlevels)) zlevels <- c(zlevels, zlim[2])
    ip <- image.plot.pre(zlim=zlim, zlevels=zlevels, center_include=T)
}
plotname <- paste0(plotpath, "/",
                   tools::file_path_sans_ext(basename(f_heatwaveR)),
                   "_vs_composite.png")
message("\nplot ", plotname, " ...")
pp <- plot_sizes(width_in=p$map_width, png_ppi=300, asp=p$map_asp)
png(plotname, width=pp$pdf_width_in, height=pp$pdf_height_in,
    units="in", res=pp$png_ppi)
image.plot.nxm(lon, lat, data, xlim=xlim, ylim=ylim, ip=ip,
               xlab="Longitude [°]", ylab="Latitude [°]", 
               zlab=intensity_mean_heatwaveR_opts$units, 
               znames_labels=paste0("composite:", composite_varname, " - heatwaveR:intensity_mean"),
               add_contour=F, useRaster=T)
dev.off()


