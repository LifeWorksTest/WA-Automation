Feature:
    1. Go over InStore and Colleague Offers page and validate the data in the offers

@I6.1 @I-InStoreOffers @I-ColleagueOffers @iOS @Smoke @Regression @Smoke @Regression
Scenario Outline: Go over the offers in the page and validate data
    Given I login to LifeWorks from the iOS app
    Then I click "Perks" from the iOS Menu Tab
    Then I am on the iOS Perks Home page
    Then I navigate to iOS "<page>" screen from iOS Perks Home page

    Given I am on the iOS "<page>" screen
    Then I validate all "<page>" offers in the page from the iOS app
    And I logout from the iOS app
    
    Examples:
    |page            |
    |In-Store        |
    |Exclusive Offers|