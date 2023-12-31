# Data prep script 


conObesity <- RPostgreSQL::dbConnect("PostgreSQL", host = "132.216.183.3",
                                     dbname = "obesity", user = "hiroshi", 
                                     password = Sys.getenv("DB3"))



#dfVarDesc<- data.frame(Description = c(
#  "Visible Minority", 
#  "Indigenous identity", 
#  "Max High sch, 15",
#  "Max High sch, 25-64",
#  "No High sch, 15",
#  "No High sch, 25-64",
#  "Moved past 5 yrs", 
#  "Moved past 1 yr", 
#  "Low-income cutoff", 
#  "Recent immigrants",
#  "Age below 15", 
#  "Age over 65", 
#  ">30% of income for housing", 
#  "Tenant, as opposed to owner"), 
#  varName = c(
#    "i_visMin",
#    "i_aboriginal",
#    "i_educ_15",
#    "i_educ_25_64",
#    "i_educ_noHS_15",
#    "i_educ_noHS_25_64",
#    "i_move_5yrs",
#    "i_move_1yrs",
#    "i_LICO",
#    "i_rec_imm",
#    "i_young",
#    "i_old",
#    "i_tenant_30income",
#    "i_tenant"
#  ), 
#varShortName =c(
#  "Visible minorities",
#  "Aboriginal",
#  "High school",
#  "Education_25",
#  "No High school",
#  "No High school 25",
#  "Recent movers",
#  "Recent move_1yr",
#  "Low income",
#  "Recent immigrants",
#  "Children",
#  "Seniors",
#  "Housing expense",
#  "Tenants")
#)

# function to get census data in Montreal 
funcGetCenMontreal <- function(yearVar, censVector, censLevel = "DA"){
  a <-get_census(dataset=yearVar, 
                 regions=list(CMA='24462'), 
                 vectors=censVector,
                 level=censLevel, 
                 use_cache = FALSE, 
                 geo_format = "sf", 
                 quiet = TRUE, 
                 api_key = Sys.getenv("CM_API_KEY")) %>% 
    mutate(interact_aoi = (CD_UID %in% c(2466, 2465, 2458)) & !(CSD_UID %in% c(2458033, 2458037))) %>% 
    mutate(hiroshi_old_aoi = (CSD_UID %in% c("2466127", "2466117", "2465005", "2466112","2466007", "2466023", "2466087", "2466097", "2466032", "2466107" , "2458227", "2458007") 
    ))
  a %>% filter(interact_aoi == TRUE )
}

# merge lines and census, 
funcMergeData <- function(dfInt, cens, intervention){
  dfInt$length_overlap <- st_length(dfInt)  
  
  # line object capturing overlap between DA and intervention 
  # Aggregate by DA, for road length, exist_indicator, and road types 
  dfIntAgg <-  dfInt%>% 
    group_by(GeoUID) %>%  
    summarise(#road_count_overlap = n(), # count of segments
      #road_length_overlap = sum(length_overlap), 
      #bike_route_overlap = list(bike_route), 
      #bikeway_type_overlap = list(bikeway_type), 
      #street_name_overlap = list(street_name), 
      exist_2011 = sum(exist_2011), # count of segments, if exist in 2011 
      exist_2016 = sum(exist_2016), 
      exist_2021 = sum(exist_2021)
    )
  
  # Merge DA with bike road - the latter no longer has line geom data, only DA polygon is present
  listMerge <- list()
  listMerge <- cens %>% 
    left_join(dfIntAgg %>% st_drop_geometry(), by = "GeoUID") %>% 
    mutate_at(vars(contains('exist_')), ~ ifelse(is.na(.), 0, .x)) %>% # after merging, make NA (areas never received intevention) to zero value
    mutate_at(vars(contains('_overlap')), ~ ifelse(is.na(.), 0, .x)) %>% 
    mutate_at(vars(contains('exist_')), ~ ifelse(. > 0, 1, 0)) # make the variable binary, rather than count of ovefrlapping road segments 
  
  # Distance from the centroid of areas to each intervention roads 
  #nearestInt <- st_nearest_feature(listMerge, intervention)
  #dist = st_distance(listMerge, intervention[nearestInt,], by_element=TRUE)
  
  #listMerge$nearestDist <- as.numeric(dist)
  
  ## Crete indicator of inmplementaion year 
  #listMerge <- listMerge %>% 
  #  mutate(exist_category = case_when(
  #    exist_2021 == 0 & exist_2016 == 0 & exist_2011 == 0 ~"Never",
  #    exist_2021 >  0 & exist_2016 == 0 & exist_2011 == 0 ~ "2021",
  #    exist_2021 >  0 & exist_2016 >  0 & exist_2011 == 0 ~ "2016",
  #    .default = "2011")
  #  ) 
  
  listMerge <- listMerge %>%  funcCensusIndicator()
  
  return(listMerge)
}




# Crete indicator of implementation year 
funcCategoryYear <- function(df){
  df %>% 
    mutate(exist_category = case_when(
      exist_2021 == 0 & exist_2016 == 0 & exist_2011 == 0 ~"Never",
      exist_2021 >  0 & exist_2016 == 0 & exist_2011 == 0 ~ "2021", 
      exist_2021 >  0 & exist_2016 >  0 & exist_2011 == 0 ~ "2016",
      #exist_2016 == 0 & exist_2011 == 0 ~"Never",
      #exist_2016 >  0 & exist_2011 == 0 ~ "2016",
      .default = "2011")
      ) 
}



# Crete indicator of implementation year 
funcPrevelanceYear <- function(df){
  df %>% 
    mutate(prevalent_2011 = factor(ifelse(exist_category == "2011", 1,0))) %>% 
    mutate(prevalent_2016 = factor(ifelse(exist_category != "2021" & (exist_2011 == 1 | exist_2016 == 1), 1,0))) %>% 
    mutate(prevalent_2021 = factor(ifelse(exist_category == "Never", 0,1)))
}

# function to create variable name 
funcCensusIndicator <- function(df){
  df %>% 
    mutate(i_visMin = visibleMin_count/visibleMin_denom, 
           i_aboriginal = indigi_count/indigi_denom, 
           i_educ_15 = educ_HS_count_15yr/educ_HS_denom_15yr, 
           i_educ_25_64 = educ_HS_count_25_64yr/educ_HS_denom_25_64yr, 
           i_educ_noHS_15 = educ_no_HS_count_15yr/educ_HS_denom_15yr, 
           i_educ_noHS_25_64 = educ_no_HS_count_25_64yr/educ_HS_denom_25_64yr, 
           i_move_5yrs = move_5yr_count/move_5yr_denom, 
           i_move_1yrs = move_1yr_count/move_1yr_denom, 
           i_LICO = LICO_prevalence*0.01, #make it to proportion  
           i_rec_imm = recentImmig_count/recentImmig_denom, 
           i_young = age_1_14_count/age_denom, 
           i_old =  age_64_over/age_denom, 
           i_tenant_30income = housingExpend_30_count/property_denom, 
           i_tenant = tenant_count/(property_denom)
    )
}

# Function to make box plot, not really needed
funcBoxPlotBox <- function(df, titleVar){
  df %>%  
    st_drop_geometry() %>% 
    ggplot( mapping=aes(x=x, y = y)) +
    geom_boxplot() +
    xlab("CTs containing bike road ") + 
    theme_classic() + 
    labs(title = Description)
}



