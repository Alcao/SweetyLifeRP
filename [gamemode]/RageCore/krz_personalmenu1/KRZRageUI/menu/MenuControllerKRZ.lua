---@type table
RageUI2.LastControl = false

---IsMouseInBounds
---@param X number
---@param Y number
---@param Width number
---@param Height number
---@return number
---@public
function RageUI2.IsMouseInBounds(X, Y, Width, Height)
    local MX, MY = math.round(GetControlNormal(0, 239) * 1920) / 1920, math.round(GetControlNormal(0, 240) * 1080) / 1080
    X, Y = X / 1920, Y / 1080
    Width, Height = Width / 1920, Height / 1080
    return (MX >= X and MX <= X + Width) and (MY > Y and MY < Y + Height)
end

---GetSafeZoneBounds
---@return table
---@public
function RageUI2.GetSafeZoneBounds()
    local SafeSize = GetSafeZoneSize()
    SafeSize = math.round(SafeSize, 2)
    SafeSize = (SafeSize * 100) - 90
    SafeSize = 10 - SafeSize

    local W, H = 1920, 1080

    return { X = math.round(SafeSize * ((W / H) * 5.4)), Y = math.round(SafeSize * 5.4) }
end
---GoUp
---@param Options number
---@return nil
---@public
function RageUI2.GoUp(Options)
    if RageUI2.CurrentMenu ~= nil then
        Options = RageUI2.CurrentMenu.Options
        if RageUI2.CurrentMenu() then
            if (Options ~= 0) then
                if Options > RageUI2.CurrentMenu.Pagination.Total then
                    if RageUI2.CurrentMenu.Index <= RageUI2.CurrentMenu.Pagination.Minimum then
                        if RageUI2.CurrentMenu.Index == 1 then
                            RageUI2.CurrentMenu.Pagination.Minimum = Options - (RageUI2.CurrentMenu.Pagination.Total - 1)
                            RageUI2.CurrentMenu.Pagination.Maximum = Options
                            RageUI2.CurrentMenu.Index = Options
                        else
                            RageUI2.CurrentMenu.Pagination.Minimum = (RageUI2.CurrentMenu.Pagination.Minimum - 1)
                            RageUI2.CurrentMenu.Pagination.Maximum = (RageUI2.CurrentMenu.Pagination.Maximum - 1)
                            RageUI2.CurrentMenu.Index = RageUI2.CurrentMenu.Index - 1
                        end
                    else
                        RageUI2.CurrentMenu.Index = RageUI2.CurrentMenu.Index - 1
                    end
                else
                    if RageUI2.CurrentMenu.Index == 1 then
                        RageUI2.CurrentMenu.Pagination.Minimum = Options - (RageUI2.CurrentMenu.Pagination.Total - 1)
                        RageUI2.CurrentMenu.Pagination.Maximum = Options
                        RageUI2.CurrentMenu.Index = Options
                    else
                        RageUI2.CurrentMenu.Index = RageUI2.CurrentMenu.Index - 1
                    end
                end

                local Audio = RageUI2.Settings.Audio
                RageUI2.PlaySound(Audio[Audio.Use].UpDown.audioName, Audio[Audio.Use].UpDown.audioRef)
                RageUI2.LastControl = true
            else
                local Audio = RageUI2.Settings.Audio
                RageUI2.PlaySound(Audio[Audio.Use].Error.audioName, Audio[Audio.Use].Error.audioRef)
            end
        end
    end
end

