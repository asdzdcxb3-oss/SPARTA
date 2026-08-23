-- SPARTA HUB - Muscle Legends Auto Lifting (E + Tap)
local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")
local run = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local vim = game:GetService("VirtualInputManager")
local rep = game:GetService("ReplicatedStorage")

local settings = {
    autoLift = false,
    autoRebirth = false,
    collectGems = true,
    usePotions = true
}

-- GUI (Фиолетовая тема)
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "SPARTA_HUB"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 230, 0, 250)
main.Position = UDim2.new(0.01, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(25, 15, 40)
main.BorderSizePixel = 0
main.Draggable = true
main.Active = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local border = Instance.new("Frame", main)
border.Size = UDim2.new(1, 4, 1, 4)
border.Position = UDim2.new(0, -2, 0, -2)
border.BackgroundColor3 = Color3.fromRGB(180, 50, 255)
border.BorderSizePixel = 0
border.ZIndex = 0
Instance.new("UICorner", border).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
title.BorderSizePixel = 0
title.Font = Enum.Font.GothamBlack
title.Text = "SPARTA HUB"
title.TextColor3 = Color3.fromRGB(200, 100, 255)
title.TextSize = 14
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

local closeBtn = Instance.new("TextButton", title)
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(0.88, 0, 0.18, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 255)
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)
closeBtn.MouseButton1Click:Connect(function() main.Visible = false end)

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, 0, 0.84, 0)
scroll.Position = UDim2.new(0, 0, 0.16, 0)
scroll.BackgroundColor3 = Color3.fromRGB(30, 18, 50)
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(180, 50, 255)
scroll.CanvasSize = UDim2.new(0, 0, 0, 220)
Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 10)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 4)
local pad = Instance.new("UIPadding", scroll)
pad.PaddingTop = UDim.new(0, 8)
pad.PaddingLeft = UDim.new(0, 10)

local function createToggle(name, setting)
    local f = Instance.new("Frame", scroll)
    f.Size = UDim2.new(0.9, 0, 0, 28)
    f.BackgroundColor3 = Color3.fromRGB(45, 25, 70)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(0.6, 0, 1, 0)
    l.Position = UDim2.new(0.05, 0, 0, 0)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.Gotham
    l.Text = name
    l.TextColor3 = Color3.fromRGB(255, 255, 255)
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left
    
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(0.3, 0, 0.6, 0)
    b.Position = UDim2.new(0.66, 0, 0.2, 0)
    b.BackgroundColor3 = settings[setting] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamBold
    b.Text = settings[setting] and "ON" or "OFF"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 10
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    
    b.MouseButton1Click:Connect(function()
        settings[setting] = not settings[setting]
        b.BackgroundColor3 = settings[setting] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        b.Text = settings[setting] and "ON" or "OFF"
    end)
end

local title1 = Instance.new("TextLabel", scroll)
title1.Size = UDim2.new(0.9, 0, 0, 18)
title1.BackgroundTransparency = 1
title1.Font = Enum.Font.GothamBold
title1.Text = "AUTO LIFT"
title1.TextColor3 = Color3.fromRGB(180, 50, 255)
title1.TextSize = 12
title1.TextXAlignment = Enum.TextXAlignment.Left

createToggle("Auto Lift", "autoLift")
createToggle("Auto Rebirth", "autoRebirth")
createToggle("Collect Gems", "collectGems")
createToggle("Use Potions", "usePotions")

local startBtn = Instance.new("TextButton", scroll)
startBtn.Size = UDim2.new(0.9, 0, 0, 35)
startBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 220)
startBtn.BorderSizePixel = 0
startBtn.Font = Enum.Font.GothamBold
startBtn.Text = "START LIFTING"
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.TextSize = 13
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 6)

local statusLabel = Instance.new("TextLabel", scroll)
statusLabel.Size = UDim2.new(0.9, 0, 0, 25)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.Text = "Status: Ready"
statusLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
statusLabel.TextSize = 11
statusLabel.TextWrapped = true

-- Кнопка скрытия
local hideBtn = Instance.new("TextButton", gui)
hideBtn.Size = UDim2.new(0, 30, 0, 30)
hideBtn.Position = UDim2.new(0.95, -15, 0.5, -15)
hideBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 220)
hideBtn.BorderSizePixel = 0
hideBtn.Font = Enum.Font.GothamBold
hideBtn.Text = "S"
hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hideBtn.TextSize = 14
hideBtn.ZIndex = 10
Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(1, 0)
hideBtn.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

