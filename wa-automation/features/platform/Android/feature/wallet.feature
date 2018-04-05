Feature:
    3. (incentive_networks) Approved cashback -> Approved withdrew. (API)
    4. (incentive_networks) Approved cashback -> Declined withdraw -> Approve withdrew by Arch user. (API, Arch)
    5. (incentive_networks) Cashback request of 1 pounds -> Declined withdrew -> Cashback request for 6 pounds -> Withdrew approved. (API)
    6. (incentive_networks) Approved cashback request for £100 spent-> Approved withdrew -> Cashback request without expecting to get double cashback -> Approve withdrew. (API)
    7. (incentive_networks) Approved cashback -> Approved withdrew by Arch user. (API, Arch)
    8. (incentive_networks) Approved cashback -> Declined withdrew by Arch user -> Approved withdrew by Arch user. (API, Arch)
    9. (incentive_networks) Approved cashback -> Approved Withdrew to Paypal account using the Android app -> Approved withdrew. (API, Android app Arch)
    10.(incentive_networks) Approved cashback -> Approved withdrew request to Bank account using the Android app -> Approved withdrew by Arch user. (API, Android app Arch)
    11. (incentive_networks) Approved cashback -> Decline withdrew by API -> Approve withdrew by API. (API)
    12. (incentive_networks) Decline Cashback by API -> Raise clime. (API) 
    13. (incentive_networks) Cashback request of 1 pounds -> Declined withdrew -> Cashback request for 6 pounds -> Withdrew approved. (API, Android app)
    42.  (incentive_networks) Cashback request of 6 pounds -> Withdrew Automatic. (Android, Server, API)


@AN9.3 @AN-IncentiveNetworks @AN-Wallet @Android
Scenario Outline: (incentive_networks) Approved cashback -> Approved withdrew. (API)
    Given I am on the Android Menu screen
    When I click from the Menu screen "Wallet"
    Then the company feature for "Base Incentive Networks" changed to "<base>"
    And the company feature for "Bonus Incentive Networks" changed to "<bonus>"
    And I click on the "retailer" link

    Given I am on the Android Wallet screen
    When I purchased product from the Android Shop Online using "incentive networks" for "<purchased_amount>" pounds and I get "<cashback_amount>" pounds cashback and I "<double_cashback>" to double cashback
    Then I ask for cashback from the Android app
    And I request to withdrew from the Android app to my "Paypal" using the API
    And the withdrew request from the Android app was "approve" using the API

    Examples:
    |base|bonus|purchased_amount|cashback_amount|double_cashback      |
    |1   |1    |0               |3              |expect               |
    |1   |0    |10              |6              |dont expect          |

@AN9.4 @incentive_networks @AN-Wallet @Web @Android
Scenario: (incentive_networks) Approved cashback -> Declined withdraw -> Approve withdrew by Arch user. (API, Arch)
    Given I am on the Android Menu screen
    When I click from the Menu screen "Wallet"
    Then the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I am on the Android Wallet screen
    When I purchased product from the Android Shop Online using "incentive networks" for "100" pounds and I get "5" pounds cashback and I "expect" to double cashback
    Then I ask for cashback from the Android app
    And I request to withdrew to my "Paypal" using the API
    And the withdrew request from the Android app was "decline" by Arch user

    Then I request to withdrew to my "Paypal" using the API
    And the withdrew request from the Android app was "approve" by Arch user

@AN9.5 @AN-IncentiveNetworks @AN-Wallet @Android
Scenario: (incentive_networks) Cashback request of 1 pounds -> Declined withdrew -> Cashback request for 6 pounds -> Withdrew approved. (API)
    Given I am on the Android Menu screen
    When I click from the Menu screen "Wallet"
    Then the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I am on the Android Wallet screen
    When I purchased product from the Android Shop Online using "incentive networks" for "2" pounds and I get "1" pounds cashback and I "expect" to double cashback
    Then I ask for cashback from the Android app
    And I request to withdrew from the Android app to my "Paypal" using the API
    And the withdrew request from the Android app was decline

    When I purchased product from the Android Shop Online using "incentive networks" for "2" pounds and I get "2" pounds cashback and I "expect" to double cashback
    Then I ask for cashback from the Android app
    And I request to withdrew from the Android app to my "Paypal" using the API
    And the withdrew request from the Android app was "approve" using the API

@AN9.6 @AN-IncentiveNetworks @AN-Wallet @Android
Scenario: (incentive_networks) Approved cashback request for £100 spent-> Approved withdrew -> Cashback request without expecting to get double cashback -> Approve withdrew. (API)
    Given I am on the Android Menu screen
    When I click from the Menu screen "Wallet"
    Then the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I am on the Android Wallet screen
    When I purchased product from the Android Shop Online using "incentive networks" for "100" pounds and I get "10" pounds cashback and I "expect" to double cashback
    When I ask for cashback from the Android app
    Then I request to withdrew from the Android app to my "Paypal" using the API
    And the withdrew request from the Android app was "approve" using the API
    And I reset time to be as before the change in the Android app

    Given I purchased product from the Android Shop Online using "incentive networks" for "10" pounds and I get "10" pounds cashback and I "dont expect" to double cashback
    When I ask for cashback from the Android app
    Then I request to withdrew from the Android app to my "Paypal" using the API
    And the withdrew request from the Android app was "approve" using the API

