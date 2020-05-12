
function gdf_from_geojson(geojson_source)
    parsed_geojson = GeoJSON.read(geojson_source)
    feat = parsed_geojson.features

    tbl = GeoTable(feat)
    
    return DataFrame(tbl)
end


# function read(parsed_geojson)

# function gdf_from_shp()



    