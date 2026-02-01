local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- === GUI Principal ===
local gui = Instance.new("ScreenGui")
gui.Name = "JulioHubGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Hub container
local hubContainer = Instance.new("Frame")
hubContainer.Size = UDim2.new(0,500,0,330)
hubContainer.Position = UDim2.new(0.5,-250,0.5,-165)
hubContainer.BackgroundColor3 = Color3.fromRGB(18,20,25)
hubContainer.BorderSizePixel = 0
hubContainer.Visible = true
hubContainer.Parent = gui

local hubCorner = Instance.new("UICorner")
hubCorner.CornerRadius = UDim.new(0,10)
hubCorner.Parent = hubContainer

-- Botón Minimizado (JH) - CUADRADO Y ARRIBA A LA IZQUIERDA
local openBtn = Instance.new("TextButton")
openBtn.Name = "OpenButton"
openBtn.Size = UDim2.new(0,50,0,50)
openBtn.Position = UDim2.new(0,15,0,15) -- Esquina superior izquierda
openBtn.BackgroundColor3 = Color3.fromRGB(22,25,32)
openBtn.Text = "JH"
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 18
openBtn.TextColor3 = Color3.fromRGB(120,190,255)
openBtn.Visible = false
openBtn.Parent = gui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0,8) -- Cuadrado con bordes suaves
btnCorner.Parent = openBtn

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(120,190,255)
btnStroke.Thickness = 2
btnStroke.Parent = openBtn

-- Top bar (Draggable)
local top = Instance.new("Frame")
top.Size = UDim2.new(1,0,0,40)
top.BackgroundColor3 = Color3.fromRGB(22,25,32)
top.Parent = hubContainer

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0,10)
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

local close = Instance.new("TextButton")
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,5)
close.Text = "–"
close.Font = Enum.Font.GothamBold
close.TextSize = 20
close.TextColor3 = Color3.fromRGB(255,100,100)
close.BackgroundTransparency = 1
close.Parent = top

-- Lógica para arrastrar (Hub y Botón JH)
local function makeDraggable(obj, handle)
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

makeDraggable(hubContainer, top)
makeDraggable(openBtn, openBtn)

-- Lógica de Visibilidad (Minimizar/Maximizar)
local function toggleUI()
    if hubContainer.Visible then
        hubContainer.Visible = false
        openBtn.Visible = true
    else
        hubContainer.Visible = true
        openBtn.Visible = false
    end
end

close.MouseButton1Click:Connect(toggleUI)
openBtn.MouseButton1Click:Connect(toggleUI)

UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.Z then
        toggleUI()
    end
end)

-- === Menú Lateral ===
local side = Instance.new("Frame")
side.Size = UDim2.new(0,140,1,-40)
side.Position = UDim2.new(0,0,0,40)
side.BackgroundColor3 = Color3.fromRGB(15,17,22)
side.Parent = hubContainer

local sideList = Instance.new("UIListLayout")
sideList.Parent = side

-- === Panel Contenido ===
local content = Instance.new("Frame")
content.Size = UDim2.new(1,-140,1,-40)
content.Position = UDim2.new(0,140,0,40)
content.BackgroundTransparency = 1
content.Parent = hubContainer

-- === FUNCIONES DE CREACIÓN ===
local function createTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,45)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(200,200,200)
    btn.BackgroundColor3 = Color3.fromRGB(20,23,30)
    btn.BorderSizePixel = 0
    btn.Parent = side

    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundTransparency = 1
    frame.ScrollBarThickness = 2
    frame.Visible = false
    frame.Parent = content
    
    local list = Instance.new("UIListLayout")
    list.Parent = frame
    list.Padding = UDim.new(0,8)
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local padding = Instance.new("UIPadding")
    padding.Parent = frame
    padding.PaddingTop = UDim.new(0,10)

    btn.MouseButton1Click:Connect(function()
        for _, f in pairs(content:GetChildren()) do if f:IsA("ScrollingFrame") then f.Visible = false end end
        for _, b in pairs(side:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(200,200,200) end end
        frame.Visible = true
        btn.TextColor3 = Color3.fromRGB(120,190,255)
    end)

    return btn, frame
end

local function createButton(parent, text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9,0,0,40)
    btn.Text = text
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(35,40,55)
    btn.BorderSizePixel = 0
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60,120,255)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35,40,55)}):Play()
    end)
    
    return btn
end

-- === TABS ===
local mainBtn, mainContent = createTab("MAIN")
local playerBtn, playerContent = createTab("PLAYER")
mainContent.Visible = true

-- === BOTONES MAIN ===
local dupeBtn = createButton(mainContent, "DUPE TOOL")
local antiBtn = createButton(mainContent, "ANTI-AFK: ON")

