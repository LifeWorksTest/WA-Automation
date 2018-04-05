Feature:
    1. Give recognition and check badges
    2. Write post
    3. Write comment
    4. Search for existing post and unexisting post

Background:
  Given I login to LifeWorks from the Android app

@AN5.1 @AN-NewsFeed @Android
Scenario: Give recognition from News Feed
    Given I am on the Android Menu screen
    Then I click from the Menu screen "News Feed"

    Given I am on the Android News Feed screen
    When I give the next recognition "Good work" badge "Newbie" to user index "3"
    Then I check that this badge "Newbie" and recognition "Good work" is first in the Android News Feed screen
    And I logout from the Android app

@AN5.2 @AN-NewsFeed @Android
Scenario: Send post
    Given I am on the Android Menu screen
    Then I click from the Menu screen "News Feed"

    Given I am on the Android News Feed screen
    When I write the next post "This is my post" from the Android app
    Then I validate that this post "This is my post" is in the Android News Feed screen
    And I logout from the Android app


@AN5.3 @AN-NewsFeed @Android
Scenario: Write comment
    Given I am on the Android Menu screen
    Then I click from the Menu screen "News Feed"

    Given I am on the Android News Feed screen
    When I write this comment "Great work my friend" in the latest post
    And I logout from the Android app

@AN5.4 @AN-NewsFeed @Android @Bug
Scenario: Search for existing post and unexisting post
    Given I am on the Android Menu screen
    Then I click from the Menu screen "News Feed"

    Given I am on the Android News Feed screen
    And I click on News Feed search
    When I search for "!@!#" that "is not in" the News Feed
    Then I search for "Test" that "is in" the News Feed
    And I logout from the Android app
  
