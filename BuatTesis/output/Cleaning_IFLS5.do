/*******************************************************************************
  Dampak Pernikahan Remaja terhadap Penghasilan Ibu di Indonesia
								[IFLS 2014]
		             Penulis		: Priskila Saragih
			     Date Last Modified	: 12 Februari 2025
*******************************************************************************/

clear all
*proses di folder Buat Tesis
//cd "C:\Users\Hp\Documents\BuatTesis"
cd "D:\Kerjaan\Project Cleaning Data kak Priskila\BuatTesis"
*change directory

//set more off
*tells stata not to pause for message

//log using "log\IFLS5.txt", replace

*---------------------------------IFLS 2014------------------------------------*
***Cleaning IFLS5 (2014)***
use "IFLS5\bk_ar1.dta", clear

*drop orang yang sudah meninggal dan keluar dari rumah tangga tersebut
drop if (ar01a==0|ar01a==3)

*Gabung dta
merge m:m hhid14 using "IFLS5\bk_sc1.dta"
drop if _merge==2
drop _merge

*Simpan hasil gabungan dta
keep pid14 hhid14 pidlink ar00 ar07 ar02b ar08day ar08mth ar08yr ar09 ar10 ar11 ar12 ar13 ar15 ar15d ar15a ar15bx ar15c ar16 ar17 ar18c sc01_14_14 sc02_14_14 sc03_14_14 sc05
rename ar00 nourutART14
rename ar07 jenis_kelamin14
rename ar02b hubungan_KRT14
rename ar08day tanggal_lahir14
rename ar08mth bulan_lahir14
rename ar08yr tahun_lahir14

*UMUR SEKARANG
rename ar09 umur14
rename ar10 nourut_ayah14
rename ar11 nourut_ibu14
rename ar12 nourut_takecare14

*STATUS PERKAWINAN SAAT INI
rename ar13 status_perkawinan14

rename ar15 agama14
rename ar15d suku

*SUKU (versi 1 jawa dan lainnya)
//Suku: (1 jawa 0 lainnya)
gen race_jawa14=1 if suku==1
replace race_jawa14=0 if suku~=1 & suku~=.

rename ar15a bekerja14
rename ar15bx pendapatan_tahunan14
rename ar15c kegiatan_utama14
rename ar16 pendidikan_tertinggi14
rename ar17 kelas_tertinggi14
rename ar18c masih_sekolah14
rename sc01_14_14 Provinsi14
rename sc02_14_14 KabKota14
rename sc03_14_14 Kecamatan14

*DAERAH (PERKOTAAN ATAU PERDESAAN)*
gen urban = 0 
replace urban=1 if sc05==1
label define urban 1 "urban" 0 "rural"

save "output\identitas14", replace

*Gabung dta*
use "IFLS5\b3a_dl4.dta", clear
keep pid14 hhid14 pidlink dl14d dl4type
rename dl14d alasan_berhentisekolah14

*Ubah data dari long ke wide karena banyak pilihan*
drop if missing(alasan_berhentisekolah14)
reshape wide alasan_berhentisekolah14, i(pid14 hhid14 pidlink) j(dl4type)

rename alasan_berhentisekolah141 putus_SD14
rename alasan_berhentisekolah142 putus_SMP14
rename alasan_berhentisekolah143 putus_SMA14
rename alasan_berhentisekolah144 putus_universitas14

gen putus_sekolah14=0
replace putus_sekolah14=1 if (putus_SD14=="B"|putus_SMP14=="B"|putus_SMA14=="B"|putus_universitas14=="B")
replace putus_sekolah14=2 if (putus_SD14=="C"|putus_SMP14=="C"|putus_SMA14=="C"|putus_universitas14=="C")
replace putus_sekolah14=3 if (putus_SD14=="D"|putus_SMP14=="D"|putus_SMA14=="D"|putus_universitas14=="D")
replace putus_sekolah14=4 if (putus_SD14=="E"|putus_SMP14=="E"|putus_SMA14=="E"|putus_universitas14=="E")
replace putus_sekolah14=5 if (putus_SD14=="F"|putus_SMP14=="F"|putus_SMA14=="F"|putus_universitas14=="F")
replace putus_sekolah14=6 if (putus_SD14=="G"|putus_SMP14=="G"|putus_SMA14=="G"|putus_universitas14=="G")
replace putus_sekolah14=7 if (putus_SD14=="H"|putus_SMP14=="H"|putus_SMA14=="H"|putus_universitas14=="H")
replace putus_sekolah14=8 if (putus_SD14=="I"|putus_SMP14=="I"|putus_SMA14=="I"|putus_universitas14=="I")
replace putus_sekolah14=9 if (putus_SD14=="K"|putus_SMP14=="K"|putus_SMA14=="K"|putus_universitas14=="K")
replace putus_sekolah14=10 if (putus_SD14=="L"|putus_SMP14=="L"|putus_SMA14=="L"|putus_universitas14=="L")
replace putus_sekolah14=11 if (putus_SD14=="M"|putus_SMP14=="M"|putus_SMA14=="M"|putus_universitas14=="M")
replace putus_sekolah14=12 if (putus_SD14=="V"|putus_SMP14=="V"|putus_SMA14=="V"|putus_universitas14=="V")

