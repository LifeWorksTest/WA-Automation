Feature:
    * In Incentive Networks transaction the cashback value presented is before calculation of base and bonus
    ** In bownty transaction the cashback value presented is after calculation of base and bonus
    1. Check that currency is uniform in the page according user country
    2. Check 'What is My Wallet'
    3. (incentive_networks) Approved cashback -> Approved withdrew. (API)
    4. (incentive_networks) Approved cashback -> Declined withdraw -> Approve withdrew by Arch user. (API, Arch)
    5. (incentive_networks) Cashback request of 1 pounds -> Declined withdrew -> Cashback request for 6 pounds -> Withdrew approved. (API)
    6. (incentive_networks) Approved cashback request for £100 spent-> Approved withdrew -> Cashback request without expecting to get double cashback -> Approve withdrew. (API)
    7. (incentive_networks) Approved cashback -> Approved withdrew by Arch user. (API, Arch)
    8. (incentive_networks) Approved cashback -> Declined withdrew by Arch user -> Approved withdrew by Arch user. (API, Arch)
    9. (incentive_networks) Approved cashback -> Approved Withdrew to Paypal account using the Web App -> Approved withdrew. (API, Web App Arch)
    10. (incentive_networks) Approved cashback -> Decline withdrew -> Approved withdrew request to Bank account using the Web App -> Approved withdrew by Arch user. (API, Web App Arch)
    11. (incentive_networks) Approved cashback -> Decline withdrew by API -> Approve withdrew by API. (API)
    12. (incentive_networks) Decline Cashback by API -> Raise clime. (API) 
    14. (bat) Approved cashback -> Approved withdrew. (API)
    15. (bat) Approved cashback -> Declined withdraw -> Approve withdrew by Arch user. (API, Arch)
    16. (bat) Cashback request of 1 pounds -> Declined withdrew -> Cashback request for 6 pounds -> Withdrew approved. (API)
    17. (bat) Approved cashback -> Approved withdrew by Arch user. (API, Arch)
    18. (bat) Approved cashback -> Declined withdrew by Arch user. (API, Arch)
    19. (bat) Approved cashback -> Withdrew request to Paypal account using the Web App -> Approved withdrew by Arch user. (
    API, Web App Arch)
    20. (bat) Approved cashback -> Withdrew request to Bank account using the Web App -> Approved withdrew by Arch user. (API, Web App Arch)
    21. (bat) Approved cashback -> Declined withdrew by API -> Approved withdrew by API (API)
    22. (bat) Decline cashback by API -> Raise clime. (API)
    23. (bownty) Approved cashback -> Approved withdrew. (API)
    24. (bownty) (bat) Approved cashback -> Declined withdraw -> Approve withdrew by Arch user. (API, Arch)
    25. (bownty) Cashback request of 1 pounds -> Declined withdrew -> Cashback request for 6 pounds -> Withdrew approved. (API)
    26. (bownty) Approved cashback -> Declined withdrew by Arch user. (API, Arch)
    27. (bownty) Withdrew request -> Withdrew decline by Arch user -> Withdrew approved by Arch user(API, Arch)
    28. (bownty) Approved cashback -> Withdrew request to Paypal account using the Web App -> Approved withdrew by Arch user. (API, Web App Arch)
    29. (bownty) Approved cashback -> Withdrew request to Bank account using the Web App -> Approved withdrew by Arch user. (API, Web App Arch)
    30. (bownty) Approved cashback -> Declined withdrew by API -> Approved withdrew by API (API)
    31. (bownty) Decline cashback by API -> Raise clime. (API)
    32. User click on retailer -> company cashback rate as change -> user make a purchase and should get the cashback rate
    33. (incentive_networks) Approved cashback -> Approved withdrew. (Server, API)
    34. (incentive_networks) Approved cashback -> Declined withdraw -> Approve withdrew by Arch user. (Server, API, Arch)
    35. (incentive_networks) Cashback request of 2 pounds -> Declined withdrew -> Cashback request for 8 pounds -> Withdrew approved. (Server, API)
    36. (incentive_networks) Approved cashback request for £100 spent-> Approved withdrew -> Cashback request without expecting to get double cashback -> Approve withdrew. (Server, API)
    37. (incentive_networks) Approved cashback -> Approved withdrew by Arch user. (Server, API, Arch)
    38. (incentive_networks) Approved cashback -> Declined withdrew by Arch user -> Approved withdrew by Arch user. (Server, API, Arch)
    39. (incentive_networks) Approved cashback -> Approved Withdrew to Paypal account using the Web App -> Approved withdrew. (Server, API, Web App Arch)
    40. (incentive_networks) Approved cashback -> Approved withdrew request to Bank account using the Web App -> Approved withdrew by Arch user. (Server, API, Web App Arch)
    41. (incentive_networks) Approved cashback -> Decline withdrew by API -> Approve withdrew by API. (Server, API)
    42. (incentive_networks) Cashback request of 6 pounds -> Withdrew Automatic. (Server, API)
    43. (incentive_networks)User click on retailer -> company cashback rate as change -> user make a purchase and should get the cashback rate (Server, API)
    44. (incentive_networks) User buy products for "20" pounds and return return product worth "10" pounds. (Server, API)
    45. Manual credit user by Arch

