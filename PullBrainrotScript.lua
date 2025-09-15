-- Script completo: GUI estilizada + puxão contínuo
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Variáveis
local puxaoAtivo = false
local RaioEscolhido = 100 -- valor padrão

-- ====== CRIAÇÃO DA GUI ======
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Frame principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 160)
frame.Position = UDim2.new(0.5, -140, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Borda arredondada
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Sombra leve (UIStroke)
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(60, 60, 60)
stroke.Thickness = 2
stroke.Transparency = 0.6
stroke.Parent = frame

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Escolha o Raio"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.Parent = frame

-- Caixa de texto
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -40, 0, 40)
textBox.Position = UDim2.new(0, 20, 0, 50)
textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textBox.Text = tostring(RaioEscolhido)
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.Font = Enum.Font.Gotham
textBox.TextSize = 20
textBox.ClearTextOnFocus = true
textBox.TextScaled = true
textBox.Parent = frame

local textCorner = Instance.new("UICorner")
textCorner.CornerRadius = UDim.new(0, 8)
textCorner.Parent = textBox

-- Botão verde (ativar puxão)
local btnAtivar = Instance.new("TextButton")
btnAtivar.Size = UDim2.new(1, -40, 0, 40)
btnAtivar.Position = UDim2.new(0, 20, 0, 105)
btnAtivar.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
btnAtivar.Text = "Ativar Puxão"
btnAtivar.TextColor3 = Color3.fromRGB(255, 255, 255)
btnAtivar.Font = Enum.Font.GothamBold
btnAtivar.TextSize = 20
btnAtivar.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 10)
btnCorner.Parent = btnAtivar

btnAtivar.MouseButton1Click:Connect(function()
	local valor = tonumber(textBox.Text)
	if valor and valor > 0 then
		RaioEscolhido = valor
		print("Raio escolhido:", RaioEscolhido)
		puxaoAtivo = true
		frame.Visible = false
	else
		textBox.Text = "Digite um número válido!"
	end
end)

-- Botão vermelho (-) para diminuir o raio
local btnDiminuir = Instance.new("TextButton")
btnDiminuir.Size = UDim2.new(0, 40, 0, 30)
btnDiminuir.Position = UDim2.new(0, 10, 0, 10)
btnDiminuir.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
btnDiminuir.Text = "-"
btnDiminuir.TextColor3 = Color3.fromRGB(255,255,255)
btnDiminuir.Font = Enum.Font.GothamBold
btnDiminuir.TextSize = 22
btnDiminuir.Parent = frame

local minusCorner = Instance.new("UICorner")
minusCorner.CornerRadius = UDim.new(0, 8)
minusCorner.Parent = btnDiminuir

btnDiminuir.MouseButton1Click:Connect(function()
	local valor = tonumber(textBox.Text) or RaioEscolhido
	valor = math.max(10, valor - 10)
	textBox.Text = tostring(valor)
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
			dir = Vector3.new(dir.X, 0, dir.Z)
			if dir.Magnitude > 0 then
				hrp.Velocity = dir.Unit * 80
			end
		end
	end
end)
