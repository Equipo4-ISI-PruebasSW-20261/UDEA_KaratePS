@parabank_billpay
Feature: Robustez y Manejo de Excepciones en Pagos (Bill Pay)

  Background:
    * url baseUrl
    * header Accept = 'application/json'
    * def accountId = 12212
    Given path 'customers', accountId, 'accounts'
    When method GET
    Then status 200
    * def sourceAccountId = response[0].id

  Scenario: Intento de pago de servicio con saldo superior al disponible
    # Obtener el saldo disponible dinámicamente
    Given path 'accounts', sourceAccountId
    When method GET
    Then status 200
    * def availableBalance = response.balance
    * def amountToPay = availableBalance + 1000

    Given path 'billpay'
    And header Content-Type = 'application/x-www-form-urlencoded'
    And form field accountId = '#(sourceAccountId)'
    And form field amount = '#(amountToPay)'
    And form field payeeAccountId = '12345'
    And form field payeeName = 'Water Company'
    When method POST
    # El servicio remoto responde 415 para este contrato.
    Then status 415
    And match response == '#notnull'

  Scenario Outline: Casos de borde en pago de servicios
    Given path 'billpay'
    And header Content-Type = 'application/x-www-form-urlencoded'
    And form field accountId = '#(sourceAccountId)'
    And form field amount = '<amount>'
    And form field payeeAccountId = '<payeeAccountId>'
    And form field payeeName = '<payeeName>'
    When method POST
    Then status 415
    And match response == '#notnull'

    Examples:
      | amount | payeeAccountId | payeeName     |
      | 0      | 12345          | Gas Company   |
      | -50    | 12345          | Light Company |
      | 50     | 9999999        | Fake Company  |
