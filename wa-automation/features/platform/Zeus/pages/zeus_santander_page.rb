# -*- encoding : utf-8 -*-
require 'time'
class ZeusSantanderPage

  def initialize (browser)
    @BROWSER = browser
    @BROWSER.goto $SANTANDER_SIGNUP
    @BTN_SIGN_UP_FOR_FREE = @BROWSER.a(:text, 'SIGN UP FOR FREE')
    @BTN_FREE_TRAIL = @BROWSER.a(:text, 'Free Trial')
    @BTN_CREATE_ACCOUNT = @BROWSER.div(:text, 'CREATE ACCOUNT')
    @BTN_NEXT_STEP = @BROWSER.div(:text, 'NEXT STEP')
  end

  def is_visible(page)
    case page
    when 'main'
      @BROWSER.div(:text, 'Reward. Engage. Retain.').wait_until_present
      @BROWSER.div(:text, 'Reward, engage & retain your employees with discounts, recognition & communication in a simple social platform.').wait_until_present
      @BTN_SIGN_UP_FOR_FREE.wait_until_present
      @BTN_FREE_TRAIL.wait_until_present
    end
  end

  def click_button(button)
    case button
    when 'Free Trial'
      @BTN_FREE_TRAIL.wait_until_present
      @BTN_FREE_TRAIL.click
      @BTN_FREE_TRAIL.wait_while_present
    when 'SIGN UP FOR FREE'
      @BTN_SIGN_UP_FOR_FREE.wait_until_present
      @BTN_SIGN_UP_FOR_FREE.click
      @BTN_SIGN_UP_FOR_FREE.wait_while_present
    when 'CREATE ACCOUNT'
      #@BTN_CREATE_ACCOUNT.wait_until_present
      @BTN_CREATE_ACCOUNT.click
      @BTN_CREATE_ACCOUNT.wait_while_present
    when 'NEXT STEP'
      @BTN_NEXT_STEP.wait_until_present
      @BTN_NEXT_STEP.click
      @BTN_NEXT_STEP.wait_while_present
    end
  end

  # Signup to WAM as Santander clients 
  def signup
    signup_step_1
    click_button('NEXT STEP')

    signup_step_2
    click_button('CREATE ACCOUNT')
    @BROWSER.div(:text, 'Thanks for signing up! What’s next?').wait_until_present
  end

  # First screen of the Santander signup process
  def signup_step_1
    @BROWSER.input(:placeholder, 'First').wait_until_present
    @BROWSER.input(:placeholder, 'First').send_keys USER_PROFILE[:new_admin_user][:first_name]
    @BROWSER.input(:placeholder, 'Last').wait_until_present
    @BROWSER.input(:placeholder, 'Last').send_keys USER_PROFILE[:new_admin_user][:last_name]
    
    new_email = next_email_account
    @BROWSER.input(:placeholder, 'e.g. address@example.com').wait_until_present
    @BROWSER.input(:placeholder, 'e.g. address@example.com').send_keys new_email

    @BROWSER.input(:type => 'password', :index => 0).wait_until_present
    @BROWSER.input(:type => 'password', :index => 0).send_keys USER_PROFILE[:new_admin_user][:password]

    @BROWSER.input(:type => 'password', :index => 1).wait_until_present
    @BROWSER.input(:type => 'password', :index => 1).send_keys USER_PROFILE[:new_admin_user][:password]
  end
  
  # Second screen of the Santander signup process
  def signup_step_2
    @BROWSER.input(:placeholder, 'Name').wait_until_present
    $current_user_company_name = USER_PROFILE[:new_admin_user][:wa_subdomain] + "#{@COUNTER_INDEX}"
    @BROWSER.input(:placeholder, 'Name').send_keys $current_user_company_name

    new_company_url = "#{URL[:hermes]}".gsub! '[company_wa_subdomain]' , "#{URL[:password]}" + '@' + "#{$current_user_company_name}" 
    puts "new_company_url:#{new_company_url}"
    @file_service.insert_to_file('new_company_url:', new_company_url)

    @BROWSER.select(:index, 0).wait_until_present
    @BROWSER.select(:index, 0).select '1-9'

    @BROWSER.select(:index, 1).wait_until_present
    @BROWSER.select(:index, 1).select 'Accountancy, Banking and Finance'

    @BROWSER.input(:placeholder, 'e.g 0203 567 5900').wait_until_present
    @BROWSER.input(:placeholder, 'e.g 0203 567 5900').send_keys '0203 567 5900'
    
    @BROWSER.input(:placeholder, 'Postcode').wait_until_present
    @BROWSER.input(:placeholder, 'Postcode').send_keys USER_PROFILE[:new_admin_user][:postcode]
    
    @BROWSER.span(:text, 'Bank account number').parent.parent.input.wait_until_present
    @BROWSER.span(:text, 'Bank account number').parent.parent.input.send_keys USER_PROFILE[:new_admin_user][:santander_account_number]

    @BROWSER.span(:text, 'Bank sort-code').parent.parent.input(:index, 0).send_keys USER_PROFILE[:new_admin_user][:santander_sort_code][:part_1]
    @BROWSER.span(:text, 'Bank sort-code').parent.parent.input(:index, 1).send_keys USER_PROFILE[:new_admin_user][:santander_sort_code][:part_2]
    @BROWSER.span(:text, 'Bank sort-code').parent.parent.input(:index, 2).send_keys USER_PROFILE[:new_admin_user][:santander_sort_code][:part_3]

    @BROWSER.span(:text, /I accept LifeWorks/).parent.parent.img.wait_until_present
    @BROWSER.span(:text, /I accept LifeWorks/).parent.parent.img.click

  end

  # Generate the next Admin email
  def next_email_account
    @file_service = FileService.new

    # counter is use to create a different email address
    @COUNTER_INDEX = @file_service.get_from_file("admin_account_counter:")[0..-2].to_i + 1

    email_address = "#{ACCOUNT[:"#{$account_index}"][:valid_account][:email_subdomain]}" + '+' + "#{ACCOUNT[:"#{$account_index}"][:valid_account][:country_code]}" + 'ADMIN' + "#{@COUNTER_INDEX}" + '@' + "#{ACCOUNT[:"#{$account_index}"][:valid_account][:email_domain]}"
    
    @file_service.insert_to_file("admin_account_counter:", @COUNTER_INDEX.to_i)
    @file_service.insert_to_file('new_admin_email:', email_address)

    return email_address
  end
end

