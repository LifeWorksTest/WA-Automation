Feature:

@N1 @Web
Scenario Outline: (run before this script @Admin2.1)
                  Colleague welcomes a new user
                  2 colleagues wecome a new user
                  3 or more colleagues wecome a new user

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<user_email>"
    Then I am login to Web App
    
    Given I am on the News Feed screen
    When I welcomes a new user
    And I logout from Web App
    
    Given I am on the Web App Login screen
    When I login to Web App with the latest new user
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App
    
    Examples:
        |user_email                    |notification                           |
        |lifeworkstesting+1@lifeworks.com |.* has welcomed you to .*               |
        |lifeworkstesting+2@lifeworks.com |.* and .* have welcomed you to .*       |
        |lifeworkstesting+3@lifeworks.com |.* and .* others have welcomed you to .*|
    

@N2 @Web
Scenario Outline: (run before this script @Admin2.1)
                  Colleague comments on new user post
                  2 colleagues comment on new user post
                  3 or more colleagues comment on new user post

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<user_email>"
    Then I am login to Web App
    
    Given I am on the News Feed screen
    When I give this comment "Welcome" to post index "0"
    Then I logout from Web App
    
    Given I am on the Web App Login screen
    When I login to Web App with the latest new user
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App
    
    Examples:
        |user_email                    |notification                                              |
        |lifeworkstesting+1@lifeworks.com |.* has commented on your welcome post: ".*"               |
        |lifeworkstesting+2@lifeworks.com |.* and .* have commented on your welcome post: ".*"       |
        |lifeworkstesting+3@lifeworks.com |.* and .* others have commented on your welcome post: ".*"|

@N3 @Web
Scenario Outline: (run before this script @N2)
                  New user comments on their own welcome post follwoing colleague comments
    
    Given I am on the Web App Login screen
    When I login to Web App with the latest new user
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Hallo every one" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<user_email>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

 Examples:
        |user_email                    |notification                                     |
        |lifeworkstesting+1@lifeworks.com |.* has also commented on their welcome post: ".*"|


@N4 @Web
Scenario Outline: Colleague comments on new user post
                  2 colleagues comment on new user post
                  3 or more colleagues comment on new user post

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App
    
    Given I am on the News Feed screen
    When I click "Give Recognition" from News Feed screen
    Then I give this recognition "Good work!!" badge "Creative" to "<reciver_name>"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<reciver_email>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App
    
    Examples:
        |sender_email               |reciver_email                 |reciver_name               |notification                                          |
        |lifeworkstesting@lifeworks.com |lifeworkstesting+1@lifeworks.com |user1                   |.* has given you recognition for .*: ".*"             | 
        |lifeworkstesting@lifeworks.com |lifeworkstesting+1@lifeworks.com |user1,user2          |.* has given you and .* recognition for .*: ".*"      | 
        |lifeworkstesting@lifeworks.com |lifeworkstesting+1@lifeworks.com |user1,user2,user3 |.* has given you and .* others recognition for .*: "*"| 

@N5 @Web
Scenario Outline: (Before running this scrift run @N4)
        Colleague comments on a post recognising the user
        2 colleagues comment on a post recognising the user
        3 or more colleagues comment on a post recognising the user

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App
    
    Given I am on the News Feed screen
    When I give this comment "@5 COMMENT" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<reciver_email>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App
    
    Examples:
        |sender_email                  |reciver_email                 |notification                                                    | 
        |lifeworkstesting@lifeworks.com    |lifeworkstesting+1@lifeworks.com |.* has commented on your recognition for .*: ".*"               |
        |lifeworkstesting+4@lifeworks.com |lifeworkstesting+1@lifeworks.com |.* and .* have commented on your recognition for .*: ".*"       |
        |lifeworkstesting+5@lifeworks.com |lifeworkstesting+1@lifeworks.com |.* and .* others have commented on your recognition for .*: ".*"|


@N6 @Web
Scenario Outline: Colleague comments on a recognition post created by the user
                  Colleague comments on a multiple recognition post created by the user
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App
    
    Given I am on the News Feed screen
    When I click "Give Recognition" from News Feed screen
    Then I give this recognition "Good work!!" badge "Creative" to "<reciver_name>"
    And I logout from Web App
    
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>"
    Then I am login to Web App
    
    Given I am on the News Feed screen
    When I give this comment "Good Work!!" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App
    
    Examples:
        |sender_email               |second_user_email             |reciver_name      |notification                                            | 
        |lifeworkstesting@lifeworks.com |lifeworkstesting+3@lifeworks.com |user1          |.* has commented on .*'s recognition for .*: ".*"       |
        |lifeworkstesting@lifeworks.com |lifeworkstesting+3@lifeworks.com |user1,user2 |.* has commented on .* and .*'s recognition for .*: ".*"|

