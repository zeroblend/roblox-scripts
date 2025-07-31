-- Big Mobile Waypoint GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BigWaypointGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0.5, -150, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.1

local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(0, 12)

local createBtn = Instance.new("TextButton", frame)
createBtn.Size = UDim2.new(1, -40, 0, 60)
createBtn.Position = UDim2.new(0, 20, 0, 20)
createBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
createBtn.TextColor3 = Color3.new(1, 1, 1)
createBtn.Text = "📍 Create Waypoint"
createBtn.TextScaled = true
createBtn.Font = Enum.Font.SourceSansBold

local tpBtn = Instance.new("TextButton", frame)
tpBtn.Size = UDim2.new(1, -40, 0, 60)
tpBtn.Position = UDim2.new(0, 20, 0, 100)
tpBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
tpBtn.TextColor3 = Color3.new(1, 1, 1)
tpBtn.Text = "🚀 Teleport!"
tpBtn.TextScaled = true
tpBtn.Font = Enum.Font.SourceSansBold

local waypoint = nil

createBtn.MouseButton1Click:Connect(function()
	local player = game.Players.LocalPlayer
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		waypoint = char.HumanoidRootPart.Position
		createBtn.Text = "✅ Waypoint Saved"
		wait(1)
		createBtn.Text = "📍 Create Waypoint"
	end
end)

tpBtn.MouseButton1Click:Connect(function()
	if waypoint then
		local player = game.Players.LocalPlayer
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char:MoveTo(waypoint)
		end
	else
		tpBtn.Text = "❌ No Waypoint"
		wait(1)
		tpBtn.Text = "🚀 Teleport!"
	end
end)
