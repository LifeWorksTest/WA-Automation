Feature:
    1. Send recognition and check that the recognition is first in feed and in Admin Panel
    2. Give comment and check that the comment is in the post and the counter has change
    3. Send post and check that the post is in the feed
    4. Send post and Like and Unlike it
    5. Send recognition with mention and then go to the user profile that was mentioned
    6. Send post with mention and then go to the user profile that was mentioned
    7. Give 25 recognitions to a new user
    8. Admin Enable/Disable grouping -> WebApp Grouping visible/not visible
    9. Validate Post filtering options according to user type
    
@H10.1 @H-NewsFeed @Web @Hermes @headless_hermes @Smoke @Regression @Production_Smoke @NotParallel
# Employees changes to Colleagues when Grouping is off
Scenario: Send recognition with image upload and check that the recognition is first in feed and in Admin Panel
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "News Feed" from the Hermes menu top bar

    Given I am on the News Feed screen
    When I click "Give Recognition" from News Feed screen
    Then I give this recognition "Good work!!" badge "Creative" to "user1"
    And I recived an email with the subject "youve_been_recognised_on_lifeworks"
    And I click "Logout" from the "Global Action" menu

    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel

    Given I am on the Dashboard
    When I check that this recognition is existing in Latest Recognition "Good work!!" badge "Creative" to "user1"

@H10.2 @H-NewsFeed @Web @Hermes @headless_hermes @Regression @Production_Smoke @CI_Pass
Scenario: Give comment and check that the comment is in the post and the counter has change
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "News Feed" from the Hermes menu top bar

    Given I am on the News Feed screen
    When I click "Give Recognition" from News Feed screen
    Then I give this recognition "Good work!!" badge "Creative" to "user1"
    And I give this comment "MY FIRST COMMENT" to post index "0"
    And I click "Logout" from the "Global Action" menu

@H10.3 @H-NewsFeed @Web @Hermes @headless_hermes @Regression @Production_Smoke @CI_Pass
Scenario: Send post with image and check that the post is in the feed
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "News Feed" from the Hermes menu top bar

    Given I am on the News Feed screen
    When I click "Write New Post" from News Feed screen
    Then I write this post "THIS IS MY FIRST POST"
    And I click "Logout" from the "Global Action" menu


@H10.4 @H-NewsFeed @Web @Hermes @headless_hermes @CI_Pass @Bug @LT-2350
Scenario: Send post and Like and Unlike it
    Given I "disable" the "Like Functionality" feature key in Arch
    And I validate that "Like" is "false" in the web app
    Then I click "Logout" from the "Global Action" menu
    
    Given I "enable" the "Like Functionality" feature key in Arch  

    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "News Feed" from the Hermes menu top bar

    Given I am on the News Feed screen
    When I click "Give Recognition" from News Feed screen
    Then I click "Write New Post" from News Feed screen
    And I write this post "THIS IS MY FIRST COMMENT"    
    And I click "Like" on this post
    And I click "Unlike" on this post
    And I click "Logout" from the "Global Action" menu

@H10.5 @H-NewsFeed @Web @Hermes @headless_hermes @NotParallel @CI_Pass
Scenario: Send reconition with mention and then go to the user profile that was mentioned
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "News Feed" from the Hermes menu top bar

    Given I am on the News Feed screen
    When I click "Give Recognition" from News Feed screen
    Then I give this mention recognition post "Great Work" badge "Creative" to "user1"
    And I validate the link to "user1 user1" profile 
    And I click "Logout" from the "Global Action" menu

@H10.6 @H-NewsFeed @Web @Hermes @NotParallel @Smoke
Scenario: Send post with mention and then go to the user profile that was mentioned    
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "News Feed" from the Hermes menu top bar

    Given I am on the News Feed screen
    When I click "Write New Post" from News Feed screen
    Then I write mention post "Great work" and I mention "user1 user1"
    And I validate the link to "user1 user1" profile 
    And I logout from Web App

@H10.7 @H-NewsFeed @Web @Hermes @Bug
Scenario: Give 25 recognitions to a new user
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "News Feed" from the Hermes menu top bar

    Given I am on the News Feed screen
    When I click "Give Recognition" from News Feed screen
    Then I give "25" recognition for the latest new user
    And the new user recived an email with the subject "youve_been_recognised_on_lifeworks"
    And I click "Logout" from the "Global Action" menu

@H10.8 @H-NewsFeed @Web @Hermes
Scenario Outline: Admin Enable/Disable grouping -> WebApp Grouping visible/not visible
    Given the Arch user "<state>" Grouping feature key and set it to be managed by "<managed_by>"

    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App

    Given I am on the News Feed screen
    When I validate that Grouping is "<visible_or_not>" in the News Feed, Leaderboard and Colleague Directory
    Then I click "Logout" from the "Global Action" menu

Examples:
|state   |managed_by|visible_or_not    |
|Enabled |Admin     |visible           |
|Disabled|Admin     |not visible       |

@H10.9 @H-NewsFeed @Web @Hermes
Scenario Outline: Validate Post filtering options according to user type
    Given I am on the Web App Login screen
    When I log into the Web App as a valid "<user_type>" user
    Then I validate that the Refine By dropdown list displays the correct filter options dependant on user type
    And I click "Logout" from the "Global Action" menu
    Examples:
    |user_type        |
    |personal         |
    |shared           |
    |limited          |
    |upgraded personal|
