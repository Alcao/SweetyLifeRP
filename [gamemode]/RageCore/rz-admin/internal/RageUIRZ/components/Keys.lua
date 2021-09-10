---
--- @author Dylan MALANDAIN
--- @version 2.0.0
--- @since 2020
---
--- RageUIRZ Is Advanced UI Libs in LUA for make beautiful interface like RockStar GAME.
---
---
--- Commercial Info.
--- Any use for commercial purposes is strictly prohibited and will be punished.
---
--- @see RageUIRZ
---


---@class Keys
Keys = {};

---Register
---@param Controls string
---@param ControlName string
---@param Description string
---@param Action function
---@return Keys
---@public
function Keys.Register(Controls, ControlName, Description, Action)
    local _Keys = {
        CONTROLS = Controls
    }
    RegisterKeyMapping(string.format('RageUIRZ-%s', ControlName), Description, "keyboard", Controls)
    RegisterCommand(string.format('RageUIRZ-%s', ControlName), function(source, args)
        if (Action ~= nil) then
            print(string.format('RageUIRZ - Pressed keys %s', Controls))
            Action();
        end
    end, false)
    return setmetatable(_Keys, Keys)
end

---Exists
---@param Controls string
---@return boolean
function Keys:Exists(Controls)
    return self.CONTROLS == Controls and true or false
end
