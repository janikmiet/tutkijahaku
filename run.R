# Reseacher database ----
library(tidyverse)
source("global.R")

## Settings ----
create_subpages = FALSE
clean_folders <- TRUE # This cleans ./temp and ./output folders before rendering files
theme <- "cerulean" # choose one ("default", "cerulean", "journal", "flatly", "darkly", "readable", "spacelab", "united", "cosmo", "lumen", "paper", "sandstone", "simplex", "yeti")

## Load dataset ----
if(TRUE){
  
  ## Read the latest files
  df1 <- readxl::read_xlsx("data/Tutkijalista_webropol päivitykset_koko_Suomi v2.xlsx", sheet = "Helsinki") %>%
    dplyr::select(`Last name`, `First name`, Organisation, Faculty, `Link 1 (Research group website)`, `Link 2 (Research portal)`, `Link 2 (Research portal)`, `Link 3 (Clinical researcher website)`, `Link 4 (Other website)`, ORCID, `Key words`, `Lupa julkaista vastaajalta (Yes or no)`)
  df2 <- readxl::read_xlsx("data/Tutkijalista_webropol päivitykset_koko_Suomi v2.xlsx", sheet = "Jyväskylä") %>%
    dplyr::select(`Last name`, `First name`, Organisation, Faculty, `Link 1 (Research group website)`, `Link 2 (Research portal)`, `Link 2 (Research portal)`, `Link 3 (Clinical researcher website)`, `Link 4 (Other website)`, ORCID, `Key words`,`Lupa julkaista vastaajalta (Yes or no)`)
  df3 <- readxl::read_xlsx("data/Tutkijalista_webropol päivitykset_koko_Suomi v2.xlsx", sheet = "Kuopio") %>%
    dplyr::select(`Last name`, `First name`, Organisation, Faculty, `Link 1 (Research group website)`, `Link 2 (Research portal)`, `Link 2 (Research portal)`, `Link 3 (Clinical researcher website)`, `Link 4 (Other website)`, ORCID, `Key words`,`Lupa julkaista vastaajalta (Yes or no)`)
  df4 <- readxl::read_xlsx("data/Tutkijalista_webropol päivitykset_koko_Suomi v2.xlsx", sheet = "Oulu") %>%
    dplyr::select(`Last name`, `First name`, Organisation, Faculty, `Link 1 (Research group website)`, `Link 2 (Research portal)`, `Link 2 (Research portal)`, `Link 3 (Clinical researcher website)`, `Link 4 (Other website)`, ORCID, `Key words`,`Lupa julkaista vastaajalta (Yes or no)`)
  df5 <- readxl::read_xlsx("data/Tutkijalista_webropol päivitykset_koko_Suomi v2.xlsx", sheet = "Tampere") %>%
    dplyr::select(`Last name`, `First name`, Organisation, Faculty, `Link 1 (Research group website)`, `Link 2 (Research portal)`, `Link 2 (Research portal)`, `Link 3 (Clinical researcher website)`, `Link 4 (Other website)`, ORCID, `Key words`,`Lupa julkaista vastaajalta (Yes or no)`)
  df6 <- readxl::read_xlsx("data/Tutkijalista_webropol päivitykset_koko_Suomi v2.xlsx", sheet = "Turku") %>%
    dplyr::select(`Last name`, `First name`, Organisation, Faculty, `Link 1 (Research group website)`, `Link 2 (Research portal)`, `Link 2 (Research portal)`, `Link 3 (Clinical researcher website)`, `Link 4 (Other website)`, ORCID, `Key words`,`Lupa julkaista vastaajalta (Yes or no)`)
  df7 <- readxl::read_xlsx("data/Tutkijalista_webropol päivitykset_koko_Suomi v2.xlsx", sheet = "Other") %>%
    dplyr::select(`Last name`, `First name`, Organisation, Faculty, `Link 1 (Research group website)`, `Link 2 (Research portal)`, `Link 2 (Research portal)`, `Link 3 (Clinical researcher website)`, `Link 4 (Other website)`, ORCID, `Key words`,`Lupa julkaista vastaajalta (Yes or no)`)
  df <- rbind(df1,df2,df3,df4,df5,df6,df7)
  
  ## Create URL link
  filenames <- gsub(pattern = " ", 
                   replacement = "", 
                   x = paste0("./temp/tutkijat/", df$`Last name`, "-", df$`First name`))
  # df$url <- paste0("tutkijat/", filenames, ".html")
  df$url <- ifelse(
    is.na(df$`Link 1 (Research group website)`),
    ifelse(
      is.na(df$`Link 2 (Research portal)`),
      ifelse(
        is.na(df$`Link 3 (Clinical researcher website)`),
        ifelse(is.na(df$`Link 4 (Other website)`),
               df$ORCID,
               df$`Link 4 (Other website)`),
        df$`Link 3 (Clinical researcher website)`),
      df$`Link 2 (Research portal)`),
    df$`Link 1 (Research group website)`
  )
  # df$Tiedot <- paste0("<a href='",df$url,"'>Tiedot</a>") 
  df$Linkki <- ifelse(is.na(df$url),
                      NA,
                      paste0("<a href='",df$url,"'>Link</a>") )
  
}