uis.InputBegan:Connect(function(input, g)
    if input.KeyCode == Enum.KeyCode.Insert and not g then main.Visible = not main.Visible end
end)

-- ==================== ЛОГИКА ====================
-- Кэш объектов
local cachedEquipment = {}
local cachedGems = {}
local lastScanTime = 0
local currentEquipment = nil

-- Функция сканирования
local function scanObjects()
    if tick() - lastScanTime < 5 then return end
    lastScanTime = tick()
    
    cachedEquipment = {}
    cachedGems = {}
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            local n = v.Name:lower()
            if n:find("bench") or n:find("barbell") or n:find("weight") or n:find("dumbbell") or n:find("lift") or n:find("train") or n:find("press") or n:find("gym") or n:find("machine") then
                table.insert(cachedEquipment, v)
            end
            if n:find("gem") or n:find("crystal") or n:find("diamond") or n:find("coin") then
                table.insert(cachedGems, v)
            end
        end
    end
    
    print("[SPARTA HUB] Scan: " .. #cachedEquipment .. " equipment, " .. #cachedGems .. " gems")
end

-- Функция телепорта к ближайшему тренажеру
local function teleportToNearestEquipment()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    scanObjects()
    
    if #cachedEquipment == 0 then
        statusLabel.Text = "Status: No equipment found"
        return false
    end
    
    local nearest = nil
    local minDist = 999999
    
    for _, eq in pairs(cachedEquipment) do
        if eq and eq.Parent then
            local d = (hrp.Position - eq.Position).Magnitude
            if d < minDist then
                minDist = d
                nearest = eq
            end
        end
    end
    
    if nearest then
        currentEquipment = nearest
        -- Телепорт рядом с тренажером (чуть сбоку чтобы ProximityPrompt сработал)
        hrp.CFrame = CFrame.new(nearest.Position + Vector3.new(0, 2, 2))
        statusLabel.Text = "Status: TP to " .. nearest.Name
        print("[SPARTA HUB] Teleported to: " .. nearest.Name)
        return true
    end
    
    return false
end

-- Функция нажатия E
local function pressE()
    vim:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
    task.wait(0.05)
    vim:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
end

-- Функция тапа (клик)
local function tapClick()
    vim:SendMouseButtonEvent(0, 0, 0, true, nil, 0)
    task.wait(0.02)
    vim:SendMouseButtonEvent(0, 0, 0, false, nil, 0)
end

-- Главный цикл
startBtn.MouseButton1Click:Connect(function()
    settings.autoLift = not settings.autoLift
    
    if settings.autoLift then
        startBtn.Text = "STOP LIFTING"
        startBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 200)
        print("[SPARTA HUB] Auto Lift STARTED")
        
        task.spawn(function()
            while settings.autoLift do
                pcall(function()
                    -- Телепорт к тренажеру
                    if teleportToNearestEquipment() then
                        task.wait(0.3)
                        
                        -- Нажимаем E
                        pressE()
                        statusLabel.Text = "Status: Pressing E..."
                        
                        task.wait(0.2)
                        
                        -- Тапаем (кликаем)
                        for i = 1, 5 do
                            if not settings.autoLift then break end
                            tapClick()
                            task.wait(0.1)
                        end
                        
                        statusLabel.Text = "Status: Lifting..."
                        
                        -- Сбор гемов
                        if settings.collectGems and #cachedGems > 0 then
                            local char = player.Character
                            if char then
                                local hrp = char:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    for _, gem in pairs(cachedGems) do
                                        if gem and gem.Parent then
                                            if (hrp.Position - gem.Position).Magnitude < 30 then
                                                hrp.CFrame = CFrame.new(gem.Position)
                                                task.wait(0.2)
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
                
                task.wait(1) -- Задержка между циклами
            end
        end)
    else
        startBtn.Text = "START LIFTING"
        startBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 220)
        statusLabel.Text = "Status: Stopped"
        print("[SPARTA HUB] Auto Lift STOPPED")
    end
end)

print("[SPARTA HUB] Loaded!")
print("[SPARTA HUB] Press START LIFTING")
