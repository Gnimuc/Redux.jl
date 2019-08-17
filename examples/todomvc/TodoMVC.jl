module TodoMVC

using Redux

include("Todo.jl")
using .Todo

include("TodoFilter.jl")
using .TodoFilter

# state
struct State <: AbstractImmutableState
    todos::Vector{Todo.State}
    visibility::TodoFilter.State
end

const INITIAL_STATE = State(Todo.INITIAL_STATE, TodoFilter.SHOW_ALL)

# reducers
function Redux.reducer(state::State, action::AbstractSyncAction)
    next_todos = reducer(state.todos, action)
    next_visibility = reducer(state.visibility, action)
    return State(next_todos, next_visibility)
end

end # module
