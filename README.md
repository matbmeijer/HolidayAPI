
<!-- README.md is generated from README.Rmd. Please edit that file -->

# HolidayAPI

<!-- badges: start -->

<!-- badges: end -->

The goal of HolidayAPI package is making worldwide holidays / bank days
accessible to the R community. The package is an API wrapper of the
[Holiday API](https://holidayapi.com/) offering easy access to all
official endpoints. You can see details of the API documentation and
limitations at <https://holidayapi.com/docs>. Be aware that you need a
key of the API, which you can get for free at
<https://holidayapi.com/signup>.

## Installation

You can install the released version of HolidayAPI from
[GitHub](https://github.com/) with the following commands in `R`:

``` r
# install.packages("devtools")
devtools::install_github("matbmeijer/HolidayAPI")
```

## Example

To work, you will need to save your API key - the package automatically
loads the key for every function once you have saved the key:

``` r
library(HolidayAPI)
save_key("____YOUR_API_KEY_HERE____")
```

This is a basic example showing how to obtain holiday data for Spain for
2019. Piping is also possible, as well as converting holidays to a
`data.frame`:

``` r
library(HolidayAPI)
#> 
#> Attaching package: 'HolidayAPI'
#> The following objects are masked from 'package:base':
#> 
#>     as.data.frame, print, summary
last_year<-as.numeric(format(Sys.Date(), "%Y"))-1
holidays_df<-get_holidays(country = "ES", year = last_year)
summary(holidays_df)
#> [1] "At date 2020-03-31, 28 holidays appear in ES during the year 2019, from which 11 are public."
class(holidays_df)
#> [1] "country_holidays" "list"

holidays_df<-holidays_df %>% as.data.frame()
class(holidays_df)
#> [1] "data.frame"

knitr::kable(head(holidays_df, 5), row.names = FALSE, caption = "Example of spanish holidays", format = "markdown")
```

| name                  | date       | observed   | public | country | uuid                                 | weekday.date.name | weekday.date.numeric | weekday.observed.name | weekday.observed.numeric | requests\_date |
| :-------------------- | :--------- | :--------- | :----- | :------ | :----------------------------------- | :---------------- | :------------------- | :-------------------- | :----------------------- | :------------- |
| New Year’s Day        | 2019-01-01 | 2019-01-01 | TRUE   | ES      | c425b20b-749e-426a-bf67-3bb2ff996456 | Tuesday           | 2                    | Tuesday               | 2                        | 2020-03-31     |
| Epiphany              | 2019-01-06 | 2019-01-06 | TRUE   | ES      | cfd84af7-b6ed-4a40-b02b-361985af9e3b | Sunday            | 7                    | Sunday                | 7                        | 2020-03-31     |
| Valentine’s Day       | 2019-02-14 | 2019-02-14 | FALSE  | ES      | ed8dc1e0-370f-4030-aff2-61d8e5bc5d8b | Thursday          | 4                    | Thursday              | 4                        | 2020-03-31     |
| UN World Wildlife Day | 2019-03-03 | 2019-03-03 | FALSE  | ES      | 95ca9650-a7c3-4cbc-b363-de7874ec3da5 | Sunday            | 7                    | Sunday                | 7                        | 2020-03-31     |
| Ash Wednesday         | 2019-03-06 | 2019-03-06 | FALSE  | ES      | 359b57cc-1362-4e82-8b96-a57d33a3f513 | Wednesday         | 3                    | Wednesday             | 3                        | 2020-03-31     |

Some useful functions are the `r get_countries()` and the `r
get_langugages()` functions, with the prior returning updated
information about all the supported countries and regions (the API
offers both national and regional holiday information) and the latter
returning updated information about the different supported languages
(on deafault the API returns english).

``` r
countries_df<-get_countries()
summary(countries_df)
#> [1] "At date 2020-03-31, the Holiday API supports holiday information for 249 countries and 3681 subdivisions."
class(countries_df)
#> [1] "available_countries" "list"

countries_df<-countries_df %>% as.data.frame()
class(countries_df)
#> [1] "data.frame"

knitr::kable(head(countries_df, 5), row.names = FALSE, caption = "Example of available countries & subdivisions", format = "markdown")
```

| code | name\_countries | codes.alpha.2 | codes.alpha.3 | codes.numeric | languages\_countries | flag                                         | code\_subdivisions | name\_subdivisions  | languages\_subdivisions | requests\_date |
| :--- | :-------------- | :------------ | :------------ | :------------ | :------------------- | :------------------------------------------- | :----------------- | :------------------ | :---------------------- | :------------- |
| AD   | Andorra         | AD            | AND           | 020           | ca                   | <https://www.countryflags.io/AD/flat/64.png> | AD-02              | Canillo             | ca                      | 2020-03-31     |
| AD   | Andorra         | AD            | AND           | 020           | ca                   | <https://www.countryflags.io/AD/flat/64.png> | AD-03              | Encamp              | ca                      | 2020-03-31     |
| AD   | Andorra         | AD            | AND           | 020           | ca                   | <https://www.countryflags.io/AD/flat/64.png> | AD-04              | La Massana          | ca                      | 2020-03-31     |
| AD   | Andorra         | AD            | AND           | 020           | ca                   | <https://www.countryflags.io/AD/flat/64.png> | AD-05              | Ordino              | ca                      | 2020-03-31     |
| AD   | Andorra         | AD            | AND           | 020           | ca                   | <https://www.countryflags.io/AD/flat/64.png> | AD-06              | Sant Julià de Lòria | ca                      | 2020-03-31     |

``` r

languages_df<-get_languages()
summary(languages_df)
#> [1] "At date 2020-03-31, the Holiday API supports 109 distinct language formats."
class(languages_df)
#> [1] "available_languages" "list"

languages_df<-languages_df %>% as.data.frame()
class(languages_df)
#> [1] "data.frame"

knitr::kable(head(languages_df, 5), row.names = FALSE, caption = "Example of available languages", format = "markdown")
```

| code | name        | requests\_date |
| :--- | :---------- | :------------- |
| af   | Afrikaans   | 2020-03-31     |
| am   | Amharic     | 2020-03-31     |
| ar   | Arabic      | 2020-03-31     |
| az   | Azerbaijani | 2020-03-31     |
| be   | Belarusian  | 2020-03-31     |

Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its terms.
