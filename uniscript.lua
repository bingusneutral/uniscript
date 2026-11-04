local Player = game:GetService("Players").LocalPlayer
local RemoteEvent = game:GetService("ReplicatedStorage").Remotes.CharacterSoundEvent
local UserInputService = game:GetService("UserInputService")

local Customization = {
	LeftSleeve = false,
	RightSleeve = false,
	LeftSleeveColor = Color3.fromRGB(255, 255, 255),
	RightSleeveColor = Color3.fromRGB(255, 255, 255),
	Towel = true,
	TowelColor = Color3.fromRGB(255, 255, 255),
	LeftGlove = false,
	RightGlove = false,
	Number = "55",
	Name = "",
}

local function ApplyCustomization(Name, Number, LeftGlove, RightGlove)
    local Character = Player.Character or Player.CharacterAdded:Wait()

    if Character:WaitForChild("Uniform", 5) then
        if not LeftGlove then
			RemoteEvent:FireServer("Game", "Customization", "Toggle", "LeftGlove")
		end

        if not RightGlove then
			RemoteEvent:FireServer("Game", "Customization", "Toggle", "RightGlove")
		end
		
        RemoteEvent:FireServer("Game", "Customization", "Number", Number)
        RemoteEvent:FireServer("Game", "Customization", "Name", Name)
    end
end

local function AddTowel(Character)
	local Torso = Character:WaitForChild("Torso")

	local Towel = Instance.new("Part")
	Towel.Name = "Towel"
	Towel.Parent = Character:WaitForChild("Uniform")
	Towel.Size = Vector3.new(0.2, 1, 1)
	Towel.CustomPhysicalProperties = PhysicalProperties.new(3, 0.5, 0.05, 5, 2.5)
	Towel.CanCollide = false

	local PositionOffset = Vector3.new(
		1.062,
		-1.361,
		0.014
	)

	local RotationOffset = Vector3.new(
		-1.45,
		-147.363,
		-13.925
	)

	Towel.CFrame = Torso.CFrame
		* CFrame.new(PositionOffset)
		* CFrame.Angles(
			math.rad(RotationOffset.X),
			math.rad(RotationOffset.Y),
			math.rad(RotationOffset.Z)
		)

	local Mesh = Instance.new("SpecialMesh")
	Mesh.MeshId = "rbxassetid://6919149797"
	Mesh.TextureContent = Content.fromAssetId(6923948446)
	Mesh.Offset = Vector3.new(0, 0, 0)
	Mesh.Scale = Vector3.new(0.45, 0.5, 0.55)
	Mesh.Parent = Towel

	local Weld = Instance.new("WeldConstraint")
	Weld.Part0 = Torso
	Weld.Part1 = Towel
	Weld.Parent = Towel

	return Towel
end

local function AddLeftSleeve(Character)
	local LeftArm = Character:WaitForChild("Left Arm")

	local LeftSleeve = Instance.new("Part")
	LeftSleeve.Name = "LeftSleeve"
	LeftSleeve.Parent = Character:WaitForChild("Uniform")
	LeftSleeve.Size = Vector3.new(1.02, 1.258, 1.02)
	LeftSleeve.CFrame = LeftArm.CFrame * CFrame.new(0, 0.078, 0)
	LeftSleeve.Material = Enum.Material.Sand
	LeftSleeve.CanCollide = false

	local Weld = Instance.new("WeldConstraint")
	Weld.Part0 = LeftArm
	Weld.Part1 = LeftSleeve
	Weld.Parent = LeftSleeve

	return LeftSleeve
end

local function AddRightSleeve(Character)
	local RightArm = Character:WaitForChild("Right Arm")

	local RightSleeve = Instance.new("Part")
	RightSleeve.Name = "RightSleeve"
	RightSleeve.Parent = Character:WaitForChild("Uniform")
	RightSleeve.Size = Vector3.new(1.02, 1.258, 1.02)
	RightSleeve.CFrame = RightArm.CFrame * CFrame.new(0, 0.078, 0)
	RightSleeve.Material = Enum.Material.Sand
	RightSleeve.CanCollide = false

	local Weld = Instance.new("WeldConstraint")
	Weld.Part0 = RightArm
	Weld.Part1 = RightSleeve
	Weld.Parent = RightSleeve

	return RightSleeve
end

local function UpdateCharacter(Character)
	local Uniform = Character:WaitForChild("Uniform")

	local LeftTransparency = Customization.LeftGlove and 1 or 0
	local ChangeLeftGlove = Uniform:WaitForChild("LeftGlove", 15).Transparency ~= LeftTransparency

	local RightTransparency = Customization.RightGlove and 1 or 0
	local ChangeRightGlove = Uniform:WaitForChild("RightGlove", 15).Transparency ~= RightTransparency

	ApplyCustomization(Customization.Name, Customization.Number, ChangeLeftGlove, ChangeRightGlove)

	local OldTowel = Uniform:FindFirstChild("Towel")
	local OldLeftSleeve = Uniform:FindFirstChild("LeftSleeve")
	local OldRightSleeve = Uniform:FindFirstChild("RightSleeve")

	if OldTowel then OldTowel:Destroy() end
	if OldLeftSleeve then OldLeftSleeve:Destroy() end
	if OldRightSleeve then OldRightSleeve:Destroy() end

	local NewLeftSleeve = AddLeftSleeve(Character)
	NewLeftSleeve.Transparency = Customization.LeftSleeve and 0 or 1
		
	pcall(function() NewLeftSleeve.Color = Customization.LeftSleeveColor end)

	local NewRightSleeve = AddRightSleeve(Character)
	NewRightSleeve.Transparency = Customization.RightSleeve and 0 or 1

	pcall(function() NewRightSleeve.Color = Customization.RightSleeveColor end)

	local NewTowel = AddTowel(Character)
	NewTowel.Transparency = Customization.Towel and 0 or 1

	pcall(function() NewTowel.Mesh.VertexColor = Vector3.new(Customization.TowelColor.R, Customization.TowelColor.G, Customization.TowelColor.B) end)
