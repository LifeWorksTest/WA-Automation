Feature:
    1. Search for users and check search results
    2. Check that all tabs have the right amount of rows
    3. Invite a user and then send reminder to user and check that the mail was sent
    4. Delete user from Pending list on View Colleagues page
    5. Restore user from Archived list on View Colleagues page
    6. Delete user from Archived list on View Colleagues page
    7. Check link from employees list to user profile
    8. User with an email address that does not match the company domain signd up using Company Code and Admin approves the request
    9. User with an email address that does not match the company domain signd up using Company Code and Admin rejects the request
    10. User with an email address that matches the company domain signs up using Company Code and is auto approved
    11. Add/Remove user to/from Admin list from Employee profile screen
    12. Go over colleagues list and Approve/Reject/Remind/Delete/Reactivate accourding to the given list

@Z3.1 @Z-Employees @Web @Zeus @headless_zeus @Smoke @Regression @Production_Smoke @NotParallel @CI_Pass
Scenario: Search for users and check search results
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu

    Given I am on the Employees screen
    When I click on "Active colleagues" from Employees screen
    Then I search for "a" from Employees screen
    And I validate the results for "a" and I expect to see results "True"

    When I search for "NoValid" from Employees screen
    Then I validate the results for "NoValid" and I expect to see results "False"
    And I logout from Admin Panel

@Z3.2 @Z-Employees @Web @Zeus @headless_zeus @CI_Pass
Scenario: Check that all tabs have the right amount of rows
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu

    Given I am on the Employees screen
    Then I validate all tabs
    And I logout from Admin Panel

@Z3.3 @Z-Employees @Web @Zeus
Scenario: Invite a user and then send reminder to user and check that the mail was sent
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu

    Given I am on the Employees screen
    When I invite friend from the Colleague page
    Then I recived an email with the subject "join"  
    And I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu
    
    Given I "Remind" the latest user to sign up in Pending
    When I recived an email with the subject "you_havent_signed_up_to_lifeworks_yet"    
    Then I logout from Admin Panel

@Z3.4 @Z-Employees @Web @Zeus @headless_zeus
Scenario: Delete user from Pending list on View Colleagues page
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu

    Given I am on the Employees screen
    When I invite friend from the Colleague page
    Then I recived an email with the subject "join"  
    And I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu

    Given I am on the Employees screen
    When I "Delete" the latest user to sign up in Pending
    Then I logout from Admin Panel

@Z3.5 @Z-Employees @Web @Zeus @headless_zeus
Scenario: Restore user from Archived list on View Colleagues page
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel

    Given I am on the Dashboard
    When I click on "Menu" from Top Bar menu
    Then I click on "Settings" from Top Bar menu
    
    Given I am on the Admin Panel Settings screen
    When I click on "Invitations" from the Settings screen
    Then I generate new invitation code 
    And I logout from Admin Panel

    Given I am on the Web App Login screen
    When I click "Signup" from the Web App Login screen
    Then I sign up to the Web App using "Company Code" with a "matching" company email domain

    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu

    Given I am on the Employees screen
    When I click on "Active colleagues" from Employees screen
    Then I open user profile name "last user that join"

    Given I am on the User Profile screen
    When I "deactivate" a user
    Then I recived an email with the subject "your_account_has_been_deactivated"
    And I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu
    
    Given I "Restore" the latest user to sign up in Archived
    And I recived an email with the subject "your_account_has_been_reactivated"
    When I validate all tabs
    Then I logout from Admin Panel

@Z3.6 @Z-Employees @Web @Zeus @headless_zeus
Scenario: Delete user from Archived list on View Colleagues page
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel

    Given I am on the Dashboard
    When I click on "Menu" from Top Bar menu
    Then I click on "Settings" from Top Bar menu
    
    Given I am on the Admin Panel Settings screen
    When I click on "Invitations" from the Settings screen
    Then I generate new invitation code 
    And I logout from Admin Panel

    Given I am on the Web App Login screen
    When I click "Signup" from the Web App Login screen
    Then I sign up to the Web App using "Company Code" with a "matching" company email domain

    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu

    Given I am on the Employees screen
    When I click on "Active colleagues" from Employees screen
    Then I open user profile name "last user that join"

    Given I am on the User Profile screen
    When I "deactivate" a user
    Then I recived an email with the subject "your_account_has_been_deactivated"
    And I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu

    Given I am on the Employees screen
    When I "Delete" the latest user to sign up in Archived
    Then I validate all tabs
    And I logout from Admin Panel

