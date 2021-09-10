---
--- @author Dylan MALANDAIN
--- @version 2.0.0
--- @since 2020
---
--- RageUIv2 Is Advanced UI Libs in LUA for make beautiful interface like RockStar GAME.
---
---
--- Commercial Info.
--- Any use for commercial purposes is strictly prohibited and will be punished.
---
--- @see RageUIv2
---

---@type table
local SettingsButton = {
    Rectangle = { Y = 0, Width = 431, Height = 38 },
    Text = { X = 8, Y = 3, Scale = 0.33 },
}

function RageUIv2.Separator(Label)
    local CurrentMenu = RageUIv2.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            local Option = RageUIv2.Options + 1
            if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
                if (Label ~= nil) then
                    RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + (CurrentMenu.WidthOffset * 2.5 ~= 0 and CurrentMenu.WidthOffset * 2.5 or 200), CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUIv2.ItemOffset, 0, SettingsButton.Text.Scale, 245, 245, 245, 255, 1)
                end
                RageUIv2.ItemOffset = RageUIv2.ItemOffset + SettingsButton.Rectangle.Height
                if (CurrentMenu.Index == Option) then
                    if (RageUIv2.LastControl) then
                        CurrentMenu.Index = Option - 1
                        if (CurrentMenu.Index < 1) then
                            CurrentMenu.Index = RageUIv2.CurrentMenu.Options
                        end
                    else
                        CurrentMenu.Index = Option + 1
                    end
                end
            end
            RageUIv2.Options = RageUIv2.Options + 1
        end
    end
end

