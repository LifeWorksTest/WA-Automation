Feature:
@E1 @Web
Scenario Outline: User is recognised by a colleague

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Give Recognition" from News Feed screen
    Then I give this recognition "Good work!!" badge "Creative" to "<reciver_name>"
    And I recived an email with the subject "<email_subject>"
    And I logout from Web App

    Examples:
        |sender_email               |reciver_name|email_subject         |
        |lifeworkstesting@lifeworks.com |eliran 1    |You've_been_recognised|


@E2 @Web
Scenario Outline: User is tagged in a recognition post
                 
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Write New Post" from News Feed screen
    Then I write mention post "Great work" and I mention "<users_to_mention>"
    And I recived an email with the subject "<email_subject>"
    And I logout from Web App

    Examples:
        |sender_email               |users_to_mention|email_subject                      |
        |lifeworkstesting@lifeworks.com |eliran 1        |You've_been_mentioned_in_a_new_post|

    
@E3 @Web
Scenario Outline: Colleague comments on a post the user has created

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Write New Post" from News Feed screen
    Then I write this post "Hello all"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Welcome" to post index "0"
    Then I recived an email with the subject "<email_subject>"
    And I logout from Web App


    Examples:
        |sender_email              |second_email_user           |email_subject             |
        |lifeworkstesting@lifeworks.com|lifeworkstesting+01@lifeworks.com|has commented on your post|


@E4 @Web
Scenario Outline: Colleague comments on the user's post that they have also commented on

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Write New Post" from News Feed screen
    Then I write this post "Hello all"
    And I give this comment "Thank you" to post index "0"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Welcome" to post index "0"
    Then I recived an email with the subject "<email_subject>"
    And I logout from Web App

    Examples:
        |sender_email              |second_email_user            |email_subject                  |
        |lifeworkstesting@lifeworks.com|lifeworkstesting+01@lifeworks.com|has also commented on your post|

@E5 @Web
Scenario Outline: Colleague comments on a post the user has also commented on

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Write New Post" from News Feed screen
    Then I write this post "Hello all"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Welcome" to post index "0"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<third_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Welcome" to post index "0"
    Then I recived an email with the subject "<email_subject>"
    And I logout from Web App


    Examples:
        |sender_email              |second_email_user            |third_email_user             |email_subject                     |
        |lifeworkstesting@lifeworks.com|lifeworkstesting+01@lifeworks.com|lifeworkstesting+02@lifeworks.com|.* has also commented on .*'s post|

@E6 @Web
Scenario Outline: Colleague also comments on their own post after the user has commented on it

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Write New Post" from News Feed screen
    Then I write this post "Hello all"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Welcome" to post index "0"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Welcome" to post index "0"
    Then I recived an email with the subject "<email_subject>"
    And I logout from Web App


    Examples:
        |sender_email              |second_email_user            |email_subject                   |
        |lifeworkstesting@lifeworks.com|lifeworkstesting+01@lifeworks.com|has also commented on their post|

@E7 @Web
Scenario Outline: User has entered email address and clicked forgotten password from forgotten password screen
    Given I am on the Web App Login screen
    When I reset my password with valid email "<email_to_reset>" and invalid email
    Then I recived an email with the subject "<email_subject>"
    And I am on the Web App Login screen


    Examples:
        |email_to_reset               |email_subject                  |
        |lifeworkstesting+01@lifeworks.com|Your forgotten password request|

@E8 @Web
Scenario Outline: User has been deactivated and reactivatedby the admin
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    
    Given I am on the Dashboard
    Then I click on "Colleagues" from Top Bar menu
    
    Given I am on the Employees screen
    When I click on "Active colleagues" from Employees screen
    Then I open user profile name "<user_name>"

    Given I am on the User Profile screen
    When I "deactivate" a user
    Then I click on "Colleagues" from Top Bar menu
    And I recived an email with the subject "<email_subject_deactivated>"

    When I click on "Archived" from Employees screen
    Then I open user profile name "<user_name>"
    And I "reactivate" a user
    And I recived an email with the subject "<email_subject_reactivated>"
    And I logout from Admin Panel

    Examples:
        |user_name       |email_subject_deactivated        |email_subject_reactivated        |
        |user112 user112 |Your account has been deactivated|Your account has been reactivated|

@E9 @Web
Scenario Outline: Admin post is created and selected to notify all users
    Given I am on the Admin Panel Login screen
    When I insert valid email and password
    Then I am login to Admin Panel

    Given I am on the Dashboard
    When I click on "Timeline" from Top Bar menu

    Given I am on the Timeline screen
    When I send this post from Timeline "<post_text>"
    Then I check that this post "<post_text>" is first in timeline
    And I recived an email with the subject "<email_subject>"
    And I logout from Admin Panel

    Examples:
        |post_text|email_subject_deactivated        |email_subject                |
        |Good day |Your account has been deactivated|New_post_from_.*_on_workangel|

@E10 @Web
Scenario: Admin reminds the user about pending invitation
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel
    And I click on "Employees" from Top Bar menu

    Given I am on the Employees screen
    When I "Remind" to user index "0" in Pending
    Then I recived an email with the subject "You haven't signed up to LifeWorks yet!" in the email account
    And I logout from Admin Panel

@E11 @Web
Scenario: Change user profile and make sure that the change as been saved
    Given I am on the Admin Panel Login screen
    When I insert valid email and password
    Then I am login to Admin Panel

    Given I am on the Dashboard
    Then I click on "Employees" from Top Bar menu
    
    Given I am on the Employees screen
    When I click on "Active employees" from Employees screen
    Then I open user profile index "1"

    Given I am on the User Profile screen
    When  I change the user profile to "user1"
    Then I check that the user profile as change to "user1"
    And I recived an email with the subject "Your workangel™ profile has been edited by the network administrator" in the email account

    When I change the user profile to "user2"
    Then I check that the user profile as change to "user2"
    And I recived an email with the subject "Your workangel™ profile has been edited by the network administrator" in the email account

@E12 @Web
Scenario:
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App

    Given I am on the News Feed screen
    When I validate that the News Feed contains "Monthly recognition results published" post
    Then I recived an email with the subject "You're a top performer!"
    And I recived an email with the subject "You're a top performer!"
    And I recived an email with the subject "You're a top performer!"
    And I recived an email with the subject "top performers at"
    Then I click "Logout" from the "Global Action" menu




