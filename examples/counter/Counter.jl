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

# reducer methods
Redux.reducer(state::State, action::IncrementAction) = State(state.counter + 1)
Redux.reducer(state::State, action::DecrementAction) = State(state.counter - 1)

end # module
