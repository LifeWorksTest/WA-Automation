Feature:
    1. Add/Remove restaurant by clicking the restaurant image/restaurant page
    2. Validate Hi-life Dining Card functionality 
    3. Cuisine type filter verification

@H6.1 @H-RestaurantDiscounts @Web @Hermes @headless_hermes @Not_CA @Not_US
Scenario Outline: Add/Remove restaurant by clicking the restaurant image/restaurant page
    Given I log into the Web App as a "personal" user and navigate to the Restaurant homepage
    And I remove all restaurants from favourites
    When I "favourite" "<restaurant_to_favourite>" using the "<favouriting_method>"
    Then I check that "<restaurant_to_favourite>" "is in" favourites
    
    When I "unfavourite" "<restaurant_to_favourite>" using the "<favouriting_method>"
    When I check that "<restaurant_to_favourite>" "is not in" favourites
    Then I click "Logout" from the "Global Action" menu

    Examples:
    |restaurant_to_favourite|favouriting_method|
    |Mirage                 |Restaurant image  |
    |Mirage                 |Restaurant Page   |


# Turn Hilife card tests back on when Bug web-6887 is fixed
@H6.2 @H-RestaurantDiscounts @Web @Hermes @headless_hermes @Smoke @Production_Smoke @Not_CA @Not_US @Web-6887 @LT-342 @Bug
Scenario Outline: Validate Hi-life Dining Card functionality 
    Given I log into the Web App as a "<user_type>" user and navigate to the Restaurant homepage
    When I validate Hilife Dining Card functionality for "3" restaurants
    Then I click "Logout" from the "Global Action" menu
    
    Examples:
    |user_type|
    |personal |
    |limited  |

@H6.3 @H-RestaurantDiscounts @Web @Hermes @Not_CA @Not_US
Scenario Outline: Cuisine type filter verification
    Given I log into the Web App as a "personal" user and navigate to the Restaurant homepage
    When I select "15" random cuisine types from the cuisine filter list
    Then I should only see restaurants that contain the cuisine type selected

    Given I deselect all selected cuisine filters by clicking "<method_to_deselect>"
    Then I should see an unfiltered list of restaurants that contain all available cuisine types

    Examples:
    |method_to_deselect   |
    |clear all            |
    |all selected cuisines|