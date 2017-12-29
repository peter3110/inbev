require(rgdal)
library(plyr)
library(ggplot2)
library(ggmap)

# DATOS DEL CENSO:
edades_por_radio <- data.frame(read.csv('data/data_hogares_viviendas/personas.csv'))
tot_personas_por_vivienda_por_radio <- read.csv('dadta/data_hogares_viviendas/HOGAR-TOTPERS.csv')


# RADIO CENSAL := POLITICO-TERRITORIAL (PROV) + POLITICO-ADMINISTRATIVA (DEPTO) + FRACCION +RADIO
radios_caba <- readOGR("data/Codgeo_CABA_con_datos/", "cabaxrdatos")
radios_prov <- readOGR("data/Codgeo_Buenos_Aires_con_datos/", "Buenos_Aires_con_datos")

#
edades_por_radio$radio[edades_por_radio$radio == 068821704]

# JOINEO LA DATA SEGUN 'RADIO'
radios_caba@data$id = rownames(radios_caba@data)
radios_caba@data$RADIO_FULL = as.integer(paste0(radios_caba@data$PROV, 
                                                radios_caba@data$DEPTO,
                                                radios_caba@data$FRAC,
                                                radios_caba@data$RADIO))
radios_caba@data = merge(radios_caba@data, edades_por_radio, by.x="RADIO_FULL", by.y="radio")

# AGREGACION DE DATA (ANTES DE HACER LOS JOIN)
radios_caba@data$edad_media = mean(c(
  as.numeric(radios_caba@data$edad_0), 
  as.numeric(radios_caba@data$edad_1)
)
)

# PREPROCESO EL DF PARA PODER USAR GGPLOT2 (ANTES DE HACER EL MAPA)
radios_caba = spTransform(radios_caba, CRS("+proj=longlat +datum=WGS84"))
radios_caba.df = fortify(radios_caba)
radios_caba.df = join(radios_caba@data, radios_caba.df, by="id")

radios_prov = spTransform(radios_prov, CRS("+proj=longlat +datum=WGS84"))
plot(radios_prov)

# PLOT 1
map <- ggplot(data = radios_prov.df,
              aes(x = long, y=lat, group = group)) +
  geom_polygon(aes(fill = edad_0)) +
  coord_fixed()
plot(radios_prov.df)

# PLOT 2
caba <- ggmap(get_map(
  maptype = "terrain-lines",
  location=c(lon = -58.4499982, lat = -34.6166642), 
  zoom = 12))
map <- caba + 
  geom_polygon(data= radios_caba.df,
    aes(x=long, y=lat, group=group, 
    fill = edad_0), 
    color = 'black',
    size= .2,
    alpha=0.8) +
  labs(title = 'Visualizacion informacion Censo 2010') + 
  guides(fill=guide_legend(title="Ninios"))
map

 
