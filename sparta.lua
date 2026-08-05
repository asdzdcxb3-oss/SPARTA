-- SPARTA - MM2 Hub (ESP + PLAYER) FULL FIXED
local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")
local run = game:GetService("RunService")
local cam = workspace.CurrentCamera
local uis = game:GetService("UserInputService")

-- Настройки
local settings = {
    esp = true, showMurderer = true, showSheriff = true, showInnocents = true,
    tracers = true, boxes = true, names = true, skeleton = true,
    maxDistance = 500,
    speedHack = false, speedValue = 50,
    noClip = false,
    aimbot = false, aimbotFov = 200
}

local noclipConnection = nil

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "SPARTA_ESP"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 250, 0, 400)
main.Position = UDim2.new(0.01, 0, 0.15, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Visible = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local border = Instance.new("Frame", main)
border.Size = UDim2.new(1, 4, 1, 4)
border.Position = UDim2.new(0, -2, 0, -2)
border.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
border.BorderSizePixel = 0
border.ZIndex = 0
Instance.new("UICorner", border).CornerRadius = UDim.new(0, 10)

-- Верхняя панель
local topPanel = Instance.new("Frame", main)
topPanel.Size = UDim2.new(1, 0, 0, 50)
topPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
topPanel.BorderSizePixel = 0
Instance.new("UICorner", topPanel).CornerRadius = UDim.new(0, 10)

local titleText = Instance.new("TextLabel", topPanel)
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.BackgroundTransparency = 1
titleText.Font = Enum.Font.GothamBlack
titleText.Text = "SPARTA HUB"
titleText.TextColor3 = Color3.fromRGB(255, 100, 0)
titleText.TextSize = 18

local closeBtn = Instance.new("TextButton", topPanel)
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(0.88, 0, 0.25, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)
closeBtn.MouseButton1Click:Connect(function() main.Visible = false end)

-- Вкладки
local tabFrame = Instance.new("Frame", main)
tabFrame.Size = UDim2.new(1, 0, 0, 30)
tabFrame.Position = UDim2.new(0, 0, 0.13, 0)
tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
tabFrame.BorderSizePixel = 0

local espTab = Instance.new("TextButton", tabFrame)
espTab.Size = UDim2.new(0.5, -2, 1, 0)
espTab.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
espTab.BorderSizePixel = 0
espTab.Font = Enum.Font.GothamBold
espTab.Text = "ESP"
espTab.TextColor3 = Color3.fromRGB(255, 255, 255)
espTab.TextSize = 13

local playerTab = Instance.new("TextButton", tabFrame)
playerTab.Size = UDim2.new(0.5, -2, 1, 0)
playerTab.Position = UDim2.new(0.5, 2, 0, 0)
playerTab.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
playerTab.BorderSizePixel = 0
playerTab.Font = Enum.Font.GothamBold
playerTab.Text = "PLAYER"
playerTab.TextColor3 = Color3.fromRGB(200, 200, 200)
playerTab.TextSize = 13

-- Контейнеры
local espContainer = Instance.new("Frame", main)
espContainer.Size = UDim2.new(1, 0, 0.77, 0)
espContainer.Position = UDim2.new(0, 0, 0.23, 0)
espContainer.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
espContainer.BorderSizePixel = 0
espContainer.Visible = true

local playerContainer = Instance.new("Frame", main)
playerContainer.Size = UDim2.new(1, 0, 0.77, 0)
playerContainer.Position = UDim2.new(0, 0, 0.23, 0)
playerContainer.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
playerContainer.BorderSizePixel = 0
playerContainer.Visible = false

espTab.MouseButton1Click:Connect(function()
    espContainer.Visible = true
    playerContainer.Visible = false
    espTab.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    playerTab.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
end)
playerTab.MouseButton1Click:Connect(function()
    espContainer.Visible = false
    playerContainer.Visible = true
    playerTab.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    espTab.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
end)

-- ==================== ESP SCROLL ====================
local espScroll = Instance.new("ScrollingFrame", espContainer)
espScroll.Size = UDim2.new(1, 0, 1, 0)
espScroll.BackgroundTransparency = 1
espScroll.BorderSizePixel = 0
espScroll.ScrollBarThickness = 4
espScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 100, 0)
espScroll.CanvasSize = UDim2.new(0, 0, 0, 300)

