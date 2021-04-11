 /*This document is for analysing the effects of the temporary German VAT change.
 For data cleaning, I used a different .do file*/
 

clear
 
*Import the cleaned data
import excel "C:\Users\Istvan\Documents\BCE Mester\Szakdolgozat\Adatok\03.28\Final.xlsx", sheet("Munka1") firstrow

*Change the format of the data by creating new ones and dropping old ones
gen weights = real(Weightinginpermill)
drop Weightinginpermill

forvalues i = 1(1)74 {
gen Per`i'  = real(TIME`i')
drop TIME`i'
}

*Reshaping data from wide to long for calculations
reshape long Per, i( COICOP ) j(per)
rename Per price
rename Services service

*Generate new variables for the months of VAT change
//2020M7 introducing new VAT rates
gen M7_2020 = 1 if per == 67
replace M7_2020 = 0 if missing(M7_2020)

//2021M1: return back to the previous VAT
gen M1_2021 = 1 if per == 73
replace M1_2021 = 0 if missing(M1_2021)

*Creating variables for each months
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

*length of the database (number of different items):
count if per == 1 //506

total weights if level == 4 & per == 1 //this is 1000
total weights if (level == 4 | level == 5) & per == 1 & (normal == 1 | reduced == 1 | taxfree == 1 | hospitality  == 1) & correction != 1 //this is 1000.12 due to level 5 items whose value are rounded
//the correction category is denoting items on level 4 which are not homogenous in regard of vat-rate (normal + red + taxfree + hosp != 1)



**************************** 0. DESCRIPTIVE STATISTICS ****************************

*Some basic pieces of information
//goods
total weights if per == 1 & goods == 1 & correction != 1 & (level == 4 | level == 5)
total weights if norm == 1 & per == 1 & goods == 1 & correction != 1 & (level == 4 | level == 5)
total weights if red == 1 & per == 1 & goods == 1 & correction != 1 & (level == 4 | level == 5)

total weights if per == 1 & goods == 1 & correction != 1 & (level == 4)
total weights if per == 1 & goods == 1 & correction != 1 & (level == 5)

//pfood
total weights if per == 1 & pfood == 1 & correction != 1 & (level == 4 | level == 5)
total weights if norm == 1 & per == 1 & pfood == 1 & correction != 1 & (level == 4 | level == 5)
total weights if red == 1 & per == 1 & pfood == 1 & correction != 1 & (level == 4 | level == 5)

total weights if per == 1 & pfood == 1 & correction != 1 & (level == 4)
total weights if per == 1 & pfood == 1 & correction != 1 & (level == 5)


//services
total weights if per == 1 & service == 1 & correction != 1 & (level == 4 | level == 5)
total weights if norm == 1 & per == 1 & service == 1 & correction != 1 & (level == 4 | level == 5)
total weights if red == 1 & per == 1 & service == 1 & correction != 1 & (level == 4 | level == 5)
total weights if hosp == 1 & per == 1 & service == 1 & correction != 1 & (level == 4 | level == 5)
total weights if taxfree == 1 & per == 1 & service == 1 & correction != 1 & (level == 4 | level == 5)

total weights if per == 1 & service == 1 & correction != 1 & (level == 4)
total weights if per == 1 & service == 1 & correction != 1 & (level == 5)



*Variance of some type of products
tabstat price if COICOP == "Processed food excluding alcohol and tobacco", stat(mean, count, sum, max, min, v, sem, p10, p25, med, p75, p90)
tabstat price if COICOP == "Unprocessed food", stat(mean, count, sum, max, min, v, sem, p10, p25, med, p75, p90)
tabstat price if COICOP == "Non-energy industrial goods", stat(mean, count, sum, max, min, v, sem, p10, p25, med, p75, p90)
tabstat price if COICOP == "Energy", stat(mean, count, sum, max, min, v, sem, p10, p25, med, p75, p90)
tabstat price if COICOP == "Services overall index excluding goods", stat(mean, count, sum, max, min, v, sem, p10, p25, med, p75, p90)
tabstat price if COICOP == "Services - miscellaneous", stat(mean, count, sum, max, min, v, sem, p10, p25, med, p75, p90)
tabstat price if COICOP == "Administered prices", stat(mean, count, sum, max, min, v, sem, p10, p25, med, p75, p90)
tabstat price if COICOP == "Actual rentals for housing", stat(mean, count, sum, max, min, v, sem, p10, p25, med, p75, p90)


************************ 1. NON-ENERGY INDUSTRIAL GOODS ************************
generate time2 = _n
tsset time2

********1.A.: GENERAL RESULTS********

*Creating the relative weights of goods on level 4 or 5
//Creating a variable for goods on level 4 and 5
//(there are no items on level 4 which have level 5 subitems - I corrected it manually in the Excel)
gen goods_4_5 = goods if (level == 4 | level == 5) & correction != 1

//the total of weights in case of level 4 and 5 goods and period is 1
total weights if goods_4_5 == 1 & per == 1

//generating a variable with relative weigths if goods are on level 4 or 5
gen rel_w_goods = goods_4_5*weights/217.16 if per == 1

//everything is correct, the sum of the weights is 1
total rel_w_goods


//writing the name of the items to a new column if period is 1 and goods_4_5 == 1
gen abbr_goods = COICOP if per == 1 & goods_4_5 == 1 

//generate an empty variable
gen betas_goods_M7 = .
gen betas_goods_M1 = .

gen resid_goods = .
gen wnp_goods = .
gen resid_mean_goods = .

forvalues i = 1(1)506{
	gen rownumber = 74*(`i'-1)+1 //these are the lines where period == 1
	if COICOP[rownumber] == abbr_goods[rownumber] { //if the abbr is not empty in this row
	eststo: quietly regress price jan feb mar apr may jun jul aug sep oct nov M7_2020 M1_2021 if COICOP == abbr_goods[rownumber] //regress just the particular item
	replace betas_goods_M7 = _b[M7_2020] if _n == rownumber
	replace betas_goods_M1 = _b[M1_2021] if _n == rownumber
	predict resid, residuals
	replace resid_goods = resid if COICOP == abbr_goods[rownumber]
	quietly wntestq resid_goods if COICOP == abbr_goods[rownumber]
	replace wnp_goods = r(p) if _n == rownumber
	quietly sum resid_goods if COICOP == abbr_goods[rownumber]
	replace resid_mean_goods = r(mean) if _n == rownumber
	est clear
	drop resid
	}
	drop rownumber
}

