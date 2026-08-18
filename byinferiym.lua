local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

local function hideObject(obj)
    if obj:IsA("BasePart") then
        obj.LocalTransparencyModifier = 1

    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        obj.Transparency = 1
    end
end

local function hideCharacter(character)

    local head = character:FindFirstChild("Head")
    if head then
        hideObject(head)

        for _, obj in ipairs(head:GetDescendants()) do
            hideObject(obj)
        end
    end

    for _, name in ipairs({
        "RightUpperLeg",
        "RightLowerLeg",
        "RightFoot"
    }) do
        local part = character:FindFirstChild(name)
        if part then
            hideObject(part)

            for _, obj in ipairs(part:GetDescendants()) do
                hideObject(obj)
            end
        end
    end

    local rightLeg = character:FindFirstChild("Right Leg")
    if rightLeg then
        hideObject(rightLeg)

        for _, obj in ipairs(rightLeg:GetDescendants()) do
            hideObject(obj)
        end
    end
end

local function setup(character)

    task.defer(function()
        hideCharacter(character)
    end)
    character.DescendantAdded:Connect(function(obj)
        task.defer(function()
            hideCharacter(character)
        end)
    end)
    RunService.RenderStepped:Connect(function()
        if character.Parent then
            hideCharacter(character)
        end
    end)
end

if Player.Character then
    setup(Player.Character)
end

Player.CharacterAdded:Connect(setup)