@H9.1 @H-Wallet @Web @Hermes @incentive_networks @headless_hermes @Production_Smoke @Bug
Scenario: Check that currency is uniform in the page according user country
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I validate currency is uniform in the page according user country
    And I click "Logout" from the "Global Action" menu

@H9.2 @H-Wallet @Web @Hermes @incentive_networks @headless_hermes @Production_Smoke @Bug
Scenario:
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    
    Given I am on the Your Wallet screen
    When I check what is my wallet
    Then I click "Logout" from the "Global Action" menu

@H9.3 @H-Wallet @Web @Hermes @incentive_networks @headless_hermes @Regression @Bug
Scenario Outline: (incentive_networks) Approved cashback -> Approved withdrew. (API)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "Base Incentive Networks" changed to "<base>"
    And the company feature for "Bonus Incentive Networks" changed to "<bonus>"
    And I click on the "retailer" link

    Given I make a transaction using "Incentive Networks" for "<purchased_amount>" pounds and I get "<cashback_amount>" pounds cashback and I "<double_cashback>" to double cashback
    When I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" using the API
    And I click "Logout" from the "Global Action" menu

    Examples:
    |base|bonus|purchased_amount|cashback_amount|double_cashback      |
    |1   |0    |10              |5.7            |dont expect          |
    |1   |1    |10              |3.7            |expect               |


@H9.4 @incentive_networks @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario: (incentive_networks) Approved cashback -> Declined withdraw -> Approve withdrew by Arch user. (API, Arch)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I make a transaction using "Incentive Networks" for "10" pounds and I get "5" pounds cashback and I "expect" to double cashback
    Then I ask for cashback
    And I request to withdrew to my "Paypal" using the API
    And the withdrew request was "decline" by Arch user

    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" by Arch user
    And I click "Logout" from the "Global Action" menu

@H9.5 @incentive_networks @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario: (incentive_networks) Cashback request of 1 pounds -> Declined withdrew -> Cashback request for 6 pounds -> Withdrew approved. (API)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I make a transaction using "Incentive Networks" for "2" pounds and I get "1" pounds cashback and I "expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was decline 

    Given I make a transaction using "Incentive Networks" for "10" pounds and I get "2" pounds cashback and I "expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" using the API
    And I click "Logout" from the "Global Action" menu

@H9.6 @incentive_networks @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario: (incentive_networks) Approved cashback request for £100 spent-> Approved withdrew -> Cashback request without expecting to get double cashback -> Approve withdrew. (API)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I make a transaction using "Incentive Networks" for "100" pounds and I get "10" pounds cashback and I "expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" using the API
    And I reset time to be as before the change

    Given I make a transaction using "Incentive Networks" for "10" pounds and I get "10" pounds cashback and I "dont expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" using the API
    And I click "Logout" from the "Global Action" menu

