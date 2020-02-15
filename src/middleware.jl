mutable struct MiddlewareStore{T} <: AbstractStore{T}
    store::Store{T}
    middlewares::Vector
end
MiddlewareStore(store::Store) = MiddlewareStore(store, [])

function identity_middleware(dispatch)
    new_dispatch = (s::Store, a::AbstractAction) -> begin
        # prologue
        result = dispatch(s, a)
        # epilogue
        return result
    end
    return new_dispatch
end

function dispatch!(store::MiddlewareStore, action::AbstractAction)
    isempty(store.middlewares) && dispatch!(store.store, action)
    dispatch = identity_middleware(dispatch!)
    for middleware in store.middlewares
        dispatch = middleware(dispatch)
    end
    return dispatch(store.store, action)
end

get_state(store::MiddlewareStore) = get_state(store.store)
subscribe!(store::MiddlewareStore, listener::Base.Callable) = subscribe!(store.store, listener)

function create_store(reducer::Base.Callable, preloaded_state, middlewares)
    store = create_store(reducer, preloaded_state)
    return MiddlewareStore(store, middlewares)
end
