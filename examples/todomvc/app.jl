using Redux
using CImGui

include("TodoMVC.jl")
using .TodoMVC
import .TodoMVC: Todo, TodoFilter

include("../Renderer.jl")
using .Renderer

const store = create_store(reducer, TodoMVC.INITIAL_STATE)

include("gui.jl")

Renderer.render(()->todo_mvc_ui(store), width=600, height=300, title="App: TodoMVC")
