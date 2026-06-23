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

#area <- "global"
area <- "NH60"

depth <- NULL
#depth <- "200m"

if (T) { # mean event duration
    varname_out <- "duration"
    varname_nc <- "duration"
    if (T) { # sst/tos
        varname_label <- "Mean MHW duration [days]"
        if (F) { # hist
            if (T) { # obs vs model with vs wout trend
                data <- list("oisst_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/sst/oisst_v2.1/mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_0066904-1036800_nloc_691150_duration_eventmean_an_fldmean_", area, ".nc"),
                                               label="OISSTv2.1 with trend"),
                             "oisst_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/sst/oisst_v2.1/mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_0066904-1036800_nloc_691150_duration_eventmean_an_fldmean_", area, ".nc"),
                                               label="OISSTv2.1 wout trend"),
                             "awicm1-recom_historical3_and_ssp585_2_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_fldmean_", area, ".nc"),
                                               label="AWI-ESM-1-REcoM with trend"),
                             "awicm1-recom_historical3_and_ssp585_2_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_fldmean_", area, ".nc"),
                                               label="AWI-ESM-1-REcoM wout trend"))
                cols <- rep(mycols(2), e=2)
                ltys <- rep(1:2, t=2)
                plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_sst_", varname_out, "_eventmean_an_fldmean_", area, "_1982-2021_", paste(names(data), collapse="_vs_"), "_clim_1982-2021_pctile_90_minDuration_5")
            }
        } else if (T) { # hist and ssp
            if (F) { # obs vs model with vs wout trend
                data <- list("oisst_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/sst/oisst_v2.1/mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_0066904-1036800_nloc_691150_duration_eventmean_an_fldmean_", area, ".nc"),
                                               label="OISSTv2.1 with trend"),
                             "oisst_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/sst/oisst_v2.1/mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_0066904-1036800_nloc_691150_duration_eventmean_an_fldmean_", area, ".nc"),
                                               label="OISSTv2.1 wout trend"),
                             "awicm1-recom_historical3_and_ssp585_2_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_fldmean_", area, ".nc"),
                                               label="AWI-ESM-1-REcoM with trend"),
                             "awicm1-recom_historical3_and_ssp585_2_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_fldmean_", area, ".nc"),
                                               label="AWI-ESM-1-REcoM wout trend"))
                cols <- rep(mycols(2), e=2)
                ltys <- rep(1:2, t=2)
                plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_sst_", varname_out, "_eventmean_an_fldmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_clim_1982-2021_pctile_90_minDuration_5")
            } else if (F) { # fixed baseline w/out trend, 15/30a run mean
                data <- list("fixed_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_fixed_baseline_withTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_fldmean_", area, ".nc"),
                                               label="30-yr fixed baseline with trend"),
                             "fixed_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_fixed_baseline_woutTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_fldmean_", area, ".nc"),
                                               label="30-yr fixed baseline without trend"),
                             "runmean_31a"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_fldmean_", area, ".nc"),
                                                label="31-yr running mean"),
                             "runmean_15a"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_15a_withTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_fldmean_", area, ".nc"),
                                                label="15-yr running mean"))
                cols <- mycols(4)
                plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_sst_", varname_out, "_eventmean_an_fldmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_pctile_90_minDuration_5")
            } else if (T) { # 31a run mean sic ranges
                data <- list("sic_ltc_15"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_fldmean_", area, "_sic_ltc_0.15.nc"),
                                               label="SIC<15%"),
                             "sic_gec_15_ltc_50"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_fldmean_", area, "_sic_gec_0.15_ltc_0.5.nc"),
                                                      label="15%≤SIC<50%"),
                             "sic_gec_50_ltc_85"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_fldmean_", area, "_sic_gec_0.5_ltc_0.85.nc"),
                                                      label="50%≤SIC<85%"),
                             "sic_gec_85"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_fldmean_", area, "_sic_gec_0.85.nc"),
                                               label="SIC≥85%"))
                cols <- mycols(4)[c(1, 3, 4, 2)]
                plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_sst_", varname_out, "_eventmean_an_fldmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_pctile_90_minDuration_5_runmean_31a_sic_ranges")
            }
        }
    } else if (F) { # bgc22
        varname_label <- "Mean ODX duration [days]"
        if (F) {
            data <- list("awicm1-recom_historical3_and_ssp585_2"=list(
                         fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mcs_bgc22_ts_19820101-21001231_clim_19820101-20111231_pctile_10_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_", area, "_duration_yearmean_fldmean.nc"),
                         label="AWI-ESM-1-REcoM"))
            plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mcs_bgc22_", varname_out, "_yearmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_clim_1982-2011_pctile_10_minDuration_5_withTrend.png")
        } else if (T) { # 31a run mean sic ranges
            data <- list("sic_ltc_15"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_fldmean_", area, "_sic_ltc_0.15.nc"),
                                           label="SIC<15%"),
                         "sic_gec_15_ltc_50"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_fldmean_", area, "_sic_gec_0.15_ltc_0.5.nc"),
                                                  label="15%≤SIC<50%"),
                         "sic_gec_50_ltc_85"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_fldmean_", area, "_sic_gec_0.5_ltc_0.85.nc"),
                                                  label="50%≤SIC<85%"),
                         "sic_gec_85"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_duration_eventmean_an_fldmean_", area, "_sic_gec_0.85.nc"),
                                           label="SIC≥85%"))
            cols <- mycols(4)[c(1, 3, 4, 2)]
            plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mcs_bgc22_0m_", varname_out, "_eventmean_an_fldmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_pctile_90_minDuration_5_runmean_31a_sic_ranges")
        }
    } else if (F) { # tos and bgc22 individually
        varname_label <- "Mean duration [days]"
        data <- list("awicm1-recom_historical3_and_ssp585_2_sst"=list(
                         fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_", area, "_duration_yearmean_fldmean.nc"),
                         label="AWI-ESM-1-REcoM SST"),
                     "awicm1-recom_historical3_and_ssp585_2_bgc22"=list(
                         fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mcs_bgc22_0m_ts_19820101-21001231_clim_19820101-20111231_pctile_10_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_", area, "_duration_yearmean_fldmean.nc"),
                         label="AWI-ESM-1-REcoM Oxygen"))
        plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_sst_pctile_90_vs_mcs_bgc22_0m_pctile_10_", varname_out, "_yearsum_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_clim_1982-2011_minDuration_5_withTrend.png")
        cols <- mycols(3)[2:3] # myred, myblue
    
    } else if (F) { # ce_tos_bgc22
        varname_label <- "Mean MHW+ODX compound duration [days]"
        if (T) { # 31a run mean sic ranges
            data <- list("sic_ltc_15"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/ce_tos_bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_pctile_90_mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126783_duration_eventmean_an_fldmean_", area, "_sic_ltc_0.15.nc"),
                                           label="SIC<15%"),
                         "sic_gec_15_ltc_50"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/ce_tos_bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_pctile_90_mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126783_duration_eventmean_an_fldmean_", area, "_sic_gec_0.15_ltc_0.5.nc"),
                                                  label="15%≤SIC<50%"),
                         "sic_gec_50_ltc_85"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/ce_tos_bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_pctile_90_mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126783_duration_eventmean_an_fldmean_", area, "_sic_gec_0.5_ltc_0.85.nc"),
                                                  label="50%≤SIC<85%"),
                         "sic_gec_85"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/ce_tos_bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_pctile_90_mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126783_duration_eventmean_an_fldmean_", area, "_sic_gec_0.85.nc"),
                                           label="SIC≥85%"))
            cols <- mycols(4)[c(1, 3, 4, 2)]
            plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_ce_sst_bgc22_0m_", varname_out, "_eventmean_an_fldmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_pctile_90_minDuration_5_runmean_31a_sic_ranges")
        }
    } # bases on which variable

} else if (F) { # nevents yearsum
    varname_out <- "nevents"
    varname_nc <- "nevents"
    if (F) { # sst/tos
        varname_label <- "MHWs per year [#]"
        if (F) { # hist
            if (T) { # obs vs model with vs wout trend
                data <- list("oisst_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/sst/oisst_v2.1/mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_0066904-1036800_nloc_691150_nevents_yearsum_fldmean_", area, ".nc"),
                                               label="OISSTv2.1 with trend"),
                             "oisst_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/sst/oisst_v2.1/mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_0066904-1036800_nloc_691150_nevents_yearsum_fldmean_", area, ".nc"),
                                               label="OISSTv2.1 wout trend"),
                             "awicm1-recom_historical3_and_ssp585_2_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_nevents_yearsum_fldmean_", area, ".nc"),
                                               label="AWI-ESM-1-REcoM with trend"),
                             "awicm1-recom_historical3_and_ssp585_2_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_000001-126859_nloc_126859_nevents_yearsum_fldmean_", area, ".nc"),
                                               label="AWI-ESM-1-REcoM wout trend"))
                cols <- rep(mycols(2), e=2)
                ltys <- rep(1:2, t=2)
                plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_sst_", varname_out, "_yearsum_fldmean_", area, "_1982-2021_", paste(names(data), collapse="_vs_"), "_clim_1982-2021_pctile_90_minDuration_5")
            }
        } else if (T) { # hist and ssp
            if (F) { # obs vs model with vs wout trend
                data <- list("oisst_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/sst/oisst_v2.1/mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_0066904-1036800_nloc_691150_nevents_yearsum_fldmean_", area, ".nc"),
                                               label="OISSTv2.1 with trend"),
                             "oisst_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/sst/oisst_v2.1/mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_0066904-1036800_nloc_691150_nevents_yearsum_fldmean_", area, ".nc"),
                                               label="OISSTv2.1 wout trend"),
                             "awicm1-recom_historical3_and_ssp585_2_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_nevents_yearsum_fldmean_", area, ".nc"),
                                               label="AWI-ESM-1-REcoM with trend"),
                             "awicm1-recom_historical3_and_ssp585_2_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_000001-126859_nloc_126859_nevents_yearsum_fldmean_", area, ".nc"),
                                               label="AWI-ESM-1-REcoM wout trend"))
                cols <- rep(mycols(2), e=2)
                ltys <- rep(1:2, t=2)
                plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_sst_", varname_out, "_yearsum_fldmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_clim_1982-2021_pctile_90_minDuration_5")
            } else if (F) { # fixed baseline w/out trend, 15/30a run mean
                data <- list("fixed_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_fixed_baseline_withTrend_locinds_000001-126859_nloc_126859_nevents_yearsum_fldmean_", area, ".nc"),
                                               label="30-yr fixed baseline with trend"),
                             "fixed_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_fixed_baseline_woutTrend_locinds_000001-126859_nloc_126859_nevents_yearsum_fldmean_", area, ".nc"),
                                               label="30-yr fixed baseline without trend"),
                             "runmean_31a"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_nevents_yearsum_fldmean_", area, ".nc"),
                                                label="31-yr running mean"),
                             "runmean_15a"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_15a_withTrend_locinds_000001-126859_nloc_126859_nevents_yearsum_fldmean_", area, ".nc"),
                                                label="15-yr running mean"))
                cols <- mycols(4)
                plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_sst_", varname_out, "_yearsum_fldmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_pctile_90_minDuration_5")
            } else if (T) { # 31a run mean sic ranges
                data <- list("sic_ltc_15"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_nevents_yearsum_fldmean_", area, "_sic_ltc_0.15.nc"),
                                               label="SIC<15%"),
                             "sic_gec_15_ltc_50"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_nevents_yearsum_fldmean_", area, "_sic_gec_0.15_ltc_0.5.nc"),
                                                      label="15%≤SIC<50%"),
                             "sic_gec_50_ltc_85"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_nevents_yearsum_fldmean_", area, "_sic_gec_0.5_ltc_0.85.nc"),
                                                      label="50%≤SIC<85%"),
                             "sic_gec_85"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_nevents_yearsum_fldmean_", area, "_sic_gec_0.85.nc"),
                                               label="SIC≥85%"))
                cols <- mycols(4)[c(1, 3, 4, 2)]
                plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_sst_", varname_out, "_yearsum_fldmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_pctile_90_minDuration_5_runmean_31a_sic_ranges")
            }
        }
    } else if (T) { # bgc22
        varname_label <- "ODXs per year [#]"
        if (F) {
            data <- list("awicm1-recom_historical3_and_ssp585_2"=list(
                         fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mcs_bgc22_ts_19820101-21001231_clim_19820101-20111231_pctile_10_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_", area, "_nevents_yearsum_fldmean.nc"),
                         label="AWI-ESM-1-REcoM"))
            plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mcs_bgc22_", varname_out, "_yearsum_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_clim_1982-2011_pctile_10_minDuration_5_withTrend.png")
        } else if (T) { # 31a run mean sic ranges
            data <- list("sic_ltc_15"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_nevents_yearsum_fldmean_", area, "_sic_ltc_0.15.nc"),
                                           label="SIC<15%"),
                         "sic_gec_15_ltc_50"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_nevents_yearsum_fldmean_", area, "_sic_gec_0.15_ltc_0.5.nc"),
                                                  label="15%≤SIC<50%"),
                         "sic_gec_50_ltc_85"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_nevents_yearsum_fldmean_", area, "_sic_gec_0.5_ltc_0.85.nc"),
                                                  label="50%≤SIC<85%"),
                         "sic_gec_85"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_nevents_yearsum_fldmean_", area, "_sic_gec_0.85.nc"),
                                           label="SIC≥85%"))
            cols <- mycols(4)[c(1, 3, 4, 2)]
            plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mcs_bgc22_0m_", varname_out, "_yearsum_fldmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_pctile_90_minDuration_5_runmean_31a_sic_ranges")
        }
    } else if (F) { # tos and bgc22 individually
        varname_label <- "Events per year [#]"
        data <- list("awicm1-recom_historical3_and_ssp585_2_sst"=list(
                         fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_", area, "_nevents_yearsum_fldmean.nc"),
                         label="AWI-ESM-1-REcoM SST"),
                     "awicm1-recom_historical3_and_ssp585_2_bgc22"=list(
                         fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mcs_bgc22_ts_19820101-21001231_clim_19820101-20111231_pctile_10_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_", area, "_nevents_yearsum_fldmean.nc"),
                         label="AWI-ESM-1-REcoM Oxygen"))
        plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_sst_pctile_90_vs_mcs_bgc22_pctile_10_", varname_out, "_yearsum_fldmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_clim_1982-2011_minDuration_5_withTrend.png")
        cols <- mycols(3)[2:3] # myred, myblue
    } else if (F) { # ce_tos_bgc22
        varname_label <- "MHW+ODX compound events per year [#]"
        if (T) { # 31a run mean sic ranges
            data <- list("sic_ltc_15"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/ce_tos_bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_pctile_90_mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126783_nevents_yearsum_fldmean_", area, "_sic_ltc_0.15.nc"),
                                           label="SIC<15%"),
                         "sic_gec_15_ltc_50"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/ce_tos_bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_pctile_90_mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126783_nevents_yearsum_fldmean_", area, "_sic_gec_0.15_ltc_0.5.nc"),
                                                  label="15%≤SIC<50%"),
                         "sic_gec_50_ltc_85"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/ce_tos_bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_pctile_90_mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126783_nevents_yearsum_fldmean_", area, "_sic_gec_0.5_ltc_0.85.nc"),
                                                  label="50%≤SIC<85%"),
                         "sic_gec_85"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/ce_tos_bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_pctile_90_mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126783_nevents_yearsum_fldmean_", area, "_sic_gec_0.85.nc"),
                                           label="SIC≥85%"))
            cols <- mycols(4)[c(1, 3, 4, 2)]
            plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_ce_sst_bgc22_0m_", varname_out, "_yearsum_fldmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_pctile_90_minDuration_5_runmean_31a_sic_ranges")
        }
    }

} else if (F) { # event days per year = exposure
    varname_out <- "exposure"
    varname_nc <- "duration"
    if (F) { # sst/tos
        varname_label <- "MHW days per year"
        if (F) { # hist
            if (T) { # obs vs model with vs wout trend
                data <- list("oisst_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/sst/oisst_v2.1/mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_0066904-1036800_nloc_691150_duration_yearsum_fldmean_", area, ".nc"),
                                               label="OISSTv2.1 with trend"),
                             "oisst_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/sst/oisst_v2.1/mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_0066904-1036800_nloc_691150_duration_yearsum_fldmean_", area, ".nc"),
                                               label="OISSTv2.1 wout trend"),
                             "awicm1-recom_historical3_and_ssp585_2_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_duration_yearsum_fldmean_", area, ".nc"),
                                               label="AWI-ESM-1-REcoM with trend"),
                             "awicm1-recom_historical3_and_ssp585_2_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_000001-126859_nloc_126859_duration_yearsum_fldmean_", area, ".nc"),
                                               label="AWI-ESM-1-REcoM wout trend"))
                cols <- rep(mycols(2), e=2)
                ltys <- rep(1:2, t=2)
                plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_sst_", varname_out, "_fldmean_", area, "_1982-2021_", paste(names(data), collapse="_vs_"), "_clim_1982-2021_pctile_90_minDuration_5")
            }
        } else if (T) { # hist and ssp
            if (F) { # obs vs model with vs wout trend
                data <- list("oisst_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/sst/oisst_v2.1/mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_0066904-1036800_nloc_691150_duration_yearsum_fldmean_", area, ".nc"),
                                               label="OISSTv2.1 with trend"),
                             "oisst_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/sst/oisst_v2.1/mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_0066904-1036800_nloc_691150_duration_yearsum_fldmean_", area, ".nc"),
                                               label="OISSTv2.1 wout trend"),
                             "awicm1-recom_historical3_and_ssp585_2_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_duration_yearsum_fldmean_", area, ".nc"),
                                               label="AWI-ESM-1-REcoM with trend"),
                             "awicm1-recom_historical3_and_ssp585_2_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_000001-126859_nloc_126859_duration_yearsum_fldmean_", area, ".nc"),
                                               label="AWI-ESM-1-REcoM wout trend"))
                cols <- rep(mycols(2), e=2)
                ltys <- rep(1:2, t=2)
                plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_sst_", varname_out, "_fldmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_clim_1982-2021_pctile_90_minDuration_5")
            } else if (F) { # fixed baseline w/out trend, 15/30a run mean
                data <- list("fixed_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_fixed_baseline_withTrend_locinds_000001-126859_nloc_126859_duration_yearsum_fldmean_", area, ".nc"),
                                               label="30-yr fixed baseline with trend"),
                             "fixed_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_fixed_baseline_woutTrend_locinds_000001-126859_nloc_126859_duration_yearsum_fldmean_", area, ".nc"),
                                               label="30-yr fixed baseline without trend"),
                             "runmean_31a"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_duration_yearsum_fldmean_", area, ".nc"),
                                                label="31-yr running mean"),
                             "runmean_15a"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_15a_withTrend_locinds_000001-126859_nloc_126859_duration_yearsum_fldmean_", area, ".nc"),
                                                label="15-yr running mean"))
                cols <- mycols(4)
                plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_sst_", varname_out, "_fldmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_pctile_90_minDuration_5")
            } else if (T) { # 31a run mean sic ranges
                data <- list("sic_ltc_15"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_duration_yearsum_fldmean_", area, "_sic_ltc_0.15.nc"),
                                               label="SIC<15%"),
                             "sic_gec_15_ltc_50"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_duration_yearsum_fldmean_", area, "_sic_gec_0.15_ltc_0.5.nc"),
                                                      label="15%≤SIC<50%"),
                             "sic_gec_50_ltc_85"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_duration_yearsum_fldmean_", area, "_sic_gec_0.5_ltc_0.85.nc"),
                                                      label="50%≤SIC<85%"),
                             "sic_gec_85"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_duration_yearsum_fldmean_", area, "_sic_gec_0.85.nc"),
                                               label="SIC≥85%"))
                cols <- mycols(4)[c(1, 3, 4, 2)]
                plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_sst_", varname_out, "_fldmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_pctile_90_minDuration_5_runmean_31a_sic_ranges")
            }
        }
    } else if (T) { # bgc22
        varname_label <- "ODX days per year"
        if (T) { # 31a run mean sic ranges
            data <- list("sic_ltc_15"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_duration_yearsum_fldmean_", area, "_sic_ltc_0.15.nc"),
                                           label="SIC<15%"),
                         "sic_gec_15_ltc_50"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_duration_yearsum_fldmean_", area, "_sic_gec_0.15_ltc_0.5.nc"),
                                                  label="15%≤SIC<50%"),
                         "sic_gec_50_ltc_85"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_duration_yearsum_fldmean_", area, "_sic_gec_0.5_ltc_0.85.nc"),
                                                  label="50%≤SIC<85%"),
                         "sic_gec_85"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_duration_yearsum_fldmean_", area, "_sic_gec_0.85.nc"),
                                           label="SIC≥85%"))
            cols <- mycols(4)[c(1, 3, 4, 2)]
            plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mcs_bgc22_0m_", varname_out, "_fldmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_pctile_90_minDuration_5_runmean_31a_sic_ranges")
        }

    } else if (F) { # ce_tos_bgc22
        varname_label <- "MHW+ODX compound days per year"
        if (T) { # 31a run mean sic ranges
            data <- list("sic_ltc_15"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/ce_tos_bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_pctile_90_mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126783_duration_yearsum_fldmean_", area, "_sic_ltc_0.15.nc"),
                                           label="SIC<15%"),
                         "sic_gec_15_ltc_50"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/ce_tos_bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_pctile_90_mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126783_duration_yearsum_fldmean_", area, "_sic_gec_0.15_ltc_0.5.nc"),
                                                  label="15%≤SIC<50%"),
                         "sic_gec_50_ltc_85"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/ce_tos_bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_pctile_90_mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126783_duration_yearsum_fldmean_", area, "_sic_gec_0.5_ltc_0.85.nc"),
                                                  label="50%≤SIC<85%"),
                         "sic_gec_85"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/ce_tos_bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_pctile_90_mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126783_duration_yearsum_fldmean_", area, "_sic_gec_0.85.nc"),
                                           label="SIC≥85%"))
            cols <- mycols(4)[c(1, 3, 4, 2)]
            plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_ce_sst_bgc22_0m_", varname_out, "_fldmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_pctile_90_minDuration_5_runmean_31a_sic_ranges")
        }
    }

} else if (F) { # intensity_mean
    varname_out <- "intensity_mean"
    varname_nc <- "intensity_mean"
    if (T) { # sst/tos
        varname_label <- "MHW mean intensity [°C]"
        if (F) { # hist
            if (T) { # obs vs model with vs wout trend
                data <- list("oisst_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/sst/oisst_v2.1/mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_0066904-1036800_nloc_691150_intensity_mean_eventmean_an_fldmean_", area, ".nc"),
                                               label="OISSTv2.1 with trend"),
                             "oisst_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/sst/oisst_v2.1/mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_0066904-1036800_nloc_691150_intensity_mean_eventmean_an_fldmean_", area, ".nc"),
                                               label="OISSTv2.1 wout trend"),
                             "awicm1-recom_historical3_and_ssp585_2_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_intensity_mean_eventmean_an_fldmean_", area, ".nc"),
                                               label="AWI-ESM-1-REcoM with trend"),
                             "awicm1-recom_historical3_and_ssp585_2_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_000001-126859_nloc_126859_intensity_mean_eventmean_an_fldmean_", area, ".nc"),
                                               label="AWI-ESM-1-REcoM wout trend"))
                cols <- rep(mycols(2), e=2)
                ltys <- rep(1:2, t=2)
                plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_sst_", varname_out, "_eventmean_an_fldmean_", area, "_1982-2021_", paste(names(data), collapse="_vs_"), "_clim_1982-2021_pctile_90_minDuration_5")
            }
        } else if (T) { # hist and ssp
            if (F) { # obs vs model with vs wout trend
                if (F) { # eventmean_an; todo: wrong?!
                    data <- list("oisst_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/sst/oisst_v2.1/mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_0066904-1036800_nloc_691150_intensity_mean_eventmean_an_fldmean_", area, ".nc"),
                                                   label="OISSTv2.1 with trend"),
                                 "oisst_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/sst/oisst_v2.1/mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_0066904-1036800_nloc_691150_intensity_mean_eventmean_an_fldmean_", area, ".nc"),
                                                   label="OISSTv2.1 wout trend"),
                                 "awicm1-recom_historical3_and_ssp585_2_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_intensity_mean_eventmean_an_fldmean_", area, ".nc"),
                                                   label="AWI-ESM-1-REcoM with trend"),
                                 "awicm1-recom_historical3_and_ssp585_2_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_000001-126859_nloc_126859_intensity_mean_eventmean_an_fldmean_", area, ".nc"),
                                                   label="AWI-ESM-1-REcoM wout trend"))
                } else if (T) { # yearmean; todo: correct?!
                    data <- list("oisst_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/sst/oisst_v2.1/mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_0066904-1036800_nloc_691150_intensity_mean_yearmean_fldmean_", area, ".nc"),
                                                   label="OISSTv2.1 with trend"),
                                 "oisst_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/sst/oisst_v2.1/mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_0066904-1036800_nloc_691150_intensity_mean_yearmean_fldmean_", area, ".nc"),
                                                   label="OISSTv2.1 wout trend"),
                                 "awicm1-recom_historical3_and_ssp585_2_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_intensity_mean_yearmean_fldmean_", area, ".nc"),
                                                   label="AWI-ESM-1-REcoM with trend"),
                                 "awicm1-recom_historical3_and_ssp585_2_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_000001-126859_nloc_126859_intensity_mean_yearmean_fldmean_", area, ".nc"),
                                                   label="AWI-ESM-1-REcoM wout trend"))
                }
                cols <- rep(mycols(2), e=2)
                ltys <- rep(1:2, t=2)
                #plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_sst_", varname_out, "_eventmean_an_fldmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_clim_1982-2021_pctile_90_minDuration_5")
                plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_sst_", varname_out, "_yearmean_fldmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_clim_1982-2021_pctile_90_minDuration_5")
            } else if (F) { # fixed baseline w/out trend, 15/30a run mean
                data <- list("fixed_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_fixed_baseline_withTrend_locinds_000001-126859_nloc_126859_intensity_mean_yearmean_fldmean_", area, ".nc"),
                                               label="30-yr fixed baseline with trend"),
                             "fixed_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_fixed_baseline_woutTrend_locinds_000001-126859_nloc_126859_intensity_mean_yearmean_fldmean_", area, ".nc"),
                                               label="30-yr fixed baseline without trend"),
                             "runmean_31a"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_intensity_mean_yearmean_fldmean_", area, ".nc"),
                                                label="31-yr running mean"),
                             "runmean_15a"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_15a_withTrend_locinds_000001-126859_nloc_126859_intensity_mean_yearmean_fldmean_", area, ".nc"),
                                                label="15-yr running mean"))
                cols <- mycols(4)
                plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_sst_", varname_out, "_yearmean_fldmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_pctile_90_minDuration_5")
            } else if (T) { # 31a run mean sic ranges
                data <- list("sic_ltc_15"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_intensity_mean_yearmean_fldmean_", area, "_sic_ltc_0.15.nc"),
                                               label="SIC<15%"),
                             "sic_gec_15_ltc_50"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_intensity_mean_yearmean_fldmean_", area, "_sic_gec_0.15_ltc_0.5.nc"),
                                                      label="15%≤SIC<50%"),
                             "sic_gec_50_ltc_85"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_intensity_mean_yearmean_fldmean_", area, "_sic_gec_0.5_ltc_0.85.nc"),
                                                      label="50%≤SIC<85%"),
                             "sic_gec_85"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_intensity_mean_yearmean_fldmean_", area, "_sic_gec_0.85.nc"),
                                               label="SIC≥85%"))
                cols <- mycols(4)[c(1, 3, 4, 2)]
                plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_sst_", varname_out, "_yearmean_fldmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_pctile_90_minDuration_5_runmean_31a_sic_ranges")
            }
        }
    } else if (F) { # bgc22
        varname_label <- eval(substitute(expression(paste("ODX mean intensity [mmol m"^paste(-3), "]"))))
        data <- list("awicm1-recom_historical3_and_ssp585_2"=list(
                         fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mcs_bgc22_ts_19820101-21001231_clim_19820101-20111231_pctile_10_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_", area, "_intensity_mean_yearmean_fldmean.nc"),
                         label="AWI-ESM-1-REcoM"))
        plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mcs_bgc22_", varname_out, "_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_clim_1982-2011_pctile_10_minDuration_5_withTrend.png")
    }

} else if (F) { # intensity_max
    varname_out <- "intensity_max"
    varname_nc <- "intensity_max"
    if (F) { # sst/tos
        varname_label <- "MHW max intensity [°C]"
        if (F) { # hist
            if (T) { # obs vs model with vs wout trend
                data <- list("oisst_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/sst/oisst_v2.1/mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_0066904-1036800_nloc_691150_intensity_max_eventmean_an_fldmean_", area, ".nc"),
                                               label="OISSTv2.1 with trend"),
                             "oisst_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/sst/oisst_v2.1/mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_0066904-1036800_nloc_691150_intensity_max_eventmean_an_fldmean_", area, ".nc"),
                                               label="OISSTv2.1 wout trend"),
                             "awicm1-recom_historical3_and_ssp585_2_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_intensity_max_eventmean_an_fldmean_", area, ".nc"),
                                               label="AWI-ESM-1-REcoM with trend"),
                             "awicm1-recom_historical3_and_ssp585_2_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_000001-126859_nloc_126859_intensity_max_eventmean_an_fldmean_", area, ".nc"),
                                               label="AWI-ESM-1-REcoM wout trend"))
                cols <- rep(mycols(2), e=2)
                ltys <- rep(1:2, t=2)
                plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_sst_", varname_out, "_eventmean_an_fldmean_", area, "_1982-2021_", paste(names(data), collapse="_vs_"), "_clim_1982-2021_pctile_90_minDuration_5")
            }
        } else if (T) { # hist and ssp
            if (F) { # obs vs model with vs wout trend
                if (F) { # eventmean_an; todo: wrong?!
                    data <- list("oisst_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/sst/oisst_v2.1/mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_0066904-1036800_nloc_691150_intensity_max_eventmean_an_fldmean_", area, ".nc"),
                                                   label="OISSTv2.1 with trend"),
                                 "oisst_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/sst/oisst_v2.1/mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_0066904-1036800_nloc_691150_intensity_max_eventmean_an_fldmean_", area, ".nc"),
                                                   label="OISSTv2.1 wout trend"),
                                 "awicm1-recom_historical3_and_ssp585_2_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_intensity_max_eventmean_an_fldmean_", area, ".nc"),
                                                   label="AWI-ESM-1-REcoM with trend"),
                                 "awicm1-recom_historical3_and_ssp585_2_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_000001-126859_nloc_126859_intensity_max_eventmean_an_fldmean_", area, ".nc"),
                                                   label="AWI-ESM-1-REcoM wout trend"))
                } else if (T) { # yearmean; todo: correct?!
                    data <- list("oisst_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/sst/oisst_v2.1/mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_0066904-1036800_nloc_691150_intensity_max_yearmean_fldmean_", area, ".nc"),
                                                   label="OISSTv2.1 with trend"),
                                 "oisst_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/sst/oisst_v2.1/mhw_sst_ts_19820101-20211231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_0066904-1036800_nloc_691150_intensity_max_yearmean_fldmean_", area, ".nc"),
                                                   label="OISSTv2.1 wout trend"),
                                 "awicm1-recom_historical3_and_ssp585_2_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-20211231_pctile_90_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_intensity_max_yearmean_fldmean_", area, ".nc"),
                                                   label="AWI-ESM-1-REcoM with trend"),
                                 "awicm1-recom_historical3_and_ssp585_2_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-20211231_pctile_90_minDuration_5_woutTrend_locinds_000001-126859_nloc_126859_intensity_max_yearmean_fldmean_", area, ".nc"),
                                                   label="AWI-ESM-1-REcoM wout trend"))
                }
                cols <- rep(mycols(2), e=2)
                ltys <- rep(1:2, t=2)
                #plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_sst_", varname_out, "_eventmean_an_fldmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_clim_1982-2021_pctile_90_minDuration_5")
                plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_sst_", varname_out, "_yearmean_fldmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_clim_1982-2021_pctile_90_minDuration_5")
            } else if (F) { # fixed baseline w/out trend, 15/30a run mean
                data <- list("fixed_with"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_fixed_baseline_withTrend_locinds_000001-126859_nloc_126859_intensity_max_yearmean_fldmean_", area, ".nc"),
                                               label="30-yr fixed baseline with trend"),
                             "fixed_wout"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-20111231_pctile_90_minDuration_5_fixed_baseline_woutTrend_locinds_000001-126859_nloc_126859_intensity_max_yearmean_fldmean_", area, ".nc"),
                                               label="30-yr fixed baseline without trend"),
                             "runmean_31a"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_intensity_max_yearmean_fldmean_", area, ".nc"),
                                                label="31-yr running mean"),
                             "runmean_15a"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_15a_withTrend_locinds_000001-126859_nloc_126859_intensity_max_yearmean_fldmean_", area, ".nc"),
                                                label="15-yr running mean"))
                cols <- mycols(4)
                plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_sst_", varname_out, "_yearmean_fldmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_pctile_90_minDuration_5")
            } else if (T) { # 31a run mean sic ranges
                data <- list("sic_ltc_15"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_intensity_max_yearmean_fldmean_", area, "_sic_ltc_0.15.nc"),
                                               label="SIC<15%"),
                             "sic_gec_15_ltc_50"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_intensity_max_yearmean_fldmean_", area, "_sic_gec_0.15_ltc_0.5.nc"),
                                                      label="15%≤SIC<50%"),
                             "sic_gec_50_ltc_85"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_intensity_max_yearmean_fldmean_", area, "_sic_gec_0.5_ltc_0.85.nc"),
                                                      label="50%≤SIC<85%"),
                             "sic_gec_85"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/tos/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mhw_tos_ts_19820101-21001231_clim_19820101-21001231_pctile_90_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_intensity_max_yearmean_fldmean_", area, "_sic_gec_0.85.nc"),
                                               label="SIC≥85%"))
                cols <- mycols(4)[c(1, 3, 4, 2)]
                plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mhw_sst_", varname_out, "_yearmean_fldmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_pctile_90_minDuration_5_runmean_31a_sic_ranges")
            }
        }
    } else if (T) { # bgc22
        varname_label <- eval(substitute(expression(paste("ODX max intensity [mmol m"^paste(-3), "]"))))
        if (F) {
            data <- list("awicm1-recom_historical3_and_ssp585_2"=list(
                         fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mcs_bgc22_ts_19820101-21001231_clim_19820101-20111231_pctile_10_minDuration_5_withTrend_locinds_000001-126859_nloc_126859_", area, "_intensity_max_yearmean_fldmean.nc"),
                         label="AWI-ESM-1-REcoM"))
            plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mcs_bgc22_", varname_out, "_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_clim_1982-2011_pctile_10_minDuration_5_withTrend.png")
        } else if (T) { # 31a run mean sic ranges
            data <- list("sic_ltc_15"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_intensity_max_yearmean_fldmean_", area, "_sic_ltc_0.15.nc"),
                                           label="SIC<15%"),
                         "sic_gec_15_ltc_50"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_intensity_max_yearmean_fldmean_", area, "_sic_gec_0.15_ltc_0.5.nc"),
                                                  label="15%≤SIC<50%"),
                         "sic_gec_50_ltc_85"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_intensity_max_yearmean_fldmean_", area, "_sic_gec_0.5_ltc_0.85.nc"),
                                                  label="50%≤SIC<85%"),
                         "sic_gec_85"=list(fin=paste0("/work/ba1103/a270073/post/heatwaveR/fldmean/bgc22/awi-esm-1-1-lr_kh800_historical3_and_ssp585_2/mcs_bgc22_0m_pctile_10_ts_19820101-21001231_clim_19820101-21001231_minDuration_5_runmean_31a_withTrend_locinds_000001-126859_nloc_126859_intensity_max_yearmean_fldmean_", area, "_sic_gec_0.85.nc"),
                                           label="SIC≥85%"))
            cols <- mycols(4)[c(1, 3, 4, 2)]
            plotname <- paste0(plotpath, "/fldmean/", varname_out, "/mcs_bgc22_0m_", varname_out, "_yearmean_fldmean_", area, "_1982-2100_", paste(names(data), collapse="_vs_"), "_pctile_10_minDuration_5_runmean_31a_sic_ranges")
        }
    }


} # which variable

