Feature:
    3. (incentive_networks) Approved cashback -> Approved withdrew. (API)
    4. Scenario: (incentive_networks) Approved cashback -> Declined withdraw -> Approve withdrew by the API. (API)
    5. (incentive_networks) Cashback request of 1 pounds -> Declined withdrew -> Cashback request for 6 pounds -> Withdrew approved. (API)
    6. (incentive_networks) Approved cashback request for £100 spent-> Approved withdrew -> Cashback request without expecting to get double cashback -> Approve withdrew. (API)
    7. (incentive_networks) Approved cashback -> Approved withdrew by Arch user. (API, Arch)
    8. (incentive_networks) Approved cashback -> Declined withdrew by Arch user -> Approved withdrew by Arch user. (API, Arch)
    9. (incentive_networks) Approved cashback -> Approved Withdrew to Paypal account using the Native app -> Approved withdrew. (API, Native app)
    10.(incentive_networks) Approved cashback -> Approved withdrew request to Bank account using the Native app -> Approved withdrew by API user. (API, Native app)
    11. (incentive_networks) Approved cashback -> Decline withdrew by API -> Approve withdrew by API. (API)
    12. (incentive_networks) Decline Cashback by API -> Raise clime. (API) 
    13. (incentive_networks) Cashback request of 1 pounds -> Declined withdrew -> Cashback request for 6 pounds -> Withdrew approved. (API, iOS app)
    42. (incentive_networks) Cashback request of 6 pounds -> Withdrew Automatic. (iOS, Server, API)


@I9.3 @I-IncentiveNetworks @I-Wallet @iOS
Scenario Outline: (incentive_networks) Approved cashback -> Approved withdrew. (API)
    Given I am on the iOS Menu screen
    When I click from the iOS Menu screen "Wallet"
    Then the company feature for "Base Incentive Networks" changed to "<base>"
    And the company feature for "Bonus Incentive Networks" changed to "<bonus>"
    And I click on the "retailer" link

    Given I am on the iOS Wallet screen
    When I purchased product from the iOS Shop Online using "incentive networks" for "<purchased_amount>" pounds and I get "<cashback_amount>" pounds cashback and I "<double_cashback>" to double cashback
    Then I ask for cashback from the iOS app
    And I request to withdrew from the iOS app to my "Paypal" using the API
    And the withdrew request from the iOS app was "approve" using the API

    Examples:
    |base|bonus|purchased_amount|cashback_amount|double_cashback      |
    |1   |1    |5               |10             |expect               |
    |1   |0    |10              |6.5            |dont expect          |

@I9.4 @incentive_networks @I-Wallet @iOS
Scenario: (incentive_networks) Approved cashback -> Declined withdraw -> Approve withdrew by the API. (API)
    Given I am on the iOS Menu screen
    When I click from the iOS Menu screen "Wallet"
    Then the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I am on the iOS Wallet screen
    When I purchased product from the iOS Shop Online using "incentive networks" for "100" pounds and I get "5" pounds cashback and I "expect" to double cashback
    Then I ask for cashback from the iOS app
    And I request to withdrew from the iOS app to my "Paypal" using the API
    And the withdrew request from the iOS app was "decline" using the API

    Then I request to withdrew from the iOS app to my "Paypal" using the API
    And the withdrew request from the iOS app was "approve" using the API

@I9.5 @I-IncentiveNetworks @I-Wallet @iOS
Scenario: (incentive_networks) Cashback request of 1 pounds -> Declined withdrew -> Cashback request for 6 pounds -> Withdrew approved. (API)
    Given I am on the iOS Menu screen
    When I click from the iOS Menu screen "Wallet"
    Then the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I am on the iOS Wallet screen
    When I purchased product from the iOS Shop Online using "incentive networks" for "2" pounds and I get "1" pounds cashback and I "expect" to double cashback
    Then I ask for cashback from the iOS app
    And I request to withdrew from the iOS app to my "Paypal" using the API
    And the withdrew request from the iOS app was decline

    When I purchased product from the iOS Shop Online using "incentive networks" for "2" pounds and I get "2" pounds cashback and I "expect" to double cashback
    Then I ask for cashback from the iOS app
    And I request to withdrew from the iOS app to my "Paypal" using the API
    And the withdrew request from the iOS app was "approve" using the API

