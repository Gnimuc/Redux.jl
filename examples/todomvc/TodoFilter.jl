module TodoFilter

using Redux

# actions
struct SetVisibilityFilter{T<:AbstractString} <: AbstractSyncAction
    filter::T
end

# state
struct State <: AbstractImmutableState
    filter::String
end

const SHOW_ALL = State("show_all")
const SHOW_COMPLETED = State("show_completed")
const SHOW_ACTIVE = State("show_active")

# reducers
Redux.reducer(s::State, a::SetVisibilityFilter) = State(a.filter)

end # module