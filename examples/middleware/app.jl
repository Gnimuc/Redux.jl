using Redux
using CImGui

include(joinpath(@__DIR__, "..", "counter", "Counter.jl"))
using .Counter

include("../Renderer.jl")
using .Renderer

# middlewares
function add_logging(dispatch)
    new_dispatch = (s::Store, a::AbstractAction) -> begin
        @info "dispatching action:" a
        result = dispatch(s, a)
        @info "next state:" get_state(s)
        return result
    end
    return new_dispatch
end

function more_logging(dispatch)
    new_dispatch = (s::Store, a::AbstractAction) -> begin
        result = dispatch(s, a)
        @info """------------
                 reducer: $(s.reducer)
                 current_state: $(s.current_state)
                 current_listeners: $(s.current_listeners)
                 next_listeners: $(s.next_listeners)
                 is_dispatching: $(s.is_dispatching)
              """
        return result
    end
    return new_dispatch
end

const store = create_store(Counter.counter, Counter.State(0), [add_logging, more_logging])

function counter_ui(store)
    flag = CImGui.ImGuiWindowFlags_NoTitleBar |
           CImGui.ImGuiWindowFlags_NoResize |
           CImGui.ImGuiWindowFlags_AlwaysAutoResize |
           CImGui.ImGuiWindowFlags_NoSavedSettings |
           CImGui.ImGuiWindowFlags_NoFocusOnAppearing |
           CImGui.ImGuiWindowFlags_NoNav
    CImGui.Begin("Counter", Ref(true), flag)
        spacing = CImGui.GetStyle().ItemInnerSpacing.x
        CImGui.PushButtonRepeat(true)
        CImGui.ArrowButton("##left", CImGui.ImGuiDir_Left) && dispatch!(store, Counter.DECREMENT)
        CImGui.SameLine(0.0, spacing)
        CImGui.ArrowButton("##right", CImGui.ImGuiDir_Right) && dispatch!(store, Counter.INCREMENT)
        CImGui.PopButtonRepeat()
        CImGui.SameLine()
        value = get_state(store).counter
        CImGui.Text("$value")
    CImGui.End()
end

Renderer.render(()->counter_ui(store), width=180, height=50, title="App: Counter")