###########################################################

# check
dir.create(dirname(plotname), recursive=T, showWarnings=F)
if (!dir.exists(dirname(plotname))) stop("could not create plot path ", dirname(plotname))

# read data
for (di in seq_along(data)) {
    message("*****************************************************\n",
            "data ", di, "/", length(data), ": ", names(data)[di], "\n",
            "open ", data[[di]]$fin, " ...")
    nc <- nc_open(data[[di]]$fin)
    data[[di]]$time <- cdo_showtimestamp(data[[di]]$fin)
    data[[di]]$data <- ncvar_get(nc, varname_nc)

    if (!is.null(data[[di]]$from)) {
        inds <- which(data[[di]]$time < data[[di]]$from)
        if (length(inds) > 0) {
            message("`data[[", di, "]]$from` = ", data[[di]]$from, " --> remove ", length(inds), 
                    " times from ", data[[di]]$time[inds[1]], " to ", data[[di]]$time[inds[length(inds)]], " ...")
            if (length(inds) == length(data[[di]]$time)) stop("this would remove all time points")
            data[[di]]$time <- data[[di]]$time[-inds]
            data[[di]]$data <- data[[di]]$data[-inds]
        }
    }
    
    if (!is.null(data[[di]]$to)) {
        inds <- which(data[[di]]$time > data[[di]]$to)
        if (length(inds) > 0) {
            message("`data[[", di, "]]$to` = ", data[[di]]$to, " --> remove ", length(inds), 
                    " times from ", data[[di]]$time[inds[1]], " to ", data[[di]]$time[inds[length(inds)]], " ...")
            if (length(inds) == length(data[[di]]$time)) stop("this would remove all time points")
            data[[di]]$time <- data[[di]]$time[-inds]
            data[[di]]$data <- data[[di]]$data[-inds]
        }
    }
} # for di

