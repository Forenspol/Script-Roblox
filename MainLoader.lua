-- MainLoader.lua
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ===== CONFIG =====
local Modules = {
	ESP = false,
	SilentAim = false
}

_G.ESP_CONFIG = {
	Color = Color3.fromRGB(255, 0, 0),
	SelectedPlayers = {}
}

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LoucraftMenu"
ScreenGui.Parent = game.CoreGui

-- ===== Fonction bouton =====
local function createButton(parent, text, posY)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(0.85, 0, 0, 45)
	btn.Position = UDim2.new(0.075, 0, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.AutoButtonColor = true
	Instance.new("UICorner", btn)
	return btn
end

-- ===== Frame principal =====
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 420)
MainFrame.Position = UDim2.new(0, 50, 0, 120)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

-- Titre
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1,0,0,50)
Title.BackgroundTransparency = 1
Title.Text = "MENU PRINCIPAL"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24

-- Boutons catégories
local btnPVP = createButton(MainFrame, "PVP  →", 80)
local btnFarm = createButton(MainFrame, "Farm  →", 140)

-- ===== Frame PVP =====
local PVPFrame = Instance.new("Frame", ScreenGui)
PVPFrame.Size = MainFrame.Size
PVPFrame.Position = MainFrame.Position
PVPFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
PVPFrame.Visible = false
PVPFrame.Active = true
PVPFrame.Draggable = true
Instance.new("UICorner", PVPFrame)

-- Titre PVP
local PVPTitle = Instance.new("TextLabel", PVPFrame)
PVPTitle.Size = UDim2.new(1,0,0,50)
PVPTitle.BackgroundTransparency = 1
PVPTitle.Text = "MENU PVP"
PVPTitle.TextColor3 = Color3.new(1,1,1)
PVPTitle.Font = Enum.Font.GothamBold
PVPTitle.TextSize = 24

-- Bouton back
local BackBtn = Instance.new("TextButton", PVPFrame)
BackBtn.Size = UDim2.new(0,60,0,35)
BackBtn.Position = UDim2.new(0,10,0,8)
BackBtn.Text = "←"
BackBtn.Font = Enum.Font.GothamBold
BackBtn.TextSize = 22
BackBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
BackBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", BackBtn)

-- ===== Bouton ESP =====
local btnESP = createButton(PVPFrame, "ESP : OFF", 80)

-- Bouton config ESP (pour afficher la config)
local btnESPConfig = Instance.new("TextButton", PVPFrame)
btnESPConfig.Size = UDim2.new(0,45,0,45)
btnESPConfig.Position = UDim2.new(1,-55,0,80)
btnESPConfig.Text = "⚙"
btnESPConfig.Font = Enum.Font.GothamBold
btnESPConfig.TextSize = 22
btnESPConfig.BackgroundColor3 = Color3.fromRGB(60,60,60)
btnESPConfig.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btnESPConfig)

-- ===== Bouton Silent Aim =====
local btnSilent = createButton(PVPFrame, "Silent Aim : OFF", 140)

local btnSilentConfig = btnESPConfig:Clone()
btnSilentConfig.Parent = PVPFrame
btnSilentConfig.Position = UDim2.new(1,-55,0,140)

-- ===== NAVIGATION =====
btnPVP.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	PVPFrame.Visible = true
end)

BackBtn.MouseButton1Click:Connect(function()
	PVPFrame.Visible = false
	MainFrame.Visible = true
end)

-- ===== ESP CONFIGURATION FRAME =====
local ESPFrame = Instance.new("Frame", PVPFrame)
ESPFrame.Size = UDim2.new(0, 360, 0, 200)
ESPFrame.Position = UDim2.new(0, 10, 0, 140)
ESPFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ESPFrame.Visible = false
Instance.new("UICorner", ESPFrame)

-- Titre config ESP
local ESPTitle = Instance.new("TextLabel", ESPFrame)
ESPTitle.Size = UDim2.new(1,0,0,30)
ESPTitle.BackgroundTransparency = 1
ESPTitle.Text = "Configuration ESP"
ESPTitle.TextColor3 = Color3.new(1,1,1)
ESPTitle.Font = Enum.Font.GothamBold
ESPTitle.TextSize = 20

-- Bouton fermeture config
local CloseConfigBtn = Instance.new("TextButton", ESPFrame)
CloseConfigBtn.Size = UDim2.new(0, 30, 0, 30)
CloseConfigBtn.Position = UDim2.new(1, -35, 0, 0)
CloseConfigBtn.Text = "✕"
CloseConfigBtn.Font = Enum.Font.GothamBold
CloseConfigBtn.TextSize = 18
CloseConfigBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
CloseConfigBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", CloseConfigBtn)

CloseConfigBtn.MouseButton1Click:Connect(function()
	ESPFrame.Visible = false
end)

-- Liste des couleurs fixes
local colors = {
	{ Name = "Rouge", Color = Color3.fromRGB(255, 0, 0) },
	{ Name = "Jaune", Color = Color3.fromRGB(255, 255, 0) },
	{ Name = "Vert", Color = Color3.fromRGB(0, 255, 0) },
	{ Name = "Bleu", Color = Color3.fromRGB(0, 0, 255) },
	{ Name = "Blanc", Color = Color3.fromRGB(255, 255, 255) },
	{ Name = "Noir", Color = Color3.fromRGB(0, 0, 0) },
	{ Name = "Violet", Color = Color3.fromRGB(128, 0, 128) },
	{ Name = "Rose", Color = Color3.fromRGB(255, 192, 203) },
	{ Name = "Bleu Cyan", Color = Color3.fromRGB(0, 255, 255) },
}