drop putus_SD14 putus_SMA14 putus_SMP14 putus_universitas14

merge m:m pidlink hhid14 using "output\identitas14"
drop _merge
save "output\notschool14", replace

*Gabung dta
use "IFLS5\b3a_hi.dta", clear
keep pid14 hhid14 pidlink hi14 hitype

*NON LABOR INCOME
rename hi14 non_labourincome14

*drop if missing(non_labourincome14)
reshape wide non_labourincome14, i(pid14 hhid14 pidlink) j(hitype, string)

rename non_labourincome14A pensiun
rename non_labourincome14B1 beasiswa_pemerintah
rename non_labourincome14B2 beasiswa_swasta
rename non_labourincome14C GR_asuransi
rename non_labourincome14D1 undian



replace pensiun=0 if pensiun==.
replace beasiswa_pemerintah=0 if beasiswa_pemerintah==.
replace beasiswa_swasta=0 if beasiswa_swasta==.
replace GR_asuransi=0 if GR_asuransi==.
replace undian=0 if undian==.

gen NL_income14=pensiun+beasiswa_pemerintah+beasiswa_swasta+GR_asuransi+undian
drop pensiun beasiswa_pemerintah beasiswa_swasta GR_asuransi undian

gen ln_NL_income=ln(NL_income14)
replace ln_NL_income=0 if (NL_income14==0)

merge m:m pidlink hhid14 using "output\notschool14"
drop _merge
save "output\non_labourincome14", replace

*Gabung dta
use "IFLS5\b3a_kw1.dta", clear
keep pid14 hhid14 pidlink kw01a kw04 kw23b kw23d

*STATUS PERKAWINAN
rename kw01a status_perkawinan14

rename kw04 pemilih_pasangan14
rename kw23b umurhaid14
rename kw23d umur_stophaid14

merge m:m pidlink hhid14 using "output\non_labourincome14"
drop _merge
save "output\perkawinanA14", replace

*Gabung dta
use "IFLS5\b3a_kw3.dta", clear
keep pid14 hhid14 pidlink kw11a kwn_num kw10yr kw11
rename kw11a hidup_bersama14
rename kw10yr tahun_menikah14
rename kw11 usia_menikah14

reshape wide tahun_menikah14 hidup_bersama14 usia_menikah14, i(pid14 hhid14 pidlink) j(kwn_num)

drop tahun_menikah142 hidup_bersama142 tahun_menikah143 hidup_bersama143 tahun_menikah144 hidup_bersama144 tahun_menikah145 hidup_bersama145 tahun_menikah146 hidup_bersama146 tahun_menikah147 hidup_bersama147 tahun_menikah148 hidup_bersama148 tahun_menikah149 hidup_bersama149 tahun_menikah1410 hidup_bersama1410 tahun_menikah1411 hidup_bersama1411 
rename tahun_menikah141 tahun_menikah14
rename hidup_bersama141 hidup_bersama14


drop usia_menikah142 usia_menikah143 usia_menikah144 usia_menikah145 usia_menikah146 usia_menikah147 usia_menikah148 usia_menikah149 usia_menikah1410 usia_menikah1411
merge m:m pidlink hhid14 using "output\perkawinanA14"
drop _merge
gen umur_menikah14=tahun_menikah14-tahun_lahir14
replace umur_menikah14=usia_menikah141 if umur_menikah14==.
drop usia_menikah141
save "output\perkawinanB14", replace

