module GDF_test

# greet() = print("Hello World!")

import Tables, GeoJSON, DataFrames

include("tables.jl")
include("io.jl")

export GeoTable, gdf_from_geojson
end # module
