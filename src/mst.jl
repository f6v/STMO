#=
Created on Tuesday 28 January 2020
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Implementation of MST
=#

module MST

using DataStructures

using STMO

export prim

"""
    prim(vertices::Vertices{T}, edges::WeightedEdgeList{R,T},
                start::T) where {R<:Real, T}

Prim's algorithm for finding the minimum spanning tree. Inputs the vertices
(`vertices`), a list of weighted edges (`vertices`) and a starting vertex (`start`).
"""
function prim(vertices::Vertices{T}, edges::WeightedEdgeList{R,T},
                start::T) where {R<:Real, T}
    adjlist = edges2adjlist(edges)
    mst_edges = eltype(edges)[]
    mst_vertices = Set{T}([u])
    edges_to_check = [(w, u, n) for (w, n) in adjlist[u]]
    cost = zero(R)
    heapify!(edges_to_check)
    while length(mst_edges) < length(vertices) && length(edges_to_check) > 0
        # pop shortest edge, u part of tree, v might be new
        w, u, v = heappop!(edges_to_check)
        if v ∉ mst_vertices
            # add to MST
            push!(mst_edges, (w, u, v))
            push!(mst_vertices, v)
            # update cost
            cost += w
            # add neighbours of v
            for (wn, n) in adjlist[v]
                n ∉ mst_vertices && heappush!(edges_to_check, (wn, v, n))
            end
        end
    end
    return mst_edges, cost
end

"""
Prim's algorithm for finding a minimum spanning tree, chooses a reandom starting
node.
"""
prim(vertices::Vertices{T}, edges::WeightedEdgeList{R,T}) = prim(vertices, edges, rand(vertices))



end  # module MST
