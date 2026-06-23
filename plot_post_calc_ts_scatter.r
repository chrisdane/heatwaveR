# r

# plot `calc_ts` results of `post_calc_heatwaveR.r`

# dependencies: myfunctions.r

rm(list=ls()); graphics.off()
if (!interactive()) {
    source("~/scripts/r/functions/myfunctions.r")
    library(ncdf4)
}
workpath <- "/work/ba1103/a270073"
plotpath <- paste0(workpath, "/plots/heatwaveR")
#plot_type <- "x11"
#plot_type <- "pdf"
plot_type <- "png"

area <- "global"
#area <- "NH60"

if (T) { # mean event duration versus nevents per year
    if (T) { # sst/tos
        if (T) { # fixed baseline w/out trend, 15/30a run mean
            varname_out <- "duration_vs_nevents"
            varname_out_plot <- "eventmean_an_duration_vs_nevents_yearsum"
            x <- list(varname_nc="duration",
                      varname_label="MHW duration [days]",
                      data=list("fixed_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_fixed_baseline_withTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_fldmean_", area, ".nc"),
                                                  label="30-yr fixed baseline with trend"),
                                "fixed_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_fixed_baseline_woutTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_fldmean_", area, ".nc"),
                                                  label="30-yr fixed baseline without trend"),
                                "runmean_15a"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_15a_withTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_fldmean_", area, ".nc"),
                                                   label="15-yr running mean"),
                                "runmean_31a"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_fldmean_", area, ".nc"),
                                                   label="31-yr running mean")))
            y <- list(varname_nc="nevents",
                      varname_label="MHWs per year [#]",
                      data=list("fixed_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_fixed_baseline_withTrend_locinds_000001-126859_nloc_126859_nevents_yearsum_fldmean_", area, ".nc"),
                                                  label="30-yr fixed baseline with trend"),
                                "fixed_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_fixed_baseline_woutTrend_locinds_000001-126859_nloc_126859_nevents_yearsum_fldmean_", area, ".nc"),
                                                  label="30-yr fixed baseline without trend"),
                                "runmean_15a"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_15a_withTrend_locinds_000001-126859_nloc_126859_nevents_yearsum_fldmean_", area, ".nc"),
                                                   label="15-yr running mean"),
                                "runmean_31a"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_nevents_yearsum_fldmean_", area, ".nc"),
                                                   label="31-yr running mean")))
            cols <- mycols(4)
            plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_sst_", varname_out_plot, "_fldmean_", area, "_1982-2100_", paste(names(x$data), collapse="_vs_"), "_pctile_90_minDuration_5")
        } # which setting
    } # which variable
} # which x, y

###########################################################

# check
if (length(x) != length(y)) stop("x and y must be of same length")
if (!all.equal(names(x$data), names(y$data))) stop("names of x$data and y$data must be equal")
dir.create(dirname(plotname), recursive=T, showWarnings=F)
if (!dir.exists(dirname(plotname))) stop("could not create plot path ", dirname(plotname))

