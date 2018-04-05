# -*- encoding : utf-8 -*-
class HermesSignupPage
  
  def initialize (browser)
    @BROWSER = browser
    @file_service = FileService.new
  end

  # Sign up process for the Web App
  # @invitation_code - 'Company Code' or a personal invitation code
  # @return @EMAIL - email adress which the user sign up with
  def signup (invitation_code = nil, new_user_data_array = nil, is_limited_account_type = false)
    @new_user_data_array = new_user_data_array

    if is_limited_account_type == false
      # Generates a 6 char code using random letters and numbers. Extremely unlikely to get duplicates
      @file_service.insert_to_file('invite_email_counter:', "#{rand(36**6).to_s(36)}")

      # Uncomment After translation file has been updated
      # @BROWSER.h1(:text, HERMES_STRINGS["sign_up"]["invitation"]["title"]).wait_until_present
      # @BROWSER.h2(:text, HERMES_STRINGS["sign_up"]["invitation"]["subtitle"]).wait_until_present
      @invitation_code = invitation_code 
      @BROWSER.text_field(:id, 'invitationCode').wait_until_present
      @BROWSER.button(:text, HERMES_STRINGS["sign_up"]["invitation"]["submit"]).wait_until_present
      ( @invitation_code == 'Dependant Code' ) ? @COUNTER_INDEX = @file_service.get_from_file('dependant_counter:')[0..-2] : @COUNTER_INDEX = @file_service.get_from_file('invite_email_counter:')[0..-2]

      if @invitation_code == 'Company Code'
        company_code = @file_service.get_from_file('company_invitation_code:')[0..-2]
        @BROWSER.text_field(:id, 'invitationCode').set company_code
      elsif @invitation_code == 'Dependant Code'
        @BROWSER.text_field(:id, 'invitationCode').set "#{$returned_value_from_email}"
      else
        @BROWSER.text_field(:id, 'invitationCode').set "#{invitation_code}"
      end

      sleep(1)

      if @BROWSER.input(:class => %w(btn btn--large), :value => HERMES_STRINGS["sign_up"]["invitation"]["submit"]).present?
        @BROWSER.input(:class => %w(btn btn--large), :value => HERMES_STRINGS["sign_up"]["invitation"]["submit"]).click
      end
    else
      # Generates a 6 char code using random letters and numbers. Extremely unlikely to get duplicates
      @file_service.insert_to_file('limited_email_counter:', "#{rand(36**6).to_s(36)}")
      @COUNTER_INDEX = @file_service.get_from_file('limited_email_counter:')[0..-2]
      @file_service.insert_to_file('limited_email_counter:', @COUNTER_INDEX)
    end

    signup_step_1(is_limited_account_type)

    if (@new_user_data_array == nil) && ( @invitation_code != 'Dependant Code' && is_limited_account_type == false )
      signup_step_2
      return @EMAIL
    else 
      return
    end
  end

  def is_visible (page, is_limited_account_type = false)
    case page
    when 'signup_step_1'
      @BROWSER.text_field(:id, 'first_name').wait_until_present
      @BROWSER.text_field(:id, 'last_name').wait_until_present
      if ( is_limited_account_type || @invitation_code == 'Dependant Code' )
        Watir::Wait.until { !@BROWSER.text_field(:id, 'job_title').present? }
      else
        @BROWSER.text_field(:id, 'job_title').wait_until_present
      end
      
      @BROWSER.text_field(:id, 'email').wait_until_present
      @BROWSER.input(:class, %w(btn btn--large)).wait_until_present
    when 'signup_step_2'
      @BROWSER.h1(:text, HERMES_STRINGS["sign_up"]["details_comp"]["title"]).wait_until_present
      @BROWSER.text_field(:id, 'phoneNumber').wait_until_present
      @BROWSER.text_field(:id, 'mobileNumber').wait_until_present
      @BROWSER.select(:id, 'undefined-day').wait_until_present
      @BROWSER.select(:id, 'undefined-month').wait_until_present
      @BROWSER.input(:id, 'undefined-year').wait_until_present
      @BROWSER.select(:id => 'undefined-day', :index => 1).wait_until_present
      @BROWSER.select(:id => 'undefined-month', :index => 1).wait_until_present
      @BROWSER.input(:id => 'undefined-year', :index => 1).wait_until_present
      @BROWSER.label(:text, HERMES_STRINGS["sign_up"]["gender"]["title"]).wait_until_present
      @BROWSER.button(:text, HERMES_STRINGS["sign_up"]["fieldset_right"]["btn"]).wait_until_present
      @BROWSER.button(:text, HERMES_STRINGS["sign_up"]["fieldset_right"]["skip"]).wait_until_present
    end
  end

  def click_button (button, is_limited_account_type = false)
    case button
    when 'Sign up'
      @BROWSER.button(:class, %w(btn btn--large)).wait_until_present
      @BROWSER.button(:class, %w(btn btn--large)).click
      
      if is_limited_account_type
        puts "email for limited user. = #{@EMAIL}"
        @file_service.insert_to_file('limited_account_user_name:', @EMAIL)
        @BROWSER.div(:text, HERMES_STRINGS["limited_account"]["confirmation"]["title"]).wait_until_present
        @BROWSER.button(:class, 'btn').wait_until_present
      elsif @invitation_code == 'Dependant Code'
        @BROWSER.button(:class, %w(btn btn--large)).wait_while_present
        Watir::Wait.until { 
          !@BROWSER.text_field(:id, 'phoneNumber').present?
          !@BROWSER.div(:text, HERMES_STRINGS["limited_account"]["confirmation"]["title"]).present?
        }
        $current_user_email = @file_service.get_from_file('dependant_account_user_name:')[0..-2]
      else
        @BROWSER.text_field(:id, 'phoneNumber').wait_until_present
      end
    when 'Continue'
      @BROWSER.button(:class, %w(btn btn--large)).wait_until_present
      @BROWSER.button(:class, %w(btn btn--large)).fire_event('click')
    when 'Continue_signup_step3'
      @BROWSER.div(:class, 'form-group').wait_until_present
      @BROWSER.div(:class, 'form-group').parent.input(:class => %w(btn btn--large)).wait_until_present
      @BROWSER.div(:class, 'form-group').parent.input(:class => %w(btn btn--large)).click
    when 'Sports & Outdoors'
      @BROWSER.div(:class, %w(interests__circle sports_and_outdoors)).wait_until_present
      @BROWSER.div(:class, %w(interests__circle sports_and_outdoors)).click
    when 'Submit'
      @BROWSER.input(:value, HERMES_STRINGS["sign_up"]["invitation"]["submit"]).wait_until_present
      @BROWSER.input(:value, HERMES_STRINGS["sign_up"]["invitation"]["submit"]).click 
      puts "Clicked"
      @BROWSER.input(:value, HERMES_STRINGS["sign_up"]["form_comp"]["cta"]).wait_while_present
    else
      fail(msg = "Error. click_button. The option #{button} is not defined in menu.")
    end
  end

  # First page of signup
  def signup_step_1 (is_limited_account_type = false)
    puts "In sign-up step1"
    is_visible('signup_step_1', is_limited_account_type)

    if @new_user_data_array == nil
      if is_limited_account_type
        first_name = "#{USER_PROFILE[:new_user][:first_name]}_limited_#{@COUNTER_INDEX}"
        last_name = "#{USER_PROFILE[:new_user][:last_name]}_limited_#{@COUNTER_INDEX}"

        @file_service.insert_to_file('limited_account_name:', "#{first_name} #{last_name}")
      else
        first_name = "#{USER_PROFILE[:new_user][:first_name]}" + "#{@COUNTER_INDEX}"
        last_name = "#{USER_PROFILE[:new_user][:last_name]}" + "#{@COUNTER_INDEX}"
      end

      @BROWSER.text_field(:id, 'first_name').set "#{first_name}"
      @BROWSER.text_field(:id, 'last_name').set "#{last_name}"
      
      if is_limited_account_type 
        @EMAIL = "#{ACCOUNT[:"#{$account_index}"][:valid_account][:email_subdomain]}" + '+' + "#{ACCOUNT[:"#{$account_index}"][:valid_account][:country_code]}" + '+' + "lim" + '_' + "#{@COUNTER_INDEX}" + '@' + "#{ACCOUNT[:"#{$account_index}"][:valid_account][:email_domain]}"
        @BROWSER.text_field(:id, 'email').set @EMAIL
      elsif @invitation_code == 'Company Code'
        @EMAIL = @BROWSER.text_field(:id, 'email').set "#{ACCOUNT[:"#{$account_index}"][:valid_account][:email_subdomain]}" + '+' + "#{ACCOUNT[:"#{$account_index}"][:valid_account][:country_code]}" + "#{@COUNTER_INDEX}" + '@' + "#{ACCOUNT[:"#{$account_index}"][:valid_account][:"#{$email_domain}"]}"
        @BROWSER.text_field(:id, 'job_title').set USER_PROFILE[:new_user][:job_title]
      else
        ( @invitation_code == 'Dependant Code' ) ? nil : ( @BROWSER.text_field(:id, 'job_title').set USER_PROFILE[:new_user][:job_title] )
        @EMAIL = @BROWSER.text_field(:id, 'email').text
      end

      if !@invitation_code && @EMAIL == nil
        fail(msg = 'Error. signup_step_1. Expected to see e-mail address.')
      end
    else
      @BROWSER.text_field(:id, 'first_name').set @new_user_data_array[0]
      @BROWSER.text_field(:id, 'last_name').set @new_user_data_array[1]
      @BROWSER.text_field(:id, 'job_title').set @new_user_data_array[2]
      @BROWSER.text_field(:id, 'email').set @new_user_data_array[3]
    end

    @BROWSER.input(:placeholder, HERMES_STRINGS["sign_up"]["form_comp"]["password_placeholder"]).send_keys USER_PROFILE[:new_user][:password]
    @BROWSER.div(:id, 'view').click
    sleep(1)
    click_button('Sign up', is_limited_account_type)
    
    if is_limited_account_type
      @BROWSER.button(:class, 'btn').wait_until_present
      @BROWSER.button(:class, 'btn').click
      @BROWSER.div(:id, 'feed').wait_until_present
    end

  end

  # Second page of signup
  def signup_step_2
    is_visible('signup_step_2')
    
    @BROWSER.text_field(:id, 'phoneNumber').set USER_PROFILE[:new_user][:phone]
    @BROWSER.text_field(:id, 'mobileNumber').set USER_PROFILE[:new_user][:mobile]
    @BROWSER.select(:id, 'undefined-day').select USER_PROFILE[:new_user][:joined_day]
    @BROWSER.select(:id, 'undefined-month').select USER_PROFILE[:new_user][:joined_month]
    @BROWSER.input(:id, 'undefined-year').send_keys USER_PROFILE[:new_user][:joined_year]
    @BROWSER.select(:id => 'undefined-day', :index => 1).select USER_PROFILE[:new_user][:birth_day]
    @BROWSER.select(:id => 'undefined-month', :index => 1).select USER_PROFILE[:new_user][:birth_month]
    @BROWSER.input(:id => 'undefined-year', :index => 1).send_keys USER_PROFILE[:new_user][:birth_year]
    @BROWSER.element(:text, USER_PROFILE[:new_user][:gender]).click
    click_button('Continue')
    
    if @invitation_code != 'Company Code'
      @BROWSER.a(:href, /feed\//).wait_until_present
      @hermes_page = HermesLoginPage.new @BROWSER
      @hermes_page.close_walkthrough_popup
      @hermes_page.close_cookie_message
    else
      @BROWSER.input(:id, 'email').wait_until_present
      @BROWSER.input(:id, 'password').wait_until_present
      
      if $email_domain == 'email_domain'
        @BROWSER.p(:text, HERMES_STRINGS['sign_up']['interests']['signup_success_2']).wait_until_present
      else
        @BROWSER.p(:text, HERMES_STRINGS['sign_up']['interests']['signup_success_1']).wait_until_present
      end

    end
  end

end