# plot ts
xlim <- range(lapply(data, "[", "time"))
xlimct <- as.POSIXct(xlim, origin="1970-1-1", tz="UTC")
if (T) {
    message("\nspecial: limit time")
    xlimlt <- as.POSIXlt(xlimct)
    xlimlt[1]$year <- xlimlt[1]$year + 15
    xlimlt[2]$year <- xlimlt[2]$year - 15
    xlimct <- as.POSIXct(xlimlt)
    xlim <- as.numeric(range(xlimct))

    for (di in seq_along(data)) {
        inds <- which(data[[di]]$time >= xlimct[1] & data[[di]]$time <= xlimct[2])
        if (length(inds) > 0) {
            data[[di]]$time <- data[[di]]$time[inds]
            data[[di]]$data <- data[[di]]$data[inds]
        }
    } # for di

}
xat <- pretty(xlimct, n=10)

ylim <- range(lapply(data, "[", "data"))
yat <- ylab <- pretty(ylim, n=8)

log <- "" # default: no logarithmic axis
if (F) { # logarithmic y-axis
    message("\nspecial: log y-axis")
    if (varname_out == "duration") {
        message("special logarithmic y-axis for duration ...")
        log <- "y" # logarithmic y-axis
        yat <- c(0, 5, 10, 15, 20, 25, 30, 60, 90, c(0.5, 1:3, 5, 10, 15, 20)*365) # days
        ylab <- ifelse(yat < 365/2, paste0(yat, "d"), paste0(yat/365, "y")) 
        varname_label <- sub(" \\[days\\]", "", varname_label)
    } else if (varname_out == "exposure") {
        message("special logarithmic y-axis for duration ...")
        log <- "y" # logarithmic y-axis
        yat <- c(0, 5, 10, 15, 20, 30, 40, 60, 80, 100, 125, 150, 200, 250, 300, 365) # days
        ylab <- yat
    } else if (varname_out == "intensity_max") {
        message("special logarithmic y-axis for intensity_max ...")
        log <- "y" # logarithmic y-axis
        yat <- c(seq(0, 2, b=0.2), seq(2.5, 10, b=0.5))
        ylab <- yat
    }
} # if logarithmic y-axis

