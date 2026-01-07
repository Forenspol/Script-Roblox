-- MainMenu.lua
-- Menu principal + sous-menu PVP
-- Toggle: Right Ctrl

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ===== CONFIG =====
local Modules = {
	ESP = false,
	SilentAim = false
}

_G.ESP_CONFIG = {
	Color = Color3.fromRGB(255, 0, 0)
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

-- ===== LIGNE ESP =====
local btnESP = createButton(PVPFrame, "ESP : OFF", 80)

local btnESPConfig = Instance.new("TextButton", PVPFrame)
btnESPConfig.Size = UDim2.new(0,45,0,45)
btnESPConfig.Position = UDim2.new(1,-55,0,80)
btnESPConfig.Text = "⚙"
btnESPConfig.Font = Enum.Font.GothamBold
btnESPConfig.TextSize = 22
btnESPConfig.BackgroundColor3 = Color3.fromRGB(60,60,60)
btnESPConfig.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btnESPConfig)

-- ===== LIGNE SILENT AIM =====
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
ESPFrame.Size = UDim2.new(0, 260, 0, 260)
ESPFrame.Position = UDim2.new(0, 10, 0, 140)
ESPFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ESPFrame.Visible = false
Instance.new("UICorner", ESPFrame)

-- Titre config ESP
local ESPTitle = Instance.new("TextLabel", ESPFrame)
ESPTitle.Size = UDim2.new(1,0,0,40)
ESPTitle.BackgroundTransparency = 1
ESPTitle.Text = "Configuration ESP"
ESPTitle.TextColor3 = Color3.new(1,1,1)
ESPTitle.Font = Enum.Font.GothamBold
ESPTitle.TextSize = 22

-- Bouton fermeture config
local CloseConfigBtn = Instance.new("TextButton", ESPFrame)
CloseConfigBtn.Size = UDim2.new(0, 30, 0, 30)
CloseConfigBtn.Position = UDim2.new(1, -35, 0, 5)
CloseConfigBtn.Text = "✕"
CloseConfigBtn.Font = Enum.Font.GothamBold
CloseConfigBtn.TextSize = 18
CloseConfigBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
CloseConfigBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", CloseConfigBtn)

CloseConfigBtn.MouseButton1Click:Connect(function()
	ESPFrame.Visible = false
end)

-- ColorBox (HEX)
local ColorBox = Instance.new("TextBox",ESPFrame)
ColorBox.Size = UDim2.new(1,-70,0,35)
ColorBox.Position = UDim2.new(0,10,0,50)
ColorBox.PlaceholderText = "#FF0000"
ColorBox.Text = "#FF0000"
ColorBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
ColorBox.TextColor3 = Color3.new(1,1,1)
ColorBox.Font = Enum.Font.Gotham
ColorBox.TextSize = 16
Instance.new("UICorner",ColorBox)

-- Color Preview (clic ouvre palette)
local ColorPreview = Instance.new("Frame",ESPFrame)
ColorPreview.Size = UDim2.new(0,50,0,35)
ColorPreview.Position = UDim2.new(1,-60,0,50)
ColorPreview.BackgroundColor3 = _G.ESP_CONFIG.Color
Instance.new("UICorner",ColorPreview)

-- ======= Palette Couleur =======
local PaletteFrame = Instance.new("Frame", ESPFrame)
PaletteFrame.Size = UDim2.new(0, 260, 0, 200)
PaletteFrame.Position = UDim2.new(0, 10, 0, 95)
PaletteFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
PaletteFrame.Visible = false
Instance.new("UICorner", PaletteFrame)

local HueBar = Instance.new("ImageLabel", PaletteFrame)
HueBar.Size = UDim2.new(1, -40, 0, 30)
HueBar.Position = UDim2.new(0, 10, 0, 10)
HueBar.BackgroundTransparency = 1
HueBar.Image = "rbxassetid://7732516505"
HueBar.ScaleType = Enum.ScaleType.Stretch

local HueSelector = Instance.new("Frame", HueBar)
HueSelector.Size = UDim2.new(0, 5, 1, 0)
HueSelector.BackgroundColor3 = Color3.new(1,1,1)
HueSelector.BorderSizePixel = 0
HueSelector.Position = UDim2.new(0, 0, 0, 0)

local SVSquare = Instance.new("Frame", PaletteFrame)
SVSquare.Size = UDim2.new(1, -20, 1, -60)
SVSquare.Position = UDim2.new(0, 10, 0, 50)
SVSquare.BackgroundColor3 = Color3.new(1,0,0)
Instance.new("UICorner", SVSquare)

local SVGradientWhite = Instance.new("UIGradient", SVSquare)
SVGradientWhite.Rotation = 0
SVGradientWhite.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.new(1,1,1)),
	ColorSequenceKeypoint.new(1, Color3.new(1,1,1,0))
}

