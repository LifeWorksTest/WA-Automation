# -*- encoding : utf-8 -*-
Given /^I am on the News Feed screen$/ do
    @news_feed_page = HermesNewsFeedPage.new @browser
    @news_feed_page.is_visible
end

When /^I give this recognition "(.*?)" badge "(.*?)" to "(.*?)"$/ do |recognition_text, badge_name, user_name|
    recognition_text = "#{recognition_text} #{Time.now.strftime('%d%m%H%M%S')}"
    @news_feed_page.give_recognition(recognition_text, badge_name, user_name)
end

When /^I give this recognition "(.*?)" badge "(.*?)" to "(.*?)" "(.*?)" times$/ do |recognition_text, badge_name, user_name, amount|
    for i in 0..amount.to_i
        @news_feed_page.give_recognition(recognition_text + i.to_s, badge_name, user_name)
        @browser.refresh
        steps %Q{
            Then I check if this post "#{recognition_text + i.to_s}" is first in the feed
        }
    end
end

When /^I give this mention recognition post "(.*?)" badge "(.*?)" to "(.*?)"$/ do |recognition_text, badge_name, user_name|
    @news_feed_page.give_recognition(recognition_text, badge_name, user_name, true)
end

When /^I click "(.*?)" from News Feed screen$/ do |button|
    @news_feed_page.click_button(button)
end

When /^I welcomes a new user$/ do
    @news_feed_page.welcome_new_user
    @browser.refresh
    @news_feed_page.is_visible
    sleep(5)
end
When /^I congratulated the user$/ do 
    @news_feed_page.congratulated_user
end

When /^I Re-recognise user post inedx "(.*?)"$/ do |post_index|
     @news_feed_page.re_recognise(post_index)
end

Then /^I validate empty state in the News Feed screen$/ do
    @news_feed_page.validate_empty_state
end

Then /^I give this comment "(.*?)" to post index "(.*?)"$/ do |comment_text, index|
    @news_feed_page.give_comment(comment_text, index.to_i)
end

Then /^I write this post "(.*?)"$/ do |post_text|
    post_text = "#{post_text} #{Time.now.strftime('%d%m%H%M%S')}"
    @news_feed_page.write_post(post_text)
end

Then /^I write mention post "(.*?)" and I mention "(.*?)"$/ do |post_text, user_name_to_mention|
    @news_feed_page.write_post_with_mention(post_text, user_name_to_mention)
end

Then /^I write mention post "(.*?)" and I mention "(.*?)" "(.*?)" times$/ do |post_text, user_name_to_mention, amount|
     steps %Q{
            When I click "Write New Post" from News Feed screen
    }
    for i in 0..amount.to_i
        @news_feed_page.write_post_with_mention(post_text + i.to_s, user_name_to_mention)
        sleep(1)
    end
end

Then /^I check if this post "(.*?)" is first in the feed$/ do |post_text|
    @news_feed_page.check_if_post_is_first_feed(post_text)
end 

Then /^I validate that all badges are "(.*?)" in the Web App$/ do |state|
    @news_feed_page.validate_badges_state(state)
end

Then /^I give "(.*?)" recognition for the latest new user$/ do |amount|
    file_service = FileService.new
    counter = file_service.get_from_file("invite_email_counter:")[0..-2]

    for i in 0..amount.to_i
        @news_feed_page.give_recognition("recognition number #{i}", "Newbie", "user#{counter} user#{counter}")
        sleep(0.5)
        @browser.refresh
    end
end

And /^I click "(.*?)" on this post$/ do |like_or_unlike|
    @news_feed_page.like_or_unlike(like_or_unlike)
end

And /^I check that the next badge "(.*?)" "(.*?)" in the list$/ do |badge_name, exists_or_not|
    @news_feed_page.check_if_badge_exists_in_list(badge_name, exists_or_not)
end

And /^I give recognition to a user from the Web App$/ do
    steps %Q{
        Given I am on the Web App Login screen
        When I insert valid email and password
        Then I am login to Web App

        Given I am on the News Feed screen
        When I click "Give Recognition" from News Feed screen
        Then I give this recognition "Good work!!" badge "Creative" to "user1"
        And I recived an email with the subject "youve_been_recognised_on_lifeworks"
        And I click "Logout" from the "Global Action" menu
        And I update statistics for this company
    }
end 

And /^I validate that the News Feed contains "(.*?)" post$/ do |post_type|
    if post_type == 'New user' || post_type == 'Birthday' || post_type == 'Anniversary' || post_type == 'Company Anniversary'
        commend = 'Daily'
    elsif post_type == 'Monthly recognition results published'
        commend = 'Monthly'
    elsif post_type == 'New user'
        commend = 'Dont trigger call'
        @news_feed_page.check_if_post_exists_in_feed('Welcome')
    end

    if commend != 'Dont trigger call'
        steps %Q{
            And I trigger "#{commend}" function using the Server
        }

        if post_type == 'Birthday'    
            @news_feed_page.check_if_post_exists_in_feed('Happy Birthday!')
        elsif post_type == 'Anniversary'
            @news_feed_page.check_if_post_exists_in_feed('Congratulations')
        elsif post_type == 'Company Anniversary'
            @news_feed_page.check_if_post_exists_in_feed('years old!')
        elsif post_type == 'Monthly recognition results published'
            @news_feed_page.check_if_post_exists_in_feed("Congratulations to last month's top performers, great job!")
        end
    end
end

And /^I trigger "(.*?)" function using the Server$/ do |commend|
    @api_page = Api.new
    case commend 
    when 'Daily'
        @api_page.trigger_daily
    when 'Monthly'
        @api_page.trigger_monthly
    end

    @browser.refresh
    sleep(5)
end

And /^I validate the link to "(.*?)" profile$/ do |user_name|
    @news_feed_page.go_to_user_profile_from_post(user_name)
    steps %Q{
        Then I am on Web App User Profile screen
    }
end 

And /^I validate that the next recognition "(.*?)" is first in the news feed$/ do |recognition_text|
    @news_feed_page.validate_recognition_is_first_in_feed(recognition_text)
end

And /^I validate that Grouping is "(.*?)" in the News Feed, Leaderboard and Colleague Directory$/ do |enabled_disabled|
    @news_feed_page.validate_grouping_fuctionlity(enabled_disabled)

    steps %Q{
        Given I click "Colleague Directory" from the "Work" menu
        When I am on the Colleague Directory screen
        Then I validate that grouping fuctionalty is "#{enabled_disabled}" in Colleague Directory screen

        Given I click "Leaderboard" from the "Work" menu
        When I am on the Leaderboard screen
        Then I validate that grouping fuctionalty is "#{enabled_disabled}" in Leaderboard screen
    }
end

And /^I validate that the current user "(.*?)" to the latest group$/ do |belong_or_not|
    @news_feed_page.validate_user_belong_to_latest_group(belong_or_not)
end

And /^I validate that the Refine By dropdown list displays the correct filter options dependant on user type$/ do
    @news_feed_page.validate_refine_by_dropdown_list
end 

And /^I verify that the correct images are displayed for my locale$/ do
    @news_feed_page.verify_uploaded_images
end