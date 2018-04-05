Feature:
    1. Generate new invitation code
    2. Upload and delete images and logos using different image formats

@Z9.1 @Z-Settings @Web @Zeus @headless_zeus @Production_Smoke @CI_Pass
Scenario: Generate new invitation code
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel

    Given I am on the Dashboard
    When I click on "Menu" from Top Bar menu
    Then I click on "Settings" from Top Bar menu
    
    Given I am on the Admin Panel Settings screen
    When I click on "Invitations" from the Settings screen
    Then I generate new invitation code 

@Z9.2 @Z-Settings @Web @Zeus @headless_zeus @Production_Smoke @CI_Pass
Scenario: Upload and delete images and logos using different image formats
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel

    Given I am on the Dashboard
    When I click on "Menu" from Top Bar menu
    Then I click on "Settings" from Top Bar menu
    
    Given I am on the Admin Panel Settings screen
    When I click on "Appearance" from the Settings screen
    Then I validate that I can upload and delete all available images
    And I logout from Admin Panel

    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I verify that the correct images are displayed for my locale
    
    