local Player = game:GetService("Players").LocalPlayer
local RemoteEvent = game:GetService("ReplicatedStorage").Remotes.CharacterSoundEvent

local function ApplyCustomization()
    local Character = Player.Character or Player.CharacterAdded:Wait()

    if Character:WaitForChild("Uniform", 5) then
        RemoteEvent:FireServer("Game", "Customization", "Toggle", "LeftGlove")
        RemoteEvent:FireServer("Game", "Customization", "Toggle", "RightGlove")
    end
end

local function AddTowel(Character)
	local Torso = Character:WaitForChild("Torso")

	local Towel = Instance.new("Part")
	Towel.Name = "Towel"
	Towel.Parent = Character:WaitForChild("Uniform")
	Towel.Size = Vector3.new(0.2, 1, 1)
	Towel.CustomPhysicalProperties = PhysicalProperties.new(3, 0.5, 0.05, 5, 2.5)

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
end

if Player.Character then
	AddTowel(Player.Character)
	ApplyCustomization()
end

Player.CharacterAdded:Connect(function(Character)
	AddTowel(Character)
	ApplyCustomization()
end)
