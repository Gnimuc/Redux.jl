module App

using Redux
using CImGui

include("../../todomvc/TodoMVC.jl")
using .TodoMVC
import .TodoMVC: Todo, TodoFilter

include("Renderer.jl")
using .Renderer

include("../../todomvc/gui.jl")

Base.@ccallable function julia_main()::Cint
    try
        real_main()
    catch
        Base.invokelatest(Base.display_error, Base.catch_stack())
        return 1
    end
    return 0
end

function real_main()
    store = create_store(TodoMVC.todo_mvc, TodoMVC.INITIAL_STATE)
    Renderer.render(()->todo_mvc_ui(store), width=600, height=300, title="App: TodoMVC")
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    real_main()
end

end # module
