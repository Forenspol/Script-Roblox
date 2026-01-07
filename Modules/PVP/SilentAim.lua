-- SilentAim.lua avec config
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Config globale
if not _G.SILENT_AIM_CONFIG then
    _G.SILENT_AIM_CONFIG = {
        Enabled = true,
        TargetPart = "Head", -- "Head" ou "Torso"
        SelectedPlayers = {}, -- UserId -> true/false
        AimCircleSize = 50,   -- rayon en pixels du cercle
        AimStrength = 0.3     -- vitesse d’aiming (0-1)
    }
end

-- Cercle visible autour du curseur (optionnel)
local AimCircle = Instance.new("Frame")
AimCircle.Size = UDim2.new(0,_G.SILENT_AIM_CONFIG.AimCircleSize*2,0,_G.SILENT_AIM_CONFIG.AimCircleSize*2)
AimCircle.Position = UDim2.new(0, Mouse.X - _G.SILENT_AIM_CONFIG.AimCircleSize, 0, Mouse.Y - _G.SILENT_AIM_CONFIG.AimCircleSize)
AimCircle.AnchorPoint = Vector2.new(0,0)
AimCircle.BackgroundTransparency = 0.7
AimCircle.BorderColor3 = Color3.fromRGB(255,0,0)
AimCircle.BackgroundColor3 = Color3.fromRGB(50,50,50)
AimCircle.Rotation = 0
AimCircle.Visible = _G.SILENT_AIM_CONFIG.Enabled
AimCircle.Parent = game.CoreGui

-- Fonction pour trouver le meilleur joueur dans le cercle
local function getClosestTarget()
    local closestDist = math.huge
    local closestPlayer = nil
    local localPos = workspace.CurrentCamera.CFrame.Position

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and _G.SILENT_AIM_CONFIG.SelectedPlayers[player.UserId] then
            if player.Character and player.Character:FindFirstChild(_G.SILENT_AIM_CONFIG.TargetPart) then
                local part = player.Character[_G.SILENT_AIM_CONFIG.TargetPart]
                local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local mouseDist = math.sqrt((screenPos.X - Mouse.X)^2 + (screenPos.Y - Mouse.Y)^2)
                    if mouseDist <= _G.SILENT_AIM_CONFIG.AimCircleSize and mouseDist < closestDist then
                        closestDist = mouseDist
                        closestPlayer = player
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- Mise à jour de l’AimCircle
RunService.RenderStepped:Connect(function()
    AimCircle.Position = UDim2.new(0, Mouse.X - _G.SILENT_AIM_CONFIG.AimCircleSize, 0, Mouse.Y - _G.SILENT_AIM_CONFIG.AimCircleSize)
    AimCircle.Size = UDim2.new(0,_G.SILENT_AIM_CONFIG.AimCircleSize*2,0,_G.SILENT_AIM_CONFIG.AimCircleSize*2)
    AimCircle.Visible = _G.SILENT_AIM_CONFIG.Enabled
end)

-- Hook du tir avec force d’aim
RunService.RenderStepped:Connect(function()
    if not _G.SILENT_AIM_CONFIG.Enabled then return end
    local target = getClosestTarget()
    if target and target.Character and target.Character:FindFirstChild(_G.SILENT_AIM_CONFIG.TargetPart) then
        local targetPos = target.Character[_G.SILENT_AIM_CONFIG.TargetPart].Position
        local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(targetPos)
        if onScreen then
            -- Déplacement du mouse vers le target avec force
            local dx = screenPos.X - Mouse.X
            local dy = screenPos.Y - Mouse.Y
            Mouse.X = Mouse.X + dx * _G.SILENT_AIM_CONFIG.AimStrength
            Mouse.Y = Mouse.Y + dy * _G.SILENT_AIM_CONFIG.AimStrength
        end
    end
end)