gen rel_goods_x_betas_M7 = rel_w_goods*betas_goods_M7
total rel_goods_x_betas_M7 //the total effect with interval forecast

gen rel_goods_x_betas_M1 = rel_w_goods*betas_goods_M1
total rel_goods_x_betas_M1 //the total effect with interval forecast

//how times autocorrelation has remained in the residuals
count if wnp_goods != . //all
count if wnp_goods != . & wnp_goods < 0.05 //when we reject that residuals are WN (alfa = 5%)

//checking the means of residuals for each item
tab resid_mean_goods

********1.B.: REDUCED ITEMS********


*Creating the relative weights of goods on level 4 or 5
//Creating a variable for goods on level 4 and 5
//(there are no items on level 4 which have level 5 subitems - I corrected it manually in the Excel)
gen goods_4_5_red = goods if (level == 4 | level == 5) & red == 1 & correction != 1

//the total of weights in case of level 4 and 5 goods and period is 1
total weights if goods_4_5_red == 1 & per == 1

//generating a variable with relative weigths if goods are on level 4 or 5
gen rel_w_goods_red = goods_4_5_red*weights/18.75 if per == 1

//everything is correct, the sum of the weights is 1
total rel_w_goods_red


//writing the name of the items to a new column if period is 1 and goods_4_5 == 1
gen abbr_goods_red = COICOP if per == 1 & goods_4_5_red == 1 

//generate two empty variables
gen betas_goods_red_M7 = .
gen betas_goods_red_M1 = .



