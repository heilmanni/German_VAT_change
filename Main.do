 /*This document is for analysing the effects of the temporary German VAT change.
 For data cleaning, I used a different .do file*/
 
 *Import the cleaned data
import excel "C:\Users\Istvan\Desktop\reshaped.xls", sheet("Sheet1") firstrow

*Change the format of the data by creating new ones and dropping old ones
gen weights = real(Weightinginpermill)
drop Weightinginpermill

forvalues i = 1(1)74 {
gen Per`i'  = real(TIME`i')
drop TIME`i'
}


************************ 1. Non-energy industrial goods ************************

***A: GENERAL CHANGES ***

*Creating the relative weights of goods on level 4 or 5
//Creating a variable for goods on level 4 and 5
//(there are no items on level 4 which have level 5 subitems - I corrected it manually in the Excel)
gen goods_4_5 = goods if (level == 4 | level == 5)

//the total of weights in case of level 4 and 5 goods
total weights if (goods == 1 & (level == 4 | level == 5))
//total weights if goods_4_5 == 1 is the same

//generating a variable with relative weigths if goods are on level 4 or 5
gen rel_w_goods = goods_4_5*weights/216.92

//everything is correct, the sum of the weights is 1
total rel_w_goods


*Creating a variable for the weighted monthly change
forvalues i = 1(1)74 {
gen wper`i'_goods  = rel_w_goods*Per`i'
}

//only for two period
*gen wper66_goods = rel_w_goods*Per66
*gen wper67_goods = rel_w_goods*Per67


*Calculating monthly price changes in different cases (2020M6 and M7)
total wper66_goods
total wper67_goods
total wper73_goods


***B: VAT rate reduced from 19 to 16 ***

//Creating a variable for goods on level 4 and 5 with normal VAT taxation
gen goods_4_5_norm = goods_4_5 if normal == 1

//the total of weights in case of level 4 and 5 goods
total weights if goods_4_5_norm == 1

//generating a variable with relative weigths if goods are on level 4 or 5
gen rel_w_goods_norm = goods_4_5_norm*weights/198.17 

//everything is correct, the sum of the weights is 1
total rel_w_goods_norm


*Creating a variable for the weighted monthly change
forvalues i = 1(1)74 {
gen wper`i'_norm_goods  = rel_w_goods_norm*Per`i'
}

*gen wper66_norm_goods = rel_w_goods_norm*Per66
*gen wper67_norm_goods = rel_w_goods_norm*Per67


*Calculating monthly price changes in different cases (2020M6 and M7)
total wper66_norm_goods
total wper67_norm_goods
total wper73_norm_goods


***C: VAT rate reduced from 7 to 5 ***

//Creating a variable for goods on level 4 and 5 with normal VAT taxation
gen goods_4_5_red = goods_4_5 if reduced == 1

//the total of weights in case of level 4 and 5 goods
total weights if goods_4_5_red == 1

//generating a variable with relative weigths if goods are on level 4 or 5
gen rel_w_goods_red = goods_4_5_red*weights/18.75

//everything is correct, the sum of the weights is 1
total rel_w_goods_red


*Creating a variable for the weighted monthly change
forvalues i = 1(1)74 {
gen wper`i'_red_goods  = rel_w_goods_red*Per`i'
}

*gen wper66_red_goods = rel_w_goods_red*Per66
*gen wper67_red_goods = rel_w_goods_red*Per67


*Calculating monthly price changes in different cases (2020M6 and M7)
total wper66_red_goods
total wper67_red_goods
total wper73_red_goods


*Main results
total wper66_goods
total wper67_goods
total wper73_goods
total wper66_norm_goods
total wper67_norm_goods
total wper73_norm_goods
total wper66_red_goods
total wper67_red_goods
total wper73_red_goods


************************ 2. Processed food ************************

***A: GENERAL CHANGES ***

