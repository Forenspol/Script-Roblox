-- MainLoader.lua
-- Menu principal + PVP + ESP intégré (fonctionnel, client-side)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ===== CONFIG GLOBALE ESP =====
_G.ESP_CONFIG = {
    Enabled = false,
    Players = {}, -- joueurName = true/false
    Color = Color3.fromRGB(255,0,0) -- couleur par défaut rouge
}

-- Remplir tous les joueurs par défaut actif
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        _G.ESP_CONFIG.Players[p.Name] = true
    end
end

Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then
        _G.ESP_CONFIG.Players[p.Name] = true
    end
end)

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LoucraftMenu"
ScreenGui.Parent = game.CoreGui

local function createButton(parent,text,posY)
    local btn = Instance.new("TextButton",parent)
    btn.Size = UDim2.new(0.85,0,0,45)
    btn.Position = UDim2.new(0.075,0,0,posY)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    Instance.new("UICorner",btn)
    return btn
end

-- ===== FRAME PRINCIPAL =====
local MainFrame = Instance.new("Frame",ScreenGui)
MainFrame.Size = UDim2.new(0,400,0,420)
MainFrame.Position = UDim2.new(0,50,0,120)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner",MainFrame)

local Title = Instance.new("TextLabel",MainFrame)
Title.Size = UDim2.new(1,0,0,50)
Title.BackgroundTransparency = 1
Title.Text = "MENU PRINCIPAL"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24

local btnPVP = createButton(MainFrame,"PVP  →",80)

-- ===== FRAME PVP =====
local PVPFrame = Instance.new("Frame",ScreenGui)
PVPFrame.Size = MainFrame.Size
PVPFrame.Position = MainFrame.Position
PVPFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
PVPFrame.Visible = false
PVPFrame.Active = true
PVPFrame.Draggable = true
Instance.new("UICorner",PVPFrame)

local PVPTitle = Instance.new("TextLabel",PVPFrame)
PVPTitle.Size = UDim2.new(1,0,0,50)
PVPTitle.BackgroundTransparency = 1
PVPTitle.Text = "MENU PVP"
PVPTitle.TextColor3 = Color3.new(1,1,1)
PVPTitle.Font = Enum.Font.GothamBold
PVPTitle.TextSize = 24

local BackBtn = Instance.new("TextButton",PVPFrame)
BackBtn.Size = UDim2.new(0,60,0,35)
BackBtn.Position = UDim2.new(0,10,0,8)
BackBtn.Text = "←"
BackBtn.Font = Enum.Font.GothamBold
BackBtn.TextSize = 22
BackBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
BackBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",BackBtn)

-- ===== ESP =====
local btnESP = createButton(PVPFrame,"ESP : OFF",80)

local btnESPConfig = Instance.new("TextButton",PVPFrame)
btnESPConfig.Size = UDim2.new(0,45,0,45)
btnESPConfig.Position = UDim2.new(1,-55,0,80)
btnESPConfig.Text = "⚙"
btnESPConfig.Font = Enum.Font.GothamBold
btnESPConfig.TextSize = 22
btnESPConfig.BackgroundColor3 = Color3.fromRGB(60,60,60)
btnESPConfig.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",btnESPConfig)

-- ===== NAVIGATION =====
btnPVP.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    PVPFrame.Visible = true
end)

BackBtn.MouseButton1Click:Connect(function()
    PVPFrame.Visible = false
    MainFrame.Visible = true
end)

-- ===== FRAME CONFIG ESP =====
local ESPFrame = Instance.new("Frame",ScreenGui)
ESPFrame.Size = UDim2.new(0,300,0,400)
ESPFrame.Position = UDim2.new(0,470,0,120)
ESPFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
ESPFrame.Visible = false
ESPFrame.Active = true
ESPFrame.Draggable = true
Instance.new("UICorner",ESPFrame)

local ESPTitle = Instance.new("TextLabel",ESPFrame)
ESPTitle.Size = UDim2.new(1,0,0,40)
ESPTitle.BackgroundTransparency = 1
ESPTitle.Text = "ESP CONFIG"
ESPTitle.TextColor3 = Color3.new(1,1,1)
ESPTitle.Font = Enum.Font.GothamBold
ESPTitle.TextSize = 18

-- HEX color input
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

local ColorPreview = Instance.new("Frame",ESPFrame)
ColorPreview.Size = UDim2.new(0,50,0,35)
ColorPreview.Position = UDim2.new(1,-60,0,50)
ColorPreview.BackgroundColor3 = _G.ESP_CONFIG.Color
Instance.new("UICorner",ColorPreview)

local function hexToColor3(hex)
    hex = hex:gsub("#","")
    if #hex ~= 6 then return nil end
    local r = tonumber(hex:sub(1,2),16)
    local g = tonumber(hex:sub(3,4),16)
    local b = tonumber(hex:sub(5,6),16)
    if not r or not g or not b then return nil end
    return Color3.fromRGB(r,g,b)
