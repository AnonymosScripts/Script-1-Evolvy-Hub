-- +1 EVOLVE HUB

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
gui.Name = "+1 Evolve Hub"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

---------------------------------------------------
-- FRAME
---------------------------------------------------

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,340,0,320)
frame.Position = UDim2.new(0.1,0,0.25,0)
frame.BackgroundColor3 = Color3.fromRGB(18,18,18)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,14)
corner.Parent = frame

---------------------------------------------------
-- TOPBAR
---------------------------------------------------

local topbar = Instance.new("Frame")
topbar.Size = UDim2.new(1,0,0,40)
topbar.BackgroundColor3 = Color3.fromRGB(28,28,28)
topbar.BorderSizePixel = 0
topbar.Parent = frame

local topcorner = Instance.new("UICorner")
topcorner.CornerRadius = UDim.new(0,14)
topcorner.Parent = topbar

---------------------------------------------------
-- TITLE
---------------------------------------------------

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-100,1,0)
title.Position = UDim2.new(0,12,0,0)
title.BackgroundTransparency = 1
title.Text = "+1 Evolve Hub"
title.TextColor3 = Color3.fromRGB(0,255,170)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topbar

---------------------------------------------------
-- MINIMIZE
---------------------------------------------------

local minimized = false

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0,28,0,28)
minimize.Position = UDim2.new(1,-70,0.5,-14)
minimize.Text = "-"
minimize.Font = Enum.Font.GothamBold
minimize.TextScaled = true
minimize.BackgroundColor3 = Color3.fromRGB(50,50,50)
minimize.TextColor3 = Color3.new(1,1,1)
minimize.Parent = topbar

local mincorner = Instance.new("UICorner")
mincorner.CornerRadius = UDim.new(0,8)
mincorner.Parent = minimize

---------------------------------------------------
-- CLOSE
---------------------------------------------------

local close = Instance.new("TextButton")
close.Size = UDim2.new(0,28,0,28)
close.Position = UDim2.new(1,-35,0.5,-14)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextScaled = true
close.BackgroundColor3 = Color3.fromRGB(255,70,70)
close.TextColor3 = Color3.new(1,1,1)
close.Parent = topbar

local closecorner = Instance.new("UICorner")
closecorner.CornerRadius = UDim.new(0,8)
closecorner.Parent = close

---------------------------------------------------
-- TAB BUTTONS
---------------------------------------------------

local flyTab = Instance.new("TextButton")
flyTab.Size = UDim2.new(0,140,0,35)
flyTab.Position = UDim2.new(0,15,0,55)
flyTab.Text = "FLY"
flyTab.Font = Enum.Font.GothamBold
flyTab.TextScaled = true
flyTab.BackgroundColor3 = Color3.fromRGB(0,170,255)
flyTab.TextColor3 = Color3.new(1,1,1)
flyTab.Parent = frame

local flytabcorner = Instance.new("UICorner")
flytabcorner.CornerRadius = UDim.new(0,10)
flytabcorner.Parent = flyTab

local farmTab = Instance.new("TextButton")
farmTab.Size = UDim2.new(0,140,0,35)
farmTab.Position = UDim2.new(0,180,0,55)
farmTab.Text = "FARM WINS"
farmTab.Font = Enum.Font.GothamBold
farmTab.TextScaled = true
farmTab.BackgroundColor3 = Color3.fromRGB(40,40,40)
farmTab.TextColor3 = Color3.new(1,1,1)
farmTab.Parent = frame

local farmcorner = Instance.new("UICorner")
farmcorner.CornerRadius = UDim.new(0,10)
farmcorner.Parent = farmTab

---------------------------------------------------
-- FLY CONTENT
---------------------------------------------------

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0,260,0,45)
flyButton.Position = UDim2.new(0.5,-130,0,110)
flyButton.Text = "FLY: OFF"
flyButton.Font = Enum.Font.GothamBold
flyButton.TextScaled = true
flyButton.BackgroundColor3 = Color3.fromRGB(255,80,80)
flyButton.TextColor3 = Color3.new(1,1,1)
flyButton.Parent = frame

local flycorner = Instance.new("UICorner")
flycorner.CornerRadius = UDim.new(0,10)
flycorner.Parent = flyButton

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1,0,0,30)
speedLabel.Position = UDim2.new(0,0,0,165)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "VELOCIDADE: "..flySpeed
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextScaled = true
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Parent = frame

