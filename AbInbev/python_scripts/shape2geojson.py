import shapefile
from json import dumps
   # read the shapefile
file_dir_src = "data/Codgeo_Buenos_Aires_con_datos/Buenos_Aires_con_datos.shp"
file_dir_dst = "pyshp-demo.json"

reader = shapefile.Reader(file_dir_src)
fields = reader.fields[1:]
field_names = [field[0] for field in fields]
buffer = []
for sr in reader.shapeRecords():
  atr = dict(zip(field_names, sr.record))
  geom = sr.shape.__geo_interface__
  buffer.append(dict(type="Feature", geometry=geom, properties=atr)) 

# write the GeoJSON file
geojson = open(file_dir_dst, "w")
geojson.write(dumps({"type": "FeatureCollection", "features": buffer}, indent=2) + "\n")
geojson.close()