@N7 @Web
Scenario Outline: 2 colleagues comment on a recognition post created by the user
                  2 colleagues comment on a multiple recognition post created by the user
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App
    
    Given I am on the News Feed screen
    When I click "Give Recognition" from News Feed screen
    Then I give this recognition "Good work!!" badge "Creative" to "<reciver_name>"
    And I logout from Web App
    
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>"
    Then I am login to Web App
    
    Given I am on the News Feed screen
    When I give this comment "Good Work" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<third_user_email>"
    Then I am login to Web App
    
    Given I am on the News Feed screen
    When I give this comment "Great Work" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App
    Examples:
        |sender_email               |second_user_email             |reciver_name      |third_user_email              |notification     |
        |lifeworkstesting@lifeworks.com |lifeworkstesting+2@lifeworks.com |user1          |lifeworkstesting+3@lifeworks.com |.* and .* have commented on .*'s recognition for .*: ".*"|
        |lifeworkstesting@lifeworks.com |lifeworkstesting+3@lifeworks.com |user1,user2 |lifeworkstesting+4@lifeworks.com |.* and .* have commented on .* and .*'s recognition for .*: ".*"|
       

@N8 @Web
Scenario Outline: 3 or more colleagues comment on a recognition post created by the user
                  3 or more colleagues comment on a multiple recognition post created by the user
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App
    
    Given I am on the News Feed screen
    When I click "Give Recognition" from News Feed screen
    Then I give this recognition "Good work!!" badge "Creative" to "<reciver_name>"
    And I logout from Web App
    
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<reciver_email>"
    Then I am login to Web App
    When I give this comment "Thank you" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<third_user_email>"
    Then I am login to Web App
    
    Given I am on the News Feed screen
    When I give this comment "Great work!!" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<fourth_user_email>"
    Then I am login to Web App
    When I give this comment "Great work!!" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples: 
        |sender_email               |reciver_email                 |reciver_name      |third_user_email              |fourth_user_email             |notification                                                           | 
        |lifeworkstesting@lifeworks.com |lifeworkstesting+1@lifeworks.com |user1          |lifeworkstesting+2@lifeworks.com |lifeworkstesting+3@lifeworks.com |.* and .* others have commented on .*'s recognition for .*: ".*"       |
        |lifeworkstesting@lifeworks.com |lifeworkstesting+1@lifeworks.com |user1,user2 |lifeworkstesting+2@lifeworks.com |lifeworkstesting+3@lifeworks.com |.* and .* others have commented on .* and .*'s recognition for .*: ".*"|
    
    
@N9 @Web
Scenario Outline: A colleague comments on a recognition post created by the user that the user has also commented on
                  Colleague comments on a multiple recognition post created by the user

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App
    
    Given I am on the News Feed screen
    When I click "Give Recognition" from News Feed screen
    Then I give this recognition "Good work :) !!" badge "Creative" to "<reciver_name>"
    And I give this comment "Thank you" to post index "0"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Thank you" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App
    
    Examples:
        |sender_email               |second_user_email             |reciver_name      |notification                                                 | 
        |lifeworkstesting@lifeworks.com |lifeworkstesting+2@lifeworks.com |user1          |.* has also commented .*'s recognition for .*: ".*"          |
        |lifeworkstesting@lifeworks.com |lifeworkstesting+3@lifeworks.com |user1,user2 |.* has also commented on .* and .*'s recognition for .*: ".*"|
    
@N10 @Web
Scenario Outline: 2 colleagues comment on a recognition post created by the user the user has also commented on
                  2 colleagues comment on a multiple recognition post created by the user

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App
    
    Given I am on the News Feed screen
    When I click "Give Recognition" from News Feed screen
    Then I give this recognition "Good work :) !!" badge "Creative" to "<reciver_name>"
    And I give this comment "Thank you" to post index "0"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Thank you" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<third_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Thank you" to post index "0"
    Then I logout from Web App


    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App
    
    Examples:
        |sender_email               |second_user_email             |third_user_email              |reciver_name      |notification                                                         |
        |lifeworkstesting@lifeworks.com |lifeworkstesting+4@lifeworks.com |lifeworkstesting+5@lifeworks.com |user1          |.* and .* have also commented .*'s recognition for .*: ".*"          |
        |lifeworkstesting@lifeworks.com |lifeworkstesting+4@lifeworks.com |lifeworkstesting+5@lifeworks.com |user1,user2 |.* and .* have also commented on .* and .*'s recognition for .*: ".*"|

@N11 @Web
Scenario Outline: 3 or more colleagues comment on a recognition post created by the user the user has also commented on
                  3 or more colleagues comment on a multiple recognition post created by the user

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App
    
    Given I am on the News Feed screen
    When I click "Give Recognition" from News Feed screen
    Then I give this recognition "Good work :) !!" badge "Creative" to "<reciver_name>"
    And I give this comment "Thank you" to post index "0"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Thank you" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<third_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Thank you" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<fourth_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Thank you" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App
    
    Examples:
        |sender_email               |second_user_email             |third_user_email              |fourth_user_email             |reciver_name      |notification                                                                |
        |lifeworkstesting@lifeworks.com |lifeworkstesting+3@lifeworks.com |lifeworkstesting+4@lifeworks.com |lifeworkstesting+5@lifeworks.com |user1          |.* and .* others have also commented .*'s recognition for .*: ".*"          |
        |lifeworkstesting@lifeworks.com |lifeworkstesting+3@lifeworks.com |lifeworkstesting+4@lifeworks.com |lifeworkstesting+5@lifeworks.com |user1,user2 |.* and .* others have also commented on .* and .*'s recognition for .*: ".*"|

