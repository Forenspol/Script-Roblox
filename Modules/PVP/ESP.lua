-- ESP.lua (CLIENT SIDE, dynamique)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ESP_CACHE = {}

-- 🔧 créer ESP
local function createESP(player)
	if player == LocalPlayer then return end
	if ESP_CACHE[player] then return end
	if not player.Character then return end

	local char = player.Character
	local head = char:FindFirstChild("Head")
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not head or not humanoid then return end

	-- Highlight
	local h = Instance.new("Highlight")
	h.Name = "ESP_Highlight"
	h.FillTransparency = 0.4
	h.OutlineTransparency = 0
	h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	h.Parent = char

	-- BillboardGui
	local b = Instance.new("BillboardGui")
	b.Name = "ESP_Name"
	b.Size = UDim2.new(0,200,0,50)
	b.StudsOffset = Vector3.new(0,2.5,0)
	b.AlwaysOnTop = true
	b.Parent = head

	-- Nom + distance
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1,0,0.6,0)
	t.BackgroundTransparency = 1
	t.TextScaled = true
	t.TextStrokeTransparency = 0
	t.Font = Enum.Font.GothamBold
	t.Parent = b

	-- Barre de vie
	local healthFrame = Instance.new("Frame")
	healthFrame.Size = UDim2.new(1,0,0.2,0)
	healthFrame.Position = UDim2.new(0,0,0.8,0)
	healthFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
	healthFrame.BorderSizePixel = 0
	healthFrame.Parent = b

	local healthBar = Instance.new("Frame")
	healthBar.Size = UDim2.new(1,0,1,0)
	healthBar.BackgroundColor3 = Color3.fromRGB(0,255,0)
	healthBar.BorderSizePixel = 0
	healthBar.Parent = healthFrame

	ESP_CACHE[player] = {h=h, b=b, t=t, healthBar=healthBar, humanoid=humanoid}
end

-- ❌ supprimer ESP
local function removeESP(player)
	local data = ESP_CACHE[player]
	if not data then return end

	if data.h then data.h:Destroy() end
	if data.b then data.b:Destroy() end

	ESP_CACHE[player] = nil
end

-- 🔄 BOUCLE CLIENT (ESP temps réel)
RunService.RenderStepped:Connect(function()
	if not _G.ESP_CONFIG then return end

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local enabled = _G.ESP_CONFIG.Enabled
				and _G.ESP_CONFIG.Players[player.Name]
				and player.Character

			if enabled then
				if not ESP_CACHE[player] then
					createESP(player)
				end

				local esp = ESP_CACHE[player]
				if esp then
					-- Update couleur et nom
					esp.h.FillColor = _G.ESP_CONFIG.Color
					esp.t.Text = player.Name.." ["..math.floor((player.Character.PrimaryPart.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude).."m]"
					esp.t.TextColor3 = _G.ESP_CONFIG.Color

					-- Barre de vie
					if esp.humanoid and esp.healthBar then
						local healthPercent = math.clamp(esp.humanoid.Health / esp.humanoid.MaxHealth, 0,1)
						esp.healthBar.Size = UDim2.new(healthPercent,0,1,0)
						if healthPercent > 0.6 then
							esp.healthBar.BackgroundColor3 = Color3.fromRGB(0,255,0)
						elseif healthPercent > 0.3 then
							esp.healthBar.BackgroundColor3 = Color3.fromRGB(255,255,0)
						else
							esp.healthBar.BackgroundColor3 = Color3.fromRGB(255,0,0)
						end
					end
				end
			else
				removeESP(player)
			end
		end
	end
end)

Players.PlayerRemoving:Connect(removeESP)

print("✅ ESP CLIENT chargé (barre vie + distance + HEX)")
