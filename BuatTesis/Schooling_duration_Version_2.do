cd "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis"
clear
use "Marriage_Data_Version_2.dta"

gen lama_sekolah = 0
replace lama_sekolah = 6 if ar16 == 2|ar16 == 11|ar16 == 72 //SD/Paket A/MI
replace lama_sekolah = 3 if ar16 == 3|ar16 == 12|ar16 == 73|ar16 == 5|ar16 == 6|ar16 == 15|ar16 == 14|ar16 == 17|ar16 == 60|ar16 == 63|ar16 == 74 //SMP/Paket B/MTs/SMU/SMK/Paket C/Pesantren/SLB/Akademi/S3/MA
replace lama_sekolah = 4 if ar16 == 13|ar16 == 61 // Universitas Terbuka/S1/
replace lama_sekolah = 2 if ar16 == 62|ar16 == 90 // S2/TK

save "Schooling_duration_Version_2.dta",replace
clear
