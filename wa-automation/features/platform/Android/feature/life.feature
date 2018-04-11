Feature:	
	1. Verify that categories are displayed in the EAP page and have sub-categories linked to them
	2. Verify that one of the articls in the EAP page can be opened by following the breadcrumbs and also by search
	

@AN15.1 @AN-Life @Android @Smoke @Regression
Scenario: Verify that categories are displayed in the EAP page and have sub-categories linked to them
    Given I am on the Android Menu screen
    Then I click from the Menu screen "Life"

    Given I am on the Employee Assistance screen
	Then I validate that all the categories have sub-categories
	And I logout from the Android app

@AN15.2 @AN-Life @Android @Smoke @Regression
Scenario: Verify that one of the articls in the EAP page can be opened by following the breadcrumbs and also by search
    Given I am on the Android Menu screen
    Then I click from the Menu screen "Life"

    Given I am on the Employee Assistance screen
    Then I open one of the articles by following the links
   	And I logout from the Android app
