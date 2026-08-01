-- Them dong/mo menu bang phim (vi du: phim Insert)  
local Players = game:GetService("Players")  
local player = Players.LocalPlayer  
local gui = Instance.new("ScreenGui")  
gui.Name = "HackMenu"  
gui.Parent = player:WaitForChild("PlayerGui")  
gui.Enabled = false  -- mac dinh tat  

local frame = Instance.new("Frame")  
frame.Size = UDim2.new(0, 300, 0, 200)  
frame.Position = UDim2.new(0.5, -150, 0.5, -100)  
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.15)  
frame.Visible = true  
frame.Parent = gui  

local states = {  
   TargetLock = false,  
   LineOfSight = false,  
   RadarESP = false  
}  

local function makeToggle(name, yPos, stateKey)  
   local btn = Instance.new("TextButton")  
   btn.Size = UDim2.new(0.9, 0, 0, 30)  
   btn.Position = UDim2.new(0.05, 0, 0, yPos)  
   btn.Text = name .. ": OFF"  
   btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)  
   btn.TextColor3 = Color3.new(1, 1, 1)  
   btn.Parent = frame  
   btn.MouseButton1Click:Connect(function()  
      states[stateKey] = not states[stateKey]  
      btn.Text = name .. ": " .. (states[stateKey] and "ON" or "OFF")  
   end)  
end  

makeToggle("Khoa muc tieu", 40, "TargetLock")  
makeToggle("Tam nhin", 80, "LineOfSight")  
makeToggle("Radar/ESP", 120, "RadarESP")  

-- Nut dong menu (tren goc phai)  
local closeBtn = Instance.new("TextButton")  
closeBtn.Size = UDim2.new(0, 25, 0, 25)  
closeBtn.Position = UDim2.new(1, -30, 0, 5)  
closeBtn.Text = "X"  
closeBtn.BackgroundColor3 = Color3.new(0.8, 0.1, 0.1)  
closeBtn.TextColor3 = Color3.new(1, 1, 1)  
closeBtn.Parent = frame  
closeBtn.MouseButton1Click:Connect(function()  
   gui.Enabled = false  
end)  

-- Ham raycasting  
local Workspace = game:GetService("Workspace")  
local function hasLineOfSight(origin, targetPos, ignoreList)  
   local params = RaycastParams.new()  
   params.FilterType = Enum.RaycastFilterType.Blacklist  
   params.FilterDescendantsInstances = ignoreList or {}  
   local direction = (targetPos - origin).Unit * (origin - targetPos).Magnitude  
   local result = Workspace:Raycast(origin, direction, params)  
   return result == nil  
end  

-- Dieu huong camera Lerp  
local RunService = game:GetService("RunService")  
local camera = Workspace.CurrentCamera  
local function smoothLookAt(targetPos, alpha)  
   local currentCF = camera.CFrame  
   local lookAtCF = CFrame.new(camera.CFrame.Position, targetPos)  
   camera.CFrame = currentCF:Lerp(lookAtCF, alpha or 0.2)  
end  

local function getNearestLivingHead()  
   local nearest = nil  
   local minDist = math.huge  
   for _, p in pairs(Players:GetPlayers()) do  
      if p ~= player and p.Character and p.Character:FindFirstChild("Head") then  
         local headPos = p.Character.Head.Position  
         local dist = (headPos - camera.CFrame.Position).Magnitude  
         if dist < minDist then  
            minDist = dist  
            nearest = p.Character.Head  
         end  
      end  
   end  
   return nearest  
end  

-- Phim bat/tat menu (Insert)  
local UserInputService = game:GetService("UserInputService")  
UserInputService.InputBegan:Connect(function(input, gameProcessed)  
   if gameProcessed then return end  
   if input.KeyCode == Enum.KeyCode.Insert then  
      gui.Enabled = not gui.Enabled  
   end  
end)  

