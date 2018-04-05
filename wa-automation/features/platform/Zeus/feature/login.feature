Feature: 
    1. Reset password without/invalid/valid email
    2. Login with unvalid format of email and password
    3. Login 5 times with incorrect password until the account is locked
    4. Login with valid email and password and check empty state for new company
    5. Login with valid email and password

@Z1.1 @Z-Login @Web @Zeus @NotParallel @RA-9611 @Bug
Scenario: Reset password without/invalid/valid email
    Given I am on the Admin Panel Login screen
    When I reset my password with valid and invalid email
    Then I recived an email with the subject "your_forgotten_password_request"
    And I reset password to "new_password"
    And I recived an email with the subject "password_change_confirmation"

    When I login to Admin Panel using the "new_password"
    Then I am login to Admin Panel
    And I logout from Admin Panel 

    Given I am on the Admin Panel Login screen
    When I reset my password with valid and invalid email
    Then I recived an email with the subject "your_forgotten_password_request"
    And I reset password to "old_password"
    And I recived an email with the subject "password_change_confirmation"
   
    When I login to Admin Panel using the "old_password"
    Then I am login to Admin Panel
    And I logout from Admin Panel
 
@Z1.2 @Z-Login @Web @Zeus @headless_zeus
Scenario: Login with unvalid format of email and password to Admin Panel
    Given I am on the Admin Panel Login screen
    Then I try to login with unvalid format of email and password to Admin Panel

@Z1.3 @Web @Bug
Scenario: Login 5 times with incorrect password until the account is locked
    Given I am on the Admin Panel Login screen
    When I try to login 5 times to Admin panel with incorrect password until the account is locked
    
    When I login after 11 minutes
    Then I am login to Admin Panel
    And I logout from Admin Panel

@Z1.4 @Z-Login @Web @Zeus @headless_zeus @Smoke @Regression @Production_Smoke
Scenario: Login with valid email and password and check empty state for new company
    Given I am on Arch Login screen
    When I login to Arch
    Then I click on "Companies" from Left menu

    Given I am on Companies screen
    When I create new company using "ActionRequired"
    Then I change account state to active for the "new company"
    
    Given I click "Features" from Companies screen
    When I "enable" "all" features in Arch
    Then I validate empty states in the Admin Panel
    And I validate that all sections are visible in the Admin Panel
    And I logout from Admin Panel

@Z1.5 @Z-Login @Web @Zeus @headless_zeus @Bug
#Validates a company empty state
Scenario: Login with valid email and password
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I am on the Dashboard
    And I validate empty states in the Admin Panel
    And I validate that all sections are visible in the Admin Panel
    And I logout from Admin Panel