@I9.6 @I-IncentiveNetworks @I-Wallet @iOS
Scenario: (incentive_networks) Approved cashback request for £100 spent-> Approved withdrew -> Cashback request without expecting to get double cashback -> Approve withdrew. (API)
    Given I am on the iOS Menu screen
    When I click from the iOS Menu screen "Wallet"
    Then the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I am on the iOS Wallet screen
    When I purchased product from the iOS Shop Online using "incentive networks" for "100" pounds and I get "10" pounds cashback and I "expect" to double cashback
    When I ask for cashback from the iOS app
    Then I request to withdrew from the iOS app to my "Paypal" using the API
    And the withdrew request from the iOS app was "approve" using the API
    And I reset time to be as before the change in the iOS app

    Given I purchased product from the iOS Shop Online using "incentive networks" for "10" pounds and I get "10" pounds cashback and I "dont expect" to double cashback
    When I ask for cashback from the iOS app
    Then I request to withdrew from the iOS app to my "Paypal" using the API
    And the withdrew request from the iOS app was "approve" using the API

@I9.7 @I-IncentiveNetworks @I-Wallet @Web @iOS
Scenario: (incentive_networks) Approved cashback -> Approved withdrew by Arch user. (API, Arch)
    Given I am on the iOS Menu screen
    When I click from the iOS Menu screen "Wallet"
    Then the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I am on the iOS Wallet screen
    When I purchased product from the iOS Shop Online using "incentive networks" for "10" pounds and I get "5" pounds cashback and I "expect" to double cashback
    When I ask for cashback from the iOS app
    Then I request to withdrew from the iOS app to my "Paypal" using the API
    And the withdrew request from the iOS app was "approve" by Arch user


@I9.8 @I-IncentiveNetworks @I-Wallet @Web @iOS
Scenario: (incentive_networks) Approved cashback -> Declined withdrew by Arch user -> Approved withdrew by Arch user. (API, Arch)
    Given I am on the iOS Menu screen
    When I click from the iOS Menu screen "Wallet"
    Then the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I am on the iOS Wallet screen
    When I purchased product from the iOS Shop Online using "incentive networks" for "100" pounds and I get "10" pounds cashback and I "expect" to double cashback
    When I ask for cashback from the iOS app
    Then I request to withdrew from the iOS app to my "Paypal" using the API
    And the withdrew request from the iOS app was "decline" by Arch user

    When I request to withdrew from the iOS app to my "Paypal" using the API
    Then the withdrew request from the iOS app was "approve" by Arch user

@I9.9 @I-IncentiveNetworks @I-Wallet @iOS
Scenario: (incentive_networks) Approved cashback -> Approved Withdrew to Paypal account using the Native app -> Approved withdrew. (API, Native app)
    Given I am on the iOS Menu screen
    When I click from the iOS Menu screen "Wallet"
    Then the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I am on the iOS Wallet screen
    When I purchased product from the iOS Shop Online using "incentive networks" for "100" pounds and I get "10" pounds cashback and I "expect" to double cashback
    Then I ask for cashback from the iOS app
    And I request to withdrew from the iOS app to the "Paypal" account
    And the withdrew request from the iOS app was "approve" using the API

@I9.10 @I-IncentiveNetworks @I-Wallet @iOS
Scenario: (incentive_networks) Approved cashback -> Approved withdrew request to Bank account using the Native app -> Approved withdrew by API user. (API, Native app)
    Given I am on the iOS Menu screen
    When I click from the iOS Menu screen "Wallet"
    Then the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I am on the iOS Wallet screen
    When I purchased product from the iOS Shop Online using "incentive networks" for "100" pounds and I get "10" pounds cashback and I "expect" to double cashback
    Then I ask for cashback from the iOS app
    And I request to withdrew from the iOS app to the "Bacs" account
    And the withdrew request from the iOS app was "approve" using the API

