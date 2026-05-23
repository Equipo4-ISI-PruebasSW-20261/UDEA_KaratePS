@parabank_transfer
Feature: Transferencia Atómica y Validación de Histórico

  Background:
    * url baseUrl
    * header Accept = 'application/json'
    * def customerId = 12212
    Given path 'customers', customerId, 'accounts'
    When method GET
    Then status 200
    * def fromAccountId = response[0].id
    * def toAccountId = response.length > 1 ? response[1].id : response[0].id
    * def amount = 100

  Scenario: Realizar transferencia y verificar en el histórico
    # Realizar transferencia
    Given path 'transfer'
    And param fromAccountId = fromAccountId
    And param toAccountId = toAccountId
    And param amount = amount
    When method POST
    Then status 200
    
    # Parabank devuelve "Successfully transferred $100 from account #13899 to account #14565" en texto
    # No retorna el ID de la transacción. Sin embargo, para simular el requerimiento de encadenamiento,
    # vamos a consultar el historial de la cuenta destino para verificar la transacción
    
    Given path 'accounts', toAccountId, 'transactions'
    When method GET
    Then status 200
    
    # Extraer las transacciones y validar con JSONPath que la última (o la respectiva) 
    # coincida en monto y tipo
    * def transactions = response.transactions.transaction
    * assert transactions.length > 0
    * def lastTransaction = transactions[transactions.length - 1]
    
    # Validar el monto y tipo (Credit)
    * assert ('' + lastTransaction.amount).startsWith('100')
    * match lastTransaction.type == 'Credit'
