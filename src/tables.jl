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

# struct GeoTable_sp{T<:Any}
#     sp::T
# end


# function GeoTable_sp(sp::T) where T<:Any
#     if(sp === nothing)
#         error("Not a valid geojson")
#     end
#     GeoTable_sp{T}(sp)
# end





# Tables.istable(::Type{<:GeoTable_sp}) = true
# Tables.rowaccess(::Type{<:GeoTable_sp}) = true
# Tables.rows(gt_sp::GeoTable_sp) = gt_sp

# Base.IteratorSize(::Type{<:GeoTable_sp}) = Base.HasLength()
# Base.length(gt_sp::GeoTable_sp) = (length(gt_sp.sp)) 
# Base.IteratorEltype(::Type{<:GeoTable_sp}) = Base.HasEltype()

# # read only AbstractVector
# Base.size(gt_sp::GeoTable_sp) = length(gt_sp.sp)  #use getter fxn here
# Base.getindex(gt_sp::GeoTable_sp, i) =  GeoTableRow_sp(sp(gt_sp)[i])
# Base.IndexStyle(::Type{<:GeoTable_sp}) = IndexLinear()

# # miss(x) = ifelse(x === nothing, missing, x)

# struct GeoTableRow_sp{T}
#     sp_f::T
# end

# Base.propertynames(gtr_sp::GeoTableRow_sp) = propertynames(properties(gtr_sp))

# # "Access the properties JSON3.Object of a Feature"
# # properties(gtr_sp::GeoTableRow_sp) = getfield(sp_f(gtr_sp), :record) ; println("prop got")
# # "Access the JSON3.Object that represents the Feature"
# # sp_f(gtr_sp::GeoTableRow_sp) = (gtr_sp.sp_f)[1] ; println("fetched")
# # "Access the JSON3.Array that represents the FeatureCollection"
# # # sp(gt_sp::GeoTable_sp) = getfield(gt_sp, :sp)
# "Access the JSON3.Object that represents the Feature's geometry"
# geometry(gtr_sp::GeoTableRow_sp) = Shapefile.shape(gtr_sp.sp_f)

# function Base.getproperty(gtr_sp::GeoTableRow_sp, sym::Symbol)
#     nm = sym
#     # println(nm);
#     props = properties(gtr_sp) #todo
#     println("got it")
#     val = props.nm
#     println("passed all")
# end


# @inline function Base.iterate(gt_sp::GeoTable_sp)
#     st = iterate(gt_sp.sp)
#     st === nothing && return nothing
#     val, state = st
#     return GeoTableRow_sp(val), state
# end

# @inline function Base.iterate(gt_sp::GeoTable_sp, st)
#     st = iterate(gt_sp.sp, st)
#     st === nothing && return nothing
#     val, state = st
#     return GeoTableRow_sp(val), state
# end



# struct FeatureCollection{T} <: AbstractVector{eltype(T)}
#     json::T
# end

# function read(source)
#     fc = JSON3.read(source)
#     features = get(fc, :features, nothing)
#     println(features)
#     if get(fc, :type, nothing) == "FeatureCollection" && features isa JSON3.Array
#         FeatureCollection{typeof(features)}(features)
#     else
#         throw(ArgumentError("input source is not a GeoJSON FeatureCollection"))
#     end
# end

# Tables.istable(::Type{<:FeatureCollection}) = true
# Tables.rowaccess(::Type{<:FeatureCollection}) = true
# Tables.rows(fc::FeatureCollection) = fc

# Base.IteratorSize(::Type{<:FeatureCollection}) = Base.HasLength()
# Base.length(fc::FeatureCollection) = length(json(fc))
# Base.IteratorEltype(::Type{<:FeatureCollection}) = Base.HasEltype()

# # read only AbstractVector
# Base.size(fc::FeatureCollection) = size(json(fc))
# Base.getindex(fc::FeatureCollection, i) = Feature(json(fc)[i])
# Base.IndexStyle(::Type{<:FeatureCollection}) = IndexLinear()

# miss(x) = ifelse(x === nothing, missing, x)

# struct Feature{T}
#     json::T
# end

# # these features always have type="Feature", so exclude that
# # the keys in properties are added here for direct access
# Base.propertynames(f::Feature) = propertynames(properties(f))

# "Access the properties JSON3.Object of a Feature"
# properties(f::Feature) = json(f).properties
# "Access the JSON3.Object that represents the Feature"
# json(f::Feature) = getfield(f, :json)
# "Access the JSON3.Array that represents the FeatureCollection"
# json(f::FeatureCollection) = getfield(f, :json)
# "Access the JSON3.Object that represents the Feature's geometry"
# geometry(f::Feature) = json(f).geometry

# """
# Get a specific property of the Feature

# Returns missing for null/nothing or not present, to work nicely with
# properties that are not defined for every feature. If it is a table,
# it should in some sense be defined.
# """
# function Base.getproperty(f::Feature, nm::Symbol)
#     props = properties(f)
#     val = get(props, nm, missing)
#     miss(val)
# end

# @inline function Base.iterate(fc::FeatureCollection)
#     st = iterate(json(fc))
#     st === nothing && return nothing
#     val, state = st
#     return Feature(val), state
# end

# @inline function Base.iterate(gt::GeoTable_sp, st)
#     st = iterate(json(fc), st)
#     st === nothing && return nothing
#     val, state = st
#     return Feature(val), state
# end