local espLayout = Instance.new("UIListLayout", espScroll)
espLayout.Padding = UDim.new(0, 4)
local espPad = Instance.new("UIPadding", espScroll)
espPad.PaddingTop = UDim.new(0, 8)
espPad.PaddingLeft = UDim.new(0, 10)

local espTitle = Instance.new("TextLabel", espScroll)
espTitle.Size = UDim2.new(0.9, 0, 0, 22)
espTitle.BackgroundTransparency = 1
espTitle.Font = Enum.Font.GothamBold
espTitle.Text = "ESP SETTINGS"
espTitle.TextColor3 = Color3.fromRGB(255, 100, 0)
espTitle.TextSize = 13
espTitle.TextXAlignment = Enum.TextXAlignment.Left

local function createToggle(name, setting, parent)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(0.88, 0, 0, 30)
    f.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(0.6, 0, 1, 0)
    l.Position = UDim2.new(0.06, 0, 0, 0)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.Gotham
    l.Text = name
    l.TextColor3 = Color3.fromRGB(255, 255, 255)
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(0.26, 0, 0.6, 0)
    b.Position = UDim2.new(0.7, 0, 0.2, 0)
    b.BackgroundColor3 = settings[setting] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamBold
    b.Text = settings[setting] and "ON" or "OFF"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 11
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 12)
    
    b.MouseButton1Click:Connect(function()
        settings[setting] = not settings[setting]
        b.BackgroundColor3 = settings[setting] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        b.Text = settings[setting] and "ON" or "OFF"
    end)
end

createToggle("ESP Master", "esp", espScroll)
createToggle("Murderer", "showMurderer", espScroll)
createToggle("Sheriff", "showSheriff", espScroll)
createToggle("Innocents", "showInnocents", espScroll)
createToggle("Tracers", "tracers", espScroll)
createToggle("Boxes", "boxes", espScroll)
createToggle("Names", "names", espScroll)
createToggle("Skeleton", "skeleton", espScroll)

-- ==================== PLAYER SCROLL ====================
local playerScroll = Instance.new("ScrollingFrame", playerContainer)
playerScroll.Size = UDim2.new(1, 0, 1, 0)
playerScroll.BackgroundTransparency = 1
playerScroll.BorderSizePixel = 0
playerScroll.ScrollBarThickness = 4
playerScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 100, 0)
playerScroll.CanvasSize = UDim2.new(0, 0, 0, 380)

local playerLayout = Instance.new("UIListLayout", playerScroll)
playerLayout.Padding = UDim.new(0, 5)
local playerPad = Instance.new("UIPadding", playerScroll)
playerPad.PaddingTop = UDim.new(0, 8)
playerPad.PaddingLeft = UDim.new(0, 10)

local playerTitle = Instance.new("TextLabel", playerScroll)
playerTitle.Size = UDim2.new(0.9, 0, 0, 22)
playerTitle.BackgroundTransparency = 1
playerTitle.Font = Enum.Font.GothamBold
playerTitle.Text = "PLAYER FUNCTIONS"
playerTitle.TextColor3 = Color3.fromRGB(255, 100, 0)
playerTitle.TextSize = 13
playerTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Speed Hack
local speedLabel = Instance.new("TextLabel", playerScroll)
speedLabel.Size = UDim2.new(0.88, 0, 0, 18)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.Gotham
speedLabel.Text = "Speed Hack"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextSize = 12
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedFrame = Instance.new("Frame", playerScroll)
speedFrame.Size = UDim2.new(0.88, 0, 0, 35)
speedFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
speedFrame.BorderSizePixel = 0
Instance.new("UICorner", speedFrame).CornerRadius = UDim.new(0, 6)

local speedInput = Instance.new("TextBox", speedFrame)
speedInput.Size = UDim2.new(0.35, 0, 0.55, 0)
speedInput.Position = UDim2.new(0.04, 0, 0.22, 0)
speedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
speedInput.BorderSizePixel = 0
speedInput.Font = Enum.Font.Gotham
speedInput.Text = "50"
speedInput.PlaceholderText = "Speed"
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.TextSize = 12
Instance.new("UICorner", speedInput).CornerRadius = UDim.new(0, 4)