-- Vong lap chinh  
RunService.RenderStepped:Connect(function()  
   if states.TargetLock and gui.Enabled then  
      local targetHead = getNearestLivingHead()  
      if targetHead then  
         smoothLookAt(targetHead.Position, 0.15)  
      end  
   end  
end)      gui.Name = "NexusHub"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = LocalPlayer:FindFirstChild("PlayerGui") or game:GetService("CoreGui")
    
    -- Main Frame
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 340, 0, 500)
    frame.Position = UDim2.new(0, 20, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    frame.BackgroundTransparency = 0.08
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(0, 200, 255)
    frame.ClipsDescendants = true
    frame.Parent = gui
    
    -- Drag bar
    local dragBar = Instance.new("Frame")
    dragBar.Size = UDim2.new(1, 0, 0, 35)
    dragBar.Position = UDim2.new(0, 0, 0, 0)
    dragBar.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    dragBar.BackgroundTransparency = 0.3
    dragBar.BorderSizePixel = 0
    dragBar.Parent = frame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚡ NEXUS HUB ⚡"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = dragBar
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 1, 0)
    closeBtn.Position = UDim2.new(1, -30, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = dragBar
    closeBtn.MouseButton1Click:Connect(function()
        menuVisible = false
        frame.Visible = false
    end)
    
    -- Scroll container
    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, -10, 1, -45)
    container.Position = UDim2.new(0, 5, 0, 40)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.ScrollBarThickness = 4
    container.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
    container.Parent = frame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = container
    
    -- Tao Toggle
    local function createToggle(label, defaultValue, callback)
        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(1, 0, 0, 34)
        bg.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        bg.BackgroundTransparency = 0.5
        bg.BorderSizePixel = 1
        bg.BorderColor3 = Color3.fromRGB(50, 50, 70)
        bg.Parent = container
        
        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, -80, 1, 0)
        text.Position = UDim2.new(0, 10, 0, 0)
        text.BackgroundTransparency = 1
        text.Text = label
        text.TextColor3 = Color3.fromRGB(220, 220, 230)
        text.TextSize = 14
        text.TextXAlignment = Enum.TextXAlignment.Left
        text.Font = Enum.Font.Gotham
        text.Parent = bg
        
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 60, 0, 26)
        toggleBtn.Position = UDim2.new(1, -70, 0.5, -13)
        toggleBtn.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 220, 100) or Color3.fromRGB(220, 50, 50)
        toggleBtn.BorderSizePixel = 0
        toggleBtn.Text = defaultValue and "ON" or "OFF"
        toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleBtn.TextSize = 12
        toggleBtn.Font = Enum.Font.GothamBold
        toggleBtn.Parent = bg
        
        local status = defaultValue
        toggleBtn.MouseButton1Click:Connect(function()
            status = not status
            toggleBtn.BackgroundColor3 = status and Color3.fromRGB(0, 220, 100) or Color3.fromRGB(220, 50, 50)
            toggleBtn.Text = status and "ON" or "OFF"
            if callback then callback(status) end
        end)
        
        return { Toggle = toggleBtn, GetValue = function() return status end }
    end
    
    -- Tao Slider
    local function createSlider(label, minVal, maxVal, defaultValue, callback)
        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(1, 0, 0, 44)
        bg.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        bg.BackgroundTransparency = 0.5
        bg.BorderSizePixel = 1
        bg.BorderColor3 = Color3.fromRGB(50, 50, 70)
        bg.Parent = container
        
        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 0, 18)
        text.Position = UDim2.new(0, 10, 0, 2)
        text.BackgroundTransparency = 1
        text.Text = label .. ": " .. tostring(defaultValue)
        text.TextColor3 = Color3.fromRGB(200, 200, 210)
        text.TextSize = 13
        text.TextXAlignment = Enum.TextXAlignment.Left
        text.Font = Enum.Font.Gotham
        text.Parent = bg
        
        local slider = Instance.new("Frame")
        slider.Size = UDim2.new(1, -20, 0, 14)
        slider.Position = UDim2.new(0, 10, 0, 24)
        slider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        slider.BorderSizePixel = 0
        slider.Parent = bg
        
        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((defaultValue - minVal) / (maxVal - minVal), 0, 1, 0)
        fill.Position = UDim2.new(0, 0, 0, 0)
        fill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        fill.BorderSizePixel = 0
        fill.Parent = slider
        
        local value = defaultValue
        local function updateSlider(val)
            value = math.clamp(val, minVal, maxVal)
            fill.Size = UDim2.new((value - minVal) / (maxVal - minVal), 0, 1, 0)
            text.Text = label .. ": " .. tostring(math.round(value))
            if callback then callback(math.round(value)) end
        end
        
        slider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local pos = input.Position.X - slider.AbsolutePosition.X
                local pct = math.clamp(pos / slider.AbsoluteSize.X, 0, 1)
                updateSlider(minVal + pct * (maxVal - minVal))
            end
        end)
        
        slider.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                    local pos = input.Position.X - slider.AbsolutePosition.X
                    local pct = math.clamp(pos / slider.AbsoluteSize.X, 0, 1)
                    updateSlider(minVal + pct * (maxVal - minVal))
                end
            end
        end)
        
        return { Slider = slider, GetValue = function() return value end }
    end
    
    -- ===== THEM CAC CHUC NANG =====
    local toggles = {}
    local sliders = {}
    
    table.insert(toggles, createToggle("GodMode", CONFIG.GodMode, function(v) CONFIG.GodMode = v end))
    table.insert(toggles, createToggle("Anti Stun", CONFIG.AntiStun, function(v) CONFIG.AntiStun = v end))
    table.insert(toggles, createToggle("No Fall DMG", CONFIG.NoFallDamage, function(v) CONFIG.NoFallDamage = v end))
    table.insert(toggles, createToggle("Walk Water", CONFIG.WalkOnWater, function(v) CONFIG.WalkOnWater = v end))
    
    -- Separator
    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, 0, 0, 2)
    sep.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    sep.BackgroundTransparency = 0.5
    sep.BorderSizePixel = 0
    sep.Parent = container
    
    local espLabel = Instance.new("TextLabel")
    espLabel.Size = UDim2.new(1, 0, 0, 20)
    espLabel.BackgroundTransparency = 1
    espLabel.Text = "═══ ESP ═══"
    espLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    espLabel.TextSize = 14
    espLabel.Font = Enum.Font.GothamBold
    espLabel.Parent = container
    
    table.insert(toggles, createToggle("ESP", CONFIG.ShowESP, function(v) CONFIG.ShowESP = v end))
    table.insert(toggles, createToggle("Box", CONFIG.ShowBox, function(v) CONFIG.ShowBox = v end))
    table.insert(toggles, createToggle("Tracer", CONFIG.ShowTracer, function(v) CONFIG.ShowTracer = v end))
    table.insert(toggles, createToggle("Name", CONFIG.ShowName, function(v) CONFIG.ShowName = v end))
    table.insert(toggles, createToggle("Distance", CONFIG.ShowDistance, function(v) CONFIG.ShowDistance = v end))
    table.insert(toggles, createToggle("Health Bar", CONFIG.ShowHealthBar, function(v) CONFIG.ShowHealthBar = v end))
    
    table.insert(sliders, createSlider("Speed", 16, 300, CONFIG.Speed, function(v) CONFIG.Speed = v end))
    table.insert(sliders, createSlider("Jump Power", 20, 250, CONFIG.JumpPower, function(v) CONFIG.JumpPower = v end))
    table.insert(sliders, createSlider("ESP Dist", 100, 1000, CONFIG.MaxDistance, function(v) CONFIG.MaxDistance = v end))
    
    -- Update canvas
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    
    -- DRAG
    dragBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragData.dragging = true
            dragData.offset = Vector2.new(input.Position.X - frame.AbsolutePosition.X, input.Position.Y - frame.AbsolutePosition.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragData.dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragData.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local newX = math.clamp(input.Position.X - dragData.offset.X, 0, Camera.ViewportSize.X - frame.AbsoluteSize.X)
            local newY = math.clamp(input.Position.Y - dragData.offset.Y, 0, Camera.ViewportSize.Y - frame.AbsoluteSize.Y)
            frame.Position = UDim2.new(0, newX, 0, newY)
        end
    end)
    
    -- F1 Toggle
    UserInputService.InputBegan:Connect(function(input, gP)
        if gP then return end
        if input.KeyCode == Enum.KeyCode.F1 then
            menuVisible = not menuVisible
            frame.Visible = menuVisible
        end
    end)
    
    return gui
