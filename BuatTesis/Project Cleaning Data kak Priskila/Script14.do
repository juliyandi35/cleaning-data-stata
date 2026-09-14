use "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis\output\HampirFinal14.dta", clear

replace Gaji_utama14 = 0 if missing(Gaji_utama14)
replace Untungusaha_utama14 = 0 if missing(Untungusaha_utama14)
replace Gaji_sampingan14 = 0 if missing(Gaji_sampingan14)
replace Untungusaha_sampingan14 = 0 if missing(Untungusaha_sampingan14)

gen ln_penghasilan = log(Gaji_utama14 + Untungusaha_utama14 + Gaji_sampingan14 + Untungusaha_sampingan14)

gen Category=""
replace Category="Early Married" if umur_menikah_pertama < 18
replace Category="Married" if umur_menikah_pertama>= 18
tabulate Category

gen lama_sekolah = 0
replace lama_sekolah = 2 if pendidikan_tertinggi14 == 90 
replace lama_sekolah = 8 if pendidikan_tertinggi14 == 2|pendidikan_tertinggi14 == 11|pendidikan_tertinggi14 == 72 
replace lama_sekolah = 11 if pendidikan_tertinggi14 == 3|pendidikan_tertinggi14 == 12|pendidikan_tertinggi14 == 73 
replace lama_sekolah = 14 if pendidikan_tertinggi14 == 5|pendidikan_tertinggi14 == 6|pendidikan_tertinggi14 == 15|pendidikan_tertinggi14 == 14|pendidikan_tertinggi14 == 17|pendidikan_tertinggi14 == 74 
replace lama_sekolah = 17 if pendidikan_tertinggi14 == 60 
replace lama_sekolah = 18 if pendidikan_tertinggi14 == 13|pendidikan_tertinggi14 == 61 
replace lama_sekolah = 20 if pendidikan_tertinggi14 == 62
replace lama_sekolah = 23 if pendidikan_tertinggi14 == 63

gen wife_together = 0
replace wife_together = 1 if status_perkawinan14 == 6

recast float son_together14 
recast float daugher_together14 
recast float son_nottogether14 
recast float daughter_nottogether14

replace son_together14 = 0 if missing(son_together14)
replace daugher_together14 = 0 if missing(daugher_together14)
replace son_nottogether14 = 0 if missing(son_nottogether14)
replace daughter_nottogether14 = 0 if missing(daughter_nottogether14)

gen family_size = wife_together + son_together14 + daugher_together14 + 1

gen children = son_together14 + daugher_together14 + son_nottogether14 + daughter_nottogether14

gen formalin = 0
replace formalin = 1 if Status_utama14 == 4|Status_utama14 == 5|Status_utama14 == 3 |Status_sampingan14 == 3|Status_sampingan14 == 4|Status_sampingan14 == 5

gen FULLPART14 =0
replace FULLPART14 = 1 if HOURS_utama14  >= 35 
replace FULLPART14 = 2 if HOURS_utama14  >= 1 & HOURS_utama14 < 35

gen ln_NL_income = log(NL_income14)
replace ln_NL_income = 0 if missing(ln_NL_income)

gen Kode_Daerah = ""
replace Kode_Daerah = string(Provinsi14) + "." + string(KabKota14) +"." + string(Kecamatan14) if strlen(string(Kecamatan14))==3 & strlen(string(KabKota14))==2
replace Kode_Daerah = string(Provinsi14) + ".0" + string(KabKota14) +".0"+ string(Kecamatan14) if strlen(string(Kecamatan14))==2 & strlen(string(KabKota14))==1
replace Kode_Daerah = string(Provinsi14) + "." + string(KabKota14) +".0"+ string(Kecamatan14) if strlen(string(Kecamatan14))==2 & strlen(string(KabKota14))==2
replace Kode_Daerah = string(Provinsi14) + ".0" + string(KabKota14) +"."+ string(Kecamatan14) if strlen(string(Kecamatan14))==3 & strlen(string(KabKota14))==1
tabulate Kode_Daerah

save "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis\output\HampirFinal141.dta", replace

*UBAH BENTUK DATA TK3
use "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis\IFLS5\b3a_tk3.dta", clear
keep pidlink hhid14 pid14 hhid14 tk28year tk28 tk33
collapse (sum)tk28, by (hhid14 pid14 pidlink)
merge 1:m pidlink using "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis\output\HampirFinal141.dta"
drop _merge

***INTERUPT (Interupsi Pekerjaan)***
gen INTERUPT=0
replace INTERUPT=1 if tk28>9
recode INTERUPT(1=0 "Tidak kontinu bekerja") (0=1 "Kontinu bekerja"), gen(INTERUPT14)
save "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis\output\HampirFinal142.dta", replace

*experience
use "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis\IFLS5\b3a_tk4.dta", clear
drop if missing(tk47yr)
drop if tk47yr == 9998
gen experience = 2014 - tk47yr
collapse (sum)experience, by (hhid14 pid14 pidlink)
merge 1:m pidlink using "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis\output\HampirFinal142.dta"
drop _merge

keep ln_penghasilan Category status_perkawinan14 umur14 lama_sekolah suku family_size HOURS_utama14 children formalin FULLPART14 ln_NL_income DAERAH14 MIGRASI14 INTERUPT14 experience Kode_Daerah hubungan_KRT14 putus_sekolah14 pemilih_pasangan14 hidup_bersama14

save "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis\Dataset14.dta", replace

* Menampilkan jumlah daerah yang ada
duplicates drop Kode_Daerah, force
count

use "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis\Dataset14.dta", clear

*Analisis Deskriptif
summarize 

*Analisis Frekuensi
tabulate Category status_perkawinan14
tabulate Category lama_sekolah
tabulate Category suku
tabulate Category family_size
tabulate Category children
tabulate Category formalin
tabulate Category FULLPART14
tabulate Category DAERAH14
tabulate Category MIGRASI14
tabulate Category INTERUPT14
tabulate Category experience
tabulate Category hubungan_KRT14
tabulate Category putus_sekolah14
tabulate Category pemilih_pasangan14
tabulate Category hidup_bersama14





