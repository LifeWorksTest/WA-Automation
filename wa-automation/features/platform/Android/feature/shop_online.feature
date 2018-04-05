Feature:
    1. Validate Featured Cashback, Recommended Cashback and Popular Cashback
    2. Favourite and unfavourite retailer

Background:
  Given I login to LifeWorks from the Android app

@AN2.1 @AN-ShopOnline @web @Android @Bug @LT-2757
Scenario Outline: Validate Featured Cashback, Recommended Cashback and Popular Cashback
    Given I am on the Android Menu screen
    Then I click from the Menu screen "Shop Online"

    Given I am on the Android Shop Online screen
    #When I click from the Android Shop Online screen "<section>"
    Then I validate "<shop_online_section>"
    And I click from the Android Shop Online screen "Back"
    And I logout from the Android app

    Examples:
        |section |shop_online_section|
        |FEATURED|Featured Cashback|
        |RECOMMENDED|Recommended Cashback|
        |POPULAR|Popular Cashback|

@AN2.2 @AN-ShopOnline @Android
Scenario: Favourite and unfavourite retailer
    Given I am on the Android Menu screen
    Then I click from the Menu screen "Shop Online"

    Given I am on the Android Shop Online screen
    When I click from the Android Shop Online screen "BROWSE"
    Then I search for "Argos" retailer
    And I "favourite" retailer
    And I click from the Android Shop Online screen "Back"
    #And I click from the Android Shop Online screen "Back"

    When I select "Favorite Retailers" from categories
    Then "Argos" "exists" in favourites list
    And I "unfavourite" retailer
    And I click from the Android Shop Online screen "Back"
    And "Argos" "not exists" in favourites list
    And I click from the Android Shop Online screen "Back"
    And I logout from the Android app
  
