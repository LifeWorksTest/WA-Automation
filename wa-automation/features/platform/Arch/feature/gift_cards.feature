Feature:
	1. Turn "ON/OFF" Gift Cards

@A4.1 @A-GiftCards @Web @Arch @headless_arch @Smoke @Regression
Scenario: Turn "ON/OFF" Gift Cards
	Given I am on Arch Login screen
	When I login to Arch
	Then I click on "Gift Cards" from Left menu

	Given I am on Gift Cards screen
	Then I turn "ON" all Gift Cards