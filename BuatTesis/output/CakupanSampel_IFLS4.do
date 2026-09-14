/*******************************************************************************
  Dampak Pernikahan Remaja terhadap Penghasilan Ibu di Indonesia
								[IFLS 2007]
		             Penulis		: Priskila Saragih
			     Date Last Modified	: 13 Februari 2025
*******************************************************************************/

clear all
*proses di folder Buat Tesis
cd "C:\Users\Hp\Documents\BuatTesis"
*change directory

set more off
*tells stata not to pause for message

*---------------------------------IFLS 2007------------------------------------*
***Cleaning IFLS5 (2007)***
use "output\HampirFinal07", clear

drop if jenis_kelamin07==1
* Jumlah perempuan ada 15.170 orang

*Asumsi semua umur masuk kategori antara teenage mothers, mothers, dan non-mothers (dengan drop usia di bawah 6 tahun yang menikah sebelumnya)

***Opsi 1***
*belum menseleksi yang kerja atau tidak
*Mengelompokkan perempuan menjadi teenage mothers, mothers, dan non-mothers versi memilah berdasarkan status perkawinan dan apakah pernah melahirkan atau tidak
gen status_ibu07=0
replace status_ibu07=1 if (inrange(status_perkawinan07, 2, 8) & inrange(umur_menikah_pertama, 10, 19)) & pernah_melahirkan07==1
replace status_ibu07=2 if (inrange(status_perkawinan07, 2, 8)) & umur_menikah_pertama>19 &pernah_melahirkan07==1
replace status_ibu07=3 if (inrange(status_perkawinan07, 2, 8)) & pernah_melahirkan07==3
*untuk yang pernah menikah dan tidak punya anak
replace status_ibu07=3 if status_ibu07==0
label def si 1 "teenage moms"
label def si 2 "moms", add
label def si 3 "non_moms", add
label value status_ibu07 si

***Opsi 2***
*Mengelompokkan perempuan menjadi teenage mothers, mothers, dan non-mothers versi memilah berdasarkan apakah pernah melahirkan atau tidak
gen status_ibu07=0
replace status_ibu07=1 if inrange(umur_menikah_pertama, 10, 19) & pernah_melahirkan07==1
replace status_ibu07=2 if (umur_menikah_pertama>19 & pernah_melahirkan07==1)
replace status_ibu07=3 if pernah_melahirkan07==3
label def si 1 "teenage moms"
label def si 2 "moms", add
label def si 3 "non_moms", add
label value status_ibu07 si