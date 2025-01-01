Mission = {
    Active = false,
    Text = {
        Main = nil
    },
    StartedAttachRopeMs = nil
}   

Mission.Start = function()
    Mission.Active = true
    -- Mission.Text.Main = "Borrar"
    CreateThread(function() 
        while Mission.Active == true do
            if Mission.Text.Main ~= nil then
                DrawTxt(0.97, 0.6, 1.0, 1.0, 0.5, Mission.Text.Main, 255, 255, 255, 255) 
            end
            if Atm.AtmEntity then
                local atmCoords = GetEntityCoords(Atm.AtmEntity)
                Draw3DText(atmCoords.x, atmCoords.y, atmCoords.z + 0.8, 0.3, "AASDASD")
            end
            Wait(0)
        end
    end)
    CreateThread(function() 
        if Drilling.Start() == true then
            while Drilling.Active == true do
                Wait(1000)
            end
            Mission.Text.Main = "Koppla ihop bilen och atm"
            Atm.AttachRope()
            while Atm.AttachingRope == true do
                Wait(1000)
            end
            if Atm.AttachRopeSuccess then
                Mission.Text.Main = "Kör med bilen och dra loss bankautomaten från vägen"
                Atm.LoosenAtmFromWall()
                while Atm.LoosenAtmFromWallStatus == true do
                    Wait(1000)
                end
            end

            -- Wait(10000)
            -- Mission.Active = false
        end
        
        -- Mission.StartedAttachRopeMs = GetGameTimer()
        -- local maximumSeconds = 60
        -- local durationRope = 60
        -- while Atm.Active == true do
        --     print("Atm is active")
        --     local currentMs = GetGameTimer()
        --     local elapsedMs = currentMs - Mission.StartedAttachRopeMs
        --     local elapsedSeconds = elapsedMs / 1000;
        --     if elapsedSeconds > durationRope then
        --         Atm.AttachRopeSuccess = false
        --         --Send notification that the atm got stuck again?
        --         break;
        --     end
        --     Mission.Text.Main = "Koppla rep  ~r~" .. math.floor(durationRope - elapsedSeconds) .. " ~s~sek på dig"
        --     -- Mission.Text.Main = "aksdasjdka"
        --     Wait(500)
        -- end
        -- Mission.Text.Main = nil
    end)
end

Mission.ForceStop = function()
    if Atm.AtmEntity and DoesEntityExist(Atm.AtmEntity) then
        DeleteEntity(Atm.AtmEntity)
    end
    Drilling.ClearDrillProp()
    Atm.Active = false
    Atm.AttachRopeSuccess = false
    Atm.AttachingRope = false
    Atm.LoosenAtmFromWall = false
    Atm.Vehicle = nil
    Atm.AtmEntity = nil
    Drilling.Active = false
    Drilling.StartedDrillingMs = 0
    Drilling.Prop = nil
    Drilling.SoundId = nil
end

DrawTxt = function(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end