@N12.0 @Web
Scenario Outline:(run before this script @Admin2.1)
    A colleague comments on a new user post

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<user_email>"
    Then I am login to Web App
    
    Given I am on the News Feed screen
    When I give this comment "Welcome 1" to post index "0"
    Then I logout from Web App

Examples:
    |user_email                |  
    |lifeworkstesting@lifeworks.com|

@N12 @Web
Scenario Outline: (run before this script @Admin2.0)
                  A colleague comments on a new user post the user has also commented on
                  2 colleagues comment on a new user post the user has also commented on
                  3 or more colleagues comment on a new user post the user has also commented on
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Welcome 2" to post index "0"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the latest new user
    Then I am login to Web App

    Given I am on the News Feed screen
    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App
    
    Examples:
        |user_email                 |second_user                   |notification                                                   |    
        |lifeworkstesting@lifeworks.com |lifeworkstesting+1@lifeworks.com |.* has also commented on .*'s welcome post: ".*"               |    
        |lifeworkstesting@lifeworks.com |lifeworkstesting+2@lifeworks.com |.* and .* have also commented on .*'s welcome post: ".*"       |
        |lifeworkstesting@lifeworks.com |lifeworkstesting+3@lifeworks.com |.* and .* others have also commented on .*'s welcome post: ".*"|

@N13 @Web
Scenario Outline: User is re-recognised by a colleague
                  User and a colleague are re-recognised by a colleague
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<first_user_email>"
    Then I am login to Web App
    
    Given I am on the News Feed screen
    When I click "Give Recognition" from News Feed screen
    Then I give this recognition "Good work!!" badge "Creative" to "<reciver_name>"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_eamil>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Re-recognise" from News Feed screen
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<reciver_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

     Examples:
        |first_user_email           |second_user_eamil             |reciver_email                 |reciver_name      |notification                                            |    
        |lifeworkstesting@lifeworks.com |lifeworkstesting+2@lifeworks.com |lifeworkstesting+1@lifeworks.com |user1        |.* and .* have given you recognition for .*: ".*"      |
        |lifeworkstesting@lifeworks.com |lifeworkstesting+2@lifeworks.com |lifeworkstesting+1@lifeworks.com |user1,user3 |.* and .* have given you and .* recognition for .*: ".*"|
        


@N14 @Web
Scenario Outline: User is re-recognised by 2 or more colleagues
                  User and 2 or more are re-recognised by 2 or more colleagues 
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<first_user_email>"
    Then I am login to Web App
    
    Given I am on the News Feed screen
    When I click "Give Recognition" from News Feed screen
    Then I give this recognition "Good work!!" badge "Creative" to "<reciver_name>"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_eamil>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Re-recognise" from News Feed screen
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<third_user_eamil>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Re-recognise" from News Feed screen
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<reciver_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

     Examples:
        |first_user_email           |second_user_eamil             |third_user_eamil              |reciver_email                 |reciver_name      |notification                                                          |    
        |lifeworkstesting@lifeworks.com |lifeworkstesting+2@lifeworks.com |lifeworkstesting+3@lifeworks.com |lifeworkstesting+1@lifeworks.com |user1          |.* and .* others have given you recognition for .*: ".*"              |     
        |lifeworkstesting@lifeworks.com |lifeworkstesting+3@lifeworks.com |lifeworkstesting+4@lifeworks.com |lifeworkstesting+1@lifeworks.com |user1,user2 |.* and .* others have given you and .* others recognition for .*: ".*"|     
     

@N15 @Web
Scenario Outline: A colleague comments on a recognition post the user has also commented on
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Give Recognition" from News Feed screen
    Then I give this recognition "Good work!!" badge "Creative" to "<reciver_name>"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<reciver_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Thank you" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Thank you" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<reciver_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
        |sender_email               |second_user_email             |reciver_email                 |reciver_name |notification                                          |    
        |lifeworkstesting@lifeworks.com |lifeworkstesting+2@lifeworks.com |lifeworkstesting+1@lifeworks.com |user1     |.* has also commented on your recognition for .*: ".*"|
    

@N16 @Web
Scenario Outline: 2 colleagues comment on a recognition post the user has also commented on
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Give Recognition" from News Feed screen
    Then I give this recognition "Good work!!" badge "Creative" to "<reciver_name>"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<reciver_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Thank you" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Thank you" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<third_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Thank you" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<reciver_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
        |sender_email               |second_user_email             |third_user_email              |reciver_email                 |reciver_name |notification                                          |    
        |lifeworkstesting@lifeworks.com |lifeworkstesting+2@lifeworks.com |lifeworkstesting+3@lifeworks.com |lifeworkstesting+1@lifeworks.com |user1     |.* and .* have also commented on your recognition for .*: ".*"|