local SVGradientBlack = Instance.new("UIGradient", SVSquare)
SVGradientBlack.Rotation = 90
SVGradientBlack.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.new(0,0,0,0)),
	ColorSequenceKeypoint.new(1, Color3.new(0,0,0))
}

local SVSelector = Instance.new("Frame", SVSquare)
SVSelector.Size = UDim2.new(0, 10, 0, 10)
SVSelector.BackgroundColor3 = Color3.new(1,1,1)
SVSelector.BorderColor3 = Color3.new(0,0,0)
SVSelector.BorderSizePixel = 2
SVSelector.AnchorPoint = Vector2.new(0.5, 0.5)
SVSelector.Position = UDim2.new(1, 0, 0, 0)

-- HSV conversion functions
local function RGBtoHSV(color)
	local r, g, b = color.R, color.G, color.B
	local max = math.max(r, g, b)
	local min = math.min(r, g, b)
	local delta = max - min

	local h, s, v
	v = max

	if max == 0 then
		s = 0
	else
		s = delta / max
	end

	if delta == 0 then
		h = 0
	else
		if max == r then
			h = (g - b) / delta
		elseif max == g then
			h = 2 + (b - r) / delta
		else
			h = 4 + (r - g) / delta
		end

		h = h * 60
		if h < 0 then
			h = h + 360
		end
	end

	return h, s, v
end

local function HSVtoRGB(h, s, v)
	local c = v * s
	local x = c * (1 - math.abs((h / 60) % 2 - 1))
	local m = v - c

	local r, g, b

	if h < 60 then
		r, g, b = c, x, 0
	elseif h < 120 then
		r, g, b = x, c, 0
	elseif h < 180 then
		r, g, b = 0, c, x
	elseif h < 240 then
		r, g, b = 0, x, c
	elseif h < 300 then
		r, g, b = x, 0, c
	else
		r, g, b = c, 0, x
	end

	return Color3.new(r + m, g + m, b + m)
end

local hue, saturation, value = 0, 1, 1

local function updateColorFromHSV()
	local color = HSVtoRGB(hue, saturation, value)
	_G.ESP_CONFIG.Color = color
	ColorPreview.BackgroundColor3 = color
	ColorBox.Text = string.format("#%02X%02X%02X",
		math.floor(color.R * 255),
		math.floor(color.G * 255),
		math.floor(color.B * 255)
	)
end

local draggingHue = false
HueBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingHue = true
	end
end)
HueBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingHue = false
	end
end)
HueBar.InputChanged:Connect(function(input)
	if draggingHue and input.UserInputType == Enum.UserInputType.MouseMovement then
		local x = math.clamp(input.Position.X - HueBar.AbsolutePosition.X, 0, HueBar.AbsoluteSize.X)
		hue = (x / HueBar.AbsoluteSize.X) * 360
		HueSelector.Position = UDim2.new(x / HueBar.AbsoluteSize.X, 0, 0, 0)
		SVSquare.BackgroundColor3 = HSVtoRGB(hue, 1, 1)
		updateColorFromHSV()
	end
end)

local draggingSV = false
SVSquare.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingSV = true
	end
end)
SVSquare.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingSV = false
	end
end)
SVSquare.InputChanged:Connect(function(input)
	if draggingSV and input.UserInputType == Enum.UserInputType.MouseMovement then
		local posX = math.clamp(input.Position.X - SVSquare.AbsolutePosition.X, 0, SVSquare.AbsoluteSize.X)
		local posY = math.clamp(input.Position.Y - SVSquare.AbsolutePosition.Y, 0, SVSquare.AbsoluteSize.Y)
		saturation = posX / SVSquare.AbsoluteSize.X
		value = 1 - (posY / SVSquare.AbsoluteSize.Y)
		SVSelector.Position = UDim2.new(saturation, 0, 1 - value, 0)
		updateColorFromHSV()
	end
end)

ColorPreview.Active = true
ColorPreview.Selectable = true
ColorPreview.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		PaletteFrame.Visible = not PaletteFrame.Visible
	end
end)

-- Update from HEX textbox manually (support #RRGGBB)
ColorBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local hex = ColorBox.Text
		if string.sub(hex, 1, 1) == "#" then
			hex = string.sub(hex, 2)
		end
		if #hex == 6 then
			local r = tonumber("0x"..hex:sub(1,2))
			local g = tonumber("0x"..hex:sub(3,4))
			local b = tonumber("0x"..hex:sub(5,6))
			if r and g and b then
				local color = Color3.fromRGB(r, g, b)
				_G.ESP_CONFIG.Color = color
				ColorPreview.BackgroundColor3 = color
				hue, saturation, value = RGBtoHSV(color)
				SVSquare.BackgroundColor3 = HSVtoRGB(hue, 1, 1)
				HueSelector.Position = UDim2.new(hue/360, 0, 0, 0)
				SVSelector.Position = UDim2.new(saturation, 0, 1 - value, 0)
			end
		end
	end
end)

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