## Clean directories -----
if(!dir.exists("temp/")) dir.create("temp/")
if(!dir.exists("temp/tutkijat")) dir.create("temp/tutkijat")
if(!dir.exists("output/")) dir.create("output/")
if(!dir.exists("output/tutkijat")) dir.create("output/tutkijat")
## Remove all files from ./temp
if(clean_folders){
  fils <- list.files("temp/", full.names = T, recursive = T)
  for (fil in fils) {
    file.remove(fil)
  }
}
## Remove all files from ./output
if(clean_folders){
  fils <- list.files("output/", full.names = T, recursive = T)
  for (fil in fils) {
    file.remove(fil)
  }
}


## Create index-page ----
if(TRUE){
  index <- readr::read_file("index.Rmd") # read template
  index <- stringr::str_replace_all(string = index, 
                                    pattern = "xxx-theme-xxx",
                                    replacement = theme)
  system("cp styles/mystyle.css temp/tutkijat/")
  system("cp styles/mystyle.css temp/")
  system("cp img/ORCID-icon-small.png temp/tutkijat/")
  system("cp styles/theme-neuro.css temp/")
  writeLines(index, "temp/index.Rmd")
  pages <- list.files("temp/", full.names = T, pattern = "Rmd")
  for(page in pages){
    rmarkdown::render(page, output_dir = "output/")
  }
}

## Create subpages ----
if(create_subpages){
  # This creates rmd-pages to ./temp/ 
  for (i in 1:nrow(df)) {
    d <- df[i,]
    template <- readr::read_file("research_template.Rmd") # read template
    template <- stringr::str_replace_all(string = template, 
                                         pattern = "xxx-theme-xxx",
                                         replacement = theme)
    # Description
    template <- stringr::str_replace_all(string = template, 
                                         pattern = "xxx-nimi-xxx",
                                         replacement = paste(d$`First name`, d$`Last name`))
    template <- stringr::str_replace_all(string = template,
                                         pattern = "xxx-tittelit-xxx",
                                         replacement = check_na(d$`Muut tittelit`))
    template <- stringr::str_replace_all(string = template,
                                         pattern = "xxx-email-xxx",
                                         replacement = check_na(d$Email))
    template <- stringr::str_replace_all(string = template,
                                         pattern = "xxx-organisation-xxx",
                                         replacement = check_na(d$Organisation))
    template <- stringr::str_replace_all(string = template,
                                         pattern = "xxx-faculty-xxx",
                                         replacement = check_na(d$Faculty))
    if(!is.na(d$ORCID) ){
      template <- stringr::str_replace_all(string = template,
                                           pattern = "xxx-orcid-xxx",
                                           replacement = paste0("![](ORCID-icon-small.png) [", d$ORCID, "](", d$ORCID,")", " </br>"))
    }else{
      template <- stringr::str_replace_all(string = template,
                                           pattern = "xxx-orcid-xxx",
                                           replacement = "")
    }
    if(!is.na(d$`Description LUONNOS`) ){
      template <- stringr::str_replace_all(string = template,
                                           pattern = "xxx-description-xxx",
                                           replacement = d$`Description LUONNOS`)
    }else{
      template <- stringr::str_replace_all(string = template,
                                           pattern = "xxx-description-xxx",
                                           replacement = "")
    }
    template <- stringr::str_replace_all(string = template,
                                         pattern = "xxx-keywords-xxx",
                                         replacement = check_na(d$`Key words`))
    ## Linkit
    # template <- stringr::str_replace_all(string = template,
    #                                      pattern = "xxx-link-xxx",
    #                                      replacement = d$Link)
    # template <- stringr::str_replace_all(string = template,
    #                                      pattern = "xxx-link_group-xxx",
    #                                      replacement = d$`Link 1 (Research group website)`)
    # template <- stringr::str_replace_all(string = template,
    #                                      pattern = "xxx-link_portal-xxx",
    #                                      replacement = d$`Link 2 (Research portal)`)
    # template <- stringr::str_replace_all(string = template,
    #                                      pattern = "xxx-link_clinical-xxx",
    #                                      replacement = d$`Link 2 (Research portal)`)
    # template <- stringr::str_replace_all(string = template,
    #                                      pattern = "xxx-link_clinical-xxx",
    #                                      replacement = d$`Link 3 (Clinical researcher website)`)
    # template <- stringr::str_replace_all(string = template,
    #                                      pattern = "xxx-link_other-xxx",
    #                                      replacement = d$`Link 4 (Other website)`)
    # 
    # 
    # Save as new file
    filename <- gsub(pattern = " ", 
                     replacement = "", 
                     x = paste0("./temp/tutkijat/", d$`Last name`, "-", d$`First name`,".Rmd"))
    writeLines(template, filename)
  }
  
  # Render subpages to ./output
  if(TRUE){
    pages <- list.files("temp/tutkijat/", full.names = T, pattern = "Rmd")
    for(page in pages){
      print(paste0("Rendering ", page))
      rmarkdown::render(page, output_dir = "output/tutkijat/")
    }
  }
}

# Upload website ----

## To Neurocenter ----
# # move to neurocenter
# system("scp -P 10199 -r ./output/* neurocenterfinland@neurocenterfinland.fi-h.seravo.com:/home/neurocenterfinland/wordpress/htdocs/neurotutkijat")

## To Kapsi ----
# system("scp -r ./output/* janikmiet@kapsi.fi:/home/users/janikmiet/sites/research.janimiettinen.fi/www/material/tutkijat")

