-- ESP.lua
-- ESP complet + Menu de configuration

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Éviter double chargement
if _G.ESP_LOADED then return end
_G.ESP_LOADED = true

-- ===== CONFIG =====
local Config = {
	Enabled = true,
	ShowBox = true,
	ShowName = true,
	Color = Color3.fromRGB(255, 0, 0)
}

-- ===== STOCKAGE =====
local ESPObjects = {}

-- ===== GUI CONFIG =====
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ESPConfigGui"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 260)
Frame.Position = UDim2.new(0.5, -150, 0.5, -130)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Visible = false
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "ESP CONFIG"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22

-- Bouton fermer
local CloseBtn = Instance.new("TextButton", Frame)
CloseBtn.Size = UDim2.new(0,30,0,30)
CloseBtn.Position = UDim2.new(1,-35,0,5)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
CloseBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", CloseBtn)

CloseBtn.MouseButton1Click:Connect(function()
	Frame.Visible = false
end)

-- ===== FONCTION UI =====
local function createToggle(text, posY, callback)
	local btn = Instance.new("TextButton", Frame)
	btn.Size = UDim2.new(0.8,0,0,36)
	btn.Position = UDim2.new(0.1,0,0,posY)
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	Instance.new("UICorner", btn)

	local state = true
	local function refresh()
		btn.Text = text .. " : " .. (state and "ON" or "OFF")
	end
	refresh()

	btn.MouseButton1Click:Connect(function()
		state = not state
		refresh()
		callback(state)
	end)

	return btn
end

-- Toggles
createToggle("Box", 50, function(v) Config.ShowBox = v end)
createToggle("Name", 95, function(v) Config.ShowName = v end)

-- ===== COLOR PICKER SIMPLE =====
local ColorLabel = Instance.new("TextLabel", Frame)
ColorLabel.Size = UDim2.new(1,0,0,30)
ColorLabel.Position = UDim2.new(0,0,0,140)
ColorLabel.Text = "Couleur ESP"
ColorLabel.TextColor3 = Color3.new(1,1,1)
ColorLabel.BackgroundTransparency = 1
ColorLabel.Font = Enum.Font.GothamBold
ColorLabel.TextSize = 18

local colors = {
	Color3.fromRGB(255,0,0),
	Color3.fromRGB(0,255,0),
	Color3.fromRGB(0,0,255),
	Color3.fromRGB(255,255,0),
	Color3.fromRGB(255,0,255),
	Color3.fromRGB(0,255,255),
	Color3.fromRGB(255,255,255)
}

for i, col in ipairs(colors) do
	local btn = Instance.new("TextButton", Frame)
	btn.Size = UDim2.new(0,30,0,30)
	btn.Position = UDim2.new(0, 20 + (i-1)*35, 0, 180)
	btn.BackgroundColor3 = col
	btn.Text = ""
	Instance.new("UICorner", btn)

	btn.MouseButton1Click:Connect(function()
		Config.Color = col
	end)
end

-- ===== CLEAR =====
local ClearBtn = Instance.new("TextButton", Frame)
ClearBtn.Size = UDim2.new(0.8,0,0,36)
ClearBtn.Position = UDim2.new(0.1,0,1,-45)
ClearBtn.Text = "CLEAR ESP"
ClearBtn.Font = Enum.Font.GothamBold
ClearBtn.TextSize = 16
ClearBtn.BackgroundColor3 = Color3.fromRGB(120,50,50)
ClearBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", ClearBtn)

-- ===== OUVERTURE DEPUIS MENU PRINCIPAL =====
_G.OpenESPConfig = function()
	Frame.Visible = not Frame.Visible
end

-- ===== ESP LOGIQUE =====
local function createESP(player)
	if player == LocalPlayer then return end

	local function onCharacter(char)
		if ESPObjects[player] then
			ESPObjects[player]:Destroy()
			ESPObjects[player] = nil
		end

		local box = Instance.new("BoxHandleAdornment")
		box.Size = Vector3.new(4,6,2)
		box.AlwaysOnTop = true
		box.ZIndex = 5
		box.Transparency = 0.5
		box.Color3 = Config.Color
		box.Adornee = char:WaitForChild("HumanoidRootPart")
		box.Parent = char

		local billboard = Instance.new("BillboardGui")
		billboard.Size = UDim2.new(0,200,0,50)
		billboard.StudsOffset = Vector3.new(0,3,0)
		billboard.AlwaysOnTop = true
		billboard.Adornee = char:WaitForChild("Head")
		billboard.Parent = char

		local nameLabel = Instance.new("TextLabel", billboard)
		nameLabel.Size = UDim2.new(1,0,1,0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = player.Name
		nameLabel.TextColor3 = Config.Color
		nameLabel.Font = Enum.Font.GothamBold
		nameLabel.TextSize = 14

		ESPObjects[player] = {
			Box = box,
			Billboard = billboard
		}
	end

	if player.Character then
		onCharacter(player.Character)
	end
	player.CharacterAdded:Connect(onCharacter)
end

-- Appliquer aux joueurs
for _, p in ipairs(Players:GetPlayers()) do
	createESP(p)
end

Players.PlayerAdded:Connect(createESP)

-- ===== UPDATE LOOP =====
RunService.RenderStepped:Connect(function()
	for player, objs in pairs(ESPObjects) do
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			local hum = player.Character.Humanoid
			if hum.Health <= 0 then
				if objs.Box then objs.Box.Visible = false end
				if objs.Billboard then objs.Billboard.Enabled = false end
			else
				if objs.Box then
					objs.Box.Visible = Config.ShowBox
					objs.Box.Color3 = Config.Color
				end
				if objs.Billboard then
					objs.Billboard.Enabled = Config.ShowName
					if objs.Billboard:FindFirstChildOfClass("TextLabel") then
						objs.Billboard.TextLabel.TextColor3 = Config.Color
					end
				end
			end
		end
	end
end)

-- ===== CLEAR =====
ClearBtn.MouseButton1Click:Connect(function()
	for _, objs in pairs(ESPObjects) do
		if objs.Box then objs.Box:Destroy() end
		if objs.Billboard then objs.Billboard:Destroy() end
	end
	table.clear(ESPObjects)
end)

print("✅ ESP chargé avec menu config")
