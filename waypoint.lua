-- Steal a Brainrot Waypoint GUI (Mobile Friendly)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local waypoint = nil

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BrainrotWaypointGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 200)
frame.Position = UDim2.new(0.5, -160, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

-- Create Waypoint Button
local createBtn = Instance.new("TextButton", frame)
createBtn.Size = UDim2.new(1, -40, 0, 70)
createBtn.Position = UDim2.new(0, 20, 0, 20)
createBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
createBtn.TextColor3 = Color3.new(1, 1, 1)
createBtn.Text = "📍 Set Current Position"
createBtn.Font = Enum.Font.SourceSansBold
createBtn.TextScaled = true

-- Teleport Button
local tpBtn = Instance.new("TextButton", frame)
tpBtn.Size = UDim2.new(1, -40, 0, 70)
tpBtn.Position = UDim2.new(0, 20, 0, 110)
tpBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
tpBtn.TextColor3 = Color3.new(1, 1, 1)
tpBtn.Text = "🚀 Teleport to Saved Spot"
tpBtn.Font = Enum.Font.SourceSansBold
tpBtn.TextScaled = true

-- Button Logic
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
