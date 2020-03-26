# Aspirin Bleeding Risk Calculator - User Interface version 2.0

library(shiny)
library(shinyjs)
library(shinyBS)
library(shinyWidgets)
library(flexdashboard)

# Radio Tooltip Function
radioTooltip <- function(id, choice, title, placement = "bottom", trigger = "hover", options = list(container = "body")){
   
   options = shinyBS:::buildTooltipOrPopoverOptionsList(title, placement, trigger, options)
   options = paste0("{'", paste(names(options), options, sep = "': '", collapse = "', '"), "'}")
   bsTag <- shiny::tags$script(shiny::HTML(paste0("
    $(document).ready(function() {
      setTimeout(function() {
        $('input', $('#", id, "')).each(function(){
          if(this.getAttribute('value') == '", choice, "') {
            opts = $.extend(", options, ", {html: true});
            $(this.parentElement).tooltip('destroy');
            $(this.parentElement).tooltip(opts);
          }
        })
      }, 500)
    });
  ")))
   htmltools::attachDependencies(bsTag, shinyBS:::shinyBSDep)
}


# Start
fluidPage(
   
   useShinyjs(),
   
   # ---- A.  CSS ----
   tags$style(".greenheart {color:#32CD32; font-size:15px}"),
   tags$style(".redblood {color:#FF0000; font-size:20px}"),
   tags$style(".reduparrow {color:#FF0000; font-size:30px}"),
   tags$style(".greendownarrow {color:#32CD32; font-size:30px}"),
   tags$style(".tooltipcol {color:#206cd8}"),
   tags$style(".warningcol {color::#FFD700}"),
   tags$style(".popover {max-width: 80%;}"),
   tags$style("#modal-box .modal { text-align:center; padding-top: 80px;}
               #modal-box .modal-body {padding: 10px; overflow-y:scroll; max-height:60vh}
               #modal-box .modal-dialog {display: inline-block; text-align: left; }
               #modal-box .modal-header {background-color: lightgrey; border-top-left-radius: 6px; border-top-right-radius: 6px}"),
    tags$style("#modal-box2 .modal {position: absolute; top:40%; left:10%; overflow: auto; }
               #modal-box2 .modal-dialog {display: inline-block; text-align: left;}
               #modal-box2 .modal-footer {display: none}
               #modal-box2 .modal-header {background-color: lightgrey; border-top-left-radius: 6px; border-top-right-radius: 6px}"),
   tags$style(".html-widget-output.gauge svg {margin-top:-10px; margin-bottom:-10px;}"),
     
   # ---- B.  Header ----
   fluidRow(
      column(10, h2("Aspirin Bleeding Risk Calculator"),
             hr(style="margin-top:5px"),
             p("This calculator is based on sex-specific Cox proportional hazards models for predicting the 5-year risk of a first CVD event or a major bleed using a contemporary cohort of over 385,000 people without established CVD who had CVD risk assessed in New Zealand primary care. For further information about the calculator, click on More Info.")),
      column(2, style="padding-top:40px; padding-right:25px; "
             , wellPanel(align="center",
                       actionButton(inputId = "display_moreinfo",
                                    label = tags$span(icon("info-circle"), "More Info"))
                       )
      )
   ),
   
   hr(style="margin-top:10px; margin-bottom:20px;"),

fluidRow(
   
# ---- C.   Data Input ----

# Tooltips 

bsTooltip("demo_ageNum", "Enter an age between 30 and 74",
          "bottom", options = list(container = "body")),

bsTooltip("bio_sbp", "Enter a value between 50 and 250 (default 120)",
          "bottom", options = list(container = "body")),

bsTooltip("bio_ratio", "Enter a value between 1 and 30 (default 3)",
          "bottom", options = list(container = "body")),

bsTooltip("reset", "Reset to Default",
          "right", options = list(container = "body")),

radioTooltip(id = "demo_smk", choice = "Current Smoker", title = "Current (or ex-smoker who quit smoking less than 12 months ago)", placement = "bottom"),
radioTooltip(id = "demo_smk", choice = "Ex-Smoker", title = "Quit 12 or more months ago", placement = "bottom"),
radioTooltip(id = "demo_smk", choice = "Never Smoked", title = "Never smoked", placement = "bottom"),

radioTooltip(id = "demo_dep", choice = "1", title = "Least deprived", placement = "bottom"),
radioTooltip(id = "demo_dep", choice = "2", title = "Slightly deprived", placement = "bottom"),
radioTooltip(id = "demo_dep", choice = "3", title = "Moderately deprived", placement = "bottom"),
radioTooltip(id = "demo_dep", choice = "4", title = "Very deprived", placement = "bottom"),
radioTooltip(id = "demo_dep", choice = "5", title = "Most deprived", placement = "bottom"),

radioTooltip(id = "clin_hx", choice = "Family Hx CVD", title = "A first-degree relative (parent or sibling) was hospitalised by or died from a heart attack or stroke before the age of 50 years", placement = "bottom"),
radioTooltip(id = "clin_hx", choice = "Diabetes", title = "Diabetes types 1 or 2 (excludes gestational only)", placement = "bottom"),
radioTooltip(id = "clin_hx", choice = "Cancer", title = "Any primary malignancy excluding squamous and basal cell skin cancers", placement = "bottom"),
radioTooltip(id = "clin_hx", choice = "GI Bleed", title = "Peptic ulcer with bleed and/or perforation, diverticulitis or diverticulosis with bleed, angiodysplasia with bleed, Mallory-Weiss tear, gastritis or gastroduodenitis or duodenitis with bleed, haemorrhage of anus or rectum, haematesis, melaena, unspecified gastrointestinal haermorrahge, oesophageal varices with bleeding, or oesophageal haemorrhage", placement = "bottom"),
radioTooltip(id = "clin_hx", choice = "Other Bleed", title = "Ocular (vitreous or retinal), respiratory (including epistaxis and haemoptysis), haemopericardium, haemoperitoneum  or haemarthrosis", placement = "bottom"),
radioTooltip(id = "clin_hx", choice = "PUD", title = "Non-bleeding and non-perforated peptic ulcer disease", placement = "bottom"),
radioTooltip(id = "clin_hx", choice = "Alcohol", title = "Chronic high use of alcohol (e.g. alcoholic gastritis, alcoholic liver disease, alcohol-induced chronic pancreatitis, alcohol use disorder)", placement = "bottom"),
radioTooltip(id = "clin_hx", choice = "Liver Disease", title = "Gastro-oesophageal varices, alcoholic chronic liver disease, chronic hepatic failure, other cirrhosis of liver, portal hypertension, or hepatorenal syndrome", placement = "bottom"),

radioTooltip(id = "mx", choice = "Lipid Lowering", title = "e.g. statins (e.g. atorvastatin, fluvastatin, pravastatin, or simvastatin), non-statins (e.g. acipimox, bezafibrate, cholestyramine, clofibrate, colestipol, ezetimibe, gemfibrozil, or nicotinic acid)", placement = "bottom"),
radioTooltip(id = "mx", choice = "BP Lowering", title = "e.g. ACE inhibitors, angiotensin II receptor blockers, beta blockers, calcium channel blockers, thiazides or other blood pressure-lowering medication (amiloride, clonidine, clopamide, hydralazine, methyldopa, or triamterene)", placement = "bottom"),
radioTooltip(id = "mx", choice = "PUD Drugs", title = "e.g. proton pump inhibitors (e.g. omeprazole, lansoprazole, or pantoprazole), histamine H2-receptor antagonists (e.g. ranitidine), or H pylori eradication ", placement = "bottom"),
radioTooltip(id = "mx", choice = "NSAID", title = "e.g. diclofenac, diflunisal, fenbufen, fenoprofen, flurbiprofen, ibuprofen, indomethacin, ketoprofen, mefenamic acid, naproxen, phenylbutazone, piroxicam, sulindac, tenoxicam, or tiaprofenic acid", placement = "bottom"),
radioTooltip(id = "mx", choice = "Corticosteroids", title = "e.g. prednisone, betamethasone, cortisone, dexamethasone, fludrocortisone, hydrocortisone, methylprednisolone, or prednisolone", placement = "bottom"),
radioTooltip(id = "mx", choice = "SSRI", title = "e.g. citalopram, escitalopram, fluoxetine, nefazodone, paroxetine, or sertraline", placement = "bottom"),


# Input Panel
column(4, h3("Patient Details", style="margin-top:0px"),
wellPanel(style="border: 1px solid #ccc;",
   
   #Sex
   div(style="display:inline-block", h4("Sex", style="margin:0")),
   div(style="margin-bottom:20px", 
       radioGroupButtons(inputId = "demo_sex", 
                         choices = list("Male"="Male", "Female"="Female"), justified = TRUE,
                         selected = "U",
                         checkIcon = list(yes = icon("ok", lib = "glyphicon")))),
   # Age
   div(style="display:inline-block", h4("Age", style="margin:0")),
   div(style="margin-bottom:10px",
       div(style="display:inline-block; ", numericInput("demo_ageNum", label = NULL, min = 30, max = 74,
                    value = NULL, width = '90px')),
       div(style="display:inline-block; margin-left:10px", p("years old"))),
   
   #  Ethnicity
   div(style="display:inline-block", h4("Ethnicity", style="margin:0")),
   div(style="display:inline-block; vertical-align:top", uiOutput("info.eth")),
   div(style="margin-bottom:20px",
       radioGroupButtons(inputId = "demo_eth", 
                         choices = list("NZ European"="NZ European", "Māori"="Maori", "Pacific"="Pacific", "Indian"="Indian", "Chinese"="Chinese", "Other Asian"="Other Asian", 
                                        "Other"="Other Ethnicity"), 
                         justified = F, selected = "Other Ethnicity",
                         checkIcon = list(yes = icon("ok", lib = "glyphicon")))),
   # Deprivation          
   div(style="display:inline-block", h4("Deprivation", style="margin:0")),
   div(style="display:inline-block; vertical-align:top", uiOutput("info.dep")),
   div(style="margin-bottom:20px",
       radioGroupButtons(inputId = "demo_dep", 
                         choices = c("1 (least)"=1, "2"=2, "3"=3, "4"=4, "5 (most)"=5), 
                         selected = "3", justified = TRUE,
                         checkIcon = list(yes = icon("ok", lib = "glyphicon")))),
             
   # Smoking
   div(style="display:inline-block", h4("Smoking", style="margin:0")),
   div(style="margin-bottom:20px",
       radioGroupButtons(inputId = "demo_smk", 
                         choices = list("Current"="Current Smoker", "Ex-Smoker"="Ex-Smoker", "Never"="Never Smoked"),  
                         selected = "Never Smoked", justified = F,
                         checkIcon = list(yes = icon("ok", lib = "glyphicon")))),
             
   # Clinical History
   div(style="display:inline-block", h4("Clinical History", style="margin:0px")),
   div(style="display:inline-block; margin-left:10px; color:grey;", h5("Select all that apply")),
   div(style="margin-bottom:20px",
       checkboxGroupButtons(inputId = "clin_hx", 
                            choices = c("Family Hx of CVD"="Family Hx CVD", "Diabetes"="Diabetes", "Cancer"="Cancer", "GI Bleed"="GI Bleed", "Other Bleed"="Other Bleed", 
                                        "Peptic Ulcer Disease"="PUD","Alcohol Related Conditions"="Alcohol",
                                        "Chronic Liver Disease"="Liver Disease", "Chronic Pancreatitis"="Pancreatitis"),
                            justified = FALSE, individual = TRUE, checkIcon = list(yes = icon("ok", lib = "glyphicon")))),
   
   # SBP / Lipids
   flowLayout(style="margin-bottom:-5px; margin-right:-50px",
              list(div(style="display:inline-block;", h4("Systolic Blood Pressure")),
                   div(style="display:inline-block;", 
                       numericInput("bio_sbp", label = NULL, min = 10, max = 180, value = 120, width = '90px')),
                   div(style="display:inline-block; margin-left:10px", p("mmHg"))),
              
              list(div(style="display:inline-block;", h4("Total/HDL Cholesterol")),
                   div(style="display:inline-block;", 
                       numericInput("bio_ratio", label = NULL, min = 1, max = 30, value = 3, width = '90px', step = 0.1)),
                   div(style="display:inline-block; margin-left:10px", p("Ratio"))))
   ,div(style="margin:20px"),
             
   # Medication
   div(style="display:inline-block", h4("Medication within last 6 months", style="margin:0px")),
   div(style="display:inline-block; margin-left:10px; color:grey;", p("Select all that apply")),
   checkboxGroupButtons(inputId = "mx",
                        choices = c("Lipid Lowering"="Lipid Lowering", "Blood Pressure Lowering"="BP Lowering", "PUD Drugs"="PUD Drugs", "NSAID"="NSAID", 
                                    "Corticosteroids"="Corticosteroids", "SSRI"="SSRI"),
                        justified = FALSE, individual = TRUE, checkIcon = list(yes = icon("ok", lib = "glyphicon")))
   
   # Reset Button
   ,div(style="margin-top:20px", actionBttn(inputId = "reset", label = "Reset", color = "primary", style = "bordered", size = "sm"))
             
)),
# ---- D. Result Output -----
column(8,
       fluidRow(
          # Major Bleeds Panel
          column(6, align="center", h3("Major Bleed in 5 years", style="margin-top:0px"),
                 wellPanel(style = "background-color: #ffffff; margin-right:25px; padding-bottom:10px; border: 1px solid #ccc;",
                           
                           h4(strong("Risk (%)"), style="margin-top:-5px;"),
                           flowLayout(
                              style="margin-left:-60px; margin-right:-80px",
                              list(h4(p("No Aspirin"), style="display:inline-block; text-align:center; margin-top:3px; margin-bottom:-10px"),
                                   div(gaugeOutput("gauge_bleedrisk_WOA"), style="margin-bottom:-80px")),
                              
                              list(h4(p("With Aspirin"), style="display:inline-block; text-align:center; margin-left:-30px; margin-right:-20px; margin-top:1px; margin-bottom:-10px"),
                                   div(gaugeOutput("gauge_bleedrisk_ASP"), style="margin-bottom:-80px"))),
                           
                          uiOutput("extreme.risk.warning.bleed"),
                           
                           h4(strong("Risk (per 1,000)"), style="margin-top:5px;"),
                           uiOutput("bleedrisk_eventrates")
                 )
                 
          ),

          # CVD Panel
          column(6, align="center", h3("CVD Event in 5 years", style="margin-top:0px"),
                 wellPanel(style = "background-color: #ffffff; margin-right:25px; padding-bottom:10px; border: 1px solid #ccc;",
                           
                           h4(strong("Risk (%)"), style="margin-top:-5px;"),
                           flowLayout(
                              style="margin-left:-60px; margin-right:-80px",
                              list(h4(p("No Aspirin"), style="display:inline-block; text-align:center; margin-top:3px; margin-bottom:-10px"),
                                   div(gaugeOutput("gauge_cvdrisk_WOA"), style="margin-bottom:-80px")),
                              
                              list(h4(p("With Aspirin"), style="display:inline-block; text-align:center; margin-left:-30px; margin-right:-20px; margin-top:1px; margin-bottom:-10px"),
                                   div(gaugeOutput("gauge_cvdrisk_ASP"), style="margin-bottom:-80px"))),
                           
                            uiOutput("extreme.risk.warning.cvd"),
                           
                           h4(strong("Risk (per 1,000)"), style="margin-top:5px;"),
                           uiOutput("cvdrisk_eventrates")
                 )
          )
       ),
       
      # Effect of Aspirin Panel
       fluidRow(column(12,  align="center", 
                       h3("Effect With Aspirin", style="margin-top:20px; margin-right:20px"),
                       wellPanel(style = "background-color: #ffffff; margin-right:25px; padding-bottom:10px; border: 1px solid #ccc;",
                                 uiOutput("effect_set")
                                 ))
                
       )

# ---E. Summary ----
,fluidRow(column(12, align="center",
                 h3("Summary", style="margin-top:20px; margin-right:20px"),
                 wellPanel(style = "background-color: #ffffff; margin-right:25px; padding-bottom:10px; border: 1px solid #ccc;",
                           tableOutput("summaryTable")
                           ))
                          
          )

) # end of results space
) # end of all panels

,div(style = "text-align:right; margin-right:20px", p("© University of Auckland 2019", style=" font-size:small; color:grey"))

)
   