end

-- ===== ESP ENGINE (GIU NGUYEN) =====
local function createESP(player)
    if not player or player == LocalPlayer then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    if not hrp or not head then return end
    
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Filled = false
    box.Transparency = 0.8
    box.Color = Color3.fromRGB(0, 180, 255)
    box.Visible = false
    
    local tracer = Drawing.new("Line")
    tracer.Thickness = 1.5
    tracer.Transparency = 0.6
    tracer.Color = Color3.fromRGB(0, 180, 255)
    tracer.Visible = false
    
    local nameText = Drawing.new("Text")
    nameText.Size = 14
    nameText.Center = true
    nameText.Outline = true
    nameText.OutlineColor = Color3.fromRGB(0, 0, 0)
    nameText.Color = Color3.fromRGB(255, 255, 255)
    nameText.Visible = false
    
    local distText = Drawing.new("Text")
    distText.Size = 12
    distText.Center = true
    distText.Outline = true
    distText.OutlineColor = Color3.fromRGB(0, 0, 0)
    distText.Color = Color3.fromRGB(200, 200, 200)
    distText.Visible = false
    
    local healthBg = Drawing.new("Square")
    healthBg.Thickness = 0
    healthBg.Filled = true
    healthBg.Color = Color3.fromRGB(30, 30, 30)
    healthBg.Transparency = 0.7
    healthBg.Visible = false
    
    local healthFill = Drawing.new("Square")
    healthFill.Thickness = 0
    healthFill.Filled = true
    healthFill.Color = Color3.fromRGB(0, 255, 0)
    healthFill.Transparency = 0.8
    healthFill.Visible = false
    
    espObjects[player] = {
        Box = box, Tracer = tracer, Name = nameText, Dist = distText,
        HealthBg = healthBg, HealthFill = healthFill,
        Character = char, Hrp = hrp, Head = head
    }
