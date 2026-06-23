# r

rm(list=ls()); graphics.off()

submit_via_nohup <- F
submit_via_sbatch <- T # uses account resources
dry <- F # do not submit jobs

myrunscript_fname <- "~/scripts/r/heatwaveR/compound_heatwaveR.r"

if (T) {
    start <- 1; end <- 82 # nchunks of calc_heatwaveR.r
    #start <- 1; end <- 160
    prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_bgc_0_fixed_with"
    #prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_bgc_0_fixed_wout"
    #prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_bgc_0_31yr_with"
    #prefix <- "awi-esm-1-1-lr_kh800_historical3_and_ssp585_2_tos_bgc_0_15yr_with"
    replace_string <- list(string="    files <- lapply(files, \"[\", ", between_lines=c(86, 88))
    #njobs_wanted <- 10
    njobs_wanted <- 40
    #njobs_wanted <- end
}

if (!exists("replace_by")) {
    ntot <- end - start + 1
    replace_by <- replicate(floor(seq(start, end, b=ntot/njobs_wanted)), n=2)
    replace_by[,2] <- c(replace_by[2:njobs_wanted,2]-1, end)
    df <- cbind(from=replace_by[,1], to=replace_by[,2], len=replace_by[,2]-replace_by[,1]+1) # check
    replace_by <- apply(replace_by, 1, paste, collapse=":")
    replace_by <- paste0(replace_by, ")")
}

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
    suffix <- paste(gsub("[[:punct:]]", "_", replace_by[jobi]), collapse="_")
    if (grepl("[[:punct:]]", substr(suffix, 1, 1))) { # remove leading special character
        suffix <- substr(suffix, 2, nchar(suffix))
    }
    if (grepl("[[:punct:]]", substr(suffix, nchar(suffix), nchar(suffix)))) { # remove trailing special character
        suffix <- substr(suffix, 1, nchar(suffix)-1)
    }
    # make suffix of equal length for all runscript/log files
    suffix_char <- strsplit(suffix, "_")[[1]] # e.g. "1"    "6342"
    suffix_char <- sprintf(paste0("%0", nchar(end), "i"), as.integer(suffix_char)) # e.g. "000001" "006342"
    suffix_char <- paste(suffix_char, collapse="_") # e.g. "000001_006342"
    myrunscripttmp_fname <- paste0(logpath, "/", myrunscript_basename, 
                                   "_", prefix, 
                                   "_job_", sprintf(paste0("%0", nchar(njobs), "i"), jobi), "_of_", njobs, 
                                   "_", suffix_char, "_script.r")
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
                                       "_", suffix_char, "_sbatch.run")
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
                 #"#SBATCH --time=01:00:00        # Set a limit on the total run time",
                 #"#SBATCH --time=04:00:00        # Set a limit on the total run time",
                 "#SBATCH --time=08:00:00        # Set a limit on the total run time",
                 #"#SBATCH --time=14:00:00        # Set a limit on the total run time",
                 #"#SBATCH --mail-type=FAIL       # Notify user by email in case of job failure",
                 #"#SBATCH --account=ab1095       # Charge resources on this project account",
                 #"#SBATCH --account=ab0246       # Charge resources on this project account",
                 #"#SBATCH --account=ba0989       # Charge resources on this project account",
                 "#SBATCH --account=ba1103       # Charge resources on this project account",
                 # memory:
                 #"#SBATCH --mem=0                    # 0 = use all mem",
                 #"#SBATCH --mem=15000M                    # 0 = use all mem",
                 "#SBATCH --mem=20000M                    # 0 = use all mem",
                 # logs and errors in different files:
                 #paste0("#SBATCH --output=", tools::file_path_sans_ext(myrunscripttmp_fname), "_o%j.log    # File name for standard output"),
                 #paste0("#SBATCH --error=", tools::file_path_sans_ext(myrunscripttmp_fname), "_e%j.log     # File name for standard error output"),
                 # logs and errors in same file:
                 paste0("#SBATCH --output=", tools::file_path_sans_ext(myrunscripttmp_fname), "_%j.log    # File name for standard output"),
                 paste0("#SBATCH --error=", tools::file_path_sans_ext(myrunscripttmp_fname), "_%j.log     # File name for standard error output"),
                 "",
                 #"module load r",
                 "module load python3/unstable", # why did i do this?
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

