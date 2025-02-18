 * -- moral_org.do

use "E:\projekte\FGZ_segmentation\daten\andere\Fault lines data - More in Common\Datensatz Die andere deutsche Teilung_More in Common_extern.dta" , clear

global data_zw "E:\projekte\FGZ_segmentation\daten\andere\more_in_common"

* --- search for "aufnehmen"
* --- procedure: recode all items of dv into binary indicators
* --- generate 40 Datasets, 100 nodes each
* --- 40 two-mode networks, scale closeness 1-10 integer values
* --- meta analysis of 40 networks

* -----------------------------
* ---- dependent similarity network items
* -----------------------------

* --- moral single items
* --- authoritarianism
* --- ethnocentrism
* --- who are the better persons
* --- interests of victimized groups
* --- attitudes towards immigrants 
* --- who belongs to Germany
* --- consequences of immigration
* --- Islam in society
* --- free speach
* --- MEINUNGVIELFALT UND ZUSAMMENHALT
* --- groups are evaluated
* --- groups share values
* --- groups are disdained
* --- Bewertung von Personengruppen
* --- kritisch_verbrechen
* --- authoritarianism
* --- Weltoffen Traditions Europaeisc Patriotisc Selbstbewu Demokratis Modern Verantwort Gerecht Sicher

* -----------------------------
* --- explanatory variables ---
* -----------------------------

* --- soziodemographie
* --- party preference
* --- institutionenvertrauen
* --- Teilhabe wirtschaftlicher Erfolg
* --- contact to other groups

* --- unsecureness
* --- appreciation

* --- online useage 
* --- web pages 
* --- social media 
* --- media use

numlabel _all, add

*save $data_zw/more_in_common_use.dta, replace

* ---- soziodemographie
rename rs30 bundesland
recode rs1 2=1 1=0, gen(frau)
rename rs2 alter
rename rs31 migrant
rename rs10 schulabschl
rename rs33 wohnort
rename rs34  religiousness
rename rs27  reli_group
rename rs23 hierarchie
rename rs182 hh_income
rename rs101new hh_size
rename  rs11n hat_kinder
rename rs6 employment
tab1 q1 q2 q3n
rename q2 left_right
rename q5n EU_identity

rename q7__q7_2 society_past
rename q7__q7_3 economy_past
rename q7b__q7_2 society_future
rename q7b__q7_3 economy_future

tab1 bundesland frau alter migrant schulabschl wohnort religiousness reli_group hierarchie hh_income hh_size /// 
hat_kinder employment

tab1 society_past economy_past society_future economy_future
descr rs32_*
* ------------------------
* ------------------------
* ---- Filter/ split?
* ------------------------
* ------------------------
tab q51__q51_1
tab q51__q51_1 zdcell
keep if zdcell == 2

recode hat_kinder 3=2 // reported to have children
tab hat_kinder
recode hat_kinder 2=0
tab hat_kinder

recode hh_income (1=400) (2=750) (3=1250) (4=1750) (5=2250)  (6=2750)  (7=3250)  (8=3750)  (9=4500)  (10=7000)  (11=.) ///
 , gen(hh_income_m)
kdensity hh_income_m
recode migrant (2 3 4=1) (else=0) // including grand parents
label drop labels5
tab migrant
format migrant %1.0f 
tab migrant

regress hh_income hierarchie hh_size hat_kinder i.schulabschl migrant alter frau i.employment
tab schulabschl, gen(schulabschl)
tab employment, gen(employment)

* --- oldschool regression imputation
impute hh_income_m hierarchie hh_size hat_kinder schulabschl2-schulabschl8 migrant alter frau employment2-employment12, gen(hh_income_i)


kdensity hh_income_i


sum bundesland frau alter migrant schulabschl wohnort religiousness reli_group hierarchie hh_income_i hh_size /// 
hat_kinder employment


descr q21__q21_1 - q21__q21_12 
sum q21__q21_1 - q21__q21_12

descr q21ind_p__q21ind_1 q21ind_p__q21ind_2 q21ind_p__q21ind_3 q21ind_p__q21ind_4 q21ind_p__q21ind_5 q21ind_p__q21ind_6
renvars q21ind_p__q21ind_1 q21ind_p__q21ind_2 q21ind_p__q21ind_3 q21ind_p__q21ind_4 q21ind_p__q21ind_5 q21ind_p__q21ind_6 / ///
Care Fairness Authority Loyalty Purity Liberty

descr Care Fairness Authority Loyalty Purity Liberty
sum Care Fairness Authority Loyalty Purity Liberty
corr Fairness Authority Loyalty Purity Liberty Care

factor Fairness Authority Loyalty Purity Liberty, pcf blank(.5)
rotate, blank(.4)

* Liberty
* Jeder sollte so leben können, wie er bzw. sie das möchte, solange niemand anderes dadurch zu Schaden kommt
* Der Staat darf die Rechte seiner Bürger einschränken, wenn die öffentliche Ordnung bedroht ist



descr q21__q21_4 q21__q21_12 q21__q21_6 q21__q21_7 q21__q21_10 q21__q21_11 q21__q21_5 q21__q21_8 q21__q21_1 q21__q21_9 q21__q21_2 q21__q21_3

* --- moral single items
renvars q21__q21_4 q21__q21_12 q21__q21_6 q21__q21_7 q21__q21_10 q21__q21_11 q21__q21_5 q21__q21_8 q21__q21_1 q21__q21_9 q21__q21_2 q21__q21_3 / child_authority limit_rights harm_animal justice_most_imp actions_wrong live_as_like no_disgusting family_if_wrong care_suffer men_women_different laws_fair no_dismiss

sum child_authority limit_rights harm_animal justice_most_imp actions_wrong live_as_like no_disgusting family_if_wrong care_suffer men_women_different laws_fair no_dismiss

factor child_authority limit_rights harm_animal justice_most_imp actions_wrong live_as_like no_disgusting family_if_wrong care_suffer men_women_different laws_fair no_dismiss, pcf blank(.4)  mineigen(.8)  
rotate, blank(.4)


renvars q22new_1 q22new_2 / control soc_trust
descr control soc_trust
* --- authoritarianism
sum q24__q24_1 q24__q24_2 q24__q24_3 q24__q24_4

recode  q24__q24_1 1=0 2=1 , gen(autor1)
recode  q24__q24_2 4=0 3=1 , gen(autor2)
recode  q24__q24_3 6=0 5=1 , gen(autor3)
recode  q24__q24_4 7=0 8=1 , gen(autor4)

renvars q24__q24_1 q24__q24_2 q24__q24_3 q24__q24_4 / independence obedience well_educ curious
corr independence obedience well_educ curious 

gen authorit = autor1 + autor2 + autor3 + autor4 
tab authorit

replace authorit = authorit * 6/4
tab authorit
sum independence obedience well_educ curious 
tab q24ind

* --- unsecureness
renvars q26__q26_1 q26__q26_2 q26__q26_3 / deu_order world_danger deu_diversity
sum deu_order world_danger deu_diversity
 

sum q10n__q10n_1 q10n__q10n_2 q10n__q10n_3 q10n__q10n_4 q10n__q10n_5 q10n__q10n_6 q10n__q10n_7 q10n__q10n_8 q10n__q10n_9 q10n__q10n_10 q10n__q10n_11 q10n__q10n_12 q10n__q10n_13 q10n__q10n_14 q10n__q10n_15 q10n__q10n_16 q10n__q10n_17 q10n__q10n_18 q10n__q10n_19 q10n__q10n_20


descr  q10n__q10n_1 q10n__q10n_2 q10n__q10n_3 q10n__q10n_4 q10n__q10n_5 q10n__q10n_6 q10n__q10n_7 q10n__q10n_8 q10n__q10n_9 q10n__q10n_10 q10n__q10n_11 q10n__q10n_12 q10n__q10n_13 q10n__q10n_14 q10n__q10n_15 q10n__q10n_16 q10n__q10n_17 q10n__q10n_18 q10n__q10n_19 q10n__q10n_20

* --- check list again
renvars q10n__q10n_1 q10n__q10n_2 q10n__q10n_3 q10n__q10n_4 q10n__q10n_5 q10n__q10n_6 q10n__q10n_7 q10n__q10n_8 q10n__q10n_9 q10n__q10n_10 q10n__q10n_11 q10n__q10n_12 q10n__q10n_13 q10n__q10n_14 q10n__q10n_15 q10n__q10n_16 q10n__q10n_17 q10n__q10n_18 q10n__q10n_19 q10n__q10n_20 / ///
pensions housing care families salaries economy middle_class digital_infra mobility_infra school_cldcre universities immigr_restr immigr_integr crime_reduce rightextr_reduce climate minor_rights democr_values EU_support cohesion
descr immigr_integr
tab immigr_integr

foreach var of varlist pensions housing care families salaries economy middle_class digital_infra mobility_infra school_cldcre universities immigr_restr immigr_integr crime_reduce rightextr_reduce climate minor_rights democr_values EU_support cohesion{
	replace `var' = 0 if `var' == 4
}

sum pensions housing care families salaries economy middle_class digital_infra mobility_infra school_cldcre universities immigr_restr immigr_integr crime_reduce rightextr_reduce climate minor_rights democr_values EU_support cohesion

descr pensions
label drop labels24 
descr q11n_1__q11n_1 - q11n_5__q11n_13


list q11n_1__q11n_1 q11n_2__q11n_1 q11n_3__q11n_1 q11n_4__q11n_1 q11n_5__q11n_1 in 1/30, clean

tab q11n_5__q11n_1

* --- only most important issues
descr q11n_1__*
tab1 q11n_1__*

descr q11n_1__q11n_1 q11n_1__q11n_2 q11n_1__q11n_3 q11n_1__q11n_4 q11n_1__q11n_5 q11n_1__q11n_6 q11n_1__q11n_7 q11n_1__q11n_8 q11n_1__q11n_9 ///
q11n_1__q11n_10  q11n_1__q11n_12 q11n_1__q11n_13




* --- check list again

renvars q11n_1__q11n_1 q11n_1__q11n_2 q11n_1__q11n_3 q11n_1__q11n_4 q11n_1__q11n_5 q11n_1__q11n_6 q11n_1__q11n_7 q11n_1__q11n_8 q11n_1__q11n_9 ///
q11n_1__q11n_10  q11n_1__q11n_12 q11n_1__q11n_13 / Weltoffen Traditions Europaeisc Patriotisc Erfolgreic Unabhaengi Selbstbewu Demokratis Modern Verantwort Gerecht Sicher

* --- party preference
recode q73n (7=3) (8 10 11 12=11) , gen(party_pref)
tab q73n party_pref
lab def party_pref 1 "CDU/CSU" 2 " SPD" 3 "AfD/NPD" 4 "FDP" 5 "DIE LINKE"  6 "Grüne" 11  "andr/ungltg/WN/KA" 9 "nicht" 
lab val party_pref party_pref
tab  q73n party_pref

