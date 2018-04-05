require 'net/imap.rb'
require 'mail'

class EmailService
  def init_email(username, password, folder = 'inbox')
    @imap = Net::IMAP.new('imap.googlemail.com', 993, true, nil, false)

    @res = @imap.login(username, password)

    if @res.name == 'OK'
      @logged_in = true
      @folder = folder
      @imap.select(@folder)

      at_exit {
        if @logged_in
          @imap.logout
        end
      }
    else
      fail(msg="Error. init_email. Error occurred during connection attempt.")
    end
  end

  def poll_and_check_if_exists(subject_text, value_to_return)
    @imap.select(@folder)

    @imap.search(["ALL"]).each do |message_id|
      envalope =  @imap.fetch(message_id, "ENVELOPE")[0].attr["ENVELOPE"]
      @subject_found = Mail::Encodings.unquote_and_convert_to(envalope.subject,'utf-8')
      puts "#{envalope}"
      puts "The subject that was found is: #{@subject_found}"

      if @subject_found.include? subject_text
        email_body = @imap.fetch(message_id, "(UID RFC822.SIZE ENVELOPE BODY[TEXT])")[0]
        puts "#{email_body}"

        @imap.copy(message_id, '[Gmail]/Bin')
        puts "************************Deleting: #{envalope.subject}************************"
        @imap.store(message_id, "+FLAGS", [:Deleted])

        @imap.expunge

        case value_to_return
        when 'dependant_invite_code'
          if ENV['CURRENT_CUCUMBER_PROFILE'].include? 'Web_US'
            dependant_invite_code = (/heig=\\r\\nht: 50px\\">.*<\/h1>=0A/.match email_body.to_s)[0][20..-9]
          else
            dependant_invite_code = (/=\\r\\nht: 50px\\">.*<\/h1>=0A/.match email_body.to_s)[0][16..-9]
          end

          return dependant_invite_code
        when 'invitation_code'
          if ENV['CURRENT_CUCUMBER_PROFILE'].include? 'Web_US'
            invitation_code = (/600;font-size:\s36px;line-height:=\\r\\n\s50px\\">.*<\/h1>=0A/.match email_body.to_s)[0][45..-9]
          elsif ENV['CURRENT_CUCUMBER_PROFILE'].include? 'Web_CA'
            invitation_code = (/600;font-size:\s36px;line-height:\s50px\\"=\\r\\n>.*<\/h1>=0A/.match email_body.to_s)[0][45..-9]
          else
            invitation_code = (/\\r\\ntion\?code=3D\w+<\/a>=0A/.match email_body.to_s)[0][16..-8]
          end

          return invitation_code
        when 'webapp_link'
          verify_account_link = /href.*/.match email_body.attr["BODY[TEXT]"]
          verify_account_link = /http.*/.match verify_account_link[0]
          verify_account_link = (verify_account_link[0])[0..-3]
          return verify_account_link
        when 'limited_account_activation_link'
          email_body_text = email_body.attr["BODY[TEXT]"]
          email_body_text.gsub!("=\r\n",'')
          email_body_text.gsub!('"','')
          limited_account_activation_link = /https:\/\/click([^\s]+)/.match email_body_text
          puts "verify account link = #{limited_account_activation_link}"
          return limited_account_activation_link
        when 'reset_password_link'
          email_body_text = email_body.attr["BODY[TEXT]"]
          email_body_text.gsub!("=\r\n",'')
          email_body_text.gsub!("3D",'')
          email_body_text.gsub!("=2E",'.')
          email_body_text.gsub!("=25",'%')
          email_body_text.gsub!("%40",'@')

          if email_body_text.include? 'admin'
            reset_password_link = /https:\/\/admin.test.lifeworks.com\/login\/forgotten\/confirm\/.*@workivate.com/.match email_body_text
          else
            reset_password_link = /https:\/\/lifeworkstesting.*\/reset-password.*@workivate.com/.match email_body_text
          end

          return reset_password_link.to_s
        when 'ticket_codes'
          email_body_text = email_body.attr["BODY[TEXT]"]
          email_body_text.gsub!("=\r\n",'')
          regex = Regexp.new(EMAILS[:your_lifeWorks_cinema_discount_codes][:ticket_code_init] + '\w+\d{4}')
          ticket_codes = email_body_text.scan(regex)
          return ticket_codes
        end

        return 'Email was found'
      end
    end

    return 'Email was not found'
  end

  def delete_all_emails
    @imap.select(@folder)

    @imap.search(["ALL"]).each do |message_id|
      @imap.copy(message_id, '[Gmail]/Bin')
      @imap.store(message_id, "+FLAGS", [:Deleted])
    end
    puts "Email was deleted"
    @imap.expunge
  end

  def empty_bin
    @imap.select('[Gmail]/Bin')
    @imap.search(['ALL']).each do |email|
      @imap.store(email, "+FLAGS", [:Deleted])
    end

    @imap.expunge
  end

  def check_if_mail_was_recived(subject_text, value_to_return = nil)
    # Try 5 time to see if the email was recived and wait at maximum for 100sec
    puts "The email subject to search for:#{subject_text}"
    for i in 0..6
      return_value = poll_and_check_if_exists(subject_text, value_to_return)
      if return_value != "Email was not found"
        break
      end

      sleep(20)
    end

    if return_value == "Email was not found"
      fail(msg="Error. Email was not found. Email subject: #{subject_text}.")
    end

    puts "Value to return #{return_value}"
    return return_value
  end
end
