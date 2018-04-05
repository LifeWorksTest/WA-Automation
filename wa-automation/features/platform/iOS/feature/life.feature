Feature:	
	1. Verify that categories are displayed in the EAP page and have sub-categories linked to them
	2. Verify that one of the articls in the EAP page can be opened by following the breadcrumbs and also by search
	3. Verify Snackable functionality on the iOS app

@I15.1 @I-Life @iOS @Smoke @Regression
Scenario: Verify that categories are displayed in the EAP page and have sub-categories linked to them
    Given I login to LifeWorks from the iOS app
    Then I click "Life" from the iOS Menu Tab

	Given I am on the iOS Employee Assistance screen
	Then I validate that all the categories have sub-categories
	And I logout from the iOS app

@I15.2 @I-Life @iOS @Smoke @Regression
Scenario: Verify that one of the articls in the EAP page can be opened by following the breadcrumbs and also by search
    Given I login to LifeWorks from the iOS app
    Then I click "Life" from the iOS Menu Tab

	Given I am on the iOS Employee Assistance screen
    Then I open one of the articles by following the links
   	And I logout from the iOS app

@I15.3 @I-Life @iOS @Smoke @Regression @Web
Scenario Outline: Verify  selecting of Snackable topics from Settings of the iOS app

    Given I "<enable_feature>" wellness tools and limit the number or interests to "<max_interests>" and sessions to "<max_sessions>" from Arch    
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
    And I click from the iOS Get Started screen "Skip for now"
	Then I click "More" from the iOS Menu Tab
    Then I am on the iOS More screen
    Then I click from the iOS More screen "Settings"

    Given I navigate to iOS Snackable Topics screen
    Then I am on the iOS Snackable Topics screen
    Then I select "<max_interests>" categories and "<max_interests>" Snackable sub topics on iOS Snackable Topics screen
    #Then I go back to iOS Settings Screen from iOS User Profile screen
    And I logout from the iOS app
    
    Examples:
        |enable_feature|max_interests|max_sessions|
        |true          |4            |4           |


@I15.4 @I-Life @iOS @Smoke @Regression @Web
Scenario Outline: Verify Snackable functionality on the iOS app

    Given I "<enable_feature>" wellness tools and limit the number or interests to "<max_interests>" and sessions to "<max_sessions>" from Arch    
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
    And I click from the iOS Get Started screen "Lets Begin"

    Given I am on the iOS Snackable Topics screen
    Then I select "<max_interests>" categories and "<max_interests>" Snackable sub topics on iOS Snackable Topics screen
    Then I am on the iOS News Feed screen
    Then I verify that "<max_sessions>" Snackable sessions can be viewed per day on iOS News Feed screen

    Examples:
        |enable_feature|max_interests|max_sessions|
        |true          |4            |2           |


@I15.5 @I-Life @iOS @Smoke @Regression @Web
Scenario Outline: Verify Snackable re-engagement functionlity by skipping an article 3 times then either setting another interest or   
    continuing with current interests

    Given I "<enable_feature>" wellness tools and limit the number or interests to "<max_interests>" and sessions to "<max_sessions>" from Arch    
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
    And I click from the iOS Get Started screen "Lets Begin"
    Then I am on iOS Snackable Topics screen
    Then I select "<max_interests>" categories and "<max_interests>" Snackable sub topics on iOS Snackable Topics screen
    Then I am on the iOS News Feed screen
    Then I verify snackable iOS re engagement functionality "<set_another_interest>"

    Examples:
        |enable_feature|set_another_interest|max_interests|
        |true          |true                |4            |
        |true          |false               |4            |