tab1 q12n__q12n_1 q12n__q12n_2
renvars q12n__q12n_1 q12n__q12n_2 / politicans_interested politicans_probl

cor politicans_interested politicans_probl

* --- men, society, Germany
descr q130__q130_1 q130__q130_2 q130__q130_3 q130__q130_4 q130__q130_5 q130__q130_6
renvars q130__q130_1 q130__q130_2 q130__q130_3 q130__q130_4 q130__q130_5 q130__q130_6 / umfeld entscheidungen selb_boot kritisch_verbrechen ges_veraend selbst_verant

* --- appreciation
descr q14__q14_1 q14__q14_2 q14__q14_3 q14__q14_4 q14__q14_5 q14__q14_6 q14__q14_7
renvars q14__q14_1 q14__q14_2 q14__q14_3 q14__q14_4 q14__q14_5 q14__q14_6 q14__q14_7 / einsam wohl_sicher wo_zuhause fremd_fuehl fuehl_respekt lebensleistung buerger_2klass

sum einsam wohl_sicher wo_zuhause fremd_fuehl fuehl_respekt lebensleistung buerger_2klass

descr q160__q160_1 - q160__q160_11
tab q160__q160_1

renvars q160__q160_1 q160__q160_2 q160__q160_3 q160__q160_4  q160__q160_5  q160__q160_6 q160__q160_7 q160__q160_8 q160__q160_9 q160__q160_10 q160__q160_11 / stolz_GG stolz_oek stolz_soc_sec stolz_ehrenamt stolz_ost_west stolz_refugess stolz_cult_heritage stolz_integr_EU stolz_krit_NS stolz_military stolz_mann_frau 

tab stolz_integr_EU
sum stolz_GG stolz_oek stolz_soc_sec stolz_ehrenamt stolz_ost_west stolz_refugess stolz_cult_heritage stolz_integr_EU stolz_krit_NS stolz_military stolz_mann_frau 

foreach var of varlist stolz_GG stolz_oek stolz_soc_sec stolz_ehrenamt stolz_ost_west stolz_refugess stolz_cult_heritage stolz_integr_EU stolz_krit_NS stolz_military stolz_mann_frau {
	replace `var' = 4 if `var' == 7
}

factor stolz_GG stolz_oek stolz_soc_sec stolz_ehrenamt stolz_ost_west stolz_refugess stolz_cult_heritage stolz_integr_EU stolz_krit_NS  stolz_mann_frau , blank(0.4) mineigen(1) // stolz_military



* --- identitaet nach soziodemographie
descr q28__q28_1 q28__q28_1 q28__q28_2 q28__q28_3 q28__q28_4 q28__q28_5 q28__q28_6 q28__q28_7 q28__q28_8 q28__q28_9 q28ind_p
tab1 q28__q28_1 q28__q28_1 q28__q28_2 q28__q28_3 q28__q28_4 q28__q28_5 q28__q28_6 q28__q28_7 q28__q28_8 q28__q28_9 q28ind_p
* --- identitaet nach soziodemographie
renvars q28__q28_1 q28__q28_2 q28__q28_3 q28__q28_4 q28__q28_5 q28__q28_6 q28__q28_7 q28__q28_8 q28__q28_9 / i_Geschlecht i_Religion i_pol_ueberzeug i_Generation i_region_Herk i_soz_Schicht i_Arbeit i_Nationalitaet i_Bildungsgrad
descr i_Geschlecht i_Religion i_pol_ueberzeug i_Generation i_region_Herk i_soz_Schicht i_Arbeit i_Nationalitaet i_Bildungsgrad

factor i_Geschlecht i_Religion i_pol_ueberzeug i_Generation i_region_Herk i_soz_Schicht i_Arbeit i_Nationalitaet i_Bildungsgrad, blank(.5) mineigen(1)
descr i_Geschlecht i_Religion i_pol_ueberzeug i_Generation i_region_Herk i_soz_Schicht i_Arbeit i_Nationalitaet i_Bildungsgrad 

* --- ethnocentrism
descr q29__q29_1 - q29__q29_9
tab1 q29__q29_1 - q29__q29_9
* --- who are the better persons
renvars q29__q29_1 - q29__q29_9 /  m_frauen_besser  m_glauben_besser m_politisch_besser  m_generat_besser m_region_besser m_schicht_besser m_arbeit_besser m_nation_besser m_bildung_besser
sum m_frauen_besser  m_glauben_besser m_politisch_besser  m_generat_besser m_region_besser m_schicht_besser m_arbeit_besser m_nation_besser m_bildung_besser


* --- interests of victimized groups
tab q31__q31_1
renvars q31__q31_1 q31__q31_2 q31__q31_3 q31__q31_4 q31__q31_5 / opf_belange_fluecht opf_muslim_rechte opf_maenner_rechte opf_minderh_beduerfn opf_polit_meinungen

corr opf_maenner_rechte opf_minderh_beduerfn
corr opf_belange_fluecht opf_muslim_rechte opf_maenner_rechte opf_minderh_beduerfn opf_polit_meinungen
tab1 opf_belange_fluecht opf_muslim_rechte opf_maenner_rechte opf_minderh_beduerfn opf_polit_meinungen

* -------------------
* -------------------
* ---- Factor 1 ----- ident_pol_crit
* -------------------
* -------------------
*opf_maenner_rechte
sum opf_belange_fluecht opf_muslim_rechte  opf_minderh_beduerfn opf_polit_meinungen
factor opf_belange_fluecht opf_muslim_rechte  opf_minderh_beduerfn opf_polit_meinungen
predict ident_pol_crit
kdensity ident_pol_crit
tab opf_minderh_beduerfn
corr opf_minderh_beduerfn ident_pol_crit

* --- contact to other groups
renvars q30__q30_1 q30__q30_2 q30__q30_3 q30__q30_4 q30__q30_5 q30__q30_6 q30__q30_7 q30__q30_8 / kontakt_relig kontakt_meinung kontakt_generation kontakt_schicht  kontakt_beruf kontakt_nation kontakt_region kontakt_bildung
tab kontakt_generation

* -------------------
* -------------------
* ---- Factor 2 ----- out_group_openness
* -------------------
* -------------------
sum kontakt_relig kontakt_meinung kontakt_generation kontakt_schicht  kontakt_beruf kontakt_nation kontakt_region kontakt_bildung
factor kontakt_relig kontakt_meinung kontakt_generation kontakt_schicht  kontakt_beruf kontakt_nation kontakt_region kontakt_bildung, pcf blank(.5)
predict out_group_openness
kdensity out_group_openness
tab kontakt_nation
corr kontakt_nation out_group_openness


* --- Bewertung von Personengruppen
renvars q55__q55_1 q55__q55_2 q55__q55_3 q55__q55_4 q55__q55_5 q55__q55_6 q55__q55_7 q55__q55_8 q55__q55_9 / muslime christen atheisten juden deutsche einwanderer fluechtlinge pegida fluechtl_hilfe

tab1 muslime christen atheisten juden deutsche einwanderer fluechtlinge pegida fluechtl_hilfe
* --- Islam in society
renvars q54__q54_1 q54__q54_2 / islam_vereinbar islam_ablehnung


* -------------------
* -------------------
* ---- Factor 3 -----  positive_muslims
* -------------------
* -------------------
* juden christen pegida atheisten deutsche
sum muslime     einwanderer fluechtlinge  fluechtl_hilfe islam_vereinbar islam_ablehnung
factor muslime     einwanderer fluechtlinge  fluechtl_hilfe islam_vereinbar islam_ablehnung, blank(0.5) mineigen(1.0) // deutsche 
rotate, blank(0.5)
predict positive_muslims
corr positive_muslims muslime
kdensity positive_muslims
tab muslime

factor juden christen deutsche, blank(0.5) mineigen(1.0) // pegida atheisten 

* --- groups share values
renvars q56__q55_1 q56__q55_2 q56__q55_3 q56__q55_4 q56__q55_5 q56__q55_6 q56__q55_7 q56__q55_8 q56__q55_9 / werte_teil_muslime werte_teil_christen werte_teil_atheisten werte_teil_juden werte_teil_deutsche werte_teil_einwanderer werte_teil_fluechtlinge werte_teil_pegida werte_teil_fluechtl_hilfe

* --- groups contribute to society
renvars q57__q55_1 q57__q55_2 q57__q55_3 q57__q55_4 q57__q55_5 q57__q55_6 q57__q55_7 q57__q55_8 q57__q55_9 / ///
beitr_teil_muslime beitr_christen beitr_atheisten beitr_juden beitr_deutsche beitr_einwanderer beitr_fluechtlinge beitr_pegida beitr_fluechtl_hilfe
sum beitr_teil_muslime beitr_christen beitr_atheisten beitr_juden beitr_deutsche beitr_einwanderer beitr_fluechtlinge beitr_pegida beitr_fluechtl_hilfe
tab beitr_teil_muslime

factor beitr_teil_muslime beitr_einwanderer beitr_fluechtlinge , blank(.5) mineigen(1)
* beitr_christen beitr_atheisten beitr_juden beitr_deutsche beitr_pegida beitr_fluechtl_hilfe
* -------------------
* -------------------
* ---- Factor 4 -----  attitude_immigrants
* -------------------
* -------------------
* --- attitudes towards immigrants 
descr q464__q464_1 q464__q464_2 q464__q464_3 q464__q464_5
renvars q464__q464_1 q464__q464_2 q464__q464_3 q464__q464_4 q464__q464_5 / immig_geschichte immig_zuflucht immig_integriert immig_probleme immig_bleiberecht 
sum immig_geschichte immig_zuflucht immig_integriert immig_probleme immig_bleiberecht 

factor immig_geschichte immig_zuflucht immig_integriert immig_bleiberecht, blank(0.5) mineigen(1)
predict pos_atti_immigr
corr  immig_bleiber~t pos_atti_immigr 
tab1 immig_bleiberecht immig_zuflucht
kdensity pos_atti_immigr


* --- who belongs to Germany
renvars q47__q47_1 q47__q47_2 q47__q47_3 q47__q47_4 q47__q47_5 q47__q47_6 q47__q47_7 q47__q47_8 / deu_sprechen deu_gesetze deu_werte_trad deu_fuehl deu_citizen deu_arbeit deu_geboren deu_ancestors

* --- consequences of immigration
tab q51__q51_1
sum q51__q51_1 q51__q51_2 q51__q51_3 q51__q51_4 q51__q51_5 q51__q51_7 q51__q51_8 q51__q51_9
renvars  q51__q51_1 q51__q51_2 q51__q51_3 q51__q51_4 q51__q51_5 q51__q51_7 q51__q51_8 q51__q51_9 / immig_conseq_kult_reicher immig_conseq_crime immig_conseq_stellen_besetzt immig_conseq_welfare_state immig_conseq_housing_market  immig_conseq_achievement immig_conseq_order immig_conseq_no_volk 

