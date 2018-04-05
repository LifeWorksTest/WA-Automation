Feature:
    1. Set user language from the settings screen
    2. Successfully change password on Settings screen
    3. Try to change password when  a) - Passwords do not match b) Passwords match but current password field is incorrect

@H14.1 @H-Settings @Web @Hermes @headless_hermes @Production_Smoke @Not_US @Not_UK @NotParallel @Bug
Scenario Outline: Change user profile and check the results
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Settings" from the "Global Action" menu
    
    Given I am on Web App Settings screen
    When I change the user language settings to "<language_1>"
    Then I change the user language settings to "<language_2>"
    
    Examples:
      |language_1   |language_2|
      |English (CA) |French (CA)|


@H14.2 @H-Settings @Web @Smoke @NotParallel
Scenario Outline: Successfully change password on Settings screen
    Given I am on the Web App Login screen
    When I log into the Web App as a valid "<user_type>" user
    Then I click "Settings" from the "Global Action" menu
    
    Given I am on Web App Settings screen
    And I click "Change password" from the Settings Screen
    When I change password to "new_password" and both password fields "<passwords_match>" and the current password is "<current_password_correct>"
    And I recived an email with the subject "password_change_confirmation"
    Then I click "Logout" from the "Global Action" menu

    Given I am on the Web App Login screen
    When I insert valid email and the new password
    Then I am login to Web App
    And I click "Settings" from the "Global Action" menu
    
    Given I am on Web App Settings screen
    And I click "Change password" from the Settings Screen
    When I change password to "old_password" and both password fields "<passwords_match>" and the current password is "<current_password_correct>"
    And I recived an email with the subject "password_change_confirmation"
    Then I click "Logout" from the "Global Action" menu

    Given I am on the Web App Login screen
    When I log into the Web App as a valid "<user_type>" user
    Then I click "Settings" from the "Global Action" menu
    And I click "Logout" from the "Global Action" menu 
    Examples:
    |user_type|passwords_match|current_password_correct|
    |personal |true           |true                    |
    |limited  |true           |true                    |

@H14.3 @H-Settings @Web
Scenario Outline: Try to change password when  a) - Passwords do not match b) Passwords match but current password field is incorrect
    Given I am on the Web App Login screen
    When I log into the Web App as a valid "personal" user
    Then I click "Settings" from the "Global Action" menu
    
    Given I am on Web App Settings screen
    And I click "Change password" from the Settings Screen
    When I change password to "new_password" and both password fields "<passwords_match>" and the current password is "<current_password_correct>"
    Then I click "Logout" from the "Global Action" menu
    Examples:
    |passwords_match|current_password_correct|
    |false          |true                    |
    |true           |false                   |



