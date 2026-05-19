-- +1 EVOLVE HUB PREMIUM

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

---------------------------------------------------
-- CONFIG
---------------------------------------------------

local flySpeed = 2
local FLYING = false

local teleportPosition = Vector3.new(7982, 207, 481)
local autoTeleport = false

local currentTab = "Fly"

local velocityHandlerName = "LUGVelocity"
local gyroHandlerName = "LUGGyro"

local mfly1
local mfly2

---------------------------------------------------
-- ROOT
---------------------------------------------------

local function getRoot(char)
	return char:FindFirstChild("HumanoidRootPart")
end

---------------------------------------------------
-- TELEPORT
---------------------------------------------------

local function teleport()
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")

	hrp.CFrame = CFrame.new(teleportPosition)
end

---------------------------------------------------
-- REMOVE FLY
---------------------------------------------------

local function unmobilefly(speaker)

	pcall(function()

		FLYING = false

		local root = getRoot(speaker.Character)

		if root and root:FindFirstChild(velocityHandlerName) then
			root:FindFirstChild(velocityHandlerName):Destroy()
		end

		if root and root:FindFirstChild(gyroHandlerName) then
			root:FindFirstChild(gyroHandlerName):Destroy()
		end

		local hum = speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid")

		if hum then
			hum.PlatformStand = false
		end

		if mfly1 then
			mfly1:Disconnect()
		end

		if mfly2 then
			mfly2:Disconnect()
		end
	end)
end

---------------------------------------------------
-- START FLY
---------------------------------------------------

local function mobilefly(speaker)

	unmobilefly(speaker)

	FLYING = true

	local root = getRoot(speaker.Character)
	local camera = workspace.CurrentCamera

	local v3zero = Vector3.new(0,0,0)
	local v3inf = Vector3.new(9e9,9e9,9e9)

	local controlModule = require(
		speaker.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")
	)

	local bv = Instance.new("BodyVelocity")
	bv.Name = velocityHandlerName
	bv.Parent = root
	bv.MaxForce = v3inf
	bv.Velocity = v3zero

	local bg = Instance.new("BodyGyro")
	bg.Name = gyroHandlerName
	bg.Parent = root
	bg.MaxTorque = v3inf
	bg.P = 1000
	bg.D = 50

	mfly2 = RunService.RenderStepped:Connect(function()

		root = getRoot(speaker.Character)
		camera = workspace.CurrentCamera

		if speaker.Character
			and root
			and root:FindFirstChild(velocityHandlerName)
			and root:FindFirstChild(gyroHandlerName) then

			local humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")

			local VelocityHandler = root:FindFirstChild(velocityHandlerName)
			local GyroHandler = root:FindFirstChild(gyroHandlerName)

			humanoid.PlatformStand = true

			GyroHandler.CFrame = camera.CFrame

			local direction = controlModule:GetMoveVector()

			local velocity =
				(camera.CFrame.LookVector * -direction.Z +
				camera.CFrame.RightVector * direction.X)
				* (flySpeed * 50)

			if direction.Magnitude <= 0 then

				local currentPos = root.Position

				local fakeSpeed = flySpeed * 50

				VelocityHandler.Velocity = Vector3.new(
					math.sin(tick() * 25) * fakeSpeed,
					0,
					math.cos(tick() * 25) * fakeSpeed
				)

				root.CFrame = CFrame.new(currentPos)

			else
				VelocityHandler.Velocity = velocity
			end
		end
	end)
end

---------------------------------------------------
-- GUI
---------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "+1 Evolve Hub Premium"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

---------------------------------------------------
-- MAIN FRAME
---------------------------------------------------

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,380,0,450)
frame.Position = UDim2.new(0.5,-190,0.5,-225)
frame.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,20)
corner.Parent = frame

-- Gradient Background
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 35)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 15))
}
gradient.Parent = frame

-- Shadow Effect
local shadow = Instance.new("Frame")
shadow.Size = frame.Size + UDim2.new(0, 40, 0, 40)
shadow.Position = frame.Position + UDim2.new(0, -20, 0, 20)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.6
shadow.BorderSizePixel = 0
shadow.ZIndex = 0
shadow.Parent = gui

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0,20)
shadowCorner.Parent = shadow

