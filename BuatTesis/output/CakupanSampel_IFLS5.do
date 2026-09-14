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
use "output\HampirFinal14", clear

drop if jenis_kelamin14==1
* Jumlah perempuan ada 29.714 orang

*Asumsi semua umur masuk kategori antara teenage mothers, mothers, dan non-mothers (dengan drop usia di bawah 6 tahun yang menikah sebelumnya)

***Opsi 1***
*belum menseleksi yang kerja atau tidak
*Mengelompokkan perempuan menjadi teenage mothers, mothers, dan non-mothers versi memilah berdasarkan status perkawinan dan apakah pernah melahirkan atau tidak
gen status_ibu14=0
replace status_ibu14=1 if (inrange(status_perkawinan14, 2, 8) & inrange(umur_menikah_pertama, 10, 19)) & pernah_melahirkan14==1
replace status_ibu14=2 if (inrange(status_perkawinan14, 2, 8)) & umur_menikah_pertama>19 &pernah_melahirkan14==1
replace status_ibu14=3 if (inrange(status_perkawinan14, 2, 8)) & pernah_melahirkan14==3
*untuk yang pernah menikah dan tidak punya anak
replace status_ibu14=3 if status_ibu14==0
label def si 1 "teenage moms"
label def si 2 "moms", add
label def si 3 "non_moms", add
label value status_ibu14 si

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

**Opsi 3**
drop if umur_menikah_pertama<10
gen teenage_married_woman=0
replace teenage_married_woman=1 if inrange(umur_menikah_pertama, 10, 19)