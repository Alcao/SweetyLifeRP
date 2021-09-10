function XNL_SetInitialXPLevels(CurrentXP, ShowRankBar, ShowRankBarAnimating)
    XNL_CurrentPlayerXP = CurrentXP

    if ShowRankBar then
        CurLevel = XNL_GetLevelFromXP(CurrentXP)
        AnimateFrom = CurrentXP
        if ShowRankBarAnimating then
            AnimateFrom = XNL_GetXPFloorForLevel(CurLevel)
        end
        CreateRankBar(XNL_GetXPFloorForLevel(CurLevel), XNL_GetXPCeilingForLevel(CurLevel), AnimateFrom, XNL_CurrentPlayerXP, CurLevel, false)
    end
end

function XNL_OnPlayerLevelUp()

end

function XNL_AddPlayerXP(XPAmount)
    if not is_int(XPAmount) then
        return
    end

    if XPAmount < 0 then
        return
    end

    local CurrentLevel = XNL_GetLevelFromXP(XNL_CurrentPlayerXP)
    local CurrentXPWithAddedXP = XNL_CurrentPlayerXP + XPAmount
    local NewLevel = XNL_GetLevelFromXP(CurrentXPWithAddedXP)
    local LevelDifference = 0
    if NewLevel > XNL_MaxPlayerLevel - 1 then
        NewLevel = XNL_MaxPlayerLevel - 1
        CurrentXPWithAddedXP = XNL_GetXPCeilingForLevel(XNL_MaxPlayerLevel - 1)
    end
    if NewLevel > CurrentLevel then
        LevelDifference = NewLevel - CurrentLevel
    end

    if LevelDifference > 0 then
        StartAtLevel = CurrentLevel
        CreateRankBar(XNL_GetXPFloorForLevel(StartAtLevel), XNL_GetXPCeilingForLevel(StartAtLevel), XNL_CurrentPlayerXP, XNL_GetXPCeilingForLevel(StartAtLevel), StartAtLevel, false)
        for i = 1, LevelDifference, 1
        do
            StartAtLevel = StartAtLevel + 1

            if i == LevelDifference then
                CreateRankBar(XNL_GetXPFloorForLevel(StartAtLevel), XNL_GetXPCeilingForLevel(StartAtLevel), XNL_GetXPFloorForLevel(StartAtLevel), CurrentXPWithAddedXP, StartAtLevel, false)
            else
                CreateRankBar(XNL_GetXPFloorForLevel(StartAtLevel), XNL_GetXPCeilingForLevel(StartAtLevel), XNL_GetXPFloorForLevel(StartAtLevel), XNL_GetXPCeilingForLevel(StartAtLevel), StartAtLevel, false)
            end
        end
    else
        CreateRankBar(XNL_GetXPFloorForLevel(NewLevel), XNL_GetXPCeilingForLevel(NewLevel), XNL_CurrentPlayerXP, CurrentXPWithAddedXP, NewLevel, false)
    end
    XNL_CurrentPlayerXP = CurrentXPWithAddedXP
    if LevelDifference > 0 then
        XNL_OnPlayerLevelUp()
    end
end

function XNL_RemovePlayerXP(XPAmount)
    if not is_int(XPAmount) then
        return
    end

    if XPAmount < 0 then
        return
    end

    local CurrentLevel = XNL_GetLevelFromXP(XNL_CurrentPlayerXP)
    local CurrentXPWithRemovedXP = XNL_CurrentPlayerXP - XPAmount
    local NewLevel = XNL_GetLevelFromXP(CurrentXPWithRemovedXP)
    local LevelDifference = 0
    if NewLevel < 1 then
        NewLevel = 1
    end
    if CurrentXPWithRemovedXP < 0 then
        CurrentXPWithRemovedXP = 0
    end
    if NewLevel < CurrentLevel then
        LevelDifference = math.abs(NewLevel - CurrentLevel)
    end

    if LevelDifference > 0 then
        StartAtLevel = CurrentLevel
        CreateRankBar(XNL_GetXPFloorForLevel(StartAtLevel), XNL_GetXPCeilingForLevel(StartAtLevel), XNL_CurrentPlayerXP, XNL_GetXPFloorForLevel(StartAtLevel), StartAtLevel, true)
        for i = 1, LevelDifference, 1
        do
            StartAtLevel = StartAtLevel - 1
            if i == LevelDifference then
                CreateRankBar(XNL_GetXPFloorForLevel(StartAtLevel), XNL_GetXPCeilingForLevel(StartAtLevel), XNL_GetXPCeilingForLevel(StartAtLevel), CurrentXPWithRemovedXP, StartAtLevel, true)
            else
                CreateRankBar(XNL_GetXPFloorForLevel(StartAtLevel), XNL_GetXPCeilingForLevel(StartAtLevel), XNL_GetXPCeilingForLevel(StartAtLevel), XNL_GetXPFloorForLevel(StartAtLevel), StartAtLevel, true)
            end
        end
    else
        CreateRankBar(XNL_GetXPFloorForLevel(NewLevel), XNL_GetXPCeilingForLevel(NewLevel), XNL_CurrentPlayerXP, CurrentXPWithRemovedXP, NewLevel, true)
    end
    XNL_CurrentPlayerXP = CurrentXPWithRemovedXP
    if LevelDifference > 0 then
        XNL_OnPlayerLevelsLost()
    end