@H9.7 @incentive_networks @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario: (incentive_networks) Approved cashback -> Approved withdrew by Arch user. (API, Arch)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I make a transaction using "Incentive Networks" for "10" pounds and I get "5" pounds cashback and I "expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" by Arch user
    And I click "Logout" from the "Global Action" menu

@H9.8 @incentive_networks @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario: (incentive_networks) Approved cashback -> Declined withdrew by Arch user -> Approved withdrew by Arch user. (API, Arch)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I make a transaction using "Incentive Networks" for "100" pounds and I get "10" pounds cashback and I "expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "decline" by Arch user
    
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" by Arch user
    And I click "Logout" from the "Global Action" menu


@H9.9 @incentive_networks @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario: (incentive_networks) Approved cashback -> Approved Withdrew to Paypal account using the Web App -> Approved withdrew. (API, Web App Arch)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I make a transaction using "Incentive Networks" for "100" pounds and I get "10" pounds cashback and I "expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to the "Paypal" account using the Web App
    And the withdrew request was "approve" by Arch user
    And I click "Logout" from the "Global Action" menu

@H9.10 @incentive_networks @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario: (incentive_networks) Approved cashback -> Decline withdrew -> Approved withdrew request to Bank account using the Web App -> Approved withdrew by Arch user. (API, Web App Arch)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I make a transaction using "Incentive Networks" for "100" pounds and I get "10" pounds cashback and I "expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to the "Bacs" account using the Web App
    And the withdrew request was "decline" by Arch user

    When I request to withdrew to the "Bacs" account using the Web App
    Then the withdrew request was "approve" by Arch user
    And I click "Logout" from the "Global Action" menu

@H9.11 @incentive_networks @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario: (incentive_networks) Approved cashback -> Decline withdrew by API -> Approve withdrew by API. (API)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I make a transaction using "Incentive Networks" for "100" pounds and I get "10" pounds cashback and I "expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "decline" using the API
    
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" using the API
    And I click "Logout" from the "Global Action" menu

@H9.12 @incentive_networks @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario Outline: (incentive_networks) Decline Cashback by API -> Raise clime. (API) 
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "Base Incentive Networks" changed to "<base>"
    And the company feature for "Bonus Incentive Networks" changed to "<bonus>"
    And I click on the "retailer" link

    Given I make a transaction using "Incentive Networks" for "<purchased_amount>" pounds and I get "<cashback_amount>" pounds cashback and I "<double_cashback>" to double cashback
    When I ask for cashback and it was declined
    Then I raise claim
    And I click "Logout" from the "Global Action" menu

    Examples:
    |base|bonus|purchased_amount|cashback_amount|double_cashback      |     
    |1   |2    |15              |2              |expect               |
    
    

@H9.14 @bat @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario Outline: (bat) Approved cashback -> Approved withdrew. (API)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "base book a table" changed to "<base>"
    And I click on the "retailer" link

    Given I make a transaction using "BAT" for "<purchased_amount>" pounds and I get "<cashback_amount>" pounds cashback and I "<double_cashback>" to double cashback
    When I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" using the API
    And I click "Logout" from the "Global Action" menu
    Examples:
        |base |purchased_amount|cashback_amount|double_cashback|
        |0.6  |10              |6              |dont expect    |
        |0.75 |10              |7.5            |dont expect    |
        |1    |10              |10             |dont expect    |
       

@H9.15 @bat @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario: (bat) Approved cashback -> Declined withdraw -> Approve withdrew by Arch user. (API, Arch)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And I click on the "retailer" link

    Given I make a transaction using "BAT" for "100" pounds and I get "6" pounds cashback and I "dont expect" to double cashback
    Then I ask for cashback
    And I request to withdrew to my "Paypal" using the API
    And the withdrew request was "decline" by Arch user
    
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" by Arch user
    And I click "Logout" from the "Global Action" menu

