Atm = {
    Active = false,
    AttachRopeSuccess = false,
    AttachingRope = false,
    LoosenAtmFromWallStatus = false,
    LoosenAtmFromWallSuccess = false,
    PoliceNotificationStatus = false,
    Vehicle = nil,
    AtmEntity = nil,
    Rope = nil
}

Atm.AttachRope = function()
    if Atm.AttachingRope == true then
        return
    end
    Atm.AttachingRope = true

    local playerId = PlayerId()
    local playerPed = GetPlayerPed(playerId)
    local playerCoords = GetEntityCoords(playerPed);
    Atm.Vehicle = GameGetClosestVehicle(playerCoords)
    Atm.LoadAnimations()
    CreateThread(function()
        while Atm.AttachingRope do
            local playerId = PlayerId()
            local playerPed = GetPlayerPed(playerId)
            local playerCoords = GetEntityCoords(playerPed);
            local trunkCoords = GetWorldPositionOfEntityBone(Atm.Vehicle, GetEntityBoneIndexByName(Atm.Vehicle, "boot"))
            local distanceBetween = GetDistanceBetweenCoords(trunkCoords, playerCoords);
            --Check if vehicle is to far of from atm
            local textToDraw = "Gå närmare för att fästa repet"
            if distanceBetween <= 1.5 then
                textToDraw = "Håll in ~g~[E]~s~ för att koppla repet"
                
                if IsControlJustPressed(0, 46) then
                    TaskPlayAnim(PlayerPedId(), "anim_heist@hs3f@ig14_open_car_trunk@male@", "open_trunk_rushed", 8.0, -8.0, -1, 49, 0,false, false, false)
                    local startPress = GetGameTimer()
                    local duration = 10000
                    
                    while IsControlJustReleased(0, 46) == false do
                        local msLeft = (GetGameTimer() - startPress)
                        local procentageCompleted = math.floor(msLeft / duration * 100);
                        
                        playerCoords = GetEntityCoords(playerPed);
                        trunkCoords = GetWorldPositionOfEntityBone(Atm.Vehicle, GetEntityBoneIndexByName(Atm.Vehicle, "boot"))
                        distanceBetween = GetDistanceBetweenCoords(trunkCoords, playerCoords)
                        Draw3DText(trunkCoords.x, trunkCoords.y, trunkCoords.z - 0.8, 0.3, "~g~" .. procentageCompleted .. "~s~%")

                        if distanceBetween > 1.5 then
                            break;
                        end
                        if procentageCompleted > 100  then
                            Atm.AttachRopeSuccess = true
                            Atm.AttachingRope = false
                            break;
                        end
                        Wait(0)
                    end
                    ClearPedTasks(PlayerPedId())
                end
            end
            Draw3DText(trunkCoords.x, trunkCoords.y, trunkCoords.z - 0.8, 0.3, textToDraw)
            --Item check?
            Wait(0)
        end
    end)
end

Atm.LoosenAtmFromWall = function()
    Atm.LoosenAtmFromWallStatus = true
    CreateThread(function()
        while Atm.LoosenAtmFromWallStatus == true do
            local playerId = PlayerId();
            local playerPed = GetPlayerPed(playerId);
            -- local coords = GetEntityCoords(playerPed);
           
            local vehicleCoords = GetEntityCoords(Atm.Vehicle);
            local atmCoords = GetEntityCoords(Atm.AtmEntity);

            SetObjectPhysicsParams(Atm.AtmEntity, 200.0, -8.0, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 45.0, 0.0)
            local rope = AddRope(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, 0.0, 0.0, 0.0, 20.0, 1, 10.0, 10, 1.0, false, false, false, 1.0, false, 0)
            Atm.Rope = rope
            while not DoesRopeExist(rope) do
                Wait(0)
            end

            AttachEntitiesToRope(rope, Atm.Vehicle, Atm.AtmEntity, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, atmCoords.x, atmCoords.y, atmCoords.z, 1, false, false, "ROPE_ATTATCH", "ROPE_ATTATCH")
            local dragProgress = 0
            while true do
                if isRopeUnderTension(Atm.Rope, Atm.Vehicle, Atm.AtmEntity) then
                    dragProgress = dragProgress + 1
                    print(dragProgress)
                    if dragProgress > 100 then
                        FreezeEntityPosition(Atm.AtmEntity, false)
                        Atm.LoosenAtmFromWallStatus = false
                        Atm.LoosenAtmFromWallSuccess = true
                        break
                    end
                end
                Wait(0)
            end
            print("breakDouble breaked")
            Wait(0)
        end
    end)
end

Atm.PoliceNotification = function()
    Atm.PoliceNotificationStatus = true
    --Trigger police phone message
    CreateThread(function() 
        while Atm.PoliceNotificationStatus and DoesEntityExist(Atm.AtmEntity) do
            local atmCoords = GetEntityCoords(Atm.AtmEntity)
            TriggerServerEvent("wiberg-atmrobbery:UpdatePoliceBlip", atmCoords)
            Wait(1500)
        end
    end)
    CreateThread(function() 
        local start = GetGameTimer()
        local policeNotificationMs = 60 * 1000
        while Atm.PoliceNotificationStatus and DoesEntityExist(Atm.AtmEntity) do
            if GetGameTimer() - start > policeNotificationMs then
                Atm.PoliceNotificationStatus = false
                TriggerServerEvent("wiberg-atmrobbery:RobbableAtms", Atm.AtmEntity)
            end
            Wait(10)
        end
    end)
end

Atm.LoadAnimations = function()
    RequestAnimDict("anim_heist@hs3f@ig14_open_car_trunk@male@")
    while not HasAnimDictLoaded("anim_heist@hs3f@ig14_open_car_trunk@male@") do
        Wait(100)
    end
end