# -*- encoding : utf-8 -*-
class EmailServicePage

  # Login to the given email adress and check if a spasipic mail was recived
  # @param subject_text - subject to search in the email
  # @param delete_if_find - delete the email if the right email was found
  # @param value_to_return - which value to return from the email
  # @param email
  # @param password
  # @return RETURNED_VALUE 

  def check_for_email(subject_text, value_to_return = nil, email, password)
    @mail_service = EmailService.new
    @mail_service.init_email(email, password)
    $returned_value_from_email = @mail_service.check_if_mail_was_recived(subject_text, value_to_return)
    @mail_service.empty_bin
    puts "return check_for_email: #{$returned_value_from_email}"
    return
  end
  
end
