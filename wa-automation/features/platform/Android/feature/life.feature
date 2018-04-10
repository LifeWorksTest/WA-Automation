Feature:	
	1. Complete all assessments in an assessment group -> Verify the results page -> Retake assessments x amount of times

@AN15.9 @AN-Life @Android @Smoke @Regression
Scenario: Complete all assessments in an assessment group -> Verify the results page -> Retake assessments x amount of times
    Given I am on the Android Menu screen
    Then I click from the Menu screen "Assessments"

    Given I am on the Assessments screen
	Then I complete a Wellbeing Assessment series
	And I logout from the Android app

# @AN15.9 @AN-Life @Android @Smoke @Regression
# Scenario Outline: Complete all assessments in an assessment group -> Verify the results page -> Retake assessments x amount of times
#     Given I login or signup to the Web App with a "<user_type>" user and navigate to the Assessment homepage
#     Then I complete a Wellbeing Assessment series and retake each assessment "<times_to_retake_assessment>" times
#     And I click "Logout" from the "Global Action" menu
#     Examples:
#     |user_type|times_to_retake_assessment|
#     |personal |            1             |
   