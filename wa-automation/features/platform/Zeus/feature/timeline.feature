Feature:
    1. Check all Timeline filters
    2. Send post and check that the post is first in timeline

@Z5.1 @Z-Timeline @Web @Zeus @headless_zeus @Smoke @Production_Smoke
Scenario: Check all Timeline filters
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "Timeline" from Top Bar menu
    
    Given I am on the Timeline screen
    Then I check all Timeline filters
    And I logout from Admin Panel

@Z5.2 @Z-Timeline @Web @Zeus @headless_zeus @Smoke @Production_Smoke
Scenario: Send post and check that the post is first in timeline
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel

    Given I am on the Dashboard
    When I click on "Timeline" from Top Bar menu

    Given I am on the Timeline screen
    When I send this post from Timeline "This is my post from Timeline"
    Then I check that this post "This is my post from Timeline" is first in timeline

    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App

    Given I am on the News Feed screen
    When I check if this post "This is my post from Timeline" is first in the feed
    Then I click "Logout" from the "Global Action" menu
