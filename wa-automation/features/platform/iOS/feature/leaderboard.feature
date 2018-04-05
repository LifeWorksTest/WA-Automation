Feature:
    1. Check that all tables are sorted and have the right images
    2. See user recognitions from the iOS appand go over the first 6 recognitions
    3. Give recognition from leaderboard

@I4.1 @I-LeaderBoard @iOS @Smoke @Regression
Scenario: Check that all tables are sorted and have the right images
    Given I login to LifeWorks from the iOS app
    Then I click "Work" from the iOS Menu Tab
    Then I am on the iOS Colleagues Directory screen
    Then I click from the iOS Colleagues Directory screen "Leaderboard" 

    Given I am on the iOS Leaderboard screen
    When I click from the iOS Leaderboard screen "This Month"
    Then I check that the table is sorted and have the right images

    When I click from the iOS Leaderboard screen "Last Month"
    Then I check that the table is sorted and have the right images

    When I click from the iOS Leaderboard screen "All Time"
    Then I check that the table is sorted and have the right images
    And I logout from the iOS app

@I4.2 @I-LeaderBoard @iOS @Smoke @Regression
Scenario: See user recognitions from the iOS app and go over all recognitions
    Given I login to LifeWorks from the iOS app
    Then I click "Work" from the iOS Menu Tab
    Then I am on the iOS Colleagues Directory screen
    Then I click from the iOS Colleagues Directory screen "Leaderboard" 

    Given I am on the iOS Leaderboard screen
    When I see "user1 user1" recognitions from the iOS app
    Then I go over the user recognitions from the iOS app
    And I click from the iOS Leaderboard screen "Back"
    And I am back to Leaderboard screen
    And I logout from the iOS app

@I4.3 @I-LeaderBoard @iOS @Smoke @Regression
#TODO: to add recognition validation in the feed
Scenario: Give recognition from leaderboard
    Given I login to LifeWorks from the iOS app
    Then I click "Work" from the iOS Menu Tab
    Then I am on the iOS Colleagues Directory screen
    Then I click from the iOS Colleagues Directory screen "Leaderboard" 

    Given I am on the iOS Leaderboard screen
    When I click from the iOS Leaderboard screen "This Month"
    Then I give this recognition "Recognition from leaderboard" to user in the "1"th place 
    And I am back to Leaderboard screen
    And I logout from the iOS app