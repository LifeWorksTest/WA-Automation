Feature:
    1. Validate that the data of the user is presented 
    2. Match current user total recognition in Profile with Leaderboard  
    3. Change profile to profile 2 and then to profile 1 and check changes 

@I8.1 @I-UserProfile @iOS @Smoke @Regression
Scenario: Validate that the data of the user is presented
    Given I login to LifeWorks from the iOS app
    Then I click "More" from the iOS Menu Tab
    Then I am on the iOS More screen
    Then I click from the iOS More screen "View My Profile"

    Given I am on the iOS Profile screen
    When I validate from the iOS app that the data of the user is presented
    And I logout from the iOS app

@I8.2 @I-UserProfile @iOS @Smoke @Regression
Scenario: Match current user total recognition in Profile with Leaderboard  
    Given I login to LifeWorks from the iOS app
    Then I click "More" from the iOS Menu Tab
    Then I am on the iOS More screen
    Then I click from the iOS More screen "View My Profile"

    Given I am on the iOS Profile screen
    When I check the number of recognitions from the iOS app
    Then I click "Work" from the iOS Menu Tab
    Then I am on the iOS Colleagues Directory screen
    Then I click from the iOS Colleagues Directory screen "Leaderboard" 
    
    Given I am on the iOS Leaderboard screen
    When I click from the iOS Leaderboard screen "All Time"
    Then I match the my total recogntion from the iOS app with All Time
    And I logout from the iOS app 

@I8.3 @I-UserProfile @iOS @Smoke @Regression
Scenario: Change profile to profile 2 and then to profile 1 and check changes 
    Given I login to LifeWorks from the iOS app
    Then I click "More" from the iOS Menu Tab
    Then I am on the iOS More screen
    Then I click from the iOS More screen "View My Profile"

    Given I am on the iOS Profile screen
    When I click from the iOS Profile screen "Edit Profile"
    Then I change the user profile to "user2" from the iOS app
    And I check that the user profile is match to "user2" from the iOS app

    When I click from the iOS Profile screen "Edit Profile"
    Then I change the user profile to "user1" from the iOS app
    And I check that the user profile is match to "user1" from the iOS app
    #Then I go back to iOS News Feed Screen from iOS User Profile screen
    And I logout from the iOS app