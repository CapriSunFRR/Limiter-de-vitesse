ESX = nil

ESX = exports["es_extended"]:getSharedObject()

local speedLimiterActive = false
local speedLimit = 0

openSpeedLimiterMenu = function()
    local elements = {
        {label = 'Limiter de vitesse', value = 'set_limit'},
        {label = 'Stop la limite', value = 'stop_limit'}
    }
    
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'speed_limiter_menu', {
        title    = 'Menu Limiteur de Vitesse',
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'set_limit' then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'speed_limiter_set', {
                title = 'Entrez la limite de vitesse (1-200)'
            }, function(data2, menu2)
                local speed = tonumber(data2.value)
                if speed >= 1 and speed <= 200 then
                    speedLimit = speed
                    speedLimiterActive = true
                    ESX.ShowNotification('Limite de vitesse fixée à ' .. speed .. ' km/h')
                    TriggerServerEvent('updateSpeedLimit', speedLimit, speedLimiterActive)
                else
                    ESX.ShowNotification('Valeur invalide. Veuillez entrer un nombre entre 1 et 200.')
                end
                menu2.close()
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif data.current.value == 'stop_limit' then
            speedLimiterActive = false
            speedLimit = 0
            ESX.ShowNotification('Limite de vitesse désactivée')
            TriggerServerEvent('updateSpeedLimit', speedLimit, speedLimiterActive)
        end
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

RegisterNetEvent('applySpeedLimit')
AddEventHandler('applySpeedLimit', function(limit, active)
    speedLimit = limit
    speedLimiterActive = active
    if not active then
        local playerPed = GetPlayerPed(-1)
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            SetEntityMaxSpeed(vehicle, GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel"))
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if speedLimiterActive then
            local playerPed = GetPlayerPed(-1)
            if IsPedInAnyVehicle(playerPed, false) then
                local vehicle = GetVehiclePedIsIn(playerPed, false)
                SetEntityMaxSpeed(vehicle, speedLimit / 3.6)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 170) then --F3 
            openSpeedLimiterMenu()
        end
    end
end)