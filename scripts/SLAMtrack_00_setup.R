## LOAD LIBRARIES ----

library(tidyverse)
library(here)


## SET PATHS ----

# dir_data and dir_meta set in .Rprofile
dir_scripts <- here("scripts")


## SET-UP SCRIPTS ----

here(dir_scripts, "SLAMtrack_x0_parameters_default.R") %>% source()
here(dir_data, "input", "SLAMtrack_x0_parameters.R") %>% source()

here(dir_scripts, "SLAMtrack_01_plotting_themes.R") %>% source()
here(dir_scripts, "SLAMtrack_02_miscellaneous_functions.R") %>% source()
here(dir_scripts, "SLAMtrack_20_plotting_functions.R") %>% source()