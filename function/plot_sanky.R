# codes below create Sanky plot for Road type transitions, 
# in the DescritpiveAnalsysi.Rmd File



### Montreal 
#### Bike Road segments, between 2011 and 2016 
NO LONGER USED, as the data sctureuc has changed 
```{r, fig.width=8, fig.height=8}
# Number of bike road segments in all years
#intList[["Mtl1_old"]] %>%  nrow()
#
## Code by year 
#intList[["Mtl1_old"]] <- intList[["Mtl1_old"]] %>% 
#	mutate(roadStatus = case_when(
#		exist_2011 ==1 & exist_2016==0 ~ "Prsent in 2011, absent in 2016",
#		exist_2011 ==0 & exist_2016==1 ~ "Absent in 2011, present in 2016",
#    exist_2011 ==1 & exist_2016==1 ~ "Present in 2011 and 2016",
#    exist_2011 ==0 & exist_2016==0 ~ "Absent in 2011 and 2016"
#	),
#	typo_2011_miss = factor(ifelse(exist_2011==0, "missing", typo_2011)), 
#	typo_2016_miss = factor(ifelse(exist_2016==0, "missing", typo_2016))
#	)
#levels(intList[["Mtl1_old"]]$typo_2011_miss) <- c(levels(intList[["Mtl1_old"]]$typo_2011), "missing")
#levels(intList[["Mtl1_old"]]$typo_2016_miss) <- c(levels(intList[["Mtl1_old"]]$typo_2016), "missing")

## Aggregated by year 
#intList[["Mtl1_old"]] %>%  
#  group_by(roadStatus) %>%  
#  st_drop_geometry() %>% 
#  summarize(count = n()) %>% 
#  htmlTable(caption = "Number of road segments, by year")

# Map of bike roads, by year 2011 and 2021
#bb <- intList[["Mtl1_old"]] %>% 
#  st_bbox()
#expand <- .05
#names(bb) <- c("left", "bottom", "right", "top")
##bgd <-get_stamenmap(bb, maptype = "toner-lite", zoom = 11)
##saveRDS(bgd, "data/MtlStamen.rds")
#bgd <- readRDS("data/MtlStamen.rds")
#ggmap(bgd) +
#  geom_sf(data=intList[["Mtl1_old"]], aes(color=factor(roadStatus)), lwd = 2, inherit.aes = FALSE, size =1)  + 
#  scale_color_brewer(palette = "Spectral", name="Road Status 2011-2016") +  
#  ggtitle("Change in bike road segments, 2011-2016") 

# Map, this time not overlying with ggmal as CRS is different
# 

```

#### Transition of bike road (Montreal) 
Some bike road segments existed in 2011 were lost in 2016
-- No longer displayed, since the latesdt 2022 data has only two facility types 
```{r}
ta <- intList[["Mtl1_old"]] %>% 
  st_drop_geometry() %>% 
  group_by(typo_2011_miss, typo_2016_miss) %>% 
  summarise(count = n())
ta %>% htmlTable()
tb <- expand.grid(unique(intList[["Mtl1_old"]]$typo_2011_miss), unique(intList[["Mtl1_old"]]$typo_2016_miss))

names(tb) <- c("typo_2011_miss", "typo_2016_miss")
tb <- tb %>% 
  left_join(ta) %>%  
  mutate(count = ifelse(is.na(count), 0, count)) %>%  
  arrange(typo_2011_miss, typo_2016_miss)

# Transition matrix of bike road
m <- matrix(tb$count, ncol = 8, nrow = 8, byrow = TRUE)
```

#### Change of bike road from 2011 to 16 (Montreal)
If our interest is to assess the change of bike road from 2011 to 2016 in relation to DA-level socio-economic and demographic status, only the first group in the transition chart (`missing_2011` on the top left) is important. All other bike road segments existed before 2011. Note that a small number of bike road segments from each road types  (this represents approximately 9 % of all bike road appeared or lost between 2011 and 2016) are lost in 2016 (see `missing_2016` group on the top right). 
-- No longer displayed, since the latest 2022 data has only two facility types 
```{r  fig.width=6, fig.height=8, message=FALSE, warning=FALSE}
intList[["Mtl1_old"]] %>%
  st_drop_geometry() %>% 
  mutate(bike_2016 = paste(intList[["Mtl1_old"]]$typo_2016_miss, "2016", sep = "_")) %>% 
  mutate(bike_2011 = paste(intList[["Mtl1_old"]]$typo_2011_miss, "2011", sep = "_")) %>% 
  make_long(bike_2011, bike_2016) %>% 
  ggplot( aes(x = x, next_x = next_x, 
              node = node, next_node = next_node, 
              fill = factor(node), label = node)) + 
  geom_sankey(flow.alpha = 0.6, node.color = "gray30") + 
  geom_sankey_label(size = 4, color = "white", fill = "gray40") +
  scale_fill_viridis_d() +
  theme_sankey(base_size = 15) +
  labs(x = NULL) +
  theme(legend.position = "none",
        plot.title = element_text(hjust = .5))

```
