repeat wait() until game:IsLoaded() == true -- // Prevents any indexing errors //

-- // Main variables //

local replicatedStorage = game:GetService('ReplicatedStorage')
local runService = game:GetService('RunService')
local userInputService = game:GetService('UserInputService')

local player = game.Players.LocalPlayer

local util = loadstring(game:HttpGet('https://pastebin.com/raw/vn7T2wnp'))()

local toggles = {
    silentAim = false;
    hitChance = 100;
    hitbox = 'Head';

    drawFov = false;
    fovSize = 100;
    numSides = 100;
    
    visibleCheck = false;
}

local fovCircle = Drawing.new("Circle")

fovCircle.Transparency = 1
fovCircle.Visible = false
fovCircle.NumSides = 100
fovCircle.Radius = toggles.fovSize
fovCircle.Thickness = 1.5
fovCircle.Color = Color3.new(1, 1, 1)

-- // Main functions //

function getMouseClosest()
    local nearest, distance = nil, math.huge

    for i, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild('CharacterMesh') and player.TeamColor ~= v.TeamColor then
            local pos, bounds = workspace.Camera:WorldToViewportPoint(v.Character.CharacterMesh.Position)

            if bounds then
                local mouse = userInputService:GetMouseLocation()
                local magnitude = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude

                if magnitude < distance then
                    if magnitude < toggles.fovSize then
                        if toggles.visibleCheck then
                            if checkIfVisible(v) then
                                nearest = v
                                distance = magnitude
                            end 
                        else
                            nearest = v
                            distance = magnitude
                        end
                    end
                end
            end
        end
    end 
    return nearest
end

local mt = getrawmetatable(game)
setreadonly(mt, false)
local namecall = mt.__namecall

mt.__namecall = function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if tostring(method) == 'FireServer' then
        if toggles.silentAim and tostring(self) == "projectiles" then
            if args[1] == 2 and math.random(1, 100) <= toggles.hitChance then
                if not getMouseClosest() then return; end

                if toggles.hitbox == 'Head' then
                    args[2] = 'Rocket'
                    args[3] = toggles.hitbox
                    args[4] = Enum.Material.Plastic
                    args[5] = getMouseClosest().Character
                end
                
                return self.FireServer(self, unpack(args))
            end
        end
    end
    return namecall(self, ...)
end

setreadonly(mt, true)

-- // UI Framework //

util:AddToQueue({
    util:CreateFolderTab({'cope.moment'}, {
        util:CreateSectionTitle('Silent Aim');
        util:CreateSpacer(5);
        util:CreateToggle('Enabled', false, function(state)
            toggles.silentAim = state
        end);
        util:CreateSpacer(10);
        util:CreateSectionTitle('Properties');
        util:CreateSpacer(5);
        util:CreateSlider('Hit Chance', 1, 100, function(value)
            toggles.hitChance = value
        end);
        util:CreateSpacer(5);
        util:CreateSpacer(10);
        util:CreateSectionTitle('Render');
        util:CreateSpacer(5);
        util:CreateToggle('Draw FOV', false, function(state)
            toggles.drawFov = state
        end);
        util:CreateSpacer(5);
        util:CreateSlider('FOV Size', 50, 400, function(value)
            toggles.fovSize = value
        end);
        util:CreateSlider('Num Sides', 4, 100, function(value)
            toggles.numSides = value
        end);
    });      
});

-- // Other //

runService.RenderStepped:Connect(function()
    local mouse = userInputService:GetMouseLocation()

    fovCircle.Position = Vector2.new(mouse.X, mouse.Y)

    fovCircle.Visible = toggles.drawFov
    fovCircle.Radius = toggles.fovSize
    fovCircle.NumSides = toggles.numSides
end)
