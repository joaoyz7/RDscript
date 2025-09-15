-- Script único: cria GUI e puxa player pro brainrot mais caro dentro do raio
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Variável para controlar se o puxão tá ativo
local puxaoAtivo = false
local RaioEscolhido = 100 -- valor padrão

-- ====== CRIAÇÃO DA GUI ======
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Escolha o raio"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.Parent = frame

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -20, 0, 40)
textBox.Position = UDim2.new(0, 10, 0, 50)
textBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
textBox.Text = tostring(RaioEscolhido)
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.Font = Enum.Font.SourceSans
textBox.TextSize = 20
textBox.ClearTextOnFocus = true
textBox.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -20, 0, 40)
button.Position = UDim2.new(0, 10, 0, 100)
button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
button.Text = "Confirmar e Ativar Puxão"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 20
button.Parent = frame

button.MouseButton1Click:Connect(function()
	local valor = tonumber(textBox.Text)
	if valor and valor > 0 then
		RaioEscolhido = valor
		print("Raio escolhido:", RaioEscolhido)
		frame.Visible = false
		puxaoAtivo = true
	else
		textBox.Text = "Digite um número válido!"
	end
end)

-- ====== FUNÇÃO PARA ENCONTRAR BRAINROT MAIS CARO DENTRO DO RAIO ======
local function encontrarBrainrot()
	local maisValioso = nil
	local maiorDinheiro = -math.huge

	for _, npc in ipairs(workspace:GetDescendants()) do
		if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("Money") then
			local distancia = (npc.HumanoidRootPart.Position - hrp.Position).Magnitude
			if distancia <= RaioEscolhido then
				local dinheiro = npc.Money.Value
				if dinheiro > maiorDinheiro then
					maiorDinheiro = dinheiro
					maisValioso = npc
				end
			end
		end
	end

	return maisValioso
end

-- ====== LOOP CONTÍNUO DO PUXÃO ======
RunService.RenderStepped:Connect(function()
	if puxaoAtivo then
		local alvo = encontrarBrainrot()
		if alvo and alvo:FindFirstChild("HumanoidRootPart") then
			local dir = (alvo.HumanoidRootPart.Position - hrp.Position)
			dir = Vector3.new(dir.X, 0, dir.Z) -- lateral apenas
			if dir.Magnitude > 0 then
				hrp.Velocity = dir.Unit * 80 -- velocidade do puxão
			end
		end
	end
end)
