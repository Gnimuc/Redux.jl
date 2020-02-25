# Redux

[![Build Status](https://travis-ci.com/Gnimuc/Redux.jl.svg?branch=master)](https://travis-ci.com/Gnimuc/Redux.jl)
[![Codecov](https://codecov.io/gh/Gnimuc/Redux.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/Gnimuc/Redux.jl)

## Installation
```julia
pkg> add Redux
```

## Quick Start
```julia
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

# create store
store = create_store(counter, State(0))

# get_state
@show get_state(store).counter

# dispatch action
dispatch!(store, INCREMENT)
@show get_state(store).counter

dispatch!(store, DECREMENT)
@show get_state(store).counter

```
