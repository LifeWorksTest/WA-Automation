# -*- encoding : utf-8 -*-
Given /^I delete all emails$/ do
    if VALIDATION[:to_delete_email]
        @email_service = EmailService.new
        @email_service.init_email(ACCOUNT[:email][:email_address], ACCOUNT[:email][:password])
        @email_service.delete_all_emails
        @email_service.empty_bin
    end
end

And /^I recived an email with the subject "(.*?)"$/ do |email_key|
    if VALIDATION[:check_email]
        @email_service = EmailServicePage.new
        @email_service.check_for_email(EMAILS[:"#{email_key}"][:subject], EMAILS[:"#{email_key}"][:return_value], USER_SIGNUP_INVITE_EMAIL[:email], USER_SIGNUP_INVITE_EMAIL[:password])
    end
end

And /^the new user recived an email with the subject "(.*?)"$/ do |email_key|
    steps %Q{
        And I recived an email with the subject "#{email_key}"
    }  
end

  # Verify the ticket codes that were returned from the cinema confirmation email
  # @param = amount_to_select
  # @param = ticket_types
And /^the email should contain "(.*?)" "(.*?)" ticket codes$/ do |amount_to_select, ticket_types|
    @file_service = FileService.new
    cinema_name = @file_service.get_from_file("cinema_name:")[0..-2]
    puts "cinema_name:#{cinema_name}"

    last_ticket_code_to_verify = @file_service.get_from_file("#{CINEMAS[:"#{cinema_name}"][:ticket_types][:"#{ticket_types}"][:name]}:").chomp.to_i
    for i in 1..last_ticket_code_to_verify
        code_to_verify = "#{EMAILS[:your_lifeWorks_cinema_discount_codes][:ticket_code_init]}#{CINEMAS[:"#{cinema_name}"][:ticket_types][:"#{ticket_types}"][:ticket_code]}_#{sprintf '%04d',i}" 
        puts "code_to_verify:#{code_to_verify}     $returned_value_from_email:#{$returned_value_from_email}"

        puts "code #{code_to_verify} is included in the confirmation email? = #{$returned_value_from_email.include? code_to_verify}"
      
        if !$returned_value_from_email.include? code_to_verify
            fail(msg = "Error. verify_ticket_codes_contained_in_email. #{code_to_verify} is not displayed in the confirmation email")
        end
    end
end
