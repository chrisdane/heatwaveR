# r

# plot results of `post_calc_heatwaveR.r`

# dependencies:
# myfunctions.r (myDefaultPlotOptions, plot_sizes), image.plot.pre.r, image.plot.nxm.r

# todo: remove fldmean

rm(list=ls()); graphics.off()
if (!interactive()) {
    source("~/scripts/r/functions/myfunctions.r")
    library(ncdf4)
}
source("~/scripts/r/functions/image.plot.pre.r")
source("~/scripts/r/functions/image.plot.nxm.r")
options(warn=2) # stop on warnings

workpath <- "/work/ba1103/a270073"
plotpath <- paste0(workpath, "/plots/heatwaveR/timmean")
#plot_type <- "x11"
#plot_type <- "pdf"
plot_type <- "png"
pdf_multi_page <- T

area <- "global"

if (T) { # mean event duration
    varname_out <- "duration"
    varname_nc <- "duration"
    if (T) { # sst/tos
        varname_label <- "MHW duration [days]"
        if (F) { # hist
            if (F) { # obs with/wout trend
                data <- list("oisst_with"=list(fin="/work/ba1103/a270073/post/heatwaveR/eventmean_ltm/sst/oisst_v2.1_mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_0066904-1036800_nloc_691150_duration_eventmean_ltm.nc",
                                          lonname="lon",
                                          latname="lat",
                                          label="OISSTv2.1 with trend"),
                             "oisst_wout"=list(fin="/work/ba1103/a270073/post/heatwaveR/eventmean_ltm/sst/oisst_v2.1_mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_0066904-1036800_nloc_691150_duration_eventmean_ltm.nc",
                                          lonname="lon",
                                          latname="lat",
                                          label="OISSTv2.1 wout trend"))
                plotname <- paste0(plotpath, "/", varname, "/mhw_sst_", varname, "_eventmean_ltm_global_1982-2021_oisst_withTrend_vs_woutTrend_clim_1982-2021_pctile_90_minDuration_5")
            } else if (F) { # obs vs model with trend
                data <- list("oisst"=list(fin="/work/ba1103/a270073/post/heatwaveR/eventmean_ltm/sst/oisst_v2.1_mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_0066904-1036800_nloc_691150_duration_eventmean_ltm.nc",
                                          lonname="lon",
                                          latname="lat",
                                          label="OISSTv2.1"),
                             "awicm1-recom_historical3_and_ssp585_2"=list(
                                 fin="/work/ba1103/a270073/post/heatwaveR/eventmean_ltm/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_duration_eventmean_ltm_remapycon_global_0.25.nc",
                                 lonname="lon",
                                 latname="lat",
                                 label="AWI-ESM-1-REcoM"))
                plotname <- paste0(plotpath, "/", varname, "/mhw_sst_", varname, "_eventmean_ltm_global_1982-2021_", paste(names(data), collapse="_vs_"), "_clim_1982-2021_pctile_90_minDuration_5_withTrend")
            } else if (T) { # obs vs model wout trend
                data <- list("oisst"=list(fin="/work/ba1103/a270073/post/heatwaveR/eventmean_ltm/sst/oisst_v2.1_mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_0066904-1036800_nloc_691150_duration_eventmean_ltm.nc",
                                          lonname="lon",
                                          latname="lat",
                                          label="OISSTv2.1"),
                             "awicm1-recom_historical3_and_ssp585_2"=list(
                                 fin="/work/ba1103/a270073/post/heatwaveR/eventmean_ltm/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_000001-126859_nloc_126859_duration_eventmean_ltm_remapycon_global_0.25.nc",
                                 lonname="lon",
                                 latname="lat",
                                 label="AWI-ESM-1-REcoM"))
                plotname <- paste0(plotpath, "/", varname, "/mhw_sst_", varname, "_eventmean_ltm_global_1982-2021_", paste(names(data), collapse="_vs_"), "_clim_1982-2021_pctile_90_minDuration_5_woutTrend")
            }
        } else if (T) { # hist and ssp
            if (F) {
            } else if (T) { # fixed baseline w/out trend, 15/30a run mean
                data <- list("fixed_with"=list(#fin="/work/ba1103/a270073/post/heatwaveR/timmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_fixed_baseline_withTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_timmean_2091-2100_remapycon_global1.nc",
                                               fin="/work/ba1103/a270073/post/heatwaveR/timmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_fixed_baseline_withTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_timmean_2091-2100_remapycon_global0.25.nc",
                                               lonname="lon", latname="lat",
                                               label="a) 30-yr fixed baseline with trend"),
                             "fixed_wout"=list(#fin="/work/ba1103/a270073/post/heatwaveR/timmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_fixed_baseline_woutTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_timmean_2091-2100_remapycon_global1.nc",
                                               fin="/work/ba1103/a270073/post/heatwaveR/timmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_fixed_baseline_woutTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_timmean_2091-2100_remapycon_global0.25.nc",
                                               lonname="lon", latname="lat",
                                               label="b) 30-yr fixed baseline without trend"),
                             "runmean_31a"=list(#fin="/work/ba1103/a270073/post/heatwaveR/timmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_timmean_2091-2100_remapycon_global1.nc",
                                                fin="/work/ba1103/a270073/post/heatwaveR/timmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_timmean_2091-2100_remapycon_global0.25.nc",
                                                lonname="lon", latname="lat",
                                                label="c) 31-yr running mean"),
                             "runmean_15a"=list(#fin="/work/ba1103/a270073/post/heatwaveR/timmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_15a_withTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_timmean_2091-2100_remapycon_global1.nc",
                                                fin="/work/ba1103/a270073/post/heatwaveR/timmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_15a_withTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_timmean_2091-2100_remapycon_global0.25.nc",
                                                lonname="lon", latname="lat",
                                                label="d) 15-yr running mean"))
                plotname <- paste0(plotpath, "/", varname_out, "/mhw_sst_", varname_out, "_eventmean_an_timmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_pctile_90_minDuration_5")
            }
        }
    } else if (T) { # gbc22
        varname_label <- "ODX duration [days]"
        data <- list("awicm1-recom_historical2"=list(
                         fin="/work/ba1103/a270073/post/heatwaveR/timmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mcs_bgc22_ts_19820101-21001231_clim_19820101-20111231_pctile_10_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_timmean_remap_global_1.nc",
                         lonname="lon",
                         latname="lat",
                         label="AWI-ESM-1-REcoM"))
        plotname <- paste0(plotpath, "/", varname, "/mcs_bgc22_", varname, "_timmean_global_1982-2100_", paste(names(data), collapse="_vs_"), "_clim_1982-2011_pctile_10_minDuration_5_withTrend")
    }

} else if (F) { # nevents per year
    varname <- "nevents"
    if (T) { # sst/tos
        varname_label <- "MHWs per year [#]"
        if (T) { # hist
            if (F) { # obs with/wout trend
                data <- list("oisst_with"=list(fin="/work/ba1103/a270073/post/heatwaveR/timmean/sst/oisst_v2.1_mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_0066904-1036800_nloc_691150_nevents_yearsum_timmean.nc",
                                          lonname="lon",
                                          latname="lat",
                                          label="OISSTv2.1 with trend"),
                             "oisst_wout"=list(fin="/work/ba1103/a270073/post/heatwaveR/timmean/sst/oisst_v2.1_mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_0066904-1036800_nloc_691150_nevents_yearsum_timmean.nc",
                                          lonname="lon",
                                          latname="lat",
                                          label="OISSTv2.1 wout trend"))
                plotname <- paste0(plotpath, "/", varname, "/mhw_sst_", varname, "_yearsum_timmean_global_1982-2021_oisst_withTrend_vs_woutTrend_clim_1982-2021_pctile_90_minDuration_5")
            } else if (F) { # obs vs model with trend
                data <- list("oisst"=list(fin="/work/ba1103/a270073/post/heatwaveR/timmean/sst/oisst_v2.1_mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_0066904-1036800_nloc_691150_nevents_yearsum_timmean.nc",
                                          lonname="lon",
                                          latname="lat",
                                          label="OISSTv2.1"),
                             "awicm1-recom_historical3_and_ssp585_2"=list(
                                 fin="/work/ba1103/a270073/post/heatwaveR/timmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_nevents_yearsum_timmean_remapycon_global_0.25.nc",
                                 lonname="lon",
                                 latname="lat",
                                 label="AWI-ESM-1-REcoM"))
                plotname <- paste0(plotpath, "/", varname, "/mhw_sst_", varname, "_yearsum_timmean_global_1982-2021_", paste(names(data), collapse="_vs_"), "_clim_1982-2021_pctile_90_minDuration_5_withTrend")
            } else if (T) { # obs vs model wout trend
                data <- list("oisst"=list(fin="/work/ba1103/a270073/post/heatwaveR/timmean/sst/oisst_v2.1_mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_0066904-1036800_nloc_691150_nevents_yearsum_timmean.nc",
                                          lonname="lon",
                                          latname="lat",
                                          label="OISSTv2.1"),
                             "awicm1-recom_historical3_and_ssp585_2"=list(
                                 fin="/work/ba1103/a270073/post/heatwaveR/timmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_000001-126859_nloc_126859_nevents_yearsum_timmean_remapycon_global_0.25.nc",
                                 lonname="lon",
                                 latname="lat",
                                 label="AWI-ESM-1-REcoM"))
                plotname <- paste0(plotpath, "/", varname, "/mhw_sst_", varname, "_yearsum_timmean_global_1982-2021_", paste(names(data), collapse="_vs_"), "_clim_1982-2021_pctile_90_minDuration_5_woutTrend")
            }
        } else if (F) { # ssp
            data <- list("awicm1-recom_historical3_and_ssp585_2"=list(
                             #fin="/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_nevents_fldmean.nc",
                             fin="/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_nevents_yearsum_fldmean.nc",
                             label="AWI-ESM-1-REcoM"))
            #plotname <- paste0(plotpath, "/fldmean/", varname, "/mhw_sst_", varname, "_global_1982-2100_", paste(names(data), collapse="_vs_"), "_clim_1982-2011_pctile_90_minDuration_5_withTrend")
            plotname <- paste0(plotpath, "/fldmean/", varname, "/mhw_sst_", varname, "_yearsum_global_1982-2100_", paste(names(data), collapse="_vs_"), "_clim_1982-2011_pctile_90_minDuration_5_withTrend")
        }
    } else if (F) { # bgc22
        varname_label <- "ODXs per year [#]"
        data <- list("awicm1-recom_historical2"=list(
                         fin="/work/ba1103/a270073/post/heatwaveR/timmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mcs_bgc22_ts_19820101-21001231_clim_19820101-20111231_pctile_10_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_timmean_remap_global_1.nc",
                         lonname="lon",
                         latname="lat",
                         label="AWI-ESM-1-REcoM"))
        plotname <- paste0(plotpath, "/", varname, "/mcs_bgc22_", varname, "_timmean_global_1982-2100_", paste(names(data), collapse="_vs_"), "_clim_1982-2011_pctile_10_minDuration_5_withTrend")
    }

} else if (F) { # event days per year = exposure
    varname <- "duration"
    if (T) { # sst/tos
        varname_label <- "MHW days per year [#]"
        if (T) { # hist
            if (F) { # obs with/wout trend
                data <- list("oisst_with"=list(fin="/work/ba1103/a270073/post/heatwaveR/timmean/sst/oisst_v2.1_mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_0066904-1036800_nloc_691150_duration_yearsum_timmean.nc",
                                          lonname="lon",
                                          latname="lat",
                                          label="OISSTv2.1 with trend"),
                             "oisst_wout"=list(fin="/work/ba1103/a270073/post/heatwaveR/timmean/sst/oisst_v2.1_mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_0066904-1036800_nloc_691150_duration_yearsum_timmean.nc",
                                          lonname="lon",
                                          latname="lat",
                                          label="OISSTv2.1 wout trend"))
                plotname <- paste0(plotpath, "/", varname, "/mhw_sst_", varname, "_yearsum_timmean_global_1982-2021_oisst_withTrend_vs_woutTrend_clim_1982-2021_pctile_90_minDuration_5")
            } else if (F) { # obs vs model with trend
                data <- list("oisst"=list(fin="/work/ba1103/a270073/post/heatwaveR/timmean/sst/oisst_v2.1_mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_0066904-1036800_nloc_691150_duration_yearsum_timmean.nc",
                                          lonname="lon",
                                          latname="lat",
                                          label="OISSTv2.1"),
                             "awicm1-recom_historical3_and_ssp585_2"=list(
                                 fin="/work/ba1103/a270073/post/heatwaveR/timmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_duration_yearsum_timmean_remapycon_global_0.25.nc",
                                 lonname="lon",
                                 latname="lat",
                                 label="AWI-ESM-1-REcoM"))
                plotname <- paste0(plotpath, "/", varname, "/mhw_sst_", varname, "_yearsum_timmean_global_1982-2021_", paste(names(data), collapse="_vs_"), "_clim_1982-2021_pctile_90_minDuration_5_withTrend")
            } else if (T) { # obs vs model wout trend
                data <- list("oisst"=list(fin="/work/ba1103/a270073/post/heatwaveR/timmean/sst/oisst_v2.1_mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_0066904-1036800_nloc_691150_duration_yearsum_timmean.nc",
                                          lonname="lon",
                                          latname="lat",
                                          label="OISSTv2.1"),
                             "awicm1-recom_historical3_and_ssp585_2"=list(
                                 fin="/work/ba1103/a270073/post/heatwaveR/timmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_000001-126859_nloc_126859_duration_yearsum_timmean_remapycon_global_0.25.nc",
                                 lonname="lon",
                                 latname="lat",
                                 label="AWI-ESM-1-REcoM"))
                plotname <- paste0(plotpath, "/", varname, "/mhw_sst_", varname, "_yearsum_timmean_global_1982-2021_", paste(names(data), collapse="_vs_"), "_clim_1982-2021_pctile_90_minDuration_5_woutTrend")
            }
        
        } else if (F) { # ssp

        }
    } else if (F) { # bgc22

    }

} else if (F) { # intensity_mean
    varname <- "intensity_mean"
    if (T) { # sst/tos
        varname_label <- "MHW mean intensity [°C]"
        if (T) { # hist
            if (F) { # obs with/wout trend
                data <- list("oisst_with"=list(fin="/work/ba1103/a270073/post/heatwaveR/eventmean_ltm/sst/oisst_v2.1_mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_0066904-1036800_nloc_691150_intensity_mean_eventmean_ltm.nc",
                                          lonname="lon",
                                          latname="lat",
                                          label="OISSTv2.1 with trend"),
                             "oisst_wout"=list(fin="/work/ba1103/a270073/post/heatwaveR/eventmean_ltm/sst/oisst_v2.1_mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_0066904-1036800_nloc_691150_intensity_mean_eventmean_ltm.nc",
                                          lonname="lon",
                                          latname="lat",
                                          label="OISSTv2.1 wout trend"))
                plotname <- paste0(plotpath, "/", varname, "/mhw_sst_", varname, "_eventmean_ltm_global_1982-2021_oisst_withTrend_vs_woutTrend_clim_1982-2021_pctile_90_minDuration_5")
            } else if (F) { # obs vs model with trend
                data <- list("oisst"=list(fin="/work/ba1103/a270073/post/heatwaveR/eventmean_ltm/sst/oisst_v2.1_mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_0066904-1036800_nloc_691150_intensity_mean_eventmean_ltm.nc",
                                          lonname="lon",
                                          latname="lat",
                                          label="OISSTv2.1"),
                             "awicm1-recom_historical3_and_ssp585_2"=list(
                                 fin="/work/ba1103/a270073/post/heatwaveR/eventmean_ltm/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_intensity_mean_eventmean_ltm_remapycon_global_0.25.nc",
                                 lonname="lon",
                                 latname="lat",
                                 label="AWI-ESM-1-REcoM"))
                plotname <- paste0(plotpath, "/", varname, "/mhw_sst_", varname, "_eventmean_ltm_global_1982-2021_", paste(names(data), collapse="_vs_"), "_clim_1982-2021_pctile_90_minDuration_5_withTrend")
            } else if (T) { # obs vs model wout trend
                data <- list("oisst"=list(fin="/work/ba1103/a270073/post/heatwaveR/eventmean_ltm/sst/oisst_v2.1_mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_0066904-1036800_nloc_691150_intensity_mean_eventmean_ltm.nc",
                                          lonname="lon",
                                          latname="lat",
                                          label="OISSTv2.1"),
                             "awicm1-recom_historical3_and_ssp585_2"=list(
                                 fin="/work/ba1103/a270073/post/heatwaveR/eventmean_ltm/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_000001-126859_nloc_126859_intensity_mean_eventmean_ltm_remapycon_global_0.25.nc", 
                                 lonname="lon",
                                 latname="lat",
                                 label="AWI-ESM-1-REcoM"))
                plotname <- paste0(plotpath, "/", varname, "/mhw_sst_", varname, "_eventmean_ltm_global_1982-2021_", paste(names(data), collapse="_vs_"), "_clim_1982-2021_pctile_90_minDuration_5_woutTrend")
            }
        } else if (F) { # ssp
            data <- list("awicm1-recom_historical3_and_ssp585_2"=list(
                             fin="/work/ba1103/a270073/post/heatwaveR/timmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_timmean_remap_global_0.25.nc",
                             lonname="lon",
                             latname="lat",
                             label="AWI-ESM-1-REcoM"))
            plotname <- paste0(plotpath, "/", varname, "/mhw_sst_", varname, "_timmean_global_1982-2100_", paste(names(data), collapse="_vs_"), "_clim_1982-2011_pctile_90_minDuration_5_withTrend")
        }
    } else if (F) { # bgc22
        varname_label <- eval(substitute(expression(paste("ODX mean intensity [mmol m"^paste(-3), "]"))))
        data <- list("awicm1-recom_historical2"=list(
                         fin="/work/ba1103/a270073/post/heatwaveR/timmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mcs_bgc22_ts_19820101-20141231_clim_19820101-20111231_pctile_10_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_intensity_mean_timmean_remap_global_0.25.nc",
                         #fin="/work/ba1103/a270073/post/heatwaveR/timmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mcs_bgc22_ts_19820101-21001231_clim_19820101-20111231_pctile_10_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_timmean_remap_global_1.nc",
                         #fin="/work/ba1103/a270073/post/heatwaveR/timmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mcs_bgc22_ts_19820101-21001231_clim_19820101-20111231_pctile_10_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_timmean_remap_global_0.25.nc",
                         #fin="/work/ba1103/a270073/post/heatwaveR/timmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_mcs_bgc22_ts_19820101-21001231_clim_19820101-20111231_pctile_10_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_timmean_remap_global_0.1.nc",
                         lonname="lon",
                         latname="lat",
                         label="AWI-ESM-1-REcoM"))
        plotname <- paste0(plotpath, "/", varname, "/mcs_bgc22_", varname, "_timmean_global_1982-2014_", paste(names(data), collapse="_vs_"), "_clim_1982-2011_pctile_10_minDuration_5_withTrend")
        #plotname <- paste0(plotpath, "/", varname, "/mcs_bgc22_", varname, "_timmean_global_1982-2100_", paste(names(data), collapse="_vs_"), "_clim_1982-2011_pctile_10_minDuration_5_withTrend")
    }

} else if (F) { # intensity_var
    varname <- "intensity_var"
    if (T) { # sst/tos
        varname_label <- "MHW intensity std. dev. [°C]"
        if (T) { # hist
            data <- list("oisst"=list(fin="/work/ba1103/a270073/post/heatwaveR/timmean/sst/oisst_v2.1_mhw_sst_ts_19820101-20141231_clim_19820101-20141231_pctile_90_minDuration_5_withTrend_locinds_0066904-1036800_nloc_691150_timmean.nc",
                                      lonname="lon",
                                      latname="lat",
                                      label="OISSTv2.1"),
                         "awicm1-recom_historical2"=list(
                             #fin="/work/ba1103/a270073/post/heatwaveR/timmean/tos/awi-esm-1-1-lr_kh800_historical2_mhw_tos_ts_19820101-20141231_clim_19820101-20141231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_timmean_remap_global_1.nc",
                             fin="/work/ba1103/a270073/post/heatwaveR/timmean/tos/awi-esm-1-1-lr_kh800_historical2_mhw_tos_ts_19820101-20141231_clim_19820101-20141231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_timmean_remap_global_0.25.nc",
                             #fin="/work/ba1103/a270073/post/heatwaveR/timmean/tos/awi-esm-1-1-lr_kh800_historical2_mhw_tos_ts_19820101-20141231_clim_19820101-20141231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_timmean_remap_global_0.1.nc",
                             lonname="lon",
                             latname="lat",
                             label="AWI-ESM-1-REcoM"))
            plotname <- paste0(plotpath, "/", varname, "/mhw_sst_", varname, "_timmean_global_1982-2014_", paste(names(data), collapse="_vs_"), "_clim_1982-2014_pctile_90_minDuration_5_withTrend")
        }
    }

} else if (F) { # trend_pdecade
    varname <- "trend_pdec"
    if (T) { # sst/tos
        varname_label <- eval(substitute(expression(paste("SST trend [°C decade"^paste(-1), "]"))))
        if (T) { # hist
            data <- list("oisst"=list(fin="/work/ba1103/a270073/post/heatwaveR/timmean/sst/oisst_v2.1_mhw_sst_ts_19820101-20141231_clim_19820101-20141231_pctile_90_minDuration_5_withTrend_locinds_0066904-1036800_nloc_691150_timmean.nc",
                                      lonname="lon",
                                      latname="lat",
                                      label="OISSTv2.1"),
                         "awicm1-recom_historical2"=list(
                             #fin="/work/ba1103/a270073/post/heatwaveR/timmean/tos/awi-esm-1-1-lr_kh800_historical2_mhw_tos_ts_19820101-20141231_clim_19820101-20141231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_timmean_remap_global_1.nc",
                             fin="/work/ba1103/a270073/post/heatwaveR/timmean/tos/awi-esm-1-1-lr_kh800_historical2_mhw_tos_ts_19820101-20141231_clim_19820101-20141231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_timmean_remap_global_0.25.nc",
                             #fin="/work/ba1103/a270073/post/heatwaveR/timmean/tos/awi-esm-1-1-lr_kh800_historical2_mhw_tos_ts_19820101-20141231_clim_19820101-20141231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_timmean_remap_global_0.1.nc",
                             lonname="lon",
                             latname="lat",
                             label="AWI-ESM-1-REcoM"))
            plotname <- paste0(plotpath, "/", varname, "/mhw_sst_", varname, "_timmean_global_1982-2014_", paste(names(data), collapse="_vs_"), "_clim_1982-2014_pctile_90_minDuration_5_withTrend")
        }
    }

} # which variable