@N17 @Web
Scenario Outline: 3 or more colleagues comment on a recognition post the user has also commented on
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Give Recognition" from News Feed screen
    Then I give this recognition "Good work!!" badge "Creative" to "<reciver_name>"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<reciver_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Thank you" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Thank you" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<third_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Thank you" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<fourth_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Thank you" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<reciver_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
        |sender_email               |second_user_email             |third_user_email              |fourth_user_email             |reciver_email                 |reciver_name |notification                                          |    
        |lifeworkstesting@lifeworks.com |lifeworkstesting+2@lifeworks.com |lifeworkstesting+3@lifeworks.com |lifeworkstesting+4@lifeworks.com |lifeworkstesting+1@lifeworks.com |user1     |.* and .* others have also commented on your recognition for .*: ".*"|
 
@N18  @Web
Scenario Outline: The user(s) who has been recognised comments on the post following colleague comments

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Give Recognition" from News Feed screen
    Then I give this recognition "Good work!!" badge "Creative" to "<reciver_name>"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Thank you" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<reciver_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Thank you" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
        |sender_email               |reciver_email                 |second_user_email            |reciver_name |notification                                           |
        |lifeworkstesting@lifeworks.com |lifeworkstesting+1@lifeworks.com |lifeworkstesting+2@lifeworks.com|user1       |.* has also commented on their recognition for .*: ".*"|

@N19 @Web
Scenario Outline: Colleague comments on a multiple recognition post created by the user

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Give Recognition" from News Feed screen
    Then I give this recognition "Good work!!" badge "Creative" to "<reciver_name>"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Great work" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
        |sender_email               |second_user_email             |reciver_name                |notification   |
        |lifeworkstesting@lifeworks.com |lifeworkstesting+4@lifeworks.com |user1,user2,user3|.* has commented on .* and .* other's recognition for .*: ".*"|

@N20 @Web
Scenario Outline: 2 colleagues comment on a multiple recognition post created by the user

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Give Recognition" from News Feed screen
    Then I give this recognition "Good work!!" badge "Creative" to "<reciver_name>"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Great work" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<third_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Great work" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
        |sender_email               |second_user_email             |third_user_email              |reciver_name                |notification   |
        |lifeworkstesting@lifeworks.com |lifeworkstesting+4@lifeworks.com |lifeworkstesting+5@lifeworks.com |user1,user2,user3|.* and .* have commented on .* other's recognition for .*: ".*"|

@N21 @Web
Scenario Outline: 3 or more colleagues comment on a multiple recognition post created by the user

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Give Recognition" from News Feed screen
    Then I give this recognition "Good work!!" badge "Creative" to "<reciver_name>"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Great work" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<third_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Great work" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<fourth_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Great work" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
        |sender_email               |second_user_email             |third_user_email              |fourth_user_email            |reciver_name                |notification                                              |
        |lifeworkstesting@lifeworks.com |lifeworkstesting+4@lifeworks.com |lifeworkstesting+5@lifeworks.com |lifeworkstesting+6@lifeworks.com|user1,user2,user3|.* and .* others have commented on .* and .* other's recognition for .*: ".*"|



@N22 @Web
Scenario Outline: Colleague comments on a multiple recognition post created by the user

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Give Recognition" from News Feed screen
    Then I give this recognition "Good work!!" badge "Creative" to "<reciver_name>"
    And I give this comment "Great work" to post index "0"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Great work" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
        |sender_email               |second_user_email             |reciver_name              |notification                                              |
        |lifeworkstesting@lifeworks.com |lifeworkstesting+4@lifeworks.com |user1,user2,user3|.* has also commented on .* and .* other's recognition for|

@N23 @Web
Scenario Outline: 2 colleagues comment on a multiple recognition post created by the user

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Give Recognition" from News Feed screen
    Then I give this recognition "Good work!!" badge "Creative" to "<reciver_name>"
    And I give this comment "Great work" to post index "0"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Great work" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<third_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Great work" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
        |sender_email               |second_user_email             |third_user_email          |reciver_name              |notification                                              |
        |lifeworkstesting@lifeworks.com |lifeworkstesting+4@lifeworks.com |lifeworkstesting+5@lifeworks.com |user1,user2,user3|.* and .* have also commented on .* and .* other's recognition for|

@N24 @Web
Scenario Outline: 3 or more colleagues comment on a multiple recognition post created by the user

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Give Recognition" from News Feed screen
    Then I give this recognition "Good work!!" badge "Creative" to "<reciver_name>"
    And I give this comment "Great work" to post index "0"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Great work" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<third_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Great work" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<fourth_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Great work" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
        |sender_email               |second_user_email             |third_user_email              |fourth_user_email             |reciver_name              |notification                                                  |
        |lifeworkstesting@lifeworks.com |lifeworkstesting+4@lifeworks.com |lifeworkstesting+5@lifeworks.com |lifeworkstesting+6@lifeworks.com |user1,user2,user3|.* and .* others have also commented on .* and .* other's recognition for .*: ".*"|

