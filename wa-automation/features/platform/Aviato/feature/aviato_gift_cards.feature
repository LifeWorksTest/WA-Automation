Feature: 
	1. Search, edit and enabled gift card

@AV1.1 @AV-GiftCards @Web @Aviato @headless_hermes
Scenario Outline: Search, edit and enabled gift card
	Given I log in to Perks Aviato and select "<country_code>"
    Then I click "Gift Cards" from the Perks Aviato menu

    Given I am on the Perks Aviato Gift Cards screen
    When I search for "<title>" Gift Card 
    Then I edit and enabled the Gift Card with the following info "<description>" "<terms_and_conditions>" "<category>" "<tier_1_value>" "<tier_2_value>"
    And I logout from Perks Aviato
 	
 	Examples:
 	|country_code|title         |description |terms_and_conditions   |category      |tier_1_value|tier_2_value|
 	|US          |TJ Maxx       |description 1|terms_and_conditions 1|Fashion       |5           |10          |
 	|GB          |Argos         |description 2|terms_and_conditions 2|Electrical    |5           |10          |
 	|CA          |Groupon Canada|description 3|terms_and_conditions 3|Home & Garden |5           |10          |