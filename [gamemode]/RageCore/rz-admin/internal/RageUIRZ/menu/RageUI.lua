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

function math.round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function string.starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

---@class RageUIRZMenus
RageUIRZ.Menus = setmetatable({}, RageUIRZ.Menus)

---@type table
---@return boolean
RageUIRZ.Menus.__call = function()
    return true
end

---@type table
RageUIRZ.Menus.__index = RageUIRZ.Menus

---@type table
RageUIRZ.CurrentMenu = nil

---@type table
RageUIRZ.NextMenu = nil

---@type number
RageUIRZ.Options = 0

---@type number
RageUIRZ.ItemOffset = 0

---@type number
RageUIRZ.StatisticPanelCount = 0

---@class UISize
RageUIRZ.UI = {
    Current = "NativeUI",
    Style = {
        RageUIRZ = {
            Width = 0
        },
        NativeUI = {
            Width = 0
        }
    }
}

---@class Settings
RageUIRZ.Settings = {
    Debug = false,
    Controls = {
        Up = {
            Enabled = true,
            Active = false,
            Pressed = false,
            Keys = {
                { 0, 172 },
                { 1, 172 },
                { 2, 172 },
                { 0, 241 },
                { 1, 241 },
                { 2, 241 },
            },
        },
        Down = {
            Enabled = true,
            Active = false,
            Pressed = false,
            Keys = {
                { 0, 173 },
                { 1, 173 },
                { 2, 173 },
                { 0, 242 },
                { 1, 242 },
                { 2, 242 },
            },
        },
        Left = {
            Enabled = true,
            Active = false,
            Pressed = false,
            Keys = {
                { 0, 174 },
                { 1, 174 },
                { 2, 174 },
            },
        },
        Right = {
            Enabled = true,
            Pressed = false,
            Active = false,
            Keys = {
                { 0, 175 },
                { 1, 175 },
                { 2, 175 },
            },
        },
        SliderLeft = {
            Enabled = true,
            Active = false,
            Pressed = false,
            Keys = {
                { 0, 174 },
                { 1, 174 },
                { 2, 174 },
            },
        },
        SliderRight = {
            Enabled = true,
            Pressed = false,
            Active = false,
            Keys = {
                { 0, 175 },
                { 1, 175 },
                { 2, 175 },
            },
        },
        Select = {
            Enabled = true,
            Pressed = false,
            Active = false,
            Keys = {
                { 0, 201 },
                { 1, 201 },
                { 2, 201 },
            },
        },
        Back = {
            Enabled = true,
            Active = false,
            Pressed = false,
            Keys = {
                { 0, 177 },
                { 1, 177 },
                { 2, 177 },
                { 0, 199 },
                { 1, 199 },
                { 2, 199 },
            },
        },
        Click = {
            Enabled = true,
            Active = false,
            Pressed = false,
            Keys = {
                { 0, 24 },
            },
        },
        Enabled = {
            Controller = {
                { 0, 2 }, -- Look Up and Down
                { 0, 1 }, -- Look Left and Right
                { 0, 25 }, -- Aim
                { 0, 24 }, -- Attack
            },
            Keyboard = {
                { 0, 201 }, -- Select
                { 0, 195 }, -- X axis
                { 0, 196 }, -- Y axis
                { 0, 187 }, -- Down
                { 0, 188 }, -- Up
                { 0, 189 }, -- Left
                { 0, 190 }, -- Right
                { 0, 202 }, -- Back
                { 0, 217 }, -- Select
                { 0, 242 }, -- Scroll down
                { 0, 241 }, -- Scroll up
                { 0, 239 }, -- Cursor X
                { 0, 240 }, -- Cursor Y
                { 0, 31 }, -- Move Up and Down
                { 0, 30 }, -- Move Left and Right
                { 0, 21 }, -- Sprint
                { 0, 22 }, -- Jump
                { 0, 23 }, -- Enter
                { 0, 75 }, -- Exit Vehicle
                { 0, 71 }, -- Accelerate Vehicle
                { 0, 72 }, -- Vehicle Brake
                { 0, 59 }, -- Move Vehicle Left and Right
                { 0, 89 }, -- Fly Yaw Left
                { 0, 9 }, -- Fly Left and Right
                { 0, 8 }, -- Fly Up and Down
                { 0, 90 }, -- Fly Yaw Right
                { 0, 76 }, -- Vehicle Handbrake
            },
        },
    },
    Audio = {
        Id = nil,
        Use = "NativeUI",
        RageUIRZ = {
            UpDown = {
                audioName = "HUD_FREEMODE_SOUNDSET",
                audioRef = "NAV_UP_DOWN",
            },
            LeftRight = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "NAV_LEFT_RIGHT",
            },
            Select = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "SELECT",
            },
            Back = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "BACK",
            },
            Error = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "ERROR",
            },
            Slider = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "CONTINUOUS_SLIDER",
                Id = nil
            },
        },
        NativeUI = {
            UpDown = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "NAV_UP_DOWN",
            },
            LeftRight = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "NAV_LEFT_RIGHT",
            },
            Select = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "SELECT",
            },
            Back = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "BACK",
            },
            Error = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "ERROR",
            },
            Slider = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "CONTINUOUS_SLIDER",
                Id = nil
            },
        }
    },
    Items = {
        Title = {
            Background = { Width = 431, Height = 107 },
            Text = { X = 215, Y = 20, Scale = 1.15 },
        },
        Subtitle = {
            Background = { Width = 431, Height = 37 },
            Text = { X = 8, Y = 3, Scale = 0.35 },
            PreText = { X = 425, Y = 3, Scale = 0.35 },
        },
        Background = { Dictionary = "menutoutbo", Texture = "gradient_bgd", Y = 0, Width = 431 },
        Navigation = {
            Rectangle = { Width = 431, Height = 18 },
            Offset = 5,
            Arrows = { Dictionary = "menutoutbo", Texture = "shop_arrows_upanddown", X = 190, Y = -6, Width = 50, Height = 50 },
        },
        Description = {
            Bar = { Y = 4, Width = 431, Height = 4 },
            Background = { Dictionary = "menutoutbo", Texture = "gradient_bgd", Y = 4, Width = 431, Height = 30 },
            Text = { X = 8, Y = 10, Scale = 0.35 },
        },
    },
    Panels = {
        Grid = {
            Background = { Dictionary = "menutoutbo", Texture = "gradient_bgd", Y = 4, Width = 431, Height = 275 },
            Grid = { Dictionary = "pause_menu_pages_char_mom_dad", Texture = "nose_grid", X = 115.5, Y = 47.5, Width = 200, Height = 200 },
            Circle = { Dictionary = "mpinventory", Texture = "in_world_circle", X = 115.5, Y = 47.5, Width = 20, Height = 20 },
            Text = {
                Top = { X = 215.5, Y = 15, Scale = 0.35 },
                Bottom = { X = 215.5, Y = 250, Scale = 0.35 },
                Left = { X = 57.75, Y = 130, Scale = 0.35 },
                Right = { X = 373.25, Y = 130, Scale = 0.35 },
            },
        },
        Percentage = {
            Background = { Dictionary = "menutoutbo", Texture = "gradient_bgd", Y = 4, Width = 431, Height = 76 },
            Bar = { X = 9, Y = 50, Width = 413, Height = 10 },
            Text = {
                Left = { X = 25, Y = 15, Scale = 0.35 },
                Middle = { X = 215.5, Y = 15, Scale = 0.35 },
                Right = { X = 398, Y = 15, Scale = 0.35 },
            },
        },
    },
}

