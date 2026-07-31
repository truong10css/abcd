-- MENU + ESP DEP + GODMODE + SPEED + JUMP CHO ROBLOX
-- TUONG THICH: Synapse X, Krnl, Fluxus (ho tro Drawing)
-- CHUC NANG: Menu dep, ESP (Box, Tracer, Name, Distance, HealthBar, Skeleton)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

-- ===== CONFIG =====
local CONFIG = {
    -- Cheat
    Speed = 50,
    JumpPower = 80,
    GodMode = true,
    AntiStun = true,
    NoFallDamage = true,
    WalkOnWater = false,
    
    -- ESP
    ShowESP = true,
    ShowBox = true,
    ShowTracer = true,
    ShowName = true,
    ShowDistance = true,
    ShowHealthBar = true,
    ShowSkeleton = false,
    ShowTeamColor = true,
    MaxDistance = 500,
}

-- ===== BIEN =====
local character = nil
local humanoid = nil
local rootPart = nil
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
