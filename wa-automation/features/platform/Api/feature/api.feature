Feature:

@API1 @Web
Scenario:
	Given I create a new company using the API
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Logout" from the "Global Action" menu