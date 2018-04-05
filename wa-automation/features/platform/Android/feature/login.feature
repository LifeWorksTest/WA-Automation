Feature:
    1. Click forgot password and then cancel
    2. Click forgot password and then insert valid and invalid Email
    3. Insert valid email and invalid password and then valid password
    4. Login attempts with deactivated account, deactivated company and unavailable network
    5. Login with valid email and password
    6. Signup to LifeWorks using "Company Code"
    7. Sign up to Work Angel using personal code

@AN1.1 @AN-Login @Android
Scenario: Click forgot password and then cancel
    Given I am on the Android Get Started screen
    Then I click from the Android Get Started screen "Login"

    Given I am on the Android Login screen
    When I insert "valid" email from the Android app
    Then I click from the Android Login screen "Continue"
    Then I click from the Android Login screen "Forgot Password"
    And I click from the Android Login screen "Cancel"
    And I click from the Android Login screen "Back"

@AN1.2 @AN-Login @Android @Bug
Scenario: Click forgot password and then insert valid and invalid Email
    Given I am on the Android Get Started screen
    Then I click from the Android Get Started screen "Login"

    Given I am on the Android Login screen
    When I insert "valid" email from the Android app
    Then I click from the Android Login screen "Continue"
    When I click from the Android Login screen "Forgot Password"
    Then I reset password with "invalid" email
    When I click from the Android Login screen "Forgot Password"
    Then I reset password with "valid" email
    And I click from the Android Login screen "Back"

@AN1.5 @AN-Login @Android
Scenario: Login and Logout (first time click No and after click Yes)
    Given I am on the Android Get Started screen
    Then I click from the Android Get Started screen "Login"

    Given I am on the Android Login screen
    When I insert valid email and password from the Android app
    Then I am on the Android Menu screen
    And I logout from the Android app

@AN1.6 @AN-Login @Web @Android @Bug
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

    Given I am on the Android Get Started screen
    When I insert "Company Code" invitation code from the Android app

    Given I am on the Android Sign up screen
    When I enter all my details in the Android app
    Then I choose my intersts from the Android app
    And I click from the Android Sign up screen "Ok! Got it!"

@AN1.7 @AN-Login @Web @Android @Bug
Scenario: Sign up to Work Angel
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel

    Given I am on the Dashboard
    When I invite friend
    And I logout from Admin Panel

    Given I am on the Android Get Started screen
    Then I insert "Personal Code" invitation code from the Android app

    Given I am on the Android Sign up screen
    When I enter all my details in the Android app
    Then I choose my intersts from the Android app
    And I am on the Android Menu screen
    And I logout from the Android app
