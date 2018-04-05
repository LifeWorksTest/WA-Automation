# -*- encoding : utf-8 -*-
class ZeusSignUpPage
  
  def initialize (browser)
    @file_service = FileService.new
    @BROWSER = browser
    puts "@BROWSER#{@BROWSER}"
    @BROWSER.goto $ZEUS_SHOP
    @BROWSER.window.resize_to(1200, 1000)
    @BROWSER.h1(:text, 'Give your employees benefits to cheer about').wait_until_present
    
    @BTN_CONTINUE1 = @BROWSER.button(:text, 'Continue!')
    @BTN_CONTINUE = @BROWSER.button(:text, 'Continue')
    @BTN_APPLAY = @BROWSER.button(:text, 'Apply')
    @BTN_LOOK_UP_ADDRESSS = @BROWSER.button(:text, 'Look up address!')
    @BTN_NEARLY_THERE = @BROWSER.button(:text, 'Nearly there!')
    @BTN_INVITE_LATER = @BROWSER.a(:text, /I'll invite employees later/)

  end

  # Sign up to Admin Panel
  # @param with_promotional 'with' or 'without' promotional
  def sign_up (with_promotional)
    first_step
    
    # after filling all field expect to see the second page after clicking "Continue!"
    click_button('Continue1')

    if with_promotional == 'with'
      insert_promotion_code
    end

    second_step
    click_button('Continue')

    third_step
    click_button('Nearly there')

    fourth_page
  end

  def click_button (button)
    case button
    when 'Apply'
      @BTN_APPLAY.wait_until_present
      @BTN_APPLAY.click
    when 'Continue'
      @BTN_CONTINUE.wait_until_present
      @BTN_CONTINUE.click
      @BTN_CONTINUE.wait_while_present
    when 'Continue1'
      @BTN_CONTINUE1.wait_until_present
      @BTN_CONTINUE1.click
      @BTN_CONTINUE1.wait_while_present
    when 'Nearly there'
      @BTN_NEARLY_THERE.wait_until_present
      @BTN_NEARLY_THERE.click
      @BTN_NEARLY_THERE.wait_while_present
    when 'Look up address!'
      @BTN_LOOK_UP_ADDRESSS.wait_until_present
      @BTN_LOOK_UP_ADDRESSS.click
      @BROWSER.select(:name, 'addressList').wait_until_present
    when 'Invite later'
      @BTN_INVITE_LATER.wait_until_present
      @BTN_INVITE_LATER.click
      @BTN_INVITE_LATER.wait_while_present
    else
      fail(msg = "Error. click_button. The option #{button} is not defined in menu.")
    end
  end

  def is_visible (page)
    case page
    when 'first page'
      @BROWSER.text_field(:id, 'firstname').wait_until_present
      @BROWSER.text_field(:id, 'lastname').wait_until_present
      @BROWSER.text_field(:id, 'email').wait_until_present
      @BROWSER.text_field(:id, 'jobtitle').wait_until_present
      @BROWSER.text_field(:id, 'password').wait_until_present
      @BROWSER.text_field(:id, 'passwordverify').wait_until_present
      @BROWSER.text_field(:id, 'companyname').wait_until_present
      @BROWSER.text_field(:id, 'telwork').wait_until_present
      @BROWSER.select(:id, 'country').wait_until_present
    when 'second page'
      @BROWSER.div(:class, 'price').wait_until_present
      @BROWSER.h2(:text, 'Card Details').wait_until_present
      @BROWSER.text_field(:id, 'name').wait_until_present
      @BROWSER.select(:id, 'expMonth').wait_until_present
      @BROWSER.select(:id, 'expYear').wait_until_present
      @BROWSER.text_field(:id, 'cvc').wait_until_present
    when 'third page'
      @BROWSER.text_field(:id, 'company_nickname').wait_until_present
      @BROWSER.text_field(:id, 'wa_subdomain').wait_until_present
      @BROWSER.select(:id, 'industry_type').wait_until_present
      @BROWSER.text_field(:id, 'postcode').wait_until_present
      @BROWSER.select(:id, 'how_heard').wait_until_present
    when 'first page validators'
      @BROWSER.span(:text, 'First name is required').wait_until_present
      @BROWSER.span(:text, 'Last name is required').wait_until_present
      @BROWSER.span(:text, 'Email is required').wait_until_present
      @BROWSER.span(:text, 'Job title is required').wait_until_present
      @BROWSER.span(:text, 'Password is required').wait_until_present
      @BROWSER.span(:text, 'Password verification is required').wait_until_present
      @BROWSER.span(:text, 'Company Name is required').wait_until_present
      @BROWSER.span(:text, 'Country is required').wait_until_present
    when 'second page validators' 
      @BROWSER.label(:for, 'name').parent.parent.span(:text, 'Required').wait_until_present
      @BROWSER.label(:for, 'number').parent.parent.span(:text, 'Required').wait_until_present
      @BROWSER.span(:text, 'Expiry month is required').wait_until_present
      @BROWSER.span(:text, 'Expiry month is required').wait_until_present
      @BROWSER.span(:text, 'Code required').wait_until_present
      @BROWSER.div(:class => %w(main-error center-block ng-binding), :text => 'There are some errors, please correct them').wait_until_present
    when 'third page validators' 
      @BROWSER.span(:text, 'Industry is required').wait_until_present
      @BROWSER.span(:text, 'Postcode is required').wait_until_present
      @BROWSER.span(:text, 'This field is required').wait_until_present
      @BROWSER.div(:class => %w(main-error center-block ng-binding), :text => 'Please fill in the address').wait_until_present
    end
  end

  # Generate the next Admin email
  def next_email_account
    # counter is use to create a different email address
    @COUNTER_INDEX = @file_service.get_from_file("admin_account_counter:")[0..-2].to_i + 1

    email_address = "#{ACCOUNT[:"#{$account_index}"][:valid_account][:email_subdomain]}" + '+' + "#{ACCOUNT[:"#{$account_index}"][:valid_account][:country_code]}" + 'ADMIN' + "#{@COUNTER_INDEX}" + '@' + "#{ACCOUNT[:"#{$account_index}"][:valid_account][:email_domain]}"
    
    @file_service.insert_to_file("admin_account_counter:", @COUNTER_INDEX.to_i)
    @file_service.insert_to_file('new_admin_email:', email_address)

    return email_address
  end

  # Fill the first signup page and check validators
  def first_step
    is_visible('first page')

    # check that after a click "Continue!" when all the field are empty 
    # all validators are seen
    @BROWSER.button(:text, /Continue/).click
    is_visible('first page validators')

    @BROWSER.text_field(:id, 'firstname').set USER_PROFILE[:new_admin_user][:first_name]
    @BROWSER.text_field(:id, 'lastname').set USER_PROFILE[:new_admin_user][:last_name]

    # check E-mail validators 
    @BROWSER.text_field(:id, 'email').set 3
    @BROWSER.text_field(:id, 'jobtitle').set USER_PROFILE[:new_admin_user][:job_title]
    
    @BROWSER.span(:text, 'Email must be in valid format').wait_until_present
  
    new_email = next_email_account
    @BROWSER.text_field(:id, 'email').set new_email 
    puts "The new admin email account is: #{new_email}"
    
    # check password validators 
    @BROWSER.text_field(:id, 'password').set USER_PROFILE[:new_admin_user][:password]
    @BROWSER.text_field(:id, 'passwordverify').set '3e3e3e3e3'
    
    @BROWSER.text_field(:id, 'companyname').set USER_PROFILE[:new_admin_user][:company_name]
        
    @BROWSER.span(:text, "Passwords don't match").wait_until_present

    @BROWSER.text_field(:id, 'passwordverify').set USER_PROFILE[:new_admin_user][:password]

    @BROWSER.text_field(:id, 'telwork').set USER_PROFILE[:new_admin_user][:phone]
    
    @BROWSER.select(:id, 'country').select USER_PROFILE[:new_admin_user][:country]
  end

  # Fill the second signup page
  def second_step
    is_visible('second page')

    @BROWSER.button(:text, /Continue/).click
    is_visible('second page validators')

    @BROWSER.text_field(:id, 'name').set USER_PROFILE[:new_admin_user][:card_holder_name]
    
    @BROWSER.text_field(:id, 'number').set '123'
    @BROWSER.button(:text, /Continue/).click
    @BROWSER.span(:text ,'Wrong card number').wait_until_present  
    
    check_card_type_pic
    
    @BROWSER.text_field(:id, 'cvc').set '123'

    @BROWSER.select(:id, 'expMonth').select USER_PROFILE[:new_admin_user][:expiry_month]
    @BROWSER.select(:id, 'expYear').select USER_PROFILE[:new_admin_user][:expiry_year]
  end

  # Fill the third signup page
  def third_step
    is_visible('third page')
    
    @BROWSER.button(:text, /Nearly there!/).click
    is_visible('third page validators')

    @BROWSER.text_field(:id, 'company_nickname').set USER_PROFILE[:new_admin_user][:company_nickname] + "#{@COUNTER_INDEX}"
    @wa_subdomain = "#{USER_PROFILE[:new_admin_user][:wa_subdomain]}" + "#{@COUNTER_INDEX}"
    @BROWSER.text_field(:id, 'wa_subdomain').set @wa_subdomain
    puts "@wa_subdomain #{@wa_subdomain}"
    
    new_company_url = "#{URL[:hermes]}".gsub! '[company_wa_subdomain]' , "#{URL[:password]}" + "@" + "#{@wa_subdomain}" 
    puts "new_company_url:#{new_company_url}"

    @file_service.insert_to_file('new_company_url:', new_company_url)
    @BROWSER.select(:id, 'industry_type').select USER_PROFILE[:new_admin_user][:industry_type]
    
    @BROWSER.text_field(:id, 'postcode').set USER_PROFILE[:new_admin_user][:postcode]
    click_button('Look up address!')
    @BROWSER.select(:name, 'addressList').select USER_PROFILE[:new_admin_user][:addressList]
    @BROWSER.select(:id, 'how_heard').select USER_PROFILE[:new_admin_user][:how_heard]
  end

  def fourth_page
    @BROWSER.h1(:text, /Invite employees to join .* Workangel network/).wait_until_present
  end

  # def fifth_page
  #   @BROWSER.h1(:text, /Congratulations, you are all set now!/).wait_until_present
  # end

  # Check that when insert different type card the right cradit card company logo is seen 
  def check_card_type_pic
    @BROWSER.text_field(:id, 'number').set '1'
    @BROWSER.select(:id, 'expMonth').select 'April'
    @BROWSER.span(:text, 'Wrong card number').wait_until_present

    @BROWSER.text_field(:id, 'number').set CREDIT_CARD[:visa]    
    @BROWSER.div(:id, 'main').click
    sleep(0.5)
    if ! (@BROWSER.text_field(:id, 'number').html).include? "visa"
      fail(msg="Error. check_card_type_pic. Expected to see Visa image")
    end

    @BROWSER.text_field(:id, 'number').set CREDIT_CARD[:mastercard]
    @BROWSER.div(:id, 'main').click
    sleep(0.5)
    if ! (@BROWSER.text_field(:id, 'number').html).include? "mastercard"
      fail(msg="Error. check_card_type_pic. Expected to see MasterCard image")
    end

    @BROWSER.text_field(:id, 'number').set CREDIT_CARD[:amex]
    @BROWSER.div(:id, 'main').click
    sleep(0.5)
    if ! (@BROWSER.text_field(:id, 'number').html).include? "amex"
      fail(msg="Error. check_card_type_pic. Expected to see American Express image")
    end
  end

  # Insert promotion code 
  # @param code
  def insert_promotion_code
    @file_service = FileService.new
    @BROWSER.span(:class, 'promo-text').wait_until_present
    @BROWSER.span(:class, 'promo-text').click

    @BROWSER.text_field(:id, 'promocode').wait_until_present
    @BROWSER.text_field(:id, 'promocode').set '123'

    promotion_code = "#{@file_service.get_from_file('coupon_code_name:')[0..-2]}#{@file_service.get_from_file('coupon_counter:')[0..-2]}"
    coupon_counter = "#{@file_service.get_from_file('coupon_counter:')[0..-2]}".to_i
    coupon_discount = "#{@file_service.get_from_file('coupon_discount:')[0..-2]}".to_f
    coupon_status = "#{@file_service.get_from_file('coupon_status:')[0..-2]}"
    puts "coupon_status:#{coupon_status}"

    @BROWSER.button(:text, 'Apply').click
    @BROWSER.span(:text, 'Promotional code not recognised. Try again.').wait_until_present     
    
    @BROWSER.text_field(:id, 'promocode').set promotion_code
    @BROWSER.button(:text, 'Apply').click
    
    if coupon_status == 'Enabled' 
      @BROWSER.span(:text, 'Your promotional code is valid. Discount has been applied.').wait_until_present
      
      @BROWSER.div(:class, 'price').span.wait_until_present
      price_befor_discount = @BROWSER.div(:class, 'price').span.text.gsub(/[$£]/,'').to_f
      puts "#{(price_befor_discount * (coupon_discount/100)).round(2)}"
      calculated_price_after_discount = (price_befor_discount - (price_befor_discount * (coupon_discount/100).round(2))).round(2)
      
      @BROWSER.div(:class, 'price').span(:index, 1).wait_until_present
      price_after_discount = @BROWSER.div(:class, 'price').span(:index, 1).text.gsub(/[$£]/,'').to_f

      if calculated_price_after_discount != price_after_discount
        fail(msg = "Error. insert_promotion_code. Price befor discount:#{price_befor_discount} Price after discount:#{price_after_discount} calculated_price_after_discount:#{calculated_price_after_discount} coupon_discount:#{coupon_discount}")
      end
    elsif coupon_status == 'Disabled'
      @BROWSER.span(:text, 'Promotional code not recognised. Try again.').wait_until_present
      puts "Coupon was Disabled as expected"
    end
  end 

  # Verifay the new user account using the given linkf for Zues from the Email and Hermes 
  def varify_account
    @BROWSER.goto($ZEUS)
    @BROWSER.text_field(:id, /email/).wait_until_present
    @BROWSER.text_field(:id, /password/).wait_until_present
    @BROWSER.text_field(:id, /email/).set "#{USER_SIGNUP_INVITE_EMAIL[:local_part]}+ADMIN+#{@COUNTER_INDEX}@lifeworks.com"
    @BROWSER.text_field(:id, /password/).set ACCOUNT[:"#{$account_index}"][:account_to_lock][:password]
    @BROWSER.button(:class, %w(btn btn--large)).click

    puts "$returned_value_from_email:#{$returned_value_from_email}"
    web_app_link =  $returned_value_from_email.gsub! '//' , '//' + "#{URL[:password]}@"
    puts "web_app_link:#{web_app_link}"
    @BROWSER.goto web_app_link
    @BROWSER.text_field(:id, /email/).wait_until_present
    @BROWSER.text_field(:id, /password/).wait_until_present
    
    @file_service = FileService.new

    # counter is use to create a different email address
    @COUNTER_INDEX = @file_service.get_from_file("admin_account_counter:")

    @BROWSER.text_field(:id, /email/).set "#{USER_SIGNUP_INVITE_EMAIL[:local_part]}+ADMIN+#{@COUNTER_INDEX}@lifeworks.com"
    @BROWSER.text_field(:id, /password/).set ACCOUNT[:"#{$account_index}"][:account_to_lock][:password]
    @BROWSER.button(:class, %w(btn btn--large)).wait_until_present
    @BROWSER.button(:class, %w(btn btn--large)).click
    sleep(5)
  end
end
