-- XENO TEST FLY GUI - COMPLETELY DIFFERENT
pcall(function()
	game.Players.LocalPlayer.PlayerGui:FindFirstChild("TEST_FLY_GUI"):Destroy()
end)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "TEST_FLY_GUI"
gui.Parent = plr.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.BorderSizePixel = 2
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
title.Text = "MADE BY INDORESX"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -30, 0, 0)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(120,0,0)
close.TextColor3 = Color3.new(1,1,1)
close.Parent = frame

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- DRAG
local dragging = false
local dragStart, startPos

title.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = i.Position
		startPos = frame.Position
	end
end)

UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(i)
	if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = i.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- BUTTON
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 220, 0, 60)
btn.Position = UDim2.new(0.5, -110, 0, 80)
btn.Text = "ENABLE FLY"
btn.TextSize = 22
btn.Font = Enum.Font.SourceSansBold
btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
btn.TextColor3 = Color3.new(1,1,1)
btn.Parent = frame

-- FLY
local flying = false
local bv, bg
local speed = 60

btn.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		btn.Text = "DISABLE FLY"
		hum.PlatformStand = true

		bg = Instance.new("BodyGyro", hrp)
		bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
		bg.P = 1e5

		bv = Instance.new("BodyVelocity", hrp)
		bv.MaxForce = Vector3.new(9e9,9e9,9e9)
	else
		btn.Text = "ENABLE FLY"
		hum.PlatformStand = false
		if bg then bg:Destroy() end
		if bv then bv:Destroy() end
	end
end)

RunService.RenderStepped:Connect(function()
	if flying and bv and bg then
		local cam = workspace.CurrentCamera
		bg.CFrame = cam.CFrame

		local v = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then v += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then v -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then v -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then v += cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then v += Vector3.new(0,1,0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then v -= Vector3.new(0,1,0) end

		bv.Velocity = v.Magnitude > 0 and v.Unit * speed or Vector3.zero
	end
end)