end

function XNL_GetXPFloorForLevel(intLevelNr)
    if is_int(intLevelNr) then
        if intLevelNr > 7999 then
            intLevelNr = 7999
        end
        if intLevelNr < 2 then
            return 0
        end

        if intLevelNr > 100 then
            BaseXP = RockstarRanks[99]
            ExtraAddPerLevel = 50
            MainAddPerLevel = 28550

            BaseLevel = intLevelNr - 100
            CurXPNeeded = 0
            for i = 1, BaseLevel, 1
            do
                MainAddPerLevel = MainAddPerLevel + 50
                CurXPNeeded = CurXPNeeded + MainAddPerLevel
            end

            return BaseXP + CurXPNeeded
        end
        return RockstarRanks[intLevelNr - 1]
    else
        return 0
    end
end

function XNL_GetXPCeilingForLevel(intLevelNr)
    if is_int(intLevelNr) then
        if intLevelNr > 7999 then
            intLevelNr = 7999
        end
        if intLevelNr < 1 then
            return 800
        end

        if intLevelNr > 99 then
            BaseXP = RockstarRanks[99]
            ExtraAddPerLevel = 50
            MainAddPerLevel = 28550

            BaseLevel = intLevelNr - 99
            CurXPNeeded = 0
            for i = 1, BaseLevel, 1
            do
                MainAddPerLevel = MainAddPerLevel + 50
                CurXPNeeded = CurXPNeeded + MainAddPerLevel
            end

            return BaseXP + CurXPNeeded
        end

        return RockstarRanks[intLevelNr]
    else
        return 0
    end
end

function XNL_GetLevelFromXP(intXPAmount)
    if is_int(intXPAmount) then
        local SearchingFor = intXPAmount

        if SearchingFor < 0 then
            return 1
        end

        if SearchingFor < RockstarRanks[99] then
            local CurLevelFound = -1
            local CurrentLevelScan = 0
            for k, v in pairs(RockstarRanks) do
                CurrentLevelScan = CurrentLevelScan + 1
                if SearchingFor < v then
                    break
                end
            end

            return CurrentLevelScan
        else
            BaseXP = RockstarRanks[99]
            ExtraAddPerLevel = 50
            MainAddPerLevel = 28550
            CurXPNeeded = 0
            local CurLevelFound = -1
            for i = 1, XNL_MaxPlayerLevel - 99, 1
            do
                MainAddPerLevel = MainAddPerLevel + 50
                CurXPNeeded = CurXPNeeded + MainAddPerLevel
                CurLevelFound = i
                if SearchingFor < (BaseXP + CurXPNeeded) then
                    break
                end
            end

            return CurLevelFound + 99
        end
    else
        return 1
    end
end

function CreateRankBar(XP_StartLimit_RankBar, XP_EndLimit_RankBar, playersPreviousXP, playersCurrentXP, CurrentPlayerLevel, TakingAwayXP)
    RankBarColor = 116
    if TakingAwayXP and XNL_UseRedBarWhenLosingXP then
        RankBarColor = 56
    end

    if not HasHudScaleformLoaded(19) then
        RequestHudScaleform(19)
        while not HasHudScaleformLoaded(19) do
            Wait(1)
        end
    end

    BeginScaleformMovieMethodHudComponent(19, "SET_COLOUR")
    PushScaleformMovieFunctionParameterInt(RankBarColor)
    EndScaleformMovieMethodReturn()
    BeginScaleformMovieMethodHudComponent(19, "SET_RANK_SCORES")
    PushScaleformMovieFunctionParameterInt(XP_StartLimit_RankBar)
    PushScaleformMovieFunctionParameterInt(XP_EndLimit_RankBar)
    PushScaleformMovieFunctionParameterInt(playersPreviousXP)
    PushScaleformMovieFunctionParameterInt(playersCurrentXP)
    PushScaleformMovieFunctionParameterInt(CurrentPlayerLevel)
    PushScaleformMovieFunctionParameterInt(100)
    EndScaleformMovieMethodReturn()
end

function is_int(n)
    if type(n) == "number" then
        if math.floor(n) == n then
            return true
        end
    end
    return false
end
function is_int(n)
    if type(n) == "number" then
        if math.floor(n) == n then
            return true 
        end 
    end
    return false 
end