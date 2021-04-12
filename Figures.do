*This document is for visualizing my data and time series



*******************0. DATA IMPORT ***************

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

gen date = per + 659
xtset date
format date %tm

****************************** FIGURES *****************************************

************************** 1. Non-energy industrial goods **********************


*Creating the relative weights of goods on level 4 or 5
//Creating a variable for goods on level 4 and 5
//correction means that those level 4 items are not included which have level 5 subitems
gen goods_4_5 = goods if (level == 4 | level == 5 ) & correction != 1
gen goods_4_5_norm = goods if (level == 4 | level == 5 ) & correction != 1 & normal == 1
gen goods_4_5_red = goods if (level == 4 | level == 5 ) & correction != 1 & reduced == 1


//the total of weights in case of level 4 and 5 goods and period is 1
total weights if goods_4_5 == 1 & per == 1
total weights if goods_4_5_norm == 1 & per == 1
total weights if goods_4_5_red == 1 & per == 1

//the weighted monthly change
gen rel_w_goods_2 = goods_4_5*weights/217.16
gen goods_w_price = price*rel_w_goods_2

gen rel_w_goods_norm_2 = goods_4_5_norm*weights/198.41 
gen goods_w_price_norm = price*rel_w_goods_norm_2

gen rel_w_goods_red_2 = goods_4_5_red*weights/18.75
gen goods_w_price_red = price*rel_w_goods_red_2

gen aggr_goods = price if COICOP == "Non-energy industrial goods"

//checking: the total must be 1
total rel_w_goods_2 if per == 1
total rel_w_goods_norm_2 if per == 1
total rel_w_goods_red_2 if per == 1



//counting the average of particular items in each period
collapse (sum) aggr_goods goods_w_price goods_w_price_norm goods_w_price_red if goods_4_5 == 1 | goods_4_5_norm == 1 | goods_4_5_red == 1 | COICOP == "Non-energy industrial goods", by(date)

*Figures

cd "c:\Users\Istvan\Documents\BCE Mester\Szakdolgozat\Ábrák"

//official vs created
twoway connected aggr_goods goods_w_price date, sort xtitle("Period") ytitle("Average monthly change (logpercent)")legend(label(1 "official") label(2 "constructed")) lcolor(edkblue erose) mcolor(edkblue erose) title("Non-energy industrial goods: official and created")
twoway connected aggr_goods goods_w_price date, sort xtitle("Dátum") ytitle("Havi átlagos változás (logszázalék)")legend(label(1 "hivatalos") label(2 "szerkesztett")) lcolor(edkblue erose) mcolor(edkblue erose) title("Nem energetikai ipari termékek")
//Export
graph export 1a_goods_off_created.png

//whole category and normal
twoway connected goods_w_price goods_w_price_norm date, sort xtitle("Dátum") ytitle("Havi átlagos változás (logszázalék)")legend(label(1 "teljes (szerkesztett)") label(2 "sztenderd áfa-kulcsú termékek")) lcolor(edkblue erose) mcolor(edkblue erose) title("Nem energetikai ipari termékek: teljes és normál áfa-kulcsú")
//Export
graph export 1b_goods_gen_norm.png

//whole category and reduced
twoway connected goods_w_price goods_w_price_red date, sort xtitle("Dátum") ytitle("Havi átlagos változás (logszázalék)")legend(label(1 "teljes (szerkesztett)") label(2 "csökkentett áfa-kulcsú termékek")) lcolor(edkblue erose) mcolor(edkblue erose) title("Nem energetikai ipari termékek: teljes és csökkentett áfa-kulcsú")
//Export
graph export 1c_goods_gen_red.png

