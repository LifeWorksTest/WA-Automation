Feature:
    1. Give recognition from the colleague directory 
    2. Search for exsiting colleague and unexsiting colleague 

@I3.1 @I-ColleaguesDirectory @iOS @Smoke @Regression
Scenario: Give recognition from the colleague directory
    Given I login to LifeWorks from the iOS app
    Then I click "Work" from the iOS Menu Tab

    Given I am on the iOS Colleagues Directory screen
    Then I give this recognition "Good work :) " to a colleague index "1" from the iOS app
    Then I click "News Feed" from the iOS Menu Tab
    Then I am on the iOS News Feed screen
    And I logout from the iOS app

@I3.2 @I-ColleaguesDirectory @iOS @Smoke @Regression
Scenario: Search for exsiting colleague and unexsiting colleague 
    Given I login to LifeWorks from the iOS app
    Then I click "Work" from the iOS Menu Tab

    Given I am on the iOS Colleagues Directory screen
    When I search from the iOS app for colleague "a" that "is in" my list
    Then I search from the iOS app for colleague "dgdf" that "is not in" my list
    Then I click from the iOS Colleagues Directory screen "Cancel" 
    And I logout from the iOS app