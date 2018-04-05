Feature:
    1. Check that the list is sorted
    2. Validate total number of colleagues
    3. Search for colleague (with a given name) and validate results

@H8.1 @H-ColleagueDirectory @Web @Hermes @headless_hermes @Production_Smoke @CI_Pass
Scenario: Check that the list is sorted
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Colleague Directory" from the "Work" menu

    Given I am on the Colleague Directory screen
    When I check that the list is sorted
    Then I click "Logout" from the "Global Action" menu

@H8.2 @H-ColleagueDirectory @Web @Hermes @headless_hermes @Smoke @Regression @Production_Smoke @CI_Pass
Scenario: Validate total number of colleagues
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Colleague Directory" from the "Work" menu

    Given I am on the Colleague Directory screen
    When I validate that the total number of colleagues is correct
    Then I click "Logout" from the "Global Action" menu

@H8.3 @H-ColleagueDirectory @Web @Hermes @headless_hermes @Production_Smoke @RA-7205 @Web-6142
Scenario Outline: Search for colleague (with a given name) and validate results
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Colleague Directory" from the "Work" menu

    Given I am on the Colleague Directory screen
    Then I search for "<state>" colleague with the name "<user_name>" and I verify the results
    And I click "Logout" from the "Global Action" menu

    Examples:
        |user_name  |state       |
        |notExisting|not existing| 
        |user1 user1|existing    |
