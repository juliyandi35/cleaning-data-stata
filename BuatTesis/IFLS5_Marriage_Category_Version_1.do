cd "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis"
clear
use "IFLS5\b3a_kw3.dta"

drop if kw11 < 7 // drop umur nikah < 7 tahun

gen Category=""
replace Category="Early Married" if kw11 < 18
replace Category="Married" if kw11>= 18
tabulate Category

gen Biner_Category=0
replace Biner_Category=0 if Category == "Married"
replace Biner_Category=1 if Category == "Early Married"
save "Marriage_Data_Version_1.dta"