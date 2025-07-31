-- Waypoint GUI Script for loadstring
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "WaypointGui"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(0.5, -110, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local makeWaypoint = Instance.new("TextButton", frame)
makeWaypoint.Size = UDim2.new(1, -20, 0, 40)
makeWaypoint.Position = UDim2.new(0, 10, 0, 10)
makeWaypoint.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
makeWaypoint.TextColor3 = Color3.fromRGB(255, 255, 255)
makeWaypoint.Text = "Create Waypoint"
makeWaypoint.Font = Enum.Font.SourceSans
makeWaypoint.TextSize = 20

local teleportButton = Instance.new("TextButton", frame)
teleportButton.Size = UDim2.new(1, -20, 0, 40)
teleportButton.Position = UDim2.new(0, 10, 0, 60)
teleportButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Text = "Teleport!"
teleportButton.Font = Enum.Font.SourceSans
teleportButton.TextSize = 20

-- Storage for saved location
local waypoint = nil

makeWaypoint.MouseButton1Click:Connect(function()
	local player = game.Players.LocalPlayer
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		waypoint = char.HumanoidRootPart.Position
		makeWaypoint.Text = "Waypoint Saved!"
		task.wait(1)
		makeWaypoint.Text = "Create Waypoint"
	end
end)

teleportButton.MouseButton1Click:Connect(function()
	if waypoint then
		local player = game.Players.LocalPlayer
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char:MoveTo(waypoint)
		end
	else
		teleportButton.Text = "No Waypoint!"
		task.wait(1)
		teleportButton.Text = "Teleport!"
	end
end)
