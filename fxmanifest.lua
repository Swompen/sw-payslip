name "sw-payslip"
author "Swompen"
version "v1.0.0"
description "A payslip system"
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_scripts {
	'config.lua'
}
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'sv_paycheck.lua'
}
client_script 'cl_paycheck.lua'