local spacing = 10
local squareSize = 30
local startX = 10
local startY = 40

for i, c in ipairs(colors) do
	local colorSquare = Instance.new("Frame", ESPFrame)
	colorSquare.Size = UDim2.new(0, squareSize, 0, squareSize)
	colorSquare.Position = UDim2.new(0, startX + (squareSize + spacing) * (i-1), 0, startY)
	colorSquare.BackgroundColor3 = c.Color
	colorSquare.BorderSizePixel = 1
	colorSquare.BorderColor3 = Color3.new(1,1,1)
	colorSquare.Active = true
	colorSquare.Selectable = true

	-- Clickable overlay (transparent button)
	local clickArea = Instance.new("TextButton", colorSquare)
	clickArea.Size = UDim2.new(1,0,1,0)
	clickArea.BackgroundTransparency = 1
	clickArea.Text = ""
	clickArea.AutoButtonColor = false
	clickArea.MouseButton1Click:Connect(function()
		_G.ESP_CONFIG.Color = c.Color
		ColorPreview.BackgroundColor3 = c.Color
	end)
end

-- Preview couleur sélectionnée
local ColorPreview = Instance.new("Frame", ESPFrame)
ColorPreview.Size = UDim2.new(0, 50, 0, 30)
ColorPreview.Position = UDim2.new(1, -60, 0, 40)
ColorPreview.BackgroundColor3 = _G.ESP_CONFIG.Color
Instance.new("UICorner", ColorPreview)

-- ===== LISTE JOUEURS =====
local PlayerListFrame = Instance.new("ScrollingFrame", ESPFrame)
PlayerListFrame.Size = UDim2.new(1, -20, 0, 80)
PlayerListFrame.Position = UDim2.new(0, 10, 0, 80)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", PlayerListFrame)

local UIListLayout = Instance.new("UIListLayout", PlayerListFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

local function refreshPlayerList()
	for _, child in ipairs(PlayerListFrame:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	for i, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local playerFrame = Instance.new("Frame", PlayerListFrame)
			playerFrame.Size = UDim2.new(1, 0, 0, 25)
			playerFrame.BackgroundTransparency = 1

			local checkBox = Instance.new("TextButton", playerFrame)
			checkBox.Size = UDim2.new(0, 20, 0, 20)
			checkBox.Position = UDim2.new(0, 0, 0, 2)
			checkBox.Text = _G.ESP_CONFIG.SelectedPlayers[player.UserId] and "✔" or ""
			checkBox.Font = Enum.Font.GothamBold
			checkBox.TextSize = 18
			checkBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
			Instance.new("UICorner", checkBox)

			local playerName = Instance.new("TextLabel", playerFrame)
			playerName.Size = UDim2.new(1, -25, 1, 0)
			playerName.Position = UDim2.new(0, 25, 0, 0)
			playerName.BackgroundTransparency = 1
			playerName.Text = player.Name
			playerName.TextColor3 = Color3.new(1,1,1)
			playerName.Font = Enum.Font.GothamBold
			playerName.TextSize = 18
			playerName.TextXAlignment = Enum.TextXAlignment.Left

			checkBox.MouseButton1Click:Connect(function()
				if _G.ESP_CONFIG.SelectedPlayers[player.UserId] then
					_G.ESP_CONFIG.SelectedPlayers[player.UserId] = nil
					checkBox.Text = ""
				else
					_G.ESP_CONFIG.SelectedPlayers[player.UserId] = true
					checkBox.Text = "✔"
				end
			end)
		end
	end

	-- Ajuster la taille du canvas pour scroll
	local totalHeight = (#Players:GetPlayers() - 1) * 29
	PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- Refresh la liste au lancement et à chaque joueur qui rejoint/quitte
refreshPlayerList()
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

-- ===== ESP =====
btnESP.MouseButton1Click:Connect(function()
	Modules.ESP = not Modules.ESP
	btnESP.Text = "ESP : " .. (Modules.ESP and "ON" or "OFF")

	if Modules.ESP then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/loucraft0493-lang/Roblox-ESP-Menu/main/Modules/PVP/ESP.lua"))()
		ESPFrame.Visible = true
	else
		ESPFrame.Visible = false
	end
end)

-- ===== SILENT AIM =====
btnSilent.MouseButton1Click:Connect(function()
	Modules.SilentAim = not Modules.SilentAim
	btnSilent.Text = "Silent Aim : " .. (Modules.SilentAim and "ON" or "OFF")

	if Modules.SilentAim then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/loucraft0493-lang/Roblox-ESP-Menu/main/Modules/PVP/SilentAim.lua"))()
	end
end)

-- ===== Boutons config =====
btnESPConfig.MouseButton1Click:Connect(function()
	ESPFrame.Visible = not ESPFrame.Visible
end)

btnSilentConfig.MouseButton1Click:Connect(function()
	print("Ouvrir config Silent Aim")
end)

-- ===== Toggle menu =====
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.RightControl then
		MainFrame.Visible = not MainFrame.Visible
		PVPFrame.Visible = false
	end
end)

print("✅ MainMenu chargé")
