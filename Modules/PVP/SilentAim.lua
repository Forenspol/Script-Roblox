-- SilentAim.lua
-- Silent Aim avec FOV + Menu config

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Eviter double load
if _G.SILENTAIM_LOADED then return end
_G.SILENTAIM_LOADED = true

-- ===== CONFIG =====
local Config = {
	Enabled = false,
	FOV = 150,
	ShowFOV = true,
	HitPart = "Head" -- Head / HumanoidRootPart
}

-- ===== GUI CONFIG =====
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SilentAimConfigGui"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 320, 0, 280)
Frame.Position = UDim2.new(0.5, -160, 0.5, -140)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Visible = false
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "SILENT AIM CONFIG"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22

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

-- ===== UI UTILS =====
local function createToggle(text, posY, default, callback)
	local btn = Instance.new("TextButton", Frame)
	btn.Size = UDim2.new(0.8,0,0,36)
	btn.Position = UDim2.new(0.1,0,0,posY)
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	Instance.new("UICorner", btn)

	local state = default
	local function refresh()
		btn.Text = text .. " : " .. (state and "ON" or "OFF")
	end
	refresh()

	btn.MouseButton1Click:Connect(function()
		state = not state
		refresh()
		callback(state)
	end)
end

-- Toggle SilentAim
createToggle("Silent Aim", 50, false, function(v)
	Config.Enabled = v
end)

-- Toggle Show FOV
createToggle("Show FOV", 95, true, function(v)
	Config.ShowFOV = v
end)

-- ===== FOV SLIDER =====
local FOVLabel = Instance.new("TextLabel", Frame)
FOVLabel.Size = UDim2.new(1,0,0,30)
FOVLabel.Position = UDim2.new(0,0,0,140)
FOVLabel.Text = "FOV : 150"
FOVLabel.TextColor3 = Color3.new(1,1,1)
FOVLabel.BackgroundTransparency = 1
FOVLabel.Font = Enum.Font.GothamBold
FOVLabel.TextSize = 18

local PlusBtn = Instance.new("TextButton", Frame)
PlusBtn.Size = UDim2.new(0,40,0,40)
PlusBtn.Position = UDim2.new(0.6,0,0,175)
PlusBtn.Text = "+"
PlusBtn.Font = Enum.Font.GothamBold
PlusBtn.TextSize = 28
PlusBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
PlusBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", PlusBtn)

local MinusBtn = Instance.new("TextButton", Frame)
MinusBtn.Size = UDim2.new(0,40,0,40)
MinusBtn.Position = UDim2.new(0.25,0,0,175)
MinusBtn.Text = "-"
MinusBtn.Font = Enum.Font.GothamBold
MinusBtn.TextSize = 28
MinusBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
MinusBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", MinusBtn)

local function refreshFOV()
	FOVLabel.Text = "FOV : " .. Config.FOV
end

PlusBtn.MouseButton1Click:Connect(function()
	Config.FOV = math.clamp(Config.FOV + 10, 50, 600)
	refreshFOV()
end)

MinusBtn.MouseButton1Click:Connect(function()
	Config.FOV = math.clamp(Config.FOV - 10, 50, 600)
	refreshFOV()
end)

-- ===== HITPART =====
local HitPartBtn = Instance.new("TextButton", Frame)
HitPartBtn.Size = UDim2.new(0.8,0,0,36)
HitPartBtn.Position = UDim2.new(0.1,0,0,230)
HitPartBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
HitPartBtn.TextColor3 = Color3.new(1,1,1)
HitPartBtn.Font = Enum.Font.GothamBold
HitPartBtn.TextSize = 16
Instance.new("UICorner", HitPartBtn)

local function refreshHitPart()
	HitPartBtn.Text = "HitPart : " .. Config.HitPart
end
refreshHitPart()

HitPartBtn.MouseButton1Click:Connect(function()
	if Config.HitPart == "Head" then
		Config.HitPart = "HumanoidRootPart"
	else
		Config.HitPart = "Head"
	end
	refreshHitPart()
end)

-- ===== OUVERTURE DEPUIS MENU =====
_G.OpenSilentAimConfig = function()
	Frame.Visible = not Frame.Visible
end

-- ===== FOV CIRCLE =====
local FOVCircle = Drawing.new("Circle")
FOVCircle.Filled = false
FOVCircle.Thickness = 2
FOVCircle.Transparency = 1
FOVCircle.Color = Color3.fromRGB(255,255,255)
FOVCircle.Visible = true

-- ===== UTILS =====
local function isAlive(plr)
	return plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0
end

local function getClosestTarget()
	local closest = nil
	local shortest = math.huge

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and isAlive(plr) then
			local part = plr.Character:FindFirstChild(Config.HitPart)
			if part then
				local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
				if onScreen then
					local dist = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
					if dist < shortest and dist < Config.FOV then
						shortest = dist
						closest = part
					end
				end
			end
		end
	end

	return closest
end

-- ===== HOOK =====
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
	local args = {...}
	local method = getnamecallmethod()

	if Config.Enabled and method == "FindPartOnRayWithIgnoreList" then
		local target = getClosestTarget()
		if target then
			local origin = args[1].Origin
			local direction = (target.Position - origin).Unit * 1000
			args[1] = Ray.new(origin, direction)
			return old(self, unpack(args))
		end
	end

	return old(self, ...)
end)

-- ===== UPDATE LOOP =====
RunService.RenderStepped:Connect(function()
	FOVCircle.Position = UserInputService:GetMouseLocation()
	FOVCircle.Radius = Config.FOV
	FOVCircle.Visible = Config.ShowFOV
end)

print("✅ Silent Aim chargé avec menu config")
