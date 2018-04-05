Feature: 
	1. Go over all gift cards and validate data
    2. Enable first gift card in Aviato and edit fields-> Set discount tier to 1 in Arch -> Buy this Gift Card from Web -> Set discount tier to 2 in Arch -> Buy this Gift Card from Web
    3. Gift Card search functionality validation

@H13.1 @H-GiftCards @Web @Hermes @headless_hermes @Not_CA
Scenario Outline: Go over all categories and validate gift cards data
    Given I log into the Web App as a "personal" user and navigate to the Gift Cards homepage
    When I open category "<category>" from Gift Cards screen
    Then I validate data of all cards in the page
    And I click "Logout" from the "Global Action" menu

    Examples:
    |category		  |
    |Department Stores|
    |Electrical       |

@H13.2 @H-GiftCards @Web @Hermes @Web @headless_hermes @Smoke @Regression @Production_Smoke @Not_CA @NotParallel
Scenario Outline: Enable first gift card in Aviato and edit fields-> Set discount tier to 1 in Arch -> Buy this Gift Card from Web -> Set discount tier to 2 in Arch -> Buy this Gift Card from Web
    Given I log in to Perks Aviato and select the country code according to the test configuration
    Then I click "Gift Cards" from the Perks Aviato menu

    Given I am on the Perks Aviato Gift Cards screen
    When I open the "1" Gift Card 
    Then I edit the Gift Card with random info and enable it 
    And I logout from Perks Aviato

    Given I set the Gift Card Discount Tier to "1" for my current company in Arch

    Given I log into the Web App as a "<user_type>" user and navigate to the Gift Cards homepage
    When I buy the Gift Card that was enabled with the first denomination available
    Then I recived an email with the subject "your_gift_card"

    Given I click "Gift Cards" from the "Perks" menu
    When I verify that the View your Gift Card Codes link redirects the user to the external giftcard page
    Then I click "Logout" from the "Global Action" menu

    Given I set the Gift Card Discount Tier to "2" for my current company in Arch

    Given I log into the Web App as a "<user_type>" user and navigate to the Gift Cards homepage
    When I buy the Gift Card that was enabled with the first denomination available
    Then I recived an email with the subject "your_gift_card"

    Given I click "Gift Cards" from the "Perks" menu
    When I verify that the View your Gift Card Codes link redirects the user to the external giftcard page
    Then I click "Logout" from the "Global Action" menu

    Examples:
    |user_type|
    |personal |
    |limited  |

@H13.3 @H-GiftCards @Web @Hermes @Web @headless_hermes @LT-2586
Scenario Outline: Gift Card search functionality validation
    Given I log into the Web App as a "personal" user and navigate to the Gift Cards homepage
    When I open category "random" from Gift Cards screen
    Then I validate search functionality for a giftcard that "<giftcard_exists>" exist with "<suggested_search>"

    Examples:
    |giftcard_exists|suggested_search|
    |false          |false           |
    |true           |false           |
    |true           |true            |

@H13.4 @H-GiftCards @Web @Hermes @Web @headless_hermes
Scenario: Disable a giftcard and check that the giftcard is not appearing on the Web App -> Enable the same giftcard and check that it is now appearing on th web app
    Given I log in to Perks Aviato and select the country code according to the test configuration
    Then I click "Gift Cards" from the Perks Aviato menu
    
    Given I am on the Perks Aviato Gift Cards screen
    When I make the "1" Gift Card "disabled"
    Then I logout from Perks Aviato

    Given I log into the Web App as a "personal" user and navigate to the Gift Cards homepage
    When I verify that the giftcard is hidden or visible depending on whether it has been enabled
    Then I click "Logout" from the "Global Action" menu

    Given I log in to Perks Aviato and select the country code according to the test configuration
    Then I click "Gift Cards" from the Perks Aviato menu
    
    Given I am on the Perks Aviato Gift Cards screen
    When I make the "1" Gift Card "enabled"
    Then I logout from Perks Aviato

    Given I log into the Web App as a "personal" user and navigate to the Gift Cards homepage
    When I verify that the giftcard is hidden or visible depending on whether it has been enabled
    Then I click "Logout" from the "Global Action" menu