@H9.16 @bat @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario: (bat) Cashback request of 1 pounds -> Declined withdrew -> Cashback request for 6 pounds -> Withdrew approved. (API)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "base book a table" changed to "1"
    And I click on the "retailer" link

    Given I make a transaction using "BAT" for "2" pounds and I get "2" pounds cashback and I "dont expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was decline 

    Given I make a transaction using "BAT" for "4" pounds and I get "4" pounds cashback and I "dont expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" using the API
    And I click "Logout" from the "Global Action" menu

@H9.17 @bat @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario: (bat) Approved cashback -> Approved withdrew by Arch user. (API, Arch)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "base book a table" changed to "1"
    And I click on the "retailer" link

    Given I make a transaction using "BAT" for "10" pounds and I get "6" pounds cashback and I "dont expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" by Arch user
    And I click "Logout" from the "Global Action" menu

@H9.18 @bat @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario: (bat) Approved cashback -> Declined withdrew by Arch user. (API, Arch)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "base book a table" changed to "1"
    And I click on the "retailer" link

    Given I make a transaction using "BAT" for "10" pounds and I get "10" pounds cashback and I "dont expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "decline" by Arch user

    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" by Arch user
    And I click "Logout" from the "Global Action" menu

@H9.19 @bat @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario: (bat) Approved cashback -> Withdrew request to Paypal account using the Web App -> Approved withdrew by Arch user. (API, Web App Arch)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "base book a table" changed to "1"
    And I click on the "retailer" link

    Given I make a transaction using "BAT" for "10" pounds and I get "10" pounds cashback and I "dont expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to the "Paypal" account using the Web App
    And the withdrew request was "approve" by Arch user
    And I click "Logout" from the "Global Action" menu

@H9.20 @bat @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario: (bat) Approved cashback -> Withdrew request to Bank account using the Web App -> Approved withdrew by Arch user. (API, Web App Arch)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "base book a table" changed to "1"
    And I click on the "retailer" link

    Given I make a transaction using "BAT" for "100" pounds and I get "10" pounds cashback and I "dont expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to the "Bacs" account using the Web App
    And the withdrew request was "approve" by Arch user
    And I click "Logout" from the "Global Action" menu

@H9.21 @bat @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario: (bat) Approved cashback -> Declined withdrew by API -> Approved withdrew by API (API)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "base book a table" changed to "1"
    And I click on the "retailer" link

    Given I make a transaction using "BAT" for "100" pounds and I get "10" pounds cashback and I "dont expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "decline" using the API
    
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" using the API
    And I click "Logout" from the "Global Action" menu

@H9.22 @bat @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario: (bat) Decline cashback by API -> Raise clime. (API)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "base book a table" changed to "1"
    And I click on the "retailer" link

    Given I make a transaction using "BAT" for "10" pounds and I get "7" pounds cashback and I "dont expect" to double cashback
    When I ask for cashback and it was declined
    Then I raise claim
    And I click "Logout" from the "Global Action" menu

@H9.23 @bownty @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario Outline: (bownty) Approved cashback -> Approved withdrew. (API)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "base bownty" changed to "<base_bownty>"
    And the company feature for "bonus bownty" changed to "<bonus_bownty>"
    And I click on the "deal" link

    Given I make a transaction using "Bownty" for "<purchase_amount>" pounds and I get "<cashback_amount>" pounds cashback and I "dont expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" using the API
    And I click "Logout" from the "Global Action" menu

    Examples:
    |base_bownty|bonus_bownty|purchase_amount|cashback_amount|double_cashback|
    |1          |0.5         |100            |11.25          |expect         |
    |1          |1           |100            |15             |expect         |
    |1          |0           |100            |7.5            |dont expect    |
    |0.625      |0           |150            |7.03           |dont expect    |

@H9.24 @bownty @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario: (bownty) (bat) Approved cashback -> Declined withdraw -> Approve withdrew by Arch user. (API, Arch)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "base bownty" changed to "1"
    And the company feature for "bonus bownty" changed to "0"
    And I click on the "deal" link

    Given I make a transaction using "Bownty" for "100" pounds and I get "7.5" pounds cashback and I "dont expect" to double cashback
    Then I ask for cashback
    And I request to withdrew to my "Paypal" using the API
    And the withdrew request was "decline" by Arch user
    
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" by Arch user
    And I click "Logout" from the "Global Action" menu

