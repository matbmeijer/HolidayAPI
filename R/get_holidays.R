#' @title Saves the key for future functions
#' @description Saves the key in the users environment as HOLIDAYAPI_PAT. It has the advantage that it is not necessary to explicitly publish the key in the users code. Just do it ones and you're set. To update the key kust save again and it will overwrite the old key.
#' @param key The users API key obtained when registering at \href{https://holidayapi.com/signup}{}.
#' @return Saves the key in the users environment as HOLIDAYAPI_PAT - it does not return any object.
#' @author Matthias Brenninkmeijer - \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @examples
#' \dontrun{
#' save_key(key="__YOUR_API_KEY__")
#' }
#' @export
save_key <-function(key){
  Sys.setenv(HOLIDAYAPI_PAT=key)
}

#' @title Retrieves the key from users environment
#' @description Retrieves the key assigned to the variable HOLIDAYAPI_PAT in the users environment.
#' The key needs to be explicitly saved with the \code{save_key(key)} function.
#' @return Returns the key from the users environment.
#' @author Matthias Brenninkmeijer - \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @examples
#' \dontrun{get_key()}

get_key <- function(){
  key <- Sys.getenv('HOLIDAYAPI_PAT', "")
  if (key == "") {
    stop("Unable to find the HOLIDAYAPI_PAT in the environment variables. Remember to save the key with the save_key(key) function.")
  }
  return(key)
}

#' @title Retrieve holidays
#' @description Retrieve a list of holidays from a given country in a given year.
#' By default the JSON format is selected because it contains additional request information.
#' @param key The users API key obtained when registering at \href{https://holidayapi.com/signup}{}.
#' If the key has been saved to the environment before using the \code{save_key(key)} function,
#' it is not required to pass. It is a required parameter in \code{character} format.
#' @param country Country code in \href{https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2}{ISO 3166-1 alpha 2}
#' or \href{https://en.wikipedia.org/wiki/ISO_3166-2}{ISO 3166-2} format. For multiple countries,
#' pass a vector - it is limited to 10 countries. It is a required parameter in \code{character} format.
#' @param year Year in \href{https://en.wikipedia.org/wiki/ISO_8601#Years}{ISO 8601} format.
#' It is a required parameter in \code{numeric} format.
#' @param ... Ellipsis to pass optional arguments into the function such as:
#' \itemize{
#' \item \code{month} - 1 or 2 digit month (1-12). It is an optional parameter.
#' \item \code{day} - 1 or 2 digit day (1-31 depending on the month). It is an optional parameter format.
#' \item \code{previous} - 1 or 2 digit day (1-31 depending on the month). It is an optional parameter format.
#' \item \code{upcoming} - Return upcoming holidays based on the date the API is called. It is an optional parameter format.
#' \item \code{public} - Return only \href{https://en.wikipedia.org/wiki/Public_holiday}{public holidays}.
#' It is an optional parameter format in boolean format.
#' \item \code{language} - By default English language, optionally other languages in ISO 639-1 language
#' #'  format can be passed (with exceptions). It is an optional parameter format in \code{character} format.
#' }
#' @author Matthias Brenninkmeijer - \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a \code{country_holidays} object containing the dates, names of holidays, if they
#' are public or not. Additionally, relevant information about the API request is shown.
#' @source For more information about the Holiday API go to the \href{https://holidayapi.com/docs}{Holiday API documentation page}
#' @examples
#' \dontrun{
#' get_holidays(country="ES", year=2018)
#' }
#' @section Warning:
#' Depending on the subscription plan the scope of the API changes. At date 2019-07-01 the free plan
#' is limited to historical data for 2018 with 10.000 monthly requests in english language format only.
#'  Non-commercial use only. For more, updated information go \href{https://holidayapi.com/}{here}.
#' @export

get_holidays<-function(country,
                       year,
                       key=get_key(), ...){
  arguments<-list(...)
  request_url<-httr::modify_url(url = "https://holidayapi.com/",
                                path = list(default_version(), "holidays"),
                                query = list(key=key,
                                     country=paste0(country, collapse = ","),
                                     year=year,
                                     month=arguments$month,
                                     day=arguments$day,
                                     previous=arguments$previous,
                                     upcoming=arguments$upcoming,
                                     public=arguments$public,
                                     language=arguments$language))
  call_raw <- httr::GET(request_url, encode = "json", httr::user_agent("github.com/matbmeijer"))
  if (httr::http_type(call_raw) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }
  call <- jsonlite::fromJSON(httr::content(call_raw, "text"), simplifyVector = TRUE)
  if(httr::http_error(call_raw)){
    if(any(names(call) %in% "error")){
     stop(sprintf("Error Code %s - %s", call$status, call$error))
    } else {
      stop(sprintf("Error Code %s - %s", call$status_code, api_response(call$status_code)))
    }
  }
  obj<-as_country_holidays(
    request_url = request_url,
    key=key,
    country=country,
    year=year,
    call=call,
    month=arguments$month,
    day=arguments$day,
    previous=arguments$previous,
    upcoming=arguments$upcoming,
    public=arguments$public,
    language=arguments$language,
    requests_date = as.Date(call_raw$date))
  return(obj)
}

