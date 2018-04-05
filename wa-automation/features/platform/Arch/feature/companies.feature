Feature:	
	1. Validate company profile with copmany profile in Admin Panel
	2. Disable all settings one by one and validate change in the Dashboard
	3. Enabled all settings one by one and validate change in the Dashboard
	3. Enabled all settings one by one and validate change in the Dashboard (headeless version)
	4. Validate company snapshot with copmany profile in Admin Panel
	5. Create new company and make sure that the user can log into Admin Panel and Web App
	6. Add/Remove new badge and validate badge exists or not on Admin Panel and Web App
	7. Add user to company using the Email CSV upload and then remove the user from Pending list
	8. Add user to company using the ID CSV upload and then remove the user from Pending list
	9. Add user to company using the Email CSV upload and then remove the user using the Email CSV upload 
	10. Add reward to company
	11. Manual credit user by Arch

@A1.1 @A-Companies @Web @Arch @headless_arch @Smoke @Regression
Scenario: Validate company profile with copmany profile in Admin Panel
	Given I am on Arch Login screen
	When I login to Arch
	Then I click on "Companies" from Left menu
	Given I am on Companies screen
	When I open the current user company
	Then I match company details with company profile on Admin Panel
	And I logout from Admin Panel

@A1.2 @A-Companies @Web @Arch @headless_arch
Scenario Outline: Disable all settings one by one and validate change in the Dashboard
	Given I am on Arch Login screen
	When I login to Arch
	Then I click on "Companies" from Left menu
	Given I am on Companies screen
	When I open the current user company
	Then I set the "<feature>" feature key to "<is_enabled>"
    And I logout from Arch   
    And I validate that "<feature>" is "<is_enabled>" in the web app

    Examples:
    |feature             |is_enabled| 
    |Social Recognition  |false     |
    |Colleague Directory |false     |
    |News feed           |false     |

@A1.3 @A-Companies @Web @Arch
Scenario Outline: Enabled all settings one by one and validate changes in the Dashboard
	Given I am on Arch Login screen
	When I login to Arch
	Then I click on "Companies" from Left menu
	Given I am on Companies screen
	When I open the current user company
	Then I set the "<feature>" feature key to "<is_enabled>"
    And I logout from Arch   
    And I validate that "<feature>" is "<is_enabled>" in the web app

    Examples:
    |feature             |is_enabled| 
    |News feed           |true      |
    |Colleague Directory |true      |
    |Social Recognition  |true      |




# @A1.3.1 @A-Companies @Web @Arch @headless_arch
# Scenario: Enabled all settings one by one and validate changes in the Dashboard
	
#     Given I am on Arch Login screen
#     When I login to Arch
#     Then I click on "Companies" from Left menu
#     Given I am on Companies screen
#     When I open the current user company
#     Then I "disabled" "Colleague Directory"
#     And I logout from Arch   
#     And I validate that "disabled" features are "not visible" on the Web App
    
#     Given I am on Arch Login screen
# 	When I login to Arch
# 	Then I click on "Companies" from Left menu
# 	Given I am on Companies screen
# 	When I open the current user company
# 	Then I "enabled" "Colleague Directory"
#     And I logout from Arch   
#     And I validate that "disabled" features are "not visible" on the Web App

#     Given I am on Arch Login screen
#     When I login to Arch
#     Then I click on "Companies" from Left menu
#     Given I am on Companies screen
#     When I open the current user company
#     Then I "enabled" "Company Feed"
#     And I logout from Arch   
#     And I validate that "disabled" features are "not visible" on the Web App
    
#     Given I am on Arch Login screen
#     When I login to Arch
#     Then I click on "Companies" from Left menu
#     Given I am on Companies screen
#     When I open the current user company
#     Then I "enabled" "Social Recognition"
#     And I logout from Arch   
#     And I validate that "disabled" features are "not visible" on the Web App

@A1.4 @A-Companies @Web @Arch @headless_arch
Scenario: Validate company snapshot with company profile in Admin Panel
	Given I am on Arch Login screen
	When I login to Arch
	Then I click on "Companies" from Left menu
	Given I am on Companies screen
	When I open the current user company
	Then I match company snapshot with company snapshot on Admin Panel
	And I logout from Admin Panel