@Z3.7 @Z-Employees @Web @Zeus @headless_zeus @CI_Pass
Scenario: Check link from employees list to user profile
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu

    Given I am on the Employees screen
    And I click on "Active colleagues" from Employees screen
    When I check the link to each employee
    Then I logout from Admin Panel

@Z3.8 @Z-Employees @Web @Zeus @Smoke @Regression @NotParallel @CI_Pass
Scenario: User with an email address that does not match the company domain signs up using Company Code and Admin approves the request
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel

    Given I am on the Dashboard
    When I click on "Menu" from Top Bar menu
    Then I click on "Settings" from Top Bar menu
    
    Given I am on the Admin Panel Settings screen
    When I click on "Invitations" from the Settings screen
    Then I generate new invitation code 
    And I logout from Admin Panel

    Given I am on the Web App Login screen
    When I click "Signup" from the Web App Login screen
    Then I sign up to the Web App using "Company Code" with a "non matching" company email domain

    Given I am on the Admin Panel Login screen
    And I insert valid email and password from the Admin Panel screen
    When I am login to Admin Panel
    Then I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu

    Given I am on the Employees screen
    When I click on "Awaiting approval" from Employees screen
    Then I "Approve" the latest user to sign up in Approval 
    
    Given I click on "Active colleagues" from Employees screen
    When I check that the new employee was add to Active Employees list
    Then I validate all tabs
    And I logout from Admin Panel

@Z3.9 @Z-Employees @Web @Zeus
Scenario: User with an email address that does not match the company domain signs up using Company Code and Admin rejects the request
    Given I am on the Web App Login screen
    When I click "Signup" from the Web App Login screen
    Then I sign up to the Web App using "Company Code" with a "non matching" company email domain

    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu

    Given I am on the Employees screen
    When I click on "Awaiting approval" from Employees screen
    Then I "Reject" the latest user to sign up in Approval 
    And I validate all tabs
    And I logout from Admin Panel

@Z3.10 @Z-Employees @Web @Zeus
Scenario: User with an email address that matches the company domain signs up using Company Code and is auto approved
    Given I am on the Web App Login screen
    When I click "Signup" from the Web App Login screen
    Then I sign up to the Web App using "Company Code" with a "matching" company email domain
    And I recived an email with the subject "please_verify_your_email_address"

    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu

    Given I am on the Employees screen
    And I click on "Active colleagues" from Employees screen
    When I check that the new employee was add to Active Employees list
    Then I validate all tabs
    And I logout from Admin Panel
        
@Z3.11 @Z-Employees @Web @Zeus @headless_zeus
Scenario: Add/Remove user to/from Admin list from Employee profile screen
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu
    
    Given I am on the Employees screen
    When I click on "Active colleagues" from Employees screen
    Then I open the user profile the make as an Admin
    And I am on the User Profile screen 
    And I "add" an existing user as Admin from Employee Profile screen
    And I logout from Admin Panel
    And I check that the new Admin "can" login as "Admin"
    And I logout from Admin Panel

    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu

    Given I am on the Employees screen
    When I click on "Active colleagues" from Employees screen
    Then I open the user profile the make as an Admin
    And I am on the User Profile screen 
    And I "remove" an existing user as Admin from Employee Profile screen
    And I logout from Admin Panel
    And I check that the new Admin "cant" login as "Admin"

@Z3.12 TO_DO
Scenario: Go over colleagues list and Approve/Reject/Remind/Delete/Reactivate accourding to the given list
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu
    
    Given I am on the Employees screen
    When I click on "Pending" from Employees screen
    Then I "Delete" all users accourding to the list
    And I logout from Admin Panel
        

