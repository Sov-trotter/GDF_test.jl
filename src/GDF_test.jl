module GDF_test

# greet() = print("Hello World!")

using GeoJSONTables, DataFrames

include("tables.jl")
include("io.jl")

export GeoTable, gdf_from_geojson, read_gjt
end # module
