Feature:
    1. Check that the table all are sorted 
    2. Go from tables to users
    3. Compere Network summary with Total recognition on 'Value' for this month and 'All Time'
    
@Z4.1 @Z-Leaderboard @Web @Zeus @headless_zeus @Smoke @Regression @Production_Smoke
Scenario: Check that all tables are sorted 
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel

    Given I am on the Dashboard
    When I click on "Performance" from Top Bar menu
    When I click on "Leaderboard" from Top Bar menu
    
    Given I am on the Admin Panel Leaderboard screen
    When I click on "Performance" from Leaderboard screen
    Then I check that the table is sorted and have the right badges

    When I click on "Engagement" from Leaderboard screen
    Then I check that the table is sorted and have the right badges

    When I click on "Values" from Leaderboard screen
    Then I check that the table is sorted and have the right badges
    And I logout from Admin Panel

@Z4.2 @Z-Leaderboard @Web @Zeus @headless_zeus @RA-9408 @Bug
Scenario: Check the link to each user profile and check that the total recognitions for the current month is match on both screen
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel

    Given I am on the Dashboard
    When I click on "Performance" from Top Bar menu
    When I click on "Leaderboard" from Top Bar menu
    
    Given I am on the Admin Panel Leaderboard screen
    When I click on "Performance" from Leaderboard screen
    Then I check the link to each user profile

    When I click on "Engagement" from Leaderboard screen
    Then I check the link to each user profile
    And I logout from Admin Panel

@Z4.3 @Z-Leaderboard @Web @Zeus @headless_zeus @CI_Pass
Scenario: Compere Network summary with Total recognition on 'Values' for this month and 'All Time'
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel

    Given I am on the Dashboard
    When I click on "Performance" from Top Bar menu
    When I click on "Leaderboard" from Top Bar menu
    
    Given I am on the Admin Panel Leaderboard screen
    When I click on "Values" from Leaderboard screen
    Then I count all Total Recognitions
    And match it with Network Summery

    When I set time filter to "All Time"
    Then I count all Total Recognitions
    And match it with Network Summery
    And I logout from Admin Panel

@Z4.4 @Z-Leaderboard @Web @Zeus @headless_zeus @CI_Pass
    Scenario: Validate recognitions per month according to the total days of the month
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel

    Given I am on the Dashboard
    When I click on "Performance" from Top Bar menu
    Then I click on "Leaderboard" from Top Bar menu
    
    Given I am on the Admin Panel Leaderboard screen
    When I validate all months recognitions per day average
    Then I logout from Admin Panel
    
    