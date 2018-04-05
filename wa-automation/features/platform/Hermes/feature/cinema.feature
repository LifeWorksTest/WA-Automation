Feature:
    1. Cinema creation -> Location Creation -> Ticket Type Creation -> CSV upload -> Ticket purchase -> Transaction verification(order summary, email, arch) -> Cinema/ticket deletion

@H16.1 @H-Cinemas @Web @Hermes @Smoke @NotParallel @Not_CA @Not_US @RA-8758 @RA-9497 
Scenario Outline: Cinema creation -> Location Creation -> Ticket Type Creation -> CSV upload -> Ticket purchase -> Transaction verification(order summary, email, arch) -> Cinema/ticket deletion
  
  Given I log into Arch and navigate to the Cinema screen
  When I create a new Cinema with the name "<cinema_name>" with ticket types "<ticket_type_1>,<ticket_type_2>" and location "<cinema_location>"
  Then I upload "<amount_to_select_1>" "<ticket_type_1>" tickets to the code stock page 
  And I upload "<amount_to_select_2>" "<ticket_type_2>" tickets to the code stock page 
  And I logout from Arch

  Given I navigate to the Web App Cinema screen using a "<user_type>" account and select the new Cinema
  When I select "<cinema_location>" from the select Cinema ticket page
  Then I add "<amount_to_select_1>" "<ticket_type_1>" Cinema tickets to my order
  And I add "<amount_to_select_2>" "<ticket_type_2>" Cinema tickets to my order
  
  Given I successfully pay for the Cinema tickets I have selected and verify the confirmation email
  When the email should contain "<amount_to_select_1>" "<ticket_type_1>" ticket codes
  And the email should contain "<amount_to_select_2>" "<ticket_type_2>" ticket codes 
  Then I verify that I cannot purchase tickets for "<ticket_type_1>,<ticket_type_2>" as they are out of stock
  And I verify that the View your Cinema Codes link contains the purchased ticket codes
  And  I click "Logout" from the "Global Action" menu

  # Given I log into Arch and navigate to the Cinema screen
  # # And I verify the transaction is correctly displayed in Arch
  # When I delete "<ticket_type_1>,<ticket_type_2>" ticket types in Arch
  # Then I delete the newly created Cinema in Arch
  # And I logout from Arch
 	
 	Examples:
 	|user_type|cinema_name |cinema_location|ticket_type_1|amount_to_select_1|ticket_type_2|amount_to_select_2|
 	|personal |lifeworks_uk|all	           |adult_2d     |4	      	        |child_2d     |5                 |
  |limited  |lifeworks_uk|all            |adult_2d     |4                 |child_2d     |5                 |