end

local function updateESP()
    if not CONFIG.ShowESP then
        for _, data in pairs(espObjects) do
            data.Box.Visible = false; data.Tracer.Visible = false
            data.Name.Visible = false; data.Dist.Visible = false
            data.HealthBg.Visible = false; data.HealthFill.Visible = false
        end
        return
    end
    
    local viewport = Camera.ViewportSize
    local center = Vector2.new(viewport.X / 2, viewport.Y)
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if not espObjects[plr] then createESP(plr) end
        end
    end
    
    for plr, data in pairs(espObjects) do
        if not plr.Parent or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
            data.Box:Remove(); data.Tracer:Remove(); data.Name:Remove()
            data.Dist:Remove(); data.HealthBg:Remove(); data.HealthFill:Remove()
            espObjects[plr] = nil
        end
    end
    
    for plr, data in pairs(espObjects) do
        if not data.Hrp or not data.Hrp.Parent then continue end
        local pos = data.Hrp.Position
        local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
        local distance = (Camera.CFrame.Position - pos).Magnitude
        
        if not onScreen or distance > CONFIG.MaxDistance then
            data.Box.Visible = false; data.Tracer.Visible = false
            data.Name.Visible = false; data.Dist.Visible = false
            data.HealthBg.Visible = false; data.HealthFill.Visible = false
            continue
        end
        
        local isTeammate = (plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team)
        local mainColor = isTeammate and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
        local scale = 300 / (distance + 1)
        local boxHeight = math.clamp(scale * 2.5, 20, 200)
        local boxWidth = math.clamp(scale * 1.2, 15, 100)
        
        if CONFIG.ShowBox then
            data.Box.Position = Vector2.new(screenPos.X - boxWidth/2, screenPos.Y - boxHeight)
            data.Box.Size = Vector2.new(boxWidth, boxHeight)
            data.Box.Color = mainColor
            data.Box.Visible = true
        else data.Box.Visible = false end
        
        if CONFIG.ShowTracer then
            data.Tracer.From = center
            data.Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
            data.Tracer.Color = mainColor
            data.Tracer.Visible = true
        else data.Tracer.Visible = false end
        
        if CONFIG.ShowName then
            data.Name.Text = plr.Name
            data.Name.Position = Vector2.new(screenPos.X, screenPos.Y - boxHeight - 20)
            data.Name.Color = mainColor
            data.Name.Visible = true
        else data.Name.Visible = false end
        
        if CONFIG.ShowDistance then
            data.Dist.Text = math.floor(distance/3) .. "m"
            data.Dist.Position = Vector2.new(screenPos.X, screenPos.Y + 10)
            data.Dist.Visible = true
        else data.Dist.Visible = false end
        
        if CONFIG.ShowHealthBar then
            local hp = 100
            local hum = data.Character:FindFirstChild("Humanoid")
            if hum then hp = (hum.Health / hum.MaxHealth) * 100 end
            hp = math.clamp(hp, 0, 100)
            local barWidth = boxWidth
            local barX = screenPos.X - barWidth/2
            local barY = screenPos.Y + 5
            data.HealthBg.Position = Vector2.new(barX, barY)
            data.HealthBg.Size = Vector2.new(barWidth, 4)
            data.HealthBg.Visible = true
            data.HealthFill.Position = Vector2.new(barX, barY)
            data.HealthFill.Size = Vector2.new((hp/100) * barWidth, 4)
            data.HealthFill.Color = hp > 50 and Color3.fromRGB(0, 255, 0) or hp > 25 and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 0, 0)
            data.HealthFill.Visible = true
        else
            data.HealthBg.Visible = false
            data.HealthFill.Visible = false
        end
    end
