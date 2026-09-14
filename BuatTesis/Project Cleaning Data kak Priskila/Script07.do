use "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis\output\HampirFinal07.dta", clear

replace Gaji_utama07 = 0 if missing(Gaji_utama07)
replace Untungusaha_utama07 = 0 if missing(Untungusaha_utama07)
replace Gaji_sampingan07 = 0 if missing(Gaji_sampingan07)
replace Untungusaha_sampingan07 = 0 if missing(Untungusaha_sampingan07)

gen ln_penghasilan = log(Gaji_utama07 + Untungusaha_utama07 + Gaji_sampingan07 + Untungusaha_sampingan07)

gen Category=""
replace Category="Early Married" if umur_menikah_pertama < 18
replace Category="Married" if umur_menikah_pertama>= 18
tabulate Category

gen lama_sekolah = 0
replace lama_sekolah = 2 if pendidikan_tertinggi07 == 90 
replace lama_sekolah = 8 if pendidikan_tertinggi07 == 2|pendidikan_tertinggi07 == 11|pendidikan_tertinggi07 == 72 
replace lama_sekolah = 11 if pendidikan_tertinggi07 == 3|pendidikan_tertinggi07 == 12|pendidikan_tertinggi07 == 73 
replace lama_sekolah = 14 if pendidikan_tertinggi07 == 5|pendidikan_tertinggi07 == 6|pendidikan_tertinggi07 == 15|pendidikan_tertinggi07 == 14|pendidikan_tertinggi07 == 17|pendidikan_tertinggi07 == 74 
replace lama_sekolah = 17 if pendidikan_tertinggi07 == 60 
replace lama_sekolah = 18 if pendidikan_tertinggi07 == 13|pendidikan_tertinggi07 == 61 
replace lama_sekolah = 20 if pendidikan_tertinggi07 == 62
replace lama_sekolah = 23 if pendidikan_tertinggi07 == 63

gen wife_together = 0
replace wife_together = 1 if status_perkawinan07 == 6

recast float son_together07 
recast float daugher_together07 
recast float son_nottogether07 
recast float daughter_nottogether07

replace son_together07 = 0 if missing(son_together07)
replace daugher_together07 = 0 if missing(daugher_together07)
replace son_nottogether07 = 0 if missing(son_nottogether07)
replace daughter_nottogether07 = 0 if missing(daughter_nottogether07)

gen family_size = wife_together + son_together07 + daugher_together07 + 1

gen children = son_together07 + daugher_together07 + son_nottogether07 + daughter_nottogether07

gen formalin = 0
replace formalin = 1 if Status_utama07 == 4|Status_utama07 == 5|Status_utama07 == 3 |Status_sampingan07 == 3|Status_sampingan07 == 4|Status_sampingan07 == 5

gen FULLPART07 =0
replace FULLPART07 = 1 if HOURS_utama07  >= 35 
replace FULLPART07 = 2 if HOURS_utama07  >= 1 & HOURS_utama07 < 35

gen ln_NL_income = log(NL_income07)
replace ln_NL_income = 0 if missing(ln_NL_income)

gen Kode_Daerah = ""
replace Kode_Daerah = string(Provinsi07) + "." + string(KabKota07) +"." + string(Kecamatan07) if strlen(string(Kecamatan07))==3 & strlen(string(KabKota07))==2
replace Kode_Daerah = string(Provinsi07) + ".0" + string(KabKota07) +".0"+ string(Kecamatan07) if strlen(string(Kecamatan07))==2 & strlen(string(KabKota07))==1
replace Kode_Daerah = string(Provinsi07) + "." + string(KabKota07) +".0"+ string(Kecamatan07) if strlen(string(Kecamatan07))==2 & strlen(string(KabKota07))==2
replace Kode_Daerah = string(Provinsi07) + ".0" + string(KabKota07) +"."+ string(Kecamatan07) if strlen(string(Kecamatan07))==3 & strlen(string(KabKota07))==1
tabulate Kode_Daerah

save "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis\output\HampirFinal071.dta", replace

*UBAH BENTUK DATA TK3
use "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis\IFLS5\b3a_tk3.dta", clear
keep pidlink hhid14 pid14 hhid14 tk28year tk28 tk33
collapse (sum)tk28, by (hhid14 pid14 pidlink)
merge 1:m pidlink using "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis\output\HampirFinal071.dta"
drop _merge

***INTERUPT (Interupsi Pekerjaan)***
gen INTERUPT=0
replace INTERUPT=1 if tk28>9
recode INTERUPT(1=0 "Tidak kontinu bekerja") (0=1 "Kontinu bekerja"), gen(INTERUPT07)
save "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis\output\HampirFinal072.dta", replace

*experience
use "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis\IFLS5\b3a_tk4.dta", clear
drop if missing(tk47yr)
drop if tk47yr == 9998
gen experience = 2014 - tk47yr
collapse (sum)experience, by (hhid14 pid14 pidlink)
merge 1:m pidlink using "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis\output\HampirFinal072.dta"
drop _merge

keep ln_penghasilan Category status_perkawinan07 umur07 lama_sekolah suku family_size HOURS_utama07 children formalin FULLPART07 ln_NL_income DAERAH07 MIGRASI07 INTERUPT07 experience Kode_Daerah hubungan_KRT07 putus_sekolah07 pemilih_pasangan07 hidup_bersama07

save "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis\Dataset07.dta", replace

* Menampilkan jumlah daerah yang ada
duplicates drop Kode_Daerah, force
count

use "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis\Dataset07.dta", clear

*Analisis Deskriptif
summarize 

*Analisis Frekuensi
tabulate Category status_perkawinan07
tabulate Category lama_sekolah
tabulate Category suku
tabulate Category family_size
tabulate Category children
tabulate Category formalin
tabulate Category FULLPART07
tabulate Category DAERAH07
tabulate Category MIGRASI07
tabulate Category INTERUPT07
tabulate Category experience
tabulate Category hubungan_KRT07
tabulate Category putus_sekolah07
tabulate Category pemilih_pasangan07
tabulate Category hidup_bersama07





