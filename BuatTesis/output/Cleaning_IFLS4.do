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

log using "log\IFLS4.txt", replace

*---------------------------------IFLS 2007------------------------------------*
***Cleaning IFLS4 (2007)***
use "IFLS4\bk_ar1.dta", clear

*drop orang yang sudah meninggal dan keluar dari rumah tangga tersebut
drop if (ar01a==0|ar01a==3)

*Gabung dta
mmerge hhid07 using "IFLS4\bk_sc.dta"
drop if _merge==2
drop _merge

*Simpan hasil gabungan dta
keep pid07 hhid07 pidlink ar00 ar07 ar02b ar08day ar08mth ar08yr ar09 ar10 ar11 ar12 ar13 ar15 ar15d ar15a ar15bx ar15c ar16 ar17 ar18c sc010700 sc020700 sc030700 sc05
rename ar00 nourutART07
rename ar07 jenis_kelamin07
rename ar02b hubungan_KRT07
rename ar08day tanggal_lahir07
rename ar08mth bulan_lahir07
rename ar08yr tahun_lahir07
rename ar09 umur07
rename ar10 nourut_ayah07
rename ar11 nourut_ibu07
rename ar12 nourut_takecare07
rename ar13 status_perkawinan07
rename ar15 agama07
rename ar15d suku
rename ar15a bekerja07
rename ar15bx pendapatan_tahunan07
rename ar15c kegiatan_utama07
rename ar16 pendidikan_tertinggi07
rename ar17 kelas_tertinggi07
rename ar18c masih_sekolah07
rename sc010700 Provinsi07
rename sc020700 KabKota07
rename sc030700 Kecamatan07
rename sc05 DAERAH07
save "output\identitas07", replace

*Gabung dta
use "IFLS4\b3a_dl4.dta", clear
keep pid07 hhid07 pidlink dl14d dl4type
rename dl14d alasan_berhentisekolah07

*Ubah data dari long ke wide karena banyak pilihan
drop if missing(alasan_berhentisekolah07)
reshape wide alasan_berhentisekolah07, i(pid07 hhid07 pidlink) j(dl4type)

rename alasan_berhentisekolah071 putus_SD07
rename alasan_berhentisekolah072 putus_SMP07
rename alasan_berhentisekolah073 putus_SMA07
rename alasan_berhentisekolah074 putus_universitas07

gen putus_sekolah07=0
replace putus_sekolah07=1 if (putus_SD07=="B"|putus_SMP07=="B"|putus_SMA07=="B"|putus_universitas07=="B")
replace putus_sekolah07=2 if (putus_SD07=="C"|putus_SMP07=="C"|putus_SMA07=="C"|putus_universitas07=="C")
replace putus_sekolah07=3 if (putus_SD07=="D"|putus_SMP07=="D"|putus_SMA07=="D"|putus_universitas07=="D")
replace putus_sekolah07=4 if (putus_SD07=="E"|putus_SMP07=="E"|putus_SMA07=="E"|putus_universitas07=="E")
replace putus_sekolah07=5 if (putus_SD07=="F"|putus_SMP07=="F"|putus_SMA07=="F"|putus_universitas07=="F")
replace putus_sekolah07=6 if (putus_SD07=="G"|putus_SMP07=="G"|putus_SMA07=="G"|putus_universitas07=="G")
replace putus_sekolah07=7 if (putus_SD07=="H"|putus_SMP07=="H"|putus_SMA07=="H"|putus_universitas07=="H")
replace putus_sekolah07=8 if (putus_SD07=="I"|putus_SMP07=="I"|putus_SMA07=="I"|putus_universitas07=="I")
replace putus_sekolah07=9 if (putus_SD07=="K"|putus_SMP07=="K"|putus_SMA07=="K"|putus_universitas07=="K")
replace putus_sekolah07=10 if (putus_SD07=="L"|putus_SMP07=="L"|putus_SMA07=="L"|putus_universitas07=="L")
replace putus_sekolah07=11 if (putus_SD07=="M"|putus_SMP07=="M"|putus_SMA07=="M"|putus_universitas07=="M")
replace putus_sekolah07=12 if (putus_SD07=="V"|putus_SMP07=="V"|putus_SMA07=="V"|putus_universitas07=="V")

drop putus_SD07 putus_SMA07 putus_SMP07 putus_universitas07

mmerge pidlink hhid07 using "output\identitas07"
drop _merge
save "output\notschool07", replace

*Gabung dta
use "IFLS4\b3a_hi.dta", clear
keep pid07 hhid07 pidlink hi14 hitype
rename hi14 non_labourincome07

*drop if missing (non_labourincome07)
reshape wide non_labourincome07, i(pid07 hhid07 pidlink) j(hitype, string)

rename non_labourincome07B1 beasiswa_pemerintah
rename non_labourincome07B2 beasiswa_swasta
rename non_labourincome07C GR_asuransi
rename non_labourincome07D1 undian

replace beasiswa_pemerintah=0 if beasiswa_pemerintah==.
replace beasiswa_swasta=0 if beasiswa_swasta==.
replace GR_asuransi=0 if GR_asuransi==.
replace undian=0 if undian==.

gen NL_income07=beasiswa_pemerintah+beasiswa_swasta+GR_asuransi+undian
drop beasiswa_pemerintah beasiswa_swasta GR_asuransi undian

mmerge pidlink hhid07 using "output\notschool07"
drop _merge
save "output\non_labourincome07", replace

*Gabung dta
use "IFLS4\b3a_kw1.dta", clear
keep pid07 hhid07 pidlink kw01a kw04
rename kw01a status_perkawinan07
rename kw04 pemilih_pasangan07

