abstract type AbstractStore{T} end

mutable struct Store{T} <: AbstractStore{T}
    reducer::Base.Callable
    current_state::T
    current_listeners::Vector
    next_listeners::Vector
    is_dispatching::Bool
end
function Store(reducer, preloaded_state)
    current_listeners = []
    next_listeners = current_listeners
    Store(reducer, preloaded_state, current_listeners, next_listeners, false)
end

function get_state(store::AbstractStore)
    store.is_dispatching && error("calling get_state() while the reducer is executing is not allowd in Redux.")
    return store.current_state
end

function subscribe!(store::AbstractStore, listener::Base.Callable)
    store.is_dispatching && error("calling subscribe() while the reducer is executing is not allowd in Redux.")

    is_subscribed = true

    if store.next_listeners === store.current_listeners
        store.next_isteners = copy(store.current_listeners)
    end
    push!(store.next_isteners, listener)

    function unsubscribe!()
        !is_subscribed && return;

        store.is_dispatching && error("unsubscribing from a store listener while the reducer is executing is not allowd in Redux.")

        is_subscribed = false

        if store.next_listeners === store.current_listeners
            store.next_isteners = copy(store.current_listeners)
        end
        deleteat!(store.next_listeners, findall(isequal(listener), store.next_listeners))
        empty!(store.current_listeners)
    end

    return unsubscribe!
end

function dispatch!(store::AbstractStore, action::AbstractSyncAction)
    store.is_dispatching && error("reducers may not dispatch actions.")

    try
        store.is_dispatching = true
        store.current_state = store.reducer(store.current_state, action)
    finally
        store.is_dispatching = false
    end

    store.current_listeners = store.next_listeners
    foreach(store.current_listeners) do listener
        listener()
    end

    return action
end

function create_store(reducer::Base.Callable, preloaded_state)
    store = Store(reducer, preloaded_state)
    dispatch!(store, ActionTypes.INIT)
    return store
end
create_store(reducer::Base.Callable, preloaded_state, enhancer::Base.Callable) = enhancer(create_store)(reducer, preloaded_state)