@H9.25 @bownty @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario: (bownty) Cashback request of 7.5 pounds -> Declined withdrew -> Cashback request for 4.5 pounds -> Withdrew approved. (API)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "base bownty" changed to "1"
    And the company feature for "bonus bownty" changed to "0"
    And I click on the "deal" link

    Given I make a transaction using "Bownty" for "50" pounds and I get "3.75" pounds cashback and I "dont expect" to double cashback
    Then I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was decline 

    Given I make a transaction using "Bownty" for "20" pounds and I get "1.5" pounds cashback and I "dont expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" using the API
    And I click "Logout" from the "Global Action" menu

@H9.26 @bownty @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario: (bownty) Approved cashback -> Declined withdrew by Arch user. (API, Arch)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "base bownty" changed to "1"
    And the company feature for "bonus bownty" changed to "0"
    And I click on the "deal" link

    Given I make a transaction using "Bownty" for "100" pounds and I get "7.5" pounds cashback and I "dont expect" to double cashback
    Then I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" by Arch user
    And I click "Logout" from the "Global Action" menu

@H9.27 @bownty @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario: (bownty) Withdrew request -> Withdrew decline by Arch user -> Withdrew approved by Arch user(API, Arch)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "base bownty" changed to "1"
    And the company feature for "bonus bownty" changed to "0"
    And I click on the "deal" link

    Given I make a transaction using "Bownty" for "100" pounds and I get "7.5" pounds cashback and I "dont expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "decline" by Arch user

    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" by Arch user
    And I click "Logout" from the "Global Action" menu

@H9.28 @bownty @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario: (bownty) Approved cashback -> Withdrew request to Paypal account using the Web App -> Approved withdrew by Arch user. (API, Web App Arch)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "base bownty" changed to "1"
    And the company feature for "bonus bownty" changed to "0"
    And I click on the "deal" link

    Given I make a transaction using "Bownty" for "100" pounds and I get "7.5" pounds cashback and I "dont expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to the "Paypal" account using the Web App
    And the withdrew request was "approve" by Arch user
    And I click "Logout" from the "Global Action" menu

@H9.29 @bownty @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario: (bownty) Withdrew request to bank account with single cashback using the Web App -> Withdrew approve by Arch user. (API, Web App Arch)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "base bownty" changed to "1"
    And the company feature for "bonus bownty" changed to "0"
    And I click on the "deal" link

    Given I make a transaction using "Bownty" for "100" pounds and I get "7.5" pounds cashback and I "dont expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to the "Bacs" account using the Web App
    And the withdrew request was "approve" by Arch user
    And I click "Logout" from the "Global Action" menu

@H9.30 @bownty @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario: (bownty) Approved cashback -> Declined withdrew by API -> Approved withdrew by API (API)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "base bownty" changed to "1"
    And the company feature for "bonus bownty" changed to "0"
    And I click on the "deal" link

    Given I make a transaction using "Bownty" for "100" pounds and I get "7.5" pounds cashback and I "dont expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "decline" using the API
    
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" using the API
    And I click "Logout" from the "Global Action" menu

@H9.31 @bownty @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario: (bownty) Decline cashback by API -> Raise clime. (API)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "base bownty" changed to "1"
    And the company feature for "bonus bownty" changed to "0"
    And I click on the "deal" link

    Given I make a transaction using "Bownty" for "100" pounds and I get "7.5" pounds cashback and I "dont expect" to double cashback
    When I ask for cashback and it was declined
    Then I raise claim
    And I click "Logout" from the "Global Action" menu

@H9.32 @bownty @H-Wallet @Web @Hermes @headless_hermes @Bug
Scenario: User click on retailer -> company cashback rate as change -> user make a purchase and should get the cashback rate
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And the company feature for "base bownty" changed to "1"
    And the company feature for "bonus bownty" changed to "1"
    And I am on the Your Wallet screen
    And I click on the "deal" link
    And the company feature for "bonus bownty" changed to "0"

    Given I make a transaction using "Bownty" for "100" pounds and I get "7.5" pounds cashback and I "expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" using the API
    And the company feature for "bonus bownty" changed to "1"
    And I click "Logout" from the "Global Action" menu