local minus = Instance.new("TextButton")
minus.Size = UDim2.new(0,90,0,40)
minus.Position = UDim2.new(0.15,0,0,205)
minus.Text = "-"
minus.Font = Enum.Font.GothamBold
minus.TextScaled = true
minus.BackgroundColor3 = Color3.fromRGB(50,50,50)
minus.TextColor3 = Color3.new(1,1,1)
minus.Parent = frame

local plus = Instance.new("TextButton")
plus.Size = UDim2.new(0,90,0,40)
plus.Position = UDim2.new(0.55,0,0,205)
plus.Text = "+"
plus.Font = Enum.Font.GothamBold
plus.TextScaled = true
plus.BackgroundColor3 = Color3.fromRGB(50,50,50)
plus.TextColor3 = Color3.new(1,1,1)
plus.Parent = frame

---------------------------------------------------
-- FARM CONTENT
---------------------------------------------------

local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0,260,0,45)
teleportButton.Position = UDim2.new(0.5,-130,0,120)
teleportButton.Text = "TELEPORTAR"
teleportButton.Font = Enum.Font.GothamBold
teleportButton.TextScaled = true
teleportButton.BackgroundColor3 = Color3.fromRGB(0,170,255)
teleportButton.TextColor3 = Color3.new(1,1,1)
teleportButton.Visible = false
teleportButton.Parent = frame

local autoButton = Instance.new("TextButton")
autoButton.Size = UDim2.new(0,260,0,45)
autoButton.Position = UDim2.new(0.5,-130,0,185)
autoButton.Text = "AUTO: OFF"
autoButton.Font = Enum.Font.GothamBold
autoButton.TextScaled = true
autoButton.BackgroundColor3 = Color3.fromRGB(255,80,80)
autoButton.TextColor3 = Color3.new(1,1,1)
autoButton.Visible = false
autoButton.Parent = frame

---------------------------------------------------
-- TAB SYSTEM
---------------------------------------------------

local function updateTabs()

	local flyVisible = currentTab == "Fly"
	local farmVisible = currentTab == "Farm"

	flyButton.Visible = flyVisible
	speedLabel.Visible = flyVisible
	plus.Visible = flyVisible
	minus.Visible = flyVisible

	teleportButton.Visible = farmVisible
	autoButton.Visible = farmVisible

	if flyVisible then
		flyTab.BackgroundColor3 = Color3.fromRGB(0,170,255)
		farmTab.BackgroundColor3 = Color3.fromRGB(40,40,40)
	else
		flyTab.BackgroundColor3 = Color3.fromRGB(40,40,40)
		farmTab.BackgroundColor3 = Color3.fromRGB(0,170,255)
	end
end

updateTabs()

---------------------------------------------------
-- BUTTONS
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

		flyButton.Text = "FLY: ON"
		flyButton.BackgroundColor3 = Color3.fromRGB(0,200,100)

	else

		unmobilefly(player)

		flyButton.Text = "FLY: OFF"
		flyButton.BackgroundColor3 = Color3.fromRGB(255,80,80)

	end
end)

plus.MouseButton1Click:Connect(function()

	flySpeed += 1
	speedLabel.Text = "VELOCIDADE: "..flySpeed

end)

minus.MouseButton1Click:Connect(function()

	if flySpeed > 1 then
		flySpeed -= 1
		speedLabel.Text = "VELOCIDADE: "..flySpeed
	end
end)

teleportButton.MouseButton1Click:Connect(function()
	teleport()
end)

autoButton.MouseButton1Click:Connect(function()

	autoTeleport = not autoTeleport

	if autoTeleport then
		autoButton.Text = "AUTO: ON"
		autoButton.BackgroundColor3 = Color3.fromRGB(0,200,100)
	else
		autoButton.Text = "AUTO: OFF"
		autoButton.BackgroundColor3 = Color3.fromRGB(255,80,80)
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
	end)
end)

---------------------------------------------------
-- MINIMIZE
---------------------------------------------------

minimize.MouseButton1Click:Connect(function()

	minimized = not minimized

	if minimized then

		frame.Size = UDim2.new(0,340,0,40)

		flyTab.Visible = false
		farmTab.Visible = false

		flyButton.Visible = false
		speedLabel.Visible = false
		plus.Visible = false
		minus.Visible = false

		teleportButton.Visible = false
		autoButton.Visible = false

		minimize.Text = "+"

	else

		frame.Size = UDim2.new(0,340,0,320)

		updateTabs()

		flyTab.Visible = true
		farmTab.Visible = true

		minimize.Text = "-"

	end
end)

---------------------------------------------------
-- CLOSE
---------------------------------------------------

close.MouseButton1Click:Connect(function()

	unmobilefly(player)
	gui:Destroy()

end)