end

-- ===== CHEAT ENGINE =====
local function applyCheats()
    if not humanoid then return end
    if CONFIG.GodMode then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        humanoid.BreakJointsOnDeath = false
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end
    if CONFIG.AntiStun then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        humanoid.Sit = false
    end
    if CONFIG.NoFallDamage then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    end
    humanoid.WalkSpeed = CONFIG.Speed
    humanoid.JumpPower = CONFIG.JumpPower
    if CONFIG.WalkOnWater and rootPart then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.Buoyancy = 0.5 end
        end
    end
end

local function getCharacter()
    character = LocalPlayer.Character
    if character then
        humanoid = character:FindFirstChild("Humanoid")
        rootPart = character:FindFirstChild("HumanoidRootPart")
    end
    return character
end

-- ===== START =====
createModernMenu()

RunService.RenderStepped:Connect(function()
    if not getCharacter() then
        LocalPlayer.CharacterAdded:Connect(function()
            wait(0.5)
            getCharacter()
            applyCheats()
        end)
        return
    end
    applyCheats()
    updateESP()
end)

print("[+] NEXUS HUB V2 LOADED")
print("[+] F1: Toggle Menu")
print("[+] Drag title bar de di chuyen")
print("[+] Click Close (✕) de dong menu")local rootPart = nil
local espObjects = {}
local menuVisible = true