*Creating the relative weights of goods on level 4 or 5
//Creating a variable for goods on level 4 and 5
//(there are no items on level 4 which have level 5 subitems - I corrected it manually in the Excel)
gen pfood_4_5 = pfood if (level == 4 | level == 5)

//the total of weights in case of level 4 and 5 goods
total weights if pfood_4_5 == 1

//generating a variable with relative weigths if goods are on level 4 or 5
gen rel_w_pfood = pfood_4_5*weights / 55.11

//everything is correct, the sum of the weights is 1
total rel_w_pfood


*Creating a variable for the weighted monthly change
forvalues i = 1(1)74 {
gen wper`i'_pfood  = rel_w_pfood*Per`i'
}

*gen wper66_pfood = rel_w_pfood *Per66
*gen wper67_pfood = rel_w_pfood *Per67


*Calculating monthly price changes in different cases (2020M6 and M7)
total wper66_pfood
total wper67_pfood
total wper73_pfood


***B: VAT rate reduced from 19 to 16 ***

//Creating a variable for goods on level 4 and 5 with normal VAT taxation
gen pfood_4_5_norm = pfood_4_5 if normal == 1

//the total of weights in case of level 4 and 5 goods
total weights if pfood_4_5_norm == 1

//generating a variable with relative weigths if goods are on level 4 or 5
gen rel_w_pfood_norm = pfood_4_5_norm*weights/15.75

//everything is correct, the sum of the weights is 1
total rel_w_pfood_norm


*Creating a variable for the weighted monthly change
forvalues i = 1(1)74 {
gen wper`i'_norm_pfood  = rel_w_pfood_norm*Per`i'
}

*gen wper66_norm_pfood = rel_w_pfood_norm*Per66
*gen wper67_norm_pfood = rel_w_pfood_norm*Per67


*Calculating monthly price changes in different cases (2020M6 and M7)
total wper66_norm_pfood
total wper67_norm_pfood
total wper73_norm_pfood


***C: VAT rate reduced from 7 to 5 ***

//Creating a variable for goods on level 4 and 5 with normal VAT taxation
gen pfood_4_5_red = pfood_4_5 if reduced == 1

//the total of weights in case of level 4 and 5 goods
total weights if pfood_4_5_red == 1

//generating a variable with relative weigths if goods are on level 4 or 5
gen rel_w_pfood_red = pfood_4_5_red*weights / 39.36

//everything is correct, the sum of the weights is 1
total rel_w_pfood_red

*Creating a variable for the weighted monthly change
forvalues i = 1(1)74 {
gen wper`i'_red_pfood  = rel_w_pfood_red*Per`i'
}


*Calculating monthly price changes in different cases (2020M6 and M7)
total wper66_red_pfood
total wper67_red_pfood
total wper73_red_pfood


*Main results
total wper66_pfood
total wper67_pfood
total wper73_pfood
total wper66_norm_pfood
total wper67_norm_pfood
total wper73_norm_pfood
total wper66_red_pfood
total wper67_red_pfood
total wper73_red_pfood



************************ 1/B Non-energy industrial goods, trends ************************

*The weights of each item is the same in each year - these variables have been created

*We need the average of the price change in July in 2015-2019


***A: GENERAL CHANGES ***

*Calculating monthly price changes
forvalues i = 1(1)74 {
egen tot_wper`i'_goods  = total(wper`i'_goods)
}

*The mean of the changes
disp (tot_wper1_goods + tot_wper13_goods + tot_wper25_goods + tot_wper37_goods + tot_wper49_goods) / 5 //January
disp (tot_wper6_goods + tot_wper18_goods + tot_wper30_goods + tot_wper42_goods + tot_wper54_goods) / 5 //June
disp (tot_wper7_goods + tot_wper19_goods + tot_wper31_goods + tot_wper43_goods + tot_wper55_goods) / 5 //July


***B: VAT rate reduced from 19 to 16 ***

*Calculating monthly price changes
forvalues i = 1(1)74 {
egen tot_wper`i'_norm_goods  = total(wper`i'_norm_goods)
}

