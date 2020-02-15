module Redux

include("action.jl")
export AbstractAction, AbstractSyncAction, AbstractAsyncAction
using .ActionTypes

include("store.jl")
export AbstractStore, Store
export create_store, get_state, subscribe!, dispatch!

include("middleware.jl")
export MiddlewareStore, identity_middleware

include("state.jl")
export AbstractState, AbstractMutableState, AbstractImmutableState

end # module
