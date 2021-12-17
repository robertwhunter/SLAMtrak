library(here)

render_SLAMtrack_single <- function(rmd, fname, exp_type, dir_data) {
  rmarkdown::render(rmd,
                    output_dir = paste0(dir_data, "output/"),
                    output_file = fname,
                    params = list(
                      fname = fname,
                      exp_type = exp_type
                    ))
  
}

render_SLAMtrack <- function(fname, exp_type) {
  
  # dir_data_root defined in .Rprofle
  dir_data <- here(dir_data_root, fname)
  
  render_SLAMtrack_single("1_QC.Rmd", fname, exp_type, dir_data)
  render_SLAMtrack_single("3_TC.Rmd", fname, exp_type, dir_data)
  
}