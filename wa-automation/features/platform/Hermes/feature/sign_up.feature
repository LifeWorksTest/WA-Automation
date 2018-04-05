Feature:
    1. Sign up using company code
    2. Sign up to Work Angel with x amount of users using company code
    3. Sign up employess to Work Angel using csv file
    4. Create new company with new users, recognitions and transactions
    5. Signup as Capita Company (Can not run on Integration)
    6. Signup as Capita Company (For Integration and Staging, but can run on all environmant)
    7. Capita user -> Create transaction -> Approved cashback -> Approved withdrew 
    8. Create a new shared account user -> Loginto Web App -> Delete Shared Account user -> Try to login with deleted shared account user
    9. Create a new limited account user -> Log into Web App with limited account user -> Log out of Web App

@H0.1 @H-SignUp @Web @Hermes @headless_hermes @Regression @Production_Smoke @Smoke @NotParallel @CI_Pass
Scenario: Sign up using "Company Code"
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
    And I recived an email with the subject "please_verify_your_email_address"

@H0.2 @H-SignUp @Web @Hermes @headless_hermes @NotParallel @CI_Pass
Scenario: Sign up to work angel with x amount of users using company code
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

    Given I sign up "10" new users

@H0.3 
Scenario: Sign up employess to LifeWorks using csv file (for this scenario you need to have a CSV file with the next data: first name,last name,job title,email,password)
	Given I sign up users to LifeWorks using csv file

@H0.4 @Web @Hermes @headless_hermes @NotParallel @Bug
Scenario: Create new company with new users and recognitions 
    
    Given I am on Arch Login screen
    And I login to Arch
    And I click on "Companies" from Left menu
    And I am on Companies screen
    When I create new company using "ActionRequired"
    And I change account state to active for the "new company"
    Then I click "Features" from Companies screen
    Given I "enable" "all" features in Arch

    Given I am on the Admin Panel Login screen
    When I login with the new company account
    Then I am login to Admin Panel

    Given I am on the Dashboard
    When I send this post from dashboard "Welcome to the company" for "10" times

    When I click on "Menu" from Top Bar menu
    Then I click on "Settings" from Top Bar menu
    
    Given I am on the Admin Panel Settings screen
    When I click on "Invitations" from the Settings screen
    Then I generate new invitation code
    And I logout from Admin Panel

    Given I am on the new company Web App Login screen
    Given I sign up "5" new users

    Given I am on the Admin Panel Login screen
    When I login with the new company account
    Then I am login to Admin Panel
    And I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu

    Given I am on the Employees screen
    When I click on "Awaiting approval" from Employees screen
    Then I click on "Approve all" from Employees screen
    And I logout from Admin Panel

    Given I am on the new company Web App Login screen
    And I login to the Web App with the latest new "user" account
    When I give this recognition "Good work!!" badge "Creative" to "user0" "10" times
    Then I write mention post "This is mention post" and I mention "user" "10" times
    And I click "Logout" from the "Global Action" menu

    Given I am on the new company Web App Login screen
    And I login to the Web App with the latest new "user" account
    When I give this recognition "Good work!!" badge "Creative" to "user0" "10" times
    Then I write mention post "This is mention post" and I mention "user" "10" times
    And I click "Logout" from the "Global Action" menu

    Given I am on the new company Web App Login screen
    When I login to the Web App with the latest new "admin" account
    Then I click "Like" on this post

    #When I make "2" purchase in Shop Online
    # TODO: Add manual credit
    Then I click "Logout" from the "Global Action" menu

@H0.5 @H-SignUp @Web @Hermes @Bug
Scenario: Signup as Capita Company (Can not run on Integration)
    Given I create new Capita Company
    And I delete the new Capita user
    When the Arch user change the new company state to Active
    Then I add a new Capita user index "1" to this Capita new company
    And I login to LifeWorks with this new Capita Company
    And I am on the News Feed screen
    
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I make a transaction using "incentive networks" for "100" pounds and I get "20" pounds cashback and I "expect" to double cashback
    When I ask for cashback
    Then I click "Logout" from the "Global Action" menu
    And I delete the new Capita user

@H0.6 @H-SignUp @Bug
Scenario: Signup as Capita Company (For Integration and Staging, but can run on all environmant)      
    Given I create new Capita Company
    When the Arch user change the new company state to Active
    Then I add a new Capita user index "1" to this Capita new company
    And I login to LifeWorks with this new Capita Company
    And I am on the News Feed screen
    And I click "Logout" from the "Global Action" menu
    And I delete the new Capita user

@H0.7 @H-SignUp @Bug
Scenario: (incentive_networks) Capita user -> Create transaction -> Approved cashback -> Approved withdrew 
    And I login to LifeWorks with the latest Capita user
    And I am on the News Feed screen
    
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I make a transaction using "incentive networks" for "100" pounds and I get "20" pounds cashback and I "expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to the "Paypal" account using the Web App
    And the withdrew request was "approve" by Arch user
    And I click "Logout" from the "Global Action" menu

@H0.8 @H-SignUp @Web @Hermes
Scenario: Create a new shared account user -> Loginto Web App -> Delete Shared Account user -> Try to login with deleted shared account user
    Given I "add" the new shared account user in Arch
    And I logout from Arch   
    
    Given I am on the Web App Login screen
    And I login to the Web App with the latest new "shared" account
    Then I click "Logout" from the "Global Action" menu
    And I "delete" the new shared account user in Arch
    And I logout from Arch  
    
    Given I am on the Web App Login screen
    And I validate that I can not log in as with the latest deleted user

@H0.9 @H-SignUp @Web @Hermes @Smoke @NotParallel
Scenario: Create a new limited account user -> Log into Web App with limited account user -> Log out of Web App
    Given I create a new limited account user and login to the Web App
    When I am on the News Feed screen
    Then I click "Logout" from the "Global Action" menu

@H0.10 @H-SignUp @Web @Hermes
Scenario: Upgrade a limited user to Personal user
    Given I create a new limited account user and login to the Web App
    When I am on the News Feed screen
    Then I click "Logout" from the "Global Action" menu

    Given I upgrade the latest Limited account user to Personal 
    When I am on the Web App Login screen
    Then I login to the Web App with the latest new "upgraded personal" account

@H0.11 @H-SignUp @Web @Hermes
Scenario: Invite a dependant user -> Sign up a new dependant user -> Log in as the dependant user -> Delete dependant user -> verify dependant user cant login
    Given I set the dependant account invite limit for the "current company" to "5" in Arch 
    When I create a new dependant account user and login to the Web App
    Then I click "Logout" from the "Global Action" menu
    
    Given I am on the Web App Login screen
    When I login to the Web App with the latest new "dependant" account
    Then I click "Logout" from the "Global Action" menu

    Given I am on the Web App Login screen
    And I insert valid email and password
    And I am login to Web App
    And I click "Profile" from the "Global Action" menu
    When I am on Web App User Profile screen
    And I click "Family" from User Profile screen
    Then I verify that the latest dependant user has a status of Active
    And I remove "all" family members from the company
    And I click "Logout" from the "Global Action" menu
    
    Given I am on the Web App Login screen
    Then I validate that I can not log in as with the latest deleted user