function RageUIRZ.SetScaleformParams(scaleform, data)
    data = data or {}
    for k, v in pairs(data) do
        PushScaleformMovieFunction(scaleform, v.name)
        if v.param then
            for _, par in pairs(v.param) do
                if math.type(par) == "integer" then
                    PushScaleformMovieFunctionParameterInt(par)
                elseif type(par) == "boolean" then
                    PushScaleformMovieFunctionParameterBool(par)
                elseif math.type(par) == "float" then
                    PushScaleformMovieFunctionParameterFloat(par)
                elseif type(par) == "string" then
                    PushScaleformMovieFunctionParameterString(par)
                end
            end
        end
        if v.func then
            v.func()
        end
        PopScaleformMovieFunctionVoid()
    end
end

function RageUIRZ.IsMouseInBounds(X, Y, Width, Height)
    local MX, MY = math.round(GetControlNormal(2, 239) * 1920) / 1920, math.round(GetControlNormal(2, 240) * 1080) / 1080
    X, Y = X / 1920, Y / 1080
    Width, Height = Width / 1920, Height / 1080
    return (MX >= X and MX <= X + Width) and (MY > Y and MY < Y + Height)
end

function RageUIRZ.GetSafeZoneBounds()
    local SafeSize = GetSafeZoneSize()
    SafeSize = math.round(SafeSize, 2)
    SafeSize = (SafeSize * 100) - 90
    SafeSize = 10 - SafeSize

    local W, H = 1920, 1080

    return { X = math.round(SafeSize * ((W / H) * 5.4)), Y = math.round(SafeSize * 5.4) }
