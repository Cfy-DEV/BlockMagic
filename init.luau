local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local directions = {
	[Enum.KeyCode.A] = "left",
	[Enum.KeyCode.D] = "right",
	[Enum.KeyCode.S] = "down",
	[Enum.KeyCode.W] = "forward",
	[Enum.KeyCode.Space] = "up",

	[Enum.KeyCode.Left] = "left",
	[Enum.KeyCode.Right] = "right",
	[Enum.KeyCode.Down] = "down",
	[Enum.KeyCode.Up] = "forward",

	[Enum.KeyCode.DPadLeft] = "left",
	[Enum.KeyCode.DPadRight] = "right",
	[Enum.KeyCode.DPadDown] = "down",
	[Enum.KeyCode.DPadUp] = "forward",
	[Enum.KeyCode.ButtonA] = "up",
}

local modes = {
	[Enum.KeyCode.E] = "scalar",
	[Enum.KeyCode.R] = "moving",

	[Enum.KeyCode.ButtonR1] = "scalar",
	[Enum.KeyCode.ButtonL1] = "moving",
}

local lp = Players.LocalPlayer
local currentPart: BasePart? = nil
local currentMode = nil
local db = false
local cooldown = 2

UserInputService.InputBegan:Connect(function(input: InputObject, gpe: boolean)
	if db then
		return
	end
	if gpe then
		return
	end

	if currentMode == nil then
		local mode = modes[input.KeyCode]
		if mode == nil then
			return
		end

		local char = lp.Character
		if not char then
			return
		end

		local hrs = char:FindFirstChild("HumanoidRootPart")
		if not hrs then
			return
		end

		local part = Instance.new("Part")
		part.Anchored = true
		part.CanCollide = true
		part.CanQuery = false
		part.Parent = workspace
		part.Size = Vector3.new(2, 2, 2)
		part.CFrame = (hrs.CFrame * CFrame.new(0, 0, -3))

		currentPart = part
		currentMode = mode

		task.delay(2, function()
			currentMode = nil
			part:Destroy()
			currentPart = nil
			db = true
			task.delay(cooldown, function()
				db = false
			end)
		end)
	elseif currentPart ~= nil then
		local direction = directions[input.KeyCode]

		if direction == nil then
			return
		end

		if currentMode == "scalar" then
			db = true
			task.delay(0.3, function()
				db = false
			end)
			local tweenInfo = TweenInfo.new(0.3)
			if direction == "left" or direction == "right" then
				local targetSize = currentPart.Size + Vector3.new(5, 0, 0)
				local tween = TweenService:Create(currentPart, tweenInfo, { Size = targetSize })
				tween:Play()
			elseif direction == "forward" or direction == "down" then
				local targetSize = currentPart.Size + Vector3.new(0, 5, 0)
				local tween = TweenService:Create(currentPart, tweenInfo, { Size = targetSize })
				tween:Play()
			elseif direction == "up" then
				local targetSize = currentPart.Size + Vector3.new(0, 0, 15)
				local sizeTween = TweenService:Create(currentPart, tweenInfo, { Size = targetSize })
				local cframeTween = TweenService:Create(currentPart, tweenInfo, { CFrame = currentPart.CFrame * CFrame.new(0, 0, -7.5) })
				sizeTween:Play()
				cframeTween:Play()
			end
		elseif currentMode == "moving" then
			db = true
			task.delay(0.5, function()
				db = false
			end)
			local tweenInfo = TweenInfo.new(0.5)
			if direction == "left" or direction == "right" then
				currentPart.Size += Vector3.new(5, 0, 0)
				local t1 = TweenService:Create(
					currentPart,
					tweenInfo,
					{ Position = currentPart.Position + Vector3.new(15, 0, 0) }
				)
				t1:Play()
			elseif direction == "forward" or direction == "down" then
				local t1 = TweenService:Create(
					currentPart,
					tweenInfo,
					{ Position = currentPart.Position + Vector3.new(0, 0, 15) }
				)
				t1:Play()
			elseif direction == "up" then
				local t1 = TweenService:Create(
					currentPart,
					tweenInfo,
					{ Position = currentPart.Position + Vector3.new(0, 15, 0) }
				)
				t1:Play()
			end
		end
	end
end)
