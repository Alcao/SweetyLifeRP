---@type table
local SettingsButton = {
    Rectangle = { Y = 0, Width = 431, Height = 38 },
    Text = { X = 8, Y = 3, Scale = 0.33 },
    LeftBadge = { Y = -2, Width = 40, Height = 40 },
    RightBadge = { X = 385, Y = -2, Width = 40, Height = 40 },
    RightText = { X = 420, Y = 4, Scale = 0.35 },
    SelectedSprite = { Dictionary = "menutoutbo", Texture = "gradient_nav", Y = 0, Width = 431, Height = 38 },
}

---ButtonWithStyle
---@param Label string
---@param Description string
---@param Style table
---@param Enabled boolean
---@param Callback function
---@param Submenu table
---@return nil
---@public
function RageUIRZ.Button(Label, Description, Style, Enabled, Callback, Submenu)


    ---@type table
    local CurrentMenu = RageUIRZ.CurrentMenu;

    if CurrentMenu ~= nil then
        if CurrentMenu() then

            ---@type number
            local Option = RageUIRZ.Options + 1

            if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then

                ---@type boolean
                local Selected = CurrentMenu.Index == Option

                RageUIRZ.ItemsSafeZone(CurrentMenu)

                local LeftBadgeOffset = ((Style.LeftBadge == RageUIRZ.BadgeStyle.None or tonumber(Style.LeftBadge) == nil) and 0 or 27)
                local RightBadgeOffset = ((Style.RightBadge == RageUIRZ.BadgeStyle.None or tonumber(Style.RightBadge) == nil) and 0 or 32)

                local Hovered = false;
                if Style.Color ~= nil then
                    if Style.Color.BackgroundColor ~= nil then
                        RenderRectangle(CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUIRZ.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height, Style.Color.BackgroundColor[1], Style.Color.BackgroundColor[2], Style.Color.BackgroundColor[3], Style.Color.BackgroundColor[4])
                    end
                end
                ---@type boolean
                if CurrentMenu.EnableMouse == true then
                    Hovered = RageUIRZ.ItemsMouseBounds(CurrentMenu, Selected, Option, SettingsButton);
                end
                if Selected then
                    if Style.Color == nil then
                        RenderSprite(SettingsButton.SelectedSprite.Dictionary, SettingsButton.SelectedSprite.Texture, CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUIRZ.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height)
                    end

                    if Style.Color ~= nil and Style.Color.HightLightColor ~= nil then
                        RenderRectangle(CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUIRZ.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height, Style.Color.HightLightColor[1], Style.Color.HightLightColor[2], Style.Color.HightLightColor[3], Style.Color.HightLightColor[4])
                    else
                        RenderSprite(SettingsButton.SelectedSprite.Dictionary, SettingsButton.SelectedSprite.Texture, CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUIRZ.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height)
                    end
                end

                if type(Style) == 'table' then
                    if Style.LeftBadge ~= nil then
                        if Style.LeftBadge ~= RageUIRZ.BadgeStyle.None and tonumber(Style.LeftBadge) ~= nil then
                            RenderSprite(RageUIRZ.GetBadgeDictionary(Style.LeftBadge, Selected), RageUIRZ.GetBadgeTexture(Style.LeftBadge, Selected), CurrentMenu.X, CurrentMenu.Y + SettingsButton.LeftBadge.Y + CurrentMenu.SubtitleHeight + RageUIRZ.ItemOffset, SettingsButton.LeftBadge.Width, SettingsButton.LeftBadge.Height, RageUIRZ.GetBadgeColour(Style.LeftBadge, Selected))
                        end
                    end
                    if Style.RightBadge ~= nil then
                        if Style.RightBadge ~= RageUIRZ.BadgeStyle.None and tonumber(Style.RightBadge) ~= nil then
                            RenderSprite(RageUIRZ.GetBadgeDictionary(Style.RightBadge, Selected), RageUIRZ.GetBadgeTexture(Style.RightBadge, Selected), CurrentMenu.X + SettingsButton.RightBadge.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightBadge.Y + CurrentMenu.SubtitleHeight + RageUIRZ.ItemOffset, SettingsButton.RightBadge.Width, SettingsButton.RightBadge.Height, 0, RageUIRZ.GetBadgeColour(Style.RightBadge, Selected))
                        end
                    end
                end

                if Enabled == true or Enabled == nil then
                    if Selected then
                        if Style.RightLabel ~= nil and Style.RightLabel ~= "" then
                            RenderText(Style.RightLabel, CurrentMenu.X + SettingsButton.RightText.X - RightBadgeOffset + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightText.Y + CurrentMenu.SubtitleHeight + RageUIRZ.ItemOffset, 0, SettingsButton.RightText.Scale, 0, 0, 0, 255, 2)
                        end
                        RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUIRZ.ItemOffset, 0, SettingsButton.Text.Scale, 0, 0, 0, 255)
                    else
                        if Style.RightLabel ~= nil and Style.RightLabel ~= "" then
                            RenderText(Style.RightLabel, CurrentMenu.X + SettingsButton.RightText.X - RightBadgeOffset + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightText.Y + CurrentMenu.SubtitleHeight + RageUIRZ.ItemOffset, 0, SettingsButton.RightText.Scale, 245, 245, 245, 255, 2)
                        end

                        RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUIRZ.ItemOffset, 0, SettingsButton.Text.Scale, 245, 245, 245, 255)
                    end
                else
                    RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUIRZ.ItemOffset, 0, SettingsButton.Text.Scale, 163, 159, 148, 255)
                end

                RageUIRZ.ItemOffset = RageUIRZ.ItemOffset + SettingsButton.Rectangle.Height

                RageUIRZ.ItemsDescription(CurrentMenu, Description, Selected);

                if (Enabled) then
                    if Selected and (CurrentMenu.Controls.Select.Active or (Hovered and CurrentMenu.Controls.Click.Active)) then
                        local Audio = RageUIRZ.Settings.Audio
                        RageUIRZ.PlaySound(Audio[Audio.Use].Select.audioName, Audio[Audio.Use].Select.audioRef)
                        if (Callback.onSelected ~= nil) and (Selected) then
                            Callback.onSelected();
                        end
                        if Submenu ~= nil then
                            if Submenu() then
                                RageUIRZ.NextMenu = Submenu
                            end
                        end
                    elseif Selected then
                        if(Callback.onActive ~= nil) then
                            Callback.onActive()
                        end 
                    end
                end
            end
            RageUIRZ.Options = RageUIRZ.Options + 1

        end
    end

end