@H9.33 @H-Wallet @Web @Hermes @server @Bug
Scenario Outline: (incentive_networks) Approved cashback -> Approved withdrew. (Server, API)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I create transaction through the server using "<method>" for "<purchased_amount>" pounds and I get "<cashback_amount>" pounds cashback and I "expect" to double cashback
    When I request to withdrew to my "Paypal" using the API
    Then the withdrew request was "approve" using the API
    And I click "Logout" from the "Global Action" menu

    Examples:
    |purchased_amount|cashback_amount|method                  |
    |50              |6.11           |payment_completed       |
    |50              |3.11           |approved                |
    |50              |3.81           |reconciled              |

@H9.34 @server @H-Wallet @Web @Hermes @Bug
Scenario: (incentive_networks) Approved cashback -> Declined withdraw -> Approve withdrew by Arch user. (Server, API, Arch)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I create transaction through the server using "payment_completed" for "10" pounds and I get "3" pounds cashback and I "expect" to double cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "decline" by Arch user

    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" by Arch user
    And I click "Logout" from the "Global Action" menu

@H9.35 @server @H-Wallet @Web @Hermes @Bug
Scenario: (incentive_networks) Cashback request of 2 pounds -> Declined withdrew -> Cashback request for 8 pounds -> Withdrew approved. (Server, API)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I create transaction through the server using "payment_completed" for "5.00" pounds and I get "1" pounds cashback and I "expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was decline 

    Given I create transaction through the server using "payment_completed" for "5.00" pounds and I get "4" pounds cashback and I "expect" to double cashback
    When I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" using the API
    And I click "Logout" from the "Global Action" menu

@H9.36 @server @H-Wallet @Web @Hermes @Bug
Scenario: (incentive_networks) Approved cashback request for £100 spent-> Approved withdrew -> Cashback request without expecting to get double cashback -> Approve withdrew. (Server, API)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I create transaction through the server using "payment_completed" for "100" pounds and I get "10" pounds cashback and I "expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" using the API
    And I reset time to be as before the change

    Given I create transaction through the server using "payment_completed" for "50" pounds and I get "10" pounds cashback and I "dont expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" using the API
    And I click "Logout" from the "Global Action" menu

@H9.37 @server @H-Wallet @Web @Hermes @Bug
Scenario: (incentive_networks) Approved cashback -> Approved withdrew by Arch user. (Server, API, Arch)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I create transaction through the server using "payment_completed" for "50" pounds and I get "10" pounds cashback and I "expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" by Arch user
    And I click "Logout" from the "Global Action" menu

@H9.38 @server @H-Wallet @Web @Hermes @Bug
Scenario: (incentive_networks) Approved cashback -> Declined withdrew by Arch user -> Approved withdrew by Arch user. (Server, API, Arch)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link
    
    Given I create transaction through the server using "payment_completed" for "50" pounds and I get "10" pounds cashback and I "expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "decline" by Arch user
    
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" by Arch user
    And I click "Logout" from the "Global Action" menu

@H9.39 @server @H-Wallet @Web @Hermes @Bug
Scenario: (incentive_networks) Approved cashback -> Approved Withdrew to Paypal account using the Web App -> Approved withdrew. (Server, API, Web App Arch)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I create transaction through the server using "payment_completed" for "50" pounds and I get "10" pounds cashback and I "expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to the "Paypal" account using the Web App
    And the withdrew request was "approve" by Arch user
    And I click "Logout" from the "Global Action" menu

@H9.40 @server @H-Wallet @Web @Hermes @Bug
Scenario: (incentive_networks) Approved cashback -> Approved withdrew request to Bank account using the Web App -> Approved withdrew by Arch user. (Server, API, Web App Arch)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I create transaction through the server using "payment_completed" for "50" pounds and I get "10" pounds cashback and I "expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to the "Bacs" account using the Web App
    And the withdrew request was "approve" by Arch user
    And I click "Logout" from the "Global Action" menu

