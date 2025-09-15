local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local backpack = player:WaitForChild("Backpack")

local puxaoAtivo = false
local RaioEscolhido = 100

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 160)
frame.Position = UDim2.new(0.5, -140, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "Escolha o Raio"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.Parent = frame

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -40, 0, 40)
textBox.Position = UDim2.new(0,20,0,50)
textBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
textBox.Text = tostring(RaioEscolhido)
textBox.TextColor3 = Color3.fromRGB(255,255,255)
textBox.Font = Enum.Font.Gotham
textBox.TextSize = 20
textBox.ClearTextOnFocus = true
textBox.TextScaled = true
textBox.Parent = frame

local textCorner = Instance.new("UICorner")
textCorner.CornerRadius = UDim.new(0,8)
textCorner.Parent = textBox

local btnPronto = Instance.new("TextButton")
btnPronto.Size = UDim2.new(1, -40, 0, 40)
btnPronto.Position = UDim2.new(0,20,0,105)
btnPronto.BackgroundColor3 = Color3.fromRGB(0,170,0)
btnPronto.Text = "Pronto"
btnPronto.TextColor3 = Color3.fromRGB(255,255,255)
btnPronto.Font = Enum.Font.GothamBold
btnPronto.TextSize = 20
btnPronto.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0,10)
btnCorner.Parent = btnPronto

local btnMin = Instance.new("TextButton")
btnMin.Size = UDim2.new(0,30,0,30)
btnMin.Position = UDim2.new(1,-35,0,5)
btnMin.BackgroundColor3 = Color3.fromRGB(200,0,0)
btnMin.Text = "_"
btnMin.TextColor3 = Color3.fromRGB(255,255,255)
btnMin.Font = Enum.Font.GothamBold
btnMin.TextSize = 20
btnMin.Parent = frame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0,6)
minCorner.Parent = btnMin

local minimizado = false
local normalSize = frame.Size
local normalPos = frame.Position
local miniSize = UDim2.new(0,60,0,40)

local function alternarGUI()
	if minimizado then
		frame.Size = normalSize
		frame.Position = normalPos
		minimizado = false
	else
		frame.Size = miniSize
		minimizado = true
	end
end

btnMin.MouseButton1Click:Connect(function()
	alternarGUI()
end)

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

local function equiparEPuxar(alvo)
	if not alvo or not alvo:FindFirstChild("HumanoidRootPart") then return end
	local tool = char:FindFirstChildOfClass("Tool") or backpack:FindFirstChildOfClass("Tool")
	if tool then
		if tool.Parent ~= char then
			tool.Parent = char
		end
		if tool:FindFirstChild("Handle") then
			tool:Activate()
		end
		local dir = (alvo.HumanoidRootPart.Position - hrp.Position)
		dir = Vector3.new(dir.X,0,dir.Z)
		if dir.Magnitude > 0 then
			hrp.Velocity = dir.Unit * 80
		end
	end
end

btnPronto.MouseButton1Click:Connect(function()
	local valor = tonumber(textBox.Text)
	if valor and valor > 0 then
		RaioEscolhido = valor
		local alvo = encontrarBrainrot()
		if alvo then
			equiparEPuxar(alvo)
			alternarGUI()
		end
	else
		textBox.Text = "Digite um número válido!"
	end
end)
