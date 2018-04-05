# -*- encoding : utf-8 -*-
class ZeusLoginPage
  def initialize (browser)
    @BROWSER = browser
    @BROWSER.goto $ZEUS
            
    @BROWSER.img(:class, 'logo-module__logo___1y_j1').wait_until_present

    @TXF_EMAIL = @BROWSER.text_field(:id, 'email')
    @TXF_PASSWORD = @BROWSER.text_field(:id, 'password')
    
    @BTN_SUBMIT = @BROWSER.button(:text, ZEUS_STRINGS["login"]["reset_request"]["submit_btn"])
    @BTN_LOGIN = @BROWSER.a(:text, 'Log In')
    
    @LBL_PASSWORD_FORMAT_INCORRECT = @BROWSER.span(:text, ZEUS_STRINGS["login"]["password_invalid"])
    @LBL_NOT_VALID_EMAIL = @BROWSER.span(:text, ZEUS_STRINGS["login"]["email_invalid"])
    @LBL_TELL_EMAIL = @BROWSER.span(:text, ZEUS_STRINGS["login"]["reset_request"]["required"])
    @LBL_FORFOTTEN_YOUR_PASSWORD = @BROWSER.link(:text, ZEUS_STRINGS["login"]["forgot_password"])
  end

  # check that the elements are visible in the given page 
  def is_visible (page)
    @BROWSER.img(:class, 'logo-module__logo___1y_j1').wait_until_present

    if page == 'login'
      @TXF_EMAIL.wait_until_present
      @TXF_PASSWORD.wait_until_present
      @BROWSER.label(:text, ZEUS_STRINGS["login"]["remember_me"]).wait_until_present
      @BTN_LOGIN.wait_until_present
      @LBL_FORFOTTEN_YOUR_PASSWORD.wait_until_present
    elsif page == 'forgotten'
      @BROWSER.span(:text, ZEUS_STRINGS["login"]["forgot_password"]).wait_until_present
      @TXF_EMAIL.wait_until_present
      @BTN_SUBMIT.wait_until_present
    end
  end

  # Login with the given email and password
  # @param email
  # @param password
  def login_to_verify_email (email, password)
    @TXF_EMAIL.to_subtype.clear
    @TXF_EMAIL.send_keys email
                    
    @TXF_PASSWORD.to_subtype.clear
    @TXF_PASSWORD.send_keys password

    @BROWSER.button(:class, %w(btn btn-primary login-btn-submit ng-binding)).click
  end

  # Login with the given email and password
  # @param email
  # @param password
  def login (email, password)
    @TXF_PASSWORD.to_subtype.clear
    @TXF_EMAIL.to_subtype.clear

    if email != nil
      @TXF_EMAIL.send_keys email
    end
    
    if password != nil
      @TXF_PASSWORD.send_keys password  
    end

  # The clicks on the elements below are neccesary in order to give focus back to the page after the textfield input and to enable the login button
  # This is not an issue that can be replicated manually
    @BROWSER.div(:text, ZEUS_STRINGS["login"]["admin_badge"]).click
    @TXF_EMAIL.click
    @TXF_PASSWORD.click
    @BTN_LOGIN.click
  end

  # Login with unvalid email and password and check that all validations are working
  def login_error_check
    # Valid email but incorrect password
    login(ACCOUNT[:"#{$account_index}"][:valid_account][:email], "#{ACCOUNT[:email][:password]}x")
    @BROWSER.p(:text, ZEUS_STRINGS["api_errors"]["incorrect_data"]).wait_until_present

    if !@BTN_LOGIN.exists?
      fail(msg = 'Error. login_error_check. Success to login with unvalid e-mail and password format.')
    end

    @BROWSER.goto $ZEUS

    # No email and No password
    login(nil, nil)
    @BROWSER.span(:text, ZEUS_STRINGS["login"]["email_required"]).wait_until_present
    @BROWSER.span(:text, ZEUS_STRINGS["login"]["password_required"]).wait_until_present

    @BROWSER.goto $ZEUS
    
    login(1, nil)
    @BROWSER.span(:text, ZEUS_STRINGS["login"]["email_invalid"]).wait_until_present

    #login with unexisting account
    login("#{ACCOUNT[:"#{$account_index}"][:valid_account][:email]}x", ACCOUNT[:email][:password])
    @BROWSER.p(:text, ZEUS_STRINGS["api_errors"]["incorrect_data"]).wait_until_present
  end

  # Lock account by the given email
  # @param email
  # @param password
  def lock_account (email, password)
    login(email, password)
    @BROWSER.span(:text, /4 attempts left/).wait_until_present

    login(email, password)
    @BROWSER.span(:text, /3 attempts left/).wait_until_present

    login(email, password)
    @BROWSER.span(:text, /2 attempts left/).wait_until_present

    # login(email, password)
    # @BROWSER.p(:text, /You have 1 attempt remaining./).wait_until_present
    
    login(email, password)
    @BROWSER.p(:text, /Please come back in 10 minutes to try again/).wait_until_present   
  end

  # Reset passwrd with the predefiend email
  # Param @change_password_to - change the password to a new or old password
  def reset_password 
    @LBL_FORFOTTEN_YOUR_PASSWORD.fire_event('click')

    is_visible 'forgotten'

    @TXF_EMAIL.wait_until_present

    # insert valid password
    @TXF_EMAIL.set ACCOUNT[:"#{$account_index}"][:reset_password_email][:email]
    @BTN_SUBMIT.click
    @BROWSER.element(:text, ZEUS_STRINGS["login"]["email_instructions"]).wait_until_present
    is_visible 'login' 
  end

  # Open the link to set the new password
  # @param - link to insert new password
  def insert_new_password (link, change_password_to)
    @BROWSER_TWO = Watir::Browser.new
    
    if link.include? 'https'
      reset_email_link = link.insert 8, "#{URL[:zeus_password]}@"
    else
      reset_email_link = link.insert 7, "#{URL[:zeus_password]}@"
    end
    
    puts "reset_email_link #{reset_email_link}"
    @BROWSER_TWO.goto "#{reset_email_link}"
    @BROWSER.send_keys [:command, :subtract]*10
    @BROWSER_TWO.send_keys :f11
    @BROWSER_TWO.input(:placeholder => ZEUS_STRINGS["login"]["reset_confirm"]["new_pass"]).wait_until_present
    puts "Change password to: #{ACCOUNT[:"#{$account_index}"][:reset_password_email][:"#{change_password_to}"]}"
    @BROWSER_TWO.input(:placeholder => ZEUS_STRINGS["login"]["reset_confirm"]["new_pass"]).send_keys ACCOUNT[:"#{$account_index}"][:reset_password_email][:"#{change_password_to}"]
    @BROWSER_TWO.input(:placeholder => ZEUS_STRINGS["login"]["reset_confirm"]["confirm_pass"]).send_keys ACCOUNT[:"#{$account_index}"][:reset_password_email][:"#{change_password_to}"]
    @BROWSER_TWO.a(:class, %w(btn btn-primary)).click
    @BROWSER_TWO.button(:class, %w(btn btn-primary login-btn-submit ng-binding)).wait_until_present
    @BROWSER_TWO.close
  end
end