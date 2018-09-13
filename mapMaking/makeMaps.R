# Demo script to make basic maps with place locations based on lat/long

#install.packages('pacman')
pacman::p_load(maps)

# Plotting single site: FCR ####
data <- data.frame(Lat = c(37.3), Long = c(-79.84))

# FCR in whole USA
par(mar = c(0,0,0,0),mgp=c(0,0,0))
map('usa', col='grey90',fill=T, border='grey50', wrap=T,lwd=0.3) # background USA map
map('state', region=c('virginia'), add = T, border='grey50',col='lightblue', fill=T, lwd=0.5) #VA
points(data$Long,data$Lat,col='black', pch=16, cex=1,lwd=1)

# FCR within VA
par(mar = c(0,0,0,0),mgp=c(0,0,0))
map('state', region=c('virginia'), lwd=2)
points(data$Long,data$Lat, cex=1.5,lwd=1, pch=16, col='black')
text(-79.6, 37.1, "FCR")

# FCR in the SE/Mid-Atlantic (can remove states from list to omit)
myRegion <- c('north carolina','south carolina','virginia', 'georgia','tennessee',
            'alabama','kentucky','west virginia', 'maryland',
            'ohio','pennsylvania')

par(mar = c(0,0,0,0),mgp=c(0,0,0))
map("state", region= myRegion,lty = 1, col='black', lwd=2)
map('state', region=c('virginia'), lwd=0.5, add = T)
points(data$Long,data$Lat,col= 'black',
         bg ='dodgerblue', pch=23, cex=2,lwd=2)

# Plotting multiple sites (e.g., MacroEDDIE Teleconnections lakes)####
Longitude <- c(-82.00909, -89.47825, -79.83722, -89.42060, -72.05270, -89.70477, 
               -99.11763, -99.25055, -82.01617, -149.61051)

Latitude <- c(29.67647, 46.21111, 37.30333, 43.10970, 43.38020, 45.99827, 
                47.15941, 47.12999, 29.68705, 68.62956)

par(mar = c(0,0,0,0),mgp=c(0,0,0))
maps::map("world", c("USA", "alaska"), xlim=c(-180,-65), ylim=c(19,72), col='grey90',
          fill=T, border='grey50', wrap=T,lwd=0.3) # background USA map
maps::map('state', region=c('florida', 'new hampshire','wisconsin','north dakota'), 
          add = T, border='grey50',col='lightblue', fill=T, lwd=0.5) # States from conterminous US
maps::map("world", c("USA:Alaska"), add = T, border='grey50',col='lightblue', fill=T, lwd=0.5) # Alaska
points(Longitude, Latitude,col='black', pch=16, cex=1,lwd=1)

# Just Conterminous sites.
par(mar = c(0,0,0,0),mgp=c(0,0,0))
maps::map('usa', col='grey90',fill=T, border='grey50', wrap=T,lwd=0.3) # background USA map
maps::map('state', region=c('florida', 'new hampshire','wisconsin','north dakota', 'virginia'), 
          add = T, border='grey50',col='lightblue', fill=T, lwd=0.5) # States from conterminous US
points(Longitude, Latitude,col='black', pch=16, cex=1,lwd=1)
