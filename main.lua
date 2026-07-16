-- // Универсальный скрипт: Malato62 Chaos Edition
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suz/Library/main/Source.lua"))()
local Window = Library:CreateWindow("TT: malato62 - Join Us")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- // Состояния
getgenv().AntiGravity = false
getgenv().MagnetEnabled = false
getgenv().SpamEmotes = false

-- // Модуль: Эмоции
local Animations = {
    "rbxassetid://33606898", "rbxassetid://33606925", 
    "rbxassetid://33606967", "rbxassetid://33606990", "rbxassetid://33607005"
}

local function PlayRandomEmote()
    local char = LocalPlayer.Character
    local animator = char and char:FindFirstChild("Humanoid") and char.Humanoid:FindFirstChild("Animator")
    if animator then
        local anim = Instance.new("Animation")
        anim.AnimationId = Animations[math.random(1, #Animations)]
        local track = animator:LoadAnimation(anim)
        track:Play()
    end
end

-- // Основной цикл физики
RunService.Heartbeat:Connect(function()
    if getgenv().AntiGravity then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 30, 0)
        end
    end

    if getgenv().MagnetEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if myRoot then
                    player.Character.HumanoidRootPart.CFrame = CFrame.new(player.Character.HumanoidRootPart.Position, myRoot.Position)
                    player.Character.HumanoidRootPart.AssemblyLinearVelocity = (myRoot.Position - player.Character.HumanoidRootPart.Position).Unit * 50
                end
            end
        end
    end
end)

-- // Интерфейс
local Tab = Window:AddTab("Chaos by malato62")

Tab:AddToggle("Анти-Гравитация", false, function(state) getgenv().AntiGravity = state end)
Tab:AddToggle("Магнит игроков", false, function(state) getgenv().MagnetEnabled = state end)
Tab:AddToggle("Спам эмоциями", false, function(state)
    getgenv().SpamEmotes = state
    task.spawn(function()
        while getgenv().SpamEmotes do
            PlayRandomEmote()
            task.wait(2)
        end
    end)
end)

Tab:AddButton("Убить физику (Жестко)", function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then obj.AssemblyLinearVelocity = Vector3.new(0, 100, 0) end
    end
end)

-- // Уведомление
task.spawn(function()
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "malato62",
            Text = "Join the chaos, join malato62!",
            Duration = 5
        })
    end)
end)
