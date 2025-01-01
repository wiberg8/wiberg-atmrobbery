-- SetRopesCreateNetworkWorldState(true);
-- SetForceVehicleTrails(false)
selectedVehicle = nil
selectedAtm = nil
PoliceBlip = nil
RobbableAtms = {}
AtmsDrilling = {}

RegisterNetEvent('wiberg-atmrobbery:UpdatePoliceBlip')
AddEventHandler('wiberg-atmrobbery:UpdatePoliceBlip', function(coords)
    if DoesBlipExist(PoliceBlip) then
        RemoveBlip(PoliceBlip) 
    end
    PoliceBlip = AddBlipForCoord(coords)
    SetBlipSprite(PoliceBlip, 161)
    SetBlipScale(PoliceBlip, 1.0)
	SetBlipColour(PoliceBlip, 1)
	BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('GPS-Sändare')
    EndTextCommandSetBlipName(PoliceBlip)
	PulseBlip(PoliceBlip)
end)

RegisterNetEvent('wiberg-atmrobbery:RobbableAtm')
AddEventHandler('wiberg-atmrobbery:RobbableAtm', function(atms)
   RobbableAtms = atms
end)


RegisterNetEvent('wiberg-atmrobbery:DrillingAtms')
AddEventHandler('wiberg-atmrobbery:DrillingAtms', function(atms)
    AtmsDrilling = atms
end)

CreateThread(function() 
    local sleep = 1500
    while true do
        if #RobbableAtms > 0 then
            sleep = 0
            for k, v in RobbableAtms do
                local coords = GetEntityCoords(v)
                local playerId = PlayerId()
                local playerCoords = GetEntityCoords(playerId)
                local distanceBetween = GetDistanceBetweenCoords(coords, playerCoords)
                if distanceBetween <= 1.5 then
                    sleep = 0
                    Draw3DText(coords.x, coords.y, coords.z, 0.3, "Tryck ~g~[E]~s~ för att borra")
                    if IsControlJustPressed("E") then
                        TriggerServerEvent("wiberg-atmrobbery:RobbingAtm", atm)
                    end
                end
                end10
            end 
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        --Num 6
        if IsControlJustPressed(0, 107) then
            local coords = GetPlayerCoords()
            coords = vector3(coords.x, coords.y + 3, coords.z - 1)

            local atm = CreateObjectNoOffset(
                -1364697528 --[[ Hash ]], 
                coords,
                true --[[ boolean ]], 
                true --[[ boolean ]], 
                true --[[ boolean ]]
            );
            SetEntityAsMissionEntity(
                atm, true, true
            )
            FreezeEntityPosition(atm, true)
            SetEntityHeading(atm, 60.00)
        end
        --Num 4
        if IsControlJustPressed(0, 108) then
            if DoesBlipExist(PoliceBlip) then
                RemoveBlip(PoliceBlip) 
            end
        end
        --Pageup
        if IsControlJustPressed(0, 208) then
            if Mission.Active and DoesEntityExist(Atm.AtmEntity) then
                local coords = GetEntityCoords(Atm.AtmEntity)
                TriggerServerEvent("wiberg-atmrobbery:UpdatePoliceBlip", coords)
            end
            -- local hashKey = GetHashKey("prop_atm_03")
            -- local pedCoords = GetEntityCoords(PlayerPedId())
            -- local objectId = GetClosestObjectOfType(pedCoords, 5.0, hashKey, false)
            
            -- local atmCoords = GetEntityCoords(objectId)
            
            -- SetEntityAsMissionEntity(objectId, true, true)
            -- DeleteEntity(objectId)
            -- while DoesEntityExist(objectId) do
            --     print("Waiting for " .. objectId .. " to be deleted")
            --     Wait(100)
            -- end
            -- local o = CreateObject(
            --     hashKey --[[ Hash ]], 
            --     atmCoords,
            --     true --[[ boolean ]], 
            --     false --[[ boolean ]], 
            --     false --[[ boolean ]]
            -- );
            
            -- AtmToVehicle();
        
        end
    end
end)

