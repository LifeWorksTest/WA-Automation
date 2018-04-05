Feature:
    1. Sign up to LifeWorks and check that all validators are working
    2. Signup as Santander company -> Arch user approve change company state to active -> admin upgrade account to premium
    3. Self signup for LifeWorks -> Arch user approve change company state to active -> admin upgrade account to premium

@Z0.1 @Z-SignUp @Web @Zeus @Bug
Scenario: Sign up to LifeWorks and check that all validators are working
    Given I am on the Admin Panel Sign Up screen
    When I insert all my details "with" promotional code
    Then I recived an email with the subject "welcome_to_lifeworks"
    And I varify the new Admin Panel account
    And I logout from Admin Panel

@Z0.2 @Z-SignUp @Web @Zeus @Bug
Scenario: Signup as Santander company -> Arch user approve change company state to active -> admin upgrade account to premium
    Given I am on the "Santander" lending screen
    When I click on "SIGN UP FOR FREE" from the lending screen
    Then I signup new "Santander" company
    And the Arch user change the new company state to Active
    
    Given I am on the new company Web App Login screen
    When I login to the Web App with the latest new "admin" account
    And I click "Logout" from the "Global Action" menu

    Given I am on the Admin Panel Login screen
    When I login with the new "Santander" company account
    Then I am login to Admin Panel
    And I upgrade the company account to premium
    And I logout from Admin Panel

@Z0.3 @Z-SignUp @Web @Zeus @Bug
Scenario: Self signup for LifeWorks -> Arch user approve change company state to active -> admin upgrade account to premium
    Given I am on the Zeus sales screen
    When I click on "SIGN UP FOR FREE" from the Zeus sales screen
    When I signup for the 3 months trail
    Then the Arch user change the new company state to Active

    Given I am on the new company Web App Login screen
    When I login to the Web App with the latest new "admin" account
    And I click "Logout" from the "Global Action" menu

    Given I am on the Admin Panel Login screen
    When I login with the new "Self Signup" company account
    Then I am login to Admin Panel
    And I upgrade the company account to premium
    And I logout from Admin Panel