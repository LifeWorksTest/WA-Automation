Feature:
1. Admin invite friend -> Sign in -> Login to WebApp
2. Check functionality of all 'VIEW ALL' button
3. validate User Managment data 
4. Validate Popular Values datas
5. Validate Top Recognisers data
7. Validate Latest Recognitions data 
8. Send post and check that the post is first in timeline and the Web App
9. Validate Engagement after User sent recognition
10. Validate Total Spending/Popular categories/Popular brands after user buy from Shop Online/Daily Deals

@Z2.1 @Z-Dashboard @Web @Zeus @Smoke @Regression @Production_Smoke @NotParallel
Scenario: Admin invite friend -> Sign in -> Admin approve -> Login to WebApp    
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel

    Given I am on the Dashboard
    When I add a new user to the network from Dashboard
    And the new user click "Logout" from the "Global Action" menu

@Z2.2 @Z-Dashboard @Web @Zeus @headless_zeus @Smoke @Regression @Production_Smoke @CI_Pass
Scenario: Check functionality of all 'VIEW ALL' button
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel

    Given I am on the Dashboard
    When I check functionality of View All buttons
    Then I am back to Dashboard
    And I logout from Admin Panel

@Z2.3 @Z-Dashboard @Web @Zeus @headless_zeus @CI_Pass
Scenario: Validate User Managment data 
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    
    Given I am on the Dashboard
    When I validate the date in "User Management"
    Then I click on "Dashboard" from Top Bar menu
    And I am back to Dashboard
    And I logout from Admin Panel

@Z2.4 @Z-Dashboard @Web @Zeus @headless_zeus
Scenario: Validate Popular Values data
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    
    Given I am on the Dashboard
    When I validate the date in "Popular Values"
    Then I click on "Dashboard" from Top Bar menu
    And I am back to Dashboard
    And I logout from Admin Panel

@Z2.5 @Z-Dashboard @Web @Zeus @headless_zeus
Scenario: Validate Top Recognisers data
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    
    Given I am on the Dashboard
    When I validate the date in "Top Recognisers"
    Then I click on "Dashboard" from Top Bar menu
    And I am back to Dashboard
    And I logout from Admin Panel

@Z2.6 @Z-Dashboard @Web @Zeus @headless_zeus
Scenario: Validate Top Performers data
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    
    Given I am on the Dashboard
    When I validate the date in "Top Performers"
    Then I click on "Dashboard" from Top Bar menu
    And I am back to Dashboard
    And I logout from Admin Panel

@Z2.7 @Z-Dashboard @Web @Zeus @headless_zeus
Scenario: Validate Latest Recognitions data
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    
    Given I am on the Dashboard
    When I validate the date in "Latest Recognitions"
    Then I click on "Dashboard" from Top Bar menu
    And I am back to Dashboard
    And I logout from Admin Panel

@Z2.8 @Z-Dashboard @Web @Zeus @headless_zeus
Scenario: Send post and check that the post is first in timeline and the Web App
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel

    Given I am on the Dashboard
    When I send this post from dashboard "12345"
    Then I click on "Timeline" from Top Bar menu
    Given I am on the Timeline screen
    Then I check that this post "12345" is first in timeline

    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App

    Given I am on the News Feed screen
    When I check if this post "12345" is first in the feed
    Then I click "Logout" from the "Global Action" menu

# Sometimes takes a while for the recognition stats to update in the admin panel. Therefore this test can sometimes fail
@Z2.9 @Z-Dashboard @Web @Zeus @RA-7979
Scenario: Validate Engagement after User sent recognition 
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel

    Given I am on the Dashboard
    When I set "Engagement"
    Then I logout from Admin Panel
    And I give recognition to a user from the Web App
    And I update statistics for this company

    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I am on the Dashboard
    And I validate the changes in "Engagement" 
    And I logout from Admin Panel

@Z2.10 @Z-Dashboard @Web @Zeus @Bug
# DB error - UPDATE_COMPANY_ANALYSTICS:{"body"=>nil, "paging"=>nil, "error"=>{"code"=>-9, "type"=>"Application", "message"=>"A 404 error occurred"}}

Scenario Outline: Validate Total Spending/Popular categories/Popular brands after user buy from Shop Online 
    Given I am on the Admin Panel Login screen
    When I update statistics for this company
    Then I insert valid email and password from the Admin Panel screen
    And I am login to Admin Panel

    Given I am on the Dashboard
    When I set "Total Spending"
    Then I logout from Admin Panel
    And the user make a purchase in "<platform>" of "<purchase_amount>"
    And I update statistics for this company

    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I am on the Dashboard
    And I validate the changes in "Total Spending" 
    And I logout from Admin Panel

    Examples:
    |platform       |purchase_amount|
    |Shop Online    |10             |
