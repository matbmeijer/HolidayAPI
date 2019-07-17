#' @title Default HTTPS status error messages
#' @description Function which returns predefined default success/error messages as documented at \href{https://holidayapi.com/docs}{}.
#' @param status HTTPS returned status code when doing a GET REST API call to any https://holidayapi.com endpoint.
#' @author Matthias Brenninkmeijer - \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a \code{character} with a predefined success/error linked to the status code.
#' @source For more information about the Holiday API go to the \href{https://holidayapi.com/docs}{Holiday API documentation page}
#' @examples
#' \dontrun{
#' api_response(200)
#' }

api_response<-function(status){
  if(status==200){
    response<-"Success! Everything is A-OK"
  } else if(status==400){
    response<-"Something is wrong on your end"
  } else if(status==401){
    response<-"Unauthorized (did you remember your API key?)"
  } else if(status==402){
    response<-"Payment required (account is delinquent)"
  } else if(status==403){
    response<-"Forbidden (this API is HTTPS-only)"
  } else if(status==429){
    response<-"Rate limit exceeded"
  }else if(status==500){
    response<-"OH NOES!!~! Something is wrong on our end"
  }
  return(response)
}

#' @title Add Country ISO Code column
#' @description Function to add country 2 letter isocode column in subidivision \code{data.frame} item
#' @param item country subdivision \code{data.frame} element
#' @param country_code 2 letter iso code to assign
#' @author Matthias Brenninkmeijer - \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns the inserted \code{data.frame} with the isocode as column attached.

add_iso_code<-function(item, country_code){
  if(is.null(item)){
    item<-data.frame(code=NA, name=NA, languages=NA, country_code=country_code, stringsAsFactors = FALSE)
  } else {
    item$country_code<-country_code
  }
  return(item)
}

#' @title Converts non-usable values to empty character string
#' @description Converts FALSE, character(0), NA, list(), NULL to an empty  \code{""} \code{character} string
#' @param item Logical FALSE, empty, NULL or NA element
#' @author Matthias Brenninkmeijer - \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns an empty \code{character} string.

nonvalues2NA<-function(item){
  if(is.na(item)||length(item)==0||is.null(item)||(is.logical(item)&&!item)){
    item<-""
  }
  return(item)
}

#' @title Returns API default version
#' @description Allows to easily adjust the versioning within the package
#' @author Matthias Brenninkmeijer - \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns the package API version

default_version <- function(){"v1"}

#' @title Convert to \code{country_holidays} class
#' @description Convert call response to an internal \code{country_holidays} class object, formatting the response to ease tha holidays analysis.
#' @param request_url URL with which the RESTful GET API call has ben made.
#' @param key The users API key obtained when registering at \href{https://holidayapi.com/signup}{}.
#' @param country Country code in \href{https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2}{ISO 3166-1 alpha 2}
#' or \href{https://en.wikipedia.org/wiki/ISO_3166-2}{ISO 3166-2} format. For multiple countries,
#' pass a vector - it is limited to 10 countries. It is a required parameter in \code{character} format.
#' @param year Year in \href{https://en.wikipedia.org/wiki/ISO_8601#Years}{ISO 8601} format.
#' It is a required parameter in \code{numeric} format.
#' @param call JSON Response from the RESTful GET API call formatted back to a \code{list} element.
#' @param ... Optional parameters.
#' @author Matthias Brenninkmeijer - \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a \code{country_holidays} object class

as_country_holidays<-function(request_url, key, country, year, call, ...){
  arguments<-list( ...)
  if(is.null(arguments$language)){
    arguments$language="eng"
  }
  call$holidays$date<-as.Date(call$holidays$date)
  call$holidays$observed<-as.Date(call$holidays$observed)

  obj<-structure(
    list(
      status=call$status,
      response=api_response(call$status),
      key=key,
      country=country,
      year=year,
      month=arguments$month,
      day=arguments$day,
      previous=arguments$previous,
      upcoming=arguments$upcoming,
      public=arguments$public,
      language=arguments$language,
      request_url = request_url,
      observations = nrow(call$holidays),
      holidays = call$holidays,
      requests_used=call$requests$used,
      requests_reset_date=as.Date(call$requests$resets),
      requests_date=arguments$requests_date),
    class =c("country_holidays", "list")
    )
  return(obj)
}

#' @title Convert to \code{available_countries} class
#' @description Convert call response to an internal \code{available_countries} class object, formatting the response to ease tha holidays analysis.
#' @param request_url URL with which the RESTful GET API call has ben made.
#' @param key The users API key obtained when registering at \href{https://holidayapi.com/signup}{}.
#' @param call JSON Response from the RESTful GET API call formatted back to a \code{list} element.
#' @param ... Optional parameters.
#' @author Matthias Brenninkmeijer - \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a \code{available_countries} object class

as_available_countries<-function(request_url, key, call, ...){
  arguments<-list( ...)
  call$countries$subdivisions<-mapply(add_iso_code,
                                      item=call$countries$subdivisions,
                                      country_code=call$countries$code,
                                      SIMPLIFY = FALSE)
  subdivisions<-do.call("rbind", call$countries$subdivisions)
  countries<-call$countries
  countries$subdivisions<-NULL
  countries$languages<-lapply(countries$languages, nonvalues2NA)
  subdivisions$languages<-lapply(subdivisions$languages, nonvalues2NA)
  countries$languages<-unlist(lapply(countries$languages, paste0, collapse=", "), FALSE, FALSE)
  subdivisions$languages<-unlist(lapply(subdivisions$languages, paste0, collapse=", "), FALSE, FALSE)
  countries$languages[countries$languages==""]<-NA
  subdivisions$languages[subdivisions$languages==""]<-NA
  call$countries<-merge(countries,
                        subdivisions,
                        by.x ="code",
                        by.y = "country_code",
                        suffixes = c("_countries", "_subdivisions"),
                        all.x = TRUE)

  obj<-structure(
    list(
      status=call$status,
      response=api_response(call$status),
      key=key,
      request_url = request_url,
      observations = nrow(call$countries),
      countries = call$countries,
      requests_used=call$requests$used,
      requests_reset_date=as.Date(call$requests$resets),
      requests_date=arguments$requests_date),
    class =c("available_countries", "list")
  )
  return(obj)
}

