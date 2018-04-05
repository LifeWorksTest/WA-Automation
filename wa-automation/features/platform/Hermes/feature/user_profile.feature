Feature:
    1. Change user profile and check the results
    2. Check there is a value in the carousel
    3. Go to user settings from user profile
    4. validate Interests functionality (choose interest)
    5. Tick\Untick 'Hide my age'
    6. Hover over Achivements and validate date

@H7.1 @H-Profile @Web @Hermes @headless_hermes @Regression @Production_Smoke @Smoke @NotParallel @CI_Pass
Scenario: Change user profile and check the results
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Profile" from the "Global Action" menu
    
    Given I am on Web App User Profile screen
    When I change my details to "user1"
    Then I check that user profile as change to "user1"
    And  I change my details to "user2"
    And I check that user profile as change to "user2"
    And I click "Logout" from the "Global Action" menu

@H7.2 @H-Profile @Web @Hermes @headless_hermes @CI_Pass
Scenario: Check there is a value in the carousel
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Profile" from the "Global Action" menu

    Given I am on Web App User Profile screen
    Then I check the functionality of the carousel
    And I click "Logout" from the "Global Action" menu

@H7.3 @H-Profile @Web @Hermes @headless_hermes @CI_Pass
Scenario: Go to user settings from user profile
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Profile" from the "Global Action" menu
    
    Given I am on Web App User Profile screen
    When I click "Settings" from User Profile screen
    Then I am on the Settings screen
    And I click back from the browser
    And I am back to User Profile screen
    And I click "Logout" from the "Global Action" menu

@H7.4 @H-Profile @Web @Hermes @headless_hermes @CI_Pass
Scenario: validate Interests functionality (choose interest)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Profile" from the "Global Action" menu
    
    Given I am on Web App User Profile screen
    When I click "Interests" from User Profile screen
    Then I validate Interests functionality
    And I click "Logout" from the "Global Action" menu

@H7.5 @H-Profile @Web @Hermes @headless_hermes @CI_Pass
Scenario: Tick\Untick 'Hide my age'
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Profile" from the "Global Action" menu
    
    Given I am on Web App User Profile screen
    When I click "Edit Profile" from User Profile screen
    Then I "hide" my age

    Given I am on Web App User Profile screen
    When I click "Edit Profile" from User Profile screen
    Then I "dont hide" my age
    And I click "Logout" from the "Global Action" menu

@H7.6 @H-Profile @Web @Hermes @headless_hermes @Bug
Scenario Outline: Hover over Achivements and validate date
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<user>"
    Then I am login to Web App
    And I click "Profile" from the "Global Action" menu
    
    Given I am on Web App User Profile screen
    When I click "Achievements" from User Profile screen
    Then I hover over Medals and Milstones and I validate the data
    Examples:
        |user |
        |user1|

@H7.7 @H-Profile @Web @Hermes @headless_hermes @Bug
Scenario: Exceed the maximum invite limit as set in Arch
    Given I set the dependant account invite limit for the "current company" to "5" in Arch

    Given I am on the Web App Login screen
    And I insert valid email and password
    And I am login to Web App
    And I click "Profile" from the "Global Action" menu
    And I am on Web App User Profile screen
    And I click "Family" from User Profile screen
    And I remove "all" family members from the company
    When I invite "5" new family members to the company
    Then I should not be able to invite anymore family members to the company
    And I click "Logout" from the "Global Action" menu








