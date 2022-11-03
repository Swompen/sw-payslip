local wait = 60000 * Config.PaySlipInterval

CreateThread(function()
    while true do
        Wait(wait)
        TriggerServerEvent('sw-payslip:Register')
    end
end)

RegisterNetEvent('sw-payslip:targetCollect', function()
    TriggerServerEvent('sw-payslip:Collect')
end)

