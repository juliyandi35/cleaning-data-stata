/*******************************************************************************
  Dampak Pernikahan Remaja terhadap Penghasilan Ibu di Indonesia
								[IFLS 2014]
		             Penulis		: Priskila Saragih
			     Date Last Modified	: 21 Februari 2025
*******************************************************************************/

clear all
*proses di folder Buat Tesis
cd "C:\Users\Hp\Documents\BuatTesis"
*change directory

set more off
*tells stata not to pause for message

*---------------------------------IFLS 2014------------------------------------*
***Cleaning IFLS5 (2014)***
use "output\HampirFinal14", clear

drop if jenis_kelamin14==1
* Jumlah perempuan ada 29.714 orang

***VERSI early married (menikah <18 tahun) dan married (>=18 tahun)
drop if umur_menikah_pertama<7 /*Asumsi kalo ga masuk akal orang menikah umur 0-6 tahun*/
gen teenage_married_woman=""
replace teenage_married_woman="Early Married" if umur_menikah_pertama < 18
replace teenage_married_woman="Married" if umur_menikah_pertama >= 18
tabulate teenage_married_woman
replace teenage_married_woman=0 if umur_menikah_pertama >= 18
replace teenage_married_woman=1 if umur_menikah_pertama < 18
save "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis\Data_Version_1_with_Dummy_Data.dta"
*Variabel Teenage Married Woman ini akan menjadi variabel of interest  (dummy) pada penelitian ini