Feature:
    1. Check that all tables are sorted
    2. See user recognitions and go over the first recognitions
    3. Give recognition from leaderboard

@AN4.1 @AN-Leaderboard @Android
Scenario Outline: Check that all tables are sorted
    Given I am on the Android Menu screen
    Then I click from the Menu screen "Leaderboard"

    Given I am on the Android Leaderboard screen
    When I click from the Android Leaderboard screen "<period>"
    Then I validate that the table is sorted on the Android app
    Examples:
    |period    |
    |THIS MONTH|
    |LAST MONTH|
    |ALL TIME  |


@AN4.2 @AN-Leaderboard @Android
Scenario: See user recognitions and go over the first recognitions
    Given I am on the Android Menu screen
    Then I click from the Menu screen "Leaderboard"

    Given I am on the Android Leaderboard screen
    When I see "user1 user1" recognitions
    Then I go over user recognitions
    And I am back to Android Leaderboard screen

@AN4.3 @AN-Leaderboard @Android
Scenario: Give recognition from leaderboard
    Given I am on the Android Menu screen
    Then I click from the Menu screen "Leaderboard"

    Given I am on the Android Leaderboard screen
    When I click from the Android Leaderboard screen "THIS MONTH"
    Then I give the following recognition "Recognition from leaderboard", "Newbie" to user index "1" from the Android Leaderboard screen
    And I am back to Android Leaderboard screen