* -------------------
* -------------------
* ---- Factor 5 -----  neg_conseq_immi
* -------------------
* -------------------
sum immig_conseq_kult_reicher immig_conseq_crime immig_conseq_stellen_besetzt immig_conseq_welfare_state immig_conseq_housing_market  immig_conseq_achievement immig_conseq_order immig_conseq_no_volk
tab immig_conseq_kult_reicher 
factor immig_conseq_kult_reicher immig_conseq_crime immig_conseq_stellen_besetzt immig_conseq_welfare_state immig_conseq_housing_market  immig_conseq_achievement immig_conseq_order immig_conseq_no_volk, blank(0.5) mineigen(1)
predict neg_conseq_immi
kdensity neg_conseq_immi
corr neg_conseq_immi immig_conseq_kult_reicher immig_conseq_no_volk
tab1 immig_conseq_kult_reicher immig_conseq_no_volk
* -------------------
* -------------------
* ---- Factor 6 -----  low_appreciation
* -------------------
* -------------------

* --- appreciation, Wertschaetzung
tab einsam
sum einsam wohl_sicher wo_zuhause fremd_fuehl fuehl_respekt  buerger_2klass
factor   wohl_sicher  fremd_fuehl fuehl_respekt  buerger_2klass, blank(0.5) mineigen(1)
predict low_appreciation
corr low_appreciation wohl_sicher  fremd_fuehl fuehl_respekt  buerger_2klass
tab1 fremd_fuehl wohl_sicher 
tab buerger_2klass
kdensity low_appreciation

sum out_group_openness
sum neg_conseq_immi pos_atti_immigr positive_muslims ident_pol_crit low_appreciation // out_group_openness
corr neg_conseq_immi pos_atti_immigr positive_muslims ident_pol_crit low_appreciation // out_group_openness

* --- free speach
renvars q580__q580_1 q580__q580_2 q580__q580_3 q580__q580_4 / uebertrieben_begriffe debatte_hasserfuellt gewinn_internet_aeussen internet_meinung 
descr uebertrieben_begriffe debatte_hasserfuellt gewinn_internet_aeussen internet_meinung 

sum uebertrieben_begriffe debatte_hasserfuellt gewinn_internet_aeussen internet_meinung 
factor uebertrieben_begriffe  gewinn_internet_aeussen internet_meinung debatte_hasserfuellt
* --- media use
tab q59__q59_1
renvars q59__q59_1 q59__q59_2 q59__q59_3 q59__q59_4 q59__q59_5 / zeitungen internet fernsehen radiosender social_media

* --- umpolen: hohe Werte, hohe Nutzung
tab1 zeitungen internet fernsehen radiosender social_media
foreach var of varlist zeitungen internet fernsehen radiosender social_media{
	quietly sum `var'
	replace `var' = -`var' + r(max) + 1
}
tab zeitungen
descr zeitungen
label drop labels50
* --- web pages
tab q63_5
descr q63_5 q63_6 q63_7 q63_8 q63_10 q63_16 q63_20 q63_21 q63_22 q63_23 q63_25
renvars q63_5 q63_6 q63_7 q63_8 q63_10 q63_16 q63_20 q63_21 q63_22 q63_23 q63_25 / BILD Focus Spiegel CHIP Welt Zeit Stern GIGA Sueddeutsche Rtl FAZ

* --- social media
descr q630_1 q630_2 q630_3 q630_4 q630_5 q630_6 q630_7 q630_8 q630_9 q630_10 q630_11 q630_12 q630_13 q630_14 q630_15 q630_16 q630_17
renvars q630_1 q630_2 q630_3 q630_4 q630_5 q630_6 q630_7 q630_8 q630_9 q630_10 q630_11 q630_12 q630_13 q630_14 q630_15 q630_16 q630_17 / Facebook Youtube Instagram Twitter Pinterest Tumblr Reddit Linked_IN XING WhatsApp Snapchat Facebook_Messenger iMessage Skype Telegram Threema Line

* --- online useage 
tab q65n__q65n_1
rename q65n__q65n_1 freq_online
rename q65n__q65n_3 seldom_inet_news
descr q66n__q66n_3 q66n__q66n_4
tab1 q66n__q66n_3 q66n__q66n_4
renvars q66n__q66n_3 q66n__q66n_4 / good_no_soc_media  never_soc_media
rename q66n__q66n_6 say_opinion_inet
descr good_no_soc_media  never_soc_media
tab1 freq_online seldom_inet_news good_no_soc_media  never_soc_media say_opinion_inet

factor freq_online seldom_inet_news good_no_soc_media  never_soc_media say_opinion_inet, pcf blank(0.5)
rotate , blank(0.5)
predict f_online_rel_behavior f_online_intensity // frequency online & focus for behavior online 
kdensity f_online_intensity
kdensity f_online_rel_behavior 
corr good_no_soc_media f_online_rel_behavior 
corr freq_online f_online_intensity 
sum f_online_intensity f_online_rel_behavior 

foreach var of varlist f_online_rel_behavior f_online_intensity{
	sum `var'
	replace `var' = `var' -r(min) + 1
	}

sum f_online_rel_behavior f_online_intensity


* --- institutionenvertrauen
descr q72__q72_1 q72__q72_2 q72__q72_3 q72__q72_4 q72__q72_5 q72__q72_6 q72__q72_7 q72__q72_8 q72__q72_9
renvars q72__q72_1 q72__q72_2 q72__q72_3 q72__q72_4 q72__q72_5 q72__q72_6 q72__q72_7 q72__q72_8 q72__q72_9 / politiker_bund spitzenpolitiker lokalpolitiker gewerkschaftler ngos polizisten richter kirchenvertreter vereinsvorstaende
sum politiker_bund  lokalpolitiker gewerkschaftler ngos polizisten richter kirchenvertreter vereinsvorstaende // spitzenpolitiker
tab politiker_bund  

* -------------------
* -------------------
* ---- Factor 7 -----  trust_institutions
* -------------------
* -------------------
tab politiker_bund
sum politiker_bund  lokalpolitiker gewerkschaftler ngos polizisten richter kirchenvertreter vereinsvorstaende 
factor politiker_bund  lokalpolitiker gewerkschaftler ngos polizisten richter kirchenvertreter vereinsvorstaende , blank(0.5) mineigen(1)
predict trust_institutions 
corr trust_institutions politiker_bund 
tab politiker_bund 
corr neg_conseq_immi pos_atti_immigr positive_muslims ident_pol_crit low_appreciation trust_institutions  // out_group_openness
corr neg_conseq_immi pos_atti_immigr positive_muslims 
corr ident_pol_crit low_appreciation trust_institutions 
 
factor neg_conseq_immi pos_atti_immigr positive_muslims ident_pol_crit low_appreciation trust_institutions, blank(0.5) mineigen(1) 
*- out_group_openness

* --- MEINUNGVIELFALT UND ZUSAMMENHALT
renvars q75n__q75n_1 q75n__q75n_2 q75n__q75n_3 q75n__q75n_4 / diskuss_vermeid zusammenhalt ueber_zeug_einstehen unterschiede_gross
sum diskuss_vermeid zusammenhalt ueber_zeug_einstehen unterschiede_gross
descr diskuss_vermeid zusammenhalt ueber_zeug_einstehen unterschiede_gross

*factor diskuss_vermeid zusammenhalt ueber_zeug_einstehen unterschiede_gross, blank(0.5) mineigen(1)


replace  authorit = 1 if authorit == 0
replace  authorit = round(authorit)
tab authorit

tab  soc_trust

* --------------------------------------
* --------------------------------------
* --------------------------------------
* ----- Faktorenanalyse 2nd order
* --------------------------------------
* --------------------------------------
* --------------------------------------
* --- soc_trust ,
factor neg_conseq_immi pos_atti_immigr positive_muslims ident_pol_crit  low_appreciation trust_institutions , blank(0.5) mineigen(1) 
rotate, blank(.3)


factor neg_conseq_immi pos_atti_immigr positive_muslims ident_pol_crit   , blank(0.5) mineigen(1) 
factor low_appreciation trust_institutions authorit control soc_trust, blank(0.5) mineigen(1) 
corr low_appreciation trust_institutions  soc_trust  authorit control

descr control

*- F1 								opf_belange_fluecht opf_muslim_rechte  opf_minderh_beduerfn opf_polit_meinungen
*- F3 								muslime  einwanderer fluechtlinge  fluechtl_hilfe islam_vereinbar islam_ablehnung
*- F4 								immig_geschichte immig_zuflucht immig_integriert immig_bleiberecht
*- F5 								immig_conseq_kult_reicher immig_conseq_crime immig_conseq_stellen_besetzt immig_conseq_welfare_state immig_conseq_housing_market  immig_conseq_achievement immig_conseq_order immig_conseq_no_volk
*- F6 								wohl_sicher  fremd_fuehl fuehl_respekt  buerger_2klass
*- F7 								politiker_bund  lokalpolitiker gewerkschaftler ngos polizisten richter kirchenvertreter vereinsvorstaende


* -- F- 1. ident_pol_crit		<-  opf_belange_fluecht opf_muslim_rechte  opf_minderh_beduerfn opf_polit_meinungen
* -- F- 3. positive_muslims		<-  muslime einwanderer fluechtlinge  fluechtl_hilfe islam_vereinbar islam_ablehnung
* -- F- 4. pos_atti_immigr		<-  immig_geschichte immig_zuflucht immig_integriert immig_bleiberecht
* -- F- 5. neg_conseq_immi 		<-  immig_conseq_kult_reicher immig_conseq_crime immig_conseq_stellen_besetzt immig_conseq_welfare_state immig_conseq_housing_market  immig_conseq_achievement immig_conseq_order immig_conseq_no_volk
* -- F- 6. low_appreciation		<-  wohl_sicher  fremd_fuehl fuehl_respekt  buerger_2klass
* -- F- 7. trust_institutions  	<-  politiker_bund  lokalpolitiker gewerkschaftler ngos polizisten richter kirchenvertreter vereinsvorstaende
* -- F- x. soc_trust			<-  one Item
tab immig_conseq_kult_reicher
cor neg_conseq_immi  immig_conseq_kult_reicher

