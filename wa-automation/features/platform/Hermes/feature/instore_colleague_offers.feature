Feature:
	1. Go over all In-Store Offers & Exclusive offers and validate offers data -> Open external website for each offer
    2. Create offer in Arch and check that created offer can be opened in the web app

@H12.1 @H-InstoreColleagueOffers @Web @Hermes @headless_hermes @Regression @Production_Smoke @Smoke
Scenario Outline: Go over all In-Store Offers & Exclusive offers and validate offers data -> Open external website for each offer
    Given I log into the Web App as a "<user_type>" user and navigate to the "<offer_type>" offers screen
    When I validate the data of "2" offers
    Then I click "Logout" from the "Global Action" menu 
    
    Examples:
    |user_type|offer_type      |
    |personal |In-Store Offers |
    |personal |Exclusive Offers|
    |limited  |In-Store Offers |
    |limited  |Exclusive Offers|


@H12.2 @H-InstoreColleagueOffers @Web @Hermes @headless_hermes
Scenario Outline: Create offer in Arch and check that created offer can be opened in the web app
    Given I am on Arch Login screen
    When I login to Arch
    Then I click on "Offers" from Left menu
    
    Given I am on Offers screen
    When I create a new "<offer_type>" offer in Arch
    Then I logout from Arch
    
    Given I log into the Web App as a "personal" user and navigate to the "<offer_type>" offers screen
    When I open an offer retailers external website
    Then I am successfully redirected to the external website
    
    Examples:
    |offer_type      |
    |In-Store Offers |
    |Exclusive Offers|


