-- SilentAim.lua

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local SilentAimEnabled = true
local FOV = 250 -- rayon de détection en pixels
local TargetPart = "Head" -- ou "HumanoidRootPart"

-- UI cercle FOV (optionnel)
local circle = Drawing.new("Circle")
circle.Color = Color3.fromRGB(255,255,255)
circle.Thickness = 1
circle.NumSides = 64
circle.Radius = FOV
circle.Filled = false
circle.Visible = true
circle.Transparency = 1

-- Trouver la cible la plus proche du curseur
local function getClosestPlayer()
	local closest = nil
	local shortest = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(TargetPart) then
			local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.Health > 0 then
				local pos, onScreen = Camera:WorldToViewportPoint(player.Character[TargetPart].Position)
				if onScreen then
					local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
					if dist < shortest and dist < FOV then
						shortest = dist
						closest = player
					end
				end
			end
		end
	end

	return closest
end

-- Hook du Raycast / Mouse.Hit
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
	local args = {...}
	local method = getnamecallmethod()

	if SilentAimEnabled and method == "Raycast" then
		local target = getClosestPlayer()
		if target and target.Character and target.Character:FindFirstChild(TargetPart) then
			args[2] = (target.Character[TargetPart].Position - args[1]).Unit * 1000
			return old(self, unpack(args))
		end
	end

	return old(self, ...)
end)

setreadonly(mt, true)

-- Update cercle FOV
game:GetService("RunService").RenderStepped:Connect(function()
	circle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
end)

print("✅ Silent Aim activé")
