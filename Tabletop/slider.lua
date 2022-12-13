function onLoad()
    self.createInput({
        input_function = "input_func",
        function_owner = self,
        label          = "Gold",
        alignment      = 4,
        position       = {x=0, y=1, z=0},
        width          = 800,
        height         = 300,
        font_size      = 323,
        validation     = 2,
    })
end

function input_func(obj, color, input, stillEditing)
    print(input)
    if not stillEditing then
        print("Finished editing.")
    end
end