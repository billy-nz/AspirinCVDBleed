
# Help / Tooltips




output$info.age <- renderUI({
   tags$span(id="info.age",
      popify(icon("question-circle", class="tooltipcol"), title = NULL, placement = "right", trigger = 'hover',
             content = paste0("<p>The CVD and bleeding risk calculators are not appropriate for use in people aged <30 or 75 or more years</p>")))
})

output$info.eth <- renderUI({
   tags$span(id="info.eth",
      popify(icon("question-circle", class="tooltipcol"), title = NULL, placement = "right", trigger = 'hover',
             content = paste0("<p>Self-identified ethnicity and prioritised (Māori > Pacific > Indian > Chinese/Other Asian > European) according to NZ Ethnicity Data Protocols</p>")))
})

output$info.dep <- renderUI({
   tags$span(id="info.dep",
      popify(icon("question-circle", class="tooltipcol"), title = NULL, placement = "right", trigger = 'hover',
             content = paste0("<p> Measured using the New Zealand Index of Deprivation (NZDep), which was constructed from 9 census-derived variables representing 8 dimensions of deprivation </p>")))
})

output$info.smk <- renderUI({
   tags$span(id="info.smk",
      popify(icon("question-circle", class="tooltipcol"), title = NULL, placement = "right", trigger = 'hover',
             content = paste0("<p> Current = current smoker (or ex-smoker who quit smoking less than 12 months ago) </p>",
                              "<p> Ex-smoker = quit 12 or more months ago </p>",
                              "<p> None = never smoked </p>")))
})

output$info.clinhx <- renderUI({
   tags$span(id="info.clinhx",
      popify(icon("question-circle", class="tooltipcol"), title = NULL, placement = "right", trigger = 'hover', 
             content = paste0("<p> Family history of premature CVD  = A first-degree relative (parent or sibling) was hospitalised by or died from a heart attack or stroke before the age of 50 years </p>",
                              "<p> Diabetes = Diabetes types 1 or 2 (excludes gestational only) </p>",
                              "<p> Cancer = Any primary malignancy excluding squamous and basal cell skin cancers </p>",
                              "<p> GI Bleed = Peptic ulcer with bleed and/or perforation, diverticulitis or diverticulosis with bleed, angiodysplasia with bleed, Mallory-Weiss tear, gastritis or gastroduodenitis or duodenitis with bleed, haemorrhage of anus or rectum, haematesis, melaena, unspecified gastrointestinal haermorrahge, oesophageal varices with bleeding, or oesophageal haemorrhage </p>",
                              "<p> Other Bleed = Ocular (vitreous or retinal), respiratory (including epistaxis and haemoptysis), haemopericardium, haemoperitoneum  or haemarthrosis </p>",
                              "<p> Peptic ulcer disease = Non-bleeding and non-perforated peptic ulcer disease </p>",
                              "<p> Alcohol-related conditions = Chronic high use of alcohol (e.g. alcoholic gastritis, alcoholic liver disease, alcohol-induced chronic pancreatitis, alcohol use disorder) </p>",
                              "<p> Chronic liver disease = Gastro-oesophageal varices, alcoholic chronic liver disease, chronic hepatic failure, other cirrhosis of liver, portal hypertension, or hepatorenal syndrome </p>")))
})

output$info.sbp <- renderUI({
   tags$span(id="info.sbp",
      popify(icon("question-circle", class="tooltipcol"), title = NULL, placement = "right", trigger = 'hover',
             content = paste0("<p> Mean of two current systolic BP measurements </p>",
                              "<p> NB: Values <50 or >250 are biologically implausible </p>")))
})

output$info.ratio <- renderUI({
   tags$span(id="info.ratio",
      popify(icon("question-circle", class="tooltipcol"), title = NULL, placement = "right", trigger = 'hover',
             content = paste0("<p> Most recent value for total cholesterol (mmol/L) divided by high density lipoprotein cholesterol (mmol/L)</p>",
                               "<p> NB: Values <1 or >30 are biologically implausible </p>")))
})

output$info.mx <- renderUI({
   tags$span(id="info.mx",
      popify(icon("question-circle", class="tooltipcol"), title = NULL, placement = "right", trigger = 'hover', 
             content = paste0("<p> Lipid-lowering = e.g. statins (e.g. atorvastatin, fluvastatin, pravastatin, or simvastatin), non-statins (e.g. acipimox, bezafibrate, cholestyramine, clofibrate, colestipol, ezetimibe, gemfibrozil, or nicotinic acid) </p>",
                              "<p> Blood pressure-lowering = e.g. ACE inhibitors, angiotensin II receptor blockers, beta blockers, calcium channel blockers, thiazides or other blood pressure-lowering medication (amiloride, clonidine, clopamide, hydralazine, methyldopa, or triamterene)  </p>",
                              "<p> Peptic ulcer disease = e.g. proton pump inhibitors (e.g. omeprazole, lansoprazole, or pantoprazole), histamine H2-receptor antagonists (e.g. ranitidine), or H pylori eradication </p>",
                              "<p> NSAID = Apart from aspirin, e.g. diclofenac, diflunisal, fenbufen, fenoprofen, flurbiprofen, ibuprofen, indomethacin, ketoprofen, mefenamic acid, naproxen, phenylbutazone, piroxicam, sulindac, tenoxicam, or tiaprofenic acid  </p>",
                              "<p> Corticosteroid = e.g. prednisone, betamethasone, cortisone, dexamethasone, fludrocortisone, hydrocortisone, methylprednisolone, or prednisolone </p>",
                              "<p> SSRI = e.g. citalopram, escitalopram, fluoxetine, nefazodone, paroxetine, or sertraline </p>")))
})

output$info.bleed <- renderUI({
   tags$span(id="info.bleed",
      popify(icon("question-circle", class="tooltipcol"), title = NULL, placement = "right", trigger = 'hover',
             content = paste0("<p> Major bleed includes............... </p>")))
})

output$info.cvd <- renderUI({
   tags$span(id="info.cvd",
      popify(icon("question-circle", class="tooltipcol"), title = NULL, placement = "right", trigger = 'hover',
             content = paste0("<p> CVD includes angina, myocardial infarction, percutaneous coronary intervention, coronary artery bypass grafting, transient ischaemic attack, ischaemic stroke, or peripheral vascular disease </p>")))
})

