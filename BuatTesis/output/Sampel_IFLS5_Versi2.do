/*******************************************************************************
  Dampak Pernikahan Remaja terhadap Penghasilan Ibu di Indonesia
								[IFLS 2014]
		             Penulis		: Priskila Saragih
			     Date Last Modified	: 21 Februari 2025
*******************************************************************************/

clear all
*proses di folder Buat Tesis
// cd "C:\Users\Hp\Documents\BuatTesis"
cd "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis"
*change directory

//set more off
*tells stata not to pause for message

*---------------------------------IFLS 2014------------------------------------*
***Cleaning IFLS5 (2014)***
use "output\HampirFinal14", clear

drop if jenis_kelamin14==1
* Jumlah perempuan ada 29.714 orang

***VERSI DROP UMUR MENIKAH PERTAMA <10 TAHUN, TEENAGE MARRIED (MENIKAH UMUR 10-19), MARRIED (MENIKAH >=19 TAHUN)
drop if umur_menikah_pertama<10
gen teenage_married_woman=""
replace teenage_married_woman="Teenage Married" if umur_menikah_pertama < 19
replace teenage_married_woman="Married" if umur_menikah_pertama >= 19
tabulate teenage_married_woman
replace teenage_married_woman=0 if umur_menikah_pertama >= 19
replace teenage_married_woman=1 if umur_menikah_pertama < 19
save "Data_Version_2_with_Dummy_Data.dta", replace

*Variabel Teenage Married Woman ini akan menjadi variabel of interest  (dummy) pada penelitian ini