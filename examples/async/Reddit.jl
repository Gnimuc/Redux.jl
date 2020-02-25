module Reddit

using Redux
using Dates
using HTTP
using JSON

# sync actions
struct SelectSubreddit <: AbstractSyncAction
    subreddit
end

struct InvalidateSubreddit <: AbstractSyncAction
    subreddit
end

struct RequestPosts <: AbstractSyncAction
    subreddit
end

struct ReceivePosts <: AbstractSyncAction
    subreddit
    posts::Vector
    received_at::DateTime
end
ReceivePosts(subreddit, json::AbstractDict) = ReceivePosts(subreddit, map(x->x["data"], json["data"]["children"]), Dates.now())

# async actions
FetchPosts(subreddit) = dispatch -> begin
    dispatch(RequestPosts(subreddit))
    raw = HTTP.get("https://www.reddit.com/r/$subreddit.json").body
    json = JSON.parse(String(raw))
    dispatch(ReceivePosts(subreddit, json))
end

function ShouldFetchPosts(state, subreddit)
    posts = state.postsBySubreddit[subreddit]
    !posts && return true
    posts.isFetching && false
    return posts.didInvalidate
end

FetchPostsIfNeeded(subreddit) = (dispatch, getState) -> begin
    if ShouldFetchPosts(getState(), subreddit))
        return dispatch(FetchPosts(subreddit))
    end
end

# state
struct Item
    id::String
    title::String
end

struct PostState <: AbstractImmutableState
    is_fetching::Bool
    did_invalidate::Bool
    items::Vector{Item}
    last_updated::DateTime
end
PostState() = PostState(false, false, [], DateTime(0))

struct State <: AbstractImmutableState
    selected_subreddit::String
    posts_by_subreddit::Dict{String,PostState}
end
State() = State("reactjs", Dict("reactjs"=>PostState()))

# reducers
posts(state::AbstractState, action::AbstractAction) = state
posts(state::Vector{<:AbstractState}, action::AbstractAction) = state
posts(s::PostState, a::InvalidateSubreddit) = PostState(s.is_fetching, true, s.items, s.last_updated)
posts(s::PostState, a::RequestPosts) = PostState(true, false, s.items, s.last_updated)
posts(s::PostState, a::ReceivePosts) = PostState(false, false, a.posts, a.received_at)

selected_subreddit(state::AbstractState, action::AbstractAction) = state
selected_subreddit(state::Vector{<:AbstractState}, action::AbstractAction) = state
selected_subreddit(s::State, a::SelectSubreddit) = State(a.subreddit, s.posts_by_subreddit)

posts_by_subreddit(state::AbstractState, action::AbstractAction) = state
posts_by_subreddit(state::Vector{<:AbstractState}, action::AbstractAction) = state
function posts_by_subreddit(s::State, a::Union{InvalidateSubreddit,RequestPosts,ReceivePosts})
    new_post_state = posts(s.posts_by_subreddit[a.subreddit], a)
    return State(s.selected_subreddit, Dict(a.subreddit=>new_post_state))
end

function root_reducer(state::AbstractState, action::AbstractAction)
    next_state = posts_by_subreddit(state, action)
    next_state = selected_subreddit(next_state, action)
    return next_state
end

end # module