--690434
CreateThread(function()
    while true do
        
        -- local pedBoneCoords = GetPedBoneCoords(playerPed, 0x188E, 0,0,0);
        if selectedVehicle then
            local vehicleCoords = GetEntityCoords(selectedVehicle)
            local speedText = "km/h: " .. tostring(math.floor(GetEntitySpeed(selectedVehicle) * 3.6))
            local other = "currentgear" .. GetVehicleCurrentGear(selectedVehicle)
            Draw3DText(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 0.8, 0.3, speedText)
            Draw3DText(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 1.4, 0.3, tostring(other))
        end
        if selectedAtm then
            local atmCoords = GetEntityCoords(selectedAtm)
            Draw3DText(atmCoords.x, atmCoords.y, atmCoords.z + 0.8, 0.3, "~r~atm")
        end
        Wait(0)
    end
end)
    
        
--         -- local rope = AddRope(carCoords.x, carCoords.y, carCoords.z, 0.0, 0.0, 0.0, 20.0, 1, 10.0, 10, 1.0, false, false, false, 1.0, false, 0)
--         --         while not rope do
--         --             Wait(0)
--         --         end
--         --         AttachRopeToEntity(
--         --             rope, 
--         --             carEntity, 
--         --             carCoords.x, carCoords.y, carCoords.z,
--         --             true
--         --         );
--         -- AttachEntitiesToRope(rope, carEntity, npcEntity, carCoords.x, carCoords.y, carCoords.z, npcCoords.x, npcCoords.y, npcCoords.z, 1, false, false, "ROPE_ATTATCH", "ROPE_ATTATCH")

--         Wait(0)
--     end
-- end)

-- CreateThread(function()
--     Wait(3000)
--     DeleteEntity(690434);
-- end)

local function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end
RegisterNetEvent('lighterused') 
AddEventHandler('lighterused', function()
    -- local playerId = PlayerId()
    -- local playerPed = GetPlayerPed(playerId)
    -- local coords = GetEntityCoords(playerPed)
    -- local vehicle = GameGetClosestVehicle(coords)
    -- FunctionsAttachRopeToVehicle(vehicle);

    Mission.Start()

    -- if vehicle then
    --     selectedVehicle = vehicle
    -- end
    
--   print('Event fired')
--   local playerId = PlayerId();
--   local ped = GetPlayerPed(playerId);
--   local pedBoneIndex = GetPedBoneIndex(ped, 0x49D9);
--   local pedBoneCoords = GetPedBoneCoords(ped, 0x49D9, 0,0,0);


--   local pos = GetEntityCoords(ped);
--   loadAnimDict("anim@heists@fleeca_bank@drilling")
--   TaskPlayAnim(ped, 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle', 3.0, 3.0, -1, 1, 0, false, false, false)
--   local DrillObject = CreateObject(`hei_prop_heist_drill`, pos.x, pos.y, pos.z, true, true, true)
--   AttachEntityToEntity(DrillObject, ped, GetPedBoneIndex(ped, 57005), 0.14, 0, -0.01, 90.0, -90.0, 180.0, true, true, false, true, 1, true)
  
end)

function FunctionsAttachRopeToVehicle(vehicle)
    local playerId = PlayerId()
    local playerPed = GetPlayerPed(playerId)
    local playerHandCoords = GetPedBoneCoords(playerPed, 0x188E, 0,0,0);

    local trunkCoords = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "boot"))

    local distance = GetDistanceBetweenCoords(playerHandCoords, trunkCoords)
    -- if distance < 1.5 then
        local rope = AddRope(
            trunkCoords.x --[[X]],
            trunkCoords.y --[[Y]],
            trunkCoords.z --[[Z]],
            0.0 --[[rotX]], 
            0.0 --[[rotY]], 
            0.0 --[[rotZ]], 
            30.0 --[[maxLength]], 
            1    --[[ropeType]], 
            distance * 1.2  --[[initLength]], 
            0.1 --[[minLength]], 
            1.0 --[[lengthChangeRate]], 
            false --[[onlyPPU]], 
            false --[[collisionOn]],
            false --[[lockFromFront]], 
            1.0 --[[timeMultiplier]],
            false --[[breakable ]]
        )
        while not rope do
            Wait(0)
        end
        -- AttachRopeToEntity(
        --     rope, 
        --     vehicle, 
        --     trunkCoords.x,
        --     trunkCoords.y,
        --     trunkCoords.z,
        --     true
        -- );
        AttachEntitiesToRope(rope, vehicle, playerPed, trunkCoords.x, trunkCoords.y, trunkCoords.z, playerHandCoords.x, playerHandCoords.y, playerHandCoords.z, 1, false, false, "ROPE_ATTATCH", "ROPE_ATTATCH")
    -- end
