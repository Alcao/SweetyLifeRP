---
--- @author Dylan MALANDAIN, Kalyptus
--- @version 1.0.0
--- File created at [24/05/2021 00:00]
---

local AC_ATCSPN = AC_ATCSPN_PARAM
local AC_RSTD = AC_RSTD_PARAM

Visual = {};

local function AddLongString(txt)
    for i = 100, string.len(txt), 99 do
        local sub = string.sub(txt, i, i + 99)
        AC_ATCSPN(sub)
    end
end

function Visual.Notification(args)
    if (not args.dict) and (args.name )then
        args.dict = args.name
    end
    if not HasStreamedTextureDictLoaded(args.dict) then
        AC_RSTD(args.dict, false)
        while not HasStreamedTextureDictLoaded(args.dict) do Wait(0) end
    end
    if (args.backId) then
        ThefeedNextPostBackgroundColor(args.backId)
    end
    BeginTextCommandThefeedPost("jamyfafi")
    if (args.message) then
        AC_ATCSPN(args.message)
        if string.len(args.message) > 99 then
            AddLongString(args.message)
        end
    end
    if (args.title) and (args.subtitle) and (args.name) then
        EndTextCommandThefeedPostMessagetext(args.dict or "CHAR_DEFAULT", args.name or "CHAR_DEFAULT", true, args.icon or 0, args.title or "", args.subtitle or "")
        SetStreamedTextureDictAsNoLongerNeeded(args.dict)
    end
    EndTextCommandThefeedPostTicker(false, true)
end

function Visual.Subtitle(text, time)
    ClearPrints()
    BeginTextCommandPrint("STRING")
    AC_ATCSPN(text)
    EndTextCommandPrint(time and math.ceil(time) or 0, true)
end

function Visual.FloatingHelpText(text, sound, loop)
    BeginTextCommandDisplayHelp("jamyfafi")
    AC_ATCSPN(text)
    if string.len(text) > 99 then
        AddLongString(text)
    end
    EndTextCommandDisplayHelp(0, loop or 0, sound or true, -1)
end

function Visual.Prompt(text, spinner)
    BeginTextCommandBusyspinnerOn("STRING")
    AC_ATCSPN(text)
    EndTextCommandBusyspinnerOn(spinner or 1)
end

function Visual.PromptDuration(duration, text, spinner)
    Citizen.CreateThread(function()
        Citizen.Wait(0)
        Visual.Prompt(text, spinner)
        Citizen.Wait(duration)
        if (BusyspinnerIsOn()) then
            BusyspinnerOff();
        end
    end)
end

function Visual.FloatingHelpTextToEntity(text, x, y)
    SetFloatingHelpTextScreenPosition(1, x, y)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp("jamyfafi")
    AC_ATCSPN(text)
    if string.len(text) > 99 then
        AddLongString(text)
    end
    EndTextCommandDisplayHelp(2, false, false, -1)
end