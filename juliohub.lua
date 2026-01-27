local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "JulioHubGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Hub principal con bordes redondos completos
local hubContainer = Instance.new("Frame")
hubContainer.Size = UDim2.new(0,500,0,330)
hubContainer.Position = UDim2.new(0.5,-250,0.25,0)
hubContainer.BackgroundColor3 = Color3.fromRGB(18,20,25)
hubContainer.BorderSizePixel = 0
hubContainer.Parent = gui

local hubCorner = Instance.new("UICorner")
hubCorner.CornerRadius = UDim.new(0,20)
hubCorner.Parent = hubContainer

-- Hub interno (contenido)
local hub = Instance.new("Frame")
hub.Size = UDim2.new(1,0,1,0)
hub.Position = UDim2.new(0,0,0,0)
hub.BackgroundTransparency = 1
hub.BorderSizePixel = 0
hub.Parent = hubContainer

-- Top bar
local top = Instance.new("Frame")
top.Parent = hub
top.Size = UDim2.new(1,0,0,40)
top.BackgroundColor3 = Color3.fromRGB(22,25,32)
top.BorderSizePixel = 0
top.Position = UDim2.new(0,0,0,0)

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0,20)
topCorner.Parent = top

local title = Instance.new("TextLabel")
title.Parent = top
title.Size = UDim2.new(1,-40,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "Julio Hub - Tsunami Brainroot"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(120,190,255)

-- Botón minimizar
local close = Instance.new("TextButton")
close.Parent = top
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,5)
close.Text = "–"
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.TextColor3 = Color3.fromRGB(255,100,100)
close.BackgroundTransparency = 1

-- Drag del hub
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
side.Parent = hub
side.Size = UDim2.new(0,140,1,-40)
side.Position = UDim2.new(0,0,0,40)
side.BackgroundColor3 = Color3.fromRGB(15,17,22)
side.BorderSizePixel = 0

local tab = Instance.new("TextLabel")
tab.Parent = side
tab.Size = UDim2.new(1,0,0,40)
tab.Text = "Main"
tab.Font = Enum.Font.GothamBold
tab.TextSize = 14
tab.TextColor3 = Color3.fromRGB(120,190,255)
tab.BackgroundTransparency = 1

local content = Instance.new("Frame")
content.Parent = hub
content.Size = UDim2.new(1,-140,1,-40)
content.Position = UDim2.new(0,140,0,40)
content.BackgroundColor3 = Color3.fromRGB(20,23,30)
content.BorderSizePixel = 0

-- DUPE button
local dupe = Instance.new("TextButton")
dupe.Parent = content
dupe.Size = UDim2.new(1,-30,0,45)
dupe.Position = UDim2.new(0,15,0,0)
dupe.Text = "DUPE"
dupe.Font = Enum.Font.GothamBlack
dupe.TextSize = 18
dupe.TextColor3 = Color3.fromRGB(255,255,255)
dupe.BackgroundColor3 = Color3.fromRGB(35,40,55)
dupe.BorderSizePixel = 0
dupe.AutoButtonColor = false

local dupeCorner = Instance.new("UICorner")
dupeCorner.CornerRadius = UDim.new(0,10)
dupeCorner.Parent = dupe

-- Glow y animación DUPE
dupe.MouseEnter:Connect(function()
	TweenService:Create(dupe, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60,120,255), Size = UDim2.new(1,-25,0,50)}):Play()
end)
dupe.MouseLeave:Connect(function()
	TweenService:Create(dupe, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35,40,55), Size = UDim2.new(1,-30,0,45)}):Play()
end)
dupe.MouseButton1Click:Connect(function()
	local tweenClick = TweenService:Create(dupe, TweenInfo.new(0.1), {Size = UDim2.new(1,-28,0,42)})
	tweenClick:Play()
	tweenClick.Completed:Wait()
	TweenService:Create(dupe, TweenInfo.new(0.1), {Size = UDim2.new(1,-30,0,45)}):Play()

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

-- Botón minimizar con animación y glow
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

	-- Glow hover
	minimizedButton.MouseEnter:Connect(function()
		TweenService:Create(minimizedButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60,120,255), Size = UDim2.new(0,65,0,45)}):Play()
	end)
	minimizedButton.MouseLeave:Connect(function()
		TweenService:Create(minimizedButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35,40,55), Size = UDim2.new(0,60,0,40)}):Play()
	end)

	-- Drag del botón JH
	local dragJH, startJH, startPosJH = false, nil, nil
	minimizedButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragJH = true
			startJH = input.Position
			startPosJH = minimizedButton.Position
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragJH and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - startJH
			minimizedButton.Position = UDim2.new(
				startPosJH.X.Scale,
				startPosJH.X.Offset + delta.X,
				startPosJH.Y.Scale,
				startPosJH.Y.Offset + delta.Y
			)
		end
	end)
	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragJH = false
		end
	end)

	minimizedButton.MouseButton1Click:Connect(function()
		hubContainer.Visible = true
		minimizedButton:Destroy()
		minimizedButton = nil
	end)
end

local function minimizeHub()
	-- Animación de encogimiento antes de ocultar
	local tween = TweenService:Create(hubContainer, TweenInfo.new(0.2), {Size = UDim2.new(0,50,0,33)})
	tween:Play()
	tween.Completed:Wait()
	hubContainer.Visible = false
	hubContainer.Size = UDim2.new(0,500,0,330)
	createMinimizedButton()
end

close.MouseButton1Click:Connect(minimizeHub)

-- Abrir/Cerrar con tecla J
UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.J then
		if hubContainer.Visible then
			minimizeHub()
		else
			if minimizedButton then
				hubContainer.Visible = true
				minimizedButton:Destroy()
				minimizedButton = nil
			end
		end
	end
end)
