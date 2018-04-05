# -*- encoding : utf-8 -*-
Given /^I am on the iOS News Feed screen$/ do
    @news_feed_page = page(IOSNewsFeedPage).await
end

When /^I write this comment "(.*?)" in the latest post from the iOS app$/ do |comment|
    @COMMENT = comment
    @news_feed_page.write_comment(@COMMENT)
end 

When /^I click "(.*?)" from the iOS News Feed screen$/ do |button|
    @news_feed_page.click_button(button)
end

When /^I give recognition to user name "(.*?)" from the iOS app$/ do |user_name|
    @news_feed_page.select_user(user_name)
end

Then /^I write this post "(.*?)" from the iOS app$/ do |post|
    @POST = post
    @news_feed_page.write_post(@POST)
    @news_feed_page.refresh_page
end

Then /^I search for "(.*?)" that "(.*?)" the iOS News Feed/ do |post_text, state|
    @news_feed_page.search_in_feed(post_text, state)
end

And /^I write this recoginition "(.*?)" from the iOS app$/ do |recognition|
    @RECOGNITION = recognition
    @news_feed_page.write_recognition(@RECOGNITION)
end

And /^I check that the recognition is in the iOS feed$/ do
    @news_feed_page.check_post_or_recognition_in_feed(@RECOGNITION)
end

And /^I check that the post is in the iOS feed$/ do
    @news_feed_page.check_post_or_recognition_in_feed(@POST)
end
And /^I choose "(.*?)" badge from the iOS app$/ do |badge|
    @news_feed_page.choose_badge(badge)
end

And /^I check badges$/ do 
    @news_feed_page.check_badges
end

And /^I check the like functionality$/ do
    @news_feed_page.like_or_unliked('Like')
    @news_feed_page.like_or_unliked('Liked')
end

Then /^I go back to the iOS News Feed screen$/ do
     @news_feed_page.back_to_news_feed
end

And /^I validate all badges exists$/ do
    @news_feed_page.check_badges
end

Then /^I verify that "(.*?)" Snackable sessions can be viewed per day on iOS News Feed screen$/ do |max_sessions|
     @news_feed_page.verify_snackable_session_limit(max_sessions)
end

Then /^I verify snackable iOS re engagement functionality "([^"]*)"$/ do |set_another_interest|
     @news_feed_page.verify_re_engagement(set_another_interest)
end