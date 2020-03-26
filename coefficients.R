
# Regression Values

peffect.aspirin <- reactive({
   list(onbleed = 0.43,
        oncvd = -0.11)
})

fem.coxvals <- reactive({
   list(cen.age = 56.13665,
        cen.sbp = 129.0173,
        cen.tchdl = 3.726268,
        cen.nzdep = 2.990826,
        cvd.bsurvfn  = 0.983169213058,
        bleed.meanlin = 3.262378,
        bleed.bsurvfn = 0.98902929)
})

male.coxvals <- reactive({
   list(cen.age = 51.79953,
        cen.sbp = 129.1095,
        cen.tchdl = 4.38906,
        cen.nzdep = 2.972793,
        cvd.bsurvfn  = 0.974755526232,
        bleed.meanlin = 2.787439,
        bleed.bsurvfn = 0.9886172)
})   
   
cvd.fem.coeffs <- reactive({
   list(age     = 0.0756412,
        maori   = 0.3910183,
        pacific = 0.2010224,
        indian  = 0.1183427, 
        asian   = -0.28551,
       exsmoke  = 0.087476,
       cursmoke = 0.6226384,
       nzdep     = 0.1080795,
       familyhx = 0.0445534,
       diabetes = 0.5447632,
       sbp   = 0.0136606,
       tchdl = 0.1226753,
       lipidlower = -0.0593798,
       bplower = 0.339925,
       age_x_diab = -0.0222549, 
       age_x_sbp  = -0.0004425,
       sbp_x_bplt = -0.004313)
})

cvd.male.coeffs <- reactive({
   list(age     = 0.0675532,
        maori   = 0.2899054,
        pacific = 0.1774195,
        indian  = 0.2902049, 
        asian   = -0.3975687,
        exsmoke  = 0.0753246,
        cursmoke = 0.5058041,
        nzdep    = 0.0794903,
        familyhx = 0.1326587,
        diabetes = 0.5597023,
        sbp   = 0.0163778,
        tchdl = 0.1283758,
        lipidlower = -0.0537314,
        bplower = 0.2947634,
        age_x_diab = -0.020235, 
        age_x_sbp  = -0.0004184,
        sbp_x_bplt = -0.0053077)
})


bleed.fem.coeffs <- reactive({
   list(age     = 0.03502806,
        maori   = 0.311582316,
        pacific = 0.291826502,
        indian  = -0.170178670, 
        asian   = 0.044890076,
        exsmoke  = 0.144844011,
        cursmoke = 0.495240401,
        nzdep     = 0.098736992,
        familyhx = 0.055185249,
        diabetes = 0.182633821,
        sbp   = 0.004991576,
        tchdl = 0.001878851,
        lipidlower = 0.010545182,
        bplower = 0.140874933,
        cancer  = 0.299418027,
        gibleed = 1.157219678,
        pud = 0.426358755,
        alcohol = 0.95065995,
        liver = 0.979437007,
        puddrugs = 0.370528961,
        nsaid = 0.10655804,
        steroids = 0.328347624,
        ssri = 0.16495507)
})

bleed.male.coeffs <- reactive({
   list(age    = 0.03538036,
       maori   = 0.40955001,
       pacific = 0.52687151,
       indian  = -0.01815411, 
       asian   = 0.37798865,
       exsmoke  = 0.15536803,
       cursmoke = 0.38226181,
       nzdep     = 0.09305327,
       familyhx = 0.05028066,
       diabetes = 0.17500777,
       sbp   = 0.00373758,
       tchdl = -0.05009861,
       lipidlower = -0.04636764,
       bplower = 0.20741834,
       cancer  = 0.56636099,
       gibleed = 1.14121551,
       pud = 0.22227113,
       alcohol = 0.67405759,
       liver = 0.77588662,
       puddrugs = 0.36282612,
       nsaid = 0.17279428,
       steroids = 0.35261644,
       ssri = 0.2928215)
})