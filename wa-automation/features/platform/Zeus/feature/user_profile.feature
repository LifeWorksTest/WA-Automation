Feature:
    1. Change user profile and make sure that the change as been saved
    2. Deactivate and reactivate user
    3. Validate total amount of recognition that the user received for the current month
    4. Validate total amount of recognition that the user sent for the current month
    5. Validate Recognitions by value accouring total recognitions that the user received
    6. Validate Milestones accouring total recognitions that the user received
    7. Validate Performance and Engagment for each month
    
@Z7.1 @Z-UserProfile @Web @Zeus @headless_zeus @Bug
Scenario: Change user profile and make sure that the change as been saved
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel

    Given I am on the Dashboard
    Then I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu
    
    Given I am on the Employees screen
    When I click on "Active colleagues" from Employees screen
    Then I open user profile index "1"

    Given I am on the User Profile screen
    When I change the user profile to "user2"
    Then I check that the user profile as change to "user2"
    #And I recived an email with the subject "Your LifeWorks profile has been edited by the network administrator"
    
    When I change the user profile to "user1"
    Then I check that the user profile as change to "user1"
    #And I recived an email with the subject "Your LifeWorks profile has been edited by the network administrator"
    And I logout from Admin Panel

@Z7.2 @Z-UserProfile @Web @Zeus @headless_zeus @Smoke @Regression @Production_Smoke @Bug 
Scenario: Deactivate and reactivate user
# Email is not being sent to the user RA-6770
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    
    Given I am on the Dashboard
    Then I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu
    
    Given I am on the Employees screen
    When I click on "Active colleagues" from Employees screen
    Then I open the user profile I would like to deactivate

    Given I am on the User Profile screen
    When I "deactivate" a user
    Then I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu
    And I recived an email with the subject "your_account_has_been_deactivated"

    When I am on the Web App Login screen
    Then I try to login with the deactivate account and I expect to "failure"
    And I get back to Admin Panel

    Given I am on the Dashboard
    Then I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu
    Then I click on "Archived" from Employees screen
    And I open the user profile I would like to deactivate
    And I "reactivate" a user
    And I recived an email with the subject "your_account_has_been_reactivated"

    Given I am on the Web App Login screen
    Then I try to login with the deactivate account and I expect to "success"
    Then I get back to Admin Panel
    And I logout from Admin Panel

@Z7.3 @Z-UserProfile @Web @Zeus @headless_zeus
Scenario: Validate total amount of recognition that the user received for the current month
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    
    Given I am on the Dashboard
    Then I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu
    
    Given I am on the Employees screen
    When I click on "Active colleagues" from Employees screen
    Then I open user profile name "user1 user1"

    Given I am on the User Profile screen
    When I click on "Performance" from User Profile screen
    Then I change months to option index "1"
    And I validate total amount of recognition that the user received
    And I logout from Admin Panel

@Z7.4 @Z-UserProfile @Web @Zeus @headless_zeus
Scenario: Validate total amount of recognition that the user sent for the current month
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    
    Given I am on the Dashboard
    Then I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu
    
    Given I am on the Employees screen
    When I click on "Active colleagues" from Employees screen
    Then I open user profile name "user0 user0"

    Given I am on the User Profile screen
    When I click on "Engagement" from User Profile screen
    Then I change months to option index "1"
    And I validate total amount of recognition that the user sent
    And I logout from Admin Panel

@Z7.5 @Z-UserProfile @Web @Zeus @Bug
Scenario: Validate Recognitions by value accouring total recognitions that the user received
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    
    Given I am on the Dashboard
    Then I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu
    
    Given I am on the Employees screen
    When I click on "Active colleagues" from Employees screen
    Then I open user profile name "user2 user2"

    Given I am on the User Profile screen
    When I click on "Performance" from User Profile screen
    Then I change months to option index "1"

    When I count the amount from each badge that the user used
    Then I click on "Achievements" from User Profile screen
    Then I change months to option index "1"
    And I match both total amount of the badges that the user used
    And I logout from Admin Panel

@Z7.6 @Z-UserProfile @Web @Zeus @headless_zeus
Scenario: Validate Milestones accouring total recognitions that the user received
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    
    Given I am on the Dashboard
    Then I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu
    
    Given I am on the Employees screen
    When I click on "Active colleagues" from Employees screen
    Then I open user profile name "user1 user1"

    Given I am on the User Profile screen
    When I click on "Achievements" from User Profile screen
    Then I validate Milestones
    And I logout from Admin Panel
    
@Z7.7 @Z-UserProfile @Web @Zeus @headless_zeus @Bug
Scenario: Validate Performance and Engagment for each month
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel

    Given I am on the Dashboard
    Then I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu
    
    Given I am on the Employees screen
    When I click on "Active colleagues" from Employees screen
    Then I open user profile name "user1 user1"

    Given I am on the User Profile screen
    When I click on "Performance" from User Profile screen
    And I validate Performance and Engagment for each month
    And I logout from Admin Panel