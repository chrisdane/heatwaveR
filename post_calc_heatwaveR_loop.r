# r

rm(list=ls()); graphics.off()

submit_via_nohup <- F
submit_via_sbatch <- T # uses account resources
dry <- F # do not submit jobs

myrunscript_fname <- "~/scripts/r/heatwaveR/post_calc_heatwaveR.r"

#start <- 1; end <- 10
#start <- 1; end <- 20
#start <- 1; end <- 30
#start <- 1; end <- 40

#start <- 1; end <- 82
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_withTrend_duration"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_withTrend_nevents"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_withTrend_intensity_mean"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_withTrend_intensity_var"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_withTrend_intensity_max"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_withTrend_cumulative_intensity"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_woutTrend_duration"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_woutTrend_nevents"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_woutTrend_intensity_mean"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_woutTrend_intensity_var"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_woutTrend_intensity_max"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_woutTrend_cumulative_intensity"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_0_withTrend_duration"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_0_withTrend_nevents"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_0_withTrend_intensity_mean"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_0_withTrend_intensity_var"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_0_withTrend_intensity_max"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_0_withTrend_cumulative_intensity"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_0_woutTrend_duration"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_0_woutTrend_nevents"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_0_woutTrend_intensity_mean"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_0_woutTrend_intensity_var"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_0_woutTrend_intensity_max"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_0_woutTrend_cumulative_intensity"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_ce_tos_bgc22_0_withTrend_duration"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_ce_tos_bgc22_0_withTrend_nevents"

start <- 1; end <- 160
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_withTrend_runmean_15_duration"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_withTrend_runmean_15_nevents"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_withTrend_runmean_15_intensity_mean"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_withTrend_runmean_15_intensity_var"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_withTrend_runmean_15_intensity_max"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_withTrend_runmean_15_cumulative_intensity"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_withTrend_runmean_31_duration"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_withTrend_runmean_31_nevents"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_withTrend_runmean_31_intensity_mean"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_withTrend_runmean_31_intensity_var"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_withTrend_runmean_31_intensity_max"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_withTrend_runmean_31_cumulative_intensity"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_thetao_200_withTrend_duration"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_thetao_200_withTrend_nevents"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_thetao_200_withTrend_intensity_mean"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_thetao_200_withTrend_intensity_var"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_thetao_200_withTrend_intensity_max"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_thetao_200_withTrend_cumulative_intensity"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_thetao_200_woutTrend_duration"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_thetao_200_woutTrend_nevents"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_thetao_200_woutTrend_intensity_mean"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_thetao_200_woutTrend_intensity_var"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_thetao_200_woutTrend_intensity_max"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_thetao_200_woutTrend_cumulative_intensity"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_thetao_200_withTrend_runmean_15_duration"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_thetao_200_withTrend_runmean_15_nevents"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_thetao_200_withTrend_runmean_15_intensity_mean"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_thetao_200_withTrend_runmean_15_intensity_var"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_thetao_200_withTrend_runmean_15_intensity_max"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_thetao_200_withTrend_runmean_15_cumulative_intensity"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_thetao_200_withTrend_runmean_31_duration"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_thetao_200_withTrend_runmean_31_nevents"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_thetao_200_withTrend_runmean_31_intensity_mean"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_thetao_200_withTrend_runmean_31_intensity_var"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_thetao_200_withTrend_runmean_31_intensity_max"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_thetao_200_withTrend_runmean_31_cumulative_intensity"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_0_withTrend_runmean_15_duration"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_0_withTrend_runmean_15_nevents"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_0_withTrend_runmean_15_intensity_mean"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_0_withTrend_runmean_15_intensity_var"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_0_withTrend_runmean_15_intensity_max"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_0_withTrend_runmean_15_cumulative_intensity"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_0_withTrend_runmean_31_duration"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_0_withTrend_runmean_31_nevents"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_0_withTrend_runmean_31_intensity_mean"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_0_withTrend_runmean_31_intensity_var"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_0_withTrend_runmean_31_intensity_max"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_0_withTrend_runmean_31_cumulative_intensity"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_200_withTrend_duration"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_200_withTrend_nevents"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_200_withTrend_intensity_mean"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_200_withTrend_intensity_var"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_200_withTrend_intensity_max"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_200_withTrend_cumulative_intensity"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_200_woutTrend_duration"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_200_woutTrend_nevents"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_200_woutTrend_intensity_mean"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_200_woutTrend_intensity_var"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_200_woutTrend_intensity_max"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_200_woutTrend_cumulative_intensity"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_200_withTrend_runmean_15_duration"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_200_withTrend_runmean_15_nevents"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_200_withTrend_runmean_15_intensity_mean"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_200_withTrend_runmean_15_intensity_var"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_200_withTrend_runmean_15_intensity_var"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_200_withTrend_runmean_15_cumulative_intensity"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_200_withTrend_runmean_31_duration"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_200_withTrend_runmean_31_nevents"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_200_withTrend_runmean_31_intensity_mean"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_200_withTrend_runmean_31_intensity_var"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_200_withTrend_runmean_31_intensity_max"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_200_withTrend_runmean_31_cumulative_intensity"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_bgc22_event"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_ce_tos_bgc22_0_withTrend_runmean_31_duration"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_ce_tos_bgc22_0_withTrend_runmean_31_nevents"
#prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_ce_tos_bgc22_0_withTrend_runmean_15_duration"
prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_ce_tos_bgc22_0_withTrend_runmean_15_nevents"

