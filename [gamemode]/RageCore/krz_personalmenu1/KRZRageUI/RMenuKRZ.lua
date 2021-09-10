---@type table
RageUI2 = {}

---@type table
RMenu2 = setmetatable({}, RMenu2)

---Add
---@param Type string
---@param Name string
---@param Menu table
---@return void
---@public
function RMenu2.Add(Type, Name, Menu, Restriction)
	if RMenu2[Type] == nil then
		RMenu2[Type] = {}
	end

	table.insert(RMenu2[Type], {
		Name = Name,
		Menu = Menu,
		Restriction = Restriction
	})
end

---Get
---@param Type string
---@param Name string
---@return table
---@public
function RMenu2.Get(Type, Name)
	if RMenu2[Type] ~= nil then
		for i = 1, #RMenu2[Type], 1 do
			if RMenu2[Type][i].Name == Name then
				return RMenu2[Type][i].Menu
			end
		end
	end
end

---Delete
---@param Type string
---@param Name string
---@return void
---@public
function RMenu2.Delete(Type, Name)
	if RMenu2[Type] ~= nil then
		for i = 1, #RMenu2[Type], 1 do
			if RMenu2[Type][i].Name == Name then
				table.remove(RMenu2[Type], i)
			end
		end
	end
end

---Settings
---@param Type string
---@param Name string
---@param Settings string
---@param Value any
---@return void
---@public
function RMenu2.Settings(Type, Name, Settings, Value)
	for i = 1, #RMenu2[Type], 1 do
		if RMenu2[Type][i].Name == Name then
			if Value ~= nil then
				RMenu2[Type][i][Settings] = Value
			else
				return RMenu2[Type][i][Settings]
			end
		end
	end
end