end

local function getobjects(id)
	return game:GetObjects(id)
end

local AssetId = getcustomasset("UniformGui.rbxm")
local UniformGui = getobjects(AssetId)[1]
local Options = UniformGui.Options
local LeftChanger = UniformGui.LeftSleeve
local RightChanger = UniformGui.RightSleeve
local TowelChanger = UniformGui.Towel
local Changers = {}
local Visible = true

table.insert(Changers, LeftChanger)
table.insert(Changers, RightChanger)
table.insert(Changers, TowelChanger)

if getgenv().HideGui then
	UniformGui.Button.Visible = false

	UserInputService.InputBegan:Connect(function(Input, GP)
		if GP then return end
		if Input.KeyCode ~= Enum.KeyCode.LeftControl then return end

		Visible = not Visible

		for _, Option in Options:GetChildren() do
			Option.Visible = Visible
		end

		for _, Changer in Changers do
			Changer.Visible = false
		end
	end)
else
	UniformGui.Button.Activated:Connect(function()
		Visible = not Visible

		for _, Option in Options:GetChildren() do
			Option.Visible = Visible
		end

		for _, Changer in Changers do
			Changer.Visible = false
		end
	end)
end

for _, Option in Options:GetChildren() do
	task.spawn(function()
		local Check = Option:FindFirstChild("Check")
		local TextBox = Option:FindFirstChild("TextBox")
		local CustomizeButton = Option:FindFirstChild("CustomizeButton")

		if Check then
			task.spawn(function()
				if Check.Parent.Name == "Gloves" then
					Check.ImageTransparency = Customization.LeftGlove and 0 or 1
				else 
					Check.ImageTransparency = Customization[Check.Parent.Name] and 0 or 1
				end

				Check.Activated:Connect(function()
					if Check.Parent.Name == "Gloves" then
						Customization.LeftGlove = not Customization.LeftGlove
						Customization.RightGlove = not Customization.RightGlove

						Check.ImageTransparency = Customization.LeftGlove and 0 or 1
					else 
						Customization[Check.Parent.Name] = not Customization[Check.Parent.Name]
						Check.ImageTransparency = Customization[Check.Parent.Name] and 0 or 1
					end

					if Player.Character then
						UpdateCharacter(Player.Character)
					end
				end)
			end)
		end

		if TextBox then
			task.spawn(function()
				if TextBox.Parent.Name == "JerseyName" then
					TextBox.Text = Customization.Name
				elseif TextBox.Parent.Name == "JerseyNumber" then
					TextBox.Text = Customization.Number
				end

				TextBox.FocusLost:Connect(function()
					local Text = TextBox.Text

					if TextBox.Parent.Name == "JerseyName" then
						Customization.Name = Text
					elseif TextBox.Parent.Name == "JerseyNumber" then
						Customization.Number = Text
					end

					if Player.Character then
						UpdateCharacter(Player.Character)
					end
				end)
			end)
		end

		if CustomizeButton then
			CustomizeButton.Activated:Connect(function()
				LeftChanger.Visible = false
				RightChanger.Visible = false
				TowelChanger.Visible = false

				local Changer = UniformGui:FindFirstChild(CustomizeButton.Parent.Name)

				if Changer then Changer.Visible = true end
			end)
		end
	end)
end

UniformGui.ResetOnSpawn = false
UniformGui.Parent = Player.PlayerGui

UpdateCharacter(Player.Character)

Player.CharacterAdded:Connect(function(Character)
	UpdateCharacter(Character)
end)

for _, Changer in Changers do
	local R = 1
	local G = 1
	local B = 1

	local Sliders = Changer:FindFirstChild("Sliders"):GetChildren()

	for _, Slider in Sliders do
		local Dot = Slider:FindFirstChildOfClass("Frame")
		local DragDetector = Dot.UIDragDetector

		local LockedX = Dot.Position.X.Scale

		DragDetector.DragContinue:Connect(function()
			local ParentSize = Dot.Parent.AbsoluteSize
			local TargetY = Dot.Position.Y.Scale + (Dot.Position.Y.Offset / ParentSize.Y)

			Dot.Position = UDim2.new(
				LockedX,
				0,
				math.clamp(TargetY, 0, 0.9),
				0
			)

			local Position = Dot.Position.Y.Scale
			local Pos

			if Position < 0 then
				Pos = 0
			elseif Position > 0.9 then
				Pos = 0.9
			else
				Pos = Position
			end

			if Dot.Name == "R" then
				R = math.abs(Pos - 0.9) * (1 / 0.9)
			elseif Dot.Name == "G" then
				G = math.abs(Pos - 0.9) * (1 / 0.9)
			elseif Dot.Name == "B" then
				B = math.abs(Pos - 0.9) * (1 / 0.9)
			end

			Customization[Changer.Name .. "Color"] = Color3.new(R, G, B)
			print(Customization[Changer.Name .. "Color"])

			UpdateCharacter(Player.Character)
		end)
	end
end