mmerge pidlink hhid07 using "output\non_labourincome07"
drop if _merge==2
drop _merge
save "output\perkawinanA07", replace

*Gabung dta
use "IFLS4\b4_kw3.dta", clear
keep pid07 hhid07 pidlink kw23b kw23e
rename kw23b umurhaid07
rename kw23e umur_stophaid07

mmerge pidlink hhid07 using "output\perkawinanA07"
drop if _merge==2
drop _merge
save "output\perkawinanB07", replace

*Gabung dta
use "IFLS4\b3a_kw3.dta", clear
keep pid07 hhid07 pidlink kw11 kw11a kwn kw10yr
rename kw11 usia_menikah07
rename kw11a hidup_bersama07
rename kw10yr tahun_menikah07

reshape wide tahun_menikah07 hidup_bersama07 usia_menikah07, i(pid07 hhid07 pidlink) j(kwn)

drop tahun_menikah072 hidup_bersama072 tahun_menikah073 hidup_bersama073 tahun_menikah074 hidup_bersama074 tahun_menikah075 hidup_bersama075 tahun_menikah076 hidup_bersama076 tahun_menikah077 hidup_bersama077 tahun_menikah078 hidup_bersama078 tahun_menikah079 hidup_bersama079 tahun_menikah0710 hidup_bersama0710 tahun_menikah0711 hidup_bersama0711 
rename tahun_menikah071 tahun_menikah07
rename hidup_bersama071 hidup_bersama07

drop usia_menikah072 usia_menikah073 usia_menikah074 usia_menikah075 usia_menikah076 usia_menikah077 usia_menikah078 usia_menikah079 usia_menikah0710 usia_menikah0711
mmerge pidlink hhid07 using "output\perkawinanA07"
drop _merge
gen umur_menikah07=tahun_menikah07-tahun_lahir07
replace umur_menikah07=usia_menikah071 if umur_menikah07==.
drop usia_menikah071
save "output\perkawinanC07", replace

*Gabung dta
use "IFLS4\b3a_br1.dta", clear
keep pid07 hhid07 pidlink br01 br03 br04 br06 br07 br11 br12 br13 br14
rename br01 pernah_melahirkan07
rename br03 son_together07
rename br04 daugher_together07
rename br06 son_nottogether07
rename br07 daughter_nottogether07
rename br11 lahir_meninggal07
rename br12 jumlahlahir_meninggal07
rename br13 pernah_keguguran07
rename br14 keguguran07

mmerge pidlink hhid07 using "output\perkawinanC07"
drop _merge
save "output\melahirkan07", replace

*Gabung dta
use "IFLS4\b3a_mg1.dta", clear
keep pid07 hhid07 pidlink mg20b
rename mg20b MIGRASI07

mmerge pidlink hhid07 using "output\melahirkan07"
drop _merge
save "output\MIGRASI07", replace

*Gabung dta
use "IFLS4\b3a_tk1.dta", clear
keep pid07 hhid07 pidlink tk01 tk02 tk03 tk04 tk05 
rename tk01 kegiatan_terbanyak07
rename tk02 dapat_penghasilan1jam07
rename tk03 while_notwork07
rename tk04 kerja_usahakeluarga07
rename tk05 pernah_bekerja07

mmerge pidlink hhid07 using "output\MIGRASI07"
drop _merge
save "output\Pekerjaan07", replace

*Gabung dta
use "IFLS4\b3a_tk2.dta", clear
keep pid07 hhid07 pidlink tk19ab tk22a tk23a tk24a tk19ba tk22b tk23b tk24b tk25a1 tk26a1 tk25b1 tk26b1
rename tk19ab sektor_utama07
rename tk22a HOURS_utama07
rename tk23a WEEKS_utama07
rename tk24a Status_utama07
rename tk19ba sektor_sampingan07
rename tk22b HOURS_sampingan07
replace HOURS_sampingan07=0 if HOURS_sampingan07==.
rename tk23b WEEKS_sampingan07
replace WEEKS_sampingan07=0 if WEEKS_sampingan07==.
rename tk24b Status_sampingan07
rename tk25a1 Gaji_utama07
replace Gaji_utama07=0 if Gaji_utama07==.
rename tk26a1 Untungusaha_utama07
replace Untungusaha_utama07=0 if Untungusaha_utama07==.
gen penghasilan_utama07=Gaji_utama07+Untungusaha_utama07
rename tk25b1 Gaji_sampingan07
replace Gaji_sampingan07=0 if Gaji_sampingan07==.
rename tk26b1 Untungusaha_sampingan07
replace Untungusaha_sampingan07=0 if Untungusaha_sampingan07==.
gen penghasilan_sampingan07=Gaji_sampingan07+Untungusaha_sampingan07

mmerge pidlink hhid07 using "output\Pekerjaan07"
drop _merge
save "output\PekerjaanLengkap07", replace

*Gabung dta
use "IFLS4\b3a_pk1.dta", clear
keep pid07 hhid07 pidlink pk19by
rename pk19by waktu_perkawinan07
mmerge pidlink hhid07 using "output\PekerjaanLengkap07"
drop _merge
generate umur_menikah207 = waktu_perkawinan07-tahun_lahir07
generate umur_menikah_pertama = min(usia_menikah07, umur_menikah207)
replace umur_menikah_pertama=0 if umur_menikah_pertama==.
*Asumsi ga masuk akal orang menikah di bawah usia 6 tahun
drop if (umur_menikah_pertama==1|umur_menikah_pertama==2|umur_menikah_pertama==3|umur_menikah_pertama==4|umur_menikah_pertama==5|umur_menikah_pertama==6| umur_menikah_pertama>99|umur_menikah_pertama<0)
save "output\HampirFinal07", replace