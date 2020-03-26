
library(shiny)

terms.top <- HTML('<span style="font-weight:bold"> Description </span><br> The aspirin benefit harm calculator presents the expected number of major bleeds caused and cardiovascular events 
                   avoided with aspirin among patients without established cardiovascular disease (CVD).')
                     
exclude.if <- HTML('<br><br><span style="font-weight:bold;">The calculator is NOT suitable for patients with the following conditions:</span>
                     <UL>
                     <LI> Aged less than 30 years
                     <LI> Aged 75 years or more
                     <LI> Established CVD
                     <LI> Heart failure
                     <LI> Atrial fibrillation
                     <LI> Familial hypercholesterolaemia
                     <LI> Chronic kidney disease (eGFR <30)
                     <LI> Diabetes with overt nephropathy OR diabetes with other renal disease (eGFR <45)
                     <LI> Intracerebral bleed
                     <LI> Currently receiving aspirin, other antiplatelet medication, or anticoagulant medication
                     </UL>')

legal.title <- HTML('<span style="font-weight:bold;"> Legal Disclaimer </span>')

full.disclaimer <- HTML('
<OL>
<LI> The calculator is intended for use by medical practitioners only.  It has been designed with the aim of assisting practitioners in their discussions with patients for whom aspirin is being considered for the primary prevention of CVD.  The calculator is merely a tool to assist the medical practitioner’s decision-making.  It is not a replacement for the medical practitioner’s own independent judgement and expertise.
<LI> The site and the calculator are made available as a research courtesy, on an “as is” basis. To the maximum extent permitted by law, the University of Auckland, its licensors and the study authors exclude all liability for any direct or indirect loss or damage, or exemplary damages, whether for breach of contract, tort (including negligence), breach of statutory duty or otherwise, in connection with its use or non-availability.
<LI> The calculator has been developed based on, and intended for use within, a NZ population. It should not be used for individuals outside these populations. 
<LI> The site, including its content and the calculator, are owned by the University of Auckland and its licensors.  The calculator may be used by medical practitioners for the purposes of their research, and for their internal business practices, but must not be further used, made available to third parties or commercialised without the consent of the University of Auckland.  No part of this site or its content may be adapted or copied, in whole or in part, except in the ordinary course of use for its permitted purpose.
<LI> The site may have features that integrate or link to third party sites or applications.  The University of Auckland, its licensors and the study authors have no responsibility or liability for those third party sites and applications.
<LI> INDEMNITY:  In accessing and using the site, you agree to indemnify the University of Auckland (including its officers, directors, employees and agents), its licensors and the study authors against all losses, damages, costs and expenses (including legal fees on a solicitor-own client basis) suffered by any of them arising out of your use or misuse of the site (including the calculator) or any breach of these terms and conditions.
</OL>                   
                   ')

more.info <- HTML('
The decision to initiate aspirin for the primary prevention of cardiovascular disease (CVD) requires careful consideration of both absolute treatment benefits and harms.(1) The most significant harm associated with aspirin is a major bleed.(1) The absolute magnitude of the CVD benefits and the bleeding harms of aspirin depends primarily on baseline (untreated) absolute risks of these outcomes, which vary considerably depending on the presence of a range of risk factors.(2) <br>
<br> Sex-specific Cox proportional hazards models have been developed for predicting the 5-year risk of a first CVD event(3) and a major bleed(4) using a contemporary cohort of over 385,000 people without established CVD who had CVD risk assessed in New Zealand primary care.<br>
<br> For clinicians and their patients considering the use of aspirin for the primary prevention of CVD, these new CVD and bleeding equations can be used together, to simultaneously provide a personalised estimate of the expected benefit of aspirin (number of CVD events avoided) along with its harm (number of major bleeds caused) over 5 years.<br>
<br> For an individual patient, enter or select relevant data for each field under Patient Details. Hover over fields with question mark for a brief description. Further information about each field is provided in Reference 4.<br>
<br> After entering all required fields for your patient, you will receive the following output:
<UL>
<LI> 5-year risk of a major bleed (without and with aspirin, as a % and per 1,000 people) 
<LI> 5-year risk of CVD (without and with aspirin, as a % and per 1,000 people) 
<LI> Estimated number of major bleeds caused by treatment with aspirin for 5 years (per 1,000 people)
<LI> Estimated number of major CVD events avoided by treatment with aspirin for 5 years (per 1,000 people)
</UL>
The default proportional effect of aspirin on CVD events is a 11% reduction, and the default proportional effect of aspirin on major bleeds is a 43% increase (5). The proportional effect of aspirin on CVD events and major bleeds is assumed to be constant, irrespective of the baseline absolute risk of these events.(2) <br>
')

references <- HTML('
<br> <span style="font-weight:bold;"> References </span>
<OL>
<LI> Whitlock EP, Burda BU, Williams SB, et al. Bleeding risks with aspirin use for primary prevention in adults: a systematic review for the U.S. Preventive Services Task Force Ann Intern Med 2016:Published online 12 April 2016.
<LI> Antithrombotic Trialists Collaboration. Aspirin in the primary and secondary prevention of vascular disease: collaborative meta-analysis of individual participant data from randomised trials. Lancet 2009;373:1849-60.
<LI> Pylypchuk R, Wells S, Kerr A, et al. Cardiovascular disease risk prediction equations in 400 000 primary care patients in New Zealand: a derivation and validation study. Lancet 2018;391:1897-907.
<LI> Selak V, Jackson R, Poppe K, et al. Predicting bleeding risk to guide aspirin use for the primary prevention of cardiovascular disease. A cohort study. Annals of Internal Medicine 2019; doi:10.7326/M18-2808.
<LI> Zheng S, Roddick A. Association of aspirin use for primary prevention with cardiovascular events and bleeding events. A systematic review and meta-analysis. JAMA 2019; 321:277-87.
</OL>                   
')
