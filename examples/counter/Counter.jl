module Counter

using Redux

# actions
struct IncrementAction <: AbstractSyncAction end
struct DecrementAction <: AbstractSyncAction end

const INCREMENT = IncrementAction()
const DECREMENT = DecrementAction()

# state
struct State <: AbstractImmutableState
    counter::Int
end

# reducers
counter(state::AbstractState, action::AbstractAction) = state
counter(state::Vector{<:AbstractState}, action::AbstractAction) = state
counter(state::State, action::IncrementAction) = State(state.counter + 1)
counter(state::State, action::DecrementAction) = State(state.counter - 1)


end # module
