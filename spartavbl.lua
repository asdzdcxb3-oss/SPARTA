-- ============================================
-- GUI ДЛЯ ФАРМА YEN / STYLE / ABILITY
-- VOLLEYBALL LEGENDS
-- ============================================

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- СОЗДАНИЕ ОСНОВНОГО GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SwillFarmGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ФОН
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 380)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- ЗАГРУГЛЕНИЕ
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = mainFrame

-- ЗАГОЛОВОК
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
title.BackgroundTransparency = 0.3
title.Text = "SWILL FARM v3.0"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- ПОДЗАГОЛОВОК (статус)
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 0, 40)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "⏸ Остановлен"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.Parent = mainFrame

-- КОНТЕЙНЕР ДЛЯ КНОПОК
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, -40, 0, 240)
buttonContainer.Position = UDim2.new(0, 20, 0, 75)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame

-- ФУНКЦИЯ СОЗДАНИЯ КНОПКИ
function createButton(text, color, yPos, scriptType)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 60)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = buttonContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 12)
    btnCorner.Parent = btn
    
    -- Иконка статуса
    local statusIcon = Instance.new("TextLabel")
    statusIcon.Size = UDim2.new(0, 30, 0, 30)
    statusIcon.Position = UDim2.new(1, -40, 0.5, -15)
    statusIcon.BackgroundTransparency = 1
    statusIcon.Text = "⬜"
    statusIcon.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusIcon.TextScaled = true
    statusIcon.Font = Enum.Font.GothamBold
    statusIcon.Parent = btn
    
    -- Переменная состояния
    local isRunning = false
    local connection = nil
    
    -- ОСНОВНОЙ СКРИПТ ДЛЯ КАЖДОГО РЕЖИМА
    local function startFarming()
        if isRunning then return end
        isRunning = true
        statusIcon.Text = "🟢"
        statusLabel.Text = "▶ Активен: " .. text
        btn.BackgroundColor3 = Color3.fromRGB(color.R * 0.7, color.G * 0.7, color.B * 0.7)
        
        -- Выбор аргумента в зависимости от режима
        local argValue = 0
        if scriptType == "yen" then argValue = 2
        elseif scriptType == "style" then argValue = 1
        elseif scriptType == "ability" then argValue = 4
        end
        
        -- ЗАПУСК ОСНОВНОГО ЦИКЛА
        local running = true
        connection = game:GetService("RunService").Stepped:Connect(function()
            if not running then return end
            
            pcall(function()
                local args = { argValue }
                game:GetService("ReplicatedStorage")
                    :WaitForChild("Packages")
                    :WaitForChild("_Index")
                    :WaitForChild("sleitnick_knit@1.7.0")
                    :WaitForChild("knit")
                    :WaitForChild("Services")
                    :WaitForChild("SeasonService")
                    :WaitForChild("RF")
                    :WaitForChild("RequestRankedReward")
                    :InvokeServer(unpack(args))
            end)
            
            wait(1) -- интервал
        end)
        
        -- Хранение состояния для остановки
        btn._running = running
        btn._connection = connection
    end
    
    local function stopFarming()
        if not isRunning then return end
        isRunning = false
        statusIcon.Text = "⬜"
        statusLabel.Text = "⏸ Остановлен"
        btn.BackgroundColor3 = color
        
        if btn._connection then
            btn._connection:Disconnect()
            btn._connection = nil
        end
        btn._running = false
    end
    
    -- ОБРАБОТЧИК НАЖАТИЯ (переключение)
    btn.MouseButton1Click:Connect(function()
        if isRunning then
            stopFarming()
        else
            startFarming()
        end
    end)
    
    return btn
end

-- СОЗДАНИЕ ТРЁХ КНОПОК
local yenBtn = createButton("💰 YEN", Color3.fromRGB(255, 200, 50), 0, "yen")
local styleBtn = createButton("🎨 STYLE", Color3.fromRGB(255, 100, 200), 70, "style")
local abilityBtn = createButton("⚡ ABILITY", Color3.fromRGB(50, 200, 255), 140, "ability")

-- КНОПКА ОСТАНОВИТЬ ВСЁ
local stopAllBtn = Instance.new("TextButton")
stopAllBtn.Size = UDim2.new(1, -40, 0, 45)
stopAllBtn.Position = UDim2.new(0, 20, 0, 230)
stopAllBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stopAllBtn.BackgroundTransparency = 0.1
stopAllBtn.Text = "⏹ ОСТАНОВИТЬ ВСЁ"
stopAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopAllBtn.TextScaled = true
stopAllBtn.Font = Enum.Font.GothamBold
stopAllBtn.BorderSizePixel = 0
stopAllBtn.Parent = buttonContainer

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 12)
stopCorner.Parent = stopAllBtn

stopAllBtn.MouseButton1Click:Connect(function()
    -- Остановить все кнопки
    for _, btn in pairs(buttonContainer:GetChildren()) do
        if btn:IsA("TextButton") and btn ~= stopAllBtn then
            if btn._connection then
                btn._connection:Disconnect()
                btn._connection = nil
            end
            btn._running = false
            btn.BackgroundColor3 = btn.BackgroundColor3 -- возврат цвета
            local icon = btn:FindFirstChildOfClass("TextLabel")
            if icon then icon.Text = "⬜" end
        end
    end
    statusLabel.Text = "⏹ Всё остановлено"
end)

-- КНОПКА ЗАКРЫТИЯ GUI
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.BackgroundTransparency = 0.2
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    -- Остановить всё перед закрытием
    for _, btn in pairs(buttonContainer:GetChildren()) do
        if btn:IsA("TextButton") and btn ~= stopAllBtn then
            if btn._connection then
                btn._connection:Disconnect()
                btn._connection = nil
            end
            btn._running = false
        end
    end
    screenGui:Destroy()
end)

-- ПЕРЕТАСКИВАНИЕ GUI (драг)
local dragging = false
local dragInput, dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- ИНФОРМАЦИОННАЯ СТРОКА СНИЗУ
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 20)
footer.Position = UDim2.new(0, 0, 1, -20)
footer.BackgroundTransparency = 1
footer.Text = "Нажми на кнопку для запуска / остановки"
footer.TextColor3 = Color3.fromRGB(100, 100, 120)
footer.TextScaled = true
footer.Font = Enum.Font.GothamMedium
footer.Parent = mainFrame

-- АНИМАЦИЯ ПОЯВЛЕНИЯ
mainFrame.BackgroundTransparency = 0.1
mainFrame:TweenPosition(UDim2.new(0.5, -160, 0.5, -190), "Out", "Quad", 0.3)

print("[SWILL] GUI успешно загружен!")
print("[SWILL] Режимы: Yen (2), Style (1), Ability (4)")

-- ============================================
-- КОМАНДЫ В КОНСОЛИ:
-- _G.swillGUI:Destroy() - удалить GUI
-- _G.stopAllFarms() - остановить все процессы
-- ============================================

_G.swillGUI = screenGui
_G.stopAllFarms = function()
    for _, btn in pairs(buttonContainer:GetChildren()) do
        if btn:IsA("TextButton") and btn ~= stopAllBtn then
            if btn._connection then
                btn._connection:Disconnect()
                btn._connection = nil
            end
            btn._running = false
        end
    end
    statusLabel.Text = "⏹ Всё остановлено"
end