@N25 @Web
Scenario Outline: User is mentioned in a post
                  User and a colleagues is mentioned in a post
                  User and 2 colleagues or more are mentioned in a post
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Write New Post" from News Feed screen
    Then I write mention post "Great work" and I mention "<users_to_mention>"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<reciver_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
    |sender_email              |reciver_email                 |reciver_name              |notification                                 |
    |lifeworkstesting@lifeworks.com|lifeworkstesting+1@lifeworks.com |user1                  |.* has mentioned you in a post:              |
    |lifeworkstesting@lifeworks.com|lifeworkstesting+1@lifeworks.com |user1,user2         |.* has mentioned you and .* in a post:       |
    |lifeworkstesting@lifeworks.com|lifeworkstesting+1@lifeworks.com |user1,user2,user3|.* has mentioned you and .* others in a post:|

@N26 @Web
Scenario Outline: Colleague comments on a post the user has created

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Write New Post" from News Feed screen
    Then I write this post "Thank you all"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Great work" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
    |sender_email              |second_email_user             |notification                  |
    |lifeworkstesting@lifeworks.com|lifeworkstesting+1@lifeworks.com |.* has commented on your post:|

@N27 @Web
Scenario Outline: 2 colleagues comment on a post the user has created

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Write New Post" from News Feed screen
    Then I write this post "Thank you all"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<third_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
    |sender_email               |second_email_user             |third_email_user              |notification                               |
    |lifeworkstesting@lifeworks.com |lifeworkstesting+1@lifeworks.com |lifeworkstesting+2@lifeworks.com |.* and .* have commented on your post: ".*"|

@N28 @Web
Scenario Outline: 3 or more colleagues comment on a post the user has created

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Write New Post" from News Feed screen
    Then I write this post "Thank you all"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<third_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<fourth_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
    |sender_email              |second_email_user             |third_email_user             |fourth_email_user            |notification                  |
    |lifeworkstesting@lifeworks.com|lifeworkstesting+1@lifeworks.com |lifeworkstesting+2@lifeworks.com|lifeworkstesting+3@lifeworks.com|.* and .* others have commented on your post: ".*"|


@N29 @Web
Scenario Outline: Colleague comments on a post the user has also commented on

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Write New Post" from News Feed screen
    Then I write this post "Thank you all"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<third_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App


    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_email_user>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
    |sender_email              |second_email_user             |third_email_user             |notification                             |
    |lifeworkstesting@lifeworks.com|lifeworkstesting+1@lifeworks.com |lifeworkstesting+2@lifeworks.com| .* has also commented on .*'s post: ".*"|


@N30 @Web
Scenario Outline: 2 colleagues comment on a post the user has also commented on

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Write New Post" from News Feed screen
    Then I write this post "Thank you all"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<third_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<fourth_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_email_user>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
    |sender_email              |second_email_user             |third_email_user             |fourth_email_user  |notification                               |
    |lifeworkstesting@lifeworks.com|lifeworkstesting+1@lifeworks.com |lifeworkstesting+2@lifeworks.com|lifeworkstesting+4@lifeworks.com|.* and .* have also commented on .*'s post:|


@N31 @Web
Scenario Outline: 3 or more colleagues comment on a post the user has also commented on

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Write New Post" from News Feed screen
    Then I write this post "Thank you all"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<third_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<fourth_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
    |sender_email              |second_email_user             |third_email_user             |fourth_email_user            |notification                  |
    |lifeworkstesting@lifeworks.com|lifeworkstesting+1@lifeworks.com |lifeworkstesting+2@lifeworks.com|lifeworkstesting+3@lifeworks.com|.* and .* others have also commented on .*'s post:|


@N32 @Web
Scenario Outline: The autor of the post has also commented

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Write New Post" from News Feed screen
    Then I write this post "Thank you all"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_email_user>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
    |sender_email               |second_email_user             |notification                             |
    |lifeworkstesting@lifeworks.com |lifeworkstesting+1@lifeworks.com |.* has also commented on their post: ".*"|


@N33 @Web
Scenario Outline: Colleague comments on a post the user is mentioned in
                 
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Write New Post" from News Feed screen
    Then I write mention post "Great work" and I mention "<users_to_mention>"
    And I give this comment ":)" to post index "0"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<reciver_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
    |sender_email              |reciver_email                 |users_to_mention|notification                                                |
    |lifeworkstesting@lifeworks.com|lifeworkstesting+1@lifeworks.com |user1        |.* has commented on .*'s post that you're mentioned in: ".*"|

@N34 @Web
Scenario Outline: 2 colleagues comment on a post the user is mentioned in
                 
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Write New Post" from News Feed screen
    Then I write mention post "Great work" and I mention "<users_to_mention>"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<third_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<reciver_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
    |sender_email              |reciver_email                 |second_email_user            |third_email_user |users_to_mention|notification                                                   |
    |lifeworkstesting@lifeworks.com|lifeworkstesting+1@lifeworks.com |lifeworkstesting+2@lifeworks.com|lifeworkstesting+4@lifeworks.com |user1        |.* and .* have commented on .*'s post that you're mentioned in:|

@N35 @Web
Scenario Outline: 3 or more colleagues comment on a post the user is mentioned in
                 
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Write New Post" from News Feed screen
    Then I write mention post "Great work" and I mention "<users_to_mention>"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<third_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<fourth_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<reciver_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
    |sender_email              |reciver_email                 |second_email_user            |third_email_user             |users_to_mention|notification                                                   |
    |lifeworkstesting@lifeworks.com|lifeworkstesting+1@lifeworks.com |lifeworkstesting+2@lifeworks.com|lifeworkstesting+3@lifeworks.com|user1        |.* and .* have commented on .*'s post that you're mentioned in:|
    

