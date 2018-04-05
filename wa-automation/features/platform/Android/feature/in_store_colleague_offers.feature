Feature:
	1. Go over the offers in the page and validate data

Background:
  Given I login to LifeWorks from the Android app

@AN6.1 @AN-InStoreOffers @Android
Scenario Outline: Go over the offers in the page and validate data
	Given I am on the Android Menu screen
    Then I click from the Menu screen "<page>"

    Given I am on the Android Offers screen
    Then I validate all "<page>" in the page
	And I logout from the Android app
  
    Examples:
    |page            |
    |In-Store Offers |
    |Exclusive Offers|