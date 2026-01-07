-- ESP.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ESPObjects = {}

local function createESP(player)
    if ESPObjects[player] then return ESPObjects[player] end
    if not player.Character or not player.Character:FindFirstChild("Head") then return end

    local head = player.Character:FindFirstChild("Head")

    -- BillboardGui parenté à CoreGui pour que le client le voie
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0,120,0,50)
    billboard.StudsOffset = Vector3.new(0,2,0)
    billboard.AlwaysOnTop = true
    billboard.Parent = game.CoreGui -- important

    -- Pseudo
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,0,20)
    nameLabel.Position = UDim2.new(0,0,0,0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = _G.ESP_CONFIG.Color
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Parent = billboard

    -- Distance
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1,0,0,15)
    distLabel.Position = UDim2.new(0,0,0,20)
    distLabel.BackgroundTransparency = 1
    distLabel.TextColor3 = _G.ESP_CONFIG.Color
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextSize = 12
    distLabel.TextStrokeTransparency = 0.5
    distLabel.Text = ""
    distLabel.Parent = billboard

    -- Barre de vie
    local healthBarBG = Instance.new("Frame")
    healthBarBG.Size = UDim2.new(1,0,0,5) -- 5 px de haut
    healthBarBG.Position = UDim2.new(0,0,1,-5)
    healthBarBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
    healthBarBG.BorderSizePixel = 0
    healthBarBG.Parent = billboard

    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(1,0,1,0)
    healthBar.Position = UDim2.new(0,0,0,0)
    healthBar.BackgroundColor3 = Color3.fromRGB(0,255,0)
    healthBar.BorderSizePixel = 0
    healthBar.Parent = healthBarBG

    ESPObjects[player] = {Billboard=billboard, NameLabel=nameLabel, DistLabel=distLabel, HealthBar=healthBar}

    RunService.RenderStepped:Connect(function()
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            billboard.Enabled = false
            return
        end
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health > 0 then
            billboard.Enabled = _G.ESP_CONFIG.SelectedPlayers[player.UserId] == true
            -- Distance
            local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
            distLabel.Text = dist.." studs"
            -- Couleur
            nameLabel.TextColor3 = _G.ESP_CONFIG.Color
            distLabel.TextColor3 = _G.ESP_CONFIG.Color
            -- Barre de vie
            healthBar.Size = UDim2.new(humanoid.Health/humanoid.MaxHealth,0,1,0)
            if humanoid.Health/humanoid.MaxHealth > 0.5 then
                healthBar.BackgroundColor3 = Color3.fromRGB(0,255,0)
            elseif humanoid.Health/humanoid.MaxHealth > 0.2 then
                healthBar.BackgroundColor3 = Color3.fromRGB(255,255,0)
            else
                healthBar.BackgroundColor3 = Color3.fromRGB(255,0,0)
            end
        else
            billboard.Enabled = false
        end
    end)

    return ESPObjects[player]
end

local function refreshESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if _G.ESP_CONFIG.SelectedPlayers[player.UserId] then
                createESP(player)
            elseif ESPObjects[player] then
                ESPObjects[player].Billboard.Enabled = false
            end
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(refreshESP)
end)
Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        ESPObjects[player].Billboard:Destroy()
        ESPObjects[player] = nil
    end
end)

-- Boucle principale
RunService.RenderStepped:Connect(refreshESP)