@I9.11 @I-IncentiveNetworks @I-Wallet @iOS
Scenario: (incentive_networks) Approved cashback -> Decline withdrew by API -> Approve withdrew by API. (API)
    Given I am on the iOS Menu screen
    When I click from the iOS Menu screen "Wallet"
    Then the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I am on the iOS Wallet screen
    When I purchased product from the iOS Shop Online using "incentive networks" for "100" pounds and I get "10" pounds cashback and I "expect" to double cashback
    Then I ask for cashback from the iOS app
    And I request to withdrew from the iOS app to my "Paypal" using the API
    And the withdrew request from the iOS app was "decline" using the API
    
    Then I request to withdrew from the iOS app to my "Paypal" using the API
    And the withdrew request from the iOS app was "approve" using the API

@I9.12 @I-IncentiveNetworks @I-Wallet @iOS
Scenario: (incentive_networks) Decline Cashback by API -> Raise clime. (API) 
    Given I am on the iOS Menu screen
    When I click from the iOS Menu screen "Wallet"
    Then the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I am on the iOS Wallet screen
    When I purchased product from the iOS Shop Online using "incentive networks" for "100" pounds and I get "10" pounds cashback and I "expect" to double cashback
    Then I ask for cashback from the iOS app and it was declined
    And I raise claim from the iOS app

@I9.13 @I-IncentiveNetworks @I-Wallet @iOS
Scenario: (incentive_networks) Cashback request of 1 pounds -> Declined withdrew -> Cashback request for 6 pounds -> Withdrew approved. (API, iOS app)
    Given I am on the iOS Menu screen
    When I click from the iOS Menu screen "Wallet"
    Then the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I am on the iOS Wallet screen
    When I purchased product from the iOS Shop Online using "incentive networks" for "2" pounds and I get "0.5" pounds cashback and I "expect" to double cashback
    Then I ask for cashback from the iOS app
    And I request to withdrew from the iOS app to the "Paypal" account
    And the withdrew request from the iOS app was decline

    When I purchased product from the iOS Shop Online using "incentive networks" for "2" pounds and I get "0.5" pounds cashback and I "expect" to double cashback
    Then I ask for cashback from the iOS app
    And I request to withdrew from the iOS app to the "Bank" account
    And the withdrew request from the iOS app was decline

    When I purchased product from the iOS Shop Online using "incentive networks" for "2" pounds and I get "2.5" pounds cashback and I "expect" to double cashback
    Then I ask for cashback from the iOS app
    And I request to withdrew from the iOS app to my "Paypal" using the API
    And the withdrew request from the iOS app was "approve" using the API

@I9.42 @server @I-Wallet @iOS
Scenario: (incentive_networks) Cashback request of 6 pounds -> Withdrew Automatic. (Server, API)
    Given I am on the iOS Menu screen
    When I click from the iOS Menu screen "Wallet"
    Then the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I am on the iOS Wallet screen
    When I purchased product from the iOS Shop Online using "incentive networks" for "10" pounds and I get "4" pounds cashback and I "expect" to double cashback
    Then I ask for cashback from the iOS app
    When the money was withdrew automatically to the iOS app
    And the withdrew request from the iOS app was "approve" using the API

@I9.43 @I-Wallet @Web @Arch @iOS @Smoke @Regression
Scenario Outline: Manual credit user by Arch
    Given I am on the iOS Menu screen
    When I click from the iOS Menu screen "Wallet"
    Then I am on the iOS Wallet screen

 
    And I request to withdrew from the iOS app to my "Paypal" using the API
    And the withdrew request from the iOS app "approve" by Arch user

    #TODO: to remove currency_name
    Examples:
    |user       |amount|currency_name|
    |user0 user0|10    |GPB          |