@N36 @Web
Scenario Outline: Colleague comments on a post the user is mentioned in and has also commented on
                 
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Write New Post" from News Feed screen
    Then I write mention post "Great work" and I mention "<users_to_mention>"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<reciver_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Thanks" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<third_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<reciver_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
    |sender_email              |reciver_email                |third_email_user             |users_to_mention|notification                                                |
    |lifeworkstesting@lifeworks.com|lifeworkstesting+1@lifeworks.com|lifeworkstesting+2@lifeworks.com|user1        |.* has also commented on .*'s post that you're mentioned in: ".*"|

@N37 @Web
Scenario Outline: 2 colleagues comment on a post the user is mentioned in and has also commented on
                 
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Write New Post" from News Feed screen
    Then I write mention post "Great work" and I mention "<users_to_mention>"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<reciver_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Thanks" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<third_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<fourth_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<reciver_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
    |sender_email              |reciver_email                |third_email_user             |fourth_email_user            |users_to_mention|notification                                                |
    |lifeworkstesting@lifeworks.com|lifeworkstesting+1@lifeworks.com|lifeworkstesting+2@lifeworks.com|lifeworkstesting+3@lifeworks.com|user1        |.* and .* have also commented on .*'s post that you're mentioned in: ".*"|
    

@N38 @Web
Scenario Outline: 3 or more colleagues comment on a post the user is mentioned in and has also commented on
                 
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Write New Post" from News Feed screen
    Then I write mention post "Great work" and I mention "<users_to_mention>"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<reciver_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Thanks" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<third_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<fourth_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<fourth_email_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<reciver_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
    |sender_email              |reciver_email                |third_email_user             |fourth_email_user            |fifth_email_user             | users_to_mention|notification                                                |
    |lifeworkstesting@lifeworks.com|lifeworkstesting+1@lifeworks.com|lifeworkstesting+2@lifeworks.com|lifeworkstesting+3@lifeworks.com|lifeworkstesting+4@lifeworks.com|user1         |.* and .* others have also commented on .*'s post that you're mentioned in: ".*"|
    
@N39 @Web
Scenario Outline: Author of the post comments on a post the user has also commented on and the post mentions the user
                 
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I click "Write New Post" from News Feed screen
    Then I write mention post "Great work" and I mention "<users_to_mention>"
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<reciver_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Thanks" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<sender_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "NP" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<reciver_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
    |sender_email              |reciver_email               |users_to_mention|notification                                                 |
    |lifeworkstesting@lifeworks.com|lifeworkstesting+1@lifeworks.com|user1          |.* has also commented on their post that you're mentioned in: ".*"|

@N40 @Web
Scenario Outline: Trigger User's birthday
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Profile" from the "Global Action" menu
    
    Given I am on Web App User Profile screen
    When I change user Birthday and Joind to the current month and day
    Then I click "News Feed" from the "Work" menu

    Given I am on the News Feed screen
    When I validate that the News Feed contains "Birthday" post 
    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I click "Logout" from the "Global Action" menu
    Examples:
    |notification                              |
    |Happy Birthday .*, from the whole .* team!|

@N41 @Web
Scenario Outline: (Trigger user birthday before running this script)
                    Colleague comments on birthday Post
                    2 colleagues comment on birthday post
                    3 or more colleagues comment on birthday post
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Happy Birtdhay from <user_email>" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<user_birthday_email>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
    |user_birthday_email       |user_email                  |notification                                             |
    |lifeworkstesting@lifeworks.com|lifeworkstesting+1@lifeworks.com|.* has commented on your birthday post: .*               |
    |lifeworkstesting@lifeworks.com|lifeworkstesting+2@lifeworks.com|.* and .* have commented on your birthday post: .*       |
    |lifeworkstesting@lifeworks.com|lifeworkstesting+3@lifeworks.com|.* and .* others have commented on your birthday post: .*|

@N42 @Web
Scenario Outline: (Trigger user birthday before running this script)
                Colleague wishes user a happy birthday
                2 colleagues wish user a happy birthday
                3 or more colleagues wish user a happy birthday

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I congratulated the user
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<user_birthday_email>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
    |user_birthday_email       |user_email                  |notification                                       |
    |lifeworkstesting@lifeworks.com|lifeworkstesting+1@lifeworks.com|.* has wished you a happy birthday!                |
    |lifeworkstesting@lifeworks.com|lifeworkstesting+2@lifeworks.com|.* and .* have wished you a happy birthday!        |
    |lifeworkstesting@lifeworks.com|lifeworkstesting+3@lifeworks.com|.* and .* others have wished you a happy birthday! |