end

function RageUIRZ.Visible(Menu, Value)
    if Menu ~= nil and Menu() then
        if Value == true or Value == false then
            if Value then
                if RageUIRZ.CurrentMenu ~= nil then
                    if RageUIRZ.CurrentMenu.Closed ~= nil then
                        RageUIRZ.CurrentMenu.Closed()
                    end
                    RageUIRZ.CurrentMenu.Open = not Value
                    Menu:UpdateInstructionalButtons(Value);
                    Menu:UpdateCursorStyle();

                end
                RageUIRZ.CurrentMenu = Menu
            else
                RageUIRZ.CurrentMenu = nil
            end
            Menu.Open = Value
            RageUIRZ.Options = 0
            RageUIRZ.ItemOffset = 0
            RageUIRZ.LastControl = false
        else
            return Menu.Open
        end
    end
end

function RageUIRZ.CloseAll()
    if RageUIRZ.CurrentMenu ~= nil then
        local parent = RageUIRZ.CurrentMenu.Parent
        while parent ~= nil do
            parent.Index = 1
            parent.Pagination.Minimum = 1
            parent.Pagination.Maximum = parent.Pagination.Total
            parent = parent.Parent
        end
        RageUIRZ.CurrentMenu.Index = 1
        RageUIRZ.CurrentMenu.Pagination.Minimum = 1
        RageUIRZ.CurrentMenu.Pagination.Maximum = RageUIRZ.CurrentMenu.Pagination.Total
        RageUIRZ.CurrentMenu.Open = false
        RageUIRZ.CurrentMenu = nil
    end
    RageUIRZ.Options = 0
    RageUIRZ.ItemOffset = 0
    ResetScriptGfxAlign()
end

function RageUIRZ.Banner()
    local CurrentMenu = RageUIRZ.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() and (CurrentMenu.Display.Header) then
            RageUIRZ.ItemsSafeZone(CurrentMenu)
            if CurrentMenu.Sprite ~= nil then
                if CurrentMenu.Sprite.Dictionary ~= nil then
                    if CurrentMenu.Sprite.Dictionary == "menutoutbo" then
                        RenderSprite(CurrentMenu.Sprite.Dictionary, CurrentMenu.Sprite.Texture, CurrentMenu.X, CurrentMenu.Y, RageUIRZ.Settings.Items.Title.Background.Width + CurrentMenu.WidthOffset, RageUIRZ.Settings.Items.Title.Background.Height, CurrentMenu.Sprite.Color.R,CurrentMenu.Sprite.Color.G,CurrentMenu.Sprite.Color.B,CurrentMenu.Sprite.Color.A)
                    else
                        RenderSprite(CurrentMenu.Sprite.Dictionary, CurrentMenu.Sprite.Texture, CurrentMenu.X, CurrentMenu.Y, RageUIRZ.Settings.Items.Title.Background.Width + CurrentMenu.WidthOffset, RageUIRZ.Settings.Items.Title.Background.Height, nil)
                    end
                else
                    RenderRectangle(CurrentMenu.X, CurrentMenu.Y, RageUIRZ.Settings.Items.Title.Background.Width + CurrentMenu.WidthOffset, RageUIRZ.Settings.Items.Title.Background.Height, CurrentMenu.Rectangle.R, CurrentMenu.Rectangle.G, CurrentMenu.Rectangle.B, CurrentMenu.Rectangle.A)
                end
            else
                RenderRectangle(CurrentMenu.X, CurrentMenu.Y, RageUIRZ.Settings.Items.Title.Background.Width + CurrentMenu.WidthOffset, RageUIRZ.Settings.Items.Title.Background.Height, CurrentMenu.Rectangle.R, CurrentMenu.Rectangle.G, CurrentMenu.Rectangle.B, CurrentMenu.Rectangle.A)
            end
            if (CurrentMenu.Display.Glare) then
                local ScaleformMovie = RequestScaleformMovie("MP_MENU_GLARE")
                ---@type number
                local Glarewidth = RageUIRZ.Settings.Items.Title.Background.Width
                ---@type number
                local Glareheight = RageUIRZ.Settings.Items.Title.Background.Height
                ---@type number
                local GlareX = CurrentMenu.X / 1920 + (CurrentMenu.SafeZoneSize.X / (64.399 - (CurrentMenu.WidthOffset * 0.065731)))
                ---@type number
                local GlareY = CurrentMenu.Y / 1080 + CurrentMenu.SafeZoneSize.Y / 33.195020746888
                RageUIRZ.SetScaleformParams(ScaleformMovie, {
                    { name = "SET_DATA_SLOT", param = { GetGameplayCamRelativeHeading() } }
                })
                DrawScaleformMovie(ScaleformMovie, GlareX, GlareY, Glarewidth / 430, Glareheight / 100, 255, 255, 255, 255, 0)
            end
            RenderText(CurrentMenu.Title, CurrentMenu.X + RageUIRZ.Settings.Items.Title.Text.X + (CurrentMenu.WidthOffset / 2), CurrentMenu.Y + RageUIRZ.Settings.Items.Title.Text.Y, CurrentMenu.TitleFont, CurrentMenu.TitleScale, 0, 89, 255, 255, 1)
            RageUIRZ.ItemOffset = RageUIRZ.ItemOffset + RageUIRZ.Settings.Items.Title.Background.Height
        end
    end
