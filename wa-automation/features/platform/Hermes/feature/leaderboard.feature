Feature:
    1. Check that I am in the correct place in the list
    2. Check that all tables are sorted
    3. See users total recognitions
    
@H3.1 @H-Leaderboard @Web @Hermes @headless_hermes @Regression @Production_Smoke
Scenario: Check that I am in the correct place in the list
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Leaderboard" from the "Work" menu

    Given I am on the Leaderboard screen
    When I select "Last Month" from the Leaderboard screen and check my position
    Then I select "All Time" from the Leaderboard screen and check my position
    And I select "This Month" from the Leaderboard screen and check my position
    
    And I click "Logout" from the "Global Action" menu

@H3.2 @H-Leaderboard @Web @Hermes @headless_hermes
Scenario: Check that all tables are sorted
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Leaderboard" from the "Work" menu

    Given I am on the Leaderboard screen
    When I select "Last Month" from the Leaderboard screen and check that the leaderboard is sorted
    Then I select "All Time" from the Leaderboard screen and check that the leaderboard is sorted
    And I select "This Month" from the Leaderboard screen and check that the leaderboard is sorted

    And I click "Logout" from the "Global Action" menu

@H3.3 @H-Leaderboard @Web @Hermes @headless_hermes @Smoke
Scenario: See users total recognitions
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Leaderboard" from the "Work" menu

    Given I am on the Leaderboard screen
    When I select "All Time" from the Leaderboard screen 
    Then I see "5" users recognitions
    And I click "Logout" from the "Global Action" menu