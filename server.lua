RegisterServerEvent('updateSpeedLimit')
AddEventHandler('updateSpeedLimit', function(speed, active)
    local xPlayers = ESX.GetPlayers()
    local sourcePlayer = source
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(sourcePlayer), false)

    for _, playerId in ipairs(xPlayers) do
        if GetVehiclePedIsIn(GetPlayerPed(playerId), false) == vehicle then
            TriggerClientEvent('applySpeedLimit', playerId, speed, active)
        end
    end
end)
