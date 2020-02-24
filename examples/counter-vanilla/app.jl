using CImGui

include("../Renderer.jl")
using .Renderer

let counter = 0
global function counter_ui()
    flag = CImGui.ImGuiWindowFlags_NoTitleBar |
           CImGui.ImGuiWindowFlags_NoResize |
           CImGui.ImGuiWindowFlags_AlwaysAutoResize |
           CImGui.ImGuiWindowFlags_NoSavedSettings |
           CImGui.ImGuiWindowFlags_NoFocusOnAppearing |
           CImGui.ImGuiWindowFlags_NoNav
    CImGui.Begin("Counter", Ref(true), flag)
        spacing = CImGui.GetStyle().ItemInnerSpacing.x
        CImGui.PushButtonRepeat(true)
        CImGui.ArrowButton("##left", CImGui.ImGuiDir_Left) && (counter-=1;)
        CImGui.SameLine(0.0, spacing)
        CImGui.ArrowButton("##right", CImGui.ImGuiDir_Right) && (counter+=1;)
        CImGui.PopButtonRepeat()
        CImGui.SameLine()
        CImGui.Text("$counter")
    CImGui.End()
end
end

Renderer.render(counter_ui, width=230, height=50, title="App: Counter-Vanilla")