-- ===== KHOI TAO DRAWING =====
local function createDrawingMenu()
    local screenSize = Vector2.new(1920, 1080)
    if Drawing and Drawing.FontSize then
        screenSize = Vector2.new(Drawing.FontSize * 120, Drawing.FontSize * 80)
    end
    
    -- Khung menu
    local mainBox = Drawing.new("Square")
    mainBox.Thickness = 2
    mainBox.Filled = true
    mainBox.Color = Color3.fromRGB(20, 20, 30)
    mainBox.Transparency = 0.92
    mainBox.Position = Vector2.new(10, 10)
    mainBox.Size = Vector2.new(300, 480)
    mainBox.Visible = true
    
    local border = Drawing.new("Square")
    border.Thickness = 2
    border.Filled = false
    border.Color = Color3.fromRGB(0, 180, 255)
    border.Transparency = 0.6
    border.Position = Vector2.new(10, 10)
    border.Size = Vector2.new(300, 480)
    border.Visible = true
    
    -- Title
    local title = Drawing.new("Text")
    title.Size = 20
    title.Center = true
    title.Outline = true
    title.OutlineColor = Color3.fromRGB(0, 0, 0)
    title.Color = Color3.fromRGB(0, 180, 255)
    title.Position = Vector2.new(160, 25)
    title.Text = "⚡ NEXUS HUB ⚡"
    title.Visible = true
    
    -- Cac muc
    local items = {}
    local yPos = 55
    local function addToggle(label, default, callback)
        local bg = Drawing.new("Square")
        bg.Thickness = 1
        bg.Filled = true
        bg.Color = Color3.fromRGB(40, 40, 50)
        bg.Transparency = 0.8
        bg.Position = Vector2.new(20, yPos)
        bg.Size = Vector2.new(260, 32)
        bg.Visible = true
        
        local text = Drawing.new("Text")
        text.Size = 14
        text.Center = false
        text.Outline = true
        text.OutlineColor = Color3.fromRGB(0, 0, 0)
        text.Color = default and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
        text.Position = Vector2.new(30, yPos + 6)
        text.Text = label .. " [" .. (default and "ON" or "OFF") .. "]"
        text.Visible = true
        
        local status = default
        table.insert(items, {
            Background = bg,
            Text = text,
            Toggle = function()
                status = not status
                text.Color = status and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
                text.Text = label .. " [" .. (status and "ON" or "OFF") .. "]"
                if callback then callback(status) end
                return status
            end,
            GetValue = function() return status end
        })
        yPos = yPos + 38
    end
    
    local function addSlider(label, minVal, maxVal, default, callback)
        local bg = Drawing.new("Square")
        bg.Thickness = 1
        bg.Filled = true
        bg.Color = Color3.fromRGB(40, 40, 50)
        bg.Transparency = 0.8
        bg.Position = Vector2.new(20, yPos)
        bg.Size = Vector2.new(260, 32)
        bg.Visible = true
        
        local text = Drawing.new("Text")
        text.Size = 13
        text.Center = false
        text.Outline = true
        text.OutlineColor = Color3.fromRGB(0, 0, 0)
        text.Color = Color3.fromRGB(200, 200, 200)
        text.Position = Vector2.new(30, yPos + 6)
        text.Text = label .. ": " .. tostring(default)
        text.Visible = true
        
        local value = default
        table.insert(items, {
            Background = bg,
            Text = text,
            SetValue = function(v)
                value = math.clamp(v, minVal, maxVal)
                text.Text = label .. ": " .. tostring(value)
                if callback then callback(value) end
            end,
            GetValue = function() return value end,
            Increase = function(amount)
                value = math.clamp(value + amount, minVal, maxVal)
                text.Text = label .. ": " .. tostring(value)
                if callback then callback(value) end
            end
        })
        yPos = yPos + 38
    end
    
    -- Them cac toggle
    addToggle("GodMode", CONFIG.GodMode, function(v) CONFIG.GodMode = v end)
    addToggle("Anti Stun", CONFIG.AntiStun, function(v) CONFIG.AntiStun = v end)
    addToggle("No Fall DMG", CONFIG.NoFallDamage, function(v) CONFIG.NoFallDamage = v end)
    addToggle("Walk Water", CONFIG.WalkOnWater, function(v) CONFIG.WalkOnWater = v end)
    addToggle("ESP", CONFIG.ShowESP, function(v) CONFIG.ShowESP = v end)
    addToggle("ESP Box", CONFIG.ShowBox, function(v) CONFIG.ShowBox = v end)
    addToggle("ESP Tracer", CONFIG.ShowTracer, function(v) CONFIG.ShowTracer = v end)
    addToggle("ESP Name", CONFIG.ShowName, function(v) CONFIG.ShowName = v end)
    addToggle("ESP Health", CONFIG.ShowHealthBar, function(v) CONFIG.ShowHealthBar = v end)
    
    addSlider("Speed", 16, 300, CONFIG.Speed, function(v) CONFIG.Speed = v end)
    addSlider("Jump", 20, 250, CONFIG.JumpPower, function(v) CONFIG.JumpPower = v end)
    addSlider("ESP Dist", 100, 1000, CONFIG.MaxDistance, function(v) CONFIG.MaxDistance = v end)
    
    -- Xu ly click
    local function handleClick(pos)
        local x, y = pos.X, pos.Y
        if x < 10 or x > 310 or y < 10 or y > 490 then return end
        
        for _, item in pairs(items) do
            local bg = item.Background
            if bg and x >= bg.Position.X and x <= bg.Position.X + bg.Size.X and
               y >= bg.Position.Y and y <= bg.Position.Y + bg.Size.Y then
                if item.Toggle then
                    item.Toggle()
                elseif item.Increase then
                    if x < bg.Position.X + 80 then
                        item.Increase(-5)
                    elseif x > bg.Position.X + 180 then
                        item.Increase(5)
                    else
                        item.Increase(1)
                    end
                end
                break
            end
        end
    end
    
    -- Phim tat F1 de an menu
    UserInputService.InputBegan:Connect(function(input, gP)
        if gP then return end
        if input.KeyCode == Enum.KeyCode.F1 then
            menuVisible = not menuVisible
            mainBox.Visible = menuVisible
            border.Visible = menuVisible
            title.Visible = menuVisible
            for _, item in pairs(items) do
                if item.Background then item.Background.Visible = menuVisible end
                if item.Text then item.Text.Visible = menuVisible end
            end
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input, gP)
        if gP then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            handleClick(Vector2.new(input.Position.X, input.Position.Y))
        end
    end)
    
    return { Items = items }
