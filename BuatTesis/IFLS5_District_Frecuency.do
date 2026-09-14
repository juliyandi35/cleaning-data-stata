cd "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis"
use "IFLS5\bk_sc1.dta"

gen Code = string(sc01_14_14) + "." + string(sc02_14_14) + "." + string(sc03_14_14)
tabulate Code // Tampilkan Frekuensi dari Setiap Kecamatan
save "IFLS5_District_Frecuency_Script.dta", replace