# read data
for (di in seq_along(x$data)) {
    message("*****************************************************\n",
            "data ", di, "/", length(x$data), ": ", names(x$data)[di], "\n",
            "open ", x$data[[di]]$fin, " ...")
    nc <- nc_open(x$data[[di]]$fin)
    x$data[[di]]$time <- cdo_showtimestamp(x$data[[di]]$fin)
    x$data[[di]]$data <- ncvar_get(nc, x$varname_nc)
    nc <- nc_open(y$data[[di]]$fin)
    y$data[[di]]$time <- cdo_showtimestamp(y$data[[di]]$fin)
    y$data[[di]]$data <- ncvar_get(nc, y$varname_nc)
    if (!all.equal(x$data[[di]]$time, y$data[[di]]$time)) stop("times of x$data and y$data must be equal")
    
    # temporal subset
    if (!is.null(x$data[[di]]$from)) {
        inds <- which(x$data[[di]]$time < x$data[[di]]$from)
        if (length(inds) > 0) {
            message("`x$data[[", di, "]]$from` = ", x$data[[di]]$from, " --> remove ", length(inds), 
                    " times from ", x$data[[di]]$time[inds[1]], " to ", x$data[[di]]$time[inds[length(inds)]], " ...")
            if (length(inds) == length(x$data[[di]]$time)) stop("this would remove all time points")
            x$data[[di]]$time <- x$data[[di]]$time[-inds]
            x$data[[di]]$data <- x$data[[di]]$data[-inds]
            y$data[[di]]$time <- y$data[[di]]$time[-inds]
            y$data[[di]]$data <- y$data[[di]]$data[-inds]
        }
    }
    if (!is.null(x$data[[di]]$to)) {
        inds <- which(x$data[[di]]$time > x$data[[di]]$to)
        if (length(inds) > 0) {
            message("`x$data[[", di, "]]$to` = ", x$data[[di]]$to, " --> remove ", length(inds), 
                    " times from ", x$data[[di]]$time[inds[1]], " to ", x$data[[di]]$time[inds[length(inds)]], " ...")
            if (length(inds) == length(x$data[[di]]$time)) stop("this would remove all time points")
            x$data[[di]]$time <- x$data[[di]]$time[-inds]
            x$data[[di]]$data <- x$data[[di]]$data[-inds]
            y$data[[di]]$time <- y$data[[di]]$time[-inds]
            y$data[[di]]$data <- y$data[[di]]$data[-inds]
        }
    }
} # for di

# plot ts
xlim <- range(lapply(x$data, "[", "data"))
xat <- xlab <- pretty(xlim, n=10)

ylim <- range(lapply(y$data, "[", "data"))
yat <- ylab <- pretty(ylim, n=10)

log <- "" # default: no logarithmic axis
if (T && x$varname_label == "MHW duration [days]") {
    message("\nspecial logarithmic x-axis for duration ...")
    log <- "x" # logarithmic x-axis
    xat <- c(0, 5, 10, 15, 20, 25, 30, 60, 90, c(0.5, 1:3, 5, 10, 15, 20)*365)
    xlab <- ifelse(xat < 365/2, paste0(xat, "d"), paste0(xat/365, "y")) 
    x$varname_label <- sub(" \\[days\\]", "", x$varname_label)
}

if (!exists("cols")) cols <- mycols(length(x$data))
if (!exists("ltys")) ltys <- rep(1, t=length(x$data))
pp <- plot_sizes()
if (plot_type == "x11") {
    # nothing to do
} else if (plot_type == "png") {
    plotname <- paste0(plotname, ".png")
    png(plotname, width=pp$png_width_px, height=pp$png_width_px, res=pp$png_ppi, family="Droid Sans")
} else if (plot_type == "pdf") {
    plotname <- paste0(plotname, ".pdf")
    pdf(plotname, width=pp$pdf_width_in, height=pp$pdf_width_in, family="Droid Sans")
} else {
    stop("plot_type ", plot_type, " not implemented")
}
message("save ", plotname, " ...")

plot(x$data[[1]]$time, y$data[[1]]$data, t="n",
     xlim=xlim, ylim=ylim, log=log, 
     xaxt="n", yaxt="n",
     xlab="", ylab=y$varname_label)
axis(1, at=xat, labels=xlab)
mtext(x$varname_label, side=1, line=2)
axis(2, at=yat, labels=ylab, las=2)
for (di in seq_along(x$data)) {
    points(x$data[[di]]$data, y$data[[di]]$data, col=cols[di], lty=ltys[di])
}
legend("topleft", sapply(x$data, "[[", "label"), col=cols, lty=ltys,
       bty="n", x.intersp=0.2)
dev.off()
if (plot_type == "pdf") grDevices::embedFonts(plotname, outfile=plotname)

