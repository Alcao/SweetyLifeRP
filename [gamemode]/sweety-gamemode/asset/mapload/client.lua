Citizen.CreateThread(function()
    while true do
        local pCoords = GetEntityCoords(GetPlayerPed(-1))        
            local distance1 = GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, 4840.571, -5174.425, 3.0, false)
            if distance1 < 3000.0 then
            Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", true)  -- load the map and removes the city
            Citizen.InvokeNative("0x5E1460624D194A38", true) -- load the minimap/pause map and removes the city minimap/pause map
            else
            Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", false)
            Citizen.InvokeNative("0x5E1460624D194A38", false)
            end
        Citizen.Wait(100)
    end
end)