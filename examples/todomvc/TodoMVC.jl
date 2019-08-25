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

const INITIAL_STATE = State(Todo.INITIAL_STATE, TodoFilter.State(TodoFilter.SHOW_ALL))

# reducers
todo_mvc(state::AbstractState, action::AbstractAction) = state
todo_mvc(state::Vector{<:AbstractState}, action::AbstractAction) = state
function todo_mvc(state::State, action::AbstractSyncAction)
    next_todos = Todo.todo(state.todos, action)
    next_visibility = TodoFilter.todo_filter(state.visibility, action)
    return State(next_todos, next_visibility)
end

end # module
