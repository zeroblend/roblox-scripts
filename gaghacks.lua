-- GUI + Core Script for Delta Executor

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Function to create simple UI
local function createTeleportUI()
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "TeleportPromptUI"

    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 250, 0, 150)
    Frame.Position = UDim2.new(0.5, -125, 0.4, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true

    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Text = "Teleport & Force Prompt"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Title.BorderSizePixel = 0
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14

    local Dropdown = Instance.new("TextButton", Frame)
    Dropdown.Position = UDim2.new(0.1, 0, 0.35, 0)
    Dropdown.Size = UDim2.new(0.8, 0, 0, 30)
    Dropdown.Text = "Select Player"
    Dropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    Dropdown.Font = Enum.Font.Gotham
    Dropdown.TextSize = 14

    local ConfirmBtn = Instance.new("TextButton", Frame)
    ConfirmBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
    ConfirmBtn.Size = UDim2.new(0.8, 0, 0, 30)
    ConfirmBtn.Text = "Teleport & Force Prompt"
    ConfirmBtn.BackgroundColor3 = Color3.fromRGB(30, 150, 30)
    ConfirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ConfirmBtn.Font = Enum.Font.Gotham
    ConfirmBtn.TextSize = 14

    -- DROPDOWN FUNCTIONALITY
    local selectedPlayer = nil
    Dropdown.MouseButton1Click:Connect(function()
        local menu = Instance.new("Frame", Frame)
        menu.Position = UDim2.new(0.1, 0, 0.55, 0)
        menu.Size = UDim2.new(0.8, 0, 0, #Players:GetPlayers() * 22)
        menu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        menu.BorderSizePixel = 0
        menu.Name = "DropdownMenu"
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local option = Instance.new("TextButton", menu)
                option.Size = UDim2.new(1, 0, 0, 20)
                option.Text = p.Name
                option.TextColor3 = Color3.fromRGB(255, 255, 255)
                option.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                option.Font = Enum.Font.Gotham
                option.TextSize = 12
                option.MouseButton1Click:Connect(function()
                    selectedPlayer = p
                    Dropdown.Text = p.Name
                    menu:Destroy()
                end)
            end
        end
    end)

    -- CONFIRM FUNCTIONALITY
    ConfirmBtn.MouseButton1Click:Connect(function()
        if selectedPlayer then
            teleportAndForcePrompt(selectedPlayer)
        else
            warn("No player selected.")
        end
    end)
end

-- Function to find nearest proximity prompt to a character
function getNearestPrompt(char)
    local closest, minDist = nil, math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Enabled then
            local parent = v.Parent
            if parent and parent:IsA("BasePart") then
                local dist = (char:GetPivot().Position - parent.Position).Magnitude
                if dist < minDist then
                    closest = v
                    minDist = dist
                end
            end
        end
    end
    return closest
end

-- Function to teleport & trigger proximity prompt
function teleportAndForcePrompt(target)
    if not target.Character or not LocalPlayer.Character then return end

    local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")

    if not myHRP or not targetHRP then return end

    -- Teleport target to near you
    targetHRP.CFrame = myHRP.CFrame + Vector3.new(2, 0, 0)

    task.wait(1)

    -- Force proximity prompt on them
    local nearestPrompt = getNearestPrompt(target.Character)
    if nearestPrompt then
        fireproximityprompt(nearestPrompt, nearestPrompt.HoldDuration or 10)
    else
        warn("No prompt nearby for target.")
    end
end

-- RUN
createTeleportUI()
