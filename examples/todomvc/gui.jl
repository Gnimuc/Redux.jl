function todo_input_ui(store)
    todos = get_state(store).todos
    flag = CImGui.ImGuiInputTextFlags_AutoSelectAll |
           CImGui.ImGuiInputTextFlags_EnterReturnsTrue
    buffer_len = 128
    spacing = CImGui.GetStyle().ItemInnerSpacing.x

    all_complete = Ref(all(x->x.completed, todos))
    CImGui.Checkbox("###todo_all", all_complete) && dispatch!(store, Todo.CompleteAllTodos())
    CImGui.SameLine(0.0, spacing)
    str = Vector{Cuchar}("What needs to be done?")
    append!(str, ['\0' for i = 1:buffer_len-length(str)])
    CImGui.PushItemWidth(-1)
    if CImGui.InputText("###todo_input", str, buffer_len, flag)
        new_str = GC.@preserve str unsafe_string(pointer(str))
        dispatch!(store, Todo.AddTodo(new_str))
    end
    CImGui.PopItemWidth()
end

function todo_list_ui(store)
    todos = get_state(store).todos
    visi = get_state(store).visibility
    flag = CImGui.ImGuiInputTextFlags_EnterReturnsTrue
    spacing = CImGui.GetStyle().ItemInnerSpacing.x
    buffer_len = 128

    CImGui.PushItemWidth(-1)
    CImGui.ListBoxHeader("List", -2)
        for i = 1:length(todos)
            id = todos[i].id
            status = todos[i].completed
            visi.filter == TodoFilter.SHOW_ACTIVE && status && continue
            visi.filter == TodoFilter.SHOW_COMPLETED && !status && continue
            # todo marker
            check = Ref(status)
            CImGui.Checkbox("###todo_$id", check) && dispatch!(store, Todo.CompleteTodo(id))
            CImGui.SameLine(0.0, spacing)
            # todo text
            old_text = todos[i].text
            if check[]
                CImGui.TextDisabled(old_text)
                CImGui.SameLine(CImGui.GetWindowContentRegionMax().x-18, spacing)
            else
                CImGui.PushItemWidth(-18)
                str = Vector{Cuchar}(old_text)
                append!(str, ['\0' for i = 1:buffer_len-length(str)])
                if CImGui.InputText("###todolist_$i", str, buffer_len, flag)
                    new_str = GC.@preserve str unsafe_string(pointer(str))
                    dispatch!(store, Todo.EditTodo(id, new_str))
                end
                CImGui.PopItemWidth()
                CImGui.SameLine(0.0, spacing)
            end
            # delete todo
            CImGui.PushID(i)
            CImGui.PushStyleColor(CImGui.ImGuiCol_Button, CImGui.HSV(0.0, 0.3, 0.3))
            CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonHovered, CImGui.HSV(0.0, 0.6, 0.6))
            CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonActive, CImGui.HSV(0.0, 0.9, 0.9))
            CImGui.PushItemWidth(-1)
            CImGui.Button("X") && dispatch!(store, Todo.DeleteTodo(id))
            CImGui.PopItemWidth()
            CImGui.PopStyleColor(3)
            CImGui.PopID()
        end
    CImGui.ListBoxFooter()
    CImGui.PopItemWidth()
end

function todo_mvc_ui(store)
    flag = CImGui.ImGuiWindowFlags_NoTitleBar |
           CImGui.ImGuiWindowFlags_NoResize |
           CImGui.ImGuiWindowFlags_AlwaysAutoResize |
           CImGui.ImGuiWindowFlags_NoSavedSettings |
           CImGui.ImGuiWindowFlags_NoFocusOnAppearing |
           CImGui.ImGuiWindowFlags_NoNav
    todos = get_state(store).todos
    visi = get_state(store).visibility
    CImGui.Begin("TodoMVC", Ref(true), flag)
        todo_input_ui(store)
        CImGui.Separator()
        todo_list_ui(store)
        CImGui.Separator()
        # active items counter
        active_item_num = count(x -> !x.completed, todos)
        CImGui.TextColored((1.0,1.0,0.0,1.0), "$active_item_num items left.")
        CImGui.SameLine()
        # visibility filter
        CImGui.RadioButton("All", visi.filter == TodoFilter.SHOW_ALL) && dispatch!(store, TodoFilter.SetVisibilityFilter(TodoFilter.SHOW_ALL))
        CImGui.SameLine()
        CImGui.RadioButton("Active", visi.filter == TodoFilter.SHOW_ACTIVE) && dispatch!(store, TodoFilter.SetVisibilityFilter(TodoFilter.SHOW_ACTIVE))
        CImGui.SameLine()
        CImGui.RadioButton("Completed", visi.filter == TodoFilter.SHOW_COMPLETED) && dispatch!(store, TodoFilter.SetVisibilityFilter(TodoFilter.SHOW_COMPLETED))
        CImGui.SameLine()
        # clear completed
        if count(x -> x.completed, todos) != 0
            CImGui.PushItemWidth(-1)
            CImGui.PushStyleColor(CImGui.ImGuiCol_Button, CImGui.HSV(0.0, 0.5, 0.5))
            CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonHovered, CImGui.HSV(0.0, 0.7, 0.7))
            CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonActive, CImGui.HSV(0.0, 0.9, 0.9))
            CImGui.Button("Clear completed") && dispatch!(store, Todo.ClearCompleted())
            CImGui.PopStyleColor(3)
            CImGui.PopItemWidth()
        end
    CImGui.End()
end
