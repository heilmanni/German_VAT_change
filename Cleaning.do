/*This file is for analysing the German monthly price levels from 2015M1 - 2021M1
First, you should import German_monthly_VAT_change.xlsx which contains the 4-digit Eurostat 
items and their aggregated price levels in each period. Moreover, they are categoriesed
based on the group of VAT-change in 2020. Some items are assigned to aggregated 
categories dummies: Processed food excluded alcohol and tobacco, Non-energy industrial goods and Services*/

clear
import excel "C:\Users\Istvan\Desktop\German_monthly_VAT_change.xlsx", sheet("Munka1") firstrow

*import delimited "https://github.com/heilmanni/German_VAT_change/blob/a5c40800186f9f860dfcd8b90f0c215aa887ff61/German_VAT_grouped.xlsx" //ez egyelőre nem jó így

rename E normal
rename F hospitality
rename G reduced
rename H taxfree
rename Processedfoodexcludingalcohol pfood
rename Nonenergyindustrialgoods goods
rename Services services

//Data cleaning
drop if Level=="na" //deleting the rows where we do not have any observations

*Replacing empty cells with zeroes
replace normal = "0" if normal == ""
replace hospitality = "0" if hospitality == ""
replace reduced = "0" if reduced == ""
replace taxfree = "0" if taxfree == ""
replace pfood = "0" if pfood == ""
replace goods = "0" if goods == ""
replace services = "0" if services == ""

*Creating new variables for the years and for the months
gen year = real(substr(TIME, 1, 4))
gen month = real(substr(TIME, 6, 7))
gen period = ym(year, month)-659

drop year
drop TIME
drop month

*if you want to give an id to COICOP:
//egen item_new = group( COICOP )
*don't forget: egen will create id-s in alphabetical order; but reshaping will do the same

reshape wide Value, i( COICOP ) j( period )


*Modifying the format of the pricelevel
//gen pricelevel = real(Value)
//drop Value

*Reshaping my paneldata
export excel reshaped
