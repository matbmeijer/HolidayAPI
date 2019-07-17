
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
2018:

``` r
library(HolidayAPI)
df<-get_holidays(country = "ES", year = 2018)

summary(df)
#>                     Length Class      Mode     
#> status              1      -none-     numeric  
#> response            1      -none-     character
#> key                 1      -none-     character
#> country             1      -none-     character
#> year                1      -none-     numeric  
#> month               0      -none-     NULL     
#> day                 0      -none-     NULL     
#> previous            0      -none-     NULL     
#> upcoming            0      -none-     NULL     
#> public              0      -none-     NULL     
#> language            1      -none-     character
#> request_url         1      -none-     character
#> observations        1      -none-     numeric  
#> holidays            5      data.frame list     
#> requests_used       1      -none-     numeric  
#> requests_reset_date 1      Date       numeric  
#> requests_date       1      Date       numeric

print(df)
#> $status
#> [1] 200
#> 
#> $response
#> [1] "Success! Everything is A-OK"
#> 
#> $key
#> [1] "7e647736-57b0-4f08-b324-d9f930945236"
#> 
#> $country
#> [1] "ES"
#> 
#> $year
#> [1] 2018
#> 
#> $month
#> NULL
#> 
#> $day
#> NULL
#> 
#> $previous
#> NULL
#> 
#> $upcoming
#> NULL
#> 
#> $public
#> NULL
#> 
#> $language
#> [1] "eng"
#> 
#> $request_url
#> [1] "https://holidayapi.com/v1/holidays?key=7e647736-57b0-4f08-b324-d9f930945236&country=ES&year=2018"
#> 
#> $observations
#> [1] 16
#> 
#> $holidays
#>                                  name       date   observed public country
#> 1                      New Year's Day 2018-01-01 2018-01-01   TRUE      ES
#> 2                            Epiphany 2018-01-06 2018-01-06   TRUE      ES
#> 3                        Father's Day 2018-03-19 2018-03-19  FALSE      ES
#> 4                       March Equinox 2018-03-20 2018-03-20  FALSE      ES
#> 5                         Good Friday 2018-03-30 2018-03-30   TRUE      ES
#> 6                           Labor Day 2018-05-01 2018-05-01   TRUE      ES
#> 7                        Mother's Day 2018-05-06 2018-05-06  FALSE      ES
#> 8                       June Solstice 2018-06-21 2018-06-21  FALSE      ES
#> 9                  Assumption of Mary 2018-08-15 2018-08-15   TRUE      ES
#> 10                  September Equinox 2018-09-23 2018-09-23  FALSE      ES
#> 11              Hispanic Heritage Day 2018-10-12 2018-10-12   TRUE      ES
#> 12                    All Saints' Day 2018-11-01 2018-11-01   TRUE      ES
#> 13            Day of the Constitution 2018-12-06 2018-12-06   TRUE      ES
#> 14 Feast of the Immaculate Conception 2018-12-08 2018-12-08   TRUE      ES
#> 15                  December Solstice 2018-12-21 2018-12-21  FALSE      ES
#> 16                      Christmas Day 2018-12-25 2018-12-25   TRUE      ES
#> 
#> $requests_used
#> [1] 89
#> 
#> $requests_reset_date
#> [1] "2019-08-01"
#> 
#> $requests_date
#> [1] "2019-07-17"
#> 
#> attr(,"class")
#> [1] "country_holidays" "list"
```
