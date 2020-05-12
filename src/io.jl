
function gdf_from_geojson(parsed_geojson)
    feat = parsed_geojson.features

    tbl = GeoTable(feat)
    return tbl
end

# function gdf_from_shp()



    