replace_string <- list(string="    files <- files[", between_lines=c(135, 137))
njobs_wanted <- end # = nchunks
njobs_wanted <- 1 # njobs=1 for all files for `calc_timmean` and `calc_ts`

if (!exists("replace_by")) {
    ntot <- end - start + 1
    if (njobs_wanted > 1) {
        replace_by <- replicate(floor(seq(start, end, b=ntot/njobs_wanted)), n=2)
        replace_by[,2] <- c(replace_by[2:njobs_wanted,2]-1, end)
    } else {
        replace_by <- matrix(c(start, end), ncol=2)
    }
    df <- cbind(from=replace_by[,1], to=replace_by[,2], len=replace_by[,2]-replace_by[,1]+1) # check
    replace_by <- apply(replace_by, 1, paste, collapse=":")
}

if (T) replace_by <- paste0(replace_by, "]")

###################################################################

# check
myrunscript_fname <- normalizePath(myrunscript_fname, mustWork=T)
message("read myrunscript_fname = ", myrunscript_fname, " ...")
myrunscript_basename <- tools::file_path_sans_ext(basename(myrunscript_fname))
myrunscript <- readLines(myrunscript_fname)

logpath <- paste0(dirname(myrunscript_fname), "/", myrunscript_basename, "_loop_logs")
dir.create(logpath, recursive=T, showWarnings=F)
if (file.access(logpath, 2) == -1) stop("no write permission to `logpath` = \"", logpath, "\"")

njobs <- length(replace_by)
if (njobs == 0 || !is.null(dim(replace_by))) {
    stop("njobs = ", njobs, ". check your 'replace_by':", replace_by) 
}

# find line to replace years between wanted lines
replace_inds <- replace_string$between_lines[1]:replace_string$between_lines[2]
replace_ind <- which(grepl(replace_string$string, myrunscript[replace_inds], fixed=T)) # fixed for special symbols e.g. [ ]
if (length(replace_ind) != 1) {
    stop("found ", length(replace_ind), " inds of `replace_string` = \"", replace_string$string, 
         "\" between lines ", paste(replace_string$between_lines, collapse="-"), 
         " in original runscript ", myrunscript_fname, ". need exactly 1 match")
}

