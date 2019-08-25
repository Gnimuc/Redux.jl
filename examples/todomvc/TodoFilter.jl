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

const SHOW_ALL = "show_all"
const SHOW_COMPLETED = "show_completed"
const SHOW_ACTIVE = "show_active"

# reducers
todo_filter(state::AbstractState, action::AbstractAction) = state
todo_filter(state::Vector{<:AbstractState}, action::AbstractAction) = state
todo_filter(s::State, a::SetVisibilityFilter) = State(a.filter)

end # module
