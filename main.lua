local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "FreeMenu"

local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.Image = "rbxassetid://8560913094" -- ปุ่มเปิด/ปิดแบบรูปภาพ
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Parent = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 150)
MainFrame.Position = UDim2.new(0, 70, 0, 10)
MainFrame.Visible = false
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Parent = ScreenGui

local function createBtn(text, y)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 200, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Parent = MainFrame
	return btn
end

-- Jump
local jumpEnabled = false
local jumpBtn = createBtn("Jump Power: OFF", 10)
jumpBtn.MouseButton1Click:Connect(function()
	jumpEnabled = not jumpEnabled
	jumpBtn.Text = jumpEnabled and "Jump Power: ON" or "Jump Power: OFF"
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.JumpPower = jumpEnabled and 100 or 50
	end
end)

-- Fast Pickup
local pickupEnabled = false
local pickupBtn = createBtn("Fast Pickup: OFF", 60)
pickupBtn.MouseButton1Click:Connect(function()
	pickupEnabled = not pickupEnabled
	pickupBtn.Text = pickupEnabled and "Fast Pickup: ON" or "Fast Pickup: OFF"
end)

-- Aimlock
local aimEnabled = true
local function getClosest()
	local closest, shortest = nil, math.huge
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
			local headPos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
			if onScreen then
				local dist = (Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2) - Vector2.new(headPos.X, headPos.Y)).Magnitude
				if dist < shortest then
					shortest = dist
					closest = p
				end
			end
		end
	end
	return closest
end

game:GetService("RunService").RenderStepped:Connect(function()
	if not aimEnabled then return end
	local target = getClosest()
	if target and target.Character and target.Character:FindFirstChild("Head") then
		Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
	end
end)

-- เปิด/ปิดเมนู
ToggleBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)