end

function RageUIRZ.Subtitle()
    local CurrentMenu = RageUIRZ.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() and (CurrentMenu.Display.Subtitle) then
            RageUIRZ.ItemsSafeZone(CurrentMenu)
            if CurrentMenu.Subtitle ~= "" then
                RenderRectangle(CurrentMenu.X, CurrentMenu.Y + RageUIRZ.ItemOffset, RageUIRZ.Settings.Items.Subtitle.Background.Width + CurrentMenu.WidthOffset, RageUIRZ.Settings.Items.Subtitle.Background.Height + CurrentMenu.SubtitleHeight, 0, 0, 0, 255)
                RenderText(CurrentMenu.PageCounterColour .. CurrentMenu.Subtitle, CurrentMenu.X + RageUIRZ.Settings.Items.Subtitle.Text.X, CurrentMenu.Y + RageUIRZ.Settings.Items.Subtitle.Text.Y + RageUIRZ.ItemOffset, 0, RageUIRZ.Settings.Items.Subtitle.Text.Scale, 245, 245, 245, 255, nil, false, false, RageUIRZ.Settings.Items.Subtitle.Background.Width + CurrentMenu.WidthOffset)
                if CurrentMenu.Index > CurrentMenu.Options or CurrentMenu.Index < 0 then
                    CurrentMenu.Index = 1
                end
                if (CurrentMenu ~= nil) then
                    if (CurrentMenu.Index > CurrentMenu.Pagination.Total) then
                        local offset = CurrentMenu.Index - CurrentMenu.Pagination.Total
                        CurrentMenu.Pagination.Minimum = 1 + offset
                        CurrentMenu.Pagination.Maximum = CurrentMenu.Pagination.Total + offset
                    else
                        CurrentMenu.Pagination.Minimum = 1
                        CurrentMenu.Pagination.Maximum = CurrentMenu.Pagination.Total
                    end
                end
                
                if CurrentMenu.Display.PageCounter then
                    if CurrentMenu.PageCounter == nil then
                        RenderText(CurrentMenu.PageCounterColour .. CurrentMenu.Index .. " / " .. CurrentMenu.Options, CurrentMenu.X + RageUIRZ.Settings.Items.Subtitle.PreText.X + CurrentMenu.WidthOffset, CurrentMenu.Y + RageUIRZ.Settings.Items.Subtitle.PreText.Y + RageUIRZ.ItemOffset, 0, RageUIRZ.Settings.Items.Subtitle.PreText.Scale, 245, 245, 245, 255, 2)
                    else
                        RenderText(CurrentMenu.PageCounter, CurrentMenu.X + RageUIRZ.Settings.Items.Subtitle.PreText.X + CurrentMenu.WidthOffset, CurrentMenu.Y + RageUIRZ.Settings.Items.Subtitle.PreText.Y + RageUIRZ.ItemOffset, 0, RageUIRZ.Settings.Items.Subtitle.PreText.Scale, 245, 245, 245, 255, 2)
                    end
                end
                RageUIRZ.ItemOffset = RageUIRZ.ItemOffset + RageUIRZ.Settings.Items.Subtitle.Background.Height
            end
        end
    end