-- === BOTONES PLAYER ===
local tpBtn = createButton(playerContent, "TELEPORTS ↓")
local flyBtn = createButton(playerContent, "FLY: OFF")
local speedBtn = createButton(playerContent, "SPEED BOOST: 16")
local infBtn = createButton(playerContent, "INFINITE JUMP: OFF")

-- === SUB-PESTAÑA TELEPORTS ===
local areaPanel = Instance.new("Frame")
areaPanel.Size = UDim2.new(0.9,0,0,0)
areaPanel.BackgroundColor3 = Color3.fromRGB(25,28,35)
areaPanel.ClipsDescendants = true
areaPanel.Parent = playerContent
areaPanel.LayoutOrder = 1 

local areaList = Instance.new("UIListLayout")
areaList.Parent = areaPanel
areaList.Padding = UDim.new(0,3)

local areas = {
    {name="Common Area", pos=Vector3.new(206,-2.7,0)},
    {name="Rare Area", pos=Vector3.new(404,-2.7,0)},
    {name="Legendary Area", pos=Vector3.new(762,-2.7,0)},
    {name="Secret Area", pos=Vector3.new(2279,-2.7,0)},
    {name="Mythic Area", pos=Vector3.new(1084,-2.7,0)},
    {name="Cosmic Area", pos=Vector3.new(1574,-2.7,0)},
    {name="Celestial Area", pos=Vector3.new(2634,-2.7,0)},
}

for _, data in ipairs(areas) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,0,0,30)
    b.BackgroundColor3 = Color3.fromRGB(45,50,65)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 12
    b.Text = data.name
    b.Parent = areaPanel
    Instance.new("UICorner", b)
    
    b.MouseButton1Click:Connect(function()
        if player.Character then player.Character.HumanoidRootPart.CFrame = CFrame.new(data.pos) end
    end)
end

local areaOpen = false
tpBtn.MouseButton1Click:Connect(function()
    areaOpen = not areaOpen
    local targetSize = areaOpen and (#areas * 33) or 0
    TweenService:Create(areaPanel, TweenInfo.new(0.3), {Size = UDim2.new(0.9,0,0,targetSize)}):Play()
    tpBtn.Text = areaOpen and "TELEPORTS ↑" or "TELEPORTS ↓"
end)

-- === LÓGICA SPEED BOOST (40, 100, 300) ===
local speedOptions = {16, 40, 100, 300}
local currentIdx = 1

speedBtn.MouseButton1Click:Connect(function()
    currentIdx = currentIdx + 1
    if currentIdx > #speedOptions then currentIdx = 1 end
    
    local newSpeed = speedOptions[currentIdx]
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = newSpeed
    end
    speedBtn.Text = "SPEED BOOST: "..newSpeed
end)

-- === LÓGICA DE VUELO (FLY) ===
local flying = false
local flySpeed = 150
local bv, bg

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = "FLY: "..(flying and "ON" or "OFF")
    
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    if flying then
        bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0,0,0)
        
        bg = Instance.new("BodyGyro", hrp)
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.CFrame = hrp.CFrame
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)

RunService.RenderStepped:Connect(function()
    if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local cam = workspace.CurrentCamera
        local dir = Vector3.new()
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0,1,0) end
        
        bv.Velocity = (dir.Magnitude > 0 and dir.Unit * flySpeed) or Vector3.new(0,0,0)
        bg.CFrame = cam.CFrame
    end
end)

-- === OTRAS FUNCIONES ===
-- Anti-AFK
local antiAFK = true
antiBtn.MouseButton1Click:Connect(function()
    antiAFK = not antiAFK
    antiBtn.Text = "ANTI-AFK: "..(antiAFK and "ON" or "OFF")
end)

player.Idled:Connect(function()
    if antiAFK then game:GetService("VirtualUser"):CaptureController(); game:GetService("VirtualUser"):ClickButton2(Vector2.new()) end
end)

-- Infinite Jump
local infJ = false
infBtn.MouseButton1Click:Connect(function() infJ = not infJ; infBtn.Text = "INFINITE JUMP: "..(infJ and "ON" or "OFF") end)
UIS.JumpRequest:Connect(function()
    if infJ and player.Character then player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(3) end
end)

-- Dupe
dupeBtn.MouseButton1Click:Connect(function()
    local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
    if tool then tool:Clone().Parent = player.Backpack end
end)

-- Actualizar CanvasSize para los Scrolls
RunService.Heartbeat:Connect(function()
    mainContent.CanvasSize = UDim2.new(0,0,0, mainContent.UIListLayout.AbsoluteContentSize.Y + 20)
    playerContent.CanvasSize = UDim2.new(0,0,0, playerContent.UIListLayout.AbsoluteContentSize.Y + 20)
end)