if (!exists("cols")) cols <- mycols(length(data))
if (!exists("ltys")) ltys <- rep(1, t=length(data))
pp <- plot_sizes()
if (plot_type == "x11") {
    # nothing to do
} else if (plot_type == "png") {
    plotname <- paste0(plotname, ".png")
    png(plotname, width=pp$png_width_px, height=pp$png_height_px, res=pp$png_ppi, family="Droid Sans")
} else if (plot_type == "pdf") {
    plotname <- paste0(plotname, ".pdf")
    pdf(plotname, width=pp$pdf_width_in, height=pp$pdf_height_in, family="Droid Sans")
} else {
    stop("plot_type ", plot_type, " not implemented")
}
message("save ", plotname, " ...")

plot(data[[1]]$time, data[[1]]$data, t="n",
     xlim=xlim, ylim=ylim, log=log, 
     xaxt="n", yaxt="n",
     xlab="", ylab=varname_label)
axis.POSIXct(1, at=xat, format="%Y")
mtext("year", side=1, line=2)
axis(2, at=yat, labels=ylab, las=2)
for (di in seq_along(data)) {
    lines(data[[di]]$time, data[[di]]$data, col=cols[di], lty=ltys[di])
}
legend("topleft", sapply(data, "[[", "label"), col=cols, lty=ltys,
       bty="n", x.intersp=0.2)
dev.off()
if (plot_type == "pdf") grDevices::embedFonts(plotname, outfile=plotname)

