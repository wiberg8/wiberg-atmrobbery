fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Kakarot'
description 'Allows players to rob atm'
version '1.2.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/drilling.lua',
    'client/mission.lua',
    'client/atm.lua'
}

server_script 'server/main.lua'

dependencies {
    'qb-core'
}
