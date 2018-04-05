Feature:
    1. Go over restaurant list and match restaurant details with the restaurant profile page
    2. Favorite and unfavorite restaurant from restaurant page and check result in 'Favourites'
    3. Search for restaurants in specific location
    4. Search for restaurant and go to restaurant page
    5. Validate functionality of the Map view
    #TODO: extend book a table functionality

@I7.1 @I-RestureantDiscount @iOS @Smoke @Regression
Scenario: Go over restaurant list and match restaurant details with the restaurant profile page
    Given I login to LifeWorks from the iOS app
    Then I click "Perks" from the iOS Menu Tab
    Then I am on the iOS Perks Home page
    Then I navigate to iOS "Restaurants" screen from iOS Perks Home page

    Given I am on the iOS Restaurant Discounts screen
    Then I match from the iOS restaurant details within the list with the details within the restaurant profile
    Then I click from iOS Restaurant Discounts screen "Back"
    And I logout from the iOS app

@I7.2 @I-RestureantDiscount @iOS @Smoke @Regression
Scenario: Favorites and unfavorites restaurant from the restaurant page and check result in 'Favourites'
    Given I login to LifeWorks from the iOS app
    Then I click "Perks" from the iOS Menu Tab    
    Then I am on the iOS Perks Home page
    Then I navigate to iOS "Restaurants" screen from iOS Perks Home page

    Given I am on the iOS Restaurant Discounts screen
    When I update the Favourites counter
    When I favorite the first restaurant in the iOS list from the restaurant page
    Then I click from iOS Restaurant Discounts screen "Back"
    And I validate that the favorites counter has "increased by one"
    And I click from iOS Restaurant Discounts screen "Favorites"

    When I validate that the restaurant is "in" the favorites list
    Then I "unfavorite" the restaurant from the favorites page
    And I click from iOS Restaurant Discounts screen "Back"
    And I update the Favourites counter 
    And I validate that the favorites counter has "decreased by one"

    Given I am on the iOS Restaurant Discounts screen
    When I click from iOS Restaurant Discounts screen "Favorites"
    Then I validate that the restaurant is "not in" the favorites list
    Then I click from iOS Restaurant Discounts screen "Back"
    Then I click from iOS Restaurant Discounts screen "Back"
    And I logout from the iOS app


@I7.3 @I-RestureantDiscount @iOS @Smoke @Regression
Scenario: Search for restaurants in specific location
    Given I login to LifeWorks from the iOS app
    Then I click "Perks" from the iOS Menu Tab
    Then I am on the iOS Perks Home page
    Then I navigate to iOS "Restaurants" screen from iOS Perks Home page

    Given I am on the iOS Restaurant Discounts screen
    When I click from iOS Restaurant Discounts screen "Near me" 
    Then I search from the iOS Restaurant Discounts for restaurants around "Oxford Street"
    And I validate from the iOS Restaurant Discounts that "Oxford Street" is visible in the previous search results
    And I click from iOS Restaurant Discounts screen "Cancel" 
    Then I click from iOS Restaurant Discounts screen "Back"
    And I logout from the iOS app
    

@I7.4 @I-RestureantDiscount @iOS @Smoke @Regression
Scenario: Search for restaurant and go to restaurant page
    Given I login to LifeWorks from the iOS app
    Then I click "Perks" from the iOS Menu Tab
    Then I am on the iOS Perks Home page
    Then I navigate to iOS "Restaurants" screen from iOS Perks Home page

    Given I am on the iOS Restaurant Discounts screen
    When I click from iOS Restaurant Discounts screen "Search"
    Then I search for a restaurant on the iOS Restaurant Discounts screen
    And I validate the displayed restaurant from the iOS Restaurant Discounts screen
    Then I click from iOS Restaurant Discounts screen "Back"
    And I click from iOS Restaurant Discounts screen "Cancel"
    Then I click from iOS Restaurant Discounts screen "Back"
    And I logout from the iOS app

@I7.5 @I-RestureantDiscount @iOS @Smoke @Regression
Scenario: Validate functionality of the Map view
    Given I login to LifeWorks from the iOS app
    Then I click "Perks" from the iOS Menu Tab
    Then I am on the iOS Perks Home page
    Then I navigate to iOS "Restaurants" screen from iOS Perks Home page

    Given I am on the iOS Restaurant Discounts screen
    When I click from iOS Restaurant Discounts screen "Map"
    Then I validate from the iOS Restaurant Discounts screen that the map contains results
    Then I click from iOS Restaurant Discounts screen "Back"
    And I logout from the iOS app