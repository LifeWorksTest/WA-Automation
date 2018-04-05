# -*- encoding : utf-8 -*-
class ArchWithdrawlsPage
  def initialize (browser)
    @BROWSER = browser

    @BTN_CONFIRM = @BROWSER.button(:id, 'modal-btn-validate') 
    @BTN_MARK_AS_APPROVED = @BROWSER.a(:class, 'approved-action')
    @BTN_MARK_AS_DECLINED =  @BROWSER.a(:class, 'declined-action')
  end

  def is_visible
     @BROWSER.div(:class, 'thumbnail').h4(:text, 'Withdrawals to confirm').wait_until_present
     @BROWSER.div(:class, 'thumbnail').table(:class, %w(table table-striped table-hover)).wait_until_present
  end

  def click_button (button)
    case button 
    when 'Confirm'
      @BTN_CONFIRM.wait_until_present
      @BTN_CONFIRM.click
      @BTN_CONFIRM.wait_while_present
      sleep(2)
    when 'Mark as approved'
      @BTN_MARK_AS_APPROVED.wait_until_present
      @BTN_MARK_AS_APPROVED.fire_event('click')
      @BTN_MARK_AS_APPROVED.wait_while_present
    when 'Mark as declined'
      @BTN_MARK_AS_DECLINED.wait_until_present
      @BTN_MARK_AS_DECLINED.fire_event('click')
      @BTN_MARK_AS_DECLINED.wait_while_present
    end
  end

  # Approve or decline withdrew transaction of the given transcation data (Check only the first line in the table and match it with the given values)
  # @param action
  # @param user_name
  # @param user_id
  # @param amount
  def approve_decline_transaction (action, paypal_or_bank, user_name, user_id, amount)
    if !$SSO
      @BROWSER.tr(:index, 1).small(:text, "user id: #{user_id}").wait_until_present
      @BROWSER.tr(:index, 1).td(:index, 0).a(:text, user_name).wait_until_present
    end
    
    @BROWSER.tr(:index, 1).td(:index => 1).small(:text, /#{paypal_or_bank}/i).wait_until_present
    @BROWSER.tr(:index, 1).td(:text, /#{amount}/).wait_until_present
    @BROWSER.tr(:index, 1).button(:text, 'Action').wait_until_present
    @BROWSER.tr(:index, 1).button(:text, 'Action').click

    if action == 'approve'
      click_button('Mark as approved')

      if paypal_or_bank == 'Paypal' || paypal_or_bank == 'paypal'
        @BROWSER.textarea.wait_until_present
        @BROWSER.textarea.click
        @BROWSER.textarea.send_keys 'Approved'
        Watir::Wait.until { @BROWSER.textarea.value.include? 'Approved' }
      end

      click_button('Confirm')
      @BROWSER.div(:id, 'alert-box').wait_until_present
    elsif action == 'decline'
      click_button('Mark as declined')
      
      @BROWSER.div(:text, 'By declining this withdrawal you will put the pending amount back into the available amount.').wait_until_present
      click_button('Confirm')
      @BROWSER.div(:id, 'alert-box').wait_until_present
      @BROWSER.div(:id, 'alert-box').wait_while_present
    end
  end
end