frame.ZIndex = 1

---------------------------------------------------
-- TOPBAR
---------------------------------------------------

local topbar = Instance.new("Frame")
topbar.Size = UDim2.new(1,0,0,60)
topbar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
topbar.BorderSizePixel = 0
topbar.Parent = frame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0,20)
topCorner.Parent = topbar

-- Gradient Topbar
local topGradient = Instance.new("UIGradient")
topGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 120, 200))
}
topGradient.Parent = topbar

---------------------------------------------------
-- TITLE
---------------------------------------------------

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-80,1,0)
title.Position = UDim2.new(0,20,0,0)
title.BackgroundTransparency = 1
title.Text = "✨ EVOLVE HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topbar

---------------------------------------------------
-- MINIMIZE BUTTON
---------------------------------------------------

local minimized = false

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0,35,0,35)
minimize.Position = UDim2.new(1,-75,0.5,-17.5)
minimize.Text = "━"
minimize.Font = Enum.Font.GothamBold
minimize.TextScaled = true
minimize.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
minimize.TextColor3 = Color3.new(1,1,1)
minimize.BorderSizePixel = 0
minimize.Parent = topbar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0,10)
minCorner.Parent = minimize

minimize.MouseEnter:Connect(function()
	minimize.BackgroundColor3 = Color3.fromRGB(0, 120, 220)
end)

minimize.MouseLeave:Connect(function()
	minimize.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
end)

---------------------------------------------------
-- CLOSE BUTTON
---------------------------------------------------

local close = Instance.new("TextButton")
close.Size = UDim2.new(0,35,0,35)
close.Position = UDim2.new(1,-35,0.5,-17.5)
close.Text = "✕"
close.Font = Enum.Font.GothamBold
close.TextScaled = true
close.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
close.TextColor3 = Color3.new(1,1,1)
close.BorderSizePixel = 0
close.Parent = topbar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0,10)
closeCorner.Parent = close

close.MouseEnter:Connect(function()
	close.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
end)

close.MouseLeave:Connect(function()
	close.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
end)

---------------------------------------------------
-- TAB BUTTONS
---------------------------------------------------

local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 50)
tabContainer.Position = UDim2.new(0, 0, 0, 60)
tabContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = frame

local tabPadding = Instance.new("UIPadding")
tabPadding.PaddingLeft = UDim.new(0, 10)
tabPadding.PaddingRight = UDim.new(0, 10)
tabPadding.PaddingTop = UDim.new(0, 5)
tabPadding.PaddingBottom = UDim.new(0, 5)
tabPadding.Parent = tabContainer

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 10)
tabLayout.Parent = tabContainer

local flyTab = Instance.new("TextButton")
flyTab.Size = UDim2.new(0.5, -5, 1, 0)
flyTab.Text = "🚀 FLY"
flyTab.Font = Enum.Font.GothamBold
flyTab.TextScaled = true
flyTab.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
flyTab.TextColor3 = Color3.new(1,1,1)
flyTab.BorderSizePixel = 0
flyTab.Parent = tabContainer

local flyTabCorner = Instance.new("UICorner")
flyTabCorner.CornerRadius = UDim.new(0,12)
flyTabCorner.Parent = flyTab

local farmTab = Instance.new("TextButton")
farmTab.Size = UDim2.new(0.5, -5, 1, 0)
farmTab.Text = "💰 FARM"
farmTab.Font = Enum.Font.GothamBold
farmTab.TextScaled = true
farmTab.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
farmTab.TextColor3 = Color3.new(1,1,1)
farmTab.BorderSizePixel = 0
farmTab.Parent = tabContainer

local farmTabCorner = Instance.new("UICorner")
farmTabCorner.CornerRadius = UDim.new(0,12)
farmTabCorner.Parent = farmTab

---------------------------------------------------
-- CONTENT CONTAINER
---------------------------------------------------

local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, 0, 1, -110)
contentContainer.Position = UDim2.new(0, 0, 0, 110)
contentContainer.BackgroundTransparency = 1
contentContainer.BorderSizePixel = 0
contentContainer.Parent = frame

