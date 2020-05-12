struct GeoTable{T<:Array}
    features::T
end

function GeoTable(features::T) where T<:Array
    geom = features[1].geometry
    if(geom == nothing)
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
Base.getindex(gt::GeoTable, i) = GeoTableRow(Row(gt)[i])
Base.IndexStyle(::Type{<:GeoTable}) = IndexLinear()

struct GeoTableRow
    Row
    feature_number::Int
end

function Tables.schema(features)

    names_fields = Tuple(keys(features[1].properties))
    geom_names = ("Geometry")
    names = (names_fields..., geom_names)
    
    #todo types
    # types_fields = Tuple(typeofvalu(features[1].properties))
    # geom_types = #todo
    # types = (types_fields..., geom_types...)
    types= (1,2,3)
    Tables.Schema(names, types)
end



# Tables.columnaccess(gt::GeoTable) = true
# Tables.columns(gt::GeoTable) = gt

# Tables.getcolumn(gt::GeoTable, i::Int) = 
# Tables.getcolumn(gt::GeoTable, nm::Symbol) = iterate(gt.features)




# Base.getindex(gtr::GeoTableRow, i) = gtr.Row[i]
# Base.IndexStyle(::Type{<:GeoTableRow}) = IndexLinear()
# Base.getindex(gt::GeoTable, i) = (gt.features)[i]
# Base.length(gt::GeoTable) = (length(gt.features))




function Base.iterate(gt::GeoTable, st = 1)
    features = gt.features

    d = Dict{String, Vector}()

    for i in String.(Tables.schema(gt.features).names)
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
        else 
            val = features[st].properties[k]
        end
        push!(v, val)
    end
    
    
    keys_tup = ()
    for _key in keys(d)
        keys_tup = (keys_tup..., Symbol(_key))
    end
    
    namez = ()
    for k in keys(d)
        namez = (namez..., Symbol(k))
    end
    
    value = Tuple(values(d))

    Row = NamedTuple{namez}(value)
    return GeoTableRow(Row, st), st + 1
end

# required `Tables.AbstractRow` interface methods
# getcolumn(gtr::GeoTableRow, i::Int) = getindex(gtr.Row, i)
# getcolumn(gtr::GeoTableRow, nm::Symbol) = getindex(gtr.Row, nm)
# columnnames(gtr::GeoTableRow) = String.(keys(gtr.Row))

# function Base.show(io::IO, gt::GeoTable, gtr::GeoTableRow)
#     println(io, "$(length(gtr.Row))")
# end













