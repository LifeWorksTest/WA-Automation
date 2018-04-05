Feature:
		1. Go over the first cards under "See All Featured Gift Cards"
		2. Buy gift card by it's namefor the payment and no email validation)

Background:
	Given I login to LifeWorks from the Android app

@AN13.1 @AN-GiftCards @Android
Scenario: Go over the first cards under "Popular"
	Given I am on the Android Menu screen
    Then I click from the Menu screen "Gift Cards"

	Given I am on the Android Gift Cards screen
	#When I click from the Android Gift Cards screen "See All Featured Gift Cards"
	Then I validate Gift Cards offers from the Android app
	And I click from the Android Gift Cards screen "Back"
	And I logout from the Android app

@AN13.2 @AN-GiftCards @Android @Bug
Scenario: Buy gift card by it's name
	Given I am on the Android Menu screen
    Then I click from the Menu screen "Gift Cards"

	Given I am on the Android Gift Cards screen
	When I click from the Android Gift Cards screen "Categories"
	Then I select from the Android Gift Cards screen "All"
	And I open "Amazon.co.uk" Gift Cards offer from the Android app
	And I buy "1" gift cards from the Android app with value of "10" pounds
	And I recived an email with the subject "your_gift_card"
	And I logout from the Android app