local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingLeft = UDim.new(0, 20)
contentPadding.PaddingRight = UDim.new(0, 20)
contentPadding.PaddingTop = UDim.new(0, 20)
contentPadding.PaddingBottom = UDim.new(0, 20)
contentPadding.Parent = contentContainer

---------------------------------------------------
-- FLY CONTENT
---------------------------------------------------

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(1, 0, 0, 50)
flyButton.Position = UDim2.new(0, 0, 0, 0)
flyButton.Text = "FLY: OFF"
flyButton.Font = Enum.Font.GothamBold
flyButton.TextScaled = true
flyButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
flyButton.TextColor3 = Color3.new(1,1,1)
flyButton.BorderSizePixel = 0
flyButton.Parent = contentContainer

local flyButtonCorner = Instance.new("UICorner")
flyButtonCorner.CornerRadius = UDim.new(0,12)
flyButtonCorner.Parent = flyButton

flyButton.MouseEnter:Connect(function()
	flyButton:TweenSize(UDim2.new(1, 5, 0, 50), "Out", "Quad", 0.2, true)
end)

flyButton.MouseLeave:Connect(function()
	flyButton:TweenSize(UDim2.new(1, 0, 0, 50), "Out", "Quad", 0.2, true)
end)

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 35)
speedLabel.Position = UDim2.new(0, 0, 0, 70)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "⚡ VELOCIDADE: " .. flySpeed
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextScaled = true
speedLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
speedLabel.Parent = contentContainer

local speedControlContainer = Instance.new("Frame")
speedControlContainer.Size = UDim2.new(1, 0, 0, 50)
speedControlContainer.Position = UDim2.new(0, 0, 0, 115)
speedControlContainer.BackgroundTransparency = 1
speedControlContainer.BorderSizePixel = 0
speedControlContainer.Parent = contentContainer

local speedLayout = Instance.new("UIListLayout")
speedLayout.FillDirection = Enum.FillDirection.Horizontal
speedLayout.Padding = UDim.new(0, 10)
speedLayout.Parent = speedControlContainer

local minus = Instance.new("TextButton")
minus.Size = UDim2.new(0.5, -5, 1, 0)
minus.Text = "➖"
minus.Font = Enum.Font.GothamBold
minus.TextScaled = true
minus.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
minus.TextColor3 = Color3.new(1,1,1)
minus.BorderSizePixel = 0
minus.Parent = speedControlContainer

local minusCorner = Instance.new("UICorner")
minusCorner.CornerRadius = UDim.new(0,10)
minusCorner.Parent = minus

local plus = Instance.new("TextButton")
plus.Size = UDim2.new(0.5, -5, 1, 0)
plus.Text = "➕"
plus.Font = Enum.Font.GothamBold
plus.TextScaled = true
plus.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
plus.TextColor3 = Color3.new(1,1,1)
plus.BorderSizePixel = 0
plus.Parent = speedControlContainer

local plusCorner = Instance.new("UICorner")
plusCorner.CornerRadius = UDim.new(0,10)
plusCorner.Parent = plus

---------------------------------------------------
-- FARM CONTENT
---------------------------------------------------

local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(1, 0, 0, 50)
teleportButton.Position = UDim2.new(0, 0, 0, 20)
teleportButton.Text = "📍 TELEPORTAR"
teleportButton.Font = Enum.Font.GothamBold
teleportButton.TextScaled = true
teleportButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
teleportButton.TextColor3 = Color3.new(1,1,1)
teleportButton.BorderSizePixel = 0
teleportButton.Visible = false
teleportButton.Parent = contentContainer

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0,12)
teleportCorner.Parent = teleportButton

teleportButton.MouseEnter:Connect(function()
	teleportButton:TweenSize(UDim2.new(1, 5, 0, 50), "Out", "Quad", 0.2, true)
end)

teleportButton.MouseLeave:Connect(function()
	teleportButton:TweenSize(UDim2.new(1, 0, 0, 50), "Out", "Quad", 0.2, true)
end)

