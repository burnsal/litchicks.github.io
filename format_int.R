### format interest form responses ###

# load data
pref_raw <- readr::read_csv("bookclub_pref_raw.csv")

## genre preferences

# create and lengthen df
read_df <- pref_raw |>
  dplyr::select(-Trigger) |>
  tidyr::separate_longer_delim(Genre, delim = ", ")
# subgenre as separate column
read_df <- read_df |>
  tidyr::separate_wider_delim(Genre, " - ", names = c("Genre", "Subgenre"),
                              too_few = "align_start")
# tidy missing values
read_df <- read_df |>
  dplyr::mutate(Subgenre = dplyr::if_else(is.na(Subgenre), Genre, Subgenre)) |>
  dplyr::mutate(dplyr::across(Genre:Subgenre, ~stringr::str_to_title(.)))

# fix sloppy nonfiction formats
nonfics <- c("Arts", "Culture", "History", "Philosophy", "Poetry",
             "Psychology", "Science", "Spirituality")
read_df <- read_df |>
  dplyr::mutate(Genre = dplyr::if_else(Subgenre %in% nonfics,
                                       "Nonfiction", Genre))

# fix sloppy fiction formats
read_df <- read_df |>
  dplyr::mutate(dplyr::across(Genre:Subgenre, ~dplyr::if_else(stringr::str_starts(Genre, "Sci"),
                                                              "Science Fiction", .)))
read_df <- read_df |>
  dplyr::mutate(Subgenre = dplyr::if_else((Genre == "Romance" & Subgenre != "Romance"),
                                          paste0("Romance - ", Subgenre), Subgenre)) |>
  tidyr::separate_wider_delim(Subgenre, " - ", names = c("Subgenre", "Subsubgenre"),
                              too_few = "align_start", too_many = "drop")
subgens <- c("Fantasy", "Science Fiction", "Romance")
read_df <- read_df |>
  dplyr::mutate(Genre = dplyr::if_else(Subgenre %in% subgens,
                                       "Fiction", Genre))

# clean up nonstandard entries
read_df <- read_df |>
  dplyr::distinct() |>
  dplyr::filter(Genre != "Etc") |>
  dplyr::filter(stringr::str_detect(Genre, "Want To Read", negate=T))

save(read_df, file = "prefs.RData")

# -- END

## Triggers or Vetos

# create and lengthen df
noread_df <- pref_raw |>
  dplyr::select(-Genre) |>
  tidyr::separate_longer_delim(Trigger, delim = ", ")



save(read_df, noread_df, file = "docs/prefs.RData")
