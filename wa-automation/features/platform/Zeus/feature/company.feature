Feature:
    1. Change all badges to "OFF" anc validate that they are not exists in the Web App
    2. Change all badges to "ON" anc validate that they are not exists in the Web App

# Turning badges off and on again causes an issue in the values tab of the leaderboard. So it is best not to run this test until WEB-5918 is fixed
@Z8.1 @Z-Company @Web @Zeus @headless_zeus @Smoke @Regression @Bug @RA-6687 @Web-5918 @Production_Smoke
Scenario: Change all badges to "OFF" anc validate that they are not exists in the Web App
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "Performance" from Top Bar menu
    And I click on "Company" from Top Bar menu

    Given I am on the Company screen
    When I change all badges state to "OFF"

    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App

    Given I am on the News Feed screen
    When I validate that all badges are "not visible" in the Web App
    Then I click "Logout" from the "Global Action" menu

@Z8.2 @Z-Company @Web @Zeus @headless_zeus @Bug @RA-6687
Scenario: Change all badges to "ON" anc validate that they are not exists in the Web App
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "Performance" from Top Bar menu
    And I click on "Company" from Top Bar menu

    Given I am on the Company screen
    When I change all badges state to "ON"

    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App

    Given I am on the News Feed screen
    When I validate that all badges are "visible" in the Web App
    Then I click "Logout" from the "Global Action" menu
