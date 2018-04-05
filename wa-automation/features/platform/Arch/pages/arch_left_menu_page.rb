# -*- encoding : utf-8 -*-
class ArchLeftMenuPage
	def initialize (browser)
    @BROWSER = browser
  end

  def click_button (button) 
    case button
    when 'Withdrawals'
      @BROWSER.ul(:class, %w(nav nav-pills nav-stacked)).span(:text, 'Withdrawals').wait_until_present
      @BROWSER.ul(:class, %w(nav nav-pills nav-stacked)).span(:text, 'Withdrawals').click
      @BROWSER.h2(:text, 'Withdrawals').wait_until_present
    when 'Companies'
      @BROWSER.ul(:class, %w(nav nav-pills nav-stacked)).span(:text, 'Companies').wait_until_present
      @BROWSER.ul(:class, %w(nav nav-pills nav-stacked)).span(:text, 'Companies').click
      @BROWSER.h2(:text, 'Companies').wait_until_present
    when 'Affiliates'
      @BROWSER.ul(:class, %w(nav nav-pills nav-stacked)).span(:text, 'Affiliates').wait_until_present
      @BROWSER.ul(:class, %w(nav nav-pills nav-stacked)).span(:text, 'Affiliates').click
      @BROWSER.h2(:text, 'Affiliates').wait_until_present
    when 'Coupons'
      @BROWSER.ul(:class, %w(nav nav-pills nav-stacked)).span(:text, 'Coupons').wait_until_present
      @BROWSER.ul(:class, %w(nav nav-pills nav-stacked)).span(:text, 'Coupons').click
      @BROWSER.h2(:text, 'Coupons').wait_until_present
    when 'Spot Rewarding'
      @BROWSER.ul(:class, %w(nav nav-pills nav-stacked)).span(:text, 'Spot Rewarding').wait_until_present
      @BROWSER.ul(:class, %w(nav nav-pills nav-stacked)).span(:text, 'Spot Rewarding').click
      @BROWSER.h2(:text, 'Spot Rewarding').wait_until_present
    when 'Gift Cards'
      @BROWSER.ul(:class, %w(nav nav-pills nav-stacked)).span(:text, 'Gift Cards').wait_until_present
      @BROWSER.ul(:class, %w(nav nav-pills nav-stacked)).span(:text, 'Gift Cards').click
      # @BROWSER.h2(:text, 'Spot Rewarding').wait_until_present
    when 'Offers'
      @BROWSER.ul(:class, %w(nav nav-pills nav-stacked)).span(:text, 'Offers').wait_until_present
      @BROWSER.ul(:class, %w(nav nav-pills nav-stacked)).span(:text, 'Offers').click
      @BROWSER.h2(:text, 'Instore offers').wait_until_present
    when 'Cinemas'
      @BROWSER.ul(:class, %w(nav nav-pills nav-stacked)).span(:text, 'Cinemas').wait_until_present
      @BROWSER.ul(:class, %w(nav nav-pills nav-stacked)).span(:text, 'Cinemas').click
      @BROWSER.h2(:text, 'Cinemas').wait_until_present
    else
      fail(msg = "Error. click_button. The option #{button} is not defined in menu.")
    end
  end
end
