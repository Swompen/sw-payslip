local QBCore = exports['qb-core']:GetCoreObject()
local paycheck = 0

RegisterServerEvent('sw-payslip:Register', function()
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        local cid = Player.PlayerData.citizenid
        local payment = Player.PlayerData.job.payment
        if Player.PlayerData.job.onduty then
            local result = exports.oxmysql:executeSync('SELECT * FROM paychecks WHERE citizenid = ? AND job = ?',
                { cid, Player.PlayerData.job.name })
            if result[1] ~= nil then
                local collectamount = result[1].collectamount + payment
                exports.oxmysql:execute('UPDATE paychecks SET collectamount = ? WHERE citizenid = ? AND job = ?',
                    { collectamount, cid, Player.PlayerData.job.name })
                TriggerClientEvent('QBCore:Notify', src, Config.Translations.new_payslip, 'success', 3200)
                Wait(1000)
            else
                exports.oxmysql:insert('INSERT INTO paychecks (`citizenid`, `collectamount`, `job`, `realname`) VALUES (?, ?, ?, ?)'
                    , { cid, payment, Player.PlayerData.job.name, Player.PlayerData.job.label })
            end
        end
    end
)

RegisterServerEvent('sw-payslip:Collect', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid
    local result = MySQL.query.await('SELECT * FROM paychecks WHERE citizenid = ?', { cid })
    for _, v in pairs(result) do
        local account = exports['Renewed-Banking']:getAccountMoney(v.job)
        paycheck = v.collectamount
        if Config.SocietyPays then
            if Config.SocietyType == 'management' then
                account = exports['qb-management']:GetAccount(v.job)
            else
                account = exports['Renewed-Banking']:getAccountMoney(v.job)
            end

            if account ~= 0 then
                if account < paycheck then
                    TriggerClientEvent('QBCore:Notify', src, Config.Translations.no_money, 'error', 4500)
                else
                    Player.Functions.AddMoney(Config.PayType, paycheck)
                    exports.oxmysql:execute('UPDATE paychecks SET collectamount = ? WHERE citizenid = ? AND job = ?',
                        { 0, cid, v.job })
                    TriggerClientEvent('QBCore:Notify', src, Config.Translations.collected_payslip)
                    if Config.SocietyType == 'management' then
                        exports['qb-management']:RemoveMoney(v.job, paycheck)
                    else
                        exports['Renewed-Banking']:removeAccountMoney(v.job, paycheck)
                        exports['Renewed-Banking']:handleTransaction(v.job, 'Utbetalad lön', paycheck,
                            Player.PlayerData.charinfo.firstname ..
                            ' ' ..
                            Player.PlayerData.charinfo.lastname .. '' .. Config.Translations.Renewed_transactionMessage,
                            Config.Translations.Renewed_transactionTitle, v.job, 'withdraw')
                    end
                end
            end
        else
            Player.Functions.AddMoney(Config.PayType, paycheck)
            exports.oxmysql:execute('UPDATE paychecks SET collectamount = ? WHERE citizenid = ? AND job = ?',
                { 0, cid, v.job })
            TriggerClientEvent('QBCore:Notify', src, Config.Translations.collected_payslip)
        end
    end
end)