########################################################

# check
dir.create(dirname(plotname), recursive=T, showWarnings=F)
if (!dir.exists(dirname(plotname))) stop("could not create plot path ", dirname(plotname))

# read data
for (di in seq_along(data)) {
    message("*****************************************************\n",
            "data ", di, "/", length(data), ": ", names(data)[di], "\n",
            "open ", data[[di]]$fin, " ...")
    nc <- nc_open(data[[di]]$fin)
    tmp_lon <- nc$dim[[data[[di]]$lonname]]$vals
    message("read variable ", varname_nc, " ...")
    tmp_data <- ncvar_get(nc, varname_nc)
    if (all(range(tmp_lon) >= 0)) { # lon 0-360
        message("convert lons from ", min(tmp_lon), "° to ", max(tmp_lon), "° to -180:180° ...")
        tmp <- convert_lon_360_to_180(lon360=tmp_lon, data360=tmp_data)
        data[[di]]$lon <- tmp$lon180
        data[[di]]$lat <- nc$dim[[data[[di]]$latname]]$vals
        data[[di]]$data <- tmp$data180[[1]]
    } else {
        data[[di]]$lon <- tmp_lon
        data[[di]]$lat <- nc$dim[[data[[di]]$latname]]$vals
        data[[di]]$data <- tmp_data
    }

    # special
    if (varname_nc == "nevents" && grepl("oisst", names(data)[di])) {
        inds <- data[[di]]$data == 0
        message("special: set zero to NA")
        data[[di]]$data[inds] <- NA # set 0 to NA; quick and dirty; todo
    }
    if (T && varname_out == "duration") {
        message("special: convert days --> years: /365.25")
        data[[di]]$data <- data[[di]]$data/365.25
        if (di == 1) varname_label <- "MHW duration [years]"
    }
} # for di

