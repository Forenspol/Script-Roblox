-- ESP.lua

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Drawing = Drawing -- en général accessible dans les scripts d’injection, sinon utiliser la lib compatible

local espObjects = {}

-- Nettoyer les drawings précédents
local function clearESP()
	for _, obj in pairs(espObjects) do
		for _, drawing in pairs(obj) do
			if drawing and drawing.Remove then
				drawing:Remove()
			end
		end
	end
	espObjects = {}
end

local function createESPForPlayer(player)
	local esp = {}

	esp.box = Drawing.new("Square")
	esp.box.Color = _G.ESP_CONFIG.Color
	esp.box.Thickness = 1.5
	esp.box.Transparency = 1
	esp.box.Filled = false

	esp.name = Drawing.new("Text")
	esp.name.Center = true
	esp.name.Outline = true
	esp.name.Color = _G.ESP_CONFIG.Color
	esp.name.Size = 16
	esp.name.Font = 2

	esp.healthBack = Drawing.new("Square")
	esp.healthBack.Color = Color3.fromRGB(0,0,0)
	esp.healthBack.Filled = true
	esp.healthBack.Transparency = 0.5

	esp.healthBar = Drawing.new("Square")
	esp.healthBar.Color = _G.ESP_CONFIG.Color
	esp.healthBar.Filled = true

	esp.distanceText = Drawing.new("Text")
	esp.distanceText.Center = true
	esp.distanceText.Outline = true
	esp.distanceText.Color = Color3.new(1,1,1)
	esp.distanceText.Size = 14
	esp.distanceText.Font = 2

	return esp
end

local function updateESP()
	local cameraCFrame = Camera.CFrame
	local cameraPos = cameraCFrame.Position

	for i, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
			if _G.ESP_CONFIG.SelectedPlayers[player.UserId] then
				if not espObjects[player] then
					espObjects[player] = createESPForPlayer(player)
				end

				local esp = espObjects[player]
				local rootPart = player.Character.HumanoidRootPart
				local humanoid = player.Character.Humanoid

				local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
				if onScreen then
					local size = Vector3.new(2, 5, 1) -- approx box size
					local scale = 1 / pos.Z * 50
					local boxSize = Vector2.new(100 * scale, 150 * scale)

					-- Position du box
					esp.box.Position = Vector2.new(pos.X - boxSize.X/2, pos.Y - boxSize.Y/2)
					esp.box.Size = boxSize
					esp.box.Color = _G.ESP_CONFIG.Color
					esp.box.Visible = true

					-- Nom joueur + distance
					local distance = (cameraPos - rootPart.Position).Magnitude
					esp.name.Position = Vector2.new(pos.X, pos.Y - boxSize.Y/2 - 20)
					esp.name.Text = player.Name
					esp.name.Color = _G.ESP_CONFIG.Color
					esp.name.Visible = true

					esp.distanceText.Position = Vector2.new(pos.X, pos.Y - boxSize.Y/2 - 5)
					esp.distanceText.Text = string.format("%.0f m", distance)
					esp.distanceText.Visible = true

					-- Barre de vie (petite hauteur)
					local healthPercent = humanoid.Health / humanoid.MaxHealth
					healthPercent = math.clamp(healthPercent, 0, 1)

					local barWidth = boxSize.X
					local barHeight = 5 -- plus petite barre de vie
					local barPosX = pos.X - barWidth/2
					local barPosY = pos.Y + boxSize.Y/2 + 5

					esp.healthBack.Position = Vector2.new(barPosX,
