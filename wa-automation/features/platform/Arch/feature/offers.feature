Feature:
	1. Create new InStore Offer
	2. Create new Colleague Offer
	
@A3.1 @A-Offers @Web @Arch @Smoke @Regression
Scenario Outline: Create new InStore Offer
	Given I am on Arch Login screen
	When I login to Arch
	Then I click on "Offers" from Left menu
	Given I am on Offers screen
	When I create the following "<section>" offer: "<country>" "<retailer_name>" "<start_date>" "<expiry_date>" "<translation_local>" "<offer_title>" "<add_all>" "<company_name_id>"
	Then I validate that the following offer exists in the "In-store" offers section: "<country>" "<retailer_name>" "<start_date>" "<expiry_date>" "<translation_local>" "<offer_title>" "<add_all>" "<company_name_id>"
	And I logout from Arch

	Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "In-Store Offers" from the "Perks" menu

	Given I am on the In-Store Offers screen 
    Then I validate that the following offer is visible "<retailer_name>" "<offer_title>" "<start_date>" "<expiry_date>"
    Then I click "Logout" from the "Global Action" menu 
	
	Examples:
	|section|country|retailer_name|start_date|expiry_date|translation_local|offer_title|add_all|company_name_id|
	|In-store|All|retailer name|10/10/2014|11/11/2018|English (UK)|this is the offer title|True|-|

@A3.2 @A-Offers @Web @Arch
Scenario Outline: Create new Colleague Offer
	Given I am on Arch Login screen
	When I login to Arch
	Then I click on "Offers" from Left menu
	Given I am on Offers screen
	When I create the following "<section>" offer: "<country>" "<retailer_name>" "<start_date>" "<expiry_date>" "<translation_local>" "<offer_title>" "<add_all>" "<company_name_id>"
	Then I validate that the following offer exists in the "In-store" offers section: "<country>" "<retailer_name>" "<start_date>" "<expiry_date>" "<translation_local>" "<offer_title>" "<add_all>" "<company_name_id>"
	And I logout from Arch


	Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "In-Store Offers" from the "Perks" menu

	Given I am on the In-Store Offers screen 
    Then I validate that the following offer is visible "<retailer_name>" "<offer_title>" "<start_date>" "<expiry_date>"
    Then I click "Logout" from the "Global Action" menu 
	
	
	Examples:
	|section|country|retailer_name|start_date|expiry_date|translation_local|offer_title|add_all|company_name_id|
	|Colleague|All|retailer name|10/10/2014|11/11/2018|English (UK)|this is the offer title|True|-|