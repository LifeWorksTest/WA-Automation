Feature:	
	1. Verify that categories are displayed in the EAP page and have sub-categories linked to them
	2. Verify that one of the articls in the EAP page can be opened by following the breadcrumbs and also by search
    3. Complete all assessments in an assessment group
	
@AN15.1 @AN-Life @Android @Smoke @Regression
Scenario: Verify that categories are displayed in the EAP page and have sub-categories linked to them
    Given I am on the Android Menu screen
    And I click from the Menu screen "Life"
    When I am on the Employee Assistance screen
	Then I validate that all the categories have sub-categories
	And I logout from the Android app

@AN15.2 @AN-Life @Android @Smoke @Regression
Scenario: Verify that one of the articls in the EAP page can be opened by following the breadcrumbs and also by search
    Given I am on the Android Menu screen
    And I click from the Menu screen "Life"
    When I am on the Employee Assistance screen
    Then I open one of the articles by following the links
   	And I logout from the Android app

@AN15.9 @AN-Life @Android @Smoke @Regression
Scenario: Complete Retake assessments in an assessment group
    Given I am on the Android Menu screen
    And I click from the Menu screen "Assessments"
    When I am on the Assessments screen
    Then I retake Health Risk Assessment
    And I logout from the Android app
    
@AN15.10 @AN-Life @Android @Smoke @Regression
Scenario Outline: Complete all assessments in an assessment group -> Verify the results page -> Retake assessments x amount of times
    Given I login or signup to the Android App with a "<user_type>" user and navigate to the Assessment homepage
    Then I complete new Assessment 
    And I retake the assessment "<times_to_retake_assessment>" times
    And I logout from the Android app
    
    Examples:
    |user_type|times_to_retake_assessment|
    |shared   |            1             |

