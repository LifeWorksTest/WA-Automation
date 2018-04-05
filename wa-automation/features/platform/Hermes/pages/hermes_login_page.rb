# -*- encoding : utf-8 -*-
class HermesLoginPage
    
    def initialize (browser, url = nil)
      @BROWSER = browser
      
      if !@BROWSER.url.include? 'hermes'
        @BROWSER.goto $HERMES
      end
      
      @TXF_EMAIL = @BROWSER.input(:id, 'email')
      @TXF_PASSWORD = @BROWSER.input(:id, 'password')
      @BTN_LOGIN = @BROWSER.button(:text, HERMES_STRINGS["login"]["action"])
      @BTN_SUBMIT =  @BROWSER.input(:class => %w(btn btn--large), :value => HERMES_STRINGS["sign_up"]["invitation"]["submit"])
      @BTN_FORGOT_PWD_SUBMIT = @BROWSER.button(:type, 'submit')
      @BTN_SIGNUP = @BROWSER.button(:id, 'signup-button')
      @BTN_LOGIN_WITH_ORBIT = @BROWSER.span(:text, 'Login with Orbit')
      @LBL_FORFOTTEN_YOUR_PASSWORD = @BROWSER.a(:text, HERMES_STRINGS["forgotten_password"]["forgotten_your_password"])
      @LBL_FAILED_VALIDATE_EMAIL = @BROWSER.span(:text, 'Please enter your email')
      #TODO:error message to be changed
      @LBL_INCORRECT_EMAIL_PASSWORD = @BROWSER.li(:class => %w(toast my-repeat-animation error), :text => 'Oops! It looks like something has gone wrong, please try again.')
    end
    
    # check that the elements are visible in the given page
    def is_visible (page)
      case page
      when 'login'
        if $SSO
          @BTN_LOGIN_WITH_ORBIT.wait_until_present
        else
          @BROWSER.div(:text, /#{HERMES_STRINGS["login"]["action"]}/i).wait_until_present
          @TXF_EMAIL.wait_until_present
          @TXF_PASSWORD.wait_until_present
          @BTN_LOGIN.wait_until_present
          @BROWSER.label(:text, HERMES_STRINGS["login"]["remember_checkbox"]).wait_until_present
        end 

      when 'forgotten'
        @BROWSER.a(:class, 'logo').wait_until_present
        @BROWSER.div(:class, %w(image profile)).wait_until_present
        @BROWSER.h2(:text, HERMES_STRINGS["login"]["forgotten_your_password"]).wait_until_present
        @TXF_EMAIL.wait_until_present
        @BTN_SUBMIT.wait_until_present
      else
        fail(msg= 'Error. click_button. Button was not found in the list.')
      end
    end
    
    def click_button (button)
        @BROWSER.div(:class, 'spinner').wait_while_present
        sleep(0.5)
        
        case button
            when 'Signup'
            @BTN_SIGNUP.wait_until_present
            Watir::Wait.until { @BTN_SIGNUP.enabled? }
            @BTN_SIGNUP.click
            @BTN_SUBMIT.wait_until_present
            when 'Browser back button'
            @BROWSER.back
            when 'Forgotten your password?'
            @LBL_FORFOTTEN_YOUR_PASSWORD.wait_until_present
            @LBL_FORFOTTEN_YOUR_PASSWORD.click
            @TXF_EMAIL.wait_until_present
            when 'Submit'
            @BTN_SUBMIT.wait_until_present
            @BTN_SUBMIT.click
            @BTN_SUBMIT.wait_while_present
            when 'Login with Orbit'
            @BTN_LOGIN_WITH_ORBIT.wait_until_present
            @BTN_LOGIN_WITH_ORBIT.click
            # @BTN_LOGIN_WITH_ORBIT.wait_while_present
            else
            fail(msg = "Error. click_button. The option #{button} is not defined in menu.")
        end
    end
    
    # Login to the Web App
    # @param email
    # @param password
    # @param expected_result - if user successful manage to login or not
    def login_to_web_app (email, password, expected_result = 'success')
      @TXF_EMAIL.to_subtype.clear
      @TXF_PASSWORD.to_subtype.clear
      
      if email != nil
        @TXF_EMAIL.send_keys email
        Watir::Wait.until { @TXF_EMAIL.value == email }
      end
        
      if password != nil
        @TXF_PASSWORD.send_keys password
        Watir::Wait.until { @TXF_PASSWORD.value == password }
      end

      @BROWSER.div(:class, 'preloader').wait_while_present
      @BTN_LOGIN.wait_until_present
      @BTN_LOGIN.click
        
      if expected_result == 'success'
        @BTN_LOGIN.wait_while_present
        close_walkthrough_popup
        close_cookie_message
      elsif (expected_result == 'failure') && (email == nil && password == nil )
        @BROWSER.p(:text, HERMES_STRINGS["api_errors"]["incorrect_data"]).wait_until_present
        @BROWSER.p(:text, HERMES_STRINGS["api_errors"]["incorrect_data"]).wait_until_present
      elsif (expected_result == 'failure') && (email != nil && password != nil)
        @BROWSER.p(:text, HERMES_STRINGS["api_errors"]["incorrect_data"]).wait_until_present
      elsif (expected_result == 'failure') && (email != nil || password != nil )
        @TXF_EMAIL.wait_until_present
      elsif (expected_result == 'failure') && (email == nil)
        @BROWSER.div(:text, HERMES_STRINGS["login"]["enter_valid_email"]).wait_until_present
      elsif (expected_result == 'failure') && (password == nil)
        @BROWSER.div(:text, HERMES_STRINGS["login"]["password_required"]).wait_until_present
      end
    end
    
    # Added this logic as the below block is looking for the "ACCEPT COOKIES" banner.
    # The second time the user logs in (in the same secanrio), this banner will not be visible as it has already been accepted.
    def close_cookie_message
      if !$COOKIE_PRIVATE_MESSAGE_DISMISSED
        @BROWSER.button(:class, 'icon-web_close').wait_until_present
        @BROWSER.button(:class, 'icon-web_close').fire_event('click')
        @BROWSER.button(:class, 'icon-web_close').wait_while_present
        $COOKIE_PRIVATE_MESSAGE_DISMISSED = true
      end
    end

    # Close walkthrough popup
    def close_walkthrough_popup
      sleep(4)
      if @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div.i(:class, 'icon-web_close').present?
        @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div.i(:class, 'icon-web_close').fire_event('click')
        @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div.i(:class, 'icon-web_close').wait_while_present
      end
    end
    
    # Login with unvalid data and checking that the login is fail
    # Check also validators by login with just email or password and with unexisting account
    def login_error_check
      login_to_web_app('test@test.com', nil, 'failure')
      login_to_web_app(nil, 'password_test', 'failure')
      login_to_web_app(nil, nil, 'failure')
    end
    
    # Reset password and checks the validators
    # @param email_to_reset
    def reset_password (email_to_reset)
        click_button ('Forgotten your password?')
        @BROWSER.div(:class, 'preloader').wait_while_present
        
        # insert invalid email
        # @TXF_EMAIL.send_keys '1234444444444'
        # @BTN_SUBMIT.wait_until_present
        # @BTN_SUBMIT.click
        # @BROWSER.div(:class, 'form-error').span(:text, 'Please enter a valid email address').wait_until_present
        # sleep(1)
        
        # @TXF_EMAIL.send_keys [:command, 'a'], :clear
        
        # insert valid email
        @TXF_EMAIL.send_keys "#{email_to_reset}"
        @BTN_FORGOT_PWD_SUBMIT.wait_until_present
        @BTN_FORGOT_PWD_SUBMIT.click
        @BROWSER.div(:text, HERMES_STRINGS["forgotten_password"]["reset_success"]["subtitle"].gsub(/\s+/, ' ')).wait_until_present
        @BROWSER.button(:text, HERMES_STRINGS["forgotten_password"]["reset_success"]["cta"]).wait_until_present
        @BROWSER.button(:text, HERMES_STRINGS["forgotten_password"]["reset_success"]["cta"]).click
        @BROWSER.button(:text, HERMES_STRINGS["forgotten_password"]["reset_success"]["cta"]).wait_while_present
        is_visible 'login'
    end
    
    # Open the link to set the new password
    # @param - link to insert new password
    def insert_new_password (link, change_password_to)
      @BROWSER_TWO = Watir::Browser.new :firefox
      @BROWSER_TWO.window.resize_to(1200, 1000)
      
      reset_email_link = link
      
      puts "reset_email_link:#{reset_email_link}"
      @BROWSER_TWO.goto reset_email_link
      @BROWSER_TWO.div(:text, HERMES_STRINGS["reset_pass"]["title"]).wait_until_present
      
      @BROWSER_TWO.text_field(:placeholder, HERMES_STRINGS["reset_pass"]["new_pass"]).wait_until_present
      @BROWSER_TWO.text_field(:placeholder, HERMES_STRINGS["reset_pass"]["new_pass"]).set ACCOUNT[:"#{$account_index}"][:reset_password_email][:"#{change_password_to}"]
      
      @BROWSER_TWO.text_field(:placeholder, HERMES_STRINGS["reset_pass"]["confirm"]).wait_until_present
      @BROWSER_TWO.text_field(:placeholder, HERMES_STRINGS["reset_pass"]["confirm"]).set ACCOUNT[:"#{$account_index}"][:reset_password_email][:"#{change_password_to}"]
      puts "Change password to: #{ACCOUNT[:"#{$account_index}"][:reset_password_email][:"#{change_password_to}"]}"
      
      @BROWSER_TWO.div(:text, HERMES_STRINGS["reset_pass"]["title"]).click
      @BROWSER_TWO.text_field(:placeholder, HERMES_STRINGS["reset_pass"]["new_pass"]).click
      @BROWSER_TWO.text_field(:placeholder, HERMES_STRINGS["reset_pass"]["confirm"]).click
      sleep(2)
      @BROWSER_TWO.input(:value, 'Submit').wait_until_present
      @BROWSER_TWO.input(:value, 'Submit').click
      @BROWSER_TWO.p(:text, HERMES_STRINGS["reset_pass"]["flash_message"]).wait_until_present
      @BROWSER_TWO.button(:text, HERMES_STRINGS["login"]["action"]).wait_until_present

      @BROWSER_TWO.close
    end
    
    # Login to Capita
    # @param user_name
    # @param user_password
    def login_to_capita (user_name = nil, user_password = nil, uuid = nil, first_login = true)
      @BROWSER.window(:index => 1).use do
      # if uuid is nil so login to integration environmant
      
      if uuid == nil
          @BROWSER.input(:id, 'username').wait_until_present
          @BROWSER.input(:id, 'password').wait_until_present
          @BROWSER.input(:id, 'loginSubmit').wait_until_present
          
          @BROWSER.input(:id, 'username').send_keys user_name
          @BROWSER.input(:id, 'password').send_keys user_password
          @BROWSER.input(:id, 'loginSubmit').click
      else
          @BROWSER.input(:id, 'uuid').wait_until_present
          @BROWSER.input(:id, 'uuid').send_keys uuid
          @BROWSER.input(:name, 'submit').wait_until_present
          sleep(2)
          @BROWSER.input(:name, 'submit').click
          sleep(2)
      end 
    end
      
    if first_login
        @BROWSER.a(:text, 'Continue').wait_until_present
        @BROWSER.a(:text, 'Continue').click
    end
    
    sleep(0.5)
  end
end
