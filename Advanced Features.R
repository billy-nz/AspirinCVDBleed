
# Reset / Export 
,div(style="display:inline-block; margin-top:20px", actionBttn(inputId = "reset", label = "Reset", color = "primary", style = "bordered", size = "sm"))
observeEvent(input$reset,{
   updateRadioGroupButtons(session = session, inputId = "demo_sex", selected = "U")
   updateNumericInput(session = session, inputId = "demo_ageNum", value = NA)
   updateRadioGroupButtons(session = session, inputId = "demo_eth", selected = "U")
   updateRadioGroupButtons(session = session, inputId = "demo_dep", selected = "U")
   updateRadioGroupButtons(session = session, inputId = "demo_smk", selected = "U")
   updateRadioGroupButtons(session = session, inputId = "clin_hx", selected = NULL)
   updateNumericInput(session = session, inputId = "bio_sbp", value = 120)
   updateNumericInput(session = session, inputId = "bio_ratio", value = 3)
   updateRadioGroupButtons(session = session, inputId = "mx", selected = NULL)
   
})