Feature:
    1. Give recognition
    2. Send post 
    3. Write comment
    4. Search for existing post and unexisting post
    5. Give recognition and validate all badges

@I5.1 @I-NewsFeed @iOS @Smoke @Regression
Scenario: Give recognition
    Given I login to LifeWorks from the iOS app
    Then I click "News Feed" from the iOS Menu Tab
    Then I am on the iOS News Feed screen
    Then I click "Give Recognition" from the iOS News Feed screen

    When I give recognition to user name "user0 user0" from the iOS app
    Then I click "Next" from the iOS News Feed screen 
    And I choose "Star" badge from the iOS app
    And I write this recoginition "Good work" from the iOS app    
    And I click "Post" from the iOS News Feed screen
    And I check that the recognition is in the iOS feed
    And I logout from the iOS app

@I5.2 @I-NewsFeed @iOS @Smoke @Regression
Scenario: Send post and "Like" this post
    Given I login to LifeWorks from the iOS app
    Then I click "News Feed" from the iOS Menu Tab

    Given I am on the iOS News Feed screen
    When I click "Create New Post" from the iOS News Feed screen
    Then I write this post "test test1" from the iOS app
    And I check that the post is in the iOS feed
    And I check the like functionality
    And I logout from the iOS app

@I5.3 @I-NewsFeed @iOS @Smoke @Regression
Scenario: Write comment
    Given I login to LifeWorks from the iOS app
    Then I click "News Feed" from the iOS Menu Tab

    Given I am on the iOS News Feed screen
    When I click "Create New Post" from the iOS News Feed screen
    Then I write this post "test test1" from the iOS app
    And I check that the post is in the iOS feed
    And I write this comment "Great work" in the latest post from the iOS app
    And I logout from the iOS app

@I5.4 @I-NewsFeed @iOS @Smoke @Regression @Bug @LT-1657
Scenario: Search for existing post and unexisting post
    Given I login to LifeWorks from the iOS app
    Then I click "News Feed" from the iOS Menu Tab

    Given I am on the iOS News Feed screen
    When I search for "test" that "is in" the iOS News Feed
    Then I search for "textIsNotInFeed" that "is not in" the iOS News Feed
    And I logout from the iOS app

@I5.5 @I-NewsFeed @iOS @Smoke @Regression @Bug @WAIOS-6439
Scenario: Give recognition and validate all badges
    Given I login to LifeWorks from the iOS app
    Then I click "News Feed" from the iOS Menu Tab

    Given I am on the iOS News Feed screen
    Then I click "Give Recognition" from the iOS News Feed screen

    When I give recognition to user name "user0 user0" from the iOS app
    Then I click "Next" from the iOS News Feed screen 
    Then I validate all badges exists
    Then I go back to the iOS News Feed screen
    And I logout from the iOS app