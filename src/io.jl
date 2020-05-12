
function gdf_from_geojson(parsed_geojson)
    feat = parsed_geojson.features

    tbl = GeoTable(feat)
    
    return DataFrame(tbl)
end


# function read(parsed_geojson)

# function gdf_from_shp()



    