end

-- ===== ESP ENGINE =====
local function createESP(player)
    if not player or player == LocalPlayer then return end
    local char = player.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    if not hrp or not head then return end
    
    -- Box
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Filled = false
    box.Transparency = 0.8
    box.Color = Color3.fromRGB(0, 180, 255)
    box.Visible = false
    
    -- Tracer
    local tracer = Drawing.new("Line")
    tracer.Thickness = 1.5
    tracer.Transparency = 0.6
    tracer.Color = Color3.fromRGB(0, 180, 255)
    tracer.Visible = false
    
    -- Name
    local nameText = Drawing.new("Text")
    nameText.Size = 14
    nameText.Center = true
    nameText.Outline = true
    nameText.OutlineColor = Color3.fromRGB(0, 0, 0)
    nameText.Color = Color3.fromRGB(255, 255, 255)
    nameText.Visible = false
    
    -- Distance
    local distText = Drawing.new("Text")
    distText.Size = 12
    distText.Center = true
    distText.Outline = true
    distText.OutlineColor = Color3.fromRGB(0, 0, 0)
    distText.Color = Color3.fromRGB(200, 200, 200)
    distText.Visible = false
    
    -- Health bar
    local healthBg = Drawing.new("Square")
    healthBg.Thickness = 0
    healthBg.Filled = true
    healthBg.Color = Color3.fromRGB(30, 30, 30)
    healthBg.Transparency = 0.7
    healthBg.Visible = false
    
    local healthFill = Drawing.new("Square")
    healthFill.Thickness = 0
    healthFill.Filled = true
    healthFill.Color = Color3.fromRGB(0, 255, 0)
    healthFill.Transparency = 0.8
    healthFill.Visible = false
    
    espObjects[player] = {
        Box = box,
        Tracer = tracer,
        Name = nameText,
        Dist = distText,
        HealthBg = healthBg,
        HealthFill = healthFill,
        Character = char,
        Hrp = hrp,
        Head = head
    }
end

