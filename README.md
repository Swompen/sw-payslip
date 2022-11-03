![chrome_nYeMRDeW9E](https://user-images.githubusercontent.com/16113909/199747215-3bb56b40-20b6-4b85-a5e3-6836750c738b.png)

# [ SW-PAYSLIP ]
Sw-payslip is a simple payslip system for your server.

# [ FEATURES ]

- After every X minutes you collect a payslip that saves in the database

- Can take money from soceity

- Works with qb-management & Renewed banking

- Works with multijob (And money will be taken from correct jobs)

- Easy config with translations

# [ INSTALLATION ]
1. Go trough the config and change things to your liking.
2. Make a target function or something and trigger below trigger. (If you dont know how, come to my discord and ask me)
```
sw-payslip:targetCollect
```
3. Go to qb-core --> server --> functions.lua and comment out or remove the code below.

```
-- Paychecks (standalone - don't touch)
function PaycheckInterval()
    if next(QBCore.Players) then
        for _, Player in pairs(QBCore.Players) do
            if Player then
                local payment = QBShared.Jobs[Player.PlayerData.job.name]['grades'][tostring(Player.PlayerData.job.grade.level)].payment
                if not payment then payment = Player.PlayerData.job.payment end
                if Player.PlayerData.job and payment > 0 and (QBShared.Jobs[Player.PlayerData.job.name].offDutyPay or Player.PlayerData.job.onduty) then
                    if QBCore.Config.Money.PayCheckSociety then
                        local account = exports['qb-management']:GetAccount(Player.PlayerData.job.name)
                        if account ~= 0 then -- Checks if player is employed by a society
                            if account < payment then -- Checks if company has enough money to pay society
                                TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, Lang:t('error.company_too_poor'), 'error')
                            else
                                Player.Functions.AddMoney('bank', payment)
                                exports['qb-management']:RemoveMoney(Player.PlayerData.job.name, payment)
                                TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, Lang:t('info.received_paycheck', {value = payment}))
                            end
                        else
                            Player.Functions.AddMoney('bank', payment)
                            TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, Lang:t('info.received_paycheck', {value = payment}))
                        end
                    else
                        Player.Functions.AddMoney('bank', payment)
                        TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, Lang:t('info.received_paycheck', {value = payment}))
                    end
                end
            end
        end
    end
    SetTimeout(QBCore.Config.Money.PayCheckTimeOut * (60 * 1000), PaycheckInterval)
end
```
