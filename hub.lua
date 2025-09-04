-- Hub básico com botão Speed Boost

-- Cria o ScreenGui
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Hub"
screenGui.Parent = playerGui

-- Cria o Frame do Hub
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Parent = screenGui

-- Título do Hub
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Hub Teste"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Parent = frame

-- Botão Speed Boost
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(1, -20, 0, 40)
speedButton.Position = UDim2.new(0, 10, 0, 50)
speedButton.Text = "Speed Boost"
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
speedButton.Parent = frame

-- Função ao clicar no botão
speedButton.MouseButton1Click:Connect(function()
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 50 -- Valor do speed boost
        end
    end
end)