local speedBtn = Instance.new("TextButton", speedFrame)
speedBtn.Size = UDim2.new(0.55, 0, 0.55, 0)
speedBtn.Position = UDim2.new(0.42, 0, 0.22, 0)
speedBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
speedBtn.BorderSizePixel = 0
speedBtn.Font = Enum.Font.GothamBold
speedBtn.Text = "OFF"
speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBtn.TextSize = 11
Instance.new("UICorner", speedBtn).CornerRadius = UDim.new(0, 5)

speedInput.FocusLost:Connect(function()
    local n = tonumber(speedInput.Text)
    if n and n >= 16 and n <= 500 then
        settings.speedValue = n
    end
    speedInput.Text = tostring(settings.speedValue)
end)

speedBtn.MouseButton1Click:Connect(function()
    settings.speedHack = not settings.speedHack
    speedBtn.BackgroundColor3 = settings.speedHack and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    speedBtn.Text = settings.speedHack and "ON" or "OFF"
    if not settings.speedHack then
        pcall(function() player.Character.Humanoid.WalkSpeed = 16 end)
    end
end)

-- No Clip
local noclipBtn = Instance.new("TextButton", playerScroll)
noclipBtn.Size = UDim2.new(0.88, 0, 0, 35)
noclipBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
noclipBtn.BorderSizePixel = 0
noclipBtn.Font = Enum.Font.GothamBold
noclipBtn.Text = "No Clip: OFF"
noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipBtn.TextSize = 12
Instance.new("UICorner", noclipBtn).CornerRadius = UDim.new(0, 6)

