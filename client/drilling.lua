Drilling = {
    Active = false,
    StartedDrillingMs = 0,
    Prop = nil,
    SoundId = nil
}

Drilling.Start = function()
    if Drilling.Active == true then
        return false
    end
    
    local pedCoords = GetEntityCoords(PlayerPedId())
    local objectId = GetClosestObjectOfType(pedCoords, 5.0, Config.AtmPropHashKey, false)
    if DoesEntityExist(objectId) == false then
        print("Atm entity does not exist")
        return false
    end

    --Set coords to and freeze player and maybe implmenet esx to cancel drilling?
    Atm.AtmEntity = objectId

    Drilling.Active = true
    
    local prop = Drilling.CreateAndAttachDrill()
    Drilling.Prop = prop
    FreezeEntityPosition(PlayerPedId(), true)
    Drilling.LoadAnimations()
    Drilling.LoadSound()
    TaskPlayAnim(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 8.0, -8.0, -1, 49, 0,
            false, false, false)
    Drilling.SoundId = GetSoundId()
    PlaySoundFromEntity(Drilling.SoundId, "Drill", Drilling.Prop, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
    Drilling.StartedDrillingMs = GetGameTimer()

    --Config
    local randomDuration = math.random(10, 10)
    
    CreateThread(function()
        while Drilling.Active == true do
            local currentMs = GetGameTimer()
            local elapsedMs = currentMs - Drilling.StartedDrillingMs
            local elapsedSeconds = elapsedMs / 1000;
            local procentageCompleted = math.floor(elapsedSeconds / randomDuration * 100);
            if elapsedSeconds > randomDuration then
                Drilling.Active = false
            end
            local playerCoords = GetPlayerCoords()
            Draw3DText(playerCoords.x, playerCoords.y, playerCoords.z + 0.8, 0.3, procentageCompleted .. " ~g~%")
            Wait(0)
        end
        Drilling.StartedDrillingMs = 0
        StopSound(Drilling.SoundId)
        ReleaseSoundId(Drilling.SoundId)
        FreezeEntityPosition(PlayerPedId(), false)
        Drilling.ClearDrillProp()
    end)
    
    return true
end

Drilling.LoadAnimations = function()
    RequestAnimDict("anim@heists@fleeca_bank@drilling")
    while not HasAnimDictLoaded("anim@heists@fleeca_bank@drilling") do
        Wait(100)
    end
end

Drilling.ClearDrillProp = function()
    if Drilling.Prop and DoesEntityExist(Drilling.Prop) then
        DetachEntity(Drilling.Prop, true, true)

        DeleteObject(Drilling.Prop)

        if DoesEntityExist(Drilling.Prop) then
            SetEntityAsMissionEntity(Drilling.Prop, true, true)
            DeleteEntity(Drilling.Prop)
        end

        Drilling.Prop = nil
    end

    ClearPedTasks(PlayerPedId())
end

Drilling.LoadSound = function()
    RequestAmbientAudioBank("DLC_HEIST_FLEECA_SOUNDSET", 0)
    RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", 0)
    RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", 0)
end

Drilling.CreateAndAttachDrill = function()
    local modelHash = GetHashKey("hei_prop_heist_drill")
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Citizen.Wait(0)
    end
    local playerPed = PlayerPedId()
    local boneIndex = GetPedBoneIndex(playerPed, 57005)

    local prop = CreateObject(modelHash, 1.0, 1.0, 1.0, true, true, false)

    local boneIndex = GetPedBoneIndex(playerPed, 28422)
    AttachEntityToEntity(prop, playerPed, boneIndex, 0.0, 0, 0.0, 0.0, 0.0, 0.0, true, true, false, false, 2, true)
    SetEntityAsMissionEntity(prop, true, true)
    return prop
end