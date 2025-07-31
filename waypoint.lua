local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local waypoint = nil
local keepTeleporting = false
local invincible = false
local originalTakeDamage

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BrainrotWaypointGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 280)
frame.Position = UDim2.new(0.5, -160, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

-- Buttons
local function createButton(parent, posY, color, text)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(1, -40, 0, 60)
	btn.Position = UDim2.new(0, 20, 0, posY)
	btn.BackgroundColor3 = color
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Text = text
	btn.Font = Enum.Font.SourceSansBold
	btn.TextScaled = true
	return btn
end

local createBtn = createButton(frame, 20, Color3.fromRGB(0, 200, 100), "📍 Set Current Position")
local tpOnceBtn = createButton(frame, 90, Color3.fromRGB(70, 130, 255), "🚀 Teleport Once")
local startKeepBtn = createButton(frame, 160, Color3.fromRGB(0, 170, 255), "🔁 Start Keep Teleport")
local stopBtn = createButton(frame, 230, Color3.fromRGB(255, 70, 70), "🛑 Stop Teleport")

-- Raycast up to find safe teleport position
local function findSafePosition(startPos)
	local rayOrigin = startPos
	local rayDirection = Vector3.new(0, 50, 0)  -- cast 50 studs up
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {player.Character}
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

	local raycastResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
	if raycastResult then
		-- Hit something above, teleport a bit below hit point to avoid clipping
		return raycastResult.Position - Vector3.new(0, 3, 0)
	else
		-- Nothing above, teleport 15 studs up from start
		return startPos + Vector3.new(0, 15, 0)
	end
end

-- True invincibility by overriding TakeDamage
local function makeInvincible(duration)
	if invincible then return end
	invincible = true

	local humanoid = player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
	if not humanoid then return end

	originalTakeDamage = humanoid.TakeDamage

	humanoid.TakeDamage = function() end

	delay(duration, function()
		if humanoid then
			humanoid.TakeDamage = originalTakeDamage
		end
		invincible = false
	end)
end

-- Safe teleport helper
local function safeTeleport(pos)
	local safePos = findSafePosition(pos)
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = CFrame.new(safePos)
		makeInvincible(3)  -- 3 seconds invincibility after teleport
	end
end

-- Button logic

createBtn.MouseButton1Click:Connect(function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		waypoint = player.Character.HumanoidRootPart.Position
		createBtn.Text = "✅ Saved!"
		wait(1)
		createBtn.Text = "📍 Set Current Position"
	end
end)

tpOnceBtn.MouseButton1Click:Connect(function()
	if waypoint then
		keepTeleporting = false
		safeTeleport(waypoint)
	else
		tpOnceBtn.Text = "❌ No Saved Spot"
		wait(1)
		tpOnceBtn.Text = "🚀 Teleport Once"
	end
end)

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

stopBtn.MouseButton1Click:Connect(function()
	keepTeleporting = false
end)
