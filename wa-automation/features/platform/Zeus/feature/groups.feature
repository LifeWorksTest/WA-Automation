Feature:
1. Admin create new group and add user -> User login to Web and validate that he is part of the new group -> Admin archive group -> User login to Web and validate that he is not part of the new group.  In addition validate the groups counters.
2.Admin create new group and add user -> Admin update group name -> User login to Web and validate that he is part of the new group -> Admin archive group -> User login to Web and validate that he is not part of the new group.  In addition validate the groups counters.
3. Admin create new group and add user -> User login to Web and validate that he is part of the new group -> Admin archive and delete group -> User login to Web and validate that he is not part of the new group.  In addition validate the groups counters.

@Z11.1 @Z-Groups @Web @Zeus @headless_zeus @Regression @Production_Smoke @NotParallel @WEB-6373 @WEB-6784
Scenario: Admin create new group and add user -> User login to Web and validate that he is part of the new group -> Admin archive group -> User login to Web and validate that he is not part of the new group.  In addition validate the groups counters.

	Given the Arch user "Enabled" Grouping feature key and set it to be managed by "Admin"

	Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "Groups" from the "Colleagues" Zeus Top Bar menu

    Given I am on the Admin Panel Groups screen
    When I create new group
    And I logout from Admin Panel

    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App

    Given I am on the News Feed screen
    When I validate that the current user "belong" to the latest group
	Then I click "Logout" from the "Global Action" menu

	Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "Groups" from the "Colleagues" Zeus Top Bar menu

    Given I am on the Admin Panel Groups screen
    When I "archive" the lestest group
   	Then I logout from Admin Panel

   	Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App

    Given I am on the News Feed screen
    When I validate that the current user "not belong" to the latest group
	Then I click "Logout" from the "Global Action" menu

    And the Arch user "Disabled" Grouping feature key and set it to be managed by "Admin"

@Z11.2 @Z-Groups @Web @Zeus @headless_zeus @Regression @Production_Smoke @NotParallel @WEB-6373 @WEB-6784
Scenario: Admin create new group and add user -> Admin update group name -> User login to Web and validate that he is part of the new group -> Admin archive group -> User login to Web and validate that he is not part of the new group.  In addition validate the groups counters.

	Given the Arch user "Enabled" Grouping feature key and set it to be managed by "Admin"

	Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "Groups" from the "Colleagues" Zeus Top Bar menu

    Given I am on the Admin Panel Groups screen
    When I create new group
    Then I "update" the lateset group name
    And I logout from Admin Panel

    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App

    Given I am on the News Feed screen
    When I validate that the current user "belong" to the latest group
	Then I click "Logout" from the "Global Action" menu

    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "Groups" from the "Colleagues" Zeus Top Bar menu

    Given I am on the Admin Panel Groups screen
    When I "archive" the lestest group
   	Then I logout from Admin Panel

   	Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App

    Given I am on the News Feed screen
    When I validate that the current user "not belong" to the latest group
	Then I click "Logout" from the "Global Action" menu

    And the Arch user "Disabled" Grouping feature key and set it to be managed by "Admin"

@Z11.3 @Z-Groups @Web @Zeus @headless_zeus @Smoke @Regression @Production_Smoke @NotParallel @WEB-6373 @WEB-6784
Scenario: Admin create new group and add user -> User login to Web and validate that he is part of the new group -> Admin archive and delete group -> User login to Web and validate that he is not part of the new group.  In addition validate the groups counters.

    Given the Arch user "Enabled" Grouping feature key and set it to be managed by "Admin"

    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "Groups" from the "Colleagues" Zeus Top Bar menu

    Given I am on the Admin Panel Groups screen
    When I create new group
    And I logout from Admin Panel

    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App

    Given I am on the News Feed screen
    When I validate that the current user "belong" to the latest group
    Then I click "Logout" from the "Global Action" menu

    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "Groups" from the "Colleagues" Zeus Top Bar menu

    Given I am on the Admin Panel Groups screen
    Then I "archive" the lestest group
    And I "delete" the lestest group
   	Then I logout from Admin Panel

    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App

    Given I am on the News Feed screen
    When I validate that the current user "not belong" to the latest group
    Then I click "Logout" from the "Global Action" menu
    And the Arch user "Disabled" Grouping feature key and set it to be managed by "Admin"