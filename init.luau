local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local directions = {
	[Enum.KeyCode.A] = "left",
	[Enum.KeyCode.D] = "right",
	[Enum.KeyCode.S] = "backward",
	[Enum.KeyCode.W] = "forward",
	[Enum.KeyCode.Space] = "up",

	[Enum.KeyCode.Left] = "left",
	[Enum.KeyCode.Right] = "right",
	[Enum.KeyCode.Down] = "backward",
	[Enum.KeyCode.Up] = "forward",

	[Enum.KeyCode.DPadLeft] = "left",
	[Enum.KeyCode.DPadRight] = "right",
	[Enum.KeyCode.DPadDown] = "backward",
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

	if input.KeyCode == Enum.KeyCode.F and (currentMode ~= nil and currentPart ~= nil) then
		currentMode = nil
		currentPart:Destroy()
		currentPart = nil
		db = true
		task.delay(cooldown, function()
			db = false
		end)
		return
	end

	local mode = modes[input.KeyCode]
	local direction = directions[input.KeyCode]

	if mode ~= nil then
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

		if currentMode == nil then
			local part = Instance.new("Part")
			part.Anchored = true
			part.CanCollide = true
			part.CanQuery = false
			part.Parent = workspace
			part.Size = Vector3.new(2, 2, 2)
			part.CFrame = (hrs.CFrame * CFrame.new(0, 0, -3))

			currentPart = part
		end
		currentMode = mode

		if direction == nil then
			return
		end
	elseif direction ~= nil and currentPart ~= nil then
		if currentMode == "scalar" then
			db = true
			task.delay(1, function()
				db = false
			end)
			local tweenInfo = TweenInfo.new(1)
			if direction == "left" or direction == "right" then
				local targetSize = currentPart.Size + Vector3.new(5, 0, 0)
				local tween = TweenService:Create(currentPart, tweenInfo, { Size = targetSize })
				tween:Play()
			elseif direction == "forward" or direction == "backward" then
				local targetSize = currentPart.Size + Vector3.new(0, 5, 0)
				local tween = TweenService:Create(currentPart, tweenInfo, { Size = targetSize })
				tween:Play()
			elseif direction == "up" then
				local targetSize = currentPart.Size + Vector3.new(0, 0, 15)
				local sizeTween = TweenService:Create(currentPart, tweenInfo, { Size = targetSize })
				local cframeTween = TweenService:Create(
					currentPart,
					tweenInfo,
					{ CFrame = currentPart.CFrame * CFrame.new(0, 0, -7.5) }
				)
				sizeTween:Play()
				cframeTween:Play()
			end
		elseif currentMode == "moving" then
			db = true
			task.delay(1, function()
				db = false
			end)
			local tweenInfo = TweenInfo.new(1)
			local shiftDown = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
				or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
			local moveDirection = direction
			if shiftDown and direction == "backward" then
				moveDirection = "bottom"
			end
			if moveDirection == "left" then
				currentPart.Size += Vector3.new(5, 0, 0)
				local t1 =
					TweenService:Create(currentPart, tweenInfo, { CFrame = currentPart.CFrame * CFrame.new(-15, 0, 0) })
				t1:Play()
			elseif moveDirection == "right" then
				currentPart.Size += Vector3.new(5, 0, 0)
				local t1 =
					TweenService:Create(currentPart, tweenInfo, { CFrame = currentPart.CFrame * CFrame.new(15, 0, 0) })
				t1:Play()
			elseif moveDirection == "forward" then
				local t1 =
					TweenService:Create(currentPart, tweenInfo, { CFrame = currentPart.CFrame * CFrame.new(0, 0, -15) })
				t1:Play()
			elseif moveDirection == "backward" then
				local t1 =
					TweenService:Create(currentPart, tweenInfo, { CFrame = currentPart.CFrame * CFrame.new(0, 0, 15) })
				t1:Play()
			elseif moveDirection == "up" then
				local t1 =
					TweenService:Create(currentPart, tweenInfo, { CFrame = currentPart.CFrame * CFrame.new(0, 15, 0) })
				t1:Play()
			elseif moveDirection == "bottom" then
				local t1 =
					TweenService:Create(currentPart, tweenInfo, { CFrame = currentPart.CFrame * CFrame.new(0, -15, 0) })
				t1:Play()
			end
		end
	end
end)