---GoDown
---@param Options number
---@return nil
---@public
function RageUI2.GoDown(Options)
    if RageUI2.CurrentMenu ~= nil then
        Options = RageUI2.CurrentMenu.Options
        if RageUI2.CurrentMenu() then
            if (Options ~= 0) then
                if Options > RageUI2.CurrentMenu.Pagination.Total then
                    if RageUI2.CurrentMenu.Index >= RageUI2.CurrentMenu.Pagination.Maximum then
                        if RageUI2.CurrentMenu.Index == Options then
                            RageUI2.CurrentMenu.Pagination.Minimum = 1
                            RageUI2.CurrentMenu.Pagination.Maximum = RageUI2.CurrentMenu.Pagination.Total
                            RageUI2.CurrentMenu.Index = 1
                        else
                            RageUI2.CurrentMenu.Pagination.Maximum = (RageUI2.CurrentMenu.Pagination.Maximum + 1)
                            RageUI2.CurrentMenu.Pagination.Minimum = RageUI2.CurrentMenu.Pagination.Maximum - (RageUI2.CurrentMenu.Pagination.Total - 1)
                            RageUI2.CurrentMenu.Index = RageUI2.CurrentMenu.Index + 1
                        end
                    else
                        RageUI2.CurrentMenu.Index = RageUI2.CurrentMenu.Index + 1
                    end
                else
                    if RageUI2.CurrentMenu.Index == Options then
                        RageUI2.CurrentMenu.Pagination.Minimum = 1
                        RageUI2.CurrentMenu.Pagination.Maximum = RageUI2.CurrentMenu.Pagination.Total
                        RageUI2.CurrentMenu.Index = 1
                    else
                        RageUI2.CurrentMenu.Index = RageUI2.CurrentMenu.Index + 1
                    end
                end
                local Audio = RageUI2.Settings.Audio
                RageUI2.PlaySound(Audio[Audio.Use].UpDown.audioName, Audio[Audio.Use].UpDown.audioRef)
                RageUI2.LastControl = false
            else
                local Audio = RageUI2.Settings.Audio
                RageUI2.PlaySound(Audio[Audio.Use].Error.audioName, Audio[Audio.Use].Error.audioRef)
            end
        end
    end
end

function RageUI2.GoLeft(Controls)
    if Controls.Left.Enabled then
        for Index = 1, #Controls.Left.Keys do
            if not Controls.Left.Pressed then
                if IsDisabledControlJustPressed(Controls.Left.Keys[Index][1], Controls.Left.Keys[Index][2]) then
                    Controls.Left.Pressed = true

                    Citizen.CreateThread(function()
                        Controls.Left.Active = true

                        Citizen.Wait(0.01)

                        Controls.Left.Active = false

                        Citizen.Wait(174.99)

                        while Controls.Left.Enabled and IsDisabledControlPressed(Controls.Left.Keys[Index][1], Controls.Left.Keys[Index][2]) do
                            Controls.Left.Active = true

                            Citizen.Wait(0.01)

                            Controls.Left.Active = false

                            Citizen.Wait(124.99)
                        end

                        Controls.Left.Pressed = false
                        Wait(10)
                    end)

                    break
                end
            end
        end
    end
end

function RageUI2.GoRight(Controls)
    if Controls.Right.Enabled then
        for Index = 1, #Controls.Right.Keys do
            if not Controls.Right.Pressed then
                if IsDisabledControlJustPressed(Controls.Right.Keys[Index][1], Controls.Right.Keys[Index][2]) then
                    Controls.Right.Pressed = true

                    Citizen.CreateThread(function()
                        Controls.Right.Active = true

                        Citizen.Wait(0.01)

                        Controls.Right.Active = false

                        Citizen.Wait(174.99)

                        while Controls.Right.Enabled and IsDisabledControlPressed(Controls.Right.Keys[Index][1], Controls.Right.Keys[Index][2]) do
                            Controls.Right.Active = true

                            Citizen.Wait(1)

                            Controls.Right.Active = false

                            Citizen.Wait(124.99)
                        end

                        Controls.Right.Pressed = false
                        Wait(10)
                    end)

                    break
                end
            end
        end
    end
end

function RageUI2.GoSliderLeft(Controls)
    if Controls.SliderLeft.Enabled then
        for Index = 1, #Controls.SliderLeft.Keys do
            if not Controls.SliderLeft.Pressed then
                if IsDisabledControlJustPressed(Controls.SliderLeft.Keys[Index][1], Controls.SliderLeft.Keys[Index][2]) then
                    Controls.SliderLeft.Pressed = true
                    Citizen.CreateThread(function()
                        Controls.SliderLeft.Active = true
                        Citizen.Wait(1)
                        Controls.SliderLeft.Active = false
                        while Controls.SliderLeft.Enabled and IsDisabledControlPressed(Controls.SliderLeft.Keys[Index][1], Controls.SliderLeft.Keys[Index][2]) do
                            Controls.SliderLeft.Active = true
                            Citizen.Wait(1)
                            Controls.SliderLeft.Active = false
                        end
                        Controls.SliderLeft.Pressed = false
                    end)
                    break
                end
            end
        end
    end
