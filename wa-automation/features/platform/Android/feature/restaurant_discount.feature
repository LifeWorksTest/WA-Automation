Feature:
    1. Go over restaurant list and match restaurant details with the restaurant profile page
    2. Favorite and unfavorite restaurant from restaurant page and check result in 'Favourites'
    3. Search for restaurants in specific location
    4. Validate functionality of the Map view

Background:
  Given I login to LifeWorks from the Android app

@AN7.1 @AN-RestureantDiscount @Android
Scenario: Go over restaurant list and match restaurant details with the restaurant profile page
    Given I am on the Android Menu screen
    Then I click from the Menu screen "Restaurant Discount"

    Given I am on the Android Restaurant Discounts screen
    Then I match restaurant details within the list with the details within the restaurant profile
    And I logout from the Android app

@AN7.2 @AN-RestureantDiscount @Android @Bug
Scenario: Favorites and unfavorites restaurant from the restaurant page and check result in 'Favourites'
    Given I am on the Android Menu screen
    Then I click from the Menu screen "Restaurant Discount"

    Given I am on the Android Restaurant Discounts screen
    When I favorite the first restaurant in the list
    And I validate that the favorites counter as updated
    And I click from Android Restaurant Discounts screen "Favorites"

    When I validate that the restaurant "is in" the favorites list
    Then I unfavorite the restaurant from the favorites page
    And I validate that the favorites counter as updated

    Given I am on the Android Restaurant Discounts screen
    When I click from Android Restaurant Discounts screen "Favorites"
    Then I validate that the restaurant "is not in" the favorites list
    And I logout from the Android app

@AN7.3 @AN-RestureantDiscount @Android @Bug
Scenario: Search for restaurants in specific location
    Given I am on the Android Menu screen
    Then I click from the Menu screen "Restaurant Discount"

    Given I am on the Android Restaurant Discounts screen
    When I click from Android Restaurant Discounts screen "Near Me"
    Then I search for restaurants around "Oxford Street"
    And I validate that "Oxford Street" is visible in the previous search results


@AN7.3.1 @AN-RestureantDiscount @Android @Bug
Scenario: Search for restaurant and go to restaurant page
    Given I am on the Android Menu screen
    Then I click from the Menu screen "Restaurant Discount"

    Given I am on the Android Restaurant Discounts screen
    When I click from Android Restaurant Discounts screen "Search"
    Then I search for restaurant "aSa"
    And I select "Masala" restaurant
    And I navigate back to more
    And I logout from the Android app

@AN7.4 @AN-RestureantDiscount @Android @Bug
Scenario: Validate functionality of the Map view
    Given I am on the Android Menu screen
    Then I click from the Menu screen "Restaurant Discount"

    Given I am on the Android Restaurant Discounts screen
    When I click from Android Restaurant Discounts screen "Map"
    Then I validate that the map contains results
    And I navigate back to more
    And I logout from the Android app
  
