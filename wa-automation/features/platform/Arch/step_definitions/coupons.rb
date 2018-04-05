# -*- encoding : utf-8 -*-
Given /^I am on Coupons screen$/ do
    @coupons_page = ArchCouponssPage.new @browser_arch
    @coupons_page.is_visible('main')
end

When /^I create new coupon$/ do
	@coupons_page.create_new_coupon
end

When /^I update coupon status to "(.*?)"$/ do |status|
	@coupons_page.update_coupon(status)
end