//whole, normal and reduced
twoway connected goods_w_price goods_w_price_norm goods_w_price_red date, sort xtitle("Dátum") ytitle("Havi átlagos változás (logszázalék)")legend(label(1 "teljes (szerkesztett)") label(2 "sztenderd áfa-kulcsú termékek") label(3 "csökkentett áfa-kulcsú")) lcolor(edkblue erose eltgreen) mcolor(edkblue erose eltgreen) subtitle("Nem energetikai ipari termékek összehasonlítása áfa-kulcsonként")
graph export 1d_goods_gen_norm_red.png

//normal and reduced
twoway connected goods_w_price_norm goods_w_price_red date, sort xtitle("Dátum") ytitle("Havi átlagos változás (logszázalék)")legend(label(1 "sztenderd áfa-kulcs") label(2 "csökkentett áfa-kulcs")) lcolor(edkblue erose) mcolor(edkblue erose) subtitle("Nem energetikai ipari termékek: sztenderd és csökkentett áfa-kulcs")
//Export
graph export 1e_goods_norm_red.png



******* Reloading the data ************
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

gen date = per + 659
xtset date
format date %tm



********************************** 2. Processed food ******************************


*Creating the relative weights of goods on level 4 or 5
//Creating a variable for goods on level 4 and 5
//correction means that those level 4 items are not included which have level 5 subitems
gen pfood_4_5 = pfood if (level == 4 | level == 5 ) & correction != 1
gen pfood_4_5_norm = pfood if (level == 4 | level == 5 ) & correction != 1 & normal == 1
gen pfood_4_5_red = pfood if (level == 4 | level == 5 ) & correction != 1 & reduced == 1


//the total of weights in case of level 4 and 5 pfood and period is 1
total weights if pfood_4_5 == 1 & per == 1
total weights if pfood_4_5_norm == 1 & per == 1
total weights if pfood_4_5_red == 1 & per == 1

//the weighted monthly change
gen rel_w_pfood_2 = pfood_4_5*weights / 55.11
gen pfood_w_price = price*rel_w_pfood_2

gen rel_w_pfood_norm_2 = pfood_4_5_norm*weights / 15.75 
gen pfood_w_price_norm = price*rel_w_pfood_norm_2

gen rel_w_pfood_red_2 = pfood_4_5_red*weights / 39.36
gen pfood_w_price_red = price*rel_w_pfood_red_2

gen aggr_pfood = price if COICOP == "Processed food excluding alcohol and tobacco"

//checking: the total must be 1
total rel_w_pfood_2 if per == 1
total rel_w_pfood_norm_2 if per == 1
total rel_w_pfood_red_2 if per == 1



//counting the average of particular items in each period
collapse (sum) aggr_pfood pfood_w_price pfood_w_price_norm pfood_w_price_red if pfood_4_5 == 1 | pfood_4_5_norm == 1 | pfood_4_5_red == 1 | COICOP == "Processed food excluding alcohol and tobacco", by(date)

*Figures

cd "c:\Users\Istvan\Documents\BCE Mester\Szakdolgozat\Ábrák"

//official vs created
twoway connected aggr_pfood pfood_w_price date, sort xtitle("Period") ytitle("Average monthly change (logpercent)")legend(label(1 "official") label(2 "constructed")) lcolor(edkblue erose) mcolor(edkblue erose) title("Processed food")
twoway connected aggr_pfood pfood_w_price date, sort xtitle("Dátum") ytitle("Havi átlagos változás (logszázalék)")legend(label(1 "hivatalos") label(2 "szerkesztett")) lcolor(edkblue erose) mcolor(edkblue erose) title("Feldolgozott élelmiszerek")
//Export
graph export 2a_pfood_off_created.png

//whole category and normal
twoway connected pfood_w_price pfood_w_price_norm date, sort xtitle("Dátum") ytitle("Havi átlagos változás (logszázalék)")legend(label(1 "teljes (szerkesztett)") label(2 "sztenderd áfa-kulcsú termékek")) lcolor(edkblue erose) mcolor(edkblue erose) title("Feldolgozott élelmiszerek")
//Export
graph export 2b_pfood_gen_norm.png

