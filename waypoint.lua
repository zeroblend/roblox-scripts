local RunService = game:GetService("RunService")
local superSpeed = false
local SUPER_WALKSPEED = 100
local NORMAL_WALKSPEED = 16

local speedConnection = nil

speedBtn.MouseButton1Click:Connect(function()
	if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
		local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
		superSpeed = not superSpeed
		if superSpeed then
			-- Start enforcing walk speed every frame
			if speedConnection then speedConnection:Disconnect() end
			speedConnection = RunService.Heartbeat:Connect(function()
				if humanoid then
					humanoid.WalkSpeed = SUPER_WALKSPEED
				end
			end)
			speedBtn.Text = "⚡ Toggle Super Speed ON"
		else
			-- Stop enforcing and reset walk speed
			if speedConnection then
				speedConnection:Disconnect()
				speedConnection = nil
			end
			humanoid.WalkSpeed = NORMAL_WALKSPEED
			speedBtn.Text = "⚡ Toggle Super Speed OFF"
		end
	end
end)

-- Also reset speed enforcement on character spawn
player.CharacterAdded:Connect(function(char)
	if speedConnection then
		speedConnection:Disconnect()
		speedConnection = nil
	end
	superSpeed = false
	speedBtn.Text = "⚡ Toggle Super Speed OFF"
	
	local humanoid = char:WaitForChild("Humanoid")
	humanoid.WalkSpeed = NORMAL_WALKSPEED
end)
