Feature:
	1. Validate 2 deals from the 'All categories' 
	2. Validate 2 deals from randomly selected categories

@I11.1 @I-Local @iOS @Smoke @Regression @Bug
Scenario Outline: Validate 2 deals from selected categories 
	Given I login to LifeWorks from the iOS app
    Then I click from the iOS Menu screen "Local"

	Given I am on the iOS Local screen
	When I click from the iOS Local screen "<category>"
	Then I validate Deals in the iOS Local screen
	And I logout from the iOS app

	Examples:
	|category       |
	|All categories |

@I11.2 @I-Local @iOS @Smoke @Regression @Bug
Scenario: Validate 2 deals from randomly selected categories
	Given I login to LifeWorks from the iOS app
    Then I click from the iOS Menu screen "Local"

	Given I am on the iOS Local screen
	When I select "2" random categories from the list displayed on the iOS Local screen
	Then I validate Deals in the iOS Local screen
	And I logout from the iOS app