const gjt = GeoJSONTables
const shp = Shapefile


struct read_gjt{T<:Array}
    properties::T
    geomtery::T
end
""" Aceepts a geojson table and returns it's properties and geometry """
function read_gjt(geojson_table)
    properties = []
    geometry = []
    for i in geojson_table
        push!(properties, get_props(i))
        push!(geometry, get_geom(i))
    end
    return read_gjt(properties, geometry)
end

""" Getter method for fetching properties of a geojson table"""    
function get_props(geojson_table_row) 
    keys_prop = Tuple(propertynames(geojson_table_row));
    vals_prop= ()
    for ky in keys_prop
        vals_prop = (vals_prop..., getproperty(geojson_table_row, ky));
    end
    return NamedTuple{keys_prop}(vals_prop);
end

""" Getter method for fetching geometry of a geojson table""" 
function get_geom(geojson_table_row)
    gj_geom = gjt.geometry(geojson_table_row)
    keys_geom = Tuple(propertynames(gj_geom))
    vals_geom = ()
    for k in keys_geom
        vals_geom = (vals_geom..., getproperty(gj_geom, k))
    end
    return NamedTuple{keys_geom}(vals_geom)
end






















function gdf_from_geojson(geojson_source)
    parsed_geojson = GeoJSON.read(geojson_source)
    feat = parsed_geojson.features

    tbl = GeoTable(feat)
    
    return DataFrame(tbl)
end


# # # function read(parsed_geojson)

# function gdf_from_shp(shp)
#     tbl = GeoTable_sp(shp)
#     return DataFrame(tbl)
# end

# # function GJT_read()