end

function RageUI2.GoSliderRight(Controls)
    if Controls.SliderRight.Enabled then
        for Index = 1, #Controls.SliderRight.Keys do
            if not Controls.SliderRight.Pressed then
                if IsDisabledControlJustPressed(Controls.SliderRight.Keys[Index][1], Controls.SliderRight.Keys[Index][2]) then
                    Controls.SliderRight.Pressed = true
                    Citizen.CreateThread(function()
                        Controls.SliderRight.Active = true
                        Citizen.Wait(1)
                        Controls.SliderRight.Active = false
                        while Controls.SliderRight.Enabled and IsDisabledControlPressed(Controls.SliderRight.Keys[Index][1], Controls.SliderRight.Keys[Index][2]) do
                            Controls.SliderRight.Active = true
                            Citizen.Wait(1)
                            Controls.SliderRight.Active = false
                        end
                        Controls.SliderRight.Pressed = false
                    end)
                    break
                end
            end
        end
    end
end

---Controls
---@return nil
---@public
function RageUI2.Controls()
    if RageUI2.CurrentMenu ~= nil then
        if RageUI2.CurrentMenu() then
            if RageUI2.CurrentMenu.Open then

                local Controls = RageUI2.CurrentMenu.Controls;
                ---@type number
                local Options = RageUI2.CurrentMenu.Options
                RageUI2.Options = RageUI2.CurrentMenu.Options
                if RageUI2.CurrentMenu.EnableMouse then
                    DisableAllControlActions(2)
                end

                if not IsInputDisabled(2) then
                    for Index = 1, #Controls.Enabled.Controller do
                        EnableControlAction(Controls.Enabled.Controller[Index][1], Controls.Enabled.Controller[Index][2], true)
                    end
                else
                    for Index = 1, #Controls.Enabled.Keyboard do
                        EnableControlAction(Controls.Enabled.Keyboard[Index][1], Controls.Enabled.Keyboard[Index][2], true)
                    end
                end

                if Controls.Up.Enabled then
                    for Index = 1, #Controls.Up.Keys do
                        if not Controls.Up.Pressed then
                            if IsDisabledControlJustPressed(Controls.Up.Keys[Index][1], Controls.Up.Keys[Index][2]) then
                                Controls.Up.Pressed = true

                                Citizen.CreateThread(function()
                                    RageUI2.GoUp(Options)

                                    Citizen.Wait(175)

                                    while Controls.Up.Enabled and IsDisabledControlPressed(Controls.Up.Keys[Index][1], Controls.Up.Keys[Index][2]) do
                                        RageUI2.GoUp(Options)

                                        Citizen.Wait(50)
                                    end

                                    Controls.Up.Pressed = false
                                end)

                                break
                            end
                        end
                    end
                end

                if Controls.Down.Enabled then
                    for Index = 1, #Controls.Down.Keys do
                        if not Controls.Down.Pressed then
                            if IsDisabledControlJustPressed(Controls.Down.Keys[Index][1], Controls.Down.Keys[Index][2]) then
                                Controls.Down.Pressed = true

                                Citizen.CreateThread(function()
                                    RageUI2.GoDown(Options)

                                    Citizen.Wait(175)

                                    while Controls.Down.Enabled and IsDisabledControlPressed(Controls.Down.Keys[Index][1], Controls.Down.Keys[Index][2]) do
                                        RageUI2.GoDown(Options)

                                        Citizen.Wait(50)
                                    end

                                    Controls.Down.Pressed = false
                                end)

                                break
                            end
                        end
                    end
                end

                RageUI2.GoLeft(Controls)
                --- Default Left navigation
                RageUI2.GoRight(Controls) --- Default Right navigation

                RageUI2.GoSliderLeft(Controls)
                RageUI2.GoSliderRight(Controls)

                if Controls.Select.Enabled then
                    for Index = 1, #Controls.Select.Keys do
                        if not Controls.Select.Pressed then
                            if IsDisabledControlJustPressed(Controls.Select.Keys[Index][1], Controls.Select.Keys[Index][2]) then
                                Controls.Select.Pressed = true

                                Citizen.CreateThread(function()
                                    Controls.Select.Active = true

                                    Citizen.Wait(0.01)

                                    Controls.Select.Active = false

                                    Citizen.Wait(174.99)

                                    while Controls.Select.Enabled and IsDisabledControlPressed(Controls.Select.Keys[Index][1], Controls.Select.Keys[Index][2]) do
                                        Controls.Select.Active = true

                                        Citizen.Wait(0.01)

                                        Controls.Select.Active = false

                                        Citizen.Wait(124.99)
                                    end

                                    Controls.Select.Pressed = false

                                end)

                                break
                            end
                        end
                    end
                end

                if Controls.Click.Enabled then
                    for Index = 1, #Controls.Click.Keys do
                        if not Controls.Click.Pressed then
                            if IsDisabledControlJustPressed(Controls.Click.Keys[Index][1], Controls.Click.Keys[Index][2]) then
                                Controls.Click.Pressed = true

                                Citizen.CreateThread(function()
                                    Controls.Click.Active = true

                                    Citizen.Wait(0.01)

                                    Controls.Click.Active = false

                                    Citizen.Wait(174.99)

                                    while Controls.Click.Enabled and IsDisabledControlPressed(Controls.Click.Keys[Index][1], Controls.Click.Keys[Index][2]) do
                                        Controls.Click.Active = true

                                        Citizen.Wait(0.01)

                                        Controls.Click.Active = false

                                        Citizen.Wait(124.99)
                                    end

                                    Controls.Click.Pressed = false
                                end)

                                break
                            end
                        end
                    end
                end
                if Controls.Back.Enabled then
                    for Index = 1, #Controls.Back.Keys do
                        if not Controls.Back.Pressed then
                            if IsDisabledControlJustPressed(Controls.Back.Keys[Index][1], Controls.Back.Keys[Index][2]) then
                                Controls.Back.Pressed = true
                                Wait(10)
                                break
                            end
                        end
                    end
                end

            end
        end
    end
