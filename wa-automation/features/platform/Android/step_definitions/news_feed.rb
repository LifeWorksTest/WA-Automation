# -*- encoding : utf-8 -*-
Given /^I am on the Android News Feed screen$/ do
    @news_feed_page = page(AndroidNewsFeedPage).await
    @news_feed_page.is_visible
end

When /^I click "(.*?)" from the News Feed screen$/ do |button|
    @news_feed_page.click_button(button)
end

When /^I give the next recognition "(.*?)" badge "(.*?)" to user index "(.*?)"$/ do |recognition_text, badge, user_index|
    steps %Q{
        Then I click "Give recognition" from the News Feed screen
        When I give recognition to user index "#{user_index}"
        Then I click "NEXT" from the News Feed screen 
        And I choose "#{badge}" badge
        And I write this recoginition "#{recognition_text}"
    }
end

When /^I write the next post "(.*?)" from the Android app$/ do |post_text|
    steps %Q{
        Then I click "Create new post" from the News Feed screen
        And I write this post "#{post_text}" on New Post screen
    }
end

When /^I give this recognition "(.*?)" to colleague index "(.*?)"$/ do |recognition, user_index|
    @colleagues_directory_page.give_recognition_to(recognition, user_index)
end

When /^I give this recognition "(.*?)" to colleague index "(.*?)" with validating the badges$/ do |recognition, user_index|
    @colleagues_directory_page.give_recognition_to(recognition, user_index, true)
end

When /^I write this comment "(.*?)" in the latest post$/ do |comment|
    @COMMENT = comment
    @news_feed_page.write_comment(@COMMENT)
end 

When /^I give recognition to user index "(.*?)"$/ do |user_index|
    @news_feed_page.select_user(user_index.to_i)
end

Then /^I validate that this post "(.*?)" is in the Android News Feed screen$/ do |post_text|
    @news_feed_page.refresh_page
    @news_feed_page.check_post_is_first(post_text)
end

Then /^I search for "(.*?)" that "(.*?)" the News Feed/ do |post_text, state|
    @news_feed_page.search_in_feed(post_text, state)
end

And /^I choose "(.*?)" badge$/ do |badge|
    @news_feed_page.choose_badge(badge)
end

And /^I write this post "(.*?)" on New Post screen/ do |post_text|
    @news_feed_page.write_post(post_text)
end 

And /^I write this recoginition "(.*?)"$/ do |recoginition|
    @news_feed_page.write_recognition(recoginition)
end

And /^I write this comment "(.*?)"$/ do |comment|
    @news_feed_page.write_comment (comment)
end

And /^I check that this badge "(.*?)" and recognition "(.*?)" is first in the Android News Feed screen$/ do |badge, recognition|
    @news_feed_page.refresh_page
    @news_feed_page.check_recognition_is_first(badge, recognition)
end

And /^I click on News Feed search$/ do
    @news_feed_page.click_button("Search")    
end    
