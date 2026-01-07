-- ESP.lua complet R6 avec hitbox fixe écran
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESPObjects = {}

-- Config globale
if not _G.ESP_CONFIG then
    _G.ESP_CONFIG = {
        Color = Color3.fromRGB(255,0,0), -- couleur par défaut
        SelectedPlayers = {} -- UserId -> true/false
    }
end

-- Hitbox fixe en pixels
local HITBOX_WIDTH = 50
local HITBOX_HEIGHT = 100
local HITBOX_OFFSET_Y = 3 -- hauteur au-dessus de la Head

-- Création ESP pour un joueur
local function createESP(player)
    if ESPObjects[player] then return end
    if not player.Character or not player.Character:FindFirstChild("Head") then return end

    local head = player.Character:FindFirstChild("Head")

    -- BillboardGui fixe sur l'écran
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0,HITBOX_WIDTH,0,HITBOX_HEIGHT)
    billboard.StudsOffset = Vector3.new(0,HITBOX_OFFSET_Y,0)
    billboard.AlwaysOnTop = true
    billboard.Parent = game.CoreGui

    -- Hitbox rectangle
    local hitbox = Instance.new("Frame")
    hitbox.Size = UDim2.new(1,0,1,0)
    hitbox.Position = UDim2.new(0,0,0,0)
    hitbox.BackgroundTransparency = 0.7
    hitbox.BorderSizePixel = 2
    hitbox.BorderColor3 = _G.ESP_CONFIG.Color
    hitbox.BackgroundColor3 = Color3.fromRGB(0,0,0)
    hitbox.Parent = billboard

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
    healthBarBG.Size = UDim2.new(1,0,0,5)
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

    ESPObjects[player] = {
        Billboard = billboard,
        NameLabel = nameLabel,
        DistLabel = distLabel,
        HealthBar = healthBar,
        Hitbox = hitbox
    }
end

-- Mise à jour en temps réel
local function updateESP()
    for player, data in pairs(ESPObjects) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local hrp = player.Character.HumanoidRootPart
            local enabled = _G.ESP_CONFIG.SelectedPlayers[player.UserId] == true
            data.Billboard.Enabled = enabled
            if enabled then
                -- Distance
                local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                data.DistLabel.Text = dist.." studs"
                -- Couleur
                data.NameLabel.TextColor3 = _G.ESP_CONFIG.Color
                data.DistLabel.TextColor3 = _G.ESP_CONFIG.Color
                data.Hitbox.BorderColor3 = _G.ESP_CONFIG.Color
                -- Barre de vie
                local healthRatio = humanoid.Health / humanoid.MaxHealth
                data.HealthBar.Size = UDim2.new(healthRatio,0,1,0)
                if healthRatio > 0.5 then
                    data.HealthBar.BackgroundColor3 = Color3.fromRGB(0,255,0)
                elseif healthRatio > 0.2 then
                    data.HealthBar.BackgroundColor3 = Color3.fromRGB(255,255,0)
                else
                    data.HealthBar.BackgroundColor3 = Color3.fromRGB(255,0,0)
                end
            end
        else
            data.Billboard.Enabled = false
        end
    end
end

-- Ajout des joueurs
local function setupPlayer(player)
    player.CharacterAdded:Connect(function()
        wait(0.1)
        createESP(player)
    end)
    if player.Character then
        createESP(player)
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then setupPlayer(player) end
end
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then setupPlayer(player) end
end)
Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        ESPObjects[player].Billboard:Destroy()
        ESPObjects[player] = nil
    end
end)

RunService.RenderStepped:Connect(updateESP)