//whole category and reduced
twoway connected pfood_w_price pfood_w_price_red date, sort xtitle("Dátum") ytitle("Havi átlagos változás (logszázalék)")legend(label(1 "teljes (szerkesztett)") label(2 "csökkentett áfa-kulcsú termékek")) lcolor(edkblue erose) mcolor(edkblue erose) title("Feldolgozott élelmiszerek")
//Export
graph export 2c_pfood_gen_red.png

//whole, normal and reduced
twoway connected pfood_w_price pfood_w_price_norm pfood_w_price_red date, sort xtitle("Dátum") ytitle("Havi átlagos változás (logszázalék)")legend(label(1 "teljes (szerkesztett)") label(2 "sztenderd áfa-kulcsú termékek") label(3 "csökkentett áfa-kulcsú")) lcolor(edkblue erose eltgreen) mcolor(edkblue erose eltgreen) subtitle("Feldolgozott élelmiszerek összehasonlítása áfa-kulcsonként")
//Export
graph export 2d_pfood_gen_norm_red.png

//normal and reduced
twoway connected pfood_w_price_norm pfood_w_price_red date, sort xtitle("Dátum") ytitle("Havi átlagos változás (logszázalék)")legend(label(1 "sztenderd áfa-kulcs") label(2 "csökkentett áfa-kulcs")) lcolor(edkblue erose) mcolor(edkblue erose) subtitle("Feldolgozott élelmiszerek: sztenderd és csökkentett áfa-kulcs")
//Export
graph export 2e_pfood_norm_red.png


******* Reloading the data ************
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

gen date = per + 659
xtset date
format date %tm



********************************** 3. Services ******************************


*Creating the relative weights of service on level 4 or 5
//Creating a variable for services on level 4 and 5
//correction means that those level 4 items are not included which have level 5 subitems
gen service_4_5 = service if (level == 4 | level == 5 ) & correction != 1
gen service_4_5_norm = service if (level == 4 | level == 5 ) & correction != 1 & normal == 1
gen service_4_5_red = service if (level == 4 | level == 5 ) & correction != 1 & reduced == 1
gen service_4_5_hosp = service if (level == 4 | level == 5 ) & correction != 1 & hospitality == 1
gen service_4_5_taxfree = service if (level == 4 | level == 5 ) & correction != 1 & taxfree == 1

//the total of weights in case of level 4 and 5 service and period is 1
total weights if service_4_5 == 1 & per == 1
total weights if service_4_5_norm == 1 & per == 1
total weights if service_4_5_red == 1 & per == 1
total weights if service_4_5_hosp == 1 & per == 1
total weights if service_4_5_taxfree == 1 & per == 1


//the weighted monthly change
gen rel_w_service_2 = service_4_5*weights / 176.88 
gen service_w_price = price*rel_w_service_2

gen rel_w_service_norm_2 = service_4_5_norm*weights / 100.47
gen service_w_price_norm = price*rel_w_service_norm_2

gen rel_w_service_red_2 = service_4_5_red*weights / 9.7
gen service_w_price_red = price*rel_w_service_red_2

gen rel_w_service_hosp_2 = service_4_5_hosp*weights / 20.95 
gen service_w_price_hosp = price*rel_w_service_hosp_2

gen rel_w_service_taxfree_2 = service_4_5_taxfree*weights / 45.76
gen service_w_price_taxfree = price*rel_w_service_taxfree_2

gen aggr_service_1 = price if COICOP == "Services - miscellaneous"
gen aggr_service_2 = price if COICOP == "Services overall index excluding goods"
gen aggr_service_3 = price if COICOP == "Services related to recreation and personal care, excluding package holidays and accommodation"

//checking: the total must be 1
total rel_w_service_2 if per == 1
total rel_w_service_norm_2 if per == 1
total rel_w_service_red_2 if per == 1
total rel_w_service_hosp_2 if per == 1
total rel_w_service_taxfree_2 if per == 1


