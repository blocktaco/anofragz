function newLibrary()
    local userInputService = game:GetService('UserInputService')
    local runService = game:GetService('RunService')

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
        local folder = util:Create('Frame', {Name = "Folder", Parent = gui, AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderColor3 = Color3.fromRGB(0, 0, 0), Position = UDim2.new(0.515999973, 0, 0.291036427, 0), Size = UDim2.new(0, 196, 0, 21), ZIndex = 1})
        local titleHolder = util:Create('Frame', {Name = "TitleHolder", Parent = folder, AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.fromRGB(36, 36, 36), BorderColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0, Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 196, 0, 21), ZIndex = 1})
        local title = util:Create('TextLabel', {
            Name = "Title", Parent = titleHolder, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1.000, BorderColor3 = Color3.fromRGB(53, 53, 53), BorderSizePixel = 0, Size = UDim2.new(0, 195, 0, 21), Font = Enum.Font.GothamBold, Text = folderName, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14.000, TextStrokeTransparency = 0.500, TextWrapped = true,
            util:Create('UIGradient', {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(200, 200, 200)), ColorSequenceKeypoint.new(0.51, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(200, 200, 200))}, Rotation = -90
            })
        })
        local background = util:Create('Frame', {Name = "Background", Parent = titleHolder, AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 1.000, BorderColor3 = Color3.fromRGB(0, 0, 0), Position = UDim2.new(0.5, 0, 8.34000015, 0), Selectable = true, Size = UDim2.new(0, 194, 0, 306)})
        local holder = util:Create('Frame', {Name = "Holder", Parent = background, AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.fromRGB(49, 49, 49), BorderColor3 = Color3.fromRGB(0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 194, 0, 306)})
    end

    function util:SetFolderTitle(folder, text)
        folder.TitleHolder.Title.Text = text
    end

    function util:CreateSlider(sliderName, minValue, maxValue, callbackFunc)
        local state = false

        local slider = util:Create('Frame', {Name = "Slider", Parent = holder, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1.000, Position = UDim2.new(0, 0, 2.4545455, 0), Size = UDim2.new(0, 205, 0, 45)})
        local sliderName = util:Create('TextLabel', {Name = "SliderName", Parent = slider, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1.000, BorderColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0, Position = UDim2.new(0.00563875539, 0, 0, 0), Size = UDim2.new(0, 203, 0, 22), Font = Enum.Font.Code, Text = sliderName, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14.000, TextStrokeTransparency = 0.000, TextXAlignment = Enum.TextXAlignment.Left})
        local sliderValue = util:Create('TextLabel', {Name = "SliderValue", Parent = slider, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1.000, BorderColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0, Position = UDim2.new(0.00563875539, 0, 0, 0), Size = UDim2.new(0, 203, 0, 22), Font = Enum.Font.Code, Text = maxValue.."%", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14.000, TextStrokeTransparency = 0.000, TextXAlignment = Enum.TextXAlignment.Right})
    
        local backgroundHolder = util:Create('Frame', {Parent = slider, BackgroundColor3 = Color3.fromRGB(52, 52, 52), BorderColor3 = Color3.fromRGB(0, 0, 0), Position = UDim2.new(0.00563875539, 0, 0.627855778, 0), Size = UDim2.new(0, 203, 0, 16)})
        local fill = util:Create('Frame', {Parent = backgroundHolder, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Position = UDim2.new(0,0,0,0), Size = UDim2.new(0, 203, 0, 16)})
    
        local connection
        userInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if connection then connection:Disconnect() connection = nil end
            end
        end)

        backgroundHolder.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if connection then connection:Disconnect() end

                connection = runService.Heartbeat:Connect(function()
                    local mouse = userInputService:GetMouseLocation()
                    local percent = math.clamp((mouse.X - backgroundHolder.AbsolutePosition.X) / (backgroundHolder.AbsoluteSize.X), 0, 1)
                    local Value = math.floor(minValue + (maxValue - minValue) * percent)

                    Value = tonumber(string.format("%.2f", Value))

                    fill.Size = UDim2.new(percent, 0, 1, 0)
                    sliderValue.Text = tostring(Value)
                    callbackFunc(Value)
                end)
            end
        end)
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

        local toggle = util:Create('Frame', {Name = "Toggle", Parent = holder, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1.000, Position = UDim2.new(0.0360360369, 0, 0.0349650383, 0), Size = UDim2.new(0, 205, 0, 22)})
        local toggleButton = util:Create('TextButton', {Name = "ToggleButton", Parent = toggle, BackgroundColor3 = Color3.fromRGB(36, 36, 36), BorderColor3 = Color3.fromRGB(0, 0, 0), Position = UDim2.new(0.00487804879, 0, 0.13636364, 0), Size = UDim2.new(0, 15, 0, 15), Font = Enum.Font.SourceSans, Text = "", TextColor3 = Color3.fromRGB(0, 0, 0), TextSize = 14.000})
        local toggleName = util:Create('TextLabel', {Name = "ToggleName", Parent = toggle, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1.000, BorderColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0, Position = UDim2.new(0.126829267, 0, 0, 0), Size = UDim2.new(0, 179, 0, 22), Font = Enum.Font.Code, Text = toggleName, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14.000, TextStrokeTransparency = 0.000, TextXAlignment = Enum.TextXAlignment.Left})
    
        toggleButton.MouseButton1Click:Connect(function()
            if toggleButton.BackgroundColor3 == Color3.fromRGB(36, 36, 36) then toggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255) else toggleButton.BackgroundColor3 = Color3.fromRGB(36, 36, 36) end

            state = not state
            callbackFunc(state)
        end)
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
