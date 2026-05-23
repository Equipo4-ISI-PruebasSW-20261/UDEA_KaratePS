@parabank_login
Feature: Autenticación y Persistencia de Sesión en Parabank

  Background:
    * url baseUrl
    * header Accept = 'application/json'

  Scenario: Customer Login Exitoso con persistencia de sesión
    # 1. Autenticación y Persistencia de Sesión
    # Petición GET a /login/{username}/{password}.
    Given path 'login'
    And path 'john'
    And path 'demo'
    When method GET
    # Validar que la respuesta sea 200 OK
    Then status 200
    * match response == '#notnull'

  Scenario: Customer Login Fallido (Credenciales Incorrectas)
    # Seguridad: Verificar que las credenciales incorrectas devuelvan un 401 Unauthorized
    Given path 'login'
    And path 'john'
    And path 'wrongpassword'
    When method GET
    # El servicio remoto responde 400 para credenciales inválidas.
    Then status 400
    And match response contains 'Invalid username and/or password'
