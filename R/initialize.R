
load_dph_packages <- function() {
  DPH_packages <- c("rmarkdown", "kableExtra", "tidyverse", "lubridate", "sf",
                     "DBI", "odbc", "formatR", "knitr", "MMWRweek",
                    "scales", "english", "flextable", "slider",
                    "stringdist", "knitr", "yaml")

  quiet_load <- function(x) {
    suppressPackageStartupMessages(library(x,
                                           lib.loc = "O:/rlibs/",
                                           logical.return = TRUE,
                                           character.only = TRUE,
                                           warn.conflicts = FALSE,
                                           quietly = TRUE,
                                           attach.required = TRUE))
  }

  invisible(sapply(DPH_packages, quiet_load))
}

#' @title Write a data.frame Object to the Database
#'
#' @description Put a better title here.
#' @param df_name the data frame name.
#' @param table_name the database table name. Default is `NULL`.
#' @param overwrite if the table exists, should it be overwritten? Default is
#' `FALSE`.
#' @param append should the data frame be appended? Default is TRUE.
#' @param host_name the host name of the database.
#' @importFrom DBI dbConnect dbWriteTable dbDisconnect SQL
#' @importFrom odbc odbc
#' @export
df_to_table <-
  function(df_name,
           table_name = NULL,
           overwrite = FALSE,
           append = TRUE,
           host_name = "best") {

    ### error checking
    if(overwrite == append)  stop("You can not append and overwrite at the same time")
    if(missing(df_name)) stop("You must specify a dataframe")
    if(!exists(deparse(substitute(df_name))))  stop("Can not find that dataframe")
    if(is.null(table_name)) stop("You must specify a table in the database")
    ### main code
    epi_connect <- DBI::dbConnect(odbc::odbc(), host_name)

    # build the SQL string
    fqdbn <- paste0("DPH_COVID_IMPORT.dbo.", table_name)

    DBI::dbWriteTable(epi_connect,
                      SQL(fqdbn),
                      df_name,
                      append = append,
                      overwrite = overwrite)

    odbc::dbDisconnect(epi_connect)
  }

#' @title Read a Database Table in as a data.frame Object.
#'
#' @description TODO write this
#' @param table_name the name of the database table. Default is `NULL`.
#' @param host_name the name of machine hosting the database server. Default
#' is "best".
#' @importFrom DBI dbConnect dbGetQuery dbDisconnect SQL
#' @importFrom odbc odbc
#' @export
table_to_df <-
  function(table_name = NULL, host_name = "best") {

    ### error checking
    if(is.null(table_name)) stop("You must specify a table in the database")
    sql_table_name <- SQL("DPH_COVID_IMPORT.dbo.report_summary")

    ### main code
    epi_connect <- DBI::dbConnect(odbc::odbc(), host_name)

    # build the SQL string
    fqdbn <- paste0("select * FROM [DPH_COVID_IMPORT].[dbo].[",
                    table_name,
                    "] ")

    results <- DBI::dbGetQuery(epi_connect,
                               statement = fqdbn)

    odbc::dbDisconnect(epi_connect)
    return(results)
  }


#' @title Summarize a Column
#'
#' @description TODO: Add this.
#' @param dfname the data.frame whose columns will be summarized.
#' @param colname the name of the column to summarize.
#' @importFrom dplyr group_by summarize mutate arrange desc
#' @export
summarise_column <- function(dfname, colname) {
  dfname %>%
    group_by({{ colname }}, .drop = FALSE) %>%
    summarise(Count = n()) %>%
    mutate(Pct = Count / sum(Count) * 100) %>%
    arrange(desc(Count))
}

make_comp_table <- function(before_df, after_df, by_what) {
  left_join(before_df, after_df,
            by = by_what,
            suffix = c(".before", ".after")) %>%
    select(-Pct.before, -Pct.after) %>%
    mutate(Count.after = replace_na(Count.after, 0),
           Count.before = replace_na(Count.before, 0),
           Change = Count.after - Count.before) %>%
    arrange(desc(Count.after))
}

getAllThursdays <-
  function(start_date = "2020-02-28",
           end_date = lubridate::today(),
           day_of_week = 5,
           how_many = 99999,
           every_n = 1) {

    if(!is.Date(start_date)) {
      start_date <- as_date(start_date)
    }

    if(!is.Date(end_date)) {
      end_date <- as_date(end_date)
    }

    if(!day_of_week %in% 1:7) {
      day_of_week <- 5
    }

    all_days <- seq(start_date, end_date, by = "day")
    thursdays <- all_days[wday(all_days) == day_of_week]

    if(every_n %in% 2:7) {
      thursdays <- rev(seq(max(thursdays), min(thursdays),
                           by = paste0("-", every_n, " weeks")))
    }

    how_many <-
      case_when(
        how_many <= 0                 ~ length(thursdays),
        how_many >= length(thursdays) ~ length(thursdays),
        TRUE                          ~ as.integer(how_many)
      )

    thursdays <- thursdays[seq.int(to = length(thursdays), length.out = how_many)]
    return(thursdays)

  }

loadRData <- function(fileName){
  #loads an RData file, and returns it
  load(fileName)
  get(ls()[ls() != "fileName"])
}

# d <- loadRData("l:/recent_rdata/case_2021-05-05-05-52-57.RData")

`%nin%` = Negate(`%in%`)

save_as_png <- function(x, filename, width = 1000, height = 500, pointsize = 14, res = 100) {
  png(filename = filename,
      width = width, height = height,
      pointsize = pointsize,
      res = res,
      antialias = "cleartype")
  print(x)
  dev.off()
}

