abstract type AbstractAction end
abstract type AbstractSyncAction <: AbstractAction end
abstract type AbstractAsyncAction <: AbstractAction end

module ActionTypes

import ..AbstractSyncAction

struct __REDUX_INIT <: AbstractSyncAction end
struct __REDUX_PROBE_UNKNOWN_ACTION <: AbstractSyncAction end

const INIT = __REDUX_INIT()
const PROBE_UNKNOWN_ACTION = __REDUX_PROBE_UNKNOWN_ACTION()

end