#' @title Convert to \code{available_languages} class
#' @description Convert call response to an internal \code{available_languages} class object, formatting the response to ease tha holidays analysis.
#' @param request_url URL with which the RESTful GET API call has ben made.
#' @param key The users API key obtained when registering at \href{https://holidayapi.com/signup}{}.
#' @param call JSON Response from the RESTful GET API call formatted back to a \code{list} element.
#' @param ... Optional parameters.
#' @author Matthias Brenninkmeijer - \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a \code{available_languages} object class

as_available_languages<-function(request_url, key, call, ...){
  arguments<-list( ...)
  obj<-structure(
    list(
      status=call$status,
      response=api_response(call$status),
      key=key,
      request_url = request_url,
      observations = nrow(call$languages),
      languages = call$languages,
      requests_used=call$requests$used,
      requests_reset_date=as.Date(call$requests$resets),
      requests_date=arguments$requests_date),
    class =c("available_languages", "list")
  )
  return(obj)
}

#' @title Print Holiday API classes
#' @param x Can be a \code{country_holidays}, \code{available_countries} or \code{available_languages} object.
#' @author Matthias Brenninkmeijer - \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Prints a Holiday API class.
#' @export

print <- function(x){
  UseMethod("print",x)
}

#' @title Print a \code{country_holidays} class
#' @param x Must be a \code{country_holidays} class object.
#' @author Matthias Brenninkmeijer - \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Prints a \code{country_holidays} class object.
#' @export

print.country_holidays <- function(x){
  cat("<Holiday API - Holidays - ", x$request_url, ">\n", sep = "")
  print(x$holidays)
  invisible(x)
}

#' @title Print a \code{available_countries} class
#' @param x Must be a \code{available_countries} class object.
#' @author Matthias Brenninkmeijer - \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Prints a \code{available_countries} class object.
#' @export

print.available_countries <- function(x){
  cat("<Holiday API - Countries - ", x$request_url, ">\n", sep = "")
  print(x$countries)
  invisible(x)
}

#' @title Print a \code{available_languages} class
#' @param x Must be a \code{available_languages} class object.
#' @author Matthias Brenninkmeijer - \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Prints a \code{available_languages} class object.
#' @export

print.available_languages <- function(x){
  cat("<Holiday API - Languages - ", x$request_url, ">\n", sep = "")
  print(x$languages)
  invisible(x)
}

#' @title Summary of Holiday API classes
#' @param x Can be a \code{country_holidays}, \code{available_countries} or \code{available_languages} object
#' @author Matthias Brenninkmeijer - \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a summary of a Holiday API class
#' @export

summary <- function(x){
  UseMethod("summary",x)
}


#' @title Summary of a \code{country_holidays} class
#' @param x Must be a \code{country_holidays} class object.
#' @author Matthias Brenninkmeijer - \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a summary of a \code{country_holidays} class object.
#' @export

summary.country_holidays <- function(x){
  res<-sprintf("At date %s, %s holidays appear in %s during the year %s, from which %s are public.",
               x$requests_date,
               x$observations,
               paste(x$country, collapse = " & "),
               x$year,
               nrow(x$holidays[x$holidays$public==TRUE,])
  )
  return(res)
}

#' @title Summary of a \code{available_countries} class
#' @param x Must be a \code{available_countries} class object.
#' @author Matthias Brenninkmeijer - \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a summary of a \code{available_countries} class object.
#' @export

summary.available_countries <- function(x){
  res<-sprintf("At date %s, the Holiday API supports holiday information for %s countries and %s subdivisions.",
               x$requests_date,
               length(unique(x$countries$code)),
               length(unique(x$countries$code_subdivisions))
  )
  return(res)
}

#' @title Summary of a \code{available_languages} class
#' @param x Must be a \code{available_languages} class object.
#' @author Matthias Brenninkmeijer - \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a summary of a \code{available_languages} class object.
#' @export

summary.available_languages <- function(x){
  res<-sprintf("At date %s, the Holiday API supports %s language formats.",
               x$requests_date,
               length(unique(x$languages$name))
  )
  return(res)
}

#' @title Creates data.frame
#' @description Creates a \code{data.frame} from a \code{country_holidays} class object
#' @param x Must be a \code{country_holidays} object.
#' @author Matthias Brenninkmeijer - \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a \code{data.frame}
#' @export

as.data.frame <- function(x){
  UseMethod("as.data.frame",x)
}

#' @title Creates data.frame
#' @param x Must be a \code{available_languages} class object
#' @author Matthias Brenninkmeijer - \href{https://github.com/matbmeijer}{https://github.com/matbmeijer}
#' @return Returns a summary of a \code{available_languages} class object.
#' @export
#'
as.data.frame.country_holidays <- function(x){
  x$holidays$requests_date<-x$requests_date
  return(x$holidays)
  invisible(x)
}
