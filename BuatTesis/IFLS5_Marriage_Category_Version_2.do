cd "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis"

clear 
use "IFLS5\b3a_kw3.dta"

drop if kw11 < 10 // drop umur nikah < 10 tahun

gen Category=""
replace Category="Teenage Married" if kw11 <= 19
replace Category="Married" if kw11> 19
tabulate Category

gen Biner_Category=0
replace Biner_Category=0 if Category == "Married"
replace Biner_Category=1 if Category == "Teenage Married"
save "Marriage_Data_Version_2.dta"