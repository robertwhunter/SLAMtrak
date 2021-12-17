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
  
  render_SLAMtrack_single("1_QC.Rmd", fname, exp_type, dir_data)
  render_SLAMtrack_single("3_TC.Rmd", fname, exp_type, dir_data)
  
}

pre_render_SLAMtrack <- function(fname, exp_type) {
  
  # dir_data_root defined in .Rprofie
  dir_data <- paste0(dir_data_root, fname, "/")
  
  if (exp_type == "slamdunk") source("scripts/SLAMtrack_10_import.R")
  if (exp_type == "smallslam") source("scripts/SLAMtrack_10a_import_small.R")
  
}
