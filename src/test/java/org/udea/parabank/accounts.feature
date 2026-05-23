@parabank_accounts
Feature: Integridad de Datos en Consulta de Cuentas

  Background:
    * url baseUrl
    * header Accept = 'application/json'

  Scenario: Consulta de cuentas y validación de esquema
    * def customerId = 12212
    Given path 'customers', customerId, 'accounts'
    When method GET
    Then status 200
    
    # Validación de Esquema
    * def accountSchema = { id: '#number', customerId: '#number', type: '#string', balance: '#number' }
    And match each response == accountSchema
    
    # Validar Enum CHECKING/SAVINGS/LOAN
    * def isValidType = function(acc){ return acc.type == 'CHECKING' || acc.type == 'SAVINGS' || acc.type == 'LOAN' }
    * match each response == '#? isValidType(_)'
    
    # Validar que el customerId en la respuesta coincida con el de la URI
    * def isMatchingCustomerId = function(acc){ return acc.customerId == customerId }
    * match each response == '#? isMatchingCustomerId(_)'
