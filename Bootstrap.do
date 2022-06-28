 /*This document is for creating standard error of the coefficients by using 
 bootstraping*/
 

clear
 
*Import the cleaned data
import excel "C:\Users\Istvan\Documents\BCE Mester\Szakdolgozat\Adatok\03.28\Final.xlsx", sheet("Munka1") firstrow

*Change the format of the data by creating new ones and dropping old ones
gen weights = real(Weightinginpermill)
drop Weightinginpermill
rename Services service

forvalues i = 1(1)74 {
gen Per`i'  = real(TIME`i')
drop TIME`i'
}

//taking sample with replacement
bsample 116 if (level == 4 | level == 5) & correction != 1 & goods == 1 

by COICOP, sort: gen repeats = _N //how many times it does exist
by COICOP, sort: gen dup = _n //which it is in order in the group

drop if dup > 1 //drop the repeated rows
drop dup //drop the dup variable

//Reshaping data from wide to long for calculations
quietly reshape long Per, i( COICOP ) j(per)
rename Per price

*Generate new variables for the months of VAT change
//2020M7 introducing new VAT rates
gen M7_2020 = 1 if per == 67
replace M7_2020 = 0 if missing(M7_2020)

//2021M1: set back to the previous VAT
gen M1_2021 = 1 if per == 73
replace M1_2021 = 0 if missing(M1_2021)

*Creating variables for each month
gen time = mod(per,12)
replace time = 12 if time == 0

gen jan = 1 if time == 1
replace jan = 0 if missing(jan)
gen feb = 1 if time == 2
replace feb = 0 if missing(feb)
gen mar = 1 if time == 3
replace mar = 0 if missing(mar)
gen apr = 1 if time == 4
replace apr = 0 if missing(apr)
gen may = 1 if time == 5
replace may = 0 if missing(may)
gen jun = 1 if time == 6
replace jun = 0 if missing(jun)
gen jul = 1 if time == 7
replace jul = 0 if missing(jul)
gen aug = 1 if time == 8
replace aug = 0 if missing(aug)
gen sep = 1 if time == 9
replace sep = 0 if missing(sep)
gen oct = 1 if time == 10
replace oct = 0 if missing(oct)
gen nov = 1 if time == 11
replace nov = 0 if missing(nov)
gen dec = 1 if time == 12
replace dec = 0 if missing(dec)

//to set timeseries
generate time2 = _n
tsset time2

//generate empty variables
gen betas_M7 = .
gen betas_M1 = .

egen group = group(COICOP)
sum group, meanonly

forvalues i = 1(1)`r(max)'{
	gen rownumber = 74*(`i'-1)+1 //these are the lines where period == 1
	quietly eststo: regress price jan feb mar apr may jun jul aug sep oct nov M7_2020 M1_2021 if group == `i' //regression
	quietly replace betas_M7 = _b[M7_2020] if _n == rownumber
	quietly replace betas_M1 = _b[M1_2021] if _n == rownumber
	quietly est clear
	drop rownumber
}

//if an obs was chosen more times, we multiple the weights
replace weights = weights * repeats

//the sum of the weights
egen total_w = total(weights) if per == 1

//relative weights
gen rel_w = weights/total_w

//the total effects
gen rel_betas_M7 = rel_w*betas_M7
egen total_M7 = total(rel_betas_M7)

gen rel_betas_M1 = rel_w*betas_M1
egen total_M1 = total(rel_betas_M1)

display total_M7
display total_M1
