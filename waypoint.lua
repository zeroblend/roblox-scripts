local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local waypoint = nil
local superSpeed = false
local superJump = false

-- Configurable boosts
local NORMAL_WALKSPEED = 16
local SUPER_WALKSPEED = 100

local NORMAL_JUMPPOWER = 50
local SUPER_JUMPPOWER = 150

-- Create GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "UtilityPanelGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 300)
frame.Position = UDim2.new(0.5, -160, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

-- Helper to create buttons
local function createButton(parent, yPos, color, text)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(1, -40, 0, 60)
	btn.Position = UDim2.new(0, 20, 0, yPos)
	btn.BackgroundColor3 = color
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextScaled = true
	btn.Text = text
	return btn
end

-- Buttons
local setPosBtn = createButton(frame, 20, Color3.fromRGB(0, 200, 100), "📍 Set Current Position")
local teleportBtn = createButton(frame, 90, Color3.fromRGB(70, 130, 255), "🚀 Teleport to Saved Spot")
local speedBtn = createButton(frame, 160, Color3.fromRGB(255, 140, 0), "⚡ Toggle Super Speed OFF")
local jumpBtn = createButton(frame, 230, Color3.fromRGB(0, 170, 255), "🦘 Toggle Super Jump OFF")

-- Teleport helper with safe offset
local function safeTeleport(pos)
	local safePos = pos + Vector3.new(0, 10, 0)
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = CFrame.new(safePos)
	end
end

-- Set current position
setPosBtn.MouseButton1Click:Connect(function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		waypoint = player.Character.HumanoidRootPart.Position
		setPosBtn.Text = "✅ Position Saved!"
		wait(1)
		setPosBtn.Text = "📍 Set Current Position"
	end
end)

-- Teleport button
teleportBtn.MouseButton1Click:Connect(function()
	if waypoint then
		safeTeleport(waypoint)
	else
		teleportBtn.Text = "❌ No Saved Spot"
		wait(1)
		teleportBtn.Text = "🚀 Teleport to Saved Spot"
	end
end)

-- Toggle Super Speed
speedBtn.MouseButton1Click:Connect(function()
	if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
		local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
		superSpeed = not superSpeed
		if superSpeed then
			humanoid.WalkSpeed = SUPER_WALKSPEED
			speedBtn.Text = "⚡ Toggle Super Speed ON"
		else
			humanoid.WalkSpeed = NORMAL_WALKSPEED
			speedBtn.Text = "⚡ Toggle Super Speed OFF"
		end
	end
end)

-- Toggle Super Jump
jumpBtn.MouseButton1Click:Connect(function()
	if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
		local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
		superJump = not superJump
		if superJump then
			humanoid.JumpPower = SUPER_JUMPPOWER
			jumpBtn.Text = "🦘 Toggle Super Jump ON"
		else
			humanoid.JumpPower = NORMAL_JUMPPOWER
			jumpBtn.Text = "🦘 Toggle Super Jump OFF"
		end
	end
end)

-- Reset boosts on character respawn
player.CharacterAdded:Connect(function(char)
	char:WaitForChild("Humanoid").WalkSpeed = NORMAL_WALKSPEED
	char:WaitForChild("Humanoid").JumpPower = NORMAL_JUMPPOWER
	superSpeed = false
	superJump = false
	speedBtn.Text = "⚡ Toggle Super Speed OFF"
	jumpBtn.Text = "🦘 Toggle Super Jump OFF"
end)