# plot timmean
x <- lapply(data, "[[", "lon")
y <- lapply(data, "[[", "lat")
z <- lapply(data, "[[", "data")
xlim <- range(x, na.rm=T)
ylim <- range(y, na.rm=T)
zlim <- range(z, na.rm=T)
zlevels <- axis.labels <- axis.at <- axis.round <- axis.addzlims <- NULL
if (F) {
    qn <- lapply(z, quantile, probs=c(0, 0.1, 0.9, 1), na.rm=T)
    message("\nquantiles:")
    cat(capture.output(str(qn)), sep="\n")
    if (F) { # use only obs zlim
        message("\nspecial: use zlim of setting 1 only")
        qn <- qn[1] # keep as list
    }
    qn10_90 <- c(min(sapply(qn, "[", "10%")), max(sapply(qn, "[", "90%")))
    zlevels <- pretty(qn10_90, n=8)
    if (any(zlevels < qn10_90[1])) zlevels <- zlevels[-which(zlevels < qn10_90[1])]
    if (any(zlevels > qn10_90[2])) zlevels <- zlevels[-which(zlevels > qn10_90[2])]
    if (zlim[1] < min(zlevels)) zlevels <- c(zlim[1], zlevels)
    if (zlim[2] > max(zlevels)) zlevels <- c(zlevels, zlim[2])
    message("zlevels:\n", paste(zlevels, collapse=", "))
}
if (T && varname_out == "duration") {
    message("special duration zlabels")
    # zlim without interpolation:
    # 31a fixed with trend: 5.5878      4586.1      29368
    # 31a fixed wout trend: 4.0000      51.752      739.48
    # 31a running mean:     4.4167      22.815      374.50
    # 15a running mean:     3.2500      17.765      250.85
    zlevels <- c(zlim[1], 
                 c(2, 4)*7/365.25, # weeks, 
                 c(2, 3, 6, 9)/12, # months
                 1, 2, 5, 10, 20, 50, zlim[2]) # years
    axis.labels <- c(paste0(round(zlim[1]*365.25, 2), "d"),
                     paste0(c(2, 4), "w"),
                     paste0(c(2, 3, 6, 9), "m"),
                     paste0(c(1, 2, 5, 10, 20, 50, round(zlim[2])), "y"))
    axis.at <- seq_along(axis.labels)
    axis.round <- 1
    axis.addzlims <- F
    varname_label <- "MHW duration"
}
ip <- image.plot.pre(zlim=zlim, zlevels=zlevels, axis.labels=axis.labels, axis.at=axis.at, axis.round=axis.round, axis.addzlims=axis.addzlims)
if (grepl("intensity", varname_out) && grepl("bgc22", basename(plotname))) { # revert colorbar
    ip$cols <- rev(ip$cols)
}
nrow <- ncol <- NULL
if (T && length(data) == 2) {
    if (length(data) == 2) nrow <- 1; ncol <- 2
}
nm <- image.plot.nxm(x, y, z, n=nrow, m=ncol, dry=T)

