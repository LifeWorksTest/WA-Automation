Feature:
    1. Sort by different filter types and check ordering is correct
    2. Check link to retailers and special offers is redirecting correctly
    3. Add and remove special offers and retailers to and from favourites
    4. Validate that the presented cashback is correct accourding to Base & Bonus Incentive Networks cashback
    5. New user click on retailer for the first time
    6. Verify successful redirection to retailer website after user clicks get cashback/offer button
    7. Shop Online search functionality validation

@H4.1 @H-ShopOnline @Web @Hermes @headless_hermes @Bug @RA-6872 @WEB-5639 @RA-9285 @RA-9022
Scenario Outline: Sort by different filter types and check ordering is correct
    Given I log into the Web App as a "personal" user and navigate to the Shop Online homepage
    When I validate the sort functionality of "15" "<retailer_type>" sorted by "<sort_type>" for "1" random categories
    Then I click "Logout" from the "Global Action" menu
    Examples:
    |retailer_type|sort_type         |
    |retailers    |Highest Cashback  |
    |offers       |Highest Cashback  |
    # |offers       |Alphabetical Order|
    # |retailers    |Alphabetical Order|
    # |offers       |Ending Soon       |

@H4.2 @H-ShopOnline @Web @Hermes @headless_hermes @WEB-6045
Scenario Outline: Check link to retailers and special offers is redirecting correctly
    Given I log into the Web App as a "personal" user and navigate to the Shop Online homepage
    When I validate the data of "3" "<retailer_type>" per category for "1" random categories
    Then I click "Logout" from the "Global Action" menu
    Examples:
    |retailer_type|
    |retailers    |
    |offers       |

@H4.3 @H-ShopOnline @Web @Hermes @headless_hermes @Regression @Production_Smoke @WEB-6898
Scenario Outline: Add and remove special offers and retailers to and from favourites
    Given I log into the Web App as a "personal" user and navigate to the Shop Online homepage
    And I remove all "<retailer_type>" retailers from favourites
    When I "add" a "<retailer>" retailer to favourites using the retailers "<favourite_method>"
    And I check that the correct retailer "is in" Favourites
    Then I "remove" a "<retailer>" retailer to favourites using the retailers "<favourite_method>"
    And I check that the correct retailer "is not in" Favourites

    And I click "Logout" from the "Global Action" menu
    Examples:
    |favourite_method|retailer_type|retailer  |
    |card            |retailers    |random    |
    |retailers page  |retailers    |random    |
    |card            |offers       |random    |
    |retailers page  |offers       |random    |

# This needs to be tested on vagrant only, getting permission denied error for GET_COMPANY api call
@H4.4 @H-ShopOnline @Web @Hermes @headless_hermes @VagrantOnly @Bug
Scenario Outline: Validate that the presented cashback is correct accourding to Base & Bonus Incentive Networks cashback
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "<rate>"
    And I click "Shop Online" from the "Perks" menu

    Given I am on the Shop Online screen
    When I open retailer "retailer_1" using the configuration file
    Then I get retailer "retailer_1" base cashback using the configuration file
    And I validate that the presented cashback is correct accourding to Base & Bonus Incentive Networks cashback
    And I click on "X" from Shop Online screen
    And I click "Logout" from the "Global Action" menu
    Examples:
        |rate |
        |1.793|
        |2.146|
        |1.989|
        |7.833|
        |0    |
        |1    |

@H4.5 @H-ShopOnline @Web @Hermes @headless_hermes @NotParallel @headless_hermes
Scenario Outline: New user clicks on retailer for the first time and recieves email on how to recieve cashback
    Given I am logged into the Web App as a user that has not used the Web App before
    And I click "Shop Online" from the "Perks" menu
    And I am on the Shop Online screen
    When I select a random category and open a random "<retailer_type>" retailer
    And I open "<retailer_type>" retailer website
    Then I am successfully redirected to the external website
    And I recived an email with the subject "how_to_get_cashback_with_lifeworks"
    Examples:
    |retailer_type|
    |offers       |
    |retailers    |

@H4.6 @H-ShopOnline @Web @Hermes @Smoke @NotParallel @headless_hermes
 Scenario Outline: Verify successful redirection to retailer website after user clicks get cashback/offer button
    Given I log into the Web App as a "<user_type>" user and navigate to the Shop Online homepage
    When I select a random category and open a random "<retailer_type>" retailer
    And I open "<retailer_type>" retailer website
    Then I am successfully redirected to the external website
    Examples:
    |user_type|retailer_type|
    |personal |offers       |
    |personal |retailers    |
    |limited  |offers       |
    |limited  |retailers    |

@H4.7 @H-ShopOnline @Web @Hermes @headless_hermes
 Scenario Outline: Shop Online search functionality validation
    Given I log into the Web App as a "personal" user and navigate to the Shop Online homepage
    When I select a random category
    Then I search for the "<retailer_type>" that is displayed last on the Shop Online page
    Examples:
    |retailer_type|
    |offers       |
    |retailers    |

@H4.8 @H-ShopOnline @Web @Hermes @headless_hermes
Scenario Outline: Clicking on a suggested retailer when searching for a retailer directs you to that retailers page
    Given I log into the Web App as a "personal" user and navigate to the Shop Online homepage
    When I select a random category
    Then I search for a "<retailer>" retailer and click on the retailers name in the suggested search results dropdown
    Examples:
    |retailer|
    |random  |