message("submit ", njobs, " jobs ...")
for (jobi in seq_len(njobs)) {

    message("*** job ", jobi, "/", njobs, " ***")
    
    # save temporary runscript as file
    #id <- format(as.numeric(Sys.time())*1000, digits=10) # some unique number for log file name
    suffix <- paste0(gsub("[[:punct:]]", "_", replace_by[jobi]), collapse="_")
    if (grepl("[[:punct:]]", substr(suffix, 1, 1))) { # remove leading special character
        suffix <- substr(suffix, 2, nchar(suffix))
    }
    if (grepl("[[:punct:]]", substr(suffix, nchar(suffix), nchar(suffix)))) { # remove trailing special character
        suffix <- substr(suffix, 1, nchar(suffix)-1)
    }
    myrunscripttmp_fname <- paste0(logpath, "/", myrunscript_basename, 
                                   "_", prefix, 
                                   "_job_", sprintf(paste0("%0", nchar(njobs), "i"), jobi), "_of_", njobs, 
                                   "_", suffix, "_script.r")
    if (file.exists(myrunscripttmp_fname)) stop("myrunscripttmp_fname = ", myrunscripttmp_fname, " already exists")
    
    # replace years
    myrunscripttmp <- myrunscript
    myrunscripttmp[replace_inds][replace_ind] <- trimws(paste0(replace_string$string, replace_by[jobi]))
    message("replaced \"", 
            myrunscript[replace_inds][replace_ind], "\" with \"", 
            myrunscripttmp[replace_inds][replace_ind], "\"")

    # write temporary runscript 
    write(myrunscripttmp, myrunscripttmp_fname)

    # create jobs command
    if (submit_via_nohup) {
        logfile <- paste0(tools::file_path_sans_ext(myrunscripttmp_fname), ".log")
        cmd <- paste0("rnohup ", myrunscripttmp_fname, " ", logfile)
    } else if (submit_via_sbatch) {
        slurmrunscript_fname <- paste0(logpath, "/", myrunscript_basename, 
                                       "_", prefix, 
                                       "_job_", sprintf(paste0("%0", nchar(njobs), "i"), jobi), "_of_", njobs, 
                                       "_", suffix, "_sbatch.run")
        if (file.exists(slurmrunscript_fname)) stop("slurm_runscriptfname = ", slurmrunscript_fname, " already exists")

        # mistral example scripts: https://www.dkrz.de/up/systems/mistral/running-jobs/example-batch-scripts
        # mistral partition limits: https://www.dkrz.de/up/systems/mistral/running-jobs/partitions-and-limits 
        # ollie example scripts: https://swrepo1.awi.de/plugins/mediawiki/wiki/hpc/index.php/Slurm_Example_Scripts
        # ollie partition limits: https://swrepo1.awi.de/plugins/mediawiki/wiki/hpc/index.php/SLURM#Partitions
        cmd <- c("#!/bin/bash",
                 paste0("#SBATCH --job-name=", tools::file_path_sans_ext(basename(slurmrunscript_fname)), "      # Specify job name"),
                 "#SBATCH --partition=shared     # Specify partition name",
                 #"#SBATCH --partition=prepost     # Specify partition name",
                 #"#SBATCH --ntasks=1             # Specify max. number of tasks to be invoked",
                 "#SBATCH --time=04:00:00        # Set a limit on the total run time",
                 #"#SBATCH --time=08:00:00        # Set a limit on the total run time",
                 #"#SBATCH --time=12:00:00        # Set a limit on the total run time", # long for `calc_event_inds`
                 #"#SBATCH --time=24:00:00        # Set a limit on the total run time", # long for `calc_event_inds`
                 #"#SBATCH --mail-type=FAIL       # Notify user by email in case of job failure",
                 #"#SBATCH --account=ab0246       # Charge resources on this project account",
                 #"#SBATCH --account=ba0989       # Charge resources on this project account",
                 #"#SBATCH --account=ab1095       # Charge resources on this project account",
                 "#SBATCH --account=ba1103       # Charge resources on this project account",
                 # memory:
                 #"#SBATCH --mem=0                    # 0 = use all mem",
                 #"#SBATCH --mem=20G                    # 0 = use all mem",
                 #"#SBATCH --mem=30G                    # 0 = use all mem",  # for `calc_ts`
                 "#SBATCH --mem=40G                    # 0 = use all mem",  # for `calc_ts`
                 # logs and errors in different files:
                 #paste0("#SBATCH --output=", tools::file_path_sans_ext(myrunscripttmp_fname), "_o%j.log    # File name for standard output"),
                 #paste0("#SBATCH --error=", tools::file_path_sans_ext(myrunscripttmp_fname), "_e%j.log     # File name for standard error output"),
                 # logs and errors in same file:
                 paste0("#SBATCH --output=", tools::file_path_sans_ext(myrunscripttmp_fname), "_%j.log    # File name for standard output"),
                 paste0("#SBATCH --error=", tools::file_path_sans_ext(myrunscripttmp_fname), "_%j.log     # File name for standard error output"),
                 "",
                 #"module load r",
                 "module load python3/unstable",
                 paste0("Rscript ", myrunscripttmp_fname))
        write(cmd, slurmrunscript_fname)
        cmd <- paste0("sbatch ", slurmrunscript_fname)
    } # which job submission method
   
    message("run `", cmd, "` ...")

    # submit job
    if (!dry) {
        system(cmd)
    } else {
        message("`dry` = T --> do not run this command")
    }

} # for jobi njobs