cor neg_conseq_immi  immig_conseq_kult_reicher immig_conseq_crime immig_conseq_stellen_besetzt immig_conseq_welfare_state immig_conseq_housing_market  immig_conseq_achievement immig_conseq_order immig_conseq_no_volk

 
* --- 2nd order factor analysis sem     soc_trust
sem (Lat_ident_pol_crit -> opf_belange_fluecht opf_muslim_rechte  opf_minderh_beduerfn opf_polit_meinungen ) ///
 (Lat_positive_muslims -> muslime einwanderer fluechtlinge  fluechtl_hilfe islam_vereinbar islam_ablehnung)  ///
 (Lat_pos_atti_immigr -> immig_geschichte immig_zuflucht immig_integriert immig_bleiberecht)  ///
 (Lat_neg_conseq_immi  -> immig_conseq_kult_reicher immig_conseq_crime immig_conseq_stellen_besetzt immig_conseq_welfare_state immig_conseq_housing_market  immig_conseq_achievement immig_conseq_order immig_conseq_no_volk)  ///
 (Lat_low_appreciation -> wohl_sicher  fremd_fuehl fuehl_respekt  buerger_2klass)  ///
 (Lat_trust_institutions -> politiker_bund  lokalpolitiker gewerkschaftler ngos polizisten richter kirchenvertreter vereinsvorstaende)  ///
 (Lat_Polarizing_att -> Lat_ident_pol_crit Lat_positive_muslims Lat_pos_atti_immigr Lat_neg_conseq_immi Lat_low_appreciation Lat_trust_institutions ) ,  cov(e.islam_vereinbar*e.Lat_positive_muslims@0)  cov(e.islam_vereinbar*e.Lat_neg_conseq_immi) cov(e.Lat_positive_muslims*e.Lat_pos_atti_immigr)  cov(e.Lat_ident_pol_crit*e.Lat_neg_conseq_immi)  cov(e.polizisten*e.richter) cov(e.wohl_sicher*e.fuehl_respekt) cov(e.immig_conseq_stellen_besetzt*e.immig_conseq_welfare_state)  cov(e.immig_conseq_kult_reicher*e.Lat_pos_atti_immigr) cov(e.immig_conseq_kult_reicher*e.Lat_neg_conseq_immi)  cov(e.immig_conseq_kult_reicher*e.immig_conseq_welfare_state) cov(e.immig_conseq_kult_reicher*e.immig_conseq_stellen_besetzt) cov(e.immig_zuflucht*e.immig_bleiberecht) cov(e.islam_vereinbar*e.Lat_ident_pol_crit) cov(e.fuehl_respekt*e.buerger_2klass)  cov(e.immig_conseq_kult_reicher*e.Lat_ident_pol_crit)  cov(e.immig_conseq_kult_reicher*e.Lat_positive_muslims)  cov(e.opf_muslim_rechte*e.islam_vereinbar) cov(e.politiker_bund*e.vereinsvorstaende)  cov(e.gewerkschaftler*e.ngos)  cov(e.ngos*e.Lat_trust_institutions)  cov(e.einwanderer*e.fluechtl_hilfe)  cov(e.immig_conseq_crime*e.immig_conseq_housing_market)
sem, standardized

estat gof, stats(all)
estat mindices

descr opf_belange_fluecht opf_muslim_rechte  opf_minderh_beduerfn opf_polit_meinungen
descr muslime einwanderer fluechtlinge  fluechtl_hilfe islam_vereinbar islam_ablehnung
descr immig_geschichte immig_zuflucht immig_integriert immig_bleiberecht
descr immig_conseq_kult_reicher immig_conseq_crime immig_conseq_stellen_besetzt immig_conseq_welfare_state immig_conseq_housing_market  immig_conseq_achievement immig_conseq_order immig_conseq_no_volk
descr wohl_sicher  fremd_fuehl fuehl_respekt  buerger_2klass
descr politiker_bund  lokalpolitiker gewerkschaftler ngos polizisten richter kirchenvertreter vereinsvorstaende

descr soc_trust			

 

* -------------------------------------
* -------------------------------------
* -- polarizing attitudes -------------
* -------------------------------------
* -------------------------------------

* --- free speach
sum uebertrieben_begriffe debatte_hasserfuellt gewinn_internet_aeussen internet_meinung 
* --- MEINUNGVIELFALT UND ZUSAMMENHALT
sum diskuss_vermeid zusammenhalt ueber_zeug_einstehen unterschiede_gross
* --- institutionenvertrauen
sum politiker_bund  lokalpolitiker gewerkschaftler ngos polizisten richter kirchenvertreter vereinsvorstaende
* --- consequences of immigration
sum immig_conseq_kult_reicher immig_conseq_crime immig_conseq_stellen_besetzt immig_conseq_welfare_state immig_conseq_housing_market immig_conseq_achievement immig_conseq_order immig_conseq_no_volk 
* --- Islam in society
sum islam_vereinbar islam_ablehnung
* --- who belongs to Germany
sum deu_sprechen deu_gesetze deu_werte_trad deu_fuehl deu_citizen deu_arbeit deu_geboren deu_ancestors
* --- Bewertung von Personengruppen => skalierung anpassen  
sum muslime christen atheisten juden deutsche einwanderer fluechtlinge pegida fluechtl_hilfe
foreach var of varlist muslime christen atheisten juden deutsche einwanderer fluechtlinge pegida fluechtl_hilfe{
	replace `var' = `var' * 6/11 
}
sum muslime

* --- unsecureness
sum deu_order world_danger deu_diversity


* --- need for action
sum pensions housing care families salaries economy middle_class digital_infra mobility_infra school_cldcre universities immigr_restr immigr_integr crime_reduce rightextr_reduce climate minor_rights democr_values EU_support cohesion

foreach var of varlist pensions housing care families salaries economy middle_class digital_infra mobility_infra school_cldcre universities immigr_restr immigr_integr crime_reduce rightextr_reduce climate minor_rights democr_values EU_support cohesion{
	replace `var' = `var' * 6/4 + 1.5
}
sum  pensions housing care families salaries economy middle_class digital_infra mobility_infra school_cldcre universities immigr_restr immigr_integr crime_reduce rightextr_reduce climate minor_rights democr_values EU_support cohesion

corr  pensions housing care families salaries economy middle_class digital_infra mobility_infra school_cldcre universities immigr_restr immigr_integr crime_reduce rightextr_reduce climate minor_rights democr_values EU_support cohesion


* --- identitaet nach soziodemographie
sum i_Geschlecht i_Religion i_pol_ueberzeug i_Generation i_region_Herk i_soz_Schicht i_Arbeit i_Nationalitaet i_Bildungsgrad
descr i_Geschlecht i_Religion i_pol_ueberzeug i_Generation i_region_Herk i_soz_Schicht i_Arbeit i_Nationalitaet i_Bildungsgrad

foreach var of varlist i_Geschlecht i_Religion i_pol_ueberzeug i_Generation i_region_Herk i_soz_Schicht i_Arbeit i_Nationalitaet i_Bildungsgrad{
	replace `var' = `var' * 6/3 * 1/2
}
sum i_Geschlecht i_Religion i_pol_ueberzeug i_Generation i_region_Herk i_soz_Schicht i_Arbeit i_Nationalitaet i_Bildungsgrad
sum control soc_trust

descr rs32_*
* --- think about standardization
* keep $polvars

gen Greece = rs32_1         
gen Italie= rs32_2         
gen Poland= rs32_3         
gen Romania= rs32_4         
gen former_SU= rs32_5         
gen former_Yugo= rs32_6         
gen Spain_Portugal = rs32_7         
gen Syria= rs32_8         
gen Turkey= rs32_9         
gen Vietnam= rs32_10        
gen other = rs32_11        
gen NA= rs32_12        
gen NET_Europe = rs32_13        

sum Greece Italie Poland Romania former_SU former_Yugo Spain_Portugal Syria Turkey Vietnam other NA NET_Europe

gen deutsch = 1 if migrant == 0
replace deutsch = 0 if migrant == 1
tab deutsch

gen turkish = 0
replace turkish = 1 if Turkey == 1
tab turkish

gen romania = 0
replace romania = 1 if Romania == 1
tab romania

gen polish = 0
replace polish = 1 if Poland == 1
tab polish

gen russian = 0
replace russian = 1 if former_SU == 1
tab russian

gen yugo = 0
replace yugo = 1 if former_Yugo == 1
tab yugo

gen s_east_europa = 0
replace s_east_europa = 1 if polish == 1 | russian == 1 | yugo == 1 | romania == 1 | turkish == 1
tab s_east_europa

gen other_mig = 0
replace other_mig = 1 if deutsch == 0 & s_east_europa == 0 
tab other_mig

sum deutsch s_east_europa other_mig

# delimit;
global polvars "neg_conseq_immi pos_atti_immigr positive_muslims ident_pol_crit  low_appreciation trust_institutions  soc_trust  out_group_openness bundesland frau alter migrant schulabschl wohnort religiousness reli_group relig_comm hierarchie hh_income_i hh_size hat_kinder employment Care Fairness Authority Loyalty Purity Liberty authorit zeitungen internet fernsehen radiosender social_media f_online_rel_behavior f_online_intensity control soc_trust Greece Italie Poland Romania former_SU former_Yugo Spain_Portugal Syria Turkey Vietnam other NA NET_Europe deutsch s_east_europa other_mig"
;
# delimit cr

# delimit;
global politems "opf_belange_fluecht opf_muslim_rechte opf_minderh_beduerfn opf_polit_meinungen 
islam_vereinbar islam_ablehnung muslime einwanderer fluechtlinge fluechtl_hilfe
immig_geschichte immig_zuflucht immig_integriert immig_bleiberecht
immig_conseq_kult_reicher immig_conseq_crime immig_conseq_stellen_besetzt immig_conseq_welfare_state 
immig_conseq_housing_market immig_conseq_achievement immig_conseq_order immig_conseq_no_volk
wohl_sicher fremd_fuehl fuehl_respekt buerger_2klass
politiker_bund lokalpolitiker gewerkschaftler ngos polizisten richter kirchenvertreter vereinsvorstaende
soc_trust"
;
# delimit cr



sum $polvars
sum $politems

keep $polvars $politems

capture drop nmiss

egen nmiss = rowmiss($polvars)
tab nmiss
sum $polvars

sum $polvars 
keep if nmiss == 0
* -------------------------------------
* -------------------------------------
* -- predictors -----------------------
* -------------------------------------
* -------------------------------------
* -- oekonomische Teilhabe => out due to split
*sum oek_teilhabe
* --- out group openness
sum out_group_openness
* --- sociodemographics
sum bundesland frau alter migrant schulabschl wohnort religiousness reli_group hierarchie hh_income_i hh_size /// 
hat_kinder employment // rekodieren!
* --- morality
sum Fairness Authority Loyalty Purity Liberty
* --- Authoritarianism 
sum authorit
* --- Media use
sum zeitungen internet fernsehen radiosender social_media
sum f_online_rel_behavior f_online_intensity // frequency online & focus for behavior online 

sum  control soc_trust                                   
                                       
global dist_vars "neg_conseq_immi pos_atti_immigr positive_muslims ident_pol_crit  low_appreciation trust_institutions   " // soc_trust
sum $dist_vars

* --- check sorting in R!!
gen id_base = _n
sort id_base

* --- aufnehmen: control soc_trust, rs32_*: Herkunftsland => done!
global actor_attrib "id_base out_group_openness bundesland frau alter migrant schulabschl wohnort religiousness reli_group hierarchie hh_income_i hh_size hat_kinder employment Care Fairness Authority Loyalty Purity Liberty authorit zeitungen internet fernsehen radiosender social_media f_online_rel_behavior f_online_intensity control soc_trust Greece Italie Poland Romania former_SU former_Yugo Spain_Portugal Syria Turkey Vietnam other NA NET_Europe deutsch s_east_europa other_mig"

