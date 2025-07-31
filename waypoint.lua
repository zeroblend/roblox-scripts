-- Steal a Brainrot Utility Panel (Mobile Friendly, Draggable)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local waypoint = nil
local superSpeed = false
local superJump = false
local speedConnection, jumpConnection = nil, nil

local SUPER_WALKSPEED = 125
local SUPER_JUMPPOWER = 150
local NORMAL_WALKSPEED = 16
local NORMAL_JUMPPOWER = 50

-- UI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BrainrotWaypointGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 320)
frame.Position = UDim2.new(0.5, -160, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true -- ← basic dragging support
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local function createButton(yPos, text)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -40, 0, 60)
	btn.Position = UDim2.new(0, 20, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Text = text
	btn.Font = Enum.Font.SourceSansBold
	btn.TextScaled = true
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	return btn
end

local createBtn = createButton(20, "📍 Set Current Position")
local tpBtn = createButton(90, "🚀 Teleport to Saved Spot")
local speedBtn = createButton(160, "⚡ Toggle Super Speed OFF")
local jumpBtn = createButton(230, "🦘 Toggle Super Jump OFF")

-- Utility functions
local function makeInvincible(seconds)
	local char = player.Character
	if not char then return end
	for _, d in ipairs(char:GetDescendants()) do
		if d:IsA("Humanoid") then
			d:SetAttribute("Invincible", true)
		end
	end
	task.delay(seconds, function()
		for _, d in ipairs(char:GetDescendants()) do
			if d:IsA("Humanoid") then
				d:SetAttribute("Invincible", false)
			end
		end
	end)
end

-- Waypoint logic
createBtn.MouseButton1Click:Connect(function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		waypoint = player.Character.HumanoidRootPart.Position
		createBtn.Text = "✅ Saved!"
		task.wait(1)
		createBtn.Text = "📍 Set Current Position"
	end
end)

tpBtn.MouseButton1Click:Connect(function()
	if waypoint and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = CFrame.new(waypoint)
		makeInvincible(10)
	else
		tpBtn.Text = "❌ No Saved Spot"
		task.wait(1)
		tpBtn.Text = "🚀 Teleport to Saved Spot"
	end
end)

-- Super Speed logic
local function updateSpeedEnforcer()
	if speedConnection then speedConnection:Disconnect() end
	if superSpeed then
		speedConnection = RunService.Heartbeat:Connect(function()
			local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
			if h then h.WalkSpeed = SUPER_WALKSPEED end
		end)
	end
end

speedBtn.MouseButton1Click:Connect(function()
	superSpeed = not superSpeed
	speedBtn.Text = superSpeed and "⚡ Toggle Super Speed ON" or "⚡ Toggle Super Speed OFF"
	updateSpeedEnforcer()
	if not superSpeed then
		local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if h then h.WalkSpeed = NORMAL_WALKSPEED end
	end
end)

-- Super Jump logic
local function updateJumpEnforcer()
	if jumpConnection then jumpConnection:Disconnect() end
	if superJump then
		jumpConnection = RunService.Heartbeat:Connect(function()
			local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
			if h then h.JumpPower = SUPER_JUMPPOWER end
		end)
	end
end

jumpBtn.MouseButton1Click:Connect(function()
	superJump = not superJump
	jumpBtn.Text = superJump and "🦘 Toggle Super Jump ON" or "🦘 Toggle Super Jump OFF"
	updateJumpEnforcer()
	if not superJump then
		local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if h then h.JumpPower = NORMAL_JUMPPOWER end
	end
end)

-- Reset all toggles on respawn
player.CharacterAdded:Connect(function(char)
	if speedConnection then speedConnection:Disconnect() end
	if jumpConnection then jumpConnection:Disconnect() end
	superSpeed = false
	superJump = false
	speedBtn.Text = "⚡ Toggle Super Speed OFF"
	jumpBtn.Text = "🦘 Toggle Super Jump OFF"

	local humanoid = char:WaitForChild("Humanoid")
	humanoid.WalkSpeed = NORMAL_WALKSPEED
	humanoid.JumpPower = NORMAL_JUMPPOWER
end)
