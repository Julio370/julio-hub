local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "JulioHubGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Hub principal
local hubContainer = Instance.new("Frame")
hubContainer.Size = UDim2.new(0,500,0,330)
hubContainer.Position = UDim2.new(0.5,-250,0.25,0)
hubContainer.BackgroundColor3 = Color3.fromRGB(18,20,25)
hubContainer.BorderSizePixel = 0
hubContainer.Parent = gui

local hubCorner = Instance.new("UICorner")
hubCorner.CornerRadius = UDim.new(0,20)
hubCorner.Parent = hubContainer

-- Hub interno
local hub = Instance.new("Frame")
hub.Size = UDim2.new(1,0,1,0)
hub.BackgroundTransparency = 1
hub.Parent = hubContainer

-- Top bar
local top = Instance.new("Frame")
top.Size = UDim2.new(1,0,0,40)
top.BackgroundColor3 = Color3.fromRGB(22,25,32)
top.Parent = hub

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0,20)
topCorner.Parent = top

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-40,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "Julio Hub - Tsunami Brainroot"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(120,190,255)
title.Parent = top

-- Botón minimizar
local close = Instance.new("TextButton")
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,5)
close.Text = "–"
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.TextColor3 = Color3.fromRGB(255,100,100)
close.BackgroundTransparency = 1
close.Parent = top

-- Drag hub
local dragging, dragStart, startPos = false, nil, nil
top.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = hubContainer.Position
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		hubContainer.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

-- Side panel
local side = Instance.new("Frame")
side.Size = UDim2.new(0,140,1,-40)
side.Position = UDim2.new(0,0,0,40)
side.BackgroundColor3 = Color3.fromRGB(15,17,22)
side.Parent = hub

local tab = Instance.new("TextLabel")
tab.Size = UDim2.new(1,0,0,40)
tab.Text = "Main"
tab.Font = Enum.Font.GothamBold
tab.TextSize = 14
tab.TextColor3 = Color3.fromRGB(120,190,255)
tab.BackgroundTransparency = 1
tab.Parent = side

local content = Instance.new("Frame")
content.Size = UDim2.new(1,-140,1,-40)
content.Position = UDim2.new(0,140,0,40)
content.BackgroundColor3 = Color3.fromRGB(20,23,30)
content.Parent = hub

-- DUPE button
local dupe = Instance.new("TextButton")
dupe.Size = UDim2.new(1,-30,0,45)
dupe.Position = UDim2.new(0,15,0,0)
dupe.Text = "DUPE"
dupe.Font = Enum.Font.GothamBlack
dupe.TextSize = 18
dupe.TextColor3 = Color3.fromRGB(255,255,255)
dupe.BackgroundColor3 = Color3.fromRGB(35,40,55)
dupe.BorderSizePixel = 0
dupe.AutoButtonColor = false
dupe.Parent = content

local dupeCorner = Instance.new("UICorner")
dupeCorner.CornerRadius = UDim.new(0,10)
dupeCorner.Parent = dupe

dupe.MouseEnter:Connect(function()
	TweenService:Create(dupe, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60,120,255), Size = UDim2.new(1,-25,0,50)}):Play()
end)
dupe.MouseLeave:Connect(function()
	TweenService:Create(dupe, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35,40,55), Size = UDim2.new(1,-30,0,45)}):Play()
end)
dupe.MouseButton1Click:Connect(function()
	local char = player.Character
	if not char then return end
	local tool = char:FindFirstChildOfClass("Tool")
	if tool then
		local clone = tool:Clone()
		for _, obj in pairs(clone:GetDescendants()) do
			if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
				obj:Destroy()
			end
		end
		clone.Parent = player.Backpack

		local highlight = Instance.new("Highlight")
		highlight.Adornee = clone:FindFirstChildWhichIsA("BasePart") or clone
		highlight.FillColor = Color3.fromRGB(100,200,255)
		highlight.FillTransparency = 0.5
		highlight.OutlineTransparency = 1
		highlight.Parent = clone

		print("Brainroot duplicado (solo visual)")
	else
		print("No tienes ninguna tool equipada")
	end
end)

-- =====================================
-- BOTÓN TELEPORT
-- =====================================
local tpButton = Instance.new("TextButton")
tpButton.Size = dupe.Size
tpButton.Position = UDim2.new(0,15,0,dupe.Position.Y.Offset + dupe.Size.Y.Offset + 10)
tpButton.Text = "TELEPORT"
tpButton.Font = Enum.Font.GothamBlack
tpButton.TextSize = 18
tpButton.TextColor3 = Color3.fromRGB(255,255,255)
tpButton.BackgroundColor3 = Color3.fromRGB(35,40,55)
tpButton.BorderSizePixel = 0
tpButton.AutoButtonColor = false
tpButton.Parent = content

local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0,10)
tpCorner.Parent = tpButton

tpButton.MouseEnter:Connect(function()
	TweenService:Create(tpButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60,120,255), Size = UDim2.new(1,-25,0,50)}):Play()
