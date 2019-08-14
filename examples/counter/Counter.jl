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

get_counter(state::State) = state.counter

# reducers
Redux.reducer(state::State, action::IncrementAction) = State(get_counter(state) + 1)
Redux.reducer(state::State, action::DecrementAction) = State(get_counter(state) - 1)

end # module
