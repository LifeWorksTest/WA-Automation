Feature:	
	1. Purchase cinema ticket
	
@I14.1 @I-Cinemas @iOS @Smoke @Regression @Web
Scenario Outline: Create a Cinema on Arch, upload tickets and complete purchase journey on the iOS app
  	Given I am on Arch Login screen
  	When I login to Arch
  	Then I click on "Cinemas" from Left menu
  	Given I am on the Cinemas screen

	When I create a new Cinema with the name "<cinema_name>" with ticket types "<ticket_type_1>,<ticket_type_2>" and location "<cinema_location>"
	Then I upload "<amount_to_select_1>" "<ticket_type_1>" tickets to the code stock page 
	And I upload "<amount_to_select_2>" "<ticket_type_2>" tickets to the code stock page 
	And I logout from Arch

	Given I login to LifeWorks from the iOS app
    Then I click "Perks" from the iOS Menu Tab    
    Then I am on the iOS Perks Home page
    Then I navigate to iOS "Cinemas" screen from iOS Perks Home page

	Given I am on the iOS Cinemas screen
	Then I purchase "<amount_to_select_1>" "<ticket_type_1>" and "<amount_to_select_2>" "<ticket_type_2>" "<cinema_name>" tickets at "<cinema_location>" cinema branch
  Then I recived an email with the subject "your_lifeWorks_cinema_discount_codes"
  Then the email should contain "<amount_to_select_1>" "<ticket_type_1>" ticket codes
  And the email should contain "<amount_to_select_2>" "<ticket_type_2>" ticket codes 

 	Examples:
 	|cinema_name |cinema_location|ticket_type_1|amount_to_select_1|ticket_type_2|amount_to_select_2|
 	|lifeworks_uk|all	         |adult_2d     |4	      	      |child_2d     |5                 |