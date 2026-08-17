-- SPARTA HUB - DOORS (Main + ESP + Player)
local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")
local run = game:GetService("RunService")
local cam = workspace.CurrentCamera
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")

-- Ждем загрузки игрока
if not player.Character then
    player.CharacterAdded:Wait()
end
task.wait(1)

-- Проверка что мы в катке (не в лобби)
local function isInGame()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    
    -- Проверка по позиции (лобби обычно на спавне)
    local hrp = char.HumanoidRootPart
    local pos = hrp.Position
    
    -- В лобби Y обычно 0-5, в катке Y больше
    if pos.Y > 5 then return true end
    
    -- Проверка по наличию комнат/дверей рядом
    local hasRooms = false
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            local n = v.Name:lower()
            if n:find("door") or n:find("room") then
                local dist = (pos - v.Position).Magnitude
                if dist < 30 then
                    hasRooms = true
                    break
                end
            end
        end
    end
    
    return hasRooms
end

-- Функция ожидания катки
local function waitForGame()
    while not isInGame() do
        task.wait(0.5)
    end
end

-- Основная логика
local function startHub()
    local settings = {
        godmode = false,
        autoDoor = false,
        espPlayers = true,
        espDoors = true,
        espGold = true,
        espMonsters = true,
        espItems = true,
        speedhack = false,
        speedValue = 50,
        noclip = false
    }
    
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "SPARTA_HUB"
    gui.ResetOnSpawn = false
    
    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 500, 0, 380)
    main.Position = UDim2.new(0.5, -250, 0.5, -190)
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    main.BorderSizePixel = 0
    main.Draggable = true
    main.Active = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
    
    local border = Instance.new("Frame", main)
    border.Size = UDim2.new(1, 6, 1, 6)
    border.Position = UDim2.new(0, -3, 0, -3)
    border.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    border.BorderSizePixel = 0
    border.ZIndex = 0
    Instance.new("UICorner", border).CornerRadius = UDim.new(0, 12)
    
    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    title.BorderSizePixel = 0
    title.Font = Enum.Font.GothamBlack
    title.Text = "SPARTA HUB"
    title.TextColor3 = Color3.fromRGB(0, 150, 255)
    title.TextSize = 22
    Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)
    
    local subtitle = Instance.new("TextLabel", title)
    subtitle.Size = UDim2.new(1, 0, 0, 15)
    subtitle.Position = UDim2.new(0, 0, 0.65, 0)
    subtitle.BackgroundTransparency = 1
    subtitle.Font = Enum.Font.Gotham
    subtitle.Text = "DOORS Edition"
    subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    subtitle.TextSize = 10
    
    local closeBtn = Instance.new("TextButton", main)
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.Position = UDim2.new(0.93, 0, 0.05, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.BorderSizePixel = 0
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 14
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    closeBtn.MouseButton1Click:Connect(function() main.Visible = false end)
    
    local tabFrame = Instance.new("Frame", main)
    tabFrame.Size = UDim2.new(0.25, 0, 0.85, 0)
    tabFrame.Position = UDim2.new(0, 0, 0.15, 0)
    tabFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
    tabFrame.BorderSizePixel = 0
    Instance.new("UICorner", tabFrame).CornerRadius = UDim.new(0, 12)
    
    local tabButtons = {}
    local containers = {}
    
    local function createTab(name, order)
        local tabBtn = Instance.new("TextButton", tabFrame)
        tabBtn.Size = UDim2.new(0.85, 0, 0, 45)
        tabBtn.Position = UDim2.new(0.075, 0, 0.03 + order * 0.13, 0)
        tabBtn.BackgroundColor3 = order == 1 and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 55)
        tabBtn.BorderSizePixel = 0
        tabBtn.Font = Enum.Font.GothamBold
        tabBtn.Text = name
        tabBtn.TextColor3 = order == 1 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
        tabBtn.TextSize = 16
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 8)
        tabButtons[name] = tabBtn
        
        local container = Instance.new("ScrollingFrame", main)
        container.Size = UDim2.new(0.73, 0, 0.83, 0)
        container.Position = UDim2.new(0.26, 0, 0.17, 0)
        container.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        container.BorderSizePixel = 0
        container.Visible = (order == 1)
        container.ScrollBarThickness = 4
        container.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
        container.CanvasSize = UDim2.new(0, 0, 0, 500)
        Instance.new("UICorner", container).CornerRadius = UDim.new(0, 10)
        containers[name] = container
        
        local layout = Instance.new("UIListLayout", container)
        layout.Padding = UDim.new(0, 5)
        local pad = Instance.new("UIPadding", container)
        pad.PaddingTop = UDim.new(0, 10)
        pad.PaddingLeft = UDim.new(0, 15)
        
        tabBtn.MouseButton1Click:Connect(function()
            for n, c in pairs(containers) do c.Visible = false end
            for n, b in pairs(tabButtons) do
                b.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
                b.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
            container.Visible = true
            tabBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
        
        return container
    end
    
    local mainContainer = createTab("MAIN", 1)
    local espContainer = createTab("ESP", 2)
    local playerContainer = createTab("PLAYER", 3)
    
    local function createToggle(container, name, setting)
        local f = Instance.new("Frame", container)
        f.Size = UDim2.new(0.88, 0, 0, 35)
        f.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        f.BorderSizePixel = 0
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
        
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(0.6, 0, 1, 0)
        l.Position = UDim2.new(0.05, 0, 0, 0)
        l.BackgroundTransparency = 1
        l.Font = Enum.Font.Gotham
        l.Text = name
        l.TextColor3 = Color3.fromRGB(255, 255, 255)
        l.TextSize = 13
        l.TextXAlignment = Enum.TextXAlignment.Left
        
        local b = Instance.new("TextButton", f)
        b.Size = UDim2.new(0.28, 0, 0.6, 0)
        b.Position = UDim2.new(0.68, 0, 0.2, 0)
        b.BackgroundColor3 = settings[setting] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        b.BorderSizePixel = 0
        b.Font = Enum.Font.GothamBold
        b.Text = settings[setting] and "ON" or "OFF"
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.TextSize = 11
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
        
        b.MouseButton1Click:Connect(function()
            settings[setting] = not settings[setting]
            b.BackgroundColor3 = settings[setting] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
            b.Text = settings[setting] and "ON" or "OFF"
        end)
    end
    
    local function createButton(container, text, callback)
        local b = Instance.new("TextButton", container)
        b.Size = UDim2.new(0.88, 0, 0, 35)
        b.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        b.BorderSizePixel = 0
        b.Font = Enum.Font.GothamBold
        b.Text = text
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.TextSize = 13
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        b.MouseButton1Click:Connect(callback)
        return b
    end
    
    -- MAIN
    local mainTitle = Instance.new("TextLabel", mainContainer)
    mainTitle.Size = UDim2.new(0.85, 0, 0, 25)
    mainTitle.BackgroundTransparency = 1
    mainTitle.Font = Enum.Font.GothamBold
    mainTitle.Text = "MAIN FUNCTIONS"
    mainTitle.TextColor3 = Color3.fromRGB(0, 150, 255)
    mainTitle.TextSize = 15
    mainTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    createToggle(mainContainer, "God Mode", "godmode")
    createToggle(mainContainer, "Auto Door", "autoDoor")
    
    local doorInput = Instance.new("TextBox", mainContainer)
    doorInput.Size = UDim2.new(0.35, 0, 0, 30)
    doorInput.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    doorInput.BorderSizePixel = 0
    doorInput.Font = Enum.Font.Gotham
    doorInput.PlaceholderText = "Door #"
    doorInput.Text = ""
    doorInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    doorInput.TextSize = 13
    Instance.new("UICorner", doorInput).CornerRadius = UDim.new(0, 5)
    
    createButton(mainContainer, "TP to Door", function()
        local n = tonumber(doorInput.Text)
        if n then
            local door = workspace:FindFirstChild("Door"..n) or workspace:FindFirstChild(n)
            if door then
                local c = player.Character
                if c and c:FindFirstChild("HumanoidRootPart") then
                    c.HumanoidRootPart.CFrame = door.CFrame + Vector3.new(0, 3, 0)
                end
            end
        end
    end)
    
    createButton(mainContainer, "TP to End", function()
        local c = player.Character
        if not c or not c:FindFirstChild("HumanoidRootPart") then return end
        local doors = {}
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name:lower():find("door") then
                table.insert(doors, v)
            end
        end
        if #doors > 0 then
            local lastDoor = doors[#doors]
            c.HumanoidRootPart.CFrame = lastDoor.CFrame + Vector3.new(0, 3, 0)
        end
    end)
    
    createButton(mainContainer, "AUTO COMPLETE", function()
        settings.autoDoor = true
        task.spawn(function()
            while settings.autoDoor do
                task.wait(0.5)
                local c = player.Character
                if c and c:FindFirstChild("HumanoidRootPart") then
                    local nearestDoor = nil
                    local minDist = 50
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("BasePart") and v.Name:lower():find("door") then
                            local dist = (c.HumanoidRootPart.Position - v.Position).Magnitude
                            if dist < minDist then
                                minDist = dist
                                nearestDoor = v
                            end
                        end
                    end
                    if nearestDoor then
                        c.Humanoid:MoveTo(nearestDoor.Position)
                        task.wait(1)
                        c.HumanoidRootPart.CFrame = nearestDoor.CFrame + Vector3.new(0, 3, 0)
                    end
                end
            end
        end)
    end)
    
    -- ESP
    local espTitle = Instance.new("TextLabel", espContainer)
    espTitle.Size = UDim2.new(0.85, 0, 0, 25)
    espTitle.BackgroundTransparency = 1
    espTitle.Font = Enum.Font.GothamBold
    espTitle.Text = "ESP SETTINGS"
    espTitle.TextColor3 = Color3.fromRGB(0, 150, 255)
    espTitle.TextSize = 15
    espTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    createToggle(espContainer, "Players", "espPlayers")
    createToggle(espContainer, "Doors", "espDoors")
    createToggle(espContainer, "Gold", "espGold")
    createToggle(espContainer, "Monsters", "espMonsters")
    createToggle(espContainer, "Items", "espItems")
    
    -- PLAYER
    local playerTitle = Instance.new("TextLabel", playerContainer)
    playerTitle.Size = UDim2.new(0.85, 0, 0, 25)
    playerTitle.BackgroundTransparency = 1
    playerTitle.Font = Enum.Font.GothamBold
    playerTitle.Text = "PLAYER"
    playerTitle.TextColor3 = Color3.fromRGB(0, 150, 255)
    playerTitle.TextSize = 15
    playerTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    createToggle(playerContainer, "Speed Hack", "speedhack")
    
    local spdInput = Instance.new("TextBox", playerContainer)
    spdInput.Size = UDim2.new(0.35, 0, 0, 30)
    spdInput.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    spdInput.BorderSizePixel = 0
    spdInput.Font = Enum.Font.Gotham
    spdInput.Text = "50"
    spdInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    spdInput.TextSize = 13
    Instance.new("UICorner", spdInput).CornerRadius = UDim.new(0, 5)
    spdInput.FocusLost:Connect(function()
        local n = tonumber(spdInput.Text)
        if n and n >= 16 and n <= 500 then settings.speedValue = n end
        spdInput.Text = tostring(settings.speedValue)
    end)
    
    createToggle(playerContainer, "No Clip", "noclip")
    
    -- Hide button
    local hideBtn = Instance.new("TextButton", gui)
    hideBtn.Size = UDim2.new(0, 35, 0, 35)
    hideBtn.Position = UDim2.new(0.95, -18, 0.5, -18)
    hideBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    hideBtn.BorderSizePixel = 0
    hideBtn.Font = Enum.Font.GothamBold
    hideBtn.Text = "S"
    hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    hideBtn.TextSize = 16
    hideBtn.ZIndex = 10
    Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(1, 0)
    hideBtn.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)
    
    uis.InputBegan:Connect(function(input, g)
        if input.KeyCode == Enum.KeyCode.Insert and not g then main.Visible = not main.Visible end
    end)
    
    -- Loops
    run.Heartbeat:Connect(function()
        if settings.godmode then
            pcall(function()
                local c = player.Character
                if c and c:FindFirstChild("Humanoid") then
                    c.Humanoid.Health = c.Humanoid.MaxHealth
                end
            end)
        end
    end)
    
    run.Heartbeat:Connect(function()
        if settings.speedhack then
            pcall(function()
                local c = player.Character
                if c and c:FindFirstChild("Humanoid") then
                    c.Humanoid.WalkSpeed = settings.speedValue
                end
            end)
        end
    end)
    
    task.spawn(function()
        while true do
            task.wait(0.1)
            if settings.noclip then
                pcall(function()
                    local c = player.Character
                    if c then
                        for _, v in pairs(c:GetDescendants()) do
                            if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
                        end
                    end
                end)
            end
        end
    end)
    
    -- ESP System
    local espObjects = {}
    
    local function findRoomObjects()
        for _, e in pairs(espObjects) do
            for _, d in pairs(e) do
                if type(d) == "userdata" then pcall(function() d:Remove() end) end
            end
        end
        espObjects = {}
        
        local c = player.Character
        if not c or not c:FindFirstChild("HumanoidRootPart") then return end
        local hrpPos = c.HumanoidRootPart.Position
        
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                local dist = (hrpPos - v.Position).Magnitude
                if dist < 50 then
                    local name = v.Name:lower()
                    local color = nil
                    local objType = nil
                    
                    if name:find("door") then
                        if settings.espDoors then color = Color3.fromRGB(0, 150, 255); objType = "Door" end
                    elseif name:find("gold") or name:find("coin") then
                        if settings.espGold then color = Color3.fromRGB(255, 215, 0); objType = "Gold" end
                    elseif name:find("monster") or name:find("rush") or name:find("screech") or name:find("seek") then
                        if settings.espMonsters then color = Color3.fromRGB(255, 0, 0); objType = "Monster" end
                    elseif name:find("key") or name:find("item") or name:find("book") or name:find("lock") then
                        if settings.espItems then color = Color3.fromRGB(0, 255, 0); objType = "Item" end
                    end
                    
                    if color and objType then
                        local tr = Drawing.new("Line"); tr.Visible = false; tr.Color = color; tr.Thickness = 1.5
                        local bx = Drawing.new("Square"); bx.Visible = false; bx.Color = color; bx.Thickness = 1.5; bx.Filled = false
                        table.insert(espObjects, {Type=objType, Obj=v, Tracer=tr, Box=bx, Color=color})
                    end
                end
            end
        end
        
        if settings.espPlayers then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                    local dist = (hrpPos - p.Character.Head.Position).Magnitude
                    if dist < 50 then
                        local color = Color3.fromRGB(0, 255, 255)
                        local tr = Drawing.new("Line"); tr.Visible = false; tr.Color = color; tr.Thickness = 1.5
                        local bx = Drawing.new("Square"); bx.Visible = false; bx.Color = color; bx.Thickness = 1.5; bx.Filled = false
                        local nm = Drawing.new("Text"); nm.Visible = false; nm.Color = color; nm.Size = 13; nm.Center = true; nm.Outline = true
                        table.insert(espObjects, {Type="Player", Obj=p.Character, Tracer=tr, Box=bx, NameTag=nm, Color=color})
                    end
                end
            end
        end
    end
    
    local function updateESP()
        for _, e in pairs(espObjects) do
            if e.Type == "Player" then
                local c = e.Obj
                if not c or not c:FindFirstChild("Head") then
                    e.Tracer.Visible = false; e.Box.Visible = false; e.NameTag.Visible = false
                    continue
                end
                local pos, on = cam:WorldToViewportPoint(c.Head.Position)
                if not on then e.Tracer.Visible = false; e.Box.Visible = false; e.NameTag.Visible = false; continue end
                e.Tracer.From = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y)
                e.Tracer.To = Vector2.new(pos.X, pos.Y)
                e.Tracer.Visible = true
                local bs = Vector2.new(2000/pos.Z, 3000/pos.Z)
                e.Box.Size = bs; e.Box.Position = Vector2.new(pos.X-bs.X/2, pos.Y-bs.Y/2); e.Box.Visible = true
                e.NameTag.Text = e.Obj.Parent.Name
                e.NameTag.Position = Vector2.new(pos.X, pos.Y-30); e.NameTag.Visible = true
            else
                if not e.Obj or not e.Obj.Parent then
                    e.Tracer.Visible = false; e.Box.Visible = false
                    continue
                end
                local pos, on = cam:WorldToViewportPoint(e.Obj.Position)
                if not on then e.Tracer.Visible = false; e.Box.Visible = false; continue end
                e.Tracer.From = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y)
                e.Tracer.To = Vector2.new(pos.X, pos.Y)
                e.Tracer.Visible = true
                local bs = Vector2.new(1500/pos.Z, 1500/pos.Z)
                e.Box.Size = bs; e.Box.Position = Vector2.new(pos.X-bs.X/2, pos.Y-bs.Y/2); e.Box.Visible = true
            end
        end
    end
    
    task.spawn(function()
        local lastRoom = ""
        while true do
            task.wait(0.5)
            local c = player.Character
            if c and c:FindFirstChild("HumanoidRootPart") then
                local roomX = math.floor(c.HumanoidRootPart.Position.X / 50)
                local roomZ = math.floor(c.HumanoidRootPart.Position.Z / 50)
                local roomID = roomX .. "_" .. roomZ
                if roomID ~= lastRoom then
                    lastRoom = roomID
                    findRoomObjects()
                end
            end
        end
    end)
    
    run.RenderStepped:Connect(updateESP)
    
    print("[SPARTA] HUB активен в катке!")
end

-- Ожидание входа в катку
print("[SPARTA] Ожидание катки...")
waitForGame()
startHub()