#' @title Retrieve available countries
#' @description Retrieve all 249 for which the Holiday API has holidays available.
#' Useful to pass on later on \code{to get_holidays()} function. By default the JSON format
#'  is selected because it contains additional request information.
#' @param key The users API key obtained when registering at \href{https://holidayapi.com/signup}{}.
#' If the key has been saved to the environment before using the \code{save_key(key)} function,
#' it is not required to pass. It is a required parameter in \code{character} format.
#' @author Matthias Brenninkmeijer - \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a \code{available_countries} object containing the
#' \href{https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2}{ISO 3166-1 alpha 2} country code and the english short name.
#' Additionally, relevant information about the API request is shown.
#' @source For more information about the Holiday API go to the \href{https://holidayapi.com/docs}{Holiday API documentation page}
#' @examples
#' \dontrun{
#' save_key(key="__YOUR_API_KEY__")
#' get_countries()
#' }
#' @section Warning:
#' Depending on the subscription plan the scope of the API changes. At date 2019-07-01 the
#' free plan is limited to historical data for 2018 with 10.000 monthly requests in english
#' language format only. Non-commercial use only. For more, updated information go \href{https://holidayapi.com/}{here}.-
#' @export

get_countries<-function(key=get_key()){
  request_url<-httr::modify_url(url = "https://holidayapi.com/",
                                path = list(default_version(), "countries"),
                                query = list(key=key))
  call_raw <- httr::GET(request_url, encode = "json", httr::user_agent("github.com/matbmeijer"))
  if (httr::http_type(call_raw) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }
  call <- jsonlite::fromJSON(httr::content(call_raw, "text"), simplifyVector = TRUE)
  if(httr::http_error(call_raw)){
    if(any(names(call) %in% "error")){
      stop(sprintf("Error Code %s - %s", call$status, call$error))
    } else {
      stop(sprintf("Error Code %s - %s", call$status_code, api_response(call$status_code)))
    }
  }

  obj<-as_available_countries(request_url = request_url,
                              key = key,
                              call = call,
                              requests_date = as.Date(call_raw$date))
  return(obj)
}

#' @title Retrieve available languages
#' @description Retrieve all 100 for which the Holiday API has holidays translation available.
#' By default returns english. Useful to pass on later on \code{to get_holidays()} function.
#' @param key The users API key obtained when registering at \href{https://holidayapi.com/signup}{}.
#' If the key has been saved to the environment before using the \code{save_key(key)} function, it is not required to pass.
#'It is a required parameter in \code{character} format.
#' @author Matthias Brenninkmeijer - \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a \code{available_languages} object containing the
#' \href{https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes}{ISO 639-1 format (with exceptions)} language and its name.
#' Additionally, relevant information about the API request is shown.
#' @source For more information about the Holiday API go to the \href{https://holidayapi.com/docs}{Holiday API documentation page}
#' @examples
#' \dontrun{
#' save_key(key="__YOUR_API_KEY__")
#' get_languages()
#' }
#' @section Warning:
#' Depending on the subscription plan the scope of the API changes. At date 2019-07-01 the free plan
#'  is limited to historical data for 2018 with 10.000 monthly requests in english language format only.
#'  Non-commercial use only. For more, updated information go \href{https://holidayapi.com/}{here}.-
#' @export

get_languages<-function(key=get_key()){
  request_url<-httr::modify_url(url = "https://holidayapi.com/",
                                path = list(default_version(), "languages"),
                        query = list(key=key))
  call_raw <- httr::GET(request_url, encode = "json", httr::user_agent("github.com/matbmeijer"))
  if (httr::http_type(call_raw) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }
  call <- jsonlite::fromJSON(httr::content(call_raw, "text"), simplifyVector = TRUE)
  if(httr::http_error(call_raw)){
    if(any(names(call) %in% "error")){
      stop(sprintf("Error Code %s - %s", call$status, call$error))
    } else {
      stop(sprintf("Error Code %s - %s", call$status_code, api_response(call$status_code)))
    }
  }
  obj<-as_available_languages(request_url=request_url,
                         key = key,
                         call = call,
                         requests_date = as.Date(call_raw$date))
  return(obj)
}

