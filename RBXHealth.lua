-- More info: https://github.com/HaloCold/RBXHealth
-- RBXHealth Version 0.1-alpha

-- Scroll down for usage instructions!

local Settings = {
	--// General
	Health = 100; -- How much health you have.
	
	Shield = false; -- Gives an extra 100 health that is seperate.
	ShieldPower = 100; -- Health in a shield. Only change if Shield is true.
	
	--// Custom Death Screen
	
	CustomDeathScreen = false; -- Show a custom death screen when you die.
	DeathScreen = nil; -- The frame that will appear (Only set if CustomDeathScreen is true).
	
	-- Death Screens need to be a frame in which "Visible" is false.
	-- They need to be in an enabled GUI in the player's PlayerGui.
	
	--// Health Bar
	
	HealthBarHUD = true; -- Show a health bar on screen.
	
}

--[[

							INSTRUCTIONS

To take damage:

local RBXHealth = require(game.ServerScriptService.RBXHealth.Damage)

RBXHealth:TakeDamage(PlayerToTakeDamage, DamageAmount)

]]

--[[

      _______      _________      _____       ______     _
     / _____ \    |____ ____|    / ___ \     | ____ \   | |
    / /     \_\       | |       / /   \ \    | |   \ \  | |
    | |               | |      / /     \ \   | |   | |  | |
    \ \______         | |      | |     | |   | |___/ /  | |
     \______ \        | |      | |     | |   |  ____/   | |
            \ \       | |      | |     | |   | |        | |
     _      | |       | |      \ \     / /   | |        |_|
    \ \_____/ /       | |       \ \___/ /    | |         _
     \_______/        |_|        \_____/     |_|        |_|
     
     
     Do not change anything below unless you know what you are doing!
     
     Changing anything here can result in this script being broken.
     
]]

-- Some other stuff to save

local RBXHealth = {}

RBXHealth.ScreenGui = script.HUD.HealthHUD

RBXHealth.Settings = Settings

RBXHealth.Version = "0.1-alpha"
RBXHealth.Web = "https://github.com/HaloCold/RBXHealth"

RBXHealth.Functions = {}
RBXHealth.Service = {}

-- Functions

function RBXHealth.Functions.CloneGui(Player)
	local HUD = nil
	local BAR = nil
	
	if RBXHealth.Settings.HealthBarHUD == true then
		HUD = RBXHealth.ScreenGui:Clone()
		HUD.Parent = Player.PlayerGui
	end
end

function RBXHealth.Functions:JoinEvent(player)
	local Folder = Instance.new("Folder", player)
	Folder.Name = "RBXHealthValues"
	
	local Health = Instance.new("NumberValue", Folder)
	Health.Name = "Health"
	Health.Value = RBXHealth.Settings.Health
	
	if RBXHealth.Settings.Shield == true then
		local Shield = Instance.new("NumberValue", Folder)
		Shield.Name = "Shield"
		Shield.Value = RBXHealth.Settings.ShieldPower
	end
end

function RBXHealth.Service:TakeDamage(player, damageAmount)
	--[[
	if not player:FindFirstChild("RBXHealthValues") then
		print("RBXHealth - Error taking damage: RBXHealthValues is nil")
	else
		if not player.RBXHealthValues:FindFirstChild("Health") then
			print("RBXHealth - Error taking damage: RBXHealthValues.Health is nil")
		else
			player.RBXHealthValues.Health -= damageAmount
		end
	end
	]]
	
	if RBXHealth.Settings.Shield == true then
		if not player:FindFirstChild("RBXHealthValues") then
			print("RBXHealth - Error taking damage: RBXHealthValues is nil")
		else
			if not player:FindFirstChild("Health") then
				print("RBXHealth - Error taking damage: RBXHealthValues.Health is nil")
			end
			if not player:FindFirstChild("Shield") then
				print("RBXHealth - Error taking damage: RBXHealthValues.Shield is nil")
			end
			if player:FindFirstChild("RBXHealthValues"):FindFirstChild("Health") and player:FindFirstChild("RBXHealthValues"):FindFirstChild("Shield") then
				if player.RBXHealthValues.Shield.Value >= damageAmount then
					player.RBXHealthValues.Shield.Value -= damageAmount
				elseif player.RBXHealthValues.Shield.Value <= damageAmount then
					local HealthDamage = damageAmount - player.RBXHealthValues.Shield
					player.RBXHealthValues.Shield.Value = 0
					player.RBXHealthValues.Health.Value -= HealthDamage
				end
			end
		end
	end
	if RBXHealth.Settings.Shield == false then
		if not player:FindFirstChild("RBXHealthValues") then
			print("RBXHealth - Error taking damage: RBXHealthValues is nil")
		else
			if not player:FindFirstChild("Health") then
				print("RBXHealth - Error taking damage: RBXHealthValues.Health is nil")
			end
			if player:FindFirstChild("RBXHealthValues"):FindFirstChild("Health") then
				if player.RBXHealthValues.Health.Value >= damageAmount then
					player.RBXHealthValues.Health.Value -= damageAmount
				elseif player.RBXHealthValues.Health.Value <= damageAmount then
					player.RBXHealthValues.Health.Value = 0
				end
			end
		end
	end
	if RBXHealth.Settings.HealthBarHUD == true then
		player.PlayerGui.HealthHUD.Label.Text = tostring(player.RBXHealthValues.Health.Value).." / "..tostring(RBXHealth.Settings.Health)
	end
	
	return player.RBXHealthValues.Health.Value
end

function RBXHealth.Functions:OnDeath(player)
	if RBXHealth.Settings.CustomDeathScreen == true then
		if RBXHealth.Settings.DeathScreen == nil then
			print("RBXHealth - Error showing death screen: No frame provided")
			player.Character:WaitForChild("Humanoid").Health = -1
		else
			RBXHealth.Settings.DeathScreen.Visible = true
			player.Character:WaitForChild("Humanoid").Health = -1
		end
	end
	if RBXHealth.Settings.CustomDeathScreen == false then
		player.Character:WaitForChild("Humanoid").Health = -1
	end
	if RBXHealth.Settings.HealthBarHUD == true then
		player.PlayerGui.HealthHUD.Label.Text = "0 / "..tostring(RBXHealth.Settings.Health)
	end
end

--// Scripting

print("RBXHealth - Successfully loaded.")

game.Players.PlayerAdded:Connect(function(player)
	RBXHealth.Functions.JoinEvent(player) -- Set up the damage script
	RBXHealth.Functions.CloneGui(player) -- Set up HUD
end)

script.Event.OnServerEvent:Connect(function(player, amount)
	local damage = RBXHealth.Service.TakeDamage(player, amount) -- RelayFN
	if damage <= 0 then
		RBXHealth.Functions.OnDeath(player)
	end
end)
