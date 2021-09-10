---
--- @author Dylan MALANDAIN, Kalyptus
--- @version 1.0.0
--- File created at [23/05/2021 05:54]
---

CONTEXT_SETTINGS = {
	Button = {
		Width = 220,
		Height = 32,
	},
	Text = {
		X = 8.0,
		Y = 4.5,
		Scale = 0.26,
		Font = 0,
		Center = false,
		Outline = false,
		DropShadow = false,
	},
}

---@class EntityTable
---@field ID number
---@field Type number
---@field Model number
---@field Heading number
---@field Coords Vector4
---@field NetI number


Context = {
	Entity = {
		ID = nil,
		Type = nil,
		Model = nil,
		NetID = nil,
		Heading = nil,
		Coords = nil
	},
	Menus = {},
	Open = false,
	Position = vector2(0.0, 0.0),
	Offset = vector2(0.0, 0.0),
	Options = 0,
	Category = "main",
	CategoryID = 0,
}

function Context:OnClosed()
	ResetEntityAlpha(self.Entity.ID)
	self.Entity.ID = nil
	self.Entity.ID = nil
	self.Open = false
	self.Category = "main"
	self.Options = 0
end

function Context:Render()
	if (self.Entity.ID ~= nil) and (self.Menus[self.Entity.Type .. self.Category] ~= nil) then
		SetMouseCursorSprite(1)
		self.Menus[self.Entity.Type .. self.Category]()
		local X, Y = 1920, 1080
		local lastX, lastY = self.Offset.x, self.Offset.y
		if (lastY + CONTEXT_SETTINGS.Button.Height) >= Y then
			self.Position = vector2(self.Position.x, self.Position.y - 10.0)
		end
		if (lastX + CONTEXT_SETTINGS.Button.Width) >= X then
			self.Position = vector2(self.Position.x - 10.0, self.Position.y)
		end
		self.Options = 0
	end
end

function Context.CreateMenu(EntityType)
	return { EntityType = EntityType, Category = "main", Parent = nil, }
end

function Context.CreateSubMenu(Parent)
	local category = Context.CategoryID + 1
	Context.CategoryID = category;
	return { EntityType = Parent.EntityType, Category = category, Parent = Parent }
end

---IsVisible
---@param Menu any
---@param Callback fun(Item:ContextItems, Entity:EntityTable)
function Context:IsVisible(Menu, Callback)

	self.Menus[Menu.EntityType .. Menu.Category] = function()
		Callback(ContextItems, self.Entity)
		if Menu.Parent then
			ContextItems:AddButton("← Retour", nil, Menu.Parent)
		end
	end
end

local CONTROLS_ACTION = { 239, 240, 24, 25, 19 }
local IsControlPressed = IsControlPressed;
local DisableAllControlActions = DisableAllControlActions;
local SetMouseCursorActiveThisFrame = SetMouseCursorActiveThisFrame;
local EnableControlAction = EnableControlAction;
local SetMouseCursorSprite = SetMouseCursorSprite;
local ResetEntityAlpha = ResetEntityAlpha;
local SetEntityAlpha = SetEntityAlpha;
local NetworkGetNetworkIdFromEntity = NetworkGetNetworkIdFromEntity;
local IsControlJustPressed = IsControlJustPressed;
local IsDisabledControlJustPressed = IsDisabledControlJustPressed;
local IsDisabledControlPressed = IsDisabledControlPressed;

Citizen.CreateThread(function()
	while true do
		if not (CPlayer.IsInJail) and not (CPlayer.IsCuffed) and not (CPlayer.IsDeath) then

			if IsControlPressed(0, 19) or IsDisabledControlPressed(0, 19) then
				CPlayer.IsContextEnabled = true;
				DisableAllControlActions(2)
				SetMouseCursorActiveThisFrame()
				for _, control in ipairs(CONTROLS_ACTION) do
					EnableControlAction(0, control, true)
				end
				if (not Context.Open) then
					local isFound, entityCoords, surfaceNormal, entityHit, entityType, cameraDirection, mouse = Graphics.ScreenToWorld(150.0, 31)
					if (entityType ~= 0) then
						SetMouseCursorSprite(5)
						if Context.Entity.ID ~= entityHit then
							ResetEntityAlpha(Context.Entity.ID)
							Context.Entity.Coords = GetEntityCoords(Context.Entity.ID)
							Context.Entity.Heading = GetEntityHeading(Context.Entity.ID)
							Context.Entity.ID = entityHit
							SetEntityAlpha(Context.Entity.ID, 200, false)
						end
						local netID = NetworkGetNetworkIdFromEntity(entityHit)
						if IsControlJustPressed(0, 24) or IsDisabledControlJustPressed(0, 24) then
							local posX, posY = Graphics.ConvertToPixel(mouse.x, mouse.y)
							Context.Position = vector2(posX, posY)
							Context.Open = true
							Context.Entity = {
								ID = entityHit,
								Type = entityType,
								Heading = GetEntityHeading(Context.Entity.ID),
								Coords = GetEntityCoords(Context.Entity.ID),
								Model = GetEntityModel(entityHit) or 0,
								NetID = netID
							}
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
						end
					else
						if (Context.Entity.ID ~= nil) then
							ResetEntityAlpha(Context.Entity.ID)
							Context.Entity.ID = nil
						end
						SetMouseCursorSprite(1)
					end
				else
					Context:Render()
				end
				DisablePlayerFiring(CPlayer.Ped, true)
				DisableControlAction(0, 140) -- Melee R
			elseif Context.Entity.ID ~= nil then
				CPlayer.IsContextEnabled = false;
				Context:OnClosed()
			else
				CPlayer.IsContextEnabled = false;
			end
		end
		Citizen.Wait(1)
	end
end)
