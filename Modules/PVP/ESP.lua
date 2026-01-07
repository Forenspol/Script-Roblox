-- ESP.lua optimisé
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Table pour stocker les ESP existants
local ESPObjects = {}

-- Fonction pour créer l'ESP pour un joueur
local function createESP(player)
    if ESPObjects[player] then return ESPObjects[player] end
    if not player.Character or not player.Character:FindFirstChild("Head") then return end

    local head = player.Character:FindFirstChild("Head")

    -- BillboardGui parenté à CoreGui
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0,120,0,50)
    billboard.StudsOffset = Vector3.new(0,2,0)
    billboard.AlwaysOnTop = true
    billboard.Parent = game.CoreGui

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
    healthBarBG.Size = UDim2.new(1,0,0,5) -- 5 px
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
        HealthBar = healthBar
    }
end

-- Mettre à jour la visibilité et les infos de tous les ESP
local function updateESP()
    for player, data in pairs(ESPObjects) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local hrp = player.Character.HumanoidRootPart
            -- Affichage selon sélection
            local enabled = _G.ESP_CONFIG.SelectedPlayers[player.UserId] == true
            data.Billboard.Enabled = enabled
            if enabled then
                -- Distance
                local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                data.DistLabel.Text = dist.." studs"
                -- Couleur
                data.NameLabel.TextColor3 = _G.ESP_CONFIG.Color
                data.DistLabel.TextColor3 = _G.ESP_CONFIG.Color
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

-- Ajouter un joueur à l'ESP quand il apparaît
local function setupPlayer(player)
    player.CharacterAdded:Connect(function()
        wait(0.1) -- petit délai pour que la Head existe
        createESP(player)
    end)
    if player.Character then
        createESP(player)
    end
end

-- Connexion des joueurs existants et nouveaux
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        setupPlayer(player)
    end
end
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        setupPlayer(player)
    end
end)
Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        ESPObjects[player].Billboard:Destroy()
        ESPObjects[player] = nil
    end
end)

-- Boucle principale pour mise à jour
RunService.RenderStepped:Connect(updateESP)
