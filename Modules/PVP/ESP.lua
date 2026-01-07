-- ESP.lua
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function applyESP(player)
	if player == LocalPlayer then return end

	local function onCharacter(char)
		task.wait(0.2)

		if not _G.ESP_CONFIG
		or not _G.ESP_CONFIG.Enabled
		or not _G.ESP_CONFIG.Players[player.Name] then
			return
		end

		if char:FindFirstChild("Highlight") then return end

		local head = char:WaitForChild("Head", 5)
		if not head then return end

		local h = Instance.new("Highlight")
		h.FillColor = _G.ESP_CONFIG.Color
		h.OutlineColor = Color3.new(1,1,1)
		h.FillTransparency = 0.4
		h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		h.Parent = char

		local b = Instance.new("BillboardGui")
		b.Size = UDim2.new(0,200,0,35)
		b.StudsOffset = Vector3.new(0,2.5,0)
		b.AlwaysOnTop = true
		b.Parent = head

		local t = Instance.new("TextLabel", b)
		t.Size = UDim2.new(1,0,1,0)
		t.BackgroundTransparency = 1
		t.Text = player.Name
		t.TextScaled = true
		t.TextStrokeTransparency = 0
		t.TextColor3 = _G.ESP_CONFIG.Color
		t.Font = Enum.Font.GothamBold
	end

	if player.Character then
		onCharacter(player.Character)
	end

	player.CharacterAdded:Connect(onCharacter)
end

for _, p in pairs(Players:GetPlayers()) do
	applyESP(p)
end

Players.PlayerAdded:Connect(applyESP)

print("✅ ESP chargé (menu + couleur HEX)")