forvalues i = 1(1)506{
	gen rownumber = 74*(`i'-1)+1 //these are the lines where period == 1
	*disp rownumber
	if COICOP[rownumber] == abbr_goods_red[rownumber] { //if the abbr is not empty in this row
	*disp abbr[rownumber]
	eststo: quietly regress price jan feb mar apr may jun jul aug sep oct nov M7_2020 M1_2021 if COICOP == abbr_goods_red[rownumber] //regress just the particular item
	replace betas_goods_red_M7 = _b[M7_2020] if _n == rownumber
	replace betas_goods_red_M1 = _b[M1_2021] if _n == rownumber
	*replace betas = _b[M7_2020] in rownumber //save the beta of the effect of VAT change to a new variable
	*disp _b[M7_2020]
	est clear
	}
	*else if COICOP != abbr[rownumber] {
	*generate betas`i' = .}
	drop rownumber
	*disp "end"
}

gen rel_goods_x_betas_red_M7 = rel_w_goods_red*betas_goods_red_M7
total rel_goods_x_betas_red_M7 //the total effect with interval forecast

gen rel_goods_x_betas_red_M1 = rel_w_goods_red*betas_goods_red_M1
total rel_goods_x_betas_red_M1 //the total effect with interval forecast



********1.C.: NORMAL ITEMS********


*Creating the relative weights of goods on level 4 or 5
//Creating a variable for goods on level 4 and 5
//(there are no items on level 4 which have level 5 subitems - I corrected it manually in the Excel)
gen goods_4_5_norm = goods if (level == 4 | level == 5) & norm == 1 & correction != 1

//the total of weights in case of level 4 and 5 goods and period is 1
total weights if goods_4_5_norm == 1 & per == 1

//generating a variable with relative weigths if goods are on level 4 or 5
gen rel_w_goods_norm = goods_4_5_norm*weights/198.41 if per == 1

//everything is correct, the sum of the weights is 1
total rel_w_goods_norm


//writing the name of the items to a new column if period is 1 and goods_4_5 == 1
gen abbr_goods_norm = COICOP if per == 1 & goods_4_5_norm == 1 

//generate two empty variables
gen betas_goods_norm_M7 = .
gen betas_goods_norm_M1 = .



forvalues i = 1(1)506{
	gen rownumber = 74*(`i'-1)+1 //these are the lines where period == 1
	if COICOP[rownumber] == abbr_goods_norm[rownumber] { //if the abbr is not empty in this row
	eststo: quietly regress price jan feb mar apr may jun jul aug sep oct nov M7_2020 M1_2021 if COICOP == abbr_goods_norm[rownumber] //regress just the particular item
	replace betas_goods_norm_M7 = _b[M7_2020] if _n == rownumber
	replace betas_goods_norm_M1 = _b[M1_2021] if _n == rownumber
	est clear
	}
	drop rownumber
}

gen rel_goods_x_betas_norm_M7 = rel_w_goods_norm*betas_goods_norm_M7
total rel_goods_x_betas_norm_M7 //the total effect with interval forecast

gen rel_goods_x_betas_norm_M1 = rel_w_goods_norm*betas_goods_norm_M1
total rel_goods_x_betas_norm_M1 //the total effect with interval forecast


************************ Some more statistics ************************

tabstat betas_goods_M7 , stat(mean, count, sum, max, min, v, cv, sem, p10, p25, med, p75, p90)
tabstat betas_goods_M1 , stat(mean, count, sum, max, min, v, cv, sem, p10, p25, med, p75, p90)
tabstat betas_goods_red_M7 , stat(mean, count, sum, max, min, v, cv, sem, p10, p25, med, p75, p90)
tabstat betas_goods_red_M1 , stat(mean, count, sum, max, min, v, cv, sem, p10, p25, med, p75, p90)
tabstat betas_goods_norm_M7 , stat(mean, count, sum, max, min, v, cv, sem, p10, p25, med, p75, p90)
tabstat betas_goods_norm_M1 , stat(mean, count, sum, max, min, v, cv, sem, p10, p25, med, p75, p90)



************************ 2. PROCESSED FOOD ************************


********2.A.: GENERAL RESULTS********

*Creating the relative weights of goods on level 4 or 5
//Creating a variable for goods on level 4 and 5
//(there are no items on level 4 which have level 5 subitems - I corrected it manually in the Excel)
gen pfood_4_5 = pfood if (level == 4 | level == 5) & correction != 1

//the total of weights in case of level 4 and 5 pfood and period is 1
total weights if pfood_4_5 == 1 & per == 1

//generating a variable with relative weigths if pfood are on level 4 or 5
gen rel_w_pfood = pfood_4_5*weights/55.11  if per == 1

//everything is correct, the sum of the weights is 1
total rel_w_pfood


//writing the name of the items to a new column if period is 1 and pfood_4_5 == 1
gen abbr_pfood = COICOP if per == 1 & pfood_4_5 == 1 

//generate an empty variable
gen betas_pfood_M7 = .
gen betas_pfood_M1 = .

gen resid_pfood = .
gen wnp_pfood = .
gen resid_mean_pfood = .

forvalues i = 1(1)506{
	gen rownumber = 74*(`i'-1)+1 //these are the lines where period == 1
	if COICOP[rownumber] == abbr_pfood[rownumber] { //if the abbr is not empty in this row
	eststo: quietly regress price jan feb mar apr may jun jul aug sep oct nov M7_2020 M1_2021 if COICOP == abbr_pfood[rownumber] //regress just the particular item
	replace betas_pfood_M7 = _b[M7_2020] if _n == rownumber
	replace betas_pfood_M1 = _b[M1_2021] if _n == rownumber
	predict resid, residuals
	replace resid_pfood = resid if COICOP == abbr_pfood[rownumber]
	quietly wntestq resid_pfood if COICOP == abbr_pfood[rownumber]
	replace wnp_pfood = r(p) if _n == rownumber
	quietly sum resid_pfood if COICOP == abbr_pfood[rownumber]
	replace resid_mean_pfood = r(mean) if _n == rownumber
	est clear
	drop resid
	}
	drop rownumber
}

gen rel_pfood_x_betas_M7 = rel_w_pfood*betas_pfood_M7
total rel_pfood_x_betas_M7 //the total effect with interval forecast

gen rel_pfood_x_betas_M1 = rel_w_pfood*betas_pfood_M1
total rel_pfood_x_betas_M1 //the total effect with interval forecast

//how times autocorrelation has remained in the residuals
count if wnp_pfood != . //all
count if wnp_pfood != . & wnp_pfood < 0.05 //when we reject that residuals are WN (alfa = 5%)

//checking the means of residuals for each item
tab resid_mean_pfood

********2.B.: REDUCED ITEMS********


*Creating the relative weights of pfood on level 4 or 5
//Creating a variable for pfood on level 4 and 5
//(there are no items on level 4 which have level 5 subitems - I corrected it manually in the Excel)
gen pfood_4_5_red = pfood if (level == 4 | level == 5) & red == 1 & correction != 1

//the total of weights in case of level 4 and 5 pfood and period is 1
total weights if pfood_4_5_red == 1 & per == 1

//generating a variable with relative weigths if pfood are on level 4 or 5
gen rel_w_pfood_red = pfood_4_5_red*weights/39.36 if per == 1

//everything is correct, the sum of the weights is 1
total rel_w_pfood_red


//writing the name of the items to a new column if period is 1 and pfood_4_5 == 1
gen abbr_pfood_red = COICOP if per == 1 & pfood_4_5_red == 1 

//generate two empty variables
gen betas_pfood_red_M7 = .
gen betas_pfood_red_M1 = .



forvalues i = 1(1)506{
	gen rownumber = 74*(`i'-1)+1 //these are the lines where period == 1
	*disp rownumber
	if COICOP[rownumber] == abbr_pfood_red[rownumber] { //if the abbr is not empty in this row
	*disp abbr[rownumber]
	eststo: quietly regress price jan feb mar apr may jun jul aug sep oct nov M7_2020 M1_2021 if COICOP == abbr_pfood_red[rownumber] //regress just the particular item
	replace betas_pfood_red_M7 = _b[M7_2020] if _n == rownumber
	replace betas_pfood_red_M1 = _b[M1_2021] if _n == rownumber
	*replace betas = _b[M7_2020] in rownumber //save the beta of the effect of VAT change to a new variable
	*disp _b[M7_2020]
	est clear
	}
	*else if COICOP != abbr[rownumber] {
	*generate betas`i' = .}
	drop rownumber
	*disp "end"
}

gen rel_pfood_x_betas_red_M7 = rel_w_pfood_red*betas_pfood_red_M7
total rel_pfood_x_betas_red_M7 //the total effect with interval forecast

gen rel_pfood_x_betas_red_M1 = rel_w_pfood_red*betas_pfood_red_M1
total rel_pfood_x_betas_red_M1 //the total effect with interval forecast



********2.C.: NORMAL ITEMS********


*Creating the relative weights of pfood on level 4 or 5
//Creating a variable for pfood on level 4 and 5
//(there are no items on level 4 which have level 5 subitems - I corrected it manually in the Excel)
gen pfood_4_5_norm = pfood if (level == 4 | level == 5) & norm == 1 & correction != 1

//the total of weights in case of level 4 and 5 pfood and period is 1
total weights if pfood_4_5_norm == 1 & per == 1

//generating a variable with relative weigths if pfood are on level 4 or 5
gen rel_w_pfood_norm = pfood_4_5_norm*weights/15.75 if per == 1

//everything is correct, the sum of the weights is 1
total rel_w_pfood_norm


//writing the name of the items to a new column if period is 1 and pfood_4_5 == 1
gen abbr_pfood_norm = COICOP if per == 1 & pfood_4_5_norm == 1 

//generate two empty variables
gen betas_pfood_norm_M7 = .
gen betas_pfood_norm_M1 = .



forvalues i = 1(1)506{
	gen rownumber = 74*(`i'-1)+1 //these are the lines where period == 1
	if COICOP[rownumber] == abbr_pfood_norm[rownumber] { //if the abbr is not empty in this row
	eststo: quietly regress price jan feb mar apr may jun jul aug sep oct nov M7_2020 M1_2021 if COICOP == abbr_pfood_norm[rownumber] //regress just the particular item
	replace betas_pfood_norm_M7 = _b[M7_2020] if _n == rownumber
	replace betas_pfood_norm_M1 = _b[M1_2021] if _n == rownumber
	est clear
	}
	drop rownumber
}

gen rel_pfood_x_betas_norm_M7 = rel_w_pfood_norm*betas_pfood_norm_M7
total rel_pfood_x_betas_norm_M7 //the total effect with interval forecast

gen rel_pfood_x_betas_norm_M1 = rel_w_pfood_norm*betas_pfood_norm_M1
total rel_pfood_x_betas_norm_M1 //the total effect with interval forecast


************************ Some more statistics ************************

tabstat betas_pfood_M7 , stat(mean, count, sum, max, min, v, cv, sem, p10, p25, med, p75, p90)
tabstat betas_pfood_M1 , stat(mean, count, sum, max, min, v, cv, sem, p10, p25, med, p75, p90)
tabstat betas_pfood_red_M7 , stat(mean, count, sum, max, min, v, cv, sem, p10, p25, med, p75, p90)
tabstat betas_pfood_red_M1 , stat(mean, count, sum, max, min, v, cv, sem, p10, p25, med, p75, p90)
tabstat betas_pfood_norm_M7 , stat(mean, count, sum, max, min, v, cv, sem, p10, p25, med, p75, p90)
tabstat betas_pfood_norm_M1 , stat(mean, count, sum, max, min, v, cv, sem, p10, p25, med, p75, p90)




************************ 3. SERVICES ************************


************************ 3.A.: GENERAL RESULTS ************************

*Creating the relative weights of services on level 4 or 5
//Creating a variable for services on level 4 and 5
//(there are no items on level 4 which have level 5 subitems - I corrected it manually in the Excel)
gen service_4_5 = service if (level == 4 | level == 5) & correction != 1

//the total of weights in case of level 4 and 5 service and period is 1
total weights if service_4_5 == 1 & per == 1

//generating a variable with relative weigths if service are on level 4 or 5
gen rel_w_service = service_4_5*weights/176.88 if per == 1

//everything is correct, the sum of the weights is 1
total rel_w_service


//writing the name of the items to a new column if period is 1 and service_4_5 == 1
gen abbr_service = COICOP if per == 1 & service_4_5 == 1 

//generate an empty variable
gen betas_service_M7 = .
gen betas_service_M1 = .

forvalues i = 1(1)506{
	gen rownumber = 74*(`i'-1)+1 //these are the lines where period == 1
	if COICOP[rownumber] == abbr_service[rownumber] { //if the abbr is not empty in this row
	eststo: quietly regress price jan feb mar apr may jun jul aug sep oct nov M7_2020 M1_2021 if COICOP == abbr_service[rownumber] //regress just the particular item
	replace betas_service_M7 = _b[M7_2020] if _n == rownumber
	replace betas_service_M1 = _b[M1_2021] if _n == rownumber
	est clear
	}
	drop rownumber
}

gen rel_service_x_betas_M7 = rel_w_service*betas_service_M7
total rel_service_x_betas_M7 //the total effect with interval forecast

gen rel_service_x_betas_M1 = rel_w_service*betas_service_M1
total rel_service_x_betas_M1 //the total effect with interval forecast


************************ 3.A.2.: GENERAL RESULTS WITHOUT TAXFREE ITEMS ************************

*Creating the relative weights of services on level 4 or 5
//Creating a variable for services on level 4 and 5
//(there are no items on level 4 which have level 5 subitems - I corrected it manually in the Excel)
gen service_4_5_notaxfree = service if (level == 4 | level == 5) & correction != 1 & taxfree != 1

//the total of weights in case of level 4 and 5 service and period is 1
total weights if service_4_5_notaxfree == 1 & per == 1

//generating a variable with relative weigths if service are on level 4 or 5
gen rel_w_service_notaxfree = service_4_5_notaxfree*weights/131.12 if per == 1

//everything is correct, the sum of the weights is 1
total rel_w_service_notaxfree


//writing the name of the items to a new column if period is 1 and service_4_5 == 1
gen abbr_service_notaxfree = COICOP if per == 1 & service_4_5_notaxfree == 1 

//generate an empty variable
gen betas_service_notaxfree_M7 = .
gen betas_service_notaxfree_M1 = .
gen betas_service_taxfree2 = .

gen resid_service_notaxfree = .
gen wnp_service_notaxfree = .
gen resid_mean_service_notaxfree = .


forvalues i = 1(1)506{
	gen rownumber = 74*(`i'-1)+1 //these are the lines where period == 1
	if COICOP[rownumber] == abbr_service_notaxfree[rownumber] { //if the abbr is not empty in this row
	eststo: quietly regress price jan feb mar apr may jun jul aug sep oct nov M7_2020 M1_2021 if COICOP == abbr_service_notaxfree[rownumber] //regress just the particular item
	replace betas_service_notaxfree_M7 = _b[M7_2020] if _n == rownumber
	replace betas_service_notaxfree_M1 = _b[M1_2021] if _n == rownumber
	predict resid, residuals
	replace resid_service_notaxfree = resid if COICOP == abbr_service_notaxfree[rownumber]
	quietly wntestq resid_service_notaxfree if COICOP == abbr_service_notaxfree[rownumber]
	replace wnp_service_notaxfree = r(p) if _n == rownumber
	quietly sum resid_service_notaxfree if COICOP == abbr_service_notaxfree[rownumber]
	replace resid_mean_service_notaxfree = r(mean) if _n == rownumber
	est clear
	drop resid
	}
	drop rownumber
}

gen rel_service_x_betas_notaxfree_M7 = rel_w_service_notaxfree*betas_service_notaxfree_M7
total rel_service_x_betas_notaxfree_M7 //the total effect with interval forecast

gen rel_service_x_betas_notaxfree_M1 = rel_w_service_notaxfree*betas_service_notaxfree_M1
total rel_service_x_betas_notaxfree_M1 //the total effect with interval forecast

//how times autocorrelation has remained in the residuals
count if wnp_service_notaxfree != . //all
count if wnp_service_notaxfree != . & wnp_service_notaxfree < 0.05 //when we reject that residuals are WN (alfa = 5%)

//checking the means of residuals for each item
tab resid_mean_service_notaxfree

************************ 3.B.: REDUCED ITEMS ************************


*Creating the relative weights of service on level 4 or 5
//Creating a variable for service on level 4 and 5
//(there are no items on level 4 which have level 5 subitems - I corrected it manually in the Excel)
gen service_4_5_red = service if (level == 4 | level == 5) & red == 1 & correction != 1

//the total of weights in case of level 4 and 5 service and period is 1
total weights if service_4_5_red == 1 & per == 1

//generating a variable with relative weigths if service are on level 4 or 5
gen rel_w_service_red = service_4_5_red*weights/9.7 if per == 1

//everything is correct, the sum of the weights is 1
total rel_w_service_red


//writing the name of the items to a new column if period is 1 and service_4_5 == 1
gen abbr_service_red = COICOP if per == 1 & service_4_5_red == 1 

//generate two empty variables
gen betas_service_red_M7 = .
gen betas_service_red_M1 = .



forvalues i = 1(1)506{
	gen rownumber = 74*(`i'-1)+1 //these are the lines where period == 1
	*disp rownumber
	if COICOP[rownumber] == abbr_service_red[rownumber] { //if the abbr is not empty in this row
	*disp abbr[rownumber]
	eststo: quietly regress price jan feb mar apr may jun jul aug sep oct nov M7_2020 M1_2021 if COICOP == abbr_service_red[rownumber] //regress just the particular item
	replace betas_service_red_M7 = _b[M7_2020] if _n == rownumber
	replace betas_service_red_M1 = _b[M1_2021] if _n == rownumber
	*replace betas = _b[M7_2020] in rownumber //save the beta of the effect of VAT change to a new variable
	*disp _b[M7_2020]
	est clear
	}
	*else if COICOP != abbr[rownumber] {
	*generate betas`i' = .}
	drop rownumber
	*disp "end"
}

gen rel_service_x_betas_red_M7 = rel_w_service_red*betas_service_red_M7
total rel_service_x_betas_red_M7 //the total effect with interval forecast

gen rel_service_x_betas_red_M1 = rel_w_service_red*betas_service_red_M1
total rel_service_x_betas_red_M1 //the total effect with interval forecast



************************ 3.C.: NORMAL ITEMS ************************


*Creating the relative weights of service on level 4 or 5
//Creating a variable for service on level 4 and 5
//(there are no items on level 4 which have level 5 subitems - I corrected it manually in the Excel)
gen service_4_5_norm = service if (level == 4 | level == 5) & norm == 1 & correction != 1

//the total of weights in case of level 4 and 5 service and period is 1
total weights if service_4_5_norm == 1 & per == 1

//generating a variable with relative weigths if service are on level 4 or 5
gen rel_w_service_norm = service_4_5_norm*weights/100.47 if per == 1

//everything is correct, the sum of the weights is 1
total rel_w_service_norm


//writing the name of the items to a new column if period is 1 and service_4_5 == 1
gen abbr_service_norm = COICOP if per == 1 & service_4_5_norm == 1 

//generate two empty variables
gen betas_service_norm_M7 = .
gen betas_service_norm_M1 = .



forvalues i = 1(1)506{
	gen rownumber = 74*(`i'-1)+1 //these are the lines where period == 1
	if COICOP[rownumber] == abbr_service_norm[rownumber] { //if the abbr is not empty in this row
	eststo: quietly regress price jan feb mar apr may jun jul aug sep oct nov M7_2020 M1_2021 if COICOP == abbr_service_norm[rownumber] //regress just the particular item
	replace betas_service_norm_M7 = _b[M7_2020] if _n == rownumber
	replace betas_service_norm_M1 = _b[M1_2021] if _n == rownumber
	est clear
	}
	drop rownumber
}

gen rel_service_x_betas_norm_M7 = rel_w_service_norm*betas_service_norm_M7
total rel_service_x_betas_norm_M7 //the total effect with interval forecast

gen rel_service_x_betas_norm_M1 = rel_w_service_norm*betas_service_norm_M1
total rel_service_x_betas_norm_M1 //the total effect with interval forecast




************************ 3.D.: HOSPITALITY ************************


*Creating the relative weights of service on level 4 or 5
//Creating a variable for service on level 4 and 5
//(there are no items on level 4 which have level 5 subitems - I corrected it manually in the Excel)
gen service_4_5_hospitality = service if (level == 4 | level == 5) & hospitality == 1 & correction != 1

//the total of weights in case of level 4 and 5 service and period is 1
total weights if service_4_5_hospitality == 1 & per == 1

//generating a variable with relative weigths if service are on level 4 or 5
gen rel_w_service_hospitality = service_4_5_hospitality*weights/20.95 if per == 1

//everything is correct, the sum of the weights is 1
total rel_w_service_hospitality


//writing the name of the items to a new column if period is 1 and service_4_5 == 1
gen abbr_service_hospitality = COICOP if per == 1 & service_4_5_hospitality == 1 

//generate two empty variables
gen betas_service_hospitality_M7 = .
gen betas_service_hospitality_M1 = .



forvalues i = 1(1)506{
	gen rownumber = 74*(`i'-1)+1 //these are the lines where period == 1
	if COICOP[rownumber] == abbr_service_hospitality[rownumber] { //if the abbr is not empty in this row
	eststo: quietly regress price jan feb mar apr may jun jul aug sep oct nov M7_2020 M1_2021 if COICOP == abbr_service_hospitality[rownumber] //regress just the particular item
	replace betas_service_hospitality_M7 = _b[M7_2020] if _n == rownumber
	replace betas_service_hospitality_M1 = _b[M1_2021] if _n == rownumber
	est clear
	}
	drop rownumber
}

gen rel_service_x_betas_hosp_M7 = rel_w_service_hospitality*betas_service_hospitality_M7
total rel_service_x_betas_hosp_M7 //the total effect with interval forecast

gen rel_service_x_betas_hosp_M1 = rel_w_service_hospitality*betas_service_hospitality_M1
total rel_service_x_betas_hosp_M1 //the total effect with interval forecast


************************ 3.E.: VAT-FREE ITEMS ************************


*Creating the relative weights of service on level 4 or 5
//Creating a variable for service on level 4 and 5
//(there are no items on level 4 which have level 5 subitems - I corrected it manually in the Excel)
gen service_4_5_taxfree = service if (level == 4 | level == 5) & taxfree == 1 & correction != 1

//the total of weights in case of level 4 and 5 service and period is 1
total weights if service_4_5_taxfree == 1 & per == 1

//generating a variable with relative weigths if service are on level 4 or 5
gen rel_w_service_taxfree = service_4_5_taxfree*weights/45.76 if per == 1

//everything is correct, the sum of the weights is 1
total rel_w_service_taxfree


//writing the name of the items to a new column if period is 1 and service_4_5 == 1
gen abbr_service_taxfree = COICOP if per == 1 & service_4_5_taxfree == 1 

//generate two empty variables
gen betas_service_taxfree_M7 = .
gen betas_service_taxfree_M1 = .



forvalues i = 1(1)506{
	gen rownumber = 74*(`i'-1)+1 //these are the lines where period == 1
	if COICOP[rownumber] == abbr_service_taxfree[rownumber] { //if the abbr is not empty in this row
	eststo: quietly regress price jan feb mar apr may jun jul aug sep oct nov M7_2020 M1_2021 if COICOP == abbr_service_taxfree[rownumber] //regress just the particular item
	replace betas_service_taxfree_M7 = _b[M7_2020] if _n == rownumber
	replace betas_service_taxfree_M1 = _b[M1_2021] if _n == rownumber
	est clear
	}
	drop rownumber
}

//there is an outlier
tab COICOP  betas_service_taxfree_M1  if betas_service_taxfree_M1 != . //"Services to maintain people in their private homes "


gen rel_service_x_betas_taxfree_M7 = rel_w_service_taxfree*betas_service_taxfree_M7
total rel_service_x_betas_taxfree_M7 //the total effect with interval forecast

gen rel_service_x_betas_taxfree_M1 = rel_w_service_taxfree*betas_service_taxfree_M1 if COICOP != "Services to maintain people in their private homes "
total rel_service_x_betas_taxfree_M1 //the total effect with interval forecast


************************ Some more statistics ************************

tabstat betas_service_M7 , stat(mean, count, sum, max, min, v, cv, sem, p10, p25, med, p75, p90)
tabstat betas_service_M1 , stat(mean, count, sum, max, min, v, cv, sem, p10, p25, med, p75, p90)
tabstat betas_service_notaxfree_M7 , stat(mean, count, sum, max, min, v, cv, sem, p10, p25, med, p75, p90)
tabstat betas_service_notaxfree_M1 , stat(mean, count, sum, max, min, v, cv, sem, p10, p25, med, p75, p90)
tabstat betas_service_red_M7 , stat(mean, count, sum, max, min, v, cv, sem, p10, p25, med, p75, p90)
tabstat betas_service_red_M1 , stat(mean, count, sum, max, min, v, cv, sem, p10, p25, med, p75, p90)
tabstat betas_service_norm_M7 , stat(mean, count, sum, max, min, v, cv, sem, p10, p25, med, p75, p90)
tabstat betas_service_norm_M1 , stat(mean, count, sum, max, min, v, cv, sem, p10, p25, med, p75, p90)
tabstat betas_service_hospitality_M7 , stat(mean, count, sum, max, min, v, cv, sem, p10, p25, med, p75, p90)
tabstat betas_service_hospitality_M1 , stat(mean, count, sum, max, min, v, cv, sem, p10, p25, med, p75, p90)
tabstat betas_service_taxfree_M7 , stat(mean, count, sum, max, min, v, cv, sem, p10, p25, med, p75, p90)
tabstat betas_service_taxfree_M1 if COICOP != "Services to maintain people in their private homes ", stat(mean, count, sum, max, min, v, cv, sem, p10, p25, med, p75, p90)



*Summarizing all the results:
total rel_goods_x_betas_M7
total rel_goods_x_betas_M1
total rel_goods_x_betas_red_M7
total rel_goods_x_betas_red_M1
total rel_goods_x_betas_norm_M7
total rel_goods_x_betas_norm_M1

total rel_pfood_x_betas_M7
total rel_pfood_x_betas_M1
total rel_pfood_x_betas_red_M7
total rel_pfood_x_betas_red_M1
total rel_pfood_x_betas_norm_M7
total rel_pfood_x_betas_norm_M1

total rel_service_x_betas_M7
total rel_service_x_betas_M1
total rel_service_x_betas_red_M7
total rel_service_x_betas_red_M1
total rel_service_x_betas_norm_M7
total rel_service_x_betas_norm_M1
total rel_service_x_betas_hosp_M7
total rel_service_x_betas_hosp_M1
total rel_service_x_betas_taxfree_M7
total rel_service_x_betas_taxfree_M1



**If we accept that betas are the same in the processed food category
reg price M7_2020 M1_2021 jan feb mar apr may jun jul aug sep oct nov if pfood == 1
reg price M7_2020 M1_2021 jan feb mar apr may jun jul aug sep oct nov if pfood == 1 & norm == 1
reg price M7_2020 M1_2021 jan feb mar apr may jun jul aug sep oct nov if pfood == 1 & red == 1





************************* 4. Trendinflation ************************************

*The trendinflation prior to the pandemic (2019M3-2020M2)
gen trendinf = 1 if per > 50 & per < 63
replace trendinf = 0 if missing(trendinf)

//ez jó, csak még 10-szer meg kéne csinálni

gen rel_w_pfood_2 = pfood_4_5*weights/55.11
gen pfood_w_price = price*rel_w_pfood_2
total rel_w_pfood_2 // ez 74, ami a periódusok száma
total pfood_w_price  if trendinf == 1 & pfood == 1 & (level == 4 | level == 5) & correction != 1
disp 1.231435 / 12 //12 periódussal számolunk

gen rel_w_goods_2 = goods_4_5*weights/217.16
gen goods_w_price = price*rel_w_goods_2
total rel_w_goods_2 // ez 74, ami a periódusok száma
total goods_w_price  if trendinf == 1 & goods == 1 & (level == 4 | level == 5) & correction != 1
disp .9131825  / 12 //12 periódussal számolunk




