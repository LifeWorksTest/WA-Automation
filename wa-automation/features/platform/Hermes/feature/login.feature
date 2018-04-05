Feature: 
    1. Reset password without/invalid/valid email and check validators
    2. Reset password to the old password (this is useful in case of a faliure of @W1.1)
    3. Login with unvalid format of email and password and check validators
    4. Login with valid email and password and validate all sections are visible
    5. Create New company with only Newsfeed or Life enabled. Login and verify user is taken to correct page on login and correct feature are enabled/disabled
    6. Login with valid email and password and then logout
    7. Click forgot password and then go back to login page (check that the routing work well)

@H1.1 @H-Login @Web @Hermes @headless_hermes @RequireEmailValidation @NotParallel @Bug
Scenario: Reset password without/invalid/valid email and check validators
    Given I am on the Web App Login screen
    When I reset my password with valid email using the configuration file and invalid email
    Then I recived an email with the subject "your_forgotten_password_request"
    And I reset Web App password to "new_password"
    And I recived an email with the subject "password_change_confirmation"

    When I insert valid email and the new password
    Then I am login to Web App
    And I click "Logout" from the "Global Action" menu

    Given I am on the Web App Login screen
    When I reset my password with valid email using the configuration file and invalid email
    Then I recived an email with the subject "your_forgotten_password_request"
    And I reset Web App password to "old_password"
    And I recived an email with the subject "password_change_confirmation"

    When I insert valid email and password
    Then I am login to Web App
    And I click "Logout" from the "Global Action" menu

@H1.2 @H-Login @Web @Hermes @headless_hermes @RequireEmailValidation @NotParallel @Smoke
Scenario: Reset password to the old password (this is useful in case of a faliure of @W1.1)
    Given I am on the Web App Login screen
    When I reset my password with valid email
    Then I recived an email with the subject "your_forgotten_password_request"
    And I reset Web App password to "old_password"
    And I recived an email with the subject "password_change_confirmation"

    When I insert valid email and password
    Then I am login to Web App
    And I click "Logout" from the "Global Action" menu
            
@H1.3 @H-Login @Web @Hermes @headless_hermes @CI_Pass
Scenario: Login with unvalid format of email and password and check validators
    Given I am on the Web App Login screen
    When I try to login with unvalid format of email and password

@H1.4 @H-Login @Web @Hermes @headless_hermes @Smoke @Regression @WEB-6096
Scenario Outline: Login with valid personal user email and password and validate all sections are visible
    Given I am on the Web App Login screen
    When I log into the Web App as a valid "<user_type>" user
    Then I validate that all sections are visible in the Web App
    And I click "Logout" from the "Global Action" menu
    Examples:
    |user_type        |
    |personal         |
    |shared           |
    |limited          |
    |upgraded personal|

@H1.5 @H-Login @Web @Hermes @headless_hermes @Smoke
Scenario: Create New company with only Newsfeed or Life enabled. Login and verify user is taken to correct page on login and correct feature are enabled/disabled
    Given I am on Arch Login screen
    When I login to Arch
    Then I click on "Companies" from Left menu

    Given I am on Companies screen
    And I create new company using "ActionRequired"
    And I change account state to active for the "new company"
    When I click "Features" from Companies screen
    Given I "enable" "news feed" features in Arch
    And I logout from Arch

    Given I am on the Web App Login screen
    When I login to the Web App with the latest new "admin" account
    Then I validate that all sections are visible in the Web App
    And I click "Logout" from the "Global Action" menu

    Given I am on Arch Login screen
    And I login to Arch
    And I click on "Companies" from Left menu
    And I am on Companies screen
    When I open company "latest_created_company"
    And I click "Features" from Companies screen
    And I "disable" "all" features in Arch
    Then I "enable" "life" features in Arch
    And I logout from Arch

    Given I am on the Web App Login screen
    When I login to the Web App with the latest new "admin" account
    Then I validate that all sections are visible in the Web App
    And I click "Logout" from the "Global Action" menu

    Given I am on Arch Login screen
    And I login to Arch
    And I click on "Companies" from Left menu
    And I am on Companies screen
    When I open company "latest_created_company"
    And I click "Features" from Companies screen
    And I "disable" "all" features in Arch
    Then I "enable" "perks" features in Arch
    And I logout from Arch

    Given I am on the Web App Login screen
    When I login to the Web App with the latest new "admin" account
    Then I validate that all sections are visible in the Web App
    And I click "Logout" from the "Global Action" menu

@H1.6 @H-Login @Web @Hermes @headless_hermes @Regression @CI_Pass
Scenario: Login with valid email and password and then logout
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Logout" from the "Global Action" menu

@H1.7 @H-Login @Web @Hermes @headless_hermes
Scenario: Click forgot password and then go back to login page (check that the routing work well)
    Given I am on the Web App Login screen
    When I click "Forgotten your password?" from the Web App Login screen
    Then I click "Browser back button" from the Web App Login screen
    And I back to the Web App Login screen