local autoButton = Instance.new("TextButton")
autoButton.Size = UDim2.new(1, 0, 0, 50)
autoButton.Position = UDim2.new(0, 0, 0, 90)
autoButton.Text = "AUTO: OFF"
autoButton.Font = Enum.Font.GothamBold
autoButton.TextScaled = true
autoButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
autoButton.TextColor3 = Color3.new(1,1,1)
autoButton.BorderSizePixel = 0
autoButton.Visible = false
autoButton.Parent = contentContainer

local autoCorner = Instance.new("UICorner")
autoCorner.CornerRadius = UDim.new(0,12)
autoCorner.Parent = autoButton

autoButton.MouseEnter:Connect(function()
	autoButton:TweenSize(UDim2.new(1, 5, 0, 50), "Out", "Quad", 0.2, true)
end)

autoButton.MouseLeave:Connect(function()
	autoButton:TweenSize(UDim2.new(1, 0, 0, 50), "Out", "Quad", 0.2, true)
end)

---------------------------------------------------
-- TAB SYSTEM
---------------------------------------------------

local function updateTabs()

	local flyVisible = currentTab == "Fly"
	local farmVisible = currentTab == "Farm"

	flyButton.Visible = flyVisible
	speedLabel.Visible = flyVisible
	speedControlContainer.Visible = flyVisible

	teleportButton.Visible = farmVisible
	autoButton.Visible = farmVisible

	if flyVisible then
		flyTab.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
		farmTab.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
	else
		flyTab.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
		farmTab.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
	end
end

updateTabs()

---------------------------------------------------
-- BUTTONS LOGIC
---------------------------------------------------

flyTab.MouseButton1Click:Connect(function()
	currentTab = "Fly"
	updateTabs()
end)

farmTab.MouseButton1Click:Connect(function()
	currentTab = "Farm"
	updateTabs()
end)

flyButton.MouseButton1Click:Connect(function()

	if not FLYING then

		mobilefly(player)

		flyButton.Text = "FLY: ON ✓"
		flyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)

	else

		unmobilefly(player)

		flyButton.Text = "FLY: OFF"
		flyButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)

	end
end)

plus.MouseButton1Click:Connect(function()

	flySpeed += 1
	speedLabel.Text = "⚡ VELOCIDADE: " .. flySpeed

end)

minus.MouseButton1Click:Connect(function()

	if flySpeed > 1 then
		flySpeed -= 1
		speedLabel.Text = "⚡ VELOCIDADE: " .. flySpeed
	end
end)

teleportButton.MouseButton1Click:Connect(function()
	teleport()
end)

autoButton.MouseButton1Click:Connect(function()

	autoTeleport = not autoTeleport

	if autoTeleport then
		autoButton.Text = "AUTO: ON ✓"
		autoButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
	else
		autoButton.Text = "AUTO: OFF"
		autoButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
	end
end)

---------------------------------------------------
-- AUTO LOOP
---------------------------------------------------

task.spawn(function()

	while true do

		task.wait(1)

		if autoTeleport then
			pcall(function()
				teleport()
			end)
		end
	end
end)

---------------------------------------------------
-- MINIMIZE
---------------------------------------------------

minimize.MouseButton1Click:Connect(function()

	minimized = not minimized

	if minimized then

		frame:TweenSize(UDim2.new(0, 380, 0, 60), "Out", "Quad", 0.3, true)
		
		flyTab.Visible = false
		farmTab.Visible = false
		tabContainer.Visible = false

		flyButton.Visible = false
		speedLabel.Visible = false
		speedControlContainer.Visible = false

		teleportButton.Visible = false
		autoButton.Visible = false

		minimize.Text = "☐"

	else

		frame:TweenSize(UDim2.new(0, 380, 0, 450), "Out", "Quad", 0.3, true)

		tabContainer.Visible = true
		flyTab.Visible = true
		farmTab.Visible = true

		updateTabs()

		minimize.Text = "━"

	end
end)

---------------------------------------------------
-- CLOSE
---------------------------------------------------

close.MouseButton1Click:Connect(function()

	unmobilefly(player)
	
	frame:TweenSize(UDim2.new(0, 380, 0, 0), "In", "Quad", 0.3, true)
	
	task.wait(0.3)
	gui:Destroy()

end)