end

function RageUIRZ.Background()
    if RageUIRZ.CurrentMenu ~= nil then
        if RageUIRZ.CurrentMenu() then
            RageUIRZ.ItemsSafeZone(RageUIRZ.CurrentMenu)
            SetScriptGfxDrawOrder(0)
            RenderSprite(RageUIRZ.Settings.Items.Background.Dictionary, RageUIRZ.Settings.Items.Background.Texture, RageUIRZ.CurrentMenu.X, RageUIRZ.CurrentMenu.Y + RageUIRZ.Settings.Items.Background.Y + RageUIRZ.CurrentMenu.SubtitleHeight, RageUIRZ.Settings.Items.Background.Width + RageUIRZ.CurrentMenu.WidthOffset, RageUIRZ.ItemOffset, 255, 255, 255)
            SetScriptGfxDrawOrder(1)
        end
    end
end

function RageUIRZ.Description()
    local CurrentMenu = RageUIRZ.CurrentMenu;
    local Description = RageUIRZ.Settings.Items.Description;
    if CurrentMenu ~= nil and CurrentMenu.Description ~= nil then
        if CurrentMenu() then
            RageUIRZ.ItemsSafeZone(CurrentMenu)
            RenderRectangle(CurrentMenu.X, CurrentMenu.Y + Description.Bar.Y + CurrentMenu.SubtitleHeight + RageUIRZ.ItemOffset, Description.Bar.Width + CurrentMenu.WidthOffset, Description.Bar.Height, 0, 0, 0, 255)
            RenderSprite(Description.Background.Dictionary, Description.Background.Texture, CurrentMenu.X, CurrentMenu.Y + Description.Background.Y + CurrentMenu.SubtitleHeight + RageUIRZ.ItemOffset, Description.Background.Width + CurrentMenu.WidthOffset, CurrentMenu.DescriptionHeight, 0, 0, 0, 255)
            RenderText(CurrentMenu.Description, CurrentMenu.X + Description.Text.X, CurrentMenu.Y + Description.Text.Y + CurrentMenu.SubtitleHeight + RageUIRZ.ItemOffset, 0, Description.Text.Scale, 255, 255, 255, 255, nil, false, false, Description.Background.Width + CurrentMenu.WidthOffset - 8.0)
            RageUIRZ.ItemOffset = RageUIRZ.ItemOffset + CurrentMenu.DescriptionHeight + Description.Bar.Y
        end
    end
end

function RageUIRZ.Render()
    local CurrentMenu = RageUIRZ.CurrentMenu;
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            if CurrentMenu.Safezone then
                ResetScriptGfxAlign()
            end

            if (CurrentMenu.Display.InstructionalButton) then
                if not CurrentMenu.InitScaleform then
                    CurrentMenu:UpdateInstructionalButtons(true)
                    CurrentMenu.InitScaleform = true
                end
                DrawScaleformMovieFullscreen(CurrentMenu.InstructionalScaleform, 255, 255, 255, 255, 0)
            end
            CurrentMenu.Options = RageUIRZ.Options
            CurrentMenu.SafeZoneSize = nil
            RageUIRZ.Controls()
            RageUIRZ.Options = 0
            RageUIRZ.StatisticPanelCount = 0
            RageUIRZ.ItemOffset = 0
            if CurrentMenu.Controls.Back.Enabled then
                if CurrentMenu.Controls.Back.Pressed and CurrentMenu.Closable then
                    CurrentMenu.Controls.Back.Pressed = false
                    local Audio = RageUIRZ.Settings.Audio
                    RageUIRZ.PlaySound(Audio[Audio.Use].Back.audioName, Audio[Audio.Use].Back.audioRef)

                    if CurrentMenu.Closed ~= nil then
                        collectgarbage()
                        CurrentMenu.Closed()
                    end

                    if CurrentMenu.Parent ~= nil then
                        if CurrentMenu.Parent() then
                            RageUIRZ.NextMenu = CurrentMenu.Parent
                            CurrentMenu:UpdateCursorStyle()
                        else
                            RageUIRZ.NextMenu = nil
                            RageUIRZ.Visible(CurrentMenu, false)
                        end
                    else
                        RageUIRZ.NextMenu = nil
                        RageUIRZ.Visible(CurrentMenu, false)
                    end
                elseif CurrentMenu.Controls.Back.Pressed and not CurrentMenu.Closable then
                    CurrentMenu.Controls.Back.Pressed = false
                end
            end
            if RageUIRZ.NextMenu ~= nil then
                if RageUIRZ.NextMenu() then
                    RageUIRZ.Visible(CurrentMenu, false)
                    RageUIRZ.Visible(RageUIRZ.NextMenu, true)
                    CurrentMenu.Controls.Select.Active = false
                    RageUIRZ.NextMenu = nil
                    RageUIRZ.LastControl = false
                end
            end
        end
    end