@N40.1 @Web
Scenario Outline: Trigger User's birthday
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Profile" from the "Global Action" menu
    
    Given I am on Web App User Profile screen
    When I change user Birthday and Joind to the current month and day
    Then I click "News Feed" from the "Work" menu

    Given I am on the News Feed screen
    When I validate that the News Feed contains "Birthday" post 
    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I click "Logout" from the "Global Action" menu
    Examples:
    |notification                              |
    |Happy Birthday .*, from the whole .* team!|

@N43 @Web
Scenario Outline: (Trigger user birthday before running this script)
                  A colleague comments on a birthday post the user has also commented on

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<first_user_email>"
    Then I am login to Web App
    
    Given I am on the News Feed screen
    When I give this comment "Happy Birthday from U1" to post index "0"
    Then I logout from Web App
    
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Happy Birthday from U2" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<first_user_email>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App
    
    Examples:
    |first_user_email             |second_user_email            |notification                                                   |
    |lifeworkstesting+1@lifeworks.com |lifeworkstesting+2@lifeworks.com |.* has also commented on .*'s birthday post: ".*               |

@N44 @Web
Scenario Outline: 2 colleagues comment on a birthday post the user has also commented on
    
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Happy Birthday from <second_user_email>" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<first_user_email>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App
    
    Examples: 
    |first_user_email             |second_user_email            |notification                                                   |
    |lifeworkstesting+1@lifeworks.com |lifeworkstesting+3@lifeworks.com |.* and .* have also commented on .*'s birthday post: ".*       |

@N45 @Web
Scenario Outline: 3 or more colleagues comment on a birthday post the user has also commented on

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Happy Birthday from <second_user_email>" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<first_user_email>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App
    
    Examples:
    |first_user_email             |second_user_email            |notification                                                   |
    |lifeworkstesting+1@lifeworks.com |lifeworkstesting+4@lifeworks.com |.* and .* others have also commented on .*'s birthday post: ".*|

@N46 @Web
Scenario Outline: 3 or more colleagues comment on a birthday post the user has also commented on

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<birthday_user>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "Happy Birthday from <birthday_user>" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<first_user_email>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App
    
    Examples:
    |first_user_email             |birthday_user              |notification                                     |
    |lifeworkstesting+1@lifeworks.com |lifeworkstesting@lifeworks.com |.* has also commented on their birthday post: ".*|

@N47 @Web
Scenario: Anniversary user's post
Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App
    And I click "Profile" from the "Global Action" menu
    
    Given I am on Web App User Profile screen
    When I change user Birthday and Joind to the current month and day
    Then I click "News Feed" from the "Work" menu

    Given I am on the News Feed screen
    When I validate that the News Feed contains "Anniversary" post 
    Then I logout from Web App

@N48 @Web
Scenario Outline: (Should run after triggring Anniversary)
                  Colleague congratulates a user for years of service
                  2 Colleagues congratulate a user for years of service
                  3 or more colleagues congratulate a user for years of service
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>"
    Then I am login to Web App
    And I am on the News Feed screen
    And I congratulated the user
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<first_user_email>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App
    
    Examples:
    |first_user_email          |second_user_email           |notification                                                                      |
    |lifeworkstesting@lifeworks.com|lifeworkstesting+1@lifeworks.com|.* has congratulated you for your .* year*s of service achievement!               |
    |lifeworkstesting@lifeworks.com|lifeworkstesting+2@lifeworks.com|.* and .* have congratulated you for your .* year*s of service achievement!       |
    |lifeworkstesting@lifeworks.com|lifeworkstesting+3@lifeworks.com|.* and .* others have congratulated you for your .* year*s of service achievement!|
    
@N49 @Web
Scenario Outline: 
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<first_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "<first_user_email>" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App
    
    Examples:
    |first_user_email             |second_user_email          |notification                                                                  |
    |lifeworkstesting+1@lifeworks.com |lifeworkstesting@lifeworks.com |.* has commented on your .* year*s of service achievement: ".*"               |
    |lifeworkstesting+2@lifeworks.com |lifeworkstesting@lifeworks.com |.* and .* have commented on your .* year*s of service achievement: ".*"       |
    |lifeworkstesting+3@lifeworks.com |lifeworkstesting@lifeworks.com |.* and .* others have commented on your .* year*s of service achievement: ".*"|

