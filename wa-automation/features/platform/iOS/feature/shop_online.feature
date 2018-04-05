Feature:
    1. Validate Featured Cashback
    2. Validate Popular in Network
    3. Validate Recommended Offers
    4. Validate Featured Offers
    5. Save and unsave offer
    6. SAdd and remove retailer from Favourites
    7. Search for existing retailer
    8. Search for unexisting retailer
    9. Search for existing product
    10. Search for unexisting product

@I2.1 @I-ShopOnline @iOS @Smoke @Regression
Scenario: Validate Featured Cashback
    Given I login to LifeWorks from the iOS app
    Then I click "Perks" from the iOS Menu Tab
    Then I am on the iOS Perks Home page
    Then I navigate to iOS "Shop Online" screen from iOS Perks Home page

    Given I am on the iOS Shop Online screen
    Then I validate three deals of Featured Cashback table from the iOS app
    And I click from the iOS Shop Online screen "Back"
    And I logout from the iOS app

@I2.2 @I-ShopOnline @iOS @Smoke @Regression
Scenario: Validate Popular in Network
    Given I login to LifeWorks from the iOS app
    Then I click "Perks" from the iOS Menu Tab
    Then I am on the iOS Perks Home page
    Then I navigate to iOS "Shop Online" screen from iOS Perks Home page

    Given I am on the iOS Shop Online screen
    Then I validate validate three deals of Popular in Network table from the iOS app
    And I click from the iOS Shop Online screen "Back"
    And I logout from the iOS app

@I2.3 @I-ShopOnline @iOS @Smoke @Regression
Scenario: Validate Recommended Offers
    Given I login to LifeWorks from the iOS app
    Then I click "Perks" from the iOS Menu Tab
    Then I am on the iOS Perks Home page
    Then I navigate to iOS "Shop Online" screen from iOS Perks Home page

    Given I am on the iOS Shop Online screen
    Then I validate validate three deals of Recommended Offers table from the iOS app
    And I click from the iOS Shop Online screen "Back"
    And I logout from the iOS app

@I2.4 @I-ShopOnline @iOS @Smoke @Regression
Scenario: Validate Featured Offers
    Given I login to LifeWorks from the iOS app
    Then I click "Perks" from the iOS Menu Tab
    Then I am on the iOS Perks Home page
    Then I navigate to iOS "Shop Online" screen from iOS Perks Home page

    Given I am on the iOS Shop Online screen
    Then I validate validate three deals of Featured Offers table from the iOS app
    And I click from the iOS Shop Online screen "Back"
    And I logout from the iOS app

@I2.5 @I-ShopOnline @iOS @Smoke @Regression
Scenario: Save and unsave offer
    Given I login to LifeWorks from the iOS app
    Then I click "Perks" from the iOS Menu Tab
    Then I am on the iOS Perks Home page
    Then I navigate to iOS "Shop Online" screen from iOS Perks Home page

    Given I am on the iOS Shop Online screen
    When I go to "Babys Mart" in category "Health & Beauty" from the iOS app
    Then I save the first offer
    And I validate that the offer is "in" Saved Offers category

    When I go to "Babys Mart" in category "Health & Beauty" from the iOS app
    Then I remove the first offer
    And I validate that the offer is "not in" Saved Offers category
    And I logout from the iOS app

@I2.6 @I-ShopOnline @iOS @Smoke @Regression
Scenario: Add and remove retailer from Favourites
    Given I login to LifeWorks from the iOS app
    Then I click "Perks" from the iOS Menu Tab
    Then I am on the iOS Perks Home page
    Then I navigate to iOS "Shop Online" screen from iOS Perks Home page

    Given I am on the iOS Shop Online screen
    When I go to "Accessorize" in category "Fashion" from the iOS app
    Then I "add" this retailer to Favourites
    And I validate that the retailer is "in" Favourites category

    When I go to "Accessorize" in category "Fashion" from the iOS app
    Then I "remove" this retailer to Favourites
    And I validate that the retailer is "not in" Favourites category
    And I logout from the iOS app

@I2.7 @I-ShopOnline @iOS @Smoke @Regression @Bug
Scenario: Search for existing retailer
    Given I login to LifeWorks from the iOS app
    Then I click "Perks" from the iOS Menu Tab
    Then I am on the iOS Perks Home page
    Then I navigate to iOS "Shop Online" screen from iOS Perks Home page

    Given I am on the iOS Shop Online screen
    When I click from the iOS Shop Online screen "Search"
    Then I search for "existing" "retailer" "Adidas" from the iOS app
    And I open "Adidas" retailer page from the iOS app
    And I clear the retailer name from Search field
    And I return to the main screen
    And I logout from the iOS app

@I2.8 @I-ShopOnline @iOS @Smoke @Regression @Bug @WAIOS-6650
Scenario: Search for unexisting retailer
    Given I login to LifeWorks from the iOS app
    Then I click "Perks" from the iOS Menu Tab
    Then I am on the iOS Perks Home page
    Then I navigate to iOS "Shop Online" screen from iOS Perks Home page

    Given I am on the iOS Shop Online screen
    When I click from the iOS Shop Online screen "Search"
    Then I search for "unexisting" "retailer" "asdfghjk" from the iOS app
    And I return to the main screen
    And I logout from the iOS app

@I2.9 @I-ShopOnline @iOS @Smoke @Regression @Bug @LT-1436
Scenario: Search for existing product
    Given I login to LifeWorks from the iOS app
    Then I click "Perks" from the iOS Menu Tab
    Then I am on the iOS Perks Home page
    Then I navigate to iOS "Shop Online" screen from iOS Perks Home page

    Given I am on the iOS Shop Online screen
    When I click from the iOS Shop Online screen "Search"
    Then I search for "existing" "product" "iphone" from the iOS app
    And I open "iphone" product page from the iOS app
    And I return to the main screen
    And I logout from the iOS app

@I2.10 @I-ShopOnline @iOS @Smoke @Regression @Bug @WAIOS-6650
Scenario: Search for unexisting product
    Given I login to LifeWorks from the iOS app
    Then I click "Perks" from the iOS Menu Tab
    Then I am on the iOS Perks Home page
    Then I navigate to iOS "Shop Online" screen from iOS Perks Home page

    Given I am on the iOS Shop Online screen
    When I click from the iOS Shop Online screen "Search"
    Then I search for "unexisting" "product" "asdfasdfs" from the iOS app
    And I return to the main screen
    And I logout from the iOS app