local function updateESP()
    if not CONFIG.ShowESP then
        -- An tat ca
        for _, data in pairs(espObjects) do
            data.Box.Visible = false
            data.Tracer.Visible = false
            data.Name.Visible = false
            data.Dist.Visible = false
            data.HealthBg.Visible = false
            data.HealthFill.Visible = false
        end
        return
    end
    
    local viewport = Camera.ViewportSize
    local center = Vector2.new(viewport.X / 2, viewport.Y)
    
    -- Tao moi cho player moi
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if not espObjects[plr] then
                createESP(plr)
            end
        end
    end
    
    -- Xoa player da mat
    for plr, data in pairs(espObjects) do
        if not plr.Parent or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
            data.Box:Remove()
            data.Tracer:Remove()
            data.Name:Remove()
            data.Dist:Remove()
            data.HealthBg:Remove()
            data.HealthFill:Remove()
            espObjects[plr] = nil
        end
    end
    
    -- Cap nhat vi tri
    for plr, data in pairs(espObjects) do
        if not data.Hrp or not data.Hrp.Parent then continue end
        
        local pos = data.Hrp.Position
        local headPos = data.Head and data.Head.Position or pos + Vector3.new(0, 2, 0)
        local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
        local screenHead, _ = Camera:WorldToViewportPoint(headPos)
        
        local distance = (Camera.CFrame.Position - pos).Magnitude
        
        if not onScreen or distance > CONFIG.MaxDistance then
            data.Box.Visible = false
            data.Tracer.Visible = false
            data.Name.Visible = false
            data.Dist.Visible = false
            data.HealthBg.Visible = false
            data.HealthFill.Visible = false
            continue
        end
        
        -- Mau theo team
        local isTeammate = (plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team)
        local mainColor = isTeammate and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
        if not CONFIG.ShowTeamColor then
            mainColor = Color3.fromRGB(0, 180, 255)
        end
        
        -- Scale
        local scale = 300 / (distance + 1)
        local boxHeight = math.clamp(scale * 2.5, 20, 200)
        local boxWidth = math.clamp(scale * 1.2, 15, 100)
        
        -- Box
        if CONFIG.ShowBox then
            data.Box.Position = Vector2.new(screenPos.X - boxWidth/2, screenPos.Y - boxHeight)
            data.Box.Size = Vector2.new(boxWidth, boxHeight)
            data.Box.Color = mainColor
            data.Box.Visible = true
        else
            data.Box.Visible = false
        end
        
        -- Tracer
        if CONFIG.ShowTracer then
            data.Tracer.From = center
            data.Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
            data.Tracer.Color = mainColor
            data.Tracer.Visible = true
        else
            data.Tracer.Visible = false
        end
        
        -- Name
        if CONFIG.ShowName then
            data.Name.Text = plr.Name
            data.Name.Position = Vector2.new(screenPos.X, screenPos.Y - boxHeight - 20)
            data.Name.Color = mainColor
            data.Name.Visible = true
        else
            data.Name.Visible = false
        end
        
        -- Distance
        if CONFIG.ShowDistance then
            data.Dist.Text = math.floor(distance/3) .. "m"
            data.Dist.Position = Vector2.new(screenPos.X, screenPos.Y + 10)
            data.Dist.Color = Color3.fromRGB(200, 200, 200)
            data.Dist.Visible = true
        else
            data.Dist.Visible = false
        end
        
        -- Health Bar
        if CONFIG.ShowHealthBar then
            local hp = 100
            local hum = data.Character:FindFirstChild("Humanoid")
            if hum then
                hp = (hum.Health / hum.MaxHealth) * 100
            end
            hp = math.clamp(hp, 0, 100)
            
            local barWidth = boxWidth
            local barHeight = 4
            local barX = screenPos.X - barWidth/2
            local barY = screenPos.Y + 5
            
            data.HealthBg.Position = Vector2.new(barX, barY)
            data.HealthBg.Size = Vector2.new(barWidth, barHeight)
            data.HealthBg.Visible = true
            
            local fillWidth = (hp / 100) * barWidth
            data.HealthFill.Position = Vector2.new(barX, barY)
            data.HealthFill.Size = Vector2.new(fillWidth, barHeight)
            data.HealthFill.Color = hp > 50 and Color3.fromRGB(0, 255, 0) or 
                                    hp > 25 and Color3.fromRGB(255, 255, 0) or 
                                    Color3.fromRGB(255, 0, 0)
            data.HealthFill.Visible = true
        else
            data.HealthBg.Visible = false
            data.HealthFill.Visible = false
        end
    end
end

-- ===== GODMODE ENGINE =====
local function applyCheats()
    if not humanoid then return end
    
    if CONFIG.GodMode then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        humanoid.BreakJointsOnDeath = false
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end
    
    if CONFIG.AntiStun then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        humanoid.Sit = false
    end
    
    if CONFIG.NoFallDamage then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    end
    
    humanoid.WalkSpeed = CONFIG.Speed
    humanoid.JumpPower = CONFIG.JumpPower
    
    if CONFIG.WalkOnWater and rootPart then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Buoyancy = 0.5
            end
        end
    end
end

-- ===== GET CHARACTER =====
local function getCharacter()
    character = LocalPlayer.Character
    if character then
        humanoid = character:FindFirstChild("Humanoid")
        rootPart = character:FindFirstChild("HumanoidRootPart")
    end
    return character
end

-- ===== MAIN LOOP =====
createDrawingMenu()

RunService.RenderStepped:Connect(function()
    if not getCharacter() then
        LocalPlayer.CharacterAdded:Connect(function()
            wait(0.5)
            getCharacter()
            applyCheats()
        end)
        return
    end
    applyCheats()
    updateESP()
end)

print("[+] NEXUS HUB LOADED")
print("[+] F1: Toggle Menu")
print("[+] ESP: Box, Tracer, Name, Distance, HealthBar")
print("[+] GodMode, Speed, Jump, AntiStun, NoFall, WalkWater")