@N50 @Web
Scenario Outline: (Trigger user's anniversary before running this script)
                  A colleague comments on a year of service post the user has also commented on 

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<first_user_email>"
    Then I am login to Web App
    
    Given I am on the News Feed screen
    When I give this comment "<first_user_email>" to post index "0"
    Then I logout from Web App
    
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "<second_user_email>" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<first_user_email>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App
    
    Examples:
    |first_user_email             |second_user_email            |notification                                                        |
    |lifeworkstesting+1@lifeworks.com |lifeworkstesting+2@lifeworks.com |.* has also commented on .*'s .* year*s of service achievement: ".*"|

@N51 @Web
Scenario Outline: 2 colleagues comment on a year of service post the user has also commented on
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "<second_user_email>" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<first_user_email>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App
    
    Examples: 
    |first_user_email             |second_user_email            |notification                                                                |
    |lifeworkstesting+1@lifeworks.com |lifeworkstesting+3@lifeworks.com |.* and .* have also commented on .*'s .* year*s of service achievement: ".*"|

@N52 @Web
Scenario Outline: 3 or more colleagues comment on a birthday post the user has also commented on
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "<second_user_email>" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<first_user_email>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App
    
    Examples:
    |first_user_email             |second_user_email            |notification                                                                       |
    |lifeworkstesting+1@lifeworks.com |lifeworkstesting+4@lifeworks.com |.* and .* others have also commented on .*'s .* year*s of service achievement: ".*"|

@N53 @Web
Scenario Outline: 3 or more colleagues comment on a birthday post the user has also commented on
    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "<second_user_email>" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<first_user_email>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App
    
    Examples:
    |first_user_email             |second_user_email          |notification                                                         |
    |lifeworkstesting+1@lifeworks.com |lifeworkstesting@lifeworks.com |.* has also commented on their .* year*s of service achievement: ".*"|

@N54 @Web
Scenario Outline: User is most recognised during a month
Given I am on the Web App Login screen
    Given I am on the Web App Login screen
    When I insert valid email and password
    Then I am login to Web App

    Given I am on the News Feed screen
    When I validate that the News Feed contains "Monthly recognition results published" post
    Then I click "Logout" from the "Global Action" menu

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<first_user_email>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<first_notification>" from the Web App
    And I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>" from the Web App
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<second_notification>" from the Web App
    And I logout from Web App

    Examples:
    |first_user_email             |second_user_email          |first_notification                                           |second_notification                                                 |
    |lifeworkstesting+1@lifeworks.com |lifeworkstesting@lifeworks.com |Congratulations! You were the top performer at .* last month!|The results are out, congratulations to last month's top performers!|

@N55 @Web
Scenario Outline: (Trigger user top performer before running this script)
                Colleague congratulates most recognised users and user is in top 3
                2 Colleagues congratulates most recognised users and user is in top 3
                3+ Colleagues congratulates most recognised users and user is in top 3

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I congratulated the user
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<top_performer_email>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App

    Examples:
    |top_performer_email         |user_email                  |notification                                                                  |
    |lifeworkstesting+1@lifeworks.com|lifeworkstesting+2@lifeworks.com|.* has congratulated you for being a top performer last month.                |
    |lifeworkstesting+1@lifeworks.com|lifeworkstesting+3@lifeworks.com|.* and .* have congratulated you for being a top performer last month.        |
    |lifeworkstesting+1@lifeworks.com|lifeworkstesting+4@lifeworks.com|.* and .* others have congratulated you for being a top performer last month. |

    
@N56 @Web
Scenario Outline: (Trigger user top performer before running this script)
    Colleague comments on most recognised user post and user is in top 3
    2 colleagues comment on most recognised user post and user is in top 3
    3 or more colleagues comment on most recognised user post and user is in top 3

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<first_user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I give this comment "<first_user_email>" to post index "0"
    Then I logout from Web App

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<second_user_email>"
    Then I am login to Web App

    When I open Notification from the Web App menu
    Then I check that this user got the next notification "<notification>" from the Web App
    And I logout from Web App
    
    Examples:
    |first_user_email             |second_user_email            |notification                                            |
    |lifeworkstesting+6@lifeworks.com |lifeworkstesting+1@lifeworks.com |.* has commented on your achievement: ".*"              |
    |lifeworkstesting+7@lifeworks.com |lifeworkstesting+1@lifeworks.com |.* and .* have commented on your achievement: ".*"      |
    |lifeworkstesting+8@lifeworks.com|lifeworkstesting+1@lifeworks.com |.* and .* others have commented on your achievement: ".*"|


@N57 @Web
Scenario Outline: Send mention post and check that the post is first in timeline
    Given I am on the Admin Panel Login screen
    When I insert valid email and password from the Admin Panel screen
    Then I am login to Admin Panel

    Given I am on the Dashboard
    When I click on "Timeline" from Top Bar menu

    Given I am on the Timeline screen
    When I send mention post from Timeline "<first_part_of_the_post>" and I mention "<users_to_mention>"
    Then I check that this post "<first_part_of_the_post> <second_part_of_the_post>" is first in timeline

    Given I am on the Web App Login screen
    When I login to Web App with the next user "<user_email>"
    Then I am login to Web App

    Given I am on the News Feed screen
    When I check if this post "<first_part_of_the_post> <second_part_of_the_post>" is first in the feed
    Then I open Notification from the Web App menu
    And I check that this user got the next notification "<notification>" from the Web App
    And I click "Logout" from the "Global Action" menu

    Examples:
    |user_email                   |users_to_mention                   |first_part_of_the_post |second_part_of_the_post            |notification                                      |  
    |lifeworkstesting+1@lifeworks.com |user1 user1                        |mention post           |user1 user1                        |.* has mentioned you in a post: ".*"              |
    |lifeworkstesting+1@lifeworks.com |user1 user1,user2 user2            |mention post           |user1 user1 user2 user2            |.* has mentioned you and .* in a post: ".*"       |
    |lifeworkstesting+1@lifeworks.com |user1 user1,user2 user2,user3 user3|mention post           |user1 user1 user2 user2 user3 user3|.* has mentioned you and .* others in a post: ".*"|