Config = Config or {}

Config.PaySlipInterval = 15 -- Intervall in minutes
Config.SocietyPays = true -- If true the money get pulled from the business account
Config.SocietyType = "management" -- qb-management = management, renewed = renewed banking
Config.PayType = "cash"  -- Payslips are payed in cash or bank
Config.Translations = {
    new_payslip = "You got a new payslip that you can collect at the bank",
    no_money = "Your business don't have any money to pay you",
    collected_payslip = "You collected your payslip: $" ..paycheck,
    Renewed_transactionTitle = "Payed salary",
    Renewed_transactionMessage = " Took out salary",
    Renewed_transactionFrom = "Payroll Office",
}