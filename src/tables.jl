struct GeoTable{T<:Array}
    features::T
end

function GeoTable(features::T) where T<:Array
    geom = features[1].geometry
    if(geom === nothing)
        error("Not a valid geojson")
    end
    GeoTable{T}(features)
end

Tables.istable(::Type{<:GeoTable}) = true
Tables.rowaccess(::Type{<:GeoTable}) = true
Tables.rows(gt::GeoTable) = gt

Base.IteratorSize(::Type{<:GeoTable}) = Base.HasLength()
Base.length(gt::GeoTable) = (length(gt.features))
Base.IteratorEltype(::Type{<:GeoTable}) = Base.HasEltype()

# read only AbstractVector
Base.size(gt::GeoTable) = length(gt.features)
Base.getindex(gt::GeoTable, i) = iterate((gt.features), i)
Base.IndexStyle(::Type{<:GeoTable}) = IndexLinear()

struct GeoTableRow
    UUID   # TODO : fetch property names paticular to the geojson
    FID
    Geometry
end

function Tables.schema(features::Array)

    names_fields = (keys(features[1].properties))
    geom_names = ("Geometry")
    names = (names_fields..., geom_names)
    
    #todo types
    # types_fields = Tuple(typeofvalu(features[1].properties))
    # geom_types = #todo
    # types = (types_fields..., geom_types...)
    types= (1,2,3)
    Tables.Schema(names, types)
end



function Base.iterate(gt::GeoTable, st = 1)
    features = gt.features

    d = Dict{String, Vector}()

    geom = ""
    prop_1 = ""
    prop_2 = ""

    namesz =  String.(Tables.schema(gt.features).names)
    for i in namesz
        if(i == "Geometry")
            d[i] = []
        else
            d[i] = Any[]
            end
    end

    st > length(features) && return nothing
    for (k, v) in pairs(d)
        if k == "Geometry"
            val = features[st].geometry
            geom = val
        elseif k == namesz[1]
            val = features[st].properties[k]
            prop_1 = val
        elseif k == namesz[2]
        # else 
            val = features[st].properties[k]
            prop_2 = val
        end
        
        
    end
    
    return GeoTableRow(prop_1, prop_2, geom), st + 1
end