@AN9.7 @AN-IncentiveNetworks @AN-Wallet @Web @Android
Scenario: (incentive_networks) Approved cashback -> Approved withdrew by Arch user. (API, Arch)
    Given I am on the Android Menu screen
    When I click from the Menu screen "Wallet"
    Then the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I am on the Android Wallet screen
    When I purchased product from the Android Shop Online using "incentive networks" for "10" pounds and I get "5" pounds cashback and I "expect" to double cashback
    When I ask for cashback from the Android app
    Then I request to withdrew from the Android app to my "Paypal" using the API
    And the withdrew request from the Android app was "approve" by Arch user


@AN9.8 @AN-IncentiveNetworks @AN-Wallet @Web @Android
Scenario: (incentive_networks) Approved cashback -> Declined withdrew by Arch user -> Approved withdrew by Arch user. (API, Arch)
    Given I am on the Android Menu screen
    When I click from the Menu screen "Wallet"
    Then the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I am on the Android Wallet screen
    When I purchased product from the Android Shop Online using "incentive networks" for "100" pounds and I get "10" pounds cashback and I "expect" to double cashback
    When I ask for cashback from the Android app
    Then I request to withdrew from the Android app to my "Paypal" using the API
    And the withdrew request from the Android app was "decline" by Arch user

    When I request to withdrew from the Android app to my "Paypal" using the API
    Then the withdrew request from the Android app was "approve" by Arch user

@AN9.9 @AN-IncentiveNetworks @AN-Wallet @Web @Android
Scenario: (incentive_networks) Approved cashback -> Approved Withdrew to Paypal account using the Android app -> Approved withdrew. (API, Android app Arch)
    Given I am on the Android Menu screen
    When I click from the Menu screen "Wallet"
    Then the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I am on the Android Wallet screen
    When I purchased product from the Android Shop Online using "incentive networks" for "100" pounds and I get "10" pounds cashback and I "expect" to double cashback
    Then I ask for cashback from the Android app
    And I request to withdrew from the Android app to the "Paypal" account
    And the withdrew request from the Android app was "approve" by Arch user

@AN9.10 @AN-IncentiveNetworks @AN-Wallet @Web @Android
Scenario: (incentive_networks) Approved cashback -> Approved withdrew request to Bank account using the Android app -> Approved withdrew by Arch user. (API, Android app Arch)
    Given I am on the Android Menu screen
    When I click from the Menu screen "Wallet"
    Then the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I am on the Android Wallet screen
    When I purchased product from the Android Shop Online using "incentive networks" for "100" pounds and I get "10" pounds cashback and I "expect" to double cashback
    Then I ask for cashback from the Android app
    And I request to withdrew from the Android app to the "Bacs" account
    And the withdrew request from the Android app was "approve" by Arch user

@AN9.11 @AN-IncentiveNetworks @AN-Wallet @Android
Scenario: (incentive_networks) Approved cashback -> Decline withdrew by API -> Approve withdrew by API. (API)
    Given I am on the Android Menu screen
    When I click from the Menu screen "Wallet"
    Then the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I am on the Android Wallet screen
    When I purchased product from the Android Shop Online using "incentive networks" for "100" pounds and I get "10" pounds cashback and I "expect" to double cashback
    Then I ask for cashback from the Android app
    And I request to withdrew from the Android app to my "Paypal" using the API
    And the withdrew request from the Android app was "decline" using the API
    
    Then I request to withdrew from the Android app to my "Paypal" using the API
    And the withdrew request from the Android app was "approve" using the API

@AN9.12 @AN-IncentiveNetworks @AN-Wallet @Android
Scenario: (incentive_networks) Decline Cashback by API -> Raise clime. (API) 
    Given I am on the Android Menu screen
    When I click from the Menu screen "Wallet"
    Then the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I am on the Android Wallet screen
    When I purchased product from the Android Shop Online using "incentive networks" for "100" pounds and I get "10" pounds cashback and I "expect" to double cashback
    Then I ask for cashback from the Android app and it was declined
    And I raise claim from the Android app

@AN9.13 @AN-IncentiveNetworks @AN-Wallet @Android
Scenario: (incentive_networks) Cashback request of 1 pounds -> Declined withdrew -> Cashback request for 6 pounds -> Withdrew approved. (API, Android app)
    Given I am on the Android Menu screen
    When I click from the Menu screen "Wallet"
    Then the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I am on the Android Wallet screen
    When I purchased product from the Android Shop Online using "incentive networks" for "2" pounds and I get "0.5" pounds cashback and I "expect" to double cashback
    Then I ask for cashback from the Android app
    And I request to withdrew from the Android app to the "Paypal" account
    And the withdrew request from the Android app was decline

    When I purchased product from the Android Shop Online using "incentive networks" for "2" pounds and I get "3" pounds cashback and I "expect" to double cashback
    Then I ask for cashback from the Android app
    And I request to withdrew from the Android app to the "Paypal" account
    And the withdrew request from the Android app was "approve" using the API

@AN9.42 @server @AN-Wallet @Android
Scenario: (incentive_networks) Cashback request of 6 pounds -> Withdrew Automatic. (Android, Server, API)
    Given I am on the Android Menu screen
    When I click from the Menu screen "Wallet"
    Then the company feature for "Base Incentive Networks" changed to "1"
    And the company feature for "Bonus Incentive Networks" changed to "1"
    And I click on the "retailer" link

    Given I am on the Android Wallet screen
    When I purchased product from the Android Shop Online using "incentive networks" for "10" pounds and I get "3" pounds cashback and I "expect" to double cashback
    When the money was withdrew automatically
    And the withdrew request was "approve" by Arch user
