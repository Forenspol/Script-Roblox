-- ESP.lua (CLIENT SIDE, dynamique)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESP_CACHE = {}

-- 🔧 créer ESP
local function createESP(player)
	if player == LocalPlayer then return end
	if ESP_CACHE[player] then return end
	if not player.Character then return end

	local char = player.Character
	local head = char:FindFirstChild("Head")
	if not head then return end

	-- Highlight
	local h = Instance.new("Highlight")
	h.Name = "ESP_Highlight"
	h.FillTransparency = 0.4
	h.OutlineTransparency = 0
	h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	h.Parent = char

	-- NameTag
	local b = Instance.new("BillboardGui")
	b.Name = "ESP_Name"
	b.Size = UDim2.new(0,200,0,35)
	b.StudsOffset = Vector3.new(0,2.5,0)
	b.AlwaysOnTop = true
	b.Parent = head

	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1,0,1,0)
	t.BackgroundTransparency = 1
	t.TextScaled = true
	t.TextStrokeTransparency = 0
	t.Font = Enum.Font.GothamBold
	t.Parent = b

	ESP_CACHE[player] = {h = h, b = b, t = t}
end

-- ❌ supprimer ESP
local function removeESP(player)
	local data = ESP_CACHE[player]
	if not data then return end

	if data.h then data.h:Destroy() end
	if data.b then data.b:Destroy() end

	ESP_CACHE[player] = nil
end

-- 🔄 BOUCLE CLIENT (clé du système)
RunService.RenderStepped:Connect(function()
	if not _G.ESP_CONFIG then return end

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local enabled = _G.ESP_CONFIG.Enabled
				and _G.ESP_CONFIG.Players[player.Name]
				and player.Character

			if enabled then
				createESP(player)
				local esp = ESP_CACHE[player]
				if esp then
					esp.h.FillColor = _G.ESP_CONFIG.Color
					esp.t.Text = player.Name
					esp.t.TextColor3 = _G.ESP_CONFIG.Color
				end
			else
				removeESP(player)
			end
		end
	end
end)

-- cleanup
Players.PlayerRemoving:Connect(removeESP)

print("✅ ESP CLIENT chargé (temps réel)")
