Feature:
	1. Arch user add reward budget -> Admin give reward -> Colleague redeem reward

@Z10.1 @Z-Rewards @Web @Zeus @headless_zeus @Bug
#Unable to run this test on Test Env as it connects to the production SVM servers
Scenario Outline: Arch user add reward budget to a company and then the Admin give reward to a colleague
	#Given the admin set the remaining rewards budget
	#When the Arch user "Add" "10" pounds as reward to this company
	#Then the admin give "10" pounds reward to "user1 user1"

	#And the admin validate that this data is in the first line of the historic rewards table: "<receiving user>" "<admin user>" "<amount>" "<status>"
	#And the Arch user validate that this data is in the first line of the historic rewards table: "<admin user>" "<receiving user>" "<amount>" 
	

	Given I am on the Web App Login screen
   	When I login to Web App with the next user "lifeworkstesting+uk1@lifeworks.com"
    Then I am login to Web App
    And I click "Rewards" from the "Global Action" menu
	
	And "<receiving user>" redeem the "<amount>" pounds reward buying "<retailer>"
   	And the user validate that the following reward is visible in the redeemed list "<amount>" pounds reward buying "<retailer>"

   	And the Arch user validate that this data is in the first line of the historic rewards table after update: "<receiving user>" "<receiving user>" "<amount>" "<retailer>" "<provider>"
   	And the admin validate that this data is in the first line of the historic rewards table: "<receiving user>" "<admin user>" "<amount>" "redeemed"
	Examples:
        |receiving user|admin user |amount|status|retailer|provider|
		|user1 user1   |user0 user0|10    |issued|Amazon  |SVM     |