end)
tpButton.MouseLeave:Connect(function()
	TweenService:Create(tpButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35,40,55), Size = UDim2.new(1,-30,0,45)}):Play()
end)

-- =====================================
-- TELEPORT FUNC
-- =====================================
local function getChar()
	return player.Character or player.CharacterAdded:Wait()
end

local function teleportTo(pos)
	local char = getChar()
	local hrp = char:WaitForChild("HumanoidRootPart")
	hrp.CFrame = CFrame.new(pos.X, pos.Y, pos.Z)
end

-- =====================================
-- AREAS Y BOTONES COMPACTOS
-- =====================================
local areas = {
    {name="Common",     pos=Vector3.new(206,  -2.70, 0), color=Color3.fromRGB(160,160,160)},
    {name="Uncommon",   pos=Vector3.new(290,  -2.70, 0), color=Color3.fromRGB(80,255,120)},
    {name="Rare",       pos=Vector3.new(404,  -2.70, 0), color=Color3.fromRGB(0,170,255)},
    {name="Epic",       pos=Vector3.new(548,  -2.70, 0), color=Color3.fromRGB(180,100,255)},
    {name="Legendary",  pos=Vector3.new(762,  -2.70, 0), color=Color3.fromRGB(255,215,80)},
    {name="Mythic",     pos=Vector3.new(1084, -2.70, 0), color=Color3.fromRGB(255,150,200)},
    {name="Cosmic",     pos=Vector3.new(1574, -2.70, 0), color=Color3.fromRGB(120,0,180)},
    {name="Secret",     pos=Vector3.new(2279, -2.70, 0), color=Color3.fromRGB(255,60,60)},
    {name="Celestial",  pos=Vector3.new(2634, -2.70, 0), color=Color3.fromRGB(200,60,140)},
}

local areaPanel = Instance.new("Frame")
areaPanel.Parent = content
areaPanel.Size = UDim2.new(1,-30,0,0)
areaPanel.Position = UDim2.new(0,15,0,tpButton.Position.Y.Offset + tpButton.Size.Y.Offset + 10)
areaPanel.BackgroundColor3 = Color3.fromRGB(0,0,0)
areaPanel.BorderSizePixel = 0
areaPanel.ClipsDescendants = true

local areaButtons = {}
local buttonHeight = 28
local spacing = 3

for i, area in ipairs(areas) do
	local btn = Instance.new("TextButton")
	btn.Parent = areaPanel
	btn.Size = UDim2.new(1,0,0,buttonHeight)
	btn.Position = UDim2.new(0,0,0,(i-1)*(buttonHeight + spacing))
	btn.Text = area.name:upper()
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 12
	btn.TextColor3 = area.color
	btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0,6)
	corner.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Parent = btn
	stroke.Thickness = 1
	stroke.Color = area.color
	stroke.Transparency = 0.4

	btn.MouseEnter:Connect(function()
		stroke.Transparency = 0
		btn.BackgroundColor3 = Color3.fromRGB(35,35,50)
	end)
	btn.MouseLeave:Connect(function()
		stroke.Transparency = 0.4
		btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
	end)

	btn.MouseButton1Click:Connect(function()
		teleportTo(area.pos)
	end)

	table.insert(areaButtons, btn)
end

-- Toggle desplegar/ocultar
local areaVisible = false
tpButton.MouseButton1Click:Connect(function()
	areaVisible = not areaVisible
	local targetHeight = areaVisible and (#areas * (buttonHeight + spacing)) or 0
	TweenService:Create(areaPanel, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1,-30,0,targetHeight)}):Play()
end)

-- =====================================
-- MINIMIZAR Y TECLA J (CORREGIDO)
-- =====================================
local minimizedButton
local function createMinimizedButton()
	if minimizedButton then return end
	minimizedButton = Instance.new("TextButton")
	minimizedButton.Size = UDim2.new(0,60,0,40)
	minimizedButton.Position = UDim2.new(0,10,0,10)
	minimizedButton.Text = "JH"
	minimizedButton.Font = Enum.Font.GothamBold
	minimizedButton.TextSize = 16
	minimizedButton.TextColor3 = Color3.fromRGB(255,255,255)
	minimizedButton.BackgroundColor3 = Color3.fromRGB(35,40,55)
	minimizedButton.BorderSizePixel = 0
	minimizedButton.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0,10)
	corner.Parent = minimizedButton

	minimizedButton.MouseButton1Click:Connect(function()
		hubContainer.Visible = true
		hubContainer.Size = UDim2.new(0,500,0,330) -- tamaño original
		minimizedButton:Destroy()
		minimizedButton = nil
	end)
end

local function minimizeHub()
	hubContainer.Visible = false
	createMinimizedButton()
end

close.MouseButton1Click:Connect(minimizeHub)

-- TECLA Z para abrir/cerrar
UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.Z then
		if hubContainer.Visible then
			minimizeHub()
		else
			if minimizedButton then
				hubContainer.Visible = true
				hubContainer.Size = UDim2.new(0,500,0,330) -- tamaño original
				minimizedButton:Destroy()
				minimizedButton = nil
			end
		end
	end
end)

