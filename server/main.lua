local QBCore = exports['qb-core']:GetCoreObject()
local RobberyOnGoing = false
local Entity = nil
local RobbableAtms = {}
local AtmsDrilling = {}

QBCore.Functions.CreateUseableItem('lighter', function(source, item)
    TriggerClientEvent("lighterused", source)
end)

RegisterServerEvent('wiberg-atmrobbery:UpdatePoliceBlip') 
AddEventHandler('wiberg-atmrobbery:UpdatePoliceBlip', function(coords)
	local players = QBCore.Functions.GetPlayers()

	for i = 1, #players do
		local player = QBCore.Functions.GetPlayer(players[i])
		if player.PlayerData.job.name == "police" then
			TriggerClientEvent("wiberg-atmrobbery:UpdatePoliceBlip", players[i], coords)
		end
	end
end)

RegisterServerEvent('wiberg-atmrobbery:RobbableAtm') 
AddEventHandler('wiberg-atmrobbery:RobbableAtm', function(atm)
	RobbableAtms[atm] = atm
	TriggerClientEvent("wiberg-atmrobbery:RobbableAtm", RobbableAtms)
end)

RegisterServerEvent('wiberg-atmrobbery:DrilledAtm') 
AddEventHandler('wiberg-atmrobbery:DrilledAtm', function(atm)
	--Rewards?

	local random = math.random(1, 10)
	local billsAmount = math.random(1, 10000)
	if random > 2 then
		xPlayer.GiveItem("markedbills", billsAmount)
	end

	table.remove(RobbableAtms, atm)
	table.remove(AtmsDrilling, atm)
end)