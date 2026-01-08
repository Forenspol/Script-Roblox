-- MainLoader.lua
-- Menu principal + loader des modules
-- Toggle: Right Ctrl

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Sécurité : éviter double injection
if game.CoreGui:FindFirstChild("ForenspolMenu") then
	game.CoreGui.ForenspolMenu:Destroy()
end

-- ===== GUI ROOT =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ForenspolMenu"
ScreenGui.Parent = game.CoreGui

-- ===== ETAT DES MODULES =====
local Modules = {
	ESP = false,
	SilentAim = false
}

-- ===== UTILITAIRE BOUTON =====
local function createButton(parent, text, posY, width)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(width or 0.7, 0, 0, 42)
	btn.Position = UDim2.new(0.15, 0, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.AutoButtonColor = true
	Instance.new("UICorner", btn)
	return btn
end

-- ===== FRAME PRINCIPAL =====
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 420, 0, 420)
MainFrame.Position = UDim2.new(0, 60, 0, 120)
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
local btnPVP = createButton(MainFrame, "PVP  →", 90)
local btnFarm = createButton(MainFrame, "Farm  →", 150)

-- ===== FRAME PVP =====
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

-- ===== LIGNE ESP =====
local btnESP = createButton(PVPFrame, "ESP : OFF", 90)

local btnESPConfig = Instance.new("TextButton", PVPFrame)
btnESPConfig.Size = UDim2.new(0,45,0,42)
btnESPConfig.Position = UDim2.new(1,-60,0,90)
btnESPConfig.Text = "⚙"
btnESPConfig.Font = Enum.Font.GothamBold
btnESPConfig.TextSize = 22
btnESPConfig.BackgroundColor3 = Color3.fromRGB(60,60,60)
btnESPConfig.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btnESPConfig)

-- ===== LIGNE SILENT AIM =====
local btnSilent = createButton(PVPFrame, "Silent Aim : OFF", 150)

local btnSilentConfig = btnESPConfig:Clone()
btnSilentConfig.Parent = PVPFrame
btnSilentConfig.Position = UDim2.new(1,-60,0,150)

-- ===== NAVIGATION =====
btnPVP.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	PVPFrame.Visible = true
end)

BackBtn.MouseButton1Click:Connect(function()
	PVPFrame.Visible = false
	MainFrame.Visible = true
end)

-- ===== ESP =====
btnESP.MouseButton1Click:Connect(function()
	Modules.ESP = not Modules.ESP
	btnESP.Text = "ESP : " .. (Modules.ESP and "ON" or "OFF")

	if Modules.ESP then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Forenspol/Script-Roblox/main/Modules/PVP/ESP.lua"))()
	end
end)

-- ⚙ ESP CONFIG
btnESPConfig.MouseButton1Click:Connect(function()
	if _G.OpenESPConfig then
		_G.OpenESPConfig()
	else
		warn("ESP pas chargé")
	end
end)

-- ===== SILENT AIM =====
btnSilent.MouseButton1Click:Connect(function()
	Modules.SilentAim = not Modules.SilentAim
	btnSilent.Text = "Silent Aim : " .. (Modules.SilentAim and "ON" or "OFF")

	if Modules.SilentAim then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Forenspol/Script-Roblox/main/Modules/PVP/SilentAim.lua"))()
	end
end)

-- ⚙ Silent Aim CONFIG
btnSilentConfig.MouseButton1Click:Connect(function()
	if _G.OpenSilentAimConfig then
		_G.OpenSilentAimConfig()
	else
		warn("SilentAim pas chargé")
	end
end)

-- ===== TOGGLE MENU =====
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.RightControl then
		MainFrame.Visible = not MainFrame.Visible
		PVPFrame.Visible = false
	end
end)

print("✅ MainLoader chargé")
