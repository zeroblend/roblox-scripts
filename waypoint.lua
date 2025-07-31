local Players = game:GetService("Players")
local player = Players.LocalPlayer
local waypoint = nil
local keepTeleporting = false

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BrainrotWaypointGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 280)  -- taller for 4 buttons
frame.Position = UDim2.new(0.5, -160, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

-- Set Current Position Button
local createBtn = Instance.new("TextButton", frame)
createBtn.Size = UDim2.new(1, -40, 0, 60)
createBtn.Position = UDim2.new(0, 20, 0, 20)
createBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
createBtn.TextColor3 = Color3.new(1, 1, 1)
createBtn.Text = "📍 Set Current Position"
createBtn.Font = Enum.Font.SourceSansBold
createBtn.TextScaled = true

-- Teleport Once Button
local tpOnceBtn = Instance.new("TextButton", frame)
tpOnceBtn.Size = UDim2.new(1, -40, 0, 60)
tpOnceBtn.Position = UDim2.new(0, 20, 0, 90)
tpOnceBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
tpOnceBtn.TextColor3 = Color3.new(1, 1, 1)
tpOnceBtn.Text = "🚀 Teleport Once"
tpOnceBtn.Font = Enum.Font.SourceSansBold
tpOnceBtn.TextScaled = true

-- Start Keep Teleporting Button
local startKeepBtn = Instance.new("TextButton", frame)
startKeepBtn.Size = UDim2.new(1, -40, 0, 60)
startKeepBtn.Position = UDim2.new(0, 20, 0, 160)
startKeepBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
startKeepBtn.TextColor3 = Color3.new(1, 1, 1)
startKeepBtn.Text = "🔁 Start Keep Teleport"
startKeepBtn.Font = Enum.Font.SourceSansBold
startKeepBtn.TextScaled = true

-- Stop Teleporting Button
local stopBtn = Instance.new("TextButton", frame)
stopBtn.Size = UDim2.new(1, -40, 0, 50)
stopBtn.Position = UDim2.new(0, 20, 0, 230)
stopBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
stopBtn.TextColor3 = Color3.new(1, 1, 1)
stopBtn.Text = "🛑 Stop Teleport"
stopBtn.Font = Enum.Font.SourceSansBold
stopBtn.TextScaled = true

-- Helper function for safe teleport
local function safeTeleport(pos)
	local safePos = pos + Vector3.new(0, 5, 0)
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = CFrame.new(safePos)
	end
end

-- Set Current Position Logic
createBtn.MouseButton1Click:Connect(function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		waypoint = player.Character.HumanoidRootPart.Position
		createBtn.Text = "✅ Saved!"
		wait(1)
		createBtn.Text = "📍 Set Current Position"
	end
end)

-- Teleport Once Logic
tpOnceBtn.MouseButton1Click:Connect(function()
	if waypoint then
		keepTeleporting = false -- stop any keep-teleporting loop if active
		safeTeleport(waypoint)
	else
		tpOnceBtn.Text = "❌ No Saved Spot"
		wait(1)
		tpOnceBtn.Text = "🚀 Teleport Once"
	end
end)

-- Start Keep Teleporting Logic
startKeepBtn.MouseButton1Click:Connect(function()
	if waypoint then
		if not keepTeleporting then
			keepTeleporting = true
			spawn(function()
				while keepTeleporting and player.Character and player.Character:FindFirstChild("HumanoidRootPart") do
					safeTeleport(waypoint)
					wait()
				end
			end)
		end
	else
		startKeepBtn.Text = "❌ No Saved Spot"
		wait(1)
		startKeepBtn.Text = "🔁 Start Keep Teleport"
	end
end)

-- Stop Teleporting Logic
stopBtn.MouseButton1Click:Connect(function()
	keepTeleporting = false
end)