end

function RageUIRZ.ItemsDescription(CurrentMenu, Description, Selected)
    ---@type table
    if Description ~= "" or Description ~= nil then
        local SettingsDescription = RageUIRZ.Settings.Items.Description;
        if Selected and CurrentMenu.Description ~= Description then
            CurrentMenu.Description = Description or nil
            ---@type number
            local DescriptionLineCount = GetLineCount(CurrentMenu.Description, CurrentMenu.X + SettingsDescription.Text.X, CurrentMenu.Y + SettingsDescription.Text.Y + CurrentMenu.SubtitleHeight + RageUIRZ.ItemOffset, 0, SettingsDescription.Text.Scale, 255, 255, 255, 255, nil, false, false, SettingsDescription.Background.Width + (CurrentMenu.WidthOffset - 5.0))
            if DescriptionLineCount > 1 then
                CurrentMenu.DescriptionHeight = SettingsDescription.Background.Height * DescriptionLineCount
            else
                CurrentMenu.DescriptionHeight = SettingsDescription.Background.Height + 7
            end
        end
    end
end

function RageUIRZ.ItemsMouseBounds(CurrentMenu, Selected, Option, SettingsButton)
    ---@type boolean
    local Hovered = false
    Hovered = RageUIRZ.IsMouseInBounds(CurrentMenu.X + CurrentMenu.SafeZoneSize.X, CurrentMenu.Y + SettingsButton.Rectangle.Y + CurrentMenu.SafeZoneSize.Y + CurrentMenu.SubtitleHeight + RageUIRZ.ItemOffset, SettingsButton.Rectangle.Width + CurrentMenu.WidthOffset, SettingsButton.Rectangle.Height)
    if Hovered and not Selected then
        RenderRectangle(CurrentMenu.X, CurrentMenu.Y + SettingsButton.Rectangle.Y + CurrentMenu.SubtitleHeight + RageUIRZ.ItemOffset, SettingsButton.Rectangle.Width + CurrentMenu.WidthOffset, SettingsButton.Rectangle.Height, 255, 255, 255, 20)
        if CurrentMenu.Controls.Click.Active then
            CurrentMenu.Index = Option
            local Audio = RageUIRZ.Settings.Audio
            RageUIRZ.PlaySound(Audio[Audio.Use].UpDown.audioName, Audio[Audio.Use].UpDown.audioRef)
        end
    end
    return Hovered;
end

function RageUIRZ.ItemsSafeZone(CurrentMenu)
    if not CurrentMenu.SafeZoneSize then
        CurrentMenu.SafeZoneSize = { X = 0, Y = 0 }
        if CurrentMenu.Safezone then
            CurrentMenu.SafeZoneSize = RageUIRZ.GetSafeZoneBounds()
            SetScriptGfxAlign(76, 84)
            SetScriptGfxAlignParams(0, 0, 0, 0)
        end
    end
end

function RageUIRZ.CurrentIsEqualTo(Current, To, Style, DefaultStyle)
    return Current == To and Style or DefaultStyle or {};
end

function RageUIRZ.IsVisible(Menu, Items, Panels)
    if (RageUIRZ.Visible(Menu)) and (UpdateOnscreenKeyboard() ~= 0) and (UpdateOnscreenKeyboard() ~= 3) then
        RageUIRZ.Banner()
        RageUIRZ.Subtitle()
        if (Items ~= nil) then
            Items()
        end
        RageUIRZ.Background();
        RageUIRZ.Navigation();
        RageUIRZ.Description();
        if (Panels ~= nil) then
            Panels()
        end
        RageUIRZ.Render()
    end
end

---SetStyleAudio
---@param StyleAudio string
---@return void
---@public
function RageUIRZ.SetStyleAudio(StyleAudio)
    RageUIRZ.Settings.Audio.Use = StyleAudio or "RageUIRZ"
end

function RageUIRZ.GetStyleAudio()
    return RageUIRZ.Settings.Audio.Use or "RageUIRZ"
end

