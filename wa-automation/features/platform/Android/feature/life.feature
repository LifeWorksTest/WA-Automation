
Feature:	
	1. Complete all assessments in an assessment group

@AN15.9 @AN-Life @Android @Smoke @Regression
Scenario: Complete Retake assessments in an assessment group
    Given I am on the Android Menu screen
    Then I click from the Menu screen "Assessments"
    Given I am on the Assessments screen
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