*Gabung dta
use "IFLS5\b3a_br1.dta", clear
keep pid14 hhid14 pidlink br01 br03 br04 br06 br07 br11 br12 br13 br14
rename br01 pernah_melahirkan14
rename br03 son_together14
rename br04 daugher_together14
rename br06 son_nottogether14
rename br07 daughter_nottogether14

*JUMLAH ANAK KANDUNG
gen children=son_together14+daugher_together14+son_nottogether14+daughter_nottogether14
replace children=0 if (children==.)

rename br11 lahir_meninggal14
rename br12 jumlahlahir_meninggal14
rename br13 pernah_keguguran14
rename br14 keguguran14

merge m:m pidlink hhid14 using "output\perkawinanB14"
drop _merge
save "output\melahirkan14", replace

*Gabung dta
use "IFLS5\b3a_mg1.dta", clear
keep pid14 hhid14 pidlink mg20b

*MIGRASI
rename mg20b MIGRASI14
gen MIGRASI=0
replace MIGRASI=1 if MIGRASI14==1
label define MIGRAS 1 "pernah migrasi" 0 "tidak pernah migrasi"

merge m:m pidlink hhid14 using "output\melahirkan14"
drop _merge
save "output\MIGRASI14", replace

*Gabung dta
use "IFLS5\b3a_tk1.dta", clear
keep pid14 hhid14 pidlink tk01 tk02 tk03 tk04 tk05 
rename tk01 kegiatan_terbanyak14
rename tk02 dapat_penghasilan1jam14
rename tk03 while_notwork14
rename tk04 kerja_usahakeluarga14
rename tk05 pernah_bekerja14

**BEKERJA**
recode dapat_penghasilan1jam14(1=1 "Bekerja") (3=0 "Tidak bekerja"), gen (workpart)
replace workpart=1 if (kegiatan_terbanyak14==1)
replace workpart=1 if (while_notwork14==1)
replace workpart=1 if (kerja_usahakeluarga14==1)

merge m:m pidlink hhid14 using "output\MIGRASI14"
drop _merge
save "output\Pekerjaan14", replace

*Gabung dta
use "IFLS5\b3a_tk2.dta", clear
keep pid14 hhid14 pidlink tk19ab tk22a tk23a tk24a tk19ba tk22b tk23b tk24b tk25a1 tk26a1 tk26a1x tk25b1 tk26b1 tk26b1x
rename tk19ab sektor_utama14
rename tk22a HOURS_utama14
replace HOURS_utama14=0 if HOURS_utama14==.
rename tk23a WEEKS_utama14
replace WEEKS_utama14=0 if WEEKS_utama14==.
rename tk24a Status_utama14
rename tk19ba sektor_sampingan14
rename tk22b HOURS_sampingan14
replace HOURS_sampingan14=0 if HOURS_sampingan14==.
rename tk23b WEEKS_sampingan14
replace WEEKS_sampingan14=0 if WEEKS_sampingan14==.

*JAM KERJA PER MINGGU*
gen HOURS_WEEKLY=HOURS_utama14+HOURS_sampingan14
replace HOURS_WEEKLY=0 if (HOURS_WEEKLY==.)

*JAM KERJA PER BULAN
*Asumsi 1 bulan ada 4 minggu
gen HOURS=(HOURS_utama14*4)+(HOURS_sampingan14*4)
replace HOURS=0 if (HOURS==.)

***FULLPART (UNTUK MENGETAHUI ORANG TSB MERUPAKAN PEKERJA FULL TIME ATAU PEKERJA PART TIME)***
gen FULLPART14 =0/*untuk  mengakomodir orang yang sementara tidak bekerja*/
replace FULLPART14 = 1 if HOURS >= 35 /*full-time worker*/
replace FULLPART14 = 2 if HOURS >= 1 & HOURS < 35 /*part-time worker*/

rename tk24b Status_sampingan14
rename tk25a1 Gaji_utama14
replace Gaji_utama14=0 if Gaji_utama14==.

*UNTUNG/RUGI USAHA UTAMA
egen profitsignprim = group(tk26a1x tk26a1), label

gen profitprim = tk26a1 * 1 if (tk26a1x == 1)
replace profitprim = tk26a1 * -1 if (tk26a1x == 2)
replace profitprim=0 if (profitprim==.)