//counting the average of particular items in each period
collapse (sum) aggr_service_1 aggr_service_2 aggr_service_3 service_w_price service_w_price_norm service_w_price_red service_w_price_hosp service_w_price_taxfree if service_4_5 == 1 | service_4_5_norm == 1 | service_4_5_red == 1 | service_4_5_hosp == 1 | service_4_5_taxfree == 1 | COICOP == "Services - miscellaneous" | COICOP == "Services overall index excluding goods" | COICOP == "Services related to recreation and personal care, excluding package holidays and accommodation", by(date)

*Figures

cd "c:\Users\Istvan\Documents\BCE Mester\Szakdolgozat\Ábrák"

//official vs created
twoway connected aggr_service_2 service_w_price date, sort xtitle("Period") ytitle("Average monthly change (logpercent)")legend(label(1 "official") label(2 "constructed")) lcolor(edkblue erose) mcolor(edkblue erose) title("Services")
twoway connected aggr_service_2 service_w_price date, sort xtitle("Dátum") ytitle("Havi átlagos változás (logszázalék)")legend(label(1 "hivatalos") label(2 "szerkesztett")) lcolor(edkblue erose) mcolor(edkblue erose) title("Szolgáltatások")
//Export
graph export 3a_service_off_created.png

//whole category and normal
twoway connected service_w_price service_w_price_norm date, sort xtitle("Dátum") ytitle("Havi átlagos változás (logszázalék)")legend(label(1 "teljes (szerkesztett)") label(2 "sztenderd áfa-kulcsú termékek")) lcolor(edkblue erose) mcolor(edkblue erose) title("Szolgáltatások")
//Export
graph export 3b_service_gen_norm.png

//whole category and reduced
twoway connected service_w_price service_w_price_red date, sort xtitle("Dátum") ytitle("Havi átlagos változás (logszázalék)")legend(label(1 "teljes (szerkesztett)") label(2 "csökkentett áfa-kulcsú termékek")) lcolor(edkblue erose) mcolor(edkblue erose) title("Szolgáltatások")
//Export
graph export 3c_service_gen_red.png

//whole category and normal
twoway connected service_w_price service_w_price_hosp date, sort xtitle("Dátum") ytitle("Havi átlagos változás (logszázalék)")legend(label(1 "teljes (szerkesztett)") label(2 "vendéglátás áfa-kulcsú termékek")) lcolor(edkblue erose) mcolor(edkblue erose) title("Szolgáltatások")
//Export
graph export 3d_service_gen_hosp.png

//whole category and reduced
twoway connected service_w_price service_w_price_taxfree date, sort xtitle("Dátum") ytitle("Havi átlagos változás (logszázalék)")legend(label(1 "teljes (szerkesztett)") label(2 "áfa-mentes termékek")) lcolor(edkblue erose) mcolor(edkblue erose) title("Szolgáltatások")
//Export
graph export 3e_service_gen_taxfree.png

//everything
twoway line service_w_price service_w_price_norm service_w_price_hosp date, sort xtitle("Dátum") ytitle("Havi átlagos változás (logszázalék)")legend(label(1 "teljes (szerkesztett)") label(2 "sztenderd") label(3 "vendéglátás")) lcolor(edkblue erose) mcolor(edkblue erose) title("Szolgáltatások")
//Export
graph export 3f_service_gen_norm_hosp.png

//normal and reduced
twoway connected service_w_price_norm service_w_price_hosp date, sort xtitle("Dátum") ytitle("Havi átlagos változás (logszázalék)")legend(label(1 "sztenderd áfa-kulcs") label(2 "vendéglátás áfa-kulcs")) lcolor(edkblue erose) mcolor(edkblue erose) subtitle("Szolgáltatások: sztenderd és vendéglátás áfa-kulcs")
//Export
graph export 3g_service_norm_hosp.png
