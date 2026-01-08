-- ESP.lua

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ESPEnabled = false
local ESPColor = Color3.fromRGB(255,0,0)
local Drawings = {}

local function clearESP()
	for _, d in pairs(Drawings) do
		pcall(function() d:Remove() end)
	end
	table.clear(Drawings)
end

local function createESP(plr)
	if plr == LocalPlayer then return end

	local box = Drawing.new("Square")
	box.Thickness = 2
	box.Filled = false
	box.Color = ESPColor

	local name = Drawing.new("Text")
	name.Size = 16
	name.Center = true
	name.Outline = true
	name.Color = ESPColor
	name.Text = plr.Name

	Drawings[plr] = {box, name}
end

local function removeESP(plr)
	if Drawings[plr] then
		for _, d in ipairs(Drawings[plr]) do
			pcall(function() d:Remove() end)
		end
		Drawings[plr] = nil
	end
end

for _,p in ipairs(Players:GetPlayers()) do
	createESP(p)
end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
	for plr, objs in pairs(Drawings) do
		local char = plr.Character
		if ESPEnabled and char and char:FindFirstChild("HumanoidRootPart") then
			local hrp = char.HumanoidRootPart
			local pos, onscreen = Camera:WorldToViewportPoint(hrp.Position)
			if onscreen then
				local size = (Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0,3,0)).Y - Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0,3,0)).Y)
				objs[1].Size = Vector2.new(size/2, size)
				objs[1].Position = Vector2.new(pos.X - size/4, pos.Y - size/2)
				objs[1].Visible = true

				objs[2].Position = Vector2.new(pos.X, pos.Y - size/2 - 16)
				objs[2].Visible = true
			else
				objs[1].Visible = false
				objs[2].Visible = false
			end
		else
			objs[1].Visible = false
			objs[2].Visible = false
		end
	end
end)

-- ===== UI CONFIG =====

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ESPConfigGui"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Visible = false
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.Text = "ESP CONFIG"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.BackgroundTransparency = 1

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0.8,0,0,40)
toggle.Position = UDim2.new(0.1,0,0,60)
toggle.Text = "ESP : OFF"
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 18
toggle.BackgroundColor3 = Color3.fromRGB(50,50,50)
toggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggle)

toggle.MouseButton1Click:Connect(function()
	ESPEnabled = not ESPEnabled
	toggle.Text = "ESP : " .. (ESPEnabled and "ON" or "OFF")
end)

_G.OpenESPConfig = function()
	frame.Visible = not frame.Visible
end

print("✅ ESP chargé")