@A1.5 @A-Companies @Web @Arch @Bug @Smoke @Regression
Scenario: Create new company and make sure that the user can log into Admin Panel and Web App
	Given I am on Arch Login screen
	When I login to Arch
	Then I click on "Companies" from Left menu
	Given I am on Companies screen
	When I create new company using "ActionRequired"
	And I change account state to active for the "new company"
	And I click "Features" from Companies screen
	And I "enable" "all" features in Arch
	Then I validate that the new user can login to admin panel and web app

@A1.6 @A-Companies @Web @Arch @headless_arch
Scenario: Add/Remove new badge and validate badge exists or not on Admin Panel and Web App 
	Given I am on Arch Login screen
	When I login to Arch
	Then I click on "Companies" from Left menu
	Given I am on Companies screen
	When I open the current user company
	Then I add new badge
	And I validate that the new badge is "exists" in "Admin Panel"
	And I validate that the new badge is "exists" in "Web App"

	When I return to Arch
	Then I click on "Companies" from Left menu
	Given I am on Companies screen
	When I open the current user company
	Then I remove the new badge
	And I validate that the new badge is "not exists" in "Admin Panel"
	And I validate that the new badge is "not exists" in "Web App"

@A1.7 @A-Companies @Web @Arch
Scenario Outline: Add user to company using the Email CSV upload and then remove the user from Pending list
	Given I am on Arch Login screen
	When I login to Arch
	Then I click on "Companies" from Left menu
	Given I am on Companies screen
	When I open the current user company
	Then I add "<number_of_users>" new users using "email" csv upload

	Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu

    Given I am on the Employees screen
   	When I check if the <number_of_users> uploaded "email" csv users are in Pending list
    
    Then I delete all users in Pending
	And I logout from Admin Panel

	Examples:
		|number_of_users|
		|      3        |

@A1.8 @A-Companies @Web @Arch 
Scenario Outline: Add user to company using the ID CSV upload and then remove the user from Pending list
	Given I am on Arch Login screen
	When I login to Arch
	Then I click on "Companies" from Left menu
	Given I am on Companies screen
	When I open the current user company
	Then I add "<number_of_users>" new users using "id" csv upload

	Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu

    Given I am on the Employees screen
    When I click on "Pending" from Employees screen
    When I check if the <number_of_users> uploaded "id" csv users are in Pending list


    Then I delete all users in Pending
	And I logout from Admin Panel

	Examples:
		|number_of_users|
		|      3        |

@A1.9 @A-Companies @Web @Arch
Scenario: Add user to company using the Email CSV upload and then remove the user using the Email CSV upload 
	Given I am on Arch Login screen
	When I login to Arch
	Then I click on "Companies" from Left menu
	Given I am on Companies screen
	When I open the current user company
	Then I add "1" new users using "email" csv upload
	And I logout from Arch

	Given I am on the Web App Login screen
    When I click "Signup" from the Web App Login screen
    Then I sign up to the Web App using "Personal Code" with a "matching" company email domain

	Given I am on Arch Login screen
	When I login to Arch
	Then I click on "Companies" from Left menu
	Given I am on Companies screen
	When I open the current user company
	Then I remove "1" new users using "email" csv upload
	And I logout from Arch

@A1.10 @A-Companies @Web @Arch @headless_arch
Scenario: Add reward to company
	Given I am on Arch Login screen
	When I login to Arch
	Then I click on "Companies" from Left menu
	Given I am on Companies screen
	When I open the current user company
	Then I click "Spot Rewarding" from Companies screen
	And I "Add" "10" pounds as reward to this company


@A1.11 @A-Companies @Web @Arch @headless_arch
Scenario Outline: Manual credit user by Arch
	Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen

	Given I am on Arch Login screen
	When I login to Arch
	Then I click on "Companies" from Left menu
	Given I am on Companies screen
	When I open the current user company
	Then I select user "<user>"
	Then I credit the user "<amount>" "<currency_name>"
	And I logout from Arch

	Given I get back to wallet
	And I validate that "<amount>" "<currency_name>" are in available to withdraw

    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" by Arch user
    And I click "Logout" from the "Global Action" menu

    #TODO: to remove currency_name
    Examples:
    |user       |amount|currency_name|
    |user0 user0|10    |GPB			 |