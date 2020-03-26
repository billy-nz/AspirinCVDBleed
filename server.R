

options(shiny.sanitize.errors = TRUE)

source("coefficients.R", local=T) # All beta coefficients & coregression Values (nb: gender specific)
source("textcontent.R", local=T) # All text for legal disclaimers and terms/conditions

shinyServer(function(input, output, session) {

source("help.R", local = T) # All text for hover over tooltips
   

   # ---- A.  Modal Boxes ----
   # Terms / Conditions Box
   showModal(tags$div(id="modal-box", modalDialog(
      size = "l",
      easyClose = FALSE,
      fade = FALSE,
      footer = tagList(div(style="text-align:center; font-weight:bold;", p("By proceeding, you agree to our terms and conditions."),
                           modalButton("Proceed"))),
      title = HTML('<span style = "font-size: x-large; font-weight:bold;"> Terms & Conditions </span>'),
      isolate(terms.top),
      isolate(exclude.if),
      isolate(legal.title),
      isolate(full.disclaimer)
   )))

   # More Information Box
   observeEvent(input$display_moreinfo, {
      showModal(tags$div(id="modal-box", modalDialog(
         size = "l",
         fade = FALSE,
         easyClose = TRUE,
         footer = div(style="text-align:center;", modalButton("Close")),
         title = HTML('<span style = "font-size: large; font-weight:bold;"> More Information </span>'),
         isolate(more.info),
         isolate(references)
      )))
   })
   
   # addTooltip(session, id="reset", title="Reset to Default",
   #        placement="right", trigger="hover", options = list(delay = list(show=1000, hide=100)))
   

   # ----B. Placeholders ----
   # Empty Matrix for summary table 
   sumtable <- data.frame("Demographic" = NA,
                          "NZDep" = NA,
                          "Smoking" = NA,
                          "History" = NA,
                          "SBP" = NA,
                          "TCHDL" = NA,
                          "Medication" = NA)
   
   # Reactive Values
   input.values <- reactiveVal()
   gauge1.value <- reactiveVal()
   gauge2.value <- reactiveVal()
   gauge3.value <- reactiveVal()
   gauge4.value <- reactiveVal()
   risk1.value <- reactiveVal()
   risk2.value <- reactiveVal()
   risk3.value <- reactiveVal()
   risk4.value <- reactiveVal()
   effect1.value <- reactiveVal()
   effect2.value <- reactiveVal()
   sum.sex.val <- reactiveVal()
   sum.age.val <- reactiveVal()
   
   # ---- Input Values ----
   observe({
      
      sex     <- +(input$demo_sex=="Male")
      age     <- as.numeric(input$demo_ageNum)
      maori   <- +(any(input$demo_eth=="Maori"))
      pacific <- +(any(input$demo_eth=="Pacific"))
      indian  <- +(any(input$demo_eth=="Indian"))
      asian   <- +(any(input$demo_eth=="Chinese") | any(input$demo_eth=="Other Asian"))
      nzdep   <- as.numeric(input$demo_dep)
      exsmoke <- +(any(input$demo_smk=="Ex-Smoker"))
      cursmoke <- +(any(input$demo_smk=="Current Smoker"))
      familyhx <- +(any(input$clin_hx=="Family Hx CVD"))
      diabetes <- +(any(input$clin_hx=="Diabetes"))
      cancer  <- +(any(input$clin_hx=="Cancer"))
      gibleed <- +(any(input$clin_hx=="GI Bleed") | any(input$clin_hx=="Other Bleed"))
      pud     <- +(any(input$clin_hx=="PUD"))
      alcohol <- +(any(input$clin_hx=="Alcohol"))
      liver   <- +(any(input$clin_hx=="Liver Disease") | any(input$clin_hx=="Pancreatitis"))
      sbp    <- as.numeric(input$bio_sbp)
      tchdl  <- as.numeric(input$bio_ratio)
      lipidlower <- +(any(input$mx=="Lipid Lowering"))
      bplower    <- +(any(input$mx=="BP Lowering"))
      puddrugs   <- +(any(input$mx=="PUD Drugs"))
      nsaid      <- +(any(input$mx=="NSAID"))
      steroids   <- +(any(input$mx=="Corticosteroids"))
      ssri       <- +(any(input$mx=="SSRI"))
      
      # To activate
      if(!any(is.na(age) | is.na(sbp) | is.na(tchdl) | length(sex)==0)){
         # Tracker
         old_values <- input.values()
         new_values <- list(Sex=input$demo_sex, Age=input$demo_ageNum, Ethnicity=input$demo_eth, NZDep=input$demo_dep, Smoking=input$demo_smk,
                            History=input$clin_hx, SBP=input$bio_sbp, TCHDL=input$bio_ratio, Medication=input$mx)
         input.values(new_values)
         
         # Compile Final Lists 
         cvd.vars <- list(sex=sex, age=age, maori=maori, pacific=pacific, indian=indian, asian=asian, exsmoke=exsmoke, cursmoke=cursmoke, nzdep=nzdep, 
                          familyhx=familyhx, diabetes=diabetes, sbp=sbp, tchdl=tchdl, lipidlower=lipidlower, bplower=bplower)
         
         bleed.vars <- c(cvd.vars,
                         list(cancer=cancer, gibleed=gibleed, pud=pud, alcohol=alcohol, liver=liver, puddrugs=puddrugs, nsaid=nsaid, steroids=steroids, ssri=ssri))
         
         
         # Sex-specific means / coeffs
         if(sex==1){
            
            coxvals      <- isolate(male.coxvals())
            cvd.coeffs   <- isolate(cvd.male.coeffs())
            bleed.coeffs <- isolate(bleed.male.coeffs())
            
         } else{
            
            coxvals      <- isolate(fem.coxvals())
            cvd.coeffs   <- isolate(cvd.fem.coeffs())
            bleed.coeffs <- isolate(bleed.fem.coeffs())
            
         }
         
         cvd.baseline.surv <- coxvals$cvd.bsurvfn
         bleed.baseline.surv <- coxvals$bleed.bsurvfn
         cvd.propeffect <- isolate(peffect.aspirin())$oncvd
         bleed.propeffect <- isolate(peffect.aspirin())$onbleed
         
         # ---- Calculations ----
         
         # --- CVD ---
         # Interaction Terms
         cvd.vars$age_x_diab <- (cvd.vars$age - coxvals$cen.age) * cvd.vars$diabetes
         cvd.vars$age_x_sbp  <- (cvd.vars$age - coxvals$cen.age) * (cvd.vars$sbp - coxvals$cen.sbp)
         cvd.vars$sbp_x_bplt <- (cvd.vars$sbp - coxvals$cen.sbp) * cvd.vars$bplower
         
         # Recentre continous variables
         cvd.vars$nzdep  <- cvd.vars$nzdep - coxvals$cen.nzdep
         cvd.vars$sbp    <- cvd.vars$sbp - coxvals$cen.sbp
         cvd.vars$age    <- cvd.vars$age - coxvals$cen.age
         cvd.vars$tchdl  <- cvd.vars$tchdl - coxvals$cen.tchdl
         
         # Calculate
         cvd.var.scores <- Map("*", cvd.vars[-1], cvd.coeffs)
         cvd.scores.sum <- Reduce("+", cvd.var.scores)
         cvd.riskscore  <- 1 - cvd.baseline.surv ^ exp(cvd.scores.sum)
         
         # --- Bleeds ---
         # Calculate
         bleed.var.scores <- Map("*", bleed.vars[-1], bleed.coeffs)
         bleed.scores.sum <- Reduce("+", bleed.var.scores)
         bleed.riskscore  <- 1 - bleed.baseline.surv ^ exp(bleed.scores.sum - coxvals$bleed.meanlin)
         
         # --- Epi Output ---   
         
         # NB: bleed.riskscore cannot exceed 0.6993007 (else with aspirin risk will exceed 100% or 1000/1000)
         validate(
            need(bleed.riskscore<=0.6993007, message=FALSE),
            if(bleed.riskscore>0.6993007){
               
               delta.index    <- which(Map("identical", new_values, old_values)==F)
               delta.var      <- names(new_values)[delta.index]
               delta.inputID  <- c("bio_sex", "demo_ageNum", "demo_eth", "demo_dep", "demo_smk", "clin_hx", "bio_sbp", "bio_ratio", "mx")[delta.index]
               
               if(req(delta.var) %in% c("Sex", "Ethnicity", "NZDep", "Smoking", "History", "Medication")){
                  prev.value.char <- as.character(unlist(old_values[delta.index]))
                  updateRadioGroupButtons(session = session, inputId = delta.inputID, selected = prev.value.char)
               } else {
                  prev.value.num <- as.numeric(unlist(old_values[delta.index]))
                  updateNumericInput(session = session, inputId = delta.inputID, value = prev.value.num)
               }
               
               showModal(tags$div(id="modal-box2", modalDialog(
                  size = "s",
                  easyClose = TRUE,
                  fade = FALSE,
                  title = HTML('<span style = "font-size: medium; font-weight:bold;"> Cannot be added! </span>'),
                  "By adding this risk factor, the risk of major bleed with aspirin will exceed 100% and therefore cannot be calculated!")))
            }
            
         )
   
         # Major Bleeds
         bleed.risk.NOasp  <- round(bleed.riskscore*100)
         bleed.risk.ASP    <- round(bleed.riskscore * (1 + bleed.propeffect) *100)
         bleed.incid.NOasp <- round(bleed.riskscore*1000)
         bleed.incid.ASP   <- round(bleed.riskscore * (1 + bleed.propeffect) *1000)
         
         # CVD EVents
         cvd.risk.NOasp    <- round(cvd.riskscore*100)
         cvd.risk.ASP      <- round(cvd.riskscore * (1 + cvd.propeffect) *100)
         cvd.incid.NOasp   <- round(cvd.riskscore*1000)
         cvd.incid.ASP     <- round(cvd.riskscore * (1 + cvd.propeffect) *1000)
         
         # Abs. Difference 
         bleed.diff.aspirin <- bleed.incid.ASP - bleed.incid.NOasp
         cvd.diff.aspirin   <- cvd.incid.NOasp - cvd.incid.ASP
         
         # Update Reactive Vals for all rendered UIs
         gauge1.value(bleed.risk.NOasp)
         gauge2.value(bleed.risk.ASP)
         gauge3.value(cvd.risk.NOasp)
         gauge4.value(cvd.risk.ASP)
         risk1.value(bleed.incid.NOasp)
         risk2.value(bleed.incid.ASP)
         risk3.value(cvd.incid.NOasp)
         risk4.value(cvd.incid.ASP)
         effect1.value(bleed.diff.aspirin)
         effect2.value(cvd.diff.aspirin)
         sum.sex.val(input$demo_sex)
         sum.age.val(input$demo_ageNum)
         
         # ---- Results Panels ----
         # NB: Gauge output cannot exceed 100%
         # 1.  Major Bleeding
         
         # % Gauges
         output$gauge_bleedrisk_WOA <-  renderGauge({
            gauge(gauge1.value(),
            label = "Risk", symbol = "%", 
            min = 0, max = 50, 
            sectors = gaugeSectors(danger = c(0, 50)))
         })
         
         output$gauge_bleedrisk_ASP <-  renderGauge({
            gauge(gauge2.value(),
            label = "Risk", symbol = "%", 
            min = 0, max = 50, 
            sectors = gaugeSectors(danger = c(0, 50)))
         })
         
         # Absolute event rate
         output$bleedrisk_eventrates <- renderUI({
            splitLayout(
               list(h4(p("No Aspirin"), style="margin-top:2px; margin-bottom:-5px"),
                    div(style="display:inline-block; margin-top:-10px", h3(strong(risk1.value()))),
                    p("per 1,000", style = "margin-top:-5px")
               ),
               
               list(h4(p("With Aspirin"), style="margin-top:2px; margin-bottom:-5px"),
                    div(style="display:inline-block; margin-top:-10px", h3(strong(risk2.value()))),
                    p("per 1,000", style = "margin-top:-5px")
               )
            )
         })
         
         # 2.  Cardiovascular Disease
         
         # % Gauge
         output$gauge_cvdrisk_WOA <-  renderGauge({
            gauge(gauge3.value(), 
            label = "Risk", symbol = "%", 
            min = 0, max = 50, 
            sectors = gaugeSectors(danger = c(0, 50)))
         })
         
         output$gauge_cvdrisk_ASP <-  renderGauge({
            gauge(gauge4.value(),
            label = "Risk", symbol = "%", 
            min = 0, max = 50, 
            sectors = gaugeSectors(danger = c(0, 50)))
         })
         
         # Absolute event rate
         output$cvdrisk_eventrates <- renderUI({
            splitLayout(
               list(h4(p("No Aspirin"), style="margin-top:2px; margin-bottom:-5px"),
                    div(style="display:inline-block; margin-top:-10px", h3(strong(risk3.value()))),
                    p("per 1,000", style = "margin-top:-5px")
               ),
               
               list(h4(p("With Aspirin"), style="margin-top:2px; margin-bottom:-5px"),
                    div(style="display:inline-block; margin-top:-10px", h3(strong(risk4.value()))),
                    p("per 1,000", style = "margin-top:-5px")
               )
            )
         })
         
         # 3.  Effects of Aspirin
         if(length(bleed.risk.NOasp)!=0){
            
            # Absolute Difference 
            output$effect_set <- renderUI({
               splitLayout(
                  list(h4(p("Major Bleeds Caused"), style="margin-top:2px; margin-bottom:-5px"),
                       p("over 5 years", style = "margin-top:-5px"),
                       div(div(style="display:inline-block; margin-top:-10px", icon("arrow-up", class="reduparrow")),
                           div(style="display:inline-block; margin-top:-10px", h3(strong(effect1.value())))),
                       p("per 1,000", style = "margin-top:-5px")
                  ),
                  
                  list(h4(p("CVD Events Avoided"), style="margin-top:2px; margin-bottom:-5px"),
                       p("over 5 years", style = "margin-top:-5px"),
                       div(div(style="display:inline-block; margin-top:-10px", icon("arrow-down", class="greendownarrow")),
                           div(style="display:inline-block; margin-top:-10px", h3(strong(effect2.value())))),
                       p("per 1,000", style = "margin-top:-5px")
                  )
               )
            })
            
            # ---- Summary ----
            output$summaryTable <- renderTable({
               
               demo   <- paste0(setdiff(c(sum.sex.val(), sum.age.val(), input$demo_eth), ""),
                                collapse = ", ")
               dep    <- paste0(input$demo_dep)
               smoke  <- paste0(input$demo_smk)
               sbp    <- paste0(input$bio_sbp) 
               ratio  <- paste0(input$bio_ratio)
               
               clinhx <- if(is.null(input$clin_hx)){
                  paste0("-")
               } else {
                  paste(input$clin_hx, collapse = ", ") 
               }
               
               meds   <- if(is.null(input$mx)){
                  paste0("-")
               } else {
                  paste(input$mx, collapse = ", ")
               }
               
               sumtable$Demographic <- demo
               sumtable$NZDep <- dep
               sumtable$Smoking <- smoke
               sumtable$History <- clinhx
               sumtable$SBP <- sbp
               sumtable$TCHDL <- ratio
               sumtable$Medication <- meds
               
               return(sumtable)
               
            }, align='l')
            
            # 5.  Extreme Baseline Risk Warning
            # If baseline predicted bleeding risk > /= 0.13172224 for women or >/= 0.16673651 for men 
            # If baseline predicted CVD risk > /= 0.1893146  for women or >/= 0.2449979 for men 
            output$extreme.risk.warning.bleed <- renderUI({
               req((sex==0 & bleed.riskscore>=0.13172224) |
                  (sex==1 & bleed.riskscore>=0.16673651))
                  wellPanel(style = "background-color: #ffffff; padding-bottom:10px; border: 1px solid #FF0000;",
                            p("These values are in the top 0.1% of predicted risk among people in whom the risk equation was developed and may be unreliable."))
            })
            
            output$extreme.risk.warning.cvd <- renderUI({
               req((sex==0 & cvd.riskscore>=0.1893146) |
                  (sex==1 & cvd.riskscore>=0.2449979))
                  wellPanel(style = "background-color: #ffffff; padding-bottom:10px; border: 1px solid #FF0000;",
                            p("These values are in the top 0.1% of predicted risk among people in whom the risk equation was developed and may be unreliable."))
            })
            
            output$warning.bleed <- renderUI({
               req((sex==0 & bleed.riskscore>=0.13172224) |
                      (sex==1 & bleed.riskscore>=0.16673651))
               icon("exclamation-triangle", class="warningcol")
            })
            
            output$warning.cvd <- renderUI({
               req((sex==0 & cvd.riskscore>=0.1893146) |
                      (sex==1 & cvd.riskscore>=0.2449979))
               icon("exclamation-triangle", class="warningcol")
            })
            
            addTooltip(session, id="warning.bleed", placement="right", trigger="hover", options = list(container = "body"),
                       title="These values are in the top 0.1% of predicted risk among people in whom the risk equation was developed and may be unreliable.")
                       

            # --- 
         } # end of avaliable result activation tag
         
      } # end of overall non-missing activation tag
      
   }) # end of data input Observe tag
   
# ---
# Reset Button
   observeEvent(input$reset,{
      
      updateRadioGroupButtons(session = session, inputId = "demo_sex", selected = "U")
      updateNumericInput(session = session, inputId = "demo_ageNum", value = NA)
      updateRadioGroupButtons(session = session, inputId = "demo_eth", selected = "Other Ethnicity")
      updateRadioGroupButtons(session = session, inputId = "demo_dep", selected = "3")
      updateRadioGroupButtons(session = session, inputId = "demo_smk", selected = "Never Smoked")
      updateRadioGroupButtons(session = session, inputId = "clin_hx", selected = NULL)
      updateNumericInput(session = session, inputId = "bio_sbp", value = 120)
      updateNumericInput(session = session, inputId = "bio_ratio", value = 3)
      updateRadioGroupButtons(session = session, inputId = "mx", selected = NULL)
      
      gauge1.value(0)
      gauge2.value(0)
      gauge3.value(0)
      gauge4.value(0)
      
      risk1.value(0)
      risk2.value(0)
      risk3.value(0)
      risk4.value(0)
      
      effect1.value(0)
      effect2.value(0)
      
      sum.sex.val("")
      sum.age.val("")
      
      output$extreme.risk.warning.bleed <- renderUI({})
      output$extreme.risk.warning.cvd <- renderUI({})
      
   })
   
}) #Fluid page end