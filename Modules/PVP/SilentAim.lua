-- SilentAim.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Config globale
if not _G.SILENT_AIM_CONFIG then
    _G.SILENT_AIM_CONFIG = {
        Enabled = true,
        TargetPart = "Head", -- "Head" ou "Torso"
        SelectedPlayers = {} -- UserId -> true/false
    }
end

-- Fonction pour trouver le meilleur joueur
local function getClosestTarget()
    local closestDist = math.huge
    local closestPlayer = nil
    local localPos = workspace.CurrentCamera.CFrame.Position

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and _G.SILENT_AIM_CONFIG.SelectedPlayers[player.UserId] then
            if player.Character and player.Character:FindFirstChild(_G.SILENT_AIM_CONFIG.TargetPart) then
                local part = player.Character[_G.SILENT_AIM_CONFIG.TargetPart]
                local dist = (part.Position - localPos).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

-- Hook du tir
RunService.RenderStepped:Connect(function()
    if not _G.SILENT_AIM_CONFIG.Enabled then return end
    local target = getClosestTarget()
    if target and target.Character and target.Character:FindFirstChild(_G.SILENT_AIM_CONFIG.TargetPart) then
        local targetPos = target.Character[_G.SILENT_AIM_CONFIG.TargetPart].Position
        -- On force le mouse position vers le target
        local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(targetPos)
        if onScreen then
            -- Ici tu peux utiliser un événement qui tire, par exemple:
            -- game:GetService("ReplicatedStorage").ShootEvent:FireServer(screenPos.Position)
            -- OU juste déplacer le Mouse
            pcall(function()
                Mouse.X = screenPos.X
                Mouse.Y = screenPos.Y
            end)
        end
    end
end)
