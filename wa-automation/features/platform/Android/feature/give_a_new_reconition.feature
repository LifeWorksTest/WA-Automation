Feature:
	1. Give recognition
  2. Give recognition and validate that the recogniton can be seen from the web app

Background:
  Given I login to LifeWorks from the Android app

@AN10.1 @AN-GiveANewRecognition @Android
Scenario: Give recognition
    Given I am on the Android Menu screen
    Then I click from the Menu screen "News Feed"

    Given I am on the Android News Feed screen
    When I give the next recognition "Good work" badge "Organised" to user index "1"
	And I logout from the Android app

@AN10.2 @AN-GiveANewRecognition @Web @Android @Bug
Scenario: Give recognition and validate that the recogniton can be seen from the web app
    Given I am on the Android Menu screen
    Then I click from the Menu screen "News Feed"

    Given I am on the Android News Feed screen
    When I give the next recognition "Good work" badge "Organised" to user index "1"
    And I logout from the Android app

    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App

    Given I am on the News Feed screen
    Then I validate that the next recognition "Good work" is first in the news feed
	And I logout from the Android app
  
