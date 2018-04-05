# -*- encoding : utf-8 -*-
class HermesSettingsPage
  def initialize (browser)
    @BROWSER = browser
    
    @LBL_SETTINGS = @BROWSER.div(:text, HERMES_STRINGS["settings"]["title"])
    @LBL_EMAIL_NOTIFICATION = @BROWSER.div(:text, HERMES_STRINGS["settings"]["section_notifications"])
    @LBL_ACCOUNT = @BROWSER.div(:text, /#{HERMES_STRINGS["settings"]["section_account"]}/)
    @LBL_LANGUAGE = @BROWSER.select
    @LBL_USEFUL_LINKS = @BROWSER.div(:text, HERMES_STRINGS["settings"]["links"]["label_1"])
    @LBL_CHANGE_YOUR_PASSWORD = @BROWSER.h2(:text, HERMES_STRINGS["settings"]["password"]["title"])

    @LNK_CONTACT_LIFEWORKS = @BROWSER.a(:text, HERMES_STRINGS["settings"]["links"]["label_2"])
    @LNK_PRIVACY_POLICY = @BROWSER.a(:text, HERMES_STRINGS["settings"]["links"]["label_3"])

    @BTN_CHANGE_PASSWORD = @BROWSER.button(:text, HERMES_STRINGS["settings"]["password"]["btn_label"])
    @BTN_SUBMIT_PASSWORD = @BROWSER.button(:text, HERMES_STRINGS["settings"]["password"]["submit"])

    @TXF_CURRENT_PASSWORD = @BROWSER.input(:placeholder, HERMES_STRINGS["settings"]["password"]["current_password"])
    @TXF_NEW_PASSWORD = @BROWSER.input(:placeholder, HERMES_STRINGS["settings"]["password"]["new_password"])
    @TXF_CONFIRM_NEW_PASSWORD = @BROWSER.input(:placeholder, HERMES_STRINGS["settings"]["password"]["confirm_password"])
  end

  def click_button (button)
    case button
    when 'Change password'
      @BTN_CHANGE_PASSWORD.wait_until_present
      @BTN_CHANGE_PASSWORD.click
      @BTN_CHANGE_PASSWORD.wait_while_present
      is_visible('Change your password')
    end
  end

  # check that the elements are visible in the page 
  def is_visible (page)
    case page
    when 'main'  
    default_locale = COMPANY_PROFILE[:profile_1][:locale]
    @LBL_SETTINGS.wait_until_present
    @LBL_USEFUL_LINKS.wait_until_present

    if $ACCOUNT_TYPE == 'shared' 
      Watir::Wait.until { !@LBL_EMAIL_NOTIFICATION.present? }
      Watir::Wait.until { !@BTN_CHANGE_PASSWORD.present? }
      Watir::Wait.until { !@LBL_EMAIL_NOTIFICATION.present? }
      
      if LOCALES[:"#{default_locale}"][:label] == 'en_GB'
        Watir::Wait.until { !@LBL_LANGUAGE.present? }
        Watir::Wait.until { !@LBL_ACCOUNT.present? }
      else
        @LBL_LANGUAGE.wait_until_present
        @LBL_ACCOUNT.wait_until_present
      end

      @LNK_PRIVACY_POLICY.wait_until_present
      @LNK_CONTACT_LIFEWORKS.wait_until_present
    else
      if ACCOUNT[:"#{$account_index}"][:valid_account][:country_code] == 'gb'
        @LBL_ACCOUNT.wait_until_present
        @LBL_EMAIL_NOTIFICATION.wait_until_present
      end
    end
    when 'Change your password'
      @LBL_CHANGE_YOUR_PASSWORD.wait_until_present
      @TXF_CURRENT_PASSWORD.wait_until_present
      @TXF_NEW_PASSWORD.wait_until_present
      @TXF_CONFIRM_NEW_PASSWORD.wait_until_present
      @BTN_SUBMIT_PASSWORD.wait_until_present
    end
  end

  # set user language
  # @param language
  def set_user_lanuage (language)
    @BROWSER.select.wait_until_present
    @BROWSER.select.select language
    @BROWSER.div(:class, 'preloader').wait_while_present
    
    if language == 'English (CA)'
      if @LBL_SETTINGS.present?
        fail(msg = 'Error. set_user_language. Language has not updated')
      end   
    else
      @LBL_SETTINGS.wait_until_present
    end

    @BROWSER.span(:class, %w(toaster__icon toaster__icon--tick)).wait_until_present
  end

  # @param current_password_correct
  # @param change_password_to
  # @param passwords_match
  def change_password (current_password_correct, change_password_to, passwords_match)
    change_password_to == 'new_password' && current_password_correct ? current_password = 'old_password' : current_password = 'new_password'
    
    @TXF_CURRENT_PASSWORD.wait_until_present
    @TXF_CURRENT_PASSWORD.to_subtype.clear
    @TXF_CURRENT_PASSWORD.send_keys ACCOUNT[:"#{$account_index}"][:reset_password_email][:"#{current_password}"]

    @TXF_NEW_PASSWORD.wait_until_present    
    @TXF_NEW_PASSWORD.to_subtype.clear
    @TXF_NEW_PASSWORD.send_keys ACCOUNT[:"#{$account_index}"][:reset_password_email][:"#{change_password_to}"]

    @TXF_CONFIRM_NEW_PASSWORD.wait_until_present
    @TXF_CONFIRM_NEW_PASSWORD.to_subtype.clear

    if passwords_match
      @TXF_CONFIRM_NEW_PASSWORD.send_keys ACCOUNT[:"#{$account_index}"][:reset_password_email][:"#{change_password_to}"]
      @TXF_CURRENT_PASSWORD.click
      @BTN_SUBMIT_PASSWORD.wait_until_present
      @BTN_SUBMIT_PASSWORD.click
      @BROWSER.div(:text, HERMES_STRINGS["settings"]["password_change_modal"]["title"]).wait_until_present
      @BROWSER.div(:text, HERMES_STRINGS["settings"]["password_change_modal"]["subtitle"]).wait_until_present
      @BROWSER.div(:class => 'radiobox-module__radiobox___D1HPj', :index => 0).wait_until_present
      @BROWSER.div(:class => 'radiobox-module__radiobox___D1HPj', :index => 1).wait_until_present
      logout_after_change = [true, false].sample

      if logout_after_change
        @BROWSER.div(:class => 'radiobox-module__radiobox___D1HPj', :index => 0).click
      else
        @BROWSER.div(:class => 'radiobox-module__radiobox___D1HPj', :index => 1).click
      end

      @BROWSER.div(:text, HERMES_STRINGS["settings"]["password_change_modal"]["submit"]).wait_until_present
      @BROWSER.div(:text, HERMES_STRINGS["settings"]["password_change_modal"]["submit"]).click
      @BROWSER.div(:text, HERMES_STRINGS["settings"]["password_change_modal"]["submit"]).wait_while_present

      if current_password_correct
        @BROWSER.p(:text, HERMES_STRINGS["settings"]["password"]["success_change"]).wait_until_present
        @BROWSER.p(:text, HERMES_STRINGS["settings"]["password"]["success_change"]).wait_while_present
        is_visible('main')
      else
        @BROWSER.span(:text, "#{HERMES_STRINGS["settings"]["password"]["incorrect_password"]} #{HERMES_STRINGS["forgotten_password"]["forgotten_your_password"]}").wait_until_present
      end
    else
      @TXF_CONFIRM_NEW_PASSWORD.send_keys "#{ACCOUNT[:"#{$account_index}"][:reset_password_email][:"#{change_password_to}"]}_1"
      @TXF_CURRENT_PASSWORD.click
      @BTN_SUBMIT_PASSWORD.wait_until_present
      @BTN_SUBMIT_PASSWORD.click
      @BROWSER.span(:text, HERMES_STRINGS["reset_pass"]["error"]).wait_until_present
      is_visible('Change your password')
    end
  end
end