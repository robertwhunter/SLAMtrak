# OPTIONAL ARGUMENTS TO DEFINE GROUP ORDER

# groups_recode <- function(fct) {
#   fct %>%
#   as.factor() %>%
#     fct_relevel("crepos", "creneg", "WT", "4TUneg") %>%
#     fct_recode(
#       `Cre +ve, 4TU +ve` = "crepos",
#       `Cre -ve control` = "creneg",
#       `Cre -ve, flox -ve control` = "WT",
#       `4TU -ve control` = "4TUneg"
#     )
# }


groups_recode <- function(fct) {
  fct %>%
  as.factor() %>%
    fct_relevel("crepos", "creneg", "WT", "4TUneg") %>%
    fct_recode(
      `RNA labelling group` = "crepos",
      `control group (Cre -ve)` = "creneg",
      `control group (UPRT -ve)` = "WT",
      `control group (4TU -ve)` = "4TUneg"
    )
}

df_meta_short$group %>% groups_recode() -> df_meta_short$group
df_tcounts$group %>% groups_recode() -> df_tcounts$group

if (exp_type == "slamdunk") { df_QC$group %>% groups_recode() -> df_QC$group }