end

---Navigation
---@return nil
---@public
function RageUI2.Navigation()
    if RageUI2.CurrentMenu ~= nil then
        if RageUI2.CurrentMenu() then
            if RageUI2.CurrentMenu.EnableMouse   then
                SetMouseCursorActiveThisFrame()
            end
            if RageUI2.Options > RageUI2.CurrentMenu.Pagination.Total then

                ---@type boolean
                local UpHovered = false

                ---@type boolean
                local DownHovered = false

                if not RageUI2.CurrentMenu.SafeZoneSize then
                    RageUI2.CurrentMenu.SafeZoneSize = { X = 0, Y = 0 }

                    if RageUI2.CurrentMenu.Safezone then
                        RageUI2.CurrentMenu.SafeZoneSize = RageUI2.GetSafeZoneBounds()

                        SetScriptGfxAlign(76, 84)
                        SetScriptGfxAlignParams(0, 0, 0, 0)
                    end
                end

                UpHovered = RageUI2.IsMouseInBounds(RageUI2.CurrentMenu.X + RageUI2.CurrentMenu.SafeZoneSize.X, RageUI2.CurrentMenu.Y + RageUI2.CurrentMenu.SafeZoneSize.Y + RageUI2.CurrentMenu.SubtitleHeight + RageUI2.ItemOffset, RageUI2.Settings.Items.Navigation.Rectangle.Width + RageUI2.CurrentMenu.WidthOffset, RageUI2.Settings.Items.Navigation.Rectangle.Height)
                DownHovered = RageUI2.IsMouseInBounds(RageUI2.CurrentMenu.X + RageUI2.CurrentMenu.SafeZoneSize.X, RageUI2.CurrentMenu.Y + RageUI2.Settings.Items.Navigation.Rectangle.Height + RageUI2.CurrentMenu.SafeZoneSize.Y + RageUI2.CurrentMenu.SubtitleHeight + RageUI2.ItemOffset, RageUI2.Settings.Items.Navigation.Rectangle.Width + RageUI2.CurrentMenu.WidthOffset, RageUI2.Settings.Items.Navigation.Rectangle.Height)

                if RageUI2.CurrentMenu.EnableMouse   then


                    if RageUI2.CurrentMenu.Controls.Click.Active then
                        if UpHovered then
                            RageUI2.GoUp(RageUI2.Options)
                        elseif DownHovered then
                            RageUI2.GoDown(RageUI2.Options)
                        end
                    end

                    if UpHovered then
                        RenderRectangle(RageUI2.CurrentMenu.X, RageUI2.CurrentMenu.Y + RageUI2.CurrentMenu.SubtitleHeight + RageUI2.ItemOffset, RageUI2.Settings.Items.Navigation.Rectangle.Width + RageUI2.CurrentMenu.WidthOffset, RageUI2.Settings.Items.Navigation.Rectangle.Height, 30, 30, 30, 255)
                    else
                        RenderRectangle(RageUI2.CurrentMenu.X, RageUI2.CurrentMenu.Y + RageUI2.CurrentMenu.SubtitleHeight + RageUI2.ItemOffset, RageUI2.Settings.Items.Navigation.Rectangle.Width + RageUI2.CurrentMenu.WidthOffset, RageUI2.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                    end

                    if DownHovered then
                        RenderRectangle(RageUI2.CurrentMenu.X, RageUI2.CurrentMenu.Y + RageUI2.Settings.Items.Navigation.Rectangle.Height + RageUI2.CurrentMenu.SubtitleHeight + RageUI2.ItemOffset, RageUI2.Settings.Items.Navigation.Rectangle.Width + RageUI2.CurrentMenu.WidthOffset, RageUI2.Settings.Items.Navigation.Rectangle.Height, 30, 30, 30, 255)
                    else
                        RenderRectangle(RageUI2.CurrentMenu.X, RageUI2.CurrentMenu.Y + RageUI2.Settings.Items.Navigation.Rectangle.Height + RageUI2.CurrentMenu.SubtitleHeight + RageUI2.ItemOffset, RageUI2.Settings.Items.Navigation.Rectangle.Width + RageUI2.CurrentMenu.WidthOffset, RageUI2.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                    end
                else
                    RenderRectangle(RageUI2.CurrentMenu.X, RageUI2.CurrentMenu.Y + RageUI2.CurrentMenu.SubtitleHeight + RageUI2.ItemOffset, RageUI2.Settings.Items.Navigation.Rectangle.Width + RageUI2.CurrentMenu.WidthOffset, RageUI2.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                    RenderRectangle(RageUI2.CurrentMenu.X, RageUI2.CurrentMenu.Y + RageUI2.Settings.Items.Navigation.Rectangle.Height + RageUI2.CurrentMenu.SubtitleHeight + RageUI2.ItemOffset, RageUI2.Settings.Items.Navigation.Rectangle.Width + RageUI2.CurrentMenu.WidthOffset, RageUI2.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                end
                RenderSprite(RageUI2.Settings.Items.Navigation.Arrows.Dictionary, RageUI2.Settings.Items.Navigation.Arrows.Texture, RageUI2.CurrentMenu.X + RageUI2.Settings.Items.Navigation.Arrows.X + (RageUI2.CurrentMenu.WidthOffset / 2), RageUI2.CurrentMenu.Y + RageUI2.Settings.Items.Navigation.Arrows.Y + RageUI2.CurrentMenu.SubtitleHeight + RageUI2.ItemOffset, RageUI2.Settings.Items.Navigation.Arrows.Width, RageUI2.Settings.Items.Navigation.Arrows.Height)

                RageUI2.ItemOffset = RageUI2.ItemOffset + (RageUI2.Settings.Items.Navigation.Rectangle.Height * 2)

            end
        end
    end
end

---GoBack
---@return nil
---@public
function RageUI2.GoBack()
    if RageUI2.CurrentMenu ~= nil then
        local Audio = RageUI2.Settings.Audio
        RageUI2.PlaySound(Audio[Audio.Use].Back.audioName, Audio[Audio.Use].Back.audioRef)
        if RageUI2.CurrentMenu.Parent ~= nil then
            if RageUI2.CurrentMenu.Parent() then
                RageUI2.NextMenu = RageUI2.CurrentMenu.Parent
            else
                RageUI2.NextMenu = nil
                RageUI2.Visible(RageUI2.CurrentMenu, false)
            end
        else
            RageUI2.NextMenu = nil
            RageUI2.Visible(RageUI2.CurrentMenu, false)
        end
    end
end
