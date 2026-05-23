@parabank_loan
Feature: Simulación de Préstamo con Evaluación de Riesgo

  Background:
    * url baseUrl
    * header Accept = 'application/json'
    * def customerId = 12212
    Given path 'customers', customerId, 'accounts'
    When method GET
    Then status 200
    * def fromAccountId = response[0].id

  Scenario: Solicitar un préstamo y validar fecha de respuesta
    * def requestPayload = { amount: 5000, downPayment: 500 }

    Given path 'requestLoan'
    And param customerId = customerId
    And param amount = requestPayload.amount
    And param downPayment = requestPayload.downPayment
    And param fromAccountId = fromAccountId
    When method POST
    Then status 200
    
    # Verificación de Respuesta: El campo responseDate debe ser una fecha válida y no nula.
    # Validar formato de fecha aproximado ISO-8601 usando Regex (ejemplo simplificado)
    * match response/loanResponse/responseDate == '#regex ^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}.*'
