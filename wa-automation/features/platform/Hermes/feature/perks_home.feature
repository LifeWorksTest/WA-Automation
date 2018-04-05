Feature:
1. Validate perks homepage functionality and link redirection

@H17.1 @H-Perks_homepage @Web @Hermes @Smoke
Scenario: Validate perks homepage functionality and link redirection
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App

    Given I click "Perks" from the Hermes menu top bar
    When I am on the Perks Homepage screen
    Then I validate that the Perks Homepage functionality is working correctly