Feature: 
    1. Click forgot password and then cancel
    2. Click forgot password and then insert valid and invalid email
    3. Insert valid email and invalid password and then valid password 
    4. Login attempts with deactivated account, deactivated company and unavailable network
    5. Login with valid email and password
    6. Signup to LifeWorks using "Company Code"
    7. Signup to LifeWorks with "Personal Code"

@I1.1 @I-Login @iOS
Scenario: Click forgot password and then cancel
    Given I am on the iOS Get Started screen 
    Then I click from the iOS Get Started screen "Log in"

    Given I am on the iOS Login screen
    When I insert valid email
    Then I click from the iOS Login screen "Forgotten your password"  
    Then I click from the iOS Login screen "Cancel"

@I1.2 @I-Login @iOS
Scenario: Click forgot password and then insert valid and invalid email
    Given I am on the iOS Get Started screen 
    Then I click from the iOS Get Started screen "Log in"
    
    Given I am on the iOS Login screen
    When I insert valid email
    Then I click from the iOS Login screen "Forgotten your password"
    And I insert "valid" email

@I1.3 @I-Login @iOS
Scenario: Insert valid email and invalid password and then valid password 
    Given I am on the iOS Get Started screen 
    Then I click from the iOS Get Started screen "Log in"
    
    Given I am on the iOS Login screen
    When I try to login with invalid password
    Then I change to valid password
    Then I see the iOS Menu Tab
    And I logout from the iOS app

@I1.4 @Bug
Scenario: Login attempts with deactivated account, deactivated company and unavailable network
    Given I am on the iOS Get Started screen 
    Then I click from the iOS Get Started screen "Log in"
    Given I am on the iOS Login screen
    Then I insert details of user that was deactivated

    Given I am on the iOS Get Started screen 
    Then I click from the iOS Get Started screen "Log in"
    Given I am on the iOS Login screen
    Then I insert details of user deactivated company 

    Given I am on the iOS Get Started screen 
    Then I click from the iOS Get Started screen "Log in"
    Given I am on the iOS Login screen
    Then I insert details of unavailable network

@I1.5 
Scenario: Login with valid email and password
    Given I am on the iOS Get Started screen 
    Then I click from the iOS Get Started screen "Log in"
    
    Given I am on the iOS Login screen
    When I insert valid credential
    Then I see the iOS Menu Tab
    And I logout from the iOS app

@I1.6 @I-Login @iOS @Web @Smoke @Regression
Scenario: Signup to LifeWorks using "Company Code"
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel

    Given I am on the Dashboard
    When I click on "Menu" from Top Bar menu
    Then I click on "Settings" from Top Bar menu
    
    Given I am on the Admin Panel Settings screen
    When I click on "Invitations" from the Settings screen
    Then I generate new invitation code 

    Given I am on the iOS Get Started screen
    When I click from the iOS Get Started screen "Sign up"
    Then I insert "Company Code" invitation code from the iOS app
    And I click from the iOS Get Started screen "Join"

    Given I am on the iOS Signup screen
    When I enter all my details from the iOS app
    And I click from the iOS Get Started screen "Skip"
    Then I click from the iOS Get Started screen "Skip for now"
    And I logout from the iOS app

@I1.7 @I-Login @iOS @Web @Bug @Smoke @Regression @Bug
Scenario: Signup to LifeWorks with "Personal Code"
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel

    Given I am on the Dashboard
    When I invite friend
    
    Given I am on the iOS Get Started screen
    When I click from the iOS Get Started screen "Enter invitation code"
    Then I insert "Personal Code" invitation code from the iOS app
    And I click from the iOS Get Started screen "Join"

    Given I am on the iOS Signup screen
    When I enter all my details from the iOS app
    And I click from the iOS Get Started screen "Skip"
    Then I click from the iOS Get Started screen "Skip for now"
    And I logout from the iOS app