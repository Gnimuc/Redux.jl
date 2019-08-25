module Todo

using Redux

# actions
struct AddTodo{T<:AbstractString} <: AbstractSyncAction
    text::T
end

struct DeleteTodo <: AbstractSyncAction
    id::Int
end

struct EditTodo{T<:AbstractString} <: AbstractSyncAction
    id::Int
    text::T
end

struct CompleteTodo <: AbstractSyncAction
    id::Int
end

struct CompleteAllTodos <: AbstractSyncAction end

struct ClearCompleted <: AbstractSyncAction end


# state
struct State <: AbstractImmutableState
    id::Int
    completed::Bool
    text::String
end

const INITIAL_STATE = State[State(0, false, "Use Redux")]

# reducers
todo(state::AbstractState, action::AbstractAction) = state
todo(state::Vector{<:AbstractState}, action::AbstractAction) = state
todo(s::Vector{State}, a::AddTodo) = State[s..., State(isempty(s) ? 1 : s[end].id + 1, false, a.text)]
todo(s::Vector{State}, a::DeleteTodo) = filter(s -> s.id !== a.id, s)
todo(s::Vector{State}, a::EditTodo) = map(s) do s
    s.id === a.id ? State(s.id, s.completed, a.text) : s
end
todo(s::Vector{State}, a::CompleteTodo) = map(s) do s
    s.id === a.id ? State(s.id, !s.completed, s.text) : s
end
function todo(s::Vector{State}, a::CompleteAllTodos)
    are_all_marked = all(x->x.completed, s)
    map(x->State(x.id, !are_all_marked, x.text), s)
end
todo(s::Vector{State}, a::ClearCompleted) = filter(s -> s.completed == false, s)


end # module
