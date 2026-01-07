-- ColorPicker.lua
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui",game.CoreGui)
ScreenGui.Name="ColorPicker"

local Frame=Instance.new("Frame",ScreenGui)
Frame.Size=UDim2.fromOffset(250,250)
Frame.Position=UDim2.fromScale(0.7,0.2)
Frame.BackgroundColor3=Color3.fromRGB(30,30,30)
Instance.new("UICorner",Frame)
Frame.Active=true
Frame.Draggable=true

local HexLabel=Instance.new("TextLabel",Frame)
HexLabel.Size=UDim2.fromOffset(100,30)
HexLabel.Position=UDim2.fromScale(0.1,0.85)
HexLabel.BackgroundTransparency=1
HexLabel.TextColor3=Color3.new(1,1,1)
HexLabel.TextScaled=true
HexLabel.Text="#FF0000"

local ColorSquare=Instance.new("Frame",Frame)
ColorSquare.Size=UDim2.fromOffset(200,200)
ColorSquare.Position=UDim2.fromScale(0.1,0.1)
ColorSquare.BackgroundColor3=Color3.fromRGB(255,0,0)
Instance.new("UICorner",ColorSquare)

local dragging=false
local hue=0
local satVal={1,1}

local function HSVtoRGB(h,s,v)
	local c=v*s
	local x=c*(1-math.abs((h/60)%2-1))
	local m=v-c
	local r,g,b=0,0,0
	if h<60 then r,g,b=c,x,0
	elseif h<120 then r,g,b=x,c,0
	elseif h<180 then r,g,b=0,c,x
	elseif h<240 then r,g,b=0,x,c
	elseif h<300 then r,g,b=x,0,c
	else r,g,b=c,0,x end
	return Color3.new(r+m,g+m,b+m)
end

local function RGBToHex(col)
	local r=math.floor(col.R*255)
	local g=math.floor(col.G*255)
	local b=math.floor(col.B*255)
	return string.format("#%02X%02X%02X",r,g,b)
end

ColorSquare.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end
end)
ColorSquare.InputEnded:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging then
		local mouse=UserInputService:GetMouseLocation()
		local x=math.clamp(mouse.X-ColorSquare.AbsolutePosition.X,0,200)/200
		local y=math.clamp(mouse.Y-ColorSquare.AbsolutePosition.Y,0,200)/200
		satVal[1]=x
		satVal[2]=1-y
		local col=HSVtoRGB(hue,satVal[1],satVal[2])
		ColorSquare.BackgroundColor3=col
		HexLabel.Text=RGBToHex(col)
		-- Applique la couleur à tous les ESP
		for _,p in ipairs(Players:GetPlayers()) do
			local folder=p.Character and p.Character:FindFirstChild("ESPFolder")
			if folder then
				for _,child in ipairs(folder:GetChildren()) do
					if child:IsA("BoxHandleAdornment") then
						child.Color3=col
					elseif child:IsA("BillboardGui") then
						local txt=child:FindFirstChildOfClass("TextLabel")
						if txt then txt.TextColor3=col end
					end
				end
			end
		end
	end
end)
