Feature: 
    1. User first joins the network
    2. User's Birthday and Anniversary post
    3. 
    4. Company anniversary
@P1 @Web
Scenario: User first joins the network
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I am on the Dashboard
    And I add a new user to the network from Dashboard
    
    When I am on the Web App Login screen
    Then I login to Web App with the latest new user
    And I am login to Web App
    And I am on the News Feed screen
    And I validate that the News Feed contains "New user" post 

@P2 @Web
Scenario: User's Birthday and Anniversary post
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Profile" from the "Global Action" menu
    
    Given I am on Web App User Profile screen
    When I change user Birthday and Joind to the current month and day
    Then I click "News Feed" from the "Work" menu

    Given I am on the News Feed screen
    When I validate that the News Feed contains "Birthday" post 
    Then I validate that the News Feed contains "Anniversary" post 
    And I click "Logout" from the "Global Action" menu

@P3 @Web
Scenario: 
    Given I signup my company to Work Angel
    

@P4 @Web
Scenario: Company anniversary
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "Menu" from Top Bar menu
    And I click on "Account" from Top Bar menu
  
    Given I am on the Account screen
    When I change company Founded date to today

    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Profile" from the "Global Action" menu

    Given I am on the News Feed screen
    When I validate that the News Feed contains "Company Anniversary" post
    Then I click "Logout" from the "Global Action" menu

@P5
Scenario: Company anniversary
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App

    Given I am on the News Feed screen
    When I validate that the News Feed contains "Monthly recognition results published" post
    Then I click "Logout" from the "Global Action" menu
