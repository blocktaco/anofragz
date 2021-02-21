function newLibrary()
    local userInputService = game:GetService('UserInputService')
    local runService = game:GetService('RunService')
    local tweenService = game:GetService('TweenService')

    local player = game.Players.LocalPlayer

    local util = {}

    local function generateString(length)
        local str = {}

        for i = 1, length do
            table.insert(str, string.char(math.random(33, 126)))
        end

        return table.concat(str)
    end

    function util:Create(class, data)
        local obj = Instance.new(class)
        for i, v in next, data do
            if i ~= 'Parent' then
                if typeof(v) == "Instance" then
                    v.Parent = obj
                else
                    obj[i] = v
                end
            end
        end

        obj.Parent = data.Parent
        return obj
    end

    function util:Dragger(gui)
        local dragging
        local dragInput
        local dragStart
        local startPos

        local function update(input)
        	local delta = input.Position - dragStart
        	gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end

        gui.InputBegan:Connect(function(input)
        	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        		dragging = true
        		dragStart = input.Position
        		startPos = gui.Position
        		
        		input.Changed:Connect(function()
        			if input.UserInputState == Enum.UserInputState.End then
        				dragging = false
        			end
        		end)
        	end
        end)

        gui.InputChanged:Connect(function(input)
        	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        		dragInput = input
        	end
        end)

        userInputService.InputChanged:Connect(function(input)
        	if input == dragInput and dragging then
        		update(input)
        	end
        end)
    end

    local gui = Instance.new('ScreenGui')
    gui.Parent = game.CoreGui
    gui.Name = generateString(20)
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling


    function util:CreateFolderTab(folderName, items)
        local y = 0

        local folder = Instance.new("Frame")
        local titleHolder = Instance.new("Frame")
        local title = Instance.new("TextLabel")
        local uiGradient = Instance.new("UIGradient")
        local background = Instance.new("Frame")
        local holder = Instance.new("Frame")
        local uiListLayout = Instance.new("UIListLayout")
        local button = Instance.new("ImageButton")

        folder.Name = "Folder"
        folder.Parent = gui
        folder.AnchorPoint = Vector2.new(0.5, 0.5)
        folder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        folder.BorderColor3 = Color3.fromRGB(0, 0, 0)
        folder.Position = UDim2.new(0.508000016, 0, 0.20751138, 0)
        folder.Size = UDim2.new(0, 196, 0, 21)
        folder.ZIndex = 5

        titleHolder.Name = "TitleHolder"
        titleHolder.Parent = folder
        titleHolder.AnchorPoint = Vector2.new(0.5, 0.5)
        titleHolder.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
        titleHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
        titleHolder.BorderSizePixel = 0
        titleHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
        titleHolder.Size = UDim2.new(0, 196, 0, 21)
        titleHolder.ZIndex = 4

        title.Name = "Title"
        title.Parent = titleHolder
        title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        title.BackgroundTransparency = 1.000
        title.BorderColor3 = Color3.fromRGB(53, 53, 53)
        title.BorderSizePixel = 0
        title.Size = UDim2.new(0, 195, 0, 21)
        title.Font = Enum.Font.GothamBold
        title.Text = folderName
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextSize = 14.000
        title.TextStrokeTransparency = 0.500
        title.TextWrapped = true

        uiGradient.Parent = titleHolder
        uiGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))}
        uiGradient.Rotation = 90

        background.Name = "Background"
        background.Parent = titleHolder
        background.AnchorPoint = Vector2.new(0.5, 0.5)
        background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        background.BackgroundTransparency = 1.000
        background.BorderColor3 = Color3.fromRGB(0, 0, 0)
        background.Position = UDim2.new(0.5, 0, 8.34000015, 0)
        background.Selectable = true
        background.Size = UDim2.new(0, 194, 0, 306)

        holder.Name = "Holder"
        holder.Parent = background
        holder.AnchorPoint = Vector2.new(0.5, 0.5)
        holder.BackgroundColor3 = Color3.fromRGB(49, 49, 49)
        holder.BorderColor3 = Color3.fromRGB(0, 0, 0)
        holder.Position = UDim2.new(0.5, 0, 0.5, 0)
        holder.Size = UDim2.new(0, 194, 0, 306)

        uiListLayout.Parent = holder
        uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        uiListLayout.Padding = UDim.new(0, -3)

        button.Name = "Button"
        button.Parent = titleHolder
        button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        button.BackgroundTransparency = 1.000
        button.Position = UDim2.new(0.913102031, 0, 0.287999988, 0)
        button.Rotation = 180
        button.Size = UDim2.new(0, 10, 0, 8)
        button.ZIndex = 5
        button.Image = "rbxassetid://6419093692"
        
        for i,v in pairs(items) do
            v.Parent = holder
            y = y + v.AbsolutePosition.Y
        end
        holder.Size = UDim2.new(0, 196, 0, y)

        util:Dragger(folder)

        button.MouseButton1Click:Connect(function()
            if holder.BackgroundTransparency == 0 then
                tweenService:Create(button, TweenInfo.new(0.15), {Rotation = 0}):Play()
                for i,v in pairs(holder:GetDescendants()) do
                    if v.ClassName == 'TextLabel' then
                        tweenService:Create(v, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
                    elseif v.ClassName == 'TextButton' or v.ClassName == 'TextBox' or (v.ClassName == 'Frame' and v.Parent.Name == 'Slider' or v.Parent.Parent.Name == 'Slider') or (v.ClassName == 'Frame' and v.Parent.Name == 'Choice') or (v.ClassName == 'Frame' and v.Name == 'SubFolder') then
                        tweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                    elseif v.ClassName == 'ImageLabel' then
                        tweenService:Create(v, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
                    end
                end
                wait(0.35)
                tweenService:Create(holder, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0, 0), Size = UDim2.new(0,194,0,0)}):Play()
                wait(0.15)	
                holder.BackgroundTransparency = 1
            else
                tweenService:Create(button, TweenInfo.new(0.15), {Rotation = 180}):Play()
                holder.BackgroundTransparency = 0	

                tweenService:Create(holder, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0,194,0,306)}):Play()
                wait(0.2)
                for i,v in pairs(holder:GetDescendants()) do
                    if v.ClassName == 'TextLabel' then
                        tweenService:Create(v, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
                    elseif v.ClassName == 'TextButton' or v.ClassName == 'TextBox' or (v.ClassName == 'Frame' and v.Parent.Name == 'Slider' or v.Parent.Parent.Name == 'Slider') or (v.ClassName == 'Frame' and v.Parent.Name == 'Choice') or (v.ClassName == 'Frame' and v.Name == 'SubFolder') then
                        tweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
                    elseif v.ClassName == 'ImageLabel' then
                        tweenService:Create(v, TweenInfo.new(0.3), {ImageTransparency = 0}):Play()
                    end
                end
            end
        end)
    end

    function util:CreateSubFolder(name, items)
        
    end

    function util:CreateSlider(name, minValue, maxValue, callbackFunc)
        local state = false

        local slider = Instance.new("Frame")
        local sliderName = Instance.new("TextLabel")
        local sliderValue = Instance.new("TextLabel")
        local sliderFill = Instance.new("Frame")
        local uiGradient = Instance.new('UIGradient')
        local sliderBackground = Instance.new("Frame")

        slider.Name = "Slider"
        slider.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        slider.BackgroundTransparency = 1.000
        slider.BorderSizePixel = 0
        slider.Position = UDim2.new(0.0206185561, 0, 0.071895428, 0)
        slider.Size = UDim2.new(0, 186, 0, 48)

        sliderName.Name = "SliderName"
        sliderName.Parent = slider
        sliderName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderName.BackgroundTransparency = 1.000
        sliderName.BorderColor3 = Color3.fromRGB(0, 0, 0)
        sliderName.BorderSizePixel = 0
        sliderName.Position = UDim2.new(0.0199999996, 0, 0.0399999991, 0)
        sliderName.Size = UDim2.new(0, 178, 0, 24)
        sliderName.Font = Enum.Font.Gotham
        sliderName.Text = name
        sliderName.TextColor3 = Color3.fromRGB(255, 255, 255)
        sliderName.TextSize = 14.000
        sliderName.TextStrokeTransparency = 0.500
        sliderName.TextXAlignment = Enum.TextXAlignment.Left

        sliderValue.Name = "SliderValue"
        sliderValue.Parent = slider
        sliderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderValue.BackgroundTransparency = 1.000
        sliderValue.BorderColor3 = Color3.fromRGB(0, 0, 0)
        sliderValue.BorderSizePixel = 0
        sliderValue.Position = UDim2.new(0.0198204294, 0, -0.00545440661, 0)
        sliderValue.Size = UDim2.new(0, 178, 0, 24)
        sliderValue.Font = Enum.Font.Gotham
        sliderValue.Text = maxValue
        sliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
        sliderValue.TextSize = 14.000
        sliderValue.TextStrokeTransparency = 0.500
        sliderValue.TextXAlignment = Enum.TextXAlignment.Right

        uiGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(86, 86, 86)), ColorSequenceKeypoint.new(0.34, Color3.fromRGB(125, 125, 125)), ColorSequenceKeypoint.new(0.68, Color3.fromRGB(163, 163, 163)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))}
        uiGradient.Rotation = -90
        uiGradient.Parent = sliderFill

        sliderBackground.Name = "SliderBackground"
        sliderBackground.Parent = slider
        sliderBackground.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
        sliderBackground.BorderColor3 = Color3.fromRGB(0, 0, 0)
        sliderBackground.Position = UDim2.new(0.0250000004, 0, 0.529999971, 0)
        sliderBackground.Size = UDim2.new(0, 177, 0, 15)

        sliderFill.Name = "SliderFill"
        sliderFill.Parent = sliderBackground
        sliderFill.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
        sliderFill.BorderSizePixel = 0
        sliderFill.Position = UDim2.new(0, 0, 0, 0)
        sliderFill.Size = UDim2.new(0, 177, 0, 15)
        sliderFill.ZIndex = 2


        local connection
        userInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if connection then connection:Disconnect() connection = nil end
            end
        end)

        sliderBackground.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if connection then connection:Disconnect() end

                connection = runService.Heartbeat:Connect(function()
                    local mouse = userInputService:GetMouseLocation()
                    local percent = math.clamp((mouse.X - sliderBackground.AbsolutePosition.X) / (sliderBackground.AbsoluteSize.X), 0, 1)
                    local Value = math.floor(minValue + (maxValue - minValue) * percent)

                    Value = tonumber(string.format("%.2f", Value))

                    sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    sliderValue.Text = tostring(Value)
                    callbackFunc(Value)
                end)
            end
        end)

        return slider
    end

    function util:CreateChoice(dropdownName, dropdownItems, callbackFunc)
        local selected = nil

        local dropdown = util:Create('Frame', {Name = "Dropdown", Parent = holder, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1.000, Position = UDim2.new(0, 0, 0.557971001, 0), Size = UDim2.new(0, 205, 0, 21), ZIndex = 2})
        local dropdownName = util:Create('TextLabel', {Name = "DropdownName", Parent = dropdown, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1.000, BorderColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0, Position = UDim2.new(0.00563875539, 0, 0, 0), Size = UDim2.new(0, 203, 0, 22), Font = Enum.Font.Code, Text = dropdownName, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14.000, TextStrokeTransparency = 0.000, TextXAlignment = Enum.TextXAlignment.Left})
        local dropdownButton = util:Create('TextButton', {Name = 'DropdownButton', Parent = dropdown, BackgroundColor3 = Color3.fromRGB(52, 52, 52), BorderColor3 = Color3.fromRGB(0, 0, 0), Position = UDim2.new(0.381248504, 0, 0.115, 0), Size = UDim2.new(0, 126, 0, 16), Font = Enum.Font.Code, Text = dropdownItems[1], TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14.000, TextStrokeTransparency = 0.000, TextXAlignment = Enum.TextXAlignment.Center})
        local dropdownItemHolder = util:Create('Frame', {
            Name = 'DropdownItemHolder', Parent = dropdownButton, BackgroundColor3 = Color3.fromRGB(43, 43, 43), BorderColor3 = Color3.fromRGB(0, 0, 0), Position = UDim2.new(0.000295971986, 0, 1, 0), Size = UDim2.new(0, 126, 0, 51), Visible = false, ZIndex = 2,
            util:Create('UIListLayout', {Parent = Frame_6, SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 1)})
        })

        for i,v in pairs(dropdownItems) do
            local dropdownItem = util:Create('TextButton', {Name = v, Parent = dropdownItemHolder, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1.000, BorderColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0, Position = UDim2.new(0, 0, 0.0208656453, 0), Size = UDim2.new(0, 126, 0, 15), Font = Enum.Font.Code, Text = v, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14.000, TextStrokeTransparency = 0.000, ZIndex = 2})
        end

        dropdownButton.MouseButton1Click:Connect(function()
            if not dropdownItemHolder.Visible then dropdownItemHolder.Visible = true else dropdownItemHolder.Visible = false end
        end)

        for i,v in pairs(dropdownItemHolder:GetChildren()) do
            if not v:IsA('UIListLayout') then
                v.MouseButton1Click:Connect(function()
                    selected = v.Name
                    dropdownButton.Text = v.Name
                    callbackFunc(selected)

                    dropdownItemHolder.Visible = false
                end)
            end
        end
    end

    function util:CreateToggle(toggleName, canBeBinded, callbackFunc)
        local state = false

        local toggle = util:Create('Frame', {Name = "Toggle", BackgroundColor3 = Color3.fromRGB(18, 18, 18), BackgroundTransparency = 1.000, BorderSizePixel = 0, Position = UDim2.new(0.036842104, 0, 0, 0), Size = UDim2.new(0, 186, 0, 25)})
        local toggleButton = util:Create('TextButton', {Name = "ToggleButton", Parent = toggle, BackgroundColor3 = Color3.fromRGB(255, 0, 4), BorderColor3 = Color3.fromRGB(0, 0, 0), Position = UDim2.new(0.895687044, 0, 0.176363647, 0), Size = UDim2.new(0, 15, 0, 15), Font = Enum.Font.SourceSans, Text = "", TextColor3 = Color3.fromRGB(0, 0, 0), TextSize = 14.000})
        local toggleName = util:Create('TextLabel', {Name = "ToggleName", Parent = toggle, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1.000, BorderColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0, Position = UDim2.new(0.0198204294, 0, -0.00545440661, 0), Size = UDim2.new(0, 178, 0, 24), Font = Enum.Font.Gotham, Text = toggleName, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14.000, TextStrokeTransparency = 0.500, TextXAlignment = Enum.TextXAlignment.Left})
    
        toggleButton.MouseButton1Click:Connect(function()
            if toggleButton.BackgroundColor3 == Color3.fromRGB(36, 36, 36) then toggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255) else toggleButton.BackgroundColor3 = Color3.fromRGB(36, 36, 36) end

            state = not state
            callbackFunc(state)
        end)

        return toggle
    end

    function util:CreateBox(boxName, callbackFunc)

    end

    function util:BindKeyToAction(bindName, bindKey, bindFunction)

    end

    userInputService.InputBegan:Connect(function(input, processed)
        if processed then return; end

        if input.KeyCode == Enum.KeyCode.RightAlt then
            gui.Enabled = not gui.Enabled
        end
    end)
    return util
end

return newLibrary();
