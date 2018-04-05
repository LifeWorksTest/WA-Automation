Feature:
    1. Give recognition from the colleague directory
    2. Search for existing and unexistsing colleague (NEED TO IMROVE ITS NOT GO OVER ALL LIST)
    3. Validate badges

  Background:
    Given I login to LifeWorks from the Android app

@AN3.1 @AN-ColleaguesDirectory @Android
Scenario: Give recognition from the colleague directory
    Given I am on the Android Menu screen
    Then I click from the Menu screen "Colleagues Directory"

    Given I am on the Android Colleagues Directory screen
    Then I give the following recognition "Great Work", "Organised" to user index "0" from the Android Colleagues Directory screen

    #And I click from the Menu screen "News Feed"

    #Given I am on the Android News Feed screen
    #And I check that this recognition "Work Angel the best" is first in the Android News Feed screen
    #And I click "Home Btn" from the News Feed screen
    And I logout from the Android app

@AN3.2 @AN-ColleaguesDirectory @Android
Scenario: Search for existing and unexistsing colleague
    Given I am on the Android Menu screen
    Then I click from the Menu screen "Colleagues Directory"

    Given I am on the Android Colleagues Directory screen
    Then I serach for colleague "userNotInList" that "is not in" my list
    And I click from the Colleagues Directory screen "BACK"
    And I serach for colleague "user1" that "is in" my list
    And I click from the Colleagues Directory screen "BACK"
    And I logout from the Android app

@AN3.3 @AN-ColleaguesDirectory @Android @Bug
Scenario: Validate badges
    Given I am on the Android Menu screen
    Then I click from the Menu screen "Colleagues Directory"

    Given I am on the Android Colleagues Directory screen
    Then I validate all badges from the Android Colleagues Directory screen

    Then I click from the Colleagues Directory screen "Home Btn"
    And I logout from the Android app
  
