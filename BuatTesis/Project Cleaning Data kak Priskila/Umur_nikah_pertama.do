use "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis\IFLS5\b3a_kw3.dta", clear
drop if missing(kw10yr)
drop if kw10yr == 9998
gen umur_menikah = 2014 - kw10yr
tabulate umur_menikah

use "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis\IFLS5\b3a_kw3.dta", clear
drop if missing(kw10yr)
collapse (max) kwn_num (first) kw10yr, by(pidlink)
drop if kw10yr == 9998
save "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis\tahun_nikah_pertama.dta",replace

use "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis\IFLS5\bk_ar1.dta",replace
drop if ar13 == 1
drop if ar09 < 7 | ar09 == 998 | ar09 == 999 
merge m:1 pidlink using "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis\tahun_nikah_pertama.dta"
gen umur_menikah_pertama = ar09 - (2014 - kw10yr)
tabulate umur_menikah_pertama
keep pidlink ar09 kw10yr umur_menikah pertama
save "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis\umur_nikah_pertama.dta",replace