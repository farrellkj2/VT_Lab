#### Plot to make semi-manuscript-friendly ggjoy plots ####
# install.packages('pacman')
pacman::p_load(cowplot, ggridges, tidyverse)

jet.colors <- colorRampPalette(c("dodgerblue4",  "dodgerblue1", "deepskyblue","cyan", 
                                 "yellow", "orange2", "red1", "red4")) 

mytheme <- theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
                 panel.background = element_blank(), axis.line.x = element_line(colour = "black"), 
                 axis.line.y = element_line(colour = "black"), 
                 axis.text.x=element_text(size=20, colour='black'), 
                 axis.text.y=element_text(size=20, colour='black'), 
                 axis.title.x=element_text(size=20), axis.title.y=element_text(size=20),
                 legend.text = element_text(size=20),
                 strip.text.x = element_text(margin = margin(.25,0,.25,0, "cm"), size=18))

lakes <- read_csv('./ggplot demo/ggjoy_demo_data.csv') %>% 
  mutate(Sim = as.factor(Sim))

ggplot(data = subset(lakes, variable == 'Temp' & zone == 'epi'), 
       aes(x = value, y = Sim, fill = Sim, group = Sim)) +
  geom_density_ridges() + mytheme + #joytheme + 
  facet_grid(. ~ Lake) + 
  scale_fill_manual(values = jet.colors(8)) +
  scale_x_continuous(limits=c(8,20), breaks=seq(8,18,2)) +
  scale_y_discrete(breaks=seq(0,7,1)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position='none') +
  labs(x=(expression(Median~annual~epilimnetic~temperature~(degree*C))), 
       y = (expression(Air~temperature~increase~(degree*C))))
