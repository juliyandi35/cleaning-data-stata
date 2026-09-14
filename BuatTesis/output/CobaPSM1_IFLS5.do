/*******************************************************************************
  Dampak Pernikahan Remaja terhadap Penghasilan Ibu di Indonesia
								[IFLS 2014]
		             Penulis		: Priskila Saragih
			     Date Last Modified	: 12 Februari 2025
*******************************************************************************/

clear all
*proses di folder Buat Tesis
cd "C:\Users\Hp\Documents\BuatTesis"
*change directory

set more off
*tells stata not to pause for message


*---------------------------------IFLS 2014------------------------------------*
***Cleaning IFLS5 (2014)***
use "IFLS5\bk_ar1.dta", clear

use "output\HampirFinal14", clear

***Opsi 2***
*Mengelompokkan perempuan menjadi teenage mothers, mothers, dan non-mothers versi memilah berdasarkan apakah pernah melahirkan atau tidak
gen status_ibu14=0
replace status_ibu14=1 if inrange(umur_menikah_pertama, 10, 19) & pernah_melahirkan14==1
replace status_ibu14=2 if (umur_menikah_pertama>19 & pernah_melahirkan14==1)
replace status_ibu14=3 if pernah_melahirkan14==3
label def si 1 "teenage moms"
label def si 2 "moms", add
label def si 3 "non_moms", add
label value status_ibu14 si

kmatch ps status_ibu14 umur14 pernah_bekerja14 (NL_income14), att atc nn(1) vce(boot)




