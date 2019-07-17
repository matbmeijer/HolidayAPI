
<!-- README.md is generated from README.Rmd. Please edit that file -->

# HolidayAPI

<!-- badges: start -->

<!-- badges: end -->

The goal of HolidayAPI package is making worldwide holidays / bank days
accessible to the R community. The package is an API wrapper of the
[Holiday API](https://holidayapi.com/). You can see details of the API
documentation and limitations at <https://holidayapi.com/docs>. Be aware
that you need a key of the API, which you can get for free at
<https://holidayapi.com/signup>.

## Installation

You can install the released version of HolidayAPI from
[GitHub](https://github.com/) with:

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
2018. Piping is also possible, as well as converting holidays to a
`data.frame`:

``` r
library(HolidayAPI)
#> 
#> Attaching package: 'HolidayAPI'
#> The following objects are masked from 'package:base':
#> 
#>     as.data.frame, print, summary
df<-get_holidays(country = "ES", year = 2018)
summary(df)
#> [1] "At date 2019-07-17, 16 holidays appear in ES during the year 2018, from which 10 are public."
class(df)
#> [1] "country_holidays" "list"

df2<-get_holidays(country = "FR", year = 2018) %>% as.data.frame()
class(df2)
#> [1] "data.frame"
head(df2)
#>                                     name       date   observed public
#> 1                         New Year's Day 2018-01-01 2018-01-01   TRUE
#> 2                          March Equinox 2018-03-20 2018-03-20  FALSE
#> 3                          Easter Monday 2018-04-02 2018-04-02   TRUE
#> 4                              Labor Day 2018-05-01 2018-05-01   TRUE
#> 5                  Victory in Europe Day 2018-05-08 2018-05-08   TRUE
#> 6 Feast of the Ascension of Jesus Christ 2018-05-10 2018-05-10   TRUE
#>   country requests_date
#> 1      FR    2019-07-17
#> 2      FR    2019-07-17
#> 3      FR    2019-07-17
#> 4      FR    2019-07-17
#> 5      FR    2019-07-17
#> 6      FR    2019-07-17
```
