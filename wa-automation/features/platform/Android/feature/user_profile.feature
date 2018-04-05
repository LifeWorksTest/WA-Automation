Feature:
    1. Validate that the data of the user is presented
    2. Match current user total recognition in Profile with Leaderboard
    3. Change profile to profile 2 and then to profile 1 and check changes

Background:
  Given I login to LifeWorks from the Android app

@AN8.1 @AN-UserProfile @Android
Scenario: Validate that the data of the user is presented
    Given I am on the Android Menu screen
    Then I click from the Menu screen "My Profile"

    Given I am on the Android Profile screen
    When I validate that the data of the user is presented
    And I click from the Android Profile screen "Back"
    And I logout from the Android app

@AN8.2 @AN-UserProfile @Android
Scenario: Match current user total recognition in Profile with Leaderboard
    Given I am on the Android Menu screen
    Then I click from the Menu screen "My Profile"

    Given I am on the Android Profile screen
    When I check the number of recognitions
    And I click from the Android Profile screen "Back"
    And I click from the Menu screen "Leaderboard"

    Given I am on the Android Leaderboard screen
    When I click from the Android Leaderboard screen "ALL TIME"
    Then I match the my total recogntion with All Time
    And I logout from the Android app

@AN8.3 @UserProfile @AN-UserProfile @Android @Bug
Scenario: Change profile to profile 2 and then to profile 1 and check changes
    Given I am on the Android Menu screen
    Then I click from the Menu screen "My Profile"

    Given I am on the Android Profile screen
    When I click from the Android Profile screen "Edit Profile"
    Then I change the user profile to "user2" from the Android app
    And I check that the user profile is match to "user1"

    When I click from the Android Profile screen "Edit Profile"
    Then I change the user profile to "user1" from the Android app
    And I check that the user profile is match to "user2"
    And I logout from the Android app
  
