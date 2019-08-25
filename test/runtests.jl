using Redux
using Test

module Counter

using ..Redux

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

using .Counter

@testset "Redux" begin
    store = create_store(Counter.counter, Counter.State(0))
    state = get_state(store)
    @test state.counter == 0

    dispatch!(store, Counter.INCREMENT)
    @test state.counter == 0
    state = get_state(store)
    @test state.counter == 1

    dispatch!(store, Counter.DECREMENT)
    state = get_state(store)
    @test state.counter == 0

    buffer = IOBuffer()
    unsub = subscribe!(store, ()->println(buffer, "current counter: $(get_state(store).counter)"))
    dispatch!(store, Counter.DECREMENT)
    @test String(take!(buffer)) == "current counter: -1\n"
    dispatch!(store, Counter.INCREMENT)
    @test String(take!(buffer)) == "current counter: 0\n"
    unsub()
    dispatch!(store, Counter.DECREMENT)
    @test String(take!(buffer)) == ""
    dispatch!(store, Counter.INCREMENT)
    @test String(take!(buffer)) == ""
end
