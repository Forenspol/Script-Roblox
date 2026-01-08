-- MainLoader.lua

if _G.MAIN_LOADED then return end
_G.MAIN_LOADED = true

-- Charger modules
pcall(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Forenspol/Script-Roblox/main/Modules/PVP/ESP.lua"))()
end)

pcall(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Forenspol/Script-Roblox/main/Modules/PVP/Aimbot.lua"))()
end)

-- UI
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MainMenuGui"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 320, 0, 260)
main.Position = UDim2.new(0.5, -160, 0.5, -130)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "MENU PRINCIPAL"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.BackgroundTransparency = 1

local function makeButton(text, y)
	local b = Instance.new("TextButton", main)
	b.Size = UDim2.new(0.8,0,0,40)
	b.Position = UDim2.new(0.1,0,0,y)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 18
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b)
	return b
end

local espBtn = makeButton("ESP  ⚙", 70)
local aimBtn = makeButton("AIMBOT  ⚙", 130)

espBtn.MouseButton1Click:Connect(function()
	if _G.OpenESPConfig then
		_G.OpenESPConfig()
	end
end)

aimBtn.MouseButton1Click:Connect(function()
	if _G.OpenAimbotConfig then
		_G.OpenAimbotConfig()
	end
end)

-- Toggle menu avec RightCtrl
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.RightControl then
		main.Visible = not main.Visible
	end
end)

print("✅ MainLoader chargé")
