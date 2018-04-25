# https://rpubs.com/mdancho84/adv-r_functional_programming

#Adaptability

# closures ?

missing_fixer <- function(na_value) {
  function(x) {
    x[x==na_value] <- NA
    x
  }
}

fix_missing_99 <- missing_fixer(-99) # create function setting -99 as param
fix_missing_99(c(-99, -999)) # run new function

fix_missing_999 <- missing_fixer(-999)
fix_missing_99(c(-99, -999)) # run new function

