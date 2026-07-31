-- ESP SCRIPT CHO ROBLOX (LUAU / SYNAPSE / KRNEL / SCRIPT-WARE)
-- CHE DO: Chay trong executor (Synapse X, Krnl, ScriptWare, v.v.)
-- CHUC NANG: Ve khung, duong thang, ten, khoang cach cho tat ca nguoi choi
-- KHONG CAN OFFSET - Su dung cac ham co ban cua Roblox API

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Cau hinh ESP
local ESP_CONFIG = {
    Box = true,          -- Ve khung
    Tracer = true,       -- Ve duong thang tu camera den nguoi choi
    Name = true,         -- Hien thi ten
    Distance = true,     -- Hien thi khoang cach
    HealthBar = true,    -- Hien thi thanh mau
    TeamCheck = true,    -- Che phan biet team (mau xanh cho dong doi, do cho ke dich)
    Color = Color3.fromRGB(255, 0, 0) -- Mau mac dinh (do)
}

-- Tao Drawing objects
local Drawing = Drawing or {}  -- Dung cho Synapse/Krnl
if not Drawing then
    error("Executor khong ho tro Drawing API (can Synapse/Krnl/ScriptWare)")
end

local espObjects = {}

-- Ham tao khung (Box)
local function createBox(player)
    if not player or player == LocalPlayer then return end
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    local head = char:FindFirstChild("Head")
    if not head then return end
    
    local gui = Drawing.new("Square")
    gui.Transparency = 1
    gui.Thickness = 2
    gui.Visible = true
    gui.Filled = false
    gui.Color = ESP_CONFIG.Color
    
    local line = Drawing.new("Line")
    line.Thickness = 1.5
    line.Visible = true
    line.Color = ESP_CONFIG.Color
    line.Transparency = 0.8
    
    local nameText = Drawing.new("Text")
    nameText.Size = 14
    nameText.Center = true
    nameText.Outline = true
    nameText.OutlineColor = Color3.fromRGB(0, 0, 0)
    nameText.Visible = true
    nameText.Color = ESP_CONFIG.Color
    
    local distText = Drawing.new("Text")
    distText.Size = 12
    distText.Center = true
    distText.Outline = true
    distText.OutlineColor = Color3.fromRGB(0, 0, 0)
    distText.Visible = true
    distText.Color = ESP_CONFIG.Color
    
    espObjects[player] = {
        Box = gui,
        Tracer = line,
        Name = nameText,
        Dist = distText,
        Char = char,
        Hrp = hrp,
        Head = head
    }
end

-- Ham update vi tri ESP
local function updateESP()
    local currentPlayers = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            currentPlayers[plr] = true
            if not espObjects[plr] then
                createBox(plr)
            end
        end
    end
    
    -- Xoa ESP cho nguoi choi da roi
    for plr, data in pairs(espObjects) do
        if not currentPlayers[plr] then
            data.Box:Remove()
            data.Tracer:Remove()
            data.Name:Remove()
            data.Dist:Remove()
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
        
        if not onScreen then
            data.Box.Visible = false
            data.Tracer.Visible = false
            data.Name.Visible = false
            data.Dist.Visible = false
            continue
        end
        
        -- Khoang cach
        local distance = (Camera.CFrame.Position - pos).Magnitude
        local scale = 200 / distance
        local boxHeight = 4 * scale
        local boxWidth = 2 * scale
        
        -- Mau theo team
        local isTeammate = (plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team)
        local color = isTeammate and ESP_CONFIG.Color or Color3.fromRGB(255, 0, 0)
        if ESP_CONFIG.TeamCheck then
            data.Box.Color = color
            data.Tracer.Color = color
            data.Name.Color = color
            data.Dist.Color = color
        end
        
        -- Cap nhat Box
        data.Box.Position = Vector2.new(screenPos.X - boxWidth/2, screenPos.Y - boxHeight)
        data.Box.Size = Vector2.new(boxWidth, boxHeight)
        data.Box.Visible = ESP_CONFIG.Box
        
        -- Cap nhat Tracer (duong thang tu giua man hinh)
        local viewportSize = Camera.ViewportSize
        local center = Vector2.new(viewportSize.X/2, viewportSize.Y/2)
        data.Tracer.From = center
        data.Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
        data.Tracer.Visible = ESP_CONFIG.Tracer
        
        -- Cap nhat Ten
        data.Name.Text = ESP_CONFIG.Name and plr.Name or ""
        data.Name.Position = Vector2.new(screenPos.X, screenPos.Y - boxHeight - 20)
        data.Name.Visible = ESP_CONFIG.Name
        
        -- Cap nhat Khoang cach
        data.Dist.Text = ESP_CONFIG.Distance and string.format("%dm", math.floor(distance/3)) or ""
        data.Dist.Position = Vector2.new(screenPos.X, screenPos.Y + 10)
        data.Dist.Visible = ESP_CONFIG.Distance
    end
end

-- Vong lap chinh
RunService.RenderStepped:Connect(updateESP)

-- Xoa ESP khi bi disable
game:GetService("Players").PlayerRemoving:Connect(function(plr)
    if espObjects[plr] then
        espObjects[plr].Box:Remove()
        espObjects[plr].Tracer:Remove()
        espObjects[plr].Name:Remove()
        espObjects[plr].Dist:Remove()
        espObjects[plr] = nil
    end
end)

-- Thong bao khoi dong
print("[ESP] Da khoi dong thanh cong!")
print("[ESP] Nhan Ctrl + C hoac disable executor de dung.")

-- Giua script song
while true do
    wait(1)
end
