render_SLAMtrack_single <- function(rmd, fname, exp_type, dir_data) {
  rmarkdown::render(rmd,
                    output_dir = paste0(dir_data, "output/"),
                    output_file = paste0(fname, "_", tools::file_path_sans_ext(rmd)),
                    params = list(
                      fname = fname,
                      dir_data = dir_data,
                      exp_type = exp_type
                    ))
  
}

render_SLAMtrack <- function(fname, exp_type) {
  
  # dir_data defined in .Rprofie
  dir_data <- paste0(dir_data_root, fname, "/")
  
  if (exp_type == "slamdunk") {
  
    render_SLAMtrack_single("1_QC.Rmd", fname, exp_type, dir_data)
    render_SLAMtrack_single("2_mutations.Rmd", fname, exp_type, dir_data)
    render_SLAMtrack_single("3_TC.Rmd", fname, exp_type, dir_data)
    render_SLAMtrack_single("4_labelled_genes.Rmd", fname, exp_type, dir_data)
    render_SLAMtrack_single("5_miniMAP.Rmd", fname, exp_type, dir_data)
    
  }
  
  if (exp_type == "smallslam") {
    
    render_SLAMtrack_single("1_QC.Rmd", fname, exp_type, dir_data)
    render_SLAMtrack_single("3_TC.Rmd", fname, exp_type, dir_data)
    render_SLAMtrack_single("4_labelled_genes.Rmd", fname, exp_type, dir_data)

  }
  
}


pre_render_SLAMtrack <- function(fname, exp_type) {
  
  # dir_data_root defined in .Rprofie
  dir_data <<- paste0(dir_data_root, fname, "/") # <<- to assign as global variable
  
  source("scripts/SLAMtrack_00_setup.R")
  if (exp_type == "slamdunk") source("scripts/SLAMtrack_10_import.R")
  if (exp_type == "smallslam") source("scripts/SLAMtrack_10a_import_small.R")
  
}


render_all_SLAMtrack <- function(pre_render = FALSE) {
  
  dir_list <- list.dirs(dir_data_root, full.names = FALSE, recursive = FALSE)
  dir_list_slamdunk <- dir_list[grep("slamdunk", dir_list)]
  dir_list_smallslam <- dir_list[grep("smallslam", dir_list)]
  
  if (pre_render == TRUE) {
    
    for (i in 1:length(dir_list_slamdunk)) pre_render_SLAMtrack(dir_list_slamdunk[i], "slamdunk")
    for (i in 1:length(dir_list_smallslam)) pre_render_SLAMtrack(dir_list_smallslam[i], "smallslam")
    
  }
  
  for (i in 1:length(dir_list_slamdunk)) render_SLAMtrack(dir_list_slamdunk[i], "slamdunk")
  for (i in 1:length(dir_list_smallslam)) render_SLAMtrack(dir_list_smallslam[i], "smallslam")
  
}