*UNTUNG/RUGI USAHA SAMPINGAN
egen profitsignadd = group(tk26a1x tk26a1), label

gen profitadd = tk26a1 * 1 if (tk26a1x == 1)
replace profitadd = tk26a1 * -1 if (tk26a1x == 2)
replace profitadd=0 if (profitadd==.)

**UNTUNG/RUGI PER BULAN**
gen untung_rugi=profitprim+profitadd
replace untung_rugi = 0 if (untung_rugi==.)

*GAJI UTAMA*
replace Gaji_utama14=0 if Gaji_utama14==.

*GAJI SAMPINGAN*
rename tk25b1 Gaji_sampingan14
replace Gaji_sampingan14=0 if Gaji_sampingan14==.

**GAJI PER BULAN**
gen GAJI=Gaji_utama14+Gaji_sampingan14
replace GAJI = 0 if (GAJI==.)

**PENGHASILAN PER BULAN**
gen penghasilan=GAJI+untung_rugi
replace penghasilan = 0 if (penghasilan==.)

**ln penghasilan per bulan**
gen ln_penghasilan=ln(penghasilan)
replace lnincome=0 if (penghasilan==0)

merge m:m pid14 hhid14 using "output\Pekerjaan14"
drop _merge
save "output\PekerjaanLengkap14", replace

*UBAH BENTUK DATA TK3
use "IFLS 5\b3a_tk3.dta", clear
keep pidlink hhid14 pid14 hhid14 tk28year tk28 tk33
collapse (sum)tk28, by (hhid14 pid14 pidlink)
merge m:m pidlink hhid14 using "output\PekerjaanLengkap14"
drop _merge


***INTERUPT (Interupsi Pekerjaan)***
gen INTERUPT=0
replace INTERUPT=1 if tk28>9
recode INTERUPT(1=0 "Tidak kontinu bekerja") (0=1 "Kontinu bekerja"), gen(INTERUPT14)
merge m:m pid14 hhid14 using "output\Pekerjaan14"
drop _merge
save "output\Job", replace

*Gabung dta
use "IFLS5\b3a_pk1.dta", clear
keep pid14 hhid14 pidlink pk19by
rename pk19by waktu_perkawinan14
merge m:m pidlink hhid14 using "output\Job"
drop _merge
generate umur_menikah214 = waktu_perkawinan14-tahun_lahir14
generate umur_menikah_pertama = min(umur_menikah14, umur_menikah214)
replace umur_menikah_pertama=0 if umur_menikah_pertama==.
*Asumsi ga masuk akal orang menikah di bawah usia 6 tahun
drop if (umur_menikah_pertama==1|umur_menikah_pertama==2|umur_menikah_pertama==3|umur_menikah_pertama==4|umur_menikah_pertama==5|umur_menikah_pertama==6| umur_menikah_pertama>99|umur_menikah_pertama<0)
save "output\HampirFinal14", replace

**MAAF MAS, INI BELUM ADA PENGAMBILAN FILE DTA-NYA***
***EXPERIENCE (Waktu sejak mulai bekerja pertama kali hingga saat orangtua disurvei)***
gen EXPERIENCE14=umur14-tk48
save "output\pekerjaan14", replace

**MAAF MAS, INI BELUM ADA PENGAMBILAN FILE DTA-NYA***
***FORMAL (UNTUK MENGETAHUI STATUS PEKERJAAN ORANG TSB FORMAL ATAU INFORMAL)***
recode tk24a(01=0 "informal") (02=0 "informal")(06=0 "informal") (07=0 "informal") (08=0 "informal") (03=1 "formal") (04=1 "formal")(05=1 "formal"), gen(formalinprim)
replace formalinprim=0 if (tk24a==.)
replace formalinprim=0 if (tk24a==9)


recode tk24b(01=0 "informal") (02=0 "informal")(06=0 "informal") (07=0 "informal") (08=0 "informal") (03=1 "formal") (04=1 "formal")(05=1 "formal"), gen(formalinadd)
replace formalinadd=0 if (tk24b==.)
replace formalinadd=0 if (tk24b==9)

gen formalin= formalinprim + formalinadd
replace formalin=1 if (formalin>0)
*Intinya salah satu aja sektor formal diantara pekerjaan utama dan pekerjaan sampingan, maka status pekerjaannya formal. Tapi kalo 22nya informal, maka status pekerjaannya informal
