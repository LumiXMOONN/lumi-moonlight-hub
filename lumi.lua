

-- 🌙 LUMI MOONLIGHT HUB
-- Made by Lumi & Moonbeam 💜
-- Roblox Studio LocalScript

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local gui = Instance.new("ScreenGui")
gui.Name = "LumiMoonlightHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local purple = Color3.fromRGB(150, 85, 220)
local dark = Color3.fromRGB(25, 17, 38)
local white = Color3.fromRGB(245, 235, 255)

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(280, 370)
frame.Position = UDim2.new(0.5, -140, 0.5, -185)
frame.BackgroundColor3 = dark
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius =
    UDim.new(0, 15)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -75, 0, 48)
title.Position = UDim2.fromOffset(10, 0)
title.BackgroundTransparency = 1
title.Text = "🌙 LUMI MOONLIGHT"
title.TextColor3 = white
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.Parent = frame

local function makeButton(text, x, parent)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(34, 32)
    b.Position = UDim2.new(1, x, 0, 8)
    b.BackgroundColor3 = purple
    b.Text = text
    b.TextColor3 = white
    b.Font = Enum.Font.GothamBold
    b.TextSize = 17
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius =
        UDim.new(0, 8)
    return b
end

local minimize = makeButton("−", -75, frame)
local close = makeButton("×", -36, frame)

local reopen = Instance.new("TextButton")
reopen.Size = UDim2.fromOffset(55, 55)
reopen.Position = UDim2.new(0, 15, 0.5, 0)
reopen.BackgroundColor3 = dark
reopen.Text = "🌙"
reopen.TextSize = 28
reopen.Visible = false
reopen.Parent = gui
Instance.new("UICorner", reopen).CornerRadius =
    UDim.new(1, 0)

minimize.MouseButton1Click:Connect(function()
    frame.Visible = false
    reopen.Visible = true
end)

reopen.MouseButton1Click:Connect(function()
    frame.Visible = true
    reopen.Visible = false
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local function getCharacter()
    return player.Character
end

-- FLYING
local flying = false
local flyConnection
local speed = 55

local function setFlying(on)
    flying = on

    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end

    local char = getCharacter()
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if not root or not hum then return end

    if flying then
        local velocity = Instance.new("BodyVelocity")
        velocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        velocity.Parent = root

        local gyro = Instance.new("BodyGyro")
        gyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
        gyro.P = 9000
        gyro.Parent = root

        flyConnection = RunService.RenderStepped:Connect(function()
            if not root.Parent then return end

            local direction = hum.MoveDirection
            local vertical = hum.Jump and speed or 0

            velocity.Velocity =
                direction * speed + Vector3.new(0, vertical, 0)

            gyro.CFrame = camera.CFrame
        end)

        hum.PlatformStand = false

        task.spawn(function()
            while flying and root.Parent do
                task.wait()
            end
            velocity:Destroy()
            gyro:Destroy()
        end)
    end
end

-- GHOST EFFECT ON YOUR OWN CHARACTER
local ghost = false
local oldTransparency = {}

local function setGhost(on)
    ghost = on
    local char = getCharacter()
    if not char then return end

    if on then
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("BasePart") then
                oldTransparency[obj] = obj.LocalTransparencyModifier
                obj.LocalTransparencyModifier = 0.65
            end
        end
    else
        for part, value in pairs(oldTransparency) do
            if part and part.Parent then
                part.LocalTransparencyModifier = value
            end
        end
        oldTransparency = {}
    end
end

-- FUNNY LOCAL MESSAGE
local function funnyMessage()
    local message = Instance.new("TextLabel")
    message.Size = UDim2.fromScale(0.8, 0.12)
    message.Position = UDim2.fromScale(0.1, 0.2)
    message.BackgroundColor3 = dark
    message.TextColor3 = white
    message.TextScaled = true
    message.Font = Enum.Font.GothamBold
    message.Text = "💀 MOONBEAM HAS ENTERED THE CHAT 💀"
    message.Parent = gui

    Instance.new("UICorner", message).CornerRadius =
        UDim.new(0, 12)

    task.delay(3, function()
        message:Destroy()
    end)
end

-- BUTTON BUILDER
local function addToggle(name, y, callback)
    local state = false

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.88, 0, 0, 43)
    button.Position = UDim2.new(0.06, 0, 0, y)
    button.BackgroundColor3 = Color3.fromRGB(65, 40, 90)
    button.TextColor3 = white
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.Text = name .. " : OFF"
    button.Parent = frame

    Instance.new("UICorner", button).CornerRadius =
        UDim.new(0, 9)

    button.MouseButton1Click:Connect(function()
        state = not state
        button.Text = name .. (state and " : ON" or " : OFF")
        button.BackgroundColor3 = state and purple
            or Color3.fromRGB(65, 40, 90)
        callback(state)
    end)
end

addToggle("🪽 Flying", 65, setFlying)
addToggle("👻 Ghost Effect", 115, setGhost)

local troll = Instance.new("TextButton")
troll.Size = UDim2.new(0.88, 0, 0, 43)
troll.Position = UDim2.new(0.06, 0, 0, 165)
troll.BackgroundColor3 = purple
troll.TextColor3 = white
troll.Font = Enum.Font.GothamBold
troll.TextSize = 14
troll.Text = "💀 Funny Troll Message"
troll.Parent = frame

Instance.new("UICorner", troll).CornerRadius =
    UDim.new(0, 9)

troll.MouseButton1Click:Connect(funnyMessage)

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 35)
footer.Position = UDim2.new(0, 0, 1, -35)
footer.BackgroundTransparency = 1
footer.Text = "Made with 💜 Lumi x Moonbeam"
footer.TextColor3 = Color3.fromRGB(190, 155, 220)
footer.TextSize = 11
footer.Font = Enum.Font.Gotham
footer.Parent = frame

player.CharacterAdded:Connect(function()
    flying = false
    ghost = false
    oldTransparency = {}
end)
