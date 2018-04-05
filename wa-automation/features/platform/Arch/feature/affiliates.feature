Feature:
	1. Create new campaign
	
# We cannot receive the email when the camppain is create as the arch user needs an @workivate email address	
@A2.1 @A-Affiliate @Web @Arch @headless_arch_arch
Scenario: Create new campaign
	Given I am on Arch Login screen
	When I login to Arch
	Then I click on "Affiliates" from Left menu
	Given I am on Affiliates screen
	When I create new affiliate 
	Then I create new campaign
	And I recived an email with the subject "new_campaign_notice"
	And I logout from Arch