noclipBtn.MouseButton1Click:Connect(function()
    settings.noClip = not settings.noClip
    noclipBtn.BackgroundColor3 = settings.noClip and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    noclipBtn.Text = settings.noClip and "No Clip: ON" or "No Clip: OFF"
    if settings.noClip then
        noclipConnection = run.Stepped:Connect(function()
            if settings.noClip then
                local c = player.Character
                if c then
                    for _, v in pairs(c:GetDescendants()) do
                        if v:IsA("BasePart") and v.CanCollide then
                            v.CanCollide = false
                        end
                    end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
        local c = player.Character
        if c then
            for _, v in pairs(c:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = true end
            end
        end
    end
end)

-- Aimbot
local aimLabel = Instance.new("TextLabel", playerScroll)
aimLabel.Size = UDim2.new(0.88, 0, 0, 18)
aimLabel.BackgroundTransparency = 1
aimLabel.Font = Enum.Font.Gotham
aimLabel.Text = "Aimbot (Sheriff)"
aimLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
aimLabel.TextSize = 12
aimLabel.TextXAlignment = Enum.TextXAlignment.Left

local aimFrame = Instance.new("Frame", playerScroll)
aimFrame.Size = UDim2.new(0.88, 0, 0, 35)
aimFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
aimFrame.BorderSizePixel = 0
Instance.new("UICorner", aimFrame).CornerRadius = UDim.new(0, 6)

local fovInput = Instance.new("TextBox", aimFrame)
fovInput.Size = UDim2.new(0.35, 0, 0.55, 0)
fovInput.Position = UDim2.new(0.04, 0, 0.22, 0)
fovInput.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
fovInput.BorderSizePixel = 0
fovInput.Font = Enum.Font.Gotham
fovInput.Text = "200"
fovInput.PlaceholderText = "FOV"
fovInput.TextColor3 = Color3.fromRGB(255, 255, 255)
fovInput.TextSize = 12
Instance.new("UICorner", fovInput).CornerRadius = UDim.new(0, 4)

local aimBtn = Instance.new("TextButton", aimFrame)
aimBtn.Size = UDim2.new(0.55, 0, 0.55, 0)
aimBtn.Position = UDim2.new(0.42, 0, 0.22, 0)
aimBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
aimBtn.BorderSizePixel = 0
aimBtn.Font = Enum.Font.GothamBold
aimBtn.Text = "OFF"
aimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
aimBtn.TextSize = 11
Instance.new("UICorner", aimBtn).CornerRadius = UDim.new(0, 5)

fovInput.FocusLost:Connect(function()
    local n = tonumber(fovInput.Text)
    if n and n >= 50 and n <= 1000 then
        settings.aimbotFov = n
    end
    fovInput.Text = tostring(settings.aimbotFov)
end)

aimBtn.MouseButton1Click:Connect(function()
    settings.aimbot = not settings.aimbot
    aimBtn.BackgroundColor3 = settings.aimbot and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    aimBtn.Text = settings.aimbot and "ON" or "OFF"
end)

-- Fling Murderer
local fmBtn = Instance.new("TextButton", playerScroll)
fmBtn.Size = UDim2.new(0.88, 0, 0, 35)
fmBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
fmBtn.BorderSizePixel = 0
fmBtn.Font = Enum.Font.GothamBold
fmBtn.Text = "Fling Murderer"
fmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fmBtn.TextSize = 12
Instance.new("UICorner", fmBtn).CornerRadius = UDim.new(0, 6)

fmBtn.MouseButton1Click:Connect(function()
    local found = false
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character then
            for _, v in pairs(p.Character:GetChildren()) do
                if v:IsA("Tool") and v.Name:lower():find("knife") then
                    local h = p.Character:FindFirstChild("HumanoidRootPart")
                    if h then
                        local bv = Instance.new("BodyVelocity", h)
                        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                        bv.Velocity = Vector3.new(math.random(-3000, 3000), 8000, math.random(-3000, 3000))
                        task.wait(0.5)
                        bv:Destroy()
                    end
                    found = true
                    break
                end
            end
        end
    end
    fmBtn.Text = found and "Done!" or "No knife"
    task.wait(1.5)
    fmBtn.Text = "Fling Murderer"
end)

-- Fling Sheriff
local fsBtn = Instance.new("TextButton", playerScroll)
fsBtn.Size = UDim2.new(0.88, 0, 0, 35)
fsBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
fsBtn.BorderSizePixel = 0
fsBtn.Font = Enum.Font.GothamBold
fsBtn.Text = "Fling Sheriff"
fsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fsBtn.TextSize = 12
Instance.new("UICorner", fsBtn).CornerRadius = UDim.new(0, 6)

fsBtn.MouseButton1Click:Connect(function()
    local found = false
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character then
            for _, v in pairs(p.Character:GetChildren()) do
                if v:IsA("Tool") then
                    local n = v.Name:lower()
                    if n:find("gun") or n:find("pistol") or n:find("revolver") then
                        local h = p.Character:FindFirstChild("HumanoidRootPart")
                        if h then
                            local bv = Instance.new("BodyVelocity", h)
                            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                            bv.Velocity = Vector3.new(math.random(-3000, 3000), 8000, math.random(-3000, 3000))
                            task.wait(0.5)
                            bv:Destroy()
                        end
                        found = true
                        break
                    end
                end
            end
        end
    end
    fsBtn.Text = found and "Done!" or "No gun"
    task.wait(1.5)
    fsBtn.Text = "Fling Sheriff"
end)

-- Кнопка скрытия
local hideBtn = Instance.new("TextButton", gui)
hideBtn.Size = UDim2.new(0, 34, 0, 34)
hideBtn.Position = UDim2.new(0.95, -17, 0.5, -17)
hideBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
hideBtn.BorderSizePixel = 0
hideBtn.Font = Enum.Font.GothamBold
hideBtn.Text = "S"
hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hideBtn.TextSize = 16
hideBtn.ZIndex = 10
Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(1, 0)
hideBtn.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

uis.InputBegan:Connect(function(input, g)
    if input.KeyCode == Enum.KeyCode.Insert and not g then
        main.Visible = not main.Visible
    end
end)

-- ==================== LOOPS ====================
-- Speed Hack Loop
run.Heartbeat:Connect(function()
    if settings.speedHack then
        pcall(function()
            local c = player.Character
            if c and c:FindFirstChild("Humanoid") then
                c.Humanoid.WalkSpeed = settings.speedValue
            end
        end)
    end
end)

-- Aimbot Loop
run.RenderStepped:Connect(function()
    if not settings.aimbot then return end
    local c = player.Character
    if not c then return end
    
    local hasGun = false
    for _, v in pairs(c:GetChildren()) do
        if v:IsA("Tool") then
            local n = v.Name:lower()
            if n:find("gun") or n:find("pistol") or n:find("revolver") then
                hasGun = true
                break
            end
        end
    end
    if not hasGun then return end
    
    local closest = nil
    local minDist = settings.aimbotFov
    local mousePos = cam.ViewportSize / 2
    
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character then
            local head = p.Character:FindFirstChild("Head")
            local hum = p.Character:FindFirstChild("Humanoid")
            if head and hum and hum.Health > 0 then
                local pos, onScreen = cam:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if dist < minDist then
                        minDist = dist
                        closest = head
                    end
                end
            end
        end
    end
    
    if closest then
        cam.CFrame = CFrame.new(cam.CFrame.Position, closest.Position)
    end
end)

-- ==================== ESP ====================
local espObjects = {}
local bodyParts = {"Head","UpperTorso","LowerTorso","LeftUpperArm","LeftLowerArm","LeftHand","RightUpperArm","RightLowerArm","RightHand","LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot"}
local skeletonConnections = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"}
}

local function getRole(p)
    local c = p.Character
    if not c then return "Unknown" end
    for _, v in pairs(c:GetChildren()) do
        if v:IsA("Tool") then
            local n = v.Name:lower()
            if n:find("knife") then return "Murderer" end
            if n:find("gun") or n:find("pistol") or n:find("revolver") then return "Sheriff" end
        end
    end
    return "Innocent"
end

local function removeESP(p)
    for i, esp in pairs(espObjects) do
        if esp.Player == p then
            pcall(function() esp.Tracer:Remove() end)
            pcall(function() esp.Box:Remove() end)
            pcall(function() esp.NameTag:Remove() end)
            pcall(function() esp.DistTag:Remove() end)
            for _, l in pairs(esp.SkeletonLines) do
                pcall(function() l:Remove() end)
            end
            table.remove(espObjects, i)
            break
        end
    end
end

local function createESP(p)
    removeESP(p)
    local c = p.Character
    if not c then return end
    if not c:FindFirstChild("Head") or not c:FindFirstChild("HumanoidRootPart") then return end
    
    local role = getRole(p)
    local colors = {
        Murderer = Color3.fromRGB(255, 0, 0),
        Sheriff = Color3.fromRGB(0, 100, 255),
        Innocent = Color3.fromRGB(0, 255, 0)
    }
    local color = colors[role] or Color3.fromRGB(255, 255, 255)
    
    local tracer = Drawing.new("Line"); tracer.Visible = false; tracer.Color = color; tracer.Thickness = 1.5
    local box = Drawing.new("Square"); box.Visible = false; box.Color = color; box.Thickness = 1.5; box.Filled = false
    local nameTag = Drawing.new("Text"); nameTag.Visible = false; nameTag.Color = color; nameTag.Size = 14; nameTag.Center = true; nameTag.Outline = true
    local distTag = Drawing.new("Text"); distTag.Visible = false; distTag.Color = color; distTag.Size = 12; distTag.Center = true; distTag.Outline = true
    local skLines = {}
    for _ = 1, #skeletonConnections do
        local l = Drawing.new("Line"); l.Visible = false; l.Color = color; l.Thickness = 1.5
        table.insert(skLines, l)
    end
    
    table.insert(espObjects, {
        Player = p, Tracer = tracer, Box = box,
        NameTag = nameTag, DistTag = distTag,
        SkeletonLines = skLines, Color = color, Role = role
    })
end

local function updateESP()
    for _, esp in pairs(espObjects) do
        local p = esp.Player
        local c = p.Character
        
        if not c or not c:FindFirstChild("Head") or not c:FindFirstChild("HumanoidRootPart") then
            esp.Tracer.Visible = false; esp.Box.Visible = false
            esp.NameTag.Visible = false; esp.DistTag.Visible = false
            for _, l in pairs(esp.SkeletonLines) do l.Visible = false end
            continue
        end
        
        local role = getRole(p)
        if role ~= esp.Role then
            esp.Role = role
            local colors = {Murderer = Color3.fromRGB(255,0,0), Sheriff = Color3.fromRGB(0,100,255), Innocent = Color3.fromRGB(0,255,0)}
            esp.Color = colors[role] or Color3.fromRGB(255,255,255)
            esp.Tracer.Color = esp.Color; esp.Box.Color = esp.Color
            esp.NameTag.Color = esp.Color; esp.DistTag.Color = esp.Color
            for _, l in pairs(esp.SkeletonLines) do l.Color = esp.Color end
        end
        
        local hrp = c.HumanoidRootPart
        local rootPos, onScreen = cam:WorldToViewportPoint(hrp.Position)
        local dist = (cam.CFrame.Position - hrp.Position).Magnitude
        
        if not onScreen or dist > settings.maxDistance then
            esp.Tracer.Visible = false; esp.Box.Visible = false
            esp.NameTag.Visible = false; esp.DistTag.Visible = false
            for _, l in pairs(esp.SkeletonLines) do l.Visible = false end
            continue
        end
        
        local show = false
        if esp.Role == "Murderer" and settings.showMurderer then show = true end
        if esp.Role == "Sheriff" and settings.showSheriff then show = true end
        if esp.Role == "Innocent" and settings.showInnocents then show = true end
        
        if not show then
            esp.Tracer.Visible = false; esp.Box.Visible = false
            esp.NameTag.Visible = false; esp.DistTag.Visible = false
            for _, l in pairs(esp.SkeletonLines) do l.Visible = false end
            continue
        end
        
        if settings.tracers and settings.esp then
            esp.Tracer.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
            esp.Tracer.To = Vector2.new(rootPos.X, rootPos.Y)
            esp.Tracer.Visible = true
        else
            esp.Tracer.Visible = false
        end
        
        if settings.boxes and settings.esp then
            local boxSize = Vector2.new(2000 / rootPos.Z, 3500 / rootPos.Z)
            esp.Box.Size = boxSize
            esp.Box.Position = Vector2.new(rootPos.X - boxSize.X / 2, rootPos.Y - boxSize.Y / 2)
            esp.Box.Visible = true
        else
            esp.Box.Visible = false
        end
        
        if settings.names and settings.esp then
            esp.NameTag.Text = p.Name .. " [" .. esp.Role .. "]"
            esp.NameTag.Position = Vector2.new(rootPos.X, rootPos.Y - 35)
            esp.NameTag.Visible = true
        else
            esp.NameTag.Visible = false
        end
        
        esp.DistTag.Text = math.floor(dist) .. "m"
        esp.DistTag.Position = Vector2.new(rootPos.X, rootPos.Y - 20)
        esp.DistTag.Visible = settings.esp and settings.names
        
        if settings.skeleton and settings.esp then
            local partPositions = {}
            for _, partName in pairs(bodyParts) do
                local part = c:FindFirstChild(partName)
                if part then
                    local pos, onScr = cam:WorldToViewportPoint(part.Position)
                    if onScr then partPositions[partName] = pos end
                end
            end
            for i, conn in pairs(skeletonConnections) do
                if partPositions[conn[1]] and partPositions[conn[2]] then
                    esp.SkeletonLines[i].From = Vector2.new(partPositions[conn[1]].X, partPositions[conn[1]].Y)
                    esp.SkeletonLines[i].To = Vector2.new(partPositions[conn[2]].X, partPositions[conn[2]].Y)
                    esp.SkeletonLines[i].Visible = true
                else
                    esp.SkeletonLines[i].Visible = false
                end
            end
        else
            for _, l in pairs(esp.SkeletonLines) do l.Visible = false end
        end
    end
end

-- Инициализация ESP
for _, p in pairs(game.Players:GetPlayers()) do
    if p ~= player then
        createESP(p)
        p.CharacterAdded:Connect(function()
            task.wait(0.5)
            createESP(p)
        end)
    end
end

game.Players.PlayerAdded:Connect(function(p)
    if p ~= player then
        createESP(p)
        p.CharacterAdded:Connect(function()
            task.wait(0.5)
            createESP(p)
        end)
    end
end)

game.Players.PlayerRemoving:Connect(removeESP)

-- ESP Render Loop
run.RenderStepped:Connect(function()
    if settings.esp then
        updateESP()
    else
        for _, esp in pairs(espObjects) do
            esp.Tracer.Visible = false
            esp.Box.Visible = false
            esp.NameTag.Visible = false
            esp.DistTag.Visible = false
            for _, l in pairs(esp.SkeletonLines) do l.Visible = false end
        end
    end
end)

print("[SPARTA]