proj <- zoomfac <- NULL
add_grid <- F
if (area == "NH60") { # projection
    proj <- "+proj=stere +lon_0=-40 +lat_0=90 +lat_ts=90"
    ylim <- c(55, 90)
    zoomfac <- 1
    add_grid <- T
    plotname <- sub("_global_", "_NH_50_", plotname)
}

pp <- plot_sizes()
if (plot_type == "x11") {
    # nothing to do
} else if (plot_type == "png") {
    plotname <- paste0(plotname, ".png")
    png(plotname, width=nm$ncol*pp$png_width_px, height=nm$nrow*pp$png_height_px, res=pp$png_ppi, family="Droid Sans")
} else if (plot_type == "pdf") {
    plotname <- paste0(plotname, ".pdf")
    pdf(plotname, width=pp$pdf_width_in, height=pp$pdf_height_in, family="Droid Sans")
} else {
    stop("plot_type ", plot_type, " not implemented")
}
message("\nsave ", plotname, " ...")

#source("~/scripts/r/functions/image.plot.nxm.r")
image.plot.nxm(x, y, z, xlim=xlim, ylim=ylim, n=nm$nrow, m=nm$ncol, ip=ip,
               proj=proj, zoomfac=zoomfac, add_grid=add_grid,
               xlab="Longitude [°]", ylab="Latitude [°]", 
               zlab=varname_label, 
               znames_labels=sapply(data, "[[", "label"),
               add_contour=F, useRaster=T,
               verbose=F)
if (plot_type == "x11") {
    stop("asd")
} else {
    dev.off()
    if (plot_type == "pdf") grDevices::embedFonts(plotname, outfile=plotname)
}

