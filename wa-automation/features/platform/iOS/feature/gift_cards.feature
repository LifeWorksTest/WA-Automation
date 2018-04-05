Feature:
	1. Go over the first cards under "See All Featured Gift Cards"
	2. Buy gift card by it's name
	3. Enable first gift card in Aviato -> Buy this Gift Card from Web

@I13.1 @I-GiftCards @iOS @Smoke @Regression
Scenario: Go over the first cards under "See All Featured Gift Cards"
	Given I login to LifeWorks from the iOS app
    When I click "Perks" from the iOS Menu Tab
    Then I am on the iOS Perks Home page
    Then I navigate to iOS "Gift Cards" screen from iOS Perks Home page

	Given I am on the iOS Gift Cards screen
	When I click from the iOS Gift Cards screen "Browse by Category"
	Then I select from the iOS Gift Cards screen "All"
	Then I validate Gift Cards offers
	Then I return to the iOS Gift Cards main screen
	And I logout from the iOS app

@I13.2 @I-GiftCards @iOS @Smoke @Regression
Scenario: Buy gift card by it's name
	Given I login to LifeWorks from the iOS app
    When I click "Perks" from the iOS Menu Tab
    Then I am on the iOS Perks Home page
    Then I navigate to iOS "Gift Cards" screen from iOS Perks Home page

	Given I am on the iOS Gift Cards screen
	When I click from the iOS Gift Cards screen "Browse by Category"
	Then I select from the iOS Gift Cards screen "All"
	And I open "New Look" Gift Cards offer
	And I buy "1" gift cards from the iOS app with value of "10" pounds
	And I recived an email with the subject "your_gift_card"
	And I return to the iOS Gift Cards main screen
	Then I logout from the iOS app

@I13.3 @I-GiftCards @iOS @Smoke @Regressio @Web @Bug
Scenario Outline: Enable first gift card in Aviato -> Buy this Gift Card from Web
	Given I log in to Perks Aviato and select the country code according to the test configuration
    Then I click "Gift Cards" from the Perks Aviato menu

    Given I am on the Perks Aviato Gift Cards screen
    When I open the "1" Gift Card
    Then I edit and enabled the Gift Card with the following info "<description>" "<terms_and_conditions>" "<category>" "<tier_1_value>" "<tier_2_value>"
    And I logout from Perks Aviato

   	Given I login to LifeWorks from the iOS app
    When I click "Perks" from the iOS Menu Tab
    Then I am on the iOS Perks Home page
    Then I navigate to iOS "Gift Cards" screen from iOS Perks Home page

	Given I am on the iOS Gift Cards screen
	When I click from the iOS Gift Cards screen "Browse by Category"
	Then I select from the iOS Gift Cards screen "All"
	And I buy the Gift Card that was enabled with the first denomination available from the iOS app
	And I recived an email with the subject "your_gift_card"

    Examples:
    |description  |terms_and_conditions  |category      |tier_1_value|tier_2_value|
    |description 1|terms_and_conditions 1|Fashion       |5           |10          |