* ---- N = 2000 => 5% sind 100
disp 2000 * 5 / 100
gen random = runiform(0,1)
sum random
tab employment if random <= 0.05

matrix dissimilarity network = $dist_vars if random < 0.05, dissim(oneminus)
matrix list network

capture drop rand
matrix drop _all

sum $dist_vars
corr $dist_vars

factor $dist_vars, blank(.5)
rotate, varimax blank(.5)

save $data_zw\more_in_common_polarization_data.dta, replace
*global data_zw "E:\projekte\FGZ_segmentation\daten\andere\more_in_common"

* -------------------------------
* -------------------------------
* ---- OLS Regressions ----------
* -------------------------------
* -------------------------------

* -------------------------------
* -- moral foundations as dV -----
* -------------------------------



global data_zw "E:\projekte\FGZ_segmentation\daten\andere\more_in_common"
use $data_zw\more_in_common_polarization_data.dta, clear
global out  "E:\projekte\FGZ_segmentation\daten\andere\out"



sum Care Fairness Authority Loyalty Purity Liberty
sum alter migrant schulabschl wohnort reli_group religiousness frau hh_income_i hierarchie
sum Greece Italie Poland Romania former_SU former_Yugo Spain_Portugal Syria Turkey Vietnam other
tab schulabschl

replace hh_income_i = hh_income_i / 100

recode schulabschl (3 4 8=1) (nonmis=0), gen(high_educ)
tab schulabschl high_educ
tab wohnort, gen(ortstyp)
tab1 ortstyp1 ortstyp2 ortstyp3 ortstyp4

tab reli_group
recode reli_group (7=1) (2=2) (1=3) (3=4) (nonmis = 5), gen(relig_comm)
tab reli_group relig_comm
lab def relig_comm 1 "keine Religion" 2 "Protest." 3 "Katholisch" 4 "Islam" 5 andere
lab val relig_comm relig_comm
tab relig_comm 
numlabel relig_comm, add
tab relig_comm , gen(relig_c)

foreach var of varlist Care Fairness Authority Loyalty Purity Liberty{
    kdens `var'
	tab `var'
}

lab var frau  "female (=1)"
lab var migrant  "migration backgr. (=1)"
lab var alter  "age in years"
lab var hh_income_i  "hh. income (in 100 EUR)"
lab var hh_size  "hh. size"
lab var high_educ  "min. higher second. education (=1)"
lab var hierarchie  "subj. position (1: bottom; 10: top)"
lab var hat_kinder  "has children"
lab var reli_group  ""
lab var religiousness  "religiosity"
lab var relig_c1 "no religion"
lab var relig_c2 "protestant"
lab var relig_c3 "catholic"
lab var relig_c4 "Islam"
lab var relig_c5 "other"

foreach var of varlist Care Fairness Authority Loyalty Purity Liberty{
    reg `var' frau migrant alter hh_income_i  hh_size high_educ hierarchie hat_kinder relig_c2 relig_c3 relig_c4 relig_c5  religiousness  
	est sto haidt_model_`var'
}
esttab haidt_model_Care haidt_model_Fairness haidt_model_Authority haidt_model_Loyalty haidt_model_Purity haidt_model_Liberty using $out\haidt_models.rtf, star(+ .1 * .05 **  .01 *** .001)  b(%4.3f) not  replace label r2 

save "E:\projekte\FGZ_segmentation\daten\andere\more_in_common\more_in_common_polarization_dataMLOGIT.dta", replace

* -------------------------------
* -------------------------------
* ---- here from R    -----------
* -------------------------------
* -------------------------------
* --- louvain clusters ----------
* -------------------------------
* -------------------------------
* -- dist_vars "neg_conseq_immi pos_atti_immigr positive_muslims ident_pol_crit  low_appreciation trust_institutions  soc_trust "

* ----------------------------------------
* -- take care order of latent classes ! -
* -- seems to depend on random seed and --
* -- number of executions ---------------- 
* ----------------------------------------
* --- fits if Stata starts completely new!
set seed 123456
import delimited "E:\projekte\FGZ_segmentation\daten\andere\more_in_common\louvain_CL.dat",  delimiter(" ") clear
save "E:\projekte\FGZ_segmentation\daten\andere\more_in_common\louvain_CL.dta",   replace

global graphs "E:\projekte\FGZ_diskr_inst\0_publikationen\polarisierung_MC\graphs"
global out "E:\projekte\FGZ_diskr_inst\0_publikationen\polarisierung_MC\out"
global data_zw "E:\projekte\FGZ_segmentation\daten\andere\more_in_common"
global data_out "E:\projekte\FGZ_diskr_inst\0_publikationen\polarisierung_MC\data"

use $data_zw\more_in_common_polarization_dataMLOGIT.dta, clear
merge 1:1 id_base using "E:\projekte\FGZ_segmentation\daten\andere\more_in_common\louvain_CL.dta"

cor neg_conseq_immi pos_atti_immigr positive_muslims ident_pol_crit
cor neg_conseq_immi pos_atti_immigr positive_muslims ident_pol_crit  low_appreciation trust_institutions //  soc_trust

global dist_vars "neg_conseq_immi pos_atti_immigr positive_muslims ident_pol_crit  low_appreciation trust_institutions" //  soc_trust "

tab cluster, mis
sum $dist_vars
corr $dist_vars
factor $dist_vars, blank(.45)
bysort cluster: sum $dist_vars

gen cluster_louvain = cluster
drop cluster

lab def cluster_louvain 1 "conservative - skeptical" 2 "open - trusting" 3 "middle"
lab val cluster cluster_louvain
tab cluster_louvain, mis
numlabel cluster_louvain, add


* ---------------------------------------------------------------------------
* ---------------------------------------------------------------------------
* --------------- descriptive statistics for all variables ------------------
* ---------------------------------------------------------------------------
* ---------------------------------------------------------------------------


tabstat $dist_vars, stat(mean sd min max) long
fsum $actor_attrib, label

descr $pol_vars
descr $dist_vars

fsum $dist_vars, label
fsum frau migrant alter hh_income_i  hh_size high_educ hierarchie hat_kinder relig_c2 relig_c3 relig_c4 relig_c5  religiousness  Care Fairness Authority Loyalty Purity Liberty, label

fsum  opf_belange_fluecht opf_muslim_rechte opf_minderh_beduerfn opf_polit_meinungen , label 
fsum $politems, label
fsum $politems
* ---------------------------------------------------------------------------
* ---------------------------------------------------------------------------
* ---------------------------------------------------------------------------
* --------      estimate Mlogit of Clustermembership here    ----------------
* ---------------------------------------------------------------------------
* ---------------------------------------------------------------------------
* ---------------------------------------------------------------------------

* --- cluster analysis
set seed 123
cluster ward $dist_vars
cluster gen gp = gr(2/10)
cluster tree, cutnumber(10) showcount 
drop gp3-gp10

cluster averagelink $dist_vars, name(avglnk)
cluster tree avglnk, xlabel(, angle(90) labsize(*.75))  cutnumber(20) 

cluster drop _all

set seed 339487731
cluster kmean $dist_vars, k(2) name(kmean2) measure(abs)
cluster kmean $dist_vars, k(3) name(kmean3) measure(abs)
cluster kmean $dist_vars, k(4) name(kmean4) measure(abs)
cluster stop kmean2
cluster stop kmean3
cluster stop kmean4

capture drop  kmean*
capture drop  kmean*

cluster drop _all

set seed 339487731

* --- two cluster solution
capture drop  kmean*
forvalues  i=1(1)50{
	capture drop  kmean`i-1'
	cluster kmean $dist_vars, k(`i') name(kmean`i') measure(abs)
	cluster stop kmean`i'
	}
cluster drop _all
* ---- 2025: here latent profile analysis for  'dist_vars':  "neg_conseq_immi pos_atti_immigr positive_muslims ident_pol_crit  low_appreciation trust_institutions  soc_trust "
* ---- then mlogit to expalain cluster membership

*preserve
*keep id_base $dist_vars
* --startvalues(randompr, draws(20)  difficult) 
forvalues i=2(1)8{ 
	disp "model no." `i'
  gsem ///
	($dist_vars <- _cons), ///
 lclass(C `i') family(gaussian) link(identity) ///
emopts(iterate(30) difficult)
 est sto c`i' 
}
est stat       c2 c3 c4 c5 c6 c7 c8
*c3 c4 c5 c7 c8 c9 c10 c11 c8 c9c11 c12 c13 c14 c15 c16 c17

set seed 1234 //startvalues(randompr, draws(20)  difficult)
gsem ///
	($dist_vars <- _cons), ///
 lclass(C 3) family(gaussian) link(identity)  ///
emopts(iterate(30) difficult)
 est sto c3 

*-- predict class membership
predict cpostmacro*, classposteriorp
egen max = rowmax(cpostmacro*)
generate predclassmacro = 1 if cpostmacro1==max
replace  predclassmacro = 2 if cpostmacro2==max
replace  predclassmacro = 3 if cpostmacro3==max

sum cpostmacro*
tab predclassmacro 

margins, predict(classpr class(1)) ///
predict(classpr class(2)) ///
predict(classpr class(3)) 

marginsplot, xtitle("") ytitle("") ///
xlabel(1 "Class 1" 2 "Class 2" 3 "Class 3" ) ///
title("Predicted Latent Class Probabilities with 95% CI")

* --- two class solution  startvalues(randompr, draws(20)  difficult)startvalues(constantonly) 
set seed 0
set seed 1234
gsem ///
	($dist_vars <- _cons), ///
 lclass(C 2) family(gaussian) link(identity) ///
emopts(iterate(30) difficult)
 est sto c2 
 
predict cpostmacro2CL*, classposteriorp
egen max2CL = rowmax(cpostmacro2CL*)
generate predclassmacro2CL = 1 if cpostmacro2CL1==max2CL
replace  predclassmacro2CL = 2 if cpostmacro2CL2==max2CL

margins, predict(classpr class(1)) ///
predict(classpr class(2)) 

marginsplot, xtitle("") ytitle("") ///
xlabel(1 "Class 1" 2 "Class 2" ) ///
title("Predicted Latent Class Probabilities with 95% CI")


gen cluster = predclassmacro
tab cluster
gen cluster2CL = predclassmacro2CL
tab cluster2CL
*restore

* ---- revision Rationality & Society 3->2  2->1 ?
*lab def cluster 1 "conservative - skeptical" 2 "open - trusting" 3 "middle"
lab def cluster 3 "conservative - skeptical" 1 "open - trusting" 2 "middle"
lab val cluster cluster
numlabel cluster, add
tab cluster
*lab drop cluster

* ---- generate distributons for two cluster solution and check labels
gen cluster2CL01= -cluster2CL +2
*gen cluster2CL01= cluster2CL -1
*lab drop cluster2CL01