@H9.41 @server @H-Wallet @Web @Hermes @Bug
Scenario: (incentive_networks) Approved cashback -> Decline withdrew by API -> Approve withdrew by API. (Server, API)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I create transaction through the server using "payment_completed" for "50" pounds and I get "10" pounds cashback and I "expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "decline" using the API
    
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" using the API
    And I click "Logout" from the "Global Action" menu

@H9.42 @server @H-Wallet @Web @Hermes @Bug
Scenario: (incentive_networks) Cashback request of 6 pounds -> Withdrew Automatic. (Server, API)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen
    And the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I create transaction through the server using "payment_completed" for "50" pounds and I get "7" pounds cashback and I "expect" to double cashback
    When the money was withdrew automatically
    And the withdrew request was "approve" by Arch user
    And I click "Logout" from the "Global Action" menu

@H9.43 @H-Wallet @Web @Hermes @server @Bug
Scenario: (incentive_networks) User click on retailer -> company cashback rate as change -> user make a purchase and should get the cashback rate (Server, API)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I am on the Your Wallet screen
    And I click on the "retailer" link
    And the company feature for "Bonus Incentive Networks" changed to "0"

    Given I create transaction through the server using "payment_completed" for "50" pounds and I get "5" pounds cashback and I "expect" to double cashback
    When I ask for cashback
    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" using the API
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click "Logout" from the "Global Action" menu

@H9.44 @H-Wallet @Web @Hermes @server @Bug
Scenario: (incentive_networks) User buy products for "20" pounds and return product worth "10" pounds. (Server, API)
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I am on the Your Wallet screen
    And I click on the "retailer" link

    Given I create transaction through the server using "payment_completed" for "100" pounds and I get "5" pounds cashback and I "expect" to double cashback
    Then I return a product worth "20" pounds that was related to my previous purchase


@H9.45 @H-Wallet @Web @Hermes @RA-9380 @Smoke @NotParallel @Not_US @Not_CA
Scenario Outline: Manual credit user by Arch
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Wallet" from the "Global Action" menu
    And I am on the Your Wallet screen

    Given I am on Arch Login screen
    When I login to Arch
    Then I click on "Companies" from Left menu
    Given I am on Companies screen
    When I open the current user company
    Then I select user "<user>"
    Then I credit the user "<amount>" "<currency_name>"
    And I logout from Arch

    Given I get back to wallet
    And I validate that "<amount>" "<currency_name>" are in available to withdraw

    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request was "approve" by Arch user
    And I click "Logout" from the "Global Action" menu

    Examples:
    |user                |amount|currency_name|
    |user0 user0         |10    |GPB          |

@H9.46 @H-Wallet @Web @Hermes @Not_US @Not_CA
Scenario Outline: Manually credit a limited user, upgrade to personal user and check that the credit has carried over to the upgrade wallet
    Given I am on the Web App Login screen
    When I log into the Web App as a valid "limited" user
    And I click "Wallet" from the "Global Action" menu
    Then I am on the Your Wallet screen

    Given I am on Arch Login screen
    When I login to Arch
    Then I click on "Companies" from Left menu
    
    Given I am on Companies screen
    And I open the current user company
    When I select user "current limited user"
    Then I credit the user "<amount>" "<currency_name>"
    And I logout from Arch

    Given I get back to wallet
    When I validate that "<amount>" "<currency_name>" are in available to withdraw
    Then I click "Logout" from the "Global Action" menu

    Given I upgrade the latest Limited account user to Personal 
    And I am on the Web App Login screen
    When I log into the Web App as a valid "upgraded personal" user
    Then I am on the News Feed screen
    And I click "Wallet" from the "Global Action" menu
    
    Given I am on the Your Wallet screen
    When I validate that "<amount>" "<currency_name>" are in available to withdraw
    Then I click "Logout" from the "Global Action" menu

    Examples:
    |amount|currency_name|
    |10    |GPB          |

    # current upgraded user
