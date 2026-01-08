
-- Aimbot.lua

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local AimbotEnabled = false
local FOV = 200
local AimPart = "Head"

-- Toggle avec SHIFT
UIS.InputBegan:Connect(function(i,gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.LeftShift then
		AimbotEnabled = not AimbotEnabled
	end
end)

local function isAlive(p)
	return p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0
end

local function getClosest()
	local closest = nil
	local dist = math.huge
	local mouse = UIS:GetMouseLocation()

	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and isAlive(p) then
			local part = p.Character:FindFirstChild(AimPart)
			if part then
				local pos, onscreen = Camera:WorldToViewportPoint(part.Position)
				if onscreen then
					local d = (Vector2.new(pos.X,pos.Y) - mouse).Magnitude
					if d < dist and d < FOV then
						dist = d
						closest = part
					end
				end
			end
		end
	end
	return closest
end

RunService.RenderStepped:Connect(function()
	if AimbotEnabled then
		local target = getClosest()
		if target then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
		end
	end
end)

-- UI CONFIG

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AimbotConfigGui"

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
title.Text = "AIMBOT CONFIG"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.BackgroundTransparency = 1

local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(1,0,0,40)
info.Position = UDim2.new(0,0,0,60)
info.Text = "SHIFT = ON / OFF"
info.TextColor3 = Color3.new(1,1,1)
info.Font = Enum.Font.Gotham
info.TextSize = 18
info.BackgroundTransparency = 1

_G.OpenAimbotConfig = function()
	frame.Visible = not frame.Visible
end

print("✅ Aimbot chargé")
