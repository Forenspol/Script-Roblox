-- ESP.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local espColor = Color3.fromRGB(255,0,0)
local selectedPlayers = {}

local function clearESP(character)
	if not character then return end
	local folder = character:FindFirstChild("ESPFolder")
	if folder then folder:Destroy() end
end

local function applyESP(character,player)
	if not character then return end

	clearESP(character)

	local folder = Instance.new("Folder")
	folder.Name="ESPFolder"
	folder.Parent=character

	local parts = {}
	for _,partName in ipairs({"Head","Torso","UpperTorso","LowerTorso","HumanoidRootPart","LeftArm","RightArm","LeftLeg","RightLeg"}) do
		local part = character:FindFirstChild(partName)
		if part and part:IsA("BasePart") then table.insert(parts,part) end
	end

	for _,part in ipairs(parts) do
		local box = Instance.new("BoxHandleAdornment")
		box.Adornee = part
		box.AlwaysOnTop = true
		box.Size = part.Size + Vector3.new(0.1,0.1,0.1)
		box.Color3 = espColor
		box.Transparency = 0.5
		box.ZIndex = 10
		box.Parent = folder
	end

	local head = character:FindFirstChild("Head")
	if head then
		local billboard = Instance.new("BillboardGui")
		billboard.Size=UDim2.new(0,200,0,40)
		billboard.StudsOffset=Vector3.new(0,3,0)
		billboard.AlwaysOnTop=true
		billboard.Parent=head

		local txt = Instance.new("TextLabel",billboard)
		txt.Size=UDim2.fromScale(1,1)
		txt.BackgroundTransparency=1
		txt.Text=player.Name
		txt.TextColor3=espColor
		txt.TextStrokeTransparency=0
		txt.Font=Enum.Font.GothamBold
		txt.TextScaled=true
	end
end

local function refreshPlayer(player)
	if player.Character then
		applyESP(player.Character,player)
	end
end

for _,p in ipairs(Players:GetPlayers()) do
	p.CharacterAdded:Connect(function(char) task.wait(0.5) refreshPlayer(p) end)
	refreshPlayer(p)
end

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function(char) task.wait(0.5) refreshPlayer(p) end)
	refreshPlayer(p)
end)
