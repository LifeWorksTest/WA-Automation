Feature:
    1. Go to every page in Life section and validate that available pages are accessible
    2. Verify that categories are displayed in the EAP page and have sub-categories linked to them
    3. Verify that one of the articls in the EAP page can be opened by following the breadcrumbs and also by search
    4. Verify redirection to the external sites when Health Library, Legal Services and Wellness Tools are selected
    5. Verify navigation to General Enquiry and Child Enquiry forms on Need Help screen
    6. Add locale specific telephone numbers to the company in Arch -> Validate that only the telephone number of the users locale is displayed on the EAP page -> Delete the Locales from Arch
    7. Enable Snackable in Arch -> Set Max category and session limits -> Verify Wellness category & Topic selection/max limits on web app -> verfiy article redirection -> Verify max sessions
    8. Verify Snackable re-engagement functionlity by skipping an article 3 times then either setting another interest or continuing with current interests
    9. Complete all assessments in an assessment group -> Verify the results page -> Retake assessments x amount of times

@H15.1 @Web @H-Life @Hermes @headless_hermes @Smoke @Regression @Production_Smoke
Scenario Outline: Go to every page in Life section and validate that available pages are accessible
    Given I am on the Web App Login screen
    When I log into the Web App as a valid "<user_type>" user
    Then I validate that all the pages in Life section are accessible
    And I click "Logout" from the "Global Action" menu
    Examples:
        |user_type |
        |personal  |
        |shared    |

@H15.2 @Web @H-Life @Hermes @headless_hermes @Regression @RA-9210
Scenario Outline: Verify that categories are displayed in the EAP page and have sub-categories linked to them
    Given I am on the Web App Login screen
    When I log into the Web App as a valid "<user_type>" user
    Then I click "Employee Assitance" from the "Life" menu

    Given I am on the "Employee Assitance" screen
    Then I validate that all the categories have sub-categories linked to them
    And I click "Logout" from the "Global Action" menu
    Examples:
        |user_type |
        |personal  |
        |shared    |

@H15.3 @Web @H-Life @Hermes @headless_hermes @Regression @WEB-6225 @RA-9210
Scenario Outline: Verify that one of the articles in the EAP page can be opened by following the breadcrumbs and also by search
    Given I am on the Web App Login screen
    When I log into the Web App as a valid "<user_type>" user
    Then I click "Employee Assitance" from the "Life" menu

    Given I am on the "Employee Assitance" screen
    Then I open one of the articles in the first category by following the links
    Then I search for the article title
    And I click "Logout" from the "Global Action" menu
    Examples:
        |user_type |
        |personal  |
        |shared    |

@H15.4 @Web @H-Life @Hermes @headless_hermes @Regression
Scenario Outline: Verify redirection to the external sites when Health Library, Legal Services and Wellness Tools are selected
    Given I am on the Web App Login screen
    When I log into the Web App as a valid "<user_type>" user
    Then I open "<features>" with exeternal links and validate successful redirection
    And I click "Logout" from the "Global Action" menu

	Examples:
        |user_type|features	      |
        |personal |Health Library |
        |personal |Legal Services |
        # |personal |Wellness Tools |
        |shared   |Health Library |
        |shared   |Legal Services |
        |shared   |Wellness Tools |

@H15.5 @Web @H-Life @Hermes @headless_hermes @Regression
Scenario Outline: Verify navigation to General Enquiry and Child Enquiry forms on Need Help screen
    Given I am on the Web App Login screen
    When I log into the Web App as a valid "<user_type>" user
    Then I click "Need Help" from the "Life" menu

    Given I am on the "Need Help" screen
    When I validate that "<type_of_enquiry>" form can be opened successfully
    And I click "Logout" from the "Global Action" menu

    Examples:
        |user_type|type_of_enquiry |
        |personal |General Enquiry |
        |personal |Childcare       |
        |shared   |General Enquiry |
        |shared   |Childcare       |

 @H15.6 @Web @H-Life @Hermes
 Scenario Outline: Add locale specific telephone numbers to the company in Arch -> Validate that only the telephone number of the users locale is displayed on the EAP page -> Delete the Locales from Arch
    Given I "add" "en_GB,en_US,fr_CA" cms locales for my company in Arch
    And I logout from Arch

    Given I am on the Web App Login screen
    And I log into the Web App as a valid "<user_type>" user
    When I click "Employee Assitance" from the "Life" menu
    And I am on the "Employee Assitance" screen
    Then I validate that I only see the phone numbers displayed for the logged-in users locale
    And I click "Logout" from the "Global Action" menu

    Given I "delete" "all" cms locales for my company in Arch
    And I logout from Arch
    Examples:
        |user_type |
        |personal  |
        |shared    |

@H15.7 @Web @H-Life @Hermes @headless_hermes @Regression @NotParallel
Scenario Outline: Enable Snackable in Arch -> Set Max category and session limits -> Verify Wellness category & Topic selection/max limits on web app -> verfiy article redirection -> Verify max sessions
    Given I "<enable_feature>" wellness tools and limit the number or interests to "<max_interests>" and sessions to "<max_sessions>" from Arch

    Given I am logged into the Web App as a user that has not used the Web App before
    And I click "Personalise your content" from News Feed screen
    And I am on the "Wellness Categories" screen
    When I select "<max_interests>" categories and "<max_interests>" Snackable sub topics
    Then I am on the News Feed screen
    Then I verify that "<max_sessions>" Snackable sessions can be viewed per day

    Examples:
        |enable_feature|max_interests|max_sessions|
        |true          |1            |1           |
        # |true          |3            |3           |
        |true          |4            |21          |

@H15.8 @Web @H-Life @Hermes @headless_hermes @Regression @NotParallel @Smoke
    Scenario Outline: Verify Snackable re-engagement functionlity by skipping an article 3 times then either setting another interest or continuing with current interests
    Given I "<enable_feature>" wellness tools and limit the number or interests to "3" and sessions to "3" from Arch

    Given I am logged into the Web App as a user that has not used the Web App before
    And I click "Personalise your content" from News Feed screen
    And I am on the "Wellness Categories" screen
    When I select "3" categories and "3" Snackable sub topics
    Then I verify snackable re engagement functionality "<set_another_interest>"

    Examples:
        |enable_feature|set_another_interest|
        |true          |true                |
        |true          |false               |

@H15.9 @Web @H-Life @Hermes @headless_hermes @Regression @NotParallel @Not_CA @Smoke
Scenario Outline: Complete all assessments in an assessment group -> Verify the results page -> Retake assessments x amount of times
    Given I login or signup to the Web App with a "<user_type>" user and navigate to the Assessment homepage
    Then I complete a Wellbeing Assessment series and retake each assessment "<times_to_retake_assessment>" times
    And I click "Logout" from the "Global Action" menu
    Examples:
    |user_type|times_to_retake_assessment|
    |personal |            1             |
    |shared   |            1             |
    |limited  |            1             |