end

ColorBox.FocusLost:Connect(function()
    local color = hexToColor3(ColorBox.Text)
    if color then
        _G.ESP_CONFIG.Color = color
        ColorPreview.BackgroundColor3 = color
    end
end)

-- ===== LISTE JOUEURS =====
local list = Instance.new("ScrollingFrame",ESPFrame)
list.Position = UDim2.new(0,10,0,95)
list.Size = UDim2.new(1,-20,1,-105)
list.CanvasSize = UDim2.new(0,0,0,0)
list.ScrollBarImageTransparency = 0.4

local layout = Instance.new("UIListLayout",list)
layout.Padding = UDim.new(0,6)

local function addPlayer(player)
    if player == LocalPlayer then return end
    local btn = Instance.new("TextButton",list)
    btn.Size = UDim2.new(1,0,0,38)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.Text = player.Name.." [ON]"
    Instance.new("UICorner",btn)

    btn.MouseButton1Click:Connect(function()
        _G.ESP_CONFIG.Players[player.Name] = not _G.ESP_CONFIG.Players[player.Name]
        btn.Text = player.Name..(_G.ESP_CONFIG.Players[player.Name] and " [ON]" or " [OFF]")
    end)
end

for _, p in pairs(Players:GetPlayers()) do addPlayer(p) end
Players.PlayerAdded:Connect(addPlayer)
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    list.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end)

btnESPConfig.MouseButton1Click:Connect(function()
    ESPFrame.Visible = not ESPFrame.Visible
end)

-- ===== ESP LOGIC =====
local ESP_CACHE = {}
local function createESP(player)
    if player == LocalPlayer then return end
    if ESP_CACHE[player] then return end
    if not player.Character then return end
    local char = player.Character
    local head = char:FindFirstChild("Head")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not head or not humanoid then return end

    local h = Instance.new("Highlight")
    h.Name = "ESP_Highlight"
    h.FillTransparency = 0.4
    h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = char

    local b = Instance.new("BillboardGui")
    b.Name = "ESP_Name"
    b.Size = UDim2.new(0,200,0,50)
    b.StudsOffset = Vector3.new(0,2.5,0)
    b.AlwaysOnTop = true
    b.Parent = head

    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1,0,0.6,0)
    t.BackgroundTransparency = 1
    t.TextScaled = true
    t.TextStrokeTransparency = 0
    t.Font = Enum.Font.GothamBold
    t.Parent = b

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

    ESP_CACHE[player] = {h=h,b=b,t=t,healthBar=healthBar,humanoid=humanoid}
end

local function removeESP(player)
    local data = ESP_CACHE[player]
    if not data then return end
    if data.h then data.h:Destroy() end
    if data.b then data.b:Destroy() end
    ESP_CACHE[player] = nil
end

RunService.RenderStepped:Connect(function()
    if not _G.ESP_CONFIG then return end
    for _,player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local enabled = _G.ESP_CONFIG.Enabled and _G.ESP_CONFIG.Players[player.Name] and player.Character
            if enabled then
                if not ESP_CACHE[player] then createESP(player) end
                local esp = ESP_CACHE[player]
                if esp then
                    local distance = ""
                    if LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
                        distance = "["..math.floor((player.Character.PrimaryPart.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude).."m]"
                    end
                    esp.h.FillColor = _G.ESP_CONFIG.Color
                    esp.t.Text = player.Name.." "..distance
                    esp.t.TextColor3 = _G.ESP_CONFIG.Color

                    local hp = esp.humanoid.Health/esp.humanoid.MaxHealth
                    hp = math.clamp(hp,0,1)
                    esp.healthBar.Size = UDim2.new(hp,0,1,0)
                    if hp>0.6 then
                        esp.healthBar.BackgroundColor3 = Color3.fromRGB(0,255,0)
                    elseif hp>0.3 then
                        esp.healthBar.BackgroundColor3 = Color3.fromRGB(255,255,0)
                    else
                        esp.healthBar.BackgroundColor3 = Color3.fromRGB(255,0,0)
                    end
                end
            else
                removeESP(player)
            end
        end
    end
end)

-- ===== TOGGLE MENU =====
UIS.InputBegan:Connect(function(input,gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
        PVPFrame.Visible = false
    end
end)

-- ===== BOUTON ESP =====
btnESP.MouseButton1Click:Connect(function()
    _G.ESP_CONFIG.Enabled = not _G.ESP_CONFIG.Enabled
    btnESP.Text = "ESP : "..(_G.ESP_CONFIG.Enabled and "ON" or "OFF")
end)

print("✅ MainMenu + ESP intégré chargé")
