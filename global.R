## Global.R

## Help function to recode NA values
check_na <- function(x) {
  ifelse(is.na(x), "", x)
}
## Help function to check null lists
check_null <- function(x) {
  ifelse(is.null(x[[1]]), "Not Available from clinicaltrials.gov", x)
}
## replace " to '
check_text <- function(x) {
  stringr::str_replace_all(x, "\"", "'")
}

## clean ääkköset nimestä
namelink <- function(x){
  x <- tolower(x)
  x <- stringr::str_replace_all(x, "ä", "a")
  x <- stringr::str_replace_all(x, "ö", "o")
  x <- stringr::str_replace_all(x, "å", "o")
  x <- stringr::str_replace_all(x, " ", "-")
  return(x)
}


## jos linkki tyhjä, näytä tyhjää
## listaa kaikki linkit