local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local waypoint = nil
--dih

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BrainrotWaypointGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 260)
frame.Position = UDim2.new(0.5, -160, 0.5, -130)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local function makeButton(parent, text, positionY, color)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(1, -40, 0, 50)
	btn.Position = UDim2.new(0, 20, 0, positionY)
	btn.BackgroundColor3 = color
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Text = text
	btn.Font = Enum.Font.SourceSansBold
	btn.TextScaled = true
	return btn
end

-- Buttons
local createBtn = makeButton(frame, "📍 Set Current Position", 20, Color3.fromRGB(0, 200, 100))
local tpBtn = makeButton(frame, "🚀 Teleport to Saved Spot", 80, Color3.fromRGB(70, 130, 255))
local speedBtn = makeButton(frame, "⚡ Toggle Super Speed OFF", 140, Color3.fromRGB(255, 165, 0))
local jumpBtn = makeButton(frame, "🦘 Toggle Super Jump OFF", 200, Color3.fromRGB(180, 0, 255))

-- Toggles & constants
local NORMAL_WALKSPEED = 16
local SUPER_WALKSPEED = 300
local NORMAL_JUMPPOWER = 50
local SUPER_JUMPPOWER = 200
local superSpeed = false
local superJump = false
local speedConnection = nil

-- Super Speed Enforcer
local function updateSpeedEnforcer()
	if speedConnection then speedConnection:Disconnect() end
	if superSpeed then
		speedConnection = RunService.RenderStepped:Connect(function()
			local char = player.Character
			if char then
				local h = char:FindFirstChildOfClass("Humanoid")
				if h and h.WalkSpeed ~= SUPER_WALKSPEED then
					h.WalkSpeed = SUPER_WALKSPEED
				end
			end
		end)
	end
end

-- Character reset
player.CharacterAdded:Connect(function(char)
	if speedConnection then speedConnection:Disconnect() end
	superSpeed = false
	speedBtn.Text = "⚡ Toggle Super Speed OFF"
	superJump = false
	jumpBtn.Text = "🦘 Toggle Super Jump OFF"
	local h = char:WaitForChild("Humanoid")
	h.WalkSpeed = NORMAL_WALKSPEED
	h.JumpPower = NORMAL_JUMPPOWER
end)

-- Button logic
createBtn.MouseButton1Click:Connect(function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		waypoint = player.Character.HumanoidRootPart.Position
		createBtn.Text = "✅ Saved!"
		wait(1)
		createBtn.Text = "📍 Set Current Position"
	end
end)

tpBtn.MouseButton1Click:Connect(function()
	if waypoint and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = CFrame.new(waypoint)
	else
		tpBtn.Text = "❌ No Saved Spot"
		wait(1)
		tpBtn.Text = "🚀 Teleport to Saved Spot"
	end
end)

speedBtn.MouseButton1Click:Connect(function()
	superSpeed = not superSpeed
	if superSpeed then
		speedBtn.Text = "⚡ Toggle Super Speed ON"
	else
		speedBtn.Text = "⚡ Toggle Super Speed OFF"
	end
	updateSpeedEnforcer()
end)

jumpBtn.MouseButton1Click:Connect(function()
	local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if h then
		superJump = not superJump
		h.JumpPower = superJump and SUPER_JUMPPOWER or NORMAL_JUMPPOWER
		jumpBtn.Text = superJump and "🦘 Toggle Super Jump ON" or "🦘 Toggle Super Jump OFF"
	end
end)