*The mean of the changes
disp (tot_wper1_norm_goods + tot_wper13_norm_goods + tot_wper25_norm_goods + tot_wper37_norm_goods + tot_wper49_norm_goods) / 5 //January
disp (tot_wper6_norm_goods + tot_wper18_norm_goods + tot_wper30_norm_goods + tot_wper42_norm_goods + tot_wper54_norm_goods) / 5 //June
disp (tot_wper7_norm_goods + tot_wper19_norm_goods + tot_wper31_norm_goods + tot_wper43_norm_goods + tot_wper55_norm_goods) / 5 //July


***C: VAT rate reduced from 7 to 5 ***

*Calculating monthly price changes
forvalues i = 1(1)74 {
egen tot_wper`i'_red_goods  = total(wper`i'_red_goods)
}

*The mean of the changes
disp (tot_wper1_red_goods + tot_wper13_red_goods + tot_wper25_red_goods + tot_wper37_red_goods + tot_wper49_red_goods) / 5 //January
disp (tot_wper6_red_goods + tot_wper18_red_goods + tot_wper30_red_goods + tot_wper42_red_goods + tot_wper54_red_goods) / 5 //June
disp (tot_wper7_red_goods + tot_wper19_red_goods + tot_wper31_red_goods + tot_wper43_red_goods + tot_wper55_red_goods) / 5 //July



************************ 2/B Processed food, trends ************************

*The weights of each item is the same in each year - these variables have been created

*We need the average of the price change in July in 2015-2019


***A: GENERAL CHANGES ***

*Calculating monthly price changes
forvalues i = 1(1)74 {
egen tot_wper`i'_pfood  = total(wper`i'_pfood)
}

*The mean of the changes
disp (tot_wper1_pfood + tot_wper13_pfood + tot_wper25_pfood + tot_wper37_pfood + tot_wper49_pfood) / 5 //January
disp (tot_wper6_pfood + tot_wper18_pfood + tot_wper30_pfood + tot_wper42_pfood + tot_wper54_pfood) / 5 //June
disp (tot_wper7_pfood + tot_wper19_pfood + tot_wper31_pfood + tot_wper43_pfood + tot_wper55_pfood) / 5 //July

***B: VAT rate reduced from 19 to 16 ***

*Calculating monthly price changes
forvalues i = 1(1)74 {
egen tot_wper`i'_norm_pfood  = total(wper`i'_norm_pfood)
}

*The mean of the changes
disp (tot_wper1_norm_pfood + tot_wper13_norm_pfood + tot_wper25_norm_pfood + tot_wper37_norm_pfood + tot_wper49_norm_pfood) / 5 //January
disp (tot_wper6_norm_pfood + tot_wper18_norm_pfood + tot_wper30_norm_pfood + tot_wper42_norm_pfood + tot_wper54_norm_pfood) / 5 //June
disp (tot_wper7_norm_pfood + tot_wper19_norm_pfood + tot_wper31_norm_pfood + tot_wper43_norm_pfood + tot_wper55_norm_pfood) / 5 //July

***C: VAT rate reduced from 7 to 5 ***

*Calculating monthly price changes
forvalues i = 1(1)74 {
egen tot_wper`i'_red_pfood  = total(wper`i'_red_pfood)
}

*The mean of the changes
disp (tot_wper1_red_pfood + tot_wper13_red_pfood + tot_wper25_red_pfood + tot_wper37_red_pfood + tot_wper49_red_pfood) / 5 //January
disp (tot_wper6_red_pfood + tot_wper18_red_pfood + tot_wper30_red_pfood + tot_wper42_red_pfood + tot_wper54_red_pfood) / 5 //June
disp (tot_wper7_red_pfood + tot_wper19_red_pfood + tot_wper31_red_pfood + tot_wper43_red_pfood + tot_wper55_red_pfood) / 5 //July
