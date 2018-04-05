Feature:
    1. Change to profile 2 and then to profile 1
    2. Click Edit profile and then click Cancel button
    3. Add/Remove user to/from Admin list and also as Network Owner

@Z6.1 @Z-Account @Web @Zeus @headless_zeus @Smoke @Regression @Production_Smoke
Scenario: Change to profile 2 and then to profile 1
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "Menu" from Top Bar menu
    And I click on "Account" from Top Bar menu
  
    Given I am on the Account screen
    When I change company profile to "profile_2"
    Then I click on "Save" from the Account screen    
    And I check that the changes are match to "profile_2"

    When I change company profile to "profile_1"
    Then I click on "Save" from the Account screen    
    And I check that the changes are match to "profile_1"
    And I logout from Admin Panel

@Z6.2 @Z-Account @Web @Zeus @headless_zeus
Scenario: Click Edit profile, change to Profile 2 without saving and check that the progile is still profile 1
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "Menu" from Top Bar menu
    And I click on "Account" from Top Bar menu
  
    Given I am on the Account screen
    When I click on "Company Profile" from the Account screen
    Then I change company profile to "profile_2"
    And I click on "Cancel" from the Account screen
    And I check that the changes are match to "profile_1"
    And I am back to Company Profile
    And I logout from Admin Panel
 
@Z6.3 @Z-Account @Web @Zeus @headless_zeus @NotParallel @Web-6968
Scenario: Add/Remove user to/from Admin list and also as Network Owner
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "Menu" from Top Bar menu
    And I click on "Account" from Top Bar menu
    
    Given I am on the Account screen
    When I click on "Admins" from the Account screen
    Then I "add" an existing user as Admin
    And I validate all changes in view after I "add" an existing user
    And I click on "Menu" from Top Bar menu
    And I click on "Account" from Top Bar menu

    Given I am on the Account screen
    When I click on "Admins" from the Account screen
    Then I change the Newtwork Owner
    And I logout from Admin Panel

    Given I check that the new Admin "can" login as "Admin"
    When I click on "Menu" from Top Bar menu
    Then I click on "Account" from Top Bar menu
    Given I am on the Account screen
    When I click on "Admins" from the Account screen
    Then I change the Newtwork Owner
    And I logout from Admin Panel

    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "Menu" from Top Bar menu
    And I click on "Account" from Top Bar menu
    
    Given I am on the Account screen
    When I click on "Admins" from the Account screen
    Then I "remove" "user2 user2" as Admin
    And I validate all changes in view after I "remove" an existing user
    And I logout from Admin Panel
    And I check that the new Admin "cant" login as "Admin"