end

function GameGetClosestVehicle(coords, modelFilter)
    return GameGetClosestEntity(GameGetVehicles(), false, coords, modelFilter)
end

function GameGetVehicles()
    return GetGamePool("CVehicle")
end

function GameGetClosestEntity(entities, isPlayerEntities, coords, modelFilter)
    local closestEntity, closestEntityDistance, filteredEntities = -1, -1, nil

    coords = vector3(coords.x, coords.y, coords.z)

    if modelFilter then
        filteredEntities = {}

        for currentEntityIndex = 1, #entities do
            if modelFilter[GetEntityModel(entities[currentEntityIndex])] then
                filteredEntities[#filteredEntities + 1] = entities[currentEntityIndex]
            end
        end
    end

    for k, entity in pairs(filteredEntities or entities) do
        local distance = #(coords - GetEntityCoords(entity))

        if closestEntityDistance == -1 or distance < closestEntityDistance then
            closestEntity, closestEntityDistance = isPlayerEntities and k or entity, distance
        end
    end

    return closestEntity, closestEntityDistance
end

function Draw3DText(x, y, z, scl_factor, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov * scl_factor
    if onScreen then
        SetTextScale(0.0, scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
local dragProgress = 0
local requiredProgress = 100

function AtmToVehicle()
    CreateThread(function()
            -- print("AtmToVehicle run")
        local playerId = PlayerId();
        local playerPed = GetPlayerPed(playerId);
        local coords = GetEntityCoords(playerPed);
       

        local vehicleHash = -1349095620;
        RequestModel(vehicleHash);

        while not HasModelLoaded(vehicleHash) do 
            Wait(10)
        end
        local spawnVehicleCoords = {
            x = coords.x + 10,
            y = coords.y,
            z = coords.z
        }
        local vehicle = CreateVehicle(
            vehicleHash, 
            spawnVehicleCoords.x,
            spawnVehicleCoords.y,
            spawnVehicleCoords.z,
            0, 
            true, 
            false
        )
        SetPedIntoVehicle(playerPed, vehicle, -1)
        -- SetVehicleDoorsLocked(vehicle, 1)
        local spawnedVehicleCoords = GetEntityCoords(vehicle);
        local o = CreateObject(
            506770882 --[[ Hash ]], 
            coords,
            true --[[ boolean ]], 
            false --[[ boolean ]], 
            false --[[ boolean ]]
        );
        FreezeEntityPosition(o, true)
        SetObjectPhysicsParams(o, 200.0, -8.0, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 45.0, 0.0)
        local atmCoords = GetEntityCoords(o);
        local rope = AddRope(spawnedVehicleCoords.x, spawnedVehicleCoords.y, spawnedVehicleCoords.z, 0.0, 0.0, 0.0, 20.0, 1, 10.0, 10, 1.0, false, false, false, 1.0, false, 0)
        while not rope do
            Wait(0)
        end
        -- AttachRopeToEntity(
        --     rope, 
        --     vehicle, 
        --     spawnedVehicleCoords.x,
        --     spawnedVehicleCoords.y,
        --     spawnedVehicleCoords.z,
        --     true
        -- );
        AttachEntitiesToRope(rope, vehicle, o, spawnedVehicleCoords.x, spawnedVehicleCoords.y, spawnedVehicleCoords.z, atmCoords.x, atmCoords.y, atmCoords.z, 1, false, false, "ROPE_ATTATCH", "ROPE_ATTATCH")
        local breakDouble = false
        local lastPrint = false
        while true do
            if isRopeUnderTension(rope, vehicle, o) then
                -- Increment dragging progress
                dragProgress = dragProgress + 1
                if dragProgress > 3000 then
                    FreezeEntityPosition(o, false)
                    break
                end
            end
            -- local duration = 0;
            -- local totalMsOverLimit = 0
            -- local startTime = GetGameTimer()


            

            -- while GetEntitySpeed(vehicle) * 3.6 >= 25 do
            --     totalMsOverLimit = GetGameTimer() - startTime
            --     if totalMsOverLimit > 3000 then
            --         breakDouble = true
            --         FreezeEntityPosition(o, false)
            --         break;
            --     end
            --     Wait(0)
            -- end
            -- if breakDouble then
            --     break
            -- end
            Wait(0)
        end
        print("breakDouble breaked")
    end)
end

function isRopeUnderTension(rope, vehicle, atm)
    -- Constants
    local tensionThreshold = 0.1 -- Adjust based on how sensitive you want the tension check to be

    -- Get the positions of the ATM and the vehicle
    local atmPos = GetEntityCoords(atm)
    local vehiclePos = GetEntityCoords(vehicle)

    -- Get the velocity of the vehicle
    local vehicleVelocity = GetEntitySpeed(vehicle) -- Speed in m/s

    -- Get the rope length
    local ropeLength = GetRopeLength(rope) -- Assumes you have a rope entity

    -- Calculate the current distance between the ATM and the vehicle
    local currentDistance = #(atmPos - vehiclePos)
    -- print(vehicleVelocity)
    -- Determine if the rope is under tension
    if currentDistance >= ropeLength then
        if vehicleVelocity > 1 then
            return true
        end
    end

    return false
end

function GetPlayerCoords()
    local playerId = PlayerId()
    local playerPed = GetPlayerPed(playerId)
    return GetEntityCoords(playerPed)
end

 -- CreateThread(function()
            --     local playerId = PlayerId()
            --     local playerPed = GetPlayerPed(playerId)
            --     local playerCoords = GetEntityCoords(playerPed);
            --     local hashAtm = -1364697528;
            --     local closestAtm = GetClosestObjectOfType(playerCoords, 10.0, hashAtm)
            --     local vehicle = GameGetClosestVehicle(playerCoords);
            --     print("cloestAtm " .. closestAtm)
            --     print("vehicle " .. vehicle)
            --     local vehicleCoords = GetEntityCoords(vehicle);
            --     local atmCoords = GetEntityCoords(closestAtm);
            --     NetworkRegisterEntityAsNetworked(closestAtm);
            --     local rope = AddRope(vehicleCoords, 0.0, 0.0, 0.0, 20.0, 1, 10.0, 10, 1.0, false, false, false, 1.0, false, 0)
            --     while not rope do
            --         Wait(0)
            --     end
            --     AttachRopeToEntity(
            --         rope, 
            --         vehicle, 
            --         vehicleCoords,
            --         true
            --     );
            --     AttachEntitiesToRope(rope, vehicle, closestAtm, vehicleCoords, atmCoords, 1, false, false, "ROPE_ATTATCH", "ROPE_ATTATCH")
            -- end)
            
        -- if IsControlJustPressed(0, 110) then
        --     local playerId = PlayerId();
        --     local playerPed = GetPlayerPed(playerId);
        --     local coords = GetEntityCoords(playerPed);
        --     local o = GetClosestObjectOfType(coords, 10.0, -1364697528, true, false, false)
        --     -- local object = GetClosestObjectOfType(
        --     --     coords.x --[[ number ]], 
        --     --     coords.y --[[ number ]], 
        --     --     coords.z --[[ number ]], 
        --     --     100 --[[ number ]], 
        --     --     -1364697528 --[[ Hash ]], 
        --     --     true, 
        --     --     false, 
        --     --     false
        --     -- )
        --     print(object)
        --     if IsEntityAMissionEntity(o) then
        --         SetEntityAsMissionEntity(o, false, true)
        --     end
        --     DeleteObject(object);
        --     -- CreateObject(
        --     --             2930269768 --[[ Hash ]], 
        --     --     coords.x --[[ number ]], 
        --     --     coords.y --[[ number ]], 
        --     --     coords.z --[[ number ]], 
        --     --     true --[[ boolean ]], 
        --     --     false --[[ boolean ]], 
        --     --     false --[[ boolean ]]
        --     -- );

        -- end

-- Drilling.DisableControls = function()
--     for _, control in ipairs(Drilling.DisabledControls) do
--         DisableControlAction(0, control, true)
--     end
-- end

-- Drilling.EnableControls = function()
--     for _, control in ipairs(Drilling.DisabledControls) do
--         DisableControlAction(0, control, false)
--     end
-- end

-- Drilling.DisabledControls = {30, -- Move Left/Right
--     31, -- Move Up/Down
--     44, -- Cover
--     -- 1,   -- Look Left/Right
--     -- 2,   -- Look Up/Down
--     199, -- Pause Menu
--     35, -- v
--     24, -- attack
--     140 -- attack
-- }

     -- local entity = GetPlayerPed(PlayerId())
                -- local heading = GetEntityHeading(selectedAtm)
                -- print("Orignal heading " .. heading)
                -- Wait(3000)
                -- Wait(3000)
                -- SetEntityCoords(
                --     selectedAtm --[[ Entity ]], 
                --     coords.x --[[ number ]], 
                --     coords.y --[[ number ]], 
                --     coords.z --[[ number ]], 
                --     false --[[ boolean ]], 
                --     false --[[ boolean ]], 
                --     false --[[ boolean ]], 
                --     false --[[ boolean ]]
                -- )
                -- SetEntityHeading(selectedAtm, 120)
            -- end
            -- FreezeEntityPosition(selectedAtm, true)
            -- print(GetEntityHeading(selectedAtm))
            -- return
            -- local function cleanup_rope_textures()
            --     -- we only want to cleanup if there are no other ropes still left on the map
            --     -- otherwise we'll make them go invisible.
            --     if #GetAllRopes() == 0 then
            --         -- there are no ropes on the map, we're safe to unload the textures.
            --         RopeUnloadTextures()
            --     end
            -- end
            -- CreateThread(function()
            --     -- if textures aren't loaded then we need to load them
            --     if not RopeAreTexturesLoaded() then
            --         -- load the textures so we can see the rope
            --         RopeLoadTextures()
            --         while not RopeAreTexturesLoaded() do
            --             Wait(0)
            --         end
            --     end
                
            --     -- Create a rope and store the handle
            --     local npcEntity = 1980707;
            --     local playerId = PlayerId();
            --     local playerPed = GetPlayerPed(playerId);

            --     local npcCoords = GetEntityCoords(npcEntity);

            --     local carEntity = 5618960;
            --     local carCoords = GetEntityCoords(carEntity);
            --     -- print("x " .. c.x)
            --     -- print("y " .. c.y)
            --     -- print("z " .. c.z)
            --     -- print(GetEntityBoneIndexByName())
            --     local rope = AddRope(carCoords.x, carCoords.y, carCoords.z, 0.0, 0.0, 0.0, 20.0, 1, 10.0, 10, 1.0, false, false, false, 1.0, false, 0)
            --     while not rope do
            --         Wait(0)
            --     end
            --     AttachRopeToEntity(
            --         rope, 
            --         carEntity, 
            --         carCoords.x, carCoords.y, carCoords.z,
            --         true
            --     );
            --     AttachEntitiesToRope(rope, carEntity, npcEntity, carCoords.x, carCoords.y, carCoords.z, npcCoords.x, npcCoords.y, npcCoords.z, 1, false, false, "ROPE_ATTATCH", "ROPE_ATTATCH")
                -- AttachEntitiesToRope
                -- AttachRopeToEntity(
                --     rope, 
                --     playerPed, 
                --     0, 
                --     0, 
                --     0, 
                --     true
                -- );
                -- Check if the rope exists.
                -- if not DoesRopeExist(rope) then
                --     cleanup_rope_textures()
                --     -- If the rope does not exist, end the execution of the code here.
                --     return
                -- end
                -- -- Let the rope exist for 3 seconds
                -- Wait(3000)
                -- -- Delete the rope!
                -- DeleteRope(rope)
                -- cleanup_rope_textures()
            -- end)