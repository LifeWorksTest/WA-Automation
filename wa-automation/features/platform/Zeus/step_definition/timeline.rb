# -*- encoding : utf-8 -*-
Given /^I am on the Timeline screen$/ do
    @timeline_page = ZeusTimelinePage.new @browser
    @timeline_page.is_visible
end

Then /^I check all Timeline filters$/ do
    @timeline_page.check_all_timeline_filters
end

Then /^I send this post from Timeline "(.*?)"$/ do |post_text|
    @timeline_page.send_new_post(post_text)
end

Then /^I send mention post from Timeline "(.*?)" and I mention "(.*?)"$/ do |post_text, users_to_mention|
	@timeline_page.write_post_with_mention(post_text, users_to_mention)
end

And /^I check that this post "(.*?)" is first in timeline$/ do |post_text|
    @timeline_page.check_post_is_first_in_timeline(post_text)
end
