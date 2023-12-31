


# Full varlist 
censusVarList_all <- c(Tot_pop = "v_CA21_1", # Target 
                   Tot_Mpop = "v_CA21_9",
                   Mpop_0_4 = "v_CA21_15",
                   Mpop_5_9 = "v_CA21_33",
                   Mpop_10_14 = "v_CA21_51",
                   Mpop_15_19 = "v_CA21_72",
                   Mpop_20_24 = "v_CA21_90",
                   Mpop_65_69 = "v_CA21_255",
                   Mpop_70_74 = "v_CA21_273",
                   Mpop_75_79 = "v_CA21_291",
                   Mpop_80_84 = "v_CA21_309",
                   Mpop_85p = "v_CA21_327",
                   Tot_Fpop = "v_CA21_10",
                   Fpop_0_4 = "v_CA21_16",
                   Fpop_5_9 = "v_CA21_34",
                   Fpop_10_14 = "v_CA21_52",
                   Fpop_15_19 = "v_CA21_73",
                   Fpop_20_24 = "v_CA21_91",
                   Fpop_65_69 = "v_CA21_256",
                   Fpop_70_74 = "v_CA21_274",
                   Fpop_75_79 = "v_CA21_292",
                   Fpop_80_84 = "v_CA21_310",
                   Fpop_85p = "v_CA21_328",
                   Imm_stat = "v_CA21_4404",  
                   Imm_2016_2021 = "v_CA21_4431",
                   Rec_Imm = "v_CA21_4635",  # recent immig 
                   Tot_VisMin_Pop = "v_CA21_4872",
                   VisMin_Pop = "v_CA21_4875", # Target 
                   Tot_ab_nonab = "v_CA21_4201",
                   Aborg_Pop = "v_CA21_4204",
                   Tot_Mobility_1yr = "v_CA21_5745",
                   Movers_1yr = "v_CA21_5751",
                   Tot_Mobility_5yrs = "v_CA21_5772",
                   Movers_5yrs = "v_CA21_5778",
                   Tot_Edu15p = "v_CA21_5817", #Total - Highest certificate, diploma or degree for the population aged 15 years and over in private households
                   Tot_NoCerti_15p = "v_CA21_5820", #No certificate, diploma or degree 
                   Tot_SecCerti_15p = "v_CA21_5820", #No certificate, diploma or degree 
                   Tot_Edu25_64= "v_CA21_5865", #Total - Highest certificate, diploma or degree for the population aged 25 to 64 years in private households 
                   Tot_NoCerti25_64 = "v_CA21_5868", # No certificate, diploma or degree 
                   Tot_SecCerti__25_64 = "v_CA21_5871", #High (secondary) school diploma or equivalency certificate  
                 
                   Tot_OwTen_CSTtoINC = "v_CA21_4288", # Owner and tenant households with household total income greater than zero, in non-farm, non-reserve private dwellings by shelter-cost-to-income ratio
                   Tot_OwTen_CSTtoINC_g30pct = "v_CA21_4290", # Spending 30% or more of income on shelter costs
                   Tot_Own = "v_CA21_4305", # Total - Owner households in non-farm, non-reserve private dwellings
                   Pct_own_g30pct = "v_CA21_4307", #% of owner households spending 30% or more of its income on shelter costs
                   Tot_Ten = "v_CA21_4313", #Total - Tenant households in non-farm, non-reserve private dwellings
                   Pct_ten_g30pct = "v_CA21_4315", #% of tenant households spending 30% or more of its income on shelter costs
                   Liconcept_stat = "v_CA21_1055", # LICO low-income status in 2020 for the population in private households to whom the low-income concept is applicable
                   LIM_AT = "v_CA21_1025", #In low income based on the Low-income measure, after tax (LIM-AT)
                   Pct_LIM_AT = "v_CA21_1040", #Prevalence of low income based on the Low-income measure, after tax (LIM-AT) (%)
                   LICO_AT = "v_CA21_1070", # In low income based on the Low-income cut-offs, after tax (LICO-AT)
                   Pct_LICO_AT = "v_CA21_1085") #Prevalence of low income based on the Low-income cut-offs, after tax (LICO-AT) (%)

# just a sample data for visualization 
censusVarList <- c(Tot_pop = "v_CA21_1")