lab def cluster2CL01 0 "conservative - skeptical" 1 "open - trusting" 
lab val cluster2CL01 cluster2CL01
numlabel cluster2CL01, add
tab cluster2CL01

gen gp2_01=-gp2+2

logit gp2_01 frau migrant alter hh_income_i  hh_size high_educ hierarchie hat_kinder relig_c2 relig_c3 relig_c4 relig_c5  religiousness Care Fairness Authority Loyalty Purity Liberty
fitstat
eststo logit_ward: margins, dydx(*)  post

logit cluster2CL01 frau migrant alter hh_income_i  hh_size high_educ hierarchie hat_kinder relig_c2 relig_c3 relig_c4 relig_c5  religiousness Care Fairness Authority Loyalty Purity Liberty
fitstat
eststo logit_LCA: margins, dydx(*) post

esttab logit_ward  logit_LCA  using $out/0_RS2025_BINARY_logit.rtf,  star(+ .1 * .05 **  .01 *** .001)  b(%4.3f) not label replace  

tab1 cluster2CL01 gp2_01 if e(sample)


logit cluster2CL01 frau migrant alter hh_income_i  hh_size high_educ hierarchie hat_kinder relig_c2 relig_c3 relig_c4 relig_c5  religiousness Care Fairness Authority Loyalty Purity Liberty
margins, dydx (Care Fairness Authority Loyalty Purity Liberty ) post
	estimates store logit_cluster
	
coefplot logit_cluster, coeflabel(Care = `"Care"' Fairness = `"Fairness"' Authority = `"Authority"' Loyalty = `"Loyalty"' Purity = `"Purity"' Liberty = `"Liberty"') xline(0) eqlabel("{bf:open-trusting vs. conservative-sceptical}", labsize(vlarge))  
graph export $graphs\0_RS2025_logit_QAP_cluster2.wmf,  as(wmf) replace  	



* -- baseoutcome()
mlogit cluster frau migrant alter hh_income_i  hh_size high_educ hierarchie hat_kinder relig_c2 relig_c3 relig_c4 relig_c5  religiousness , baseoutcome(1)
mlogit cluster   Care Fairness Authority Loyalty Purity Liberty, baseoutcome(1)
mlogit cluster frau migrant alter hh_income_i  hh_size high_educ hierarchie hat_kinder relig_c2 relig_c3 relig_c4 relig_c5  religiousness  Care Fairness Authority Loyalty Purity Liberty, baseoutcome(1)
fitstat
est sto mlogit_cluster
margins, dydx(Care Fairness Authority Loyalty Purity Liberty) predict(outcome(1)) predict(outcome(2)) predict(outcome(3))
marginsplot
marginsplot,  title(" ")  ytitle("AMEs cluster membership" ) xtitle(" " " " "cluster membership: ") ///
plotregion(lcolor(white) margin(medlarge))  legend(region(color(white)))  plot( , label(conservative-skeptical open-trusting middle))
graph export $graphs\0_RS2025_mlogit_cluster1.wmf,  as(wmf) replace  	
 
forvalues i = 1/3 {
	margins, dydx (Care Fairness Authority Loyalty Purity Liberty ) predict(outcome(`i')) post
	estimates store ame`i'
	quietly estimates restore mlogit_cluster
	}
 
coefplot mlogit_cluster, keep(1 : Care Fairness Authority Loyalty Purity Liberty  /// 
						2 : Care Fairness Authority Loyalty Purity Liberty  /// 
						3 : Care Fairness Authority Loyalty Purity Liberty ) /// 
								 omitted bylabel(Log Odds)  ||(ame1,aseq(1)\ ame2,aseq(2)\ ame3,aseq(3) ) ///
						, bylabel(average mariginal effects of latent class membership)  ||,xline(0) eqlabels("{bf:open-trusting}" "{bf:middle}" "{bf:conservative-sceptical}"  , asheadings)  byopts(iscale(.9))	///
						coeflabel(Care = `"Care"' Fairness = `"Fairness"' Authority = `"Authority"' Loyalty = `"Loyalty"' Purity = `"Purity"' Liberty = `"Liberty"') ciopts(recast(rcap) color(gray)) xtitle() // byopts(xrescale)
graph export $graphs/0_RS2025_mlogit_cluster2.wmf,  as(wmf) replace  			


forvalues i = 1/3 {
	mlogit cluster frau migrant alter hh_income_i  hh_size high_educ hierarchie hat_kinder relig_c2 relig_c3 relig_c4 relig_c5  religiousness  		Care Fairness Authority Loyalty Purity Liberty, baseoutcome(1)
	eststo m`i': margins, dydx(*) predict(outcome(`i')) post
}
esttab m1 m2 m3 using $out/0_RS2025_mlogit.rtf,  star(+ .1 * .05 **  .01 *** .001)  b(%4.3f) not label replace  

* ---------------------------------
* ---------------------------------
* ---------------------------------
* --- plot 3 clusters -------------
* ---------------------------------
* ---------------------------------
* ---------------------------------

kdensity neg_conseq_immi if cluster == 1
kdensity neg_conseq_immi if cluster == 2
kdensity neg_conseq_immi if cluster == 3

gen x_axis = _n in 1/600 /**create x-axis appropriate to the range, 60 points**/
replace x_axis = ( x_axis - 300 ) / 125
sum x_axis // just to get a x axis with appropriate range for the plot

kdensity neg_conseq_immi if cluster == 1,  generate(clu1) at(x_axis ) nodraw
kdensity neg_conseq_immi if cluster == 2,  generate(clu2) at(x_axis ) nodraw
kdensity neg_conseq_immi if cluster == 3,  generate(clu3) at(x_axis ) nodraw
lab var clu3 "conservative - skeptical"
lab var clu1 "open - trusting"
lab var clu2 "middle"

graph twoway connected clu1 clu2 clu3 x_axis , /// 
graphregion(fcolor(white) margin(zero) ilcolor(white) ) plotregion(lcolor(white) margin(medlarge) fcolor(white) ilcolor(white) ) ///
lcolor(black gray black  ) lwidth(small medthick small  ) lpattern(shortdash solid longdash  ) ///
ylabel( 0(.2)1, glcolor(white) labsize(5) ) xlabel(, glcolor(white) labsize(5) ) msymbol(none none none) xtitle(" ") ///
legend(region(lcolor(white))  )legend(region(lcolor(white)) size(5) cols(1) ring(0) position(6) order( 1 2 3))
drop  clu1 clu2 clu3
drop x_axis
graph export $data_zw\0_RS2025_neg_conseq_immi_engl.wmf, as(wmf) replace

* pos_atti_immigr

kdensity pos_atti_immigr  if cluster == 1
kdensity pos_atti_immigr  if cluster == 2
kdensity pos_atti_immigr  if cluster == 3

gen x_axis = _n in 1/600 /**create x-axis appropriate to the range, 60 points**/
replace x_axis = ( x_axis - 300 ) / 125
sum x_axis // just to get a x axis with appropriate range for the plot

kdensity pos_atti_immigr  if cluster == 1,  generate(clu1) at(x_axis ) nodraw
kdensity pos_atti_immigr  if cluster == 2,  generate(clu2) at(x_axis ) nodraw
kdensity pos_atti_immigr  if cluster == 3,  generate(clu3) at(x_axis ) nodraw
lab var clu3 "conservative - skeptical"
lab var clu1 "open - trusting"
lab var clu2 "middle"

graph twoway connected clu1 clu2 clu3 x_axis , /// 
graphregion(fcolor(white) margin(zero) ilcolor(white) ) plotregion(lcolor(white) margin(medlarge) fcolor(white) ilcolor(white) ) ///
lcolor(black gray black  ) lwidth(small medthick small  ) lpattern(shortdash solid longdash  ) ///
ylabel( 0(.2)1, glcolor(white) labsize(5) ) xlabel(, glcolor(white) labsize(5) ) msymbol(none none none) xtitle(" ") ///
legend(region(lcolor(white))  )legend(region(lcolor(white)) size(5) cols(1) ring(0) position(6) order( 1 2 3 ))
drop  clu1 clu2 clu3
drop x_axis
graph export $data_zw\0_RS2025_pos_atti_immigr_engl.wmf, as(wmf) replace

* positive_muslims 

kdensity  positive_muslims  if cluster == 1
kdensity  positive_muslims   if cluster == 2
kdensity  positive_muslims   if cluster == 3

gen x_axis = _n in 1/600 /**create x-axis appropriate to the range, 60 points**/
replace x_axis = ( x_axis - 300 ) / 125
sum x_axis // just to get a x axis with appropriate range for the plot

kdensity  positive_muslims   if cluster == 1,  generate(clu1) at(x_axis ) nodraw
kdensity  positive_muslims  if cluster == 2,  generate(clu2) at(x_axis ) nodraw
kdensity  positive_muslims   if cluster == 3,  generate(clu3) at(x_axis ) nodraw
lab var clu3 "conservative - skeptical"
lab var clu1 "open - trusting"
lab var clu2 "middle"

graph twoway connected clu1 clu2 clu3 x_axis , /// 
graphregion(fcolor(white) margin(zero) ilcolor(white) ) plotregion(lcolor(white) margin(medlarge) fcolor(white) ilcolor(white) ) ///
lcolor(black gray black  ) lwidth(small medthick small  ) lpattern(shortdash solid longdash  ) ///
ylabel( 0(.2)1, glcolor(white) labsize(5) ) xlabel(, glcolor(white) labsize(5) ) msymbol(none none none) xtitle(" ") ///
legend(region(lcolor(white))  )legend(region(lcolor(white)) size(5) cols(1) ring(0) position(6) order( 1 2 3))
drop  clu1 clu2 clu3
drop x_axis
graph export $data_zw\0_RS2025_positive_muslims_engl.wmf, as(wmf) replace

* ident_pol_crit

kdensity ident_pol_crit  if cluster == 1
kdensity ident_pol_crit  if cluster == 2
kdensity ident_pol_crit  if cluster == 3

gen x_axis = _n in 1/600 /**create x-axis appropriate to the range, 60 points**/
replace x_axis = ( x_axis - 300 ) / 125
sum x_axis // just to get a x axis with appropriate range for the plot

kdensity ident_pol_crit  if cluster == 1,  generate(clu1) at(x_axis ) nodraw
kdensity ident_pol_crit  if cluster == 2,  generate(clu2) at(x_axis ) nodraw
kdensity ident_pol_crit  if cluster == 3,  generate(clu3) at(x_axis ) nodraw
lab var clu3 "conservative - skeptical"
lab var clu1 "open - trusting"
lab var clu2 "middle"

graph twoway connected clu1 clu2 clu3 x_axis , /// 
graphregion(fcolor(white) margin(zero) ilcolor(white) ) plotregion(lcolor(white) margin(medlarge) fcolor(white) ilcolor(white) ) ///
lcolor(black gray black  ) lwidth(small medthick small  ) lpattern(shortdash solid longdash  ) ///
ylabel( 0(.2)1, glcolor(white) labsize(5) ) xlabel(, glcolor(white) labsize(5) ) msymbol(none none none) xtitle(" ") ///
legend(region(lcolor(white))  )legend(region(lcolor(white)) size(5) cols(1) ring(0) position(6) order( 1 2 3))
drop  clu1 clu2 clu3
drop x_axis
graph export $data_zw\0_RS2025_ident_pol_crit_engl.wmf, as(wmf) replace


*low_appreciation

kdensity low_appreciation  if cluster == 1
kdensity low_appreciation  if cluster == 2
kdensity low_appreciation  if cluster == 3

gen x_axis = _n in 1/600 /**create x-axis appropriate to the range, 60 points**/
replace x_axis = ( x_axis - 300 ) / 125
sum x_axis // just to get a x axis with appropriate range for the plot

kdensity low_appreciation  if cluster == 1,  generate(clu1) at(x_axis ) nodraw
kdensity low_appreciation  if cluster == 2,  generate(clu2) at(x_axis ) nodraw
kdensity low_appreciation  if cluster == 3,  generate(clu3) at(x_axis ) nodraw
lab var clu3 "conservative - skeptical"
lab var clu1 "open - trusting"
lab var clu2 "middle"

graph twoway connected clu1 clu2 clu3 x_axis , /// 
graphregion(fcolor(white) margin(zero) ilcolor(white) ) plotregion(lcolor(white) margin(medlarge) fcolor(white) ilcolor(white) ) ///
lcolor(black gray black  ) lwidth(small medthick small  ) lpattern(shortdash solid longdash  ) ///
ylabel( 0(.2)1, glcolor(white) labsize(5) ) xlabel(, glcolor(white) labsize(5) ) msymbol(none none none) xtitle(" ") ///
legend(region(lcolor(white))  )legend(region(lcolor(white)) size(5) cols(1) ring(0) position(6) order( 1 2 3))
drop  clu1 clu2 clu3
drop x_axis
graph export $data_zw\0_RS2025_low_appreciation_engl.wmf, as(wmf) replace


* trust_institutions 
kdensity trust_institutions  if cluster == 1
kdensity trust_institutions  if cluster == 2
kdensity trust_institutions  if cluster == 3

gen x_axis = _n in 1/600 /**create x-axis appropriate to the range, 60 points**/
replace x_axis = ( x_axis - 300 ) / 125
sum x_axis // just to get a x axis with appropriate range for the plot

kdensity trust_institutions  if cluster == 1,  generate(clu1) at(x_axis ) nodraw
kdensity trust_institutions  if cluster == 2,  generate(clu2) at(x_axis ) nodraw
kdensity trust_institutions  if cluster == 3,  generate(clu3) at(x_axis ) nodraw
lab var clu3 "conservative - skeptical"
lab var clu1 "open - trusting"
lab var clu2 "middle"

graph twoway connected clu1 clu2 clu3 x_axis , /// 
graphregion(fcolor(white) margin(zero) ilcolor(white) ) plotregion(lcolor(white) margin(medlarge) fcolor(white) ilcolor(white) ) ///
lcolor(black gray black  ) lwidth(small medthick small  ) lpattern(shortdash solid longdash  ) ///
ylabel( 0(.2)1, glcolor(white) labsize(5) ) xlabel(, glcolor(white) labsize(5) ) msymbol(none none none) xtitle(" ") ///
legend(region(lcolor(white))  )legend(region(lcolor(white)) size(5) cols(1) ring(0) position(6) order( 1 2 3))
drop  clu1 clu2 clu3
drop x_axis
graph export $data_zw\0_RS2025_trust_institutions_engl.wmf, as(wmf) replace


* soc_trust
kdensity soc_trust  if cluster == 1
kdensity soc_trust  if cluster == 2
kdensity soc_trust  if cluster == 3

gen x_axis = _n in 1/600 /**create x-axis appropriate to the range, 60 points**/
replace x_axis = ( x_axis - 300 ) / 125 + 3
sum x_axis // just to get a x axis with appropriate range for the plot

kdensity soc_trust  if cluster == 1,  generate(clu1) at(x_axis ) nodraw
kdensity soc_trust  if cluster == 2,  generate(clu2) at(x_axis ) nodraw
kdensity soc_trust  if cluster == 3,  generate(clu3) at(x_axis ) nodraw
lab var clu3 "conservative - skeptical"
lab var clu1 "open - trusting"
lab var clu2 "middle"

graph twoway connected clu1 clu2 clu3 x_axis , /// 
graphregion(fcolor(white) margin(zero) ilcolor(white) ) plotregion(lcolor(white) margin(medlarge) fcolor(white) ilcolor(white) ) ///
lcolor(black gray black  ) lwidth(small medthick small  ) lpattern(shortdash solid longdash  ) ///
ylabel( 0(.2)1, glcolor(white) labsize(5) ) xlabel(, glcolor(white) labsize(5) ) msymbol(none none none) xtitle(" ") ///
legend(region(lcolor(white))  )legend(region(lcolor(white)) size(5) cols(1) ring(0) position(6) order( 1 2 3))
drop  clu1 clu2 clu3
drop x_axis
graph export $data_zw\0_RS2025_soc_trust_engl.wmf, as(wmf) replace

* ---------------------------------
* ---------------------------------
* ---------------------------------
* --- binary clusters -------------
* ---------------------------------
* ---------------------------------
* ---------------------------------
* -- lab def cluster2CL01 0 "conservative - skeptical" 1 "open - trusting" 

kdensity neg_conseq_immi if cluster2CL01  == 0
kdensity neg_conseq_immi if cluster2CL01  == 1

gen x_axis = _n in 1/600 /**create x-axis appropriate to the range, 60 points**/
replace x_axis = ( x_axis - 300 ) / 125
sum x_axis // just to get a x axis with appropriate range for the plot

kdensity neg_conseq_immi if cluster2CL01 == 0,  generate(clu1) at(x_axis ) nodraw
kdensity neg_conseq_immi if cluster2CL01 == 1,  generate(clu2) at(x_axis ) nodraw
lab var clu1 "conservative - skeptical"
lab var clu2 "open - trusting"

graph twoway connected clu1 clu2  x_axis , /// 
graphregion(fcolor(white) margin(zero) ilcolor(white) ) plotregion(lcolor(white) margin(medlarge) fcolor(white) ilcolor(white) ) ///
lcolor(gray  black  ) lwidth(medthick  small  ) lpattern(longdash shortdash   ) ///
ylabel( 0(.2)1, glcolor(white) labsize(5) ) xlabel(, glcolor(white) labsize(5) ) msymbol(none none none) xtitle(" ") ///
legend(region(lcolor(white))  )legend(region(lcolor(white)) size(5) cols(1) ring(0) position(11) order(2 1 ))
drop  clu1 clu2 
drop x_axis
graph export $data_zw\0_RS2025_BINARY_neg_conseq_immi_engl.wmf, as(wmf) replace

* pos_atti_immigr

kdensity pos_atti_immigr if cluster2CL01  == 0
kdensity pos_atti_immigr if cluster2CL01  == 1

gen x_axis = _n in 1/600 /**create x-axis appropriate to the range, 60 points**/
replace x_axis = ( x_axis - 300 ) / 125
sum x_axis // just to get a x axis with appropriate range for the plot

kdensity pos_atti_immigr if cluster2CL01 == 0,  generate(clu1) at(x_axis ) nodraw
kdensity pos_atti_immigr if cluster2CL01 == 1,  generate(clu2) at(x_axis ) nodraw
lab var clu1 "conservative - skeptical"
lab var clu2 "open - trusting"

graph twoway connected clu1 clu2  x_axis , /// 
graphregion(fcolor(white) margin(zero) ilcolor(white) ) plotregion(lcolor(white) margin(medlarge) fcolor(white) ilcolor(white) ) ///
lcolor(gray  black  ) lwidth(medthick  small  ) lpattern(longdash shortdash   ) ///
ylabel( 0(.2)1, glcolor(white) labsize(5) ) xlabel(, glcolor(white) labsize(5) ) msymbol(none none none) xtitle(" ") ///
legend(region(lcolor(white))  )legend(region(lcolor(white)) size(5) cols(1) ring(0) position(11) order(2 1 ))
drop  clu1 clu2 
drop x_axis
graph export $data_zw\0_RS2025_BINARY_pos_atti_immigr.wmf, as(wmf) replace


* positive_muslims 

kdensity positive_muslims if cluster2CL01  == 0
kdensity positive_muslims if cluster2CL01  == 1

gen x_axis = _n in 1/600 /**create x-axis appropriate to the range, 60 points**/
replace x_axis = ( x_axis - 300 ) / 125
sum x_axis // just to get a x axis with appropriate range for the plot

kdensity positive_muslims if cluster2CL01 == 0,  generate(clu1) at(x_axis ) nodraw
kdensity positive_muslims if cluster2CL01 == 1,  generate(clu2) at(x_axis ) nodraw
lab var clu1 "conservative - skeptical"
lab var clu2 "open - trusting"

graph twoway connected clu1 clu2  x_axis , /// 
graphregion(fcolor(white) margin(zero) ilcolor(white) ) plotregion(lcolor(white) margin(medlarge) fcolor(white) ilcolor(white) ) ///
lcolor(gray  black  ) lwidth(medthick  small  ) lpattern(longdash shortdash   ) ///
ylabel( 0(.2)1, glcolor(white) labsize(5) ) xlabel(, glcolor(white) labsize(5) ) msymbol(none none none) xtitle(" ") ///
legend(region(lcolor(white))  )legend(region(lcolor(white)) size(5) cols(1) ring(0) position(11) order(2 1 ))
drop  clu1 clu2 
drop x_axis
graph export $data_zw\0_RS2025_BINARY_positive_muslims.wmf, as(wmf) replace

* ident_pol_crit

kdensity ident_pol_crit if cluster2CL01  == 0
kdensity ident_pol_crit if cluster2CL01  == 1

gen x_axis = _n in 1/600 /**create x-axis appropriate to the range, 60 points**/
replace x_axis = ( x_axis - 300 ) / 125
sum x_axis // just to get a x axis with appropriate range for the plot

kdensity ident_pol_crit if cluster2CL01 == 0,  generate(clu1) at(x_axis ) nodraw
kdensity ident_pol_crit if cluster2CL01 == 1,  generate(clu2) at(x_axis ) nodraw
lab var clu1 "conservative - skeptical"
lab var clu2 "open - trusting"

graph twoway connected clu1 clu2  x_axis , /// 
graphregion(fcolor(white) margin(zero) ilcolor(white) ) plotregion(lcolor(white) margin(medlarge) fcolor(white) ilcolor(white) ) ///
lcolor(gray  black  ) lwidth(medthick  small  ) lpattern(longdash shortdash   ) ///
ylabel( 0(.2)1, glcolor(white) labsize(5) ) xlabel(, glcolor(white) labsize(5) ) msymbol(none none none) xtitle(" ") ///
legend(region(lcolor(white))  )legend(region(lcolor(white)) size(5) cols(1) ring(0) position(11) order(2 1 ))
drop  clu1 clu2 
drop x_axis
graph export $data_zw\0_RS2025_BINARY_ident_pol_crit.wmf, as(wmf) replace

*low_appreciation

kdensity low_appreciation if cluster2CL01  == 0
kdensity low_appreciation if cluster2CL01  == 1

gen x_axis = _n in 1/600 /**create x-axis appropriate to the range, 60 points**/
replace x_axis = ( x_axis - 300 ) / 125
sum x_axis // just to get a x axis with appropriate range for the plot

kdensity low_appreciation if cluster2CL01 == 0,  generate(clu1) at(x_axis ) nodraw
kdensity low_appreciation if cluster2CL01 == 1,  generate(clu2) at(x_axis ) nodraw
lab var clu1 "conservative - skeptical"
lab var clu2 "open - trusting"

graph twoway connected clu1 clu2  x_axis , /// 
graphregion(fcolor(white) margin(zero) ilcolor(white) ) plotregion(lcolor(white) margin(medlarge) fcolor(white) ilcolor(white) ) ///
lcolor(gray  black  ) lwidth(medthick  small  ) lpattern(longdash shortdash   ) ///
ylabel( 0(.2)1, glcolor(white) labsize(5) ) xlabel(, glcolor(white) labsize(5) ) msymbol(none none none) xtitle(" ") ///
legend(region(lcolor(white))  )legend(region(lcolor(white)) size(5) cols(1) ring(0) position(11) order(2 1 ))
drop  clu1 clu2 
drop x_axis
graph export $data_zw\0_RS2025_BINARY_low_appreciation.wmf, as(wmf) replace

* trust_institutions 

kdensity trust_institutions if cluster2CL01  == 0
kdensity trust_institutions if cluster2CL01  == 1

gen x_axis = _n in 1/600 /**create x-axis appropriate to the range, 60 points**/
replace x_axis = ( x_axis - 300 ) / 125
sum x_axis // just to get a x axis with appropriate range for the plot

kdensity trust_institutions if cluster2CL01 == 0,  generate(clu1) at(x_axis ) nodraw
kdensity trust_institutions if cluster2CL01 == 1,  generate(clu2) at(x_axis ) nodraw
lab var clu1 "conservative - skeptical"
lab var clu2 "open - trusting"

graph twoway connected clu1 clu2  x_axis , /// 
graphregion(fcolor(white) margin(zero) ilcolor(white) ) plotregion(lcolor(white) margin(medlarge) fcolor(white) ilcolor(white) ) ///
lcolor(gray  black  ) lwidth(medthick  small  ) lpattern(longdash shortdash   ) ///
ylabel( 0(.2)1, glcolor(white) labsize(5) ) xlabel(, glcolor(white) labsize(5) ) msymbol(none none none) xtitle(" ") ///
legend(region(lcolor(white))  )legend(region(lcolor(white)) size(5) cols(1) ring(0) position(11) order(2 1 ))
drop  clu1 clu2 
drop x_axis
graph export $data_zw\0_RS2025_BINARY_trust_institutions.wmf, as(wmf) replace

* soc_trust


save $data_zw\polarization2025.dta, replace

use $data_zw\polarization2025.dta, clear
tab schulabschl
tab religiousness
pwcorr Care Fairness Authority Loyalty Purity Liberty neg_conseq_immi pos_atti_immigr positive_muslims ident_pol_crit  low_appreciation trust_institutions  soc_trust, sig





* -------------------------------
* -------------------------------
* ---- data for MRQAP------------
* -------------------------------
* -------------------------------
*gen rand = runiform(0,1) // default (0,1)
	*keep if rand <=  0.1 //  skip keep for full data, or split into e.g. 4 samples
* --- aufnehmen: control soc_trust, rs32_*: Herkunftsland => done!

global graphs "E:\projekte\FGZ_diskr_inst\0_publikationen\polarisierung_MC\graphs"
global out "E:\projekte\FGZ_diskr_inst\0_publikationen\polarisierung_MC\out"
global data_zw "E:\projekte\FGZ_segmentation\daten\andere\more_in_common"
global data_out "E:\projekte\FGZ_diskr_inst\0_publikationen\polarisierung_MC\data"

global actor_attrib "id_base out_group_openness bundesland frau alter migrant schulabschl wohnort religiousness reli_group relig_comm hierarchie hh_income_i hh_size hat_kinder employment Care Fairness Authority Loyalty Purity Liberty authorit zeitungen internet fernsehen radiosender social_media f_online_rel_behavior f_online_intensity control soc_trust Greece Italie Poland Romania former_SU former_Yugo Spain_Portugal Syria Turkey Vietnam other NA NET_Europe deutsch s_east_europa other_mig"
disp "$actor_attrib"
global dist_vars "neg_conseq_immi pos_atti_immigr positive_muslims ident_pol_crit  low_appreciation trust_institutions  "
disp "$dist_vars"	
	
set seed 12345
forvalues i=1(1)1{
	use $data_zw\polarization2025.dta, clear
	*keep if _n <= 2000
	matrix dissimilarity network = $dist_vars , absolute  // Euclidean absolute
	matrix list network
	*makesymmetric(network) 
	svmat network, names(net_ii)
	
	foreach var of varlist net_ii*{
		replace `var' = 1/`var' * 100 if `var' != 0 // make distance to similarity 
		replace `var' = 100 if `var' > 100 // activate and check robustness: outliers of extreme similarity cut to 100
		}
	
	savin net_ii* using $data_out\0_RS2025_more_in_common_similarity_network`i'.dta , replace
	savin $actor_attrib using $data_out\0_RS2025_more_in_common_two_mode_actors`i'.dta, replace
	
	export delimited net_ii* using  $data_out\0_RS2025_more_in_common_similarity_network_TRUNC100`i'.dat,  delimiter(" ") novar nolabel replace // activate for robustness check, deactivate all other
	*export delimited net_ii* using  $data_out\0_RS2025_more_in_common_similarity_network`i'.dat,  delimiter(" ") novar nolabel replace
	*export delimited $actor_attrib using $data_out\0_RS2025_more_in_common_two_mode_actors`i'.dat,  delimiter(" ")  nolabel replace
	
	*capture drop net_ii* rand
	matrix drop network
	}	
	
capture drop net_ii* rand

forvalues i=1(1)1{
	use $data_zw\0_RS2025_more_in_common_similarity_network`i'.dta, clear
		foreach var of varlist net_ii*{
		sum `var' // if `var' != 0
	}
}
kdensity net_ii22 
kdensity net_ii1998 

preserve
gen id=_n
keep id net_ii*
reshape long net_ii, i(id) j(alteri)
sum net_ii
sum net_ii if net_ii < 200
sum net_ii if net_ii < 150
sum net_ii if net_ii < 100
sum net_ii if net_ii < 30 
*restore

kdensity net_ii , xtitle("similarity in polarizing attitudes") title("")
graph save "Graph" "E:\projekte\FGZ_diskr_inst\0_publikationen\polarisierung_MC\jobs\graphs\graph_density.gph", replace
graph export "E:\projekte\FGZ_diskr_inst\0_publikationen\polarisierung_MC\jobs\graphs\graph_density.wmf", replace
restore

* ----- values > 100
disp (4000000 - 3996918) / 4000000 * 100

/*kdensity net_ii if net_ii < 150
kdensity net_ii if net_ii < 100
kdensity net_ii if net_ii < 200
kdensity net_ii if net_ii < 30
sum net_ii
sum net_ii if net_ii < 200
sum net_ii if net_ii < 150
sum net_ii if net_ii < 100
sum net_ii if net_ii < 30 */



* -------------------------------
* -------------------------------
* ---- random samples -----------
* ---- for similarity matrices --
* -------------------------------
* -------------------------------

set seed 12345
forvalues i=1(1)20{
	use $data_zw\more_in_common_polarization_data.dta, clear
	gen rand = runiform(0,1) // default (0,1)
	keep if rand <=  0.075 //  0.025
	matrix dissimilarity network = $dist_vars , absolute  // Euclidean absolute
	matrix list network
	svmat  float  network, names(net_ii)

	foreach var of varlist net_ii*{
		replace `var' = 1/`var' * 10 if `var' != 0 // make distance to similarity 
		replace `var' = round(`var')
		sum `var' if `var' != 0 
		replace `var' = `var'- r(min)  if `var' != 0 // + 1; scale from 0 to value => highest value = hightest similarity
		}
		
	savin net_ii* using $data_zw\more_in_common_similarity_network`i'.dta , replace
	savin $actor_attrib using $data_zw\more_in_common_two_mode_actors`i'.dta, replace
	
	export delimited net_ii* using  $data_zw\more_in_common_similarity_network`i'.dat,  delimiter(" ") novar nolabel replace
	export delimited $actor_attrib using $data_zw\more_in_common_two_mode_actors`i'.dat,  delimiter(" ")  nolabel replace
	
	capture drop net_ii* rand
	matrix drop network
	}	
	
capture drop net_ii* rand

forvalues i=1(1)20{
	use $data_zw\similarity_network`i'.dta, clear
		foreach var of varlist net_ii*{
		sum `var' // if `var' != 0
	}
}
kdensity net_ii22 


* -------------------------------
* -------------------------------
* ---- all data here ------------
* -------------------------------
* -------------------------------

set seed 12345
forvalues i=1(1)1{
	use $data_zw\more_in_common_polarization_data.dta, clear
	matrix dissimilarity network = $dist_vars , absolute  // Euclidean absolute
	matrix list network
	svmat  float  network, names(net_ii)

	foreach var of varlist net_ii*{
		replace `var' = 1/`var' * 10 if `var' != 0 // make distance to similarity 
		replace `var' = round(`var')
		sum `var' if `var' != 0 
		replace `var' = `var'- r(min)  if `var' != 0 // + 1; scale from 0 to value => highest value = hightest similarity
		}
		
	savin net_ii* using $data_zw\more_in_common_similarity_network2000.dta , replace
	savin $actor_attrib using $data_zw\more_in_common_two_mode_actors2000.dta, replace
	
	export delimited net_ii* using  $data_zw\more_in_common_similarity_network2000.dat,  delimiter(" ") novar nolabel replace
	export delimited $actor_attrib using $data_zw\more_in_common_two_mode_actors2000.dat,  delimiter(" ")  nolabel replace
	
	capture drop net_ii* 
	matrix drop network
	}	
	


* ----------------- test 
clear
input id euro dm
1 20 30
2 10 40
3 30 20
end
list, clean
matrix dissimilarity network = euro dm, absolute  // Euclidean absolute
matrix list network
svmat  float  network, names(net_ii)
foreach var of varlist net_ii*{
	    gen `var'_1 = `var'
		sum `var'_1 if `var'_1 != 0
		replace `var'_1 = -`var'_1 + r(max) + 1 if `var'_1 != 0
		*gen `var'_2 = round(`var'_1)
		}
list, clean