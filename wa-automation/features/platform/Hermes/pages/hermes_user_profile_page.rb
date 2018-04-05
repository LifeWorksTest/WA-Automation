  # -*- encoding : utf-8 -*-
class HermesUserProfilePage

  def initialize (browser)
    @BROWSER = browser
    @file_service = FileService.new

    @BTN_EDIT_PROFILE = @BROWSER.button(:text, HERMES_STRINGS["profile"]["card"]["edit"].upcase)
    @BTN_FAMILY = @BROWSER.div(:text,  HERMES_STRINGS["dependant_accounts"]["profile_cta"].upcase)
    @BTN_SETTINGS =  @BROWSER.div(:text, HERMES_STRINGS["profile"]["card"]["settings"].upcase)
    @BTN_SAVE = @BROWSER.button(:class, 'btn btn--large')
    @BTN_CANCEL = @BROWSER.button(:class, %w(btn btn--secondary btn--large))
    @BTN_INTERESTS = @BROWSER.span(:text, HERMES_STRINGS["profile"]["profile"]["interest"])
    @BTN_ACHIEVEMENTS = @BROWSER.div(:class, 'page-tabs__header').h3(:index, 1).a
    @BTN_RECOGNITIONS = @BROWSER.div(:class, 'page-tabs__header').h3(:index, 0).a
    @BTN_SAVE_CHANGES = @BROWSER.button(:class => 'btn undefined', :text => /#{HERMES_STRINGS["profile"]["interests"]["cta"]}/)
    @BTN_INVITE_FAMILY_MEMBERS = @BROWSER.div(:text, HERMES_STRINGS["dependant_accounts"]["home_cta"].upcase)
    @BTN_SEND_INVITATION = @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).button(:text, HERMES_STRINGS["dependant_accounts"]["invite_modal"]["send_invitation"].upcase)
    @BTN_CANCEL_INVITATION = @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:text, HERMES_STRINGS["dependant_accounts"]["invite_modal"]["cancel"].upcase)
    
    @TXF_FIRST_NAME = @BROWSER.text_field(:id, 'firstName')
    @TXF_LAST_NAME = @BROWSER.text_field(:id, 'lastName')
    @TXF_JOB_TITLE = @BROWSER.text_field(:id, 'jobTitle')
    @TXF_JOINED_DAY= @BROWSER.select(:id, 'joinedDate-day')
    @TXF_JOINED_MONTH = @BROWSER.select(:id, 'joinedDate-month')
    @TXF_JOINED_YEAR = @BROWSER.input(:id, 'joinedDate-year')
    @TXF_PHONE = @BROWSER.input(:id, 'phoneNumber')
    @TXF_MOBILE = @BROWSER.input(:id, 'mobileNumber')
    @TXF_BIRTH_DAY = @BROWSER.select(:id, 'birthDate-day')
    @TXF_BIRTH_MONTH = @BROWSER.select(:id, 'birthDate-month')
    @TXF_BIRTH_YEAR = @BROWSER.input(:id, 'birthDate-year')
    @TXF_ABOUT = @BROWSER.textarea(:id, 'aboutMe')
    @TXF_INVITE_FAMILY_MEMBER_EMAIL = @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).text_field

    @LBL_INVITE_FAMILY_MEMBERS = @BROWSER.div(:text, HERMES_STRINGS["dependant_accounts"]["home_title"])


    @LIST_DEPENDANT_USERS = @BROWSER.element(css: "div[style^='margin-top: 40px; width: 100%;']")
    @MODAL_INVITE_FAMILY_MEMBERS = @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open))    
  end

  def is_visible (page)
    case page
    when 'Proflie'
      if @BTN_INTERESTS.present?
        @BTN_EDIT_PROFILE.wait_until_present
      end

      
        
      if $ACCOUNT_TYPE == 'limited'
        @BTN_SETTINGS.wait_until_present

        Watir::Wait.until { 
          !@BROWSER.ol(:class, 'recognition-timeline').present? 
          !@BROWSER.span(:text => /#{HERMES_STRINGS["profile"]["achievements"]["recognitions"]}/).present?
          !@BROWSER.span(:text => /#{HERMES_STRINGS["profile"]["profile"]["achievement"]}/).present? 
        }

      else
        if @BTN_SETTINGS.present?
          ( $USER_FEATURE_LIST['eap'] ) && ( $ACCOUNT_TYPE == 'personal' ) ?  @BTN_FAMILY.wait_until_present : Watir::Wait.until { !@BTN_FAMILY.present? } 
          @BROWSER.span(:text, HERMES_STRINGS["profile"]["profile"]["interest"]).wait_until_present
        end  
        
        if $USER_FEATURE_LIST['social_recognition']
          @BROWSER.ol(:class, 'recognition-timeline').wait_until_present
          @BROWSER.span(:text => /#{HERMES_STRINGS["profile"]["achievements"]["recognitions"]}/).wait_until_present
          @BROWSER.span(:text => /#{HERMES_STRINGS["profile"]["profile"]["achievement"]}/).wait_until_present
          
          if @BROWSER.span(:text, HERMES_STRINGS["profile"]["achievements"]["recognitions"]).parent.span.text.to_i > 0
            Watir::Wait.until { @BROWSER.lis(:class, %w(item-recognition item-recognition--profile clearfix-recognition)).count > 0}
          else
            @BROWSER.div(:class, %w{no-data}).wait_until_present
          end
        else
          Watir::Wait.until { !@BROWSER.span(:text => /#{HERMES_STRINGS["profile"]["achievements"]["recognitions"]}/).present? }
          Watir::Wait.until { !@BROWSER.span(:text => /#{HERMES_STRINGS["profile"]["profile"]["achievement"]}/).present? }
        end
      end
    when 'Edit'
      @TXF_FIRST_NAME.wait_until_present
      @TXF_LAST_NAME.wait_until_present
      @TXF_JOB_TITLE.wait_until_present  
      @TXF_JOINED_DAY.wait_until_present 
      @TXF_JOINED_MONTH.wait_until_present
      @TXF_JOINED_YEAR.wait_until_present
      @TXF_PHONE.wait_until_present
      @TXF_MOBILE.wait_until_present
      @TXF_BIRTH_DAY.wait_until_present
      @TXF_BIRTH_MONTH.wait_until_present
      @TXF_BIRTH_YEAR.wait_until_present
      @TXF_ABOUT.wait_until_present
      @BTN_CANCEL.wait_until_present
      @BROWSER.div(:class, 'image').parent.div(:text => /#{HERMES_STRINGS["profile_edit"]["upload"]}/).wait_until_present
      @BROWSER.div(:class, 'image').wait_until_present
    when 'Invite family members'
      @BROWSER.div(:id, 'spinner').wait_until_present
      @BROWSER.div(:id, 'spinner').wait_while_present
      @LBL_INVITE_FAMILY_MEMBERS.wait_until_present
      @BTN_INVITE_FAMILY_MEMBERS.wait_until_present
      @MAX_INVITES_ALLOWED = @BROWSER.element(css: "div[style^='font-size: 16px; color: rgb(33, 33, 33); margin-bottom: 30px;']").text.match(/\d/).to_s.to_i
    when 'Send invitation'
      @MODAL_INVITE_FAMILY_MEMBERS.wait_until_present
      @BTN_SEND_INVITATION.wait_until_present
      @BTN_CANCEL_INVITATION.wait_until_present
      @TXF_INVITE_FAMILY_MEMBER_EMAIL.wait_until_present
    when 'Achievements'
      @BROWSER.div(:class, %w(user-medals ng-scope)).div(:class, %w(medal gold no-medal)).wait_until_present
      @BROWSER.div(:class, %w(user-medals ng-scope)).div(:class, %w(medal silver no-medal)).wait_until_present
      @BROWSER.div(:class, %w(user-medals ng-scope)).div(:class, %w(medal bronze no-medal)).wait_until_present
      @BROWSER.div(:class, %w(user-milestones ng-scope)).div(:class, %w(milestone newbie complete)).wait_until_present
      @BROWSER.div(:class, %w(user-milestones ng-scope)).div(:class, %w(milestone hotshot incomplete)).wait_until_present
      @BROWSER.div(:class, %w(user-milestones ng-scope)).div(:class, %w(milestone rockstar incomplete inactive)).wait_until_present
      @BROWSER.div(:class, %w(user-milestones ng-scope)).div(:class, %w(milestone master incomplete inactive)).wait_until_present
      @BROWSER.div(:class, %w(user-milestones ng-scope)).div(:class, %w(milestone champion incomplete inactive)).wait_until_present
      @BROWSER.div(:class, %w(user-milestones ng-scope)).div(:class, %w(milestone legend incomplete inactive)).wait_until_present
    when 'Interests'
      @BROWSER.div(:class => 'page', :index => 2).img.wait_until_present
      interests_amount =  @BROWSER.div(:class => 'page', :index => 2).imgs.count
      
      if interests_amount != 15
        fail("Error. is_visible. #{interests_amount} interests images were found while expecting to see 15")
      end
    end
  end

  def click_button (button)
    case button
    when 'Edit Profile'
      @BTN_EDIT_PROFILE.wait_until_present
      @BTN_EDIT_PROFILE.click
      is_visible('Edit')
    when 'Save'
      @BTN_SAVE.wait_until_present
      @BTN_SAVE.click
      is_visible('Proflie')
    when 'Cancel'
      @BTN_CANCEL.wait_until_present
      @BTN_CANCEL.click
      is_visible('Proflie')
    when 'Settings'
      @BTN_SETTINGS.wait_until_present
      @BTN_EDIT_PROFILE.parent.div(:text, /#{HERMES_STRINGS["profile"]["card"]["settings"]}/i).click
      @BTN_EDIT_PROFILE.wait_while_present
    when 'Family'
      @BTN_FAMILY.wait_until_present
      @BTN_FAMILY.click
      is_visible('Invite family members')
    when 'Invite family members'
      @BTN_INVITE_FAMILY_MEMBERS.wait_until_present
      @BTN_INVITE_FAMILY_MEMBERS.click
      is_visible('Send invitation')
    when 'Send Invitation'
      @BTN_SEND_INVITATION.wait_until_present
      @BTN_SEND_INVITATION.click
      @MODAL_INVITE_FAMILY_MEMBERS.wait_while_present
    when 'Interests'
      @BTN_INTERESTS.wait_until_present
      @BTN_INTERESTS.click
      is_visible('Interests')
    when 'Save changes'
      @BTN_SAVE_CHANGES.wait_until_present
      @BTN_SAVE_CHANGES.click
      @BROWSER.li(:text, HERMES_STRINGS["profile"]["interests"]["saved"]).wait_until_present
    when 'Achievements'
      @BROWSER.div(:class, 'page-tabs__header').h3(:index, 1).p(:text, /#{HERMES_STRINGS["profile"]["achievement"]}/).span.wait_until_present
      @BROWSER.div(:class, 'page-tabs__header').h3(:index, 1).p(:text, /#{HERMES_STRINGS["profile"]["achievement"]}/).span.click
      @BROWSER.div(:class, %w(user-achievements ng-scope)).span.wait_until_present
    else
      fail(msg = "Error. click_button. The option #{button} is not defined in menu.")
    end
  end

  # @param users_to_invite
  # Invites X amount of dependant/family users to the web app. Always deletes the 
  def invite_family_members (users_to_invite)    
    if @BROWSER.div(:text => HERMES_STRINGS["dependant_accounts"]["delete"]).present? 
      i = @BROWSER.divs(:text => HERMES_STRINGS["dependant_accounts"]["delete"]).count.to_i
    else
      i = 0
    end

    users_to_invite.times do
      i += 1
      dependant_counter = "#{rand(36**6).to_s(36)}"
      @EMAIL = "#{ACCOUNT[:"#{$account_index}"][:valid_account][:email_subdomain]}" + '+' + "#{ACCOUNT[:"#{$account_index}"][:valid_account][:country_code]}" + '+' + "dep" + '_' + "#{dependant_counter}" + '@' + "#{ACCOUNT[:"#{$account_index}"][:valid_account][:email_domain]}"
      @file_service.insert_to_file('dependant_account_user_name:', @EMAIL)
      @file_service.insert_to_file('dependant_counter:', dependant_counter)
      click_button('Invite family members')
      @TXF_INVITE_FAMILY_MEMBER_EMAIL.send_keys @EMAIL
      click_button('Send Invitation')
      
      if i > @MAX_INVITES_ALLOWED
        Watir::Wait.until { @BROWSER.divs(:text => HERMES_STRINGS["dependant_accounts"]["delete"]).count.to_i == i - 1 }
        validate_family_members_added_or_deleted('not added')
      else
        Watir::Wait.until { @BROWSER.divs(:text => HERMES_STRINGS["dependant_accounts"]["delete"]).count.to_i == i }
        validate_family_members_added_or_deleted('pending')
      end
    end
  end

  # @param users_to_delete
  # Deletes X amount of dependant/family users to the web app. Always deletes the first user in the list
  def delete_family_members (users_to_delete)
    # If users_to_delete value is set to 'all', the a count is made of all user listed on the page and the deletion loop will run that many times
    ( users_to_delete == 'all' ) ? users_to_delete = @BROWSER.divs(:text => HERMES_STRINGS["dependant_accounts"]["delete"]).count.to_i : users_to_delete = users_to_delete.to_i
 
      users_to_delete.times do
       if @BROWSER.div(:text => HERMES_STRINGS["dependant_accounts"]["delete"], :index => 0).present?
        count_of_users_before_deletion = @BROWSER.divs(:text => HERMES_STRINGS["dependant_accounts"]["delete"]).count.to_i
        @EMAIL = @BROWSER.element(css: "div[style^='display: inline-block; vertical-align: middle; width: 50%; overflow: hidden; text-overflow: ellipsis; max-width: 100%;']").text
        @BROWSER.div(:text => HERMES_STRINGS["dependant_accounts"]["delete"], :index => 0).click
        Watir::Wait.until { @BROWSER.divs(:text, HERMES_STRINGS["dependant_accounts"]["delete"]).count.to_i == count_of_users_before_deletion - 1 }
        validate_family_members_added_or_deleted('deleted')
        # if the email address being deleted matches the email stored in the ext file, then remove email value from ext file
        @EMAIL == @file_service.get_from_file('dependant_account_user_name:')[0..-2] ? ( $LATEST_DELETED_USER = @EMAIL ) && ( @file_service.insert_to_file('dependant_account_user_name:', '') ) : nil
      end
    end
  end

  def validate_family_members_added_or_deleted (status)
    status = status.downcase

    if status == 'pending'
      @BROWSER.p(:text, "#{HERMES_STRINGS["dependant_accounts"]["add_account"]} #{@EMAIL}").wait_until_present
      @BROWSER.p(:text, "#{HERMES_STRINGS["dependant_accounts"]["add_account"]} #{@EMAIL}").wait_while_present
      @LIST_DEPENDANT_USERS.div(:text, @EMAIL).parent.div(:text, 'Pending').wait_until_present
      @LIST_DEPENDANT_USERS.div(:text, @EMAIL).parent.div(:text, 'Delete').wait_until_present
      @BROWSER.span(:text, /#{HERMES_STRINGS["api_errors"]["dependant_already_limit"].gsub('%{limit}', "#{@MAX_INVITES_ALLOWED}")}/).wait_until_present
      puts "User with email address '#{@EMAIL}' has been added and is pending"
    elsif status == 'active'
      @EMAIL = @file_service.get_from_file('dependant_account_user_name:')[0..-2]
      @LIST_DEPENDANT_USERS.div(:text, @EMAIL).parent.div(:text, 'Active').wait_until_present
      @LIST_DEPENDANT_USERS.div(:text, @EMAIL).parent.div(:text, 'Delete').wait_until_present
      @BROWSER.span(:text, /#{HERMES_STRINGS["api_errors"]["dependant_already_limit"].gsub('%{limit}', "#{@MAX_INVITES_ALLOWED}")}/).wait_until_present
      puts "User with email address '#{@EMAIL}' has signed up and is active"
    elsif status == 'deleted'
      @BROWSER.p(:text, "#{@EMAIL} #{HERMES_STRINGS["dependant_accounts"]["remove_account"]}").wait_until_present 
      @BROWSER.p(:text, "#{@EMAIL} #{HERMES_STRINGS["dependant_accounts"]["remove_account"]}").wait_while_present
      @LIST_DEPENDANT_USERS.div(:text, @EMAIL).wait_while_present
      puts "User with email address '#{@EMAIL}' has been deleted"
    else status == 'not added'
      @BROWSER.p(:text, HERMES_STRINGS["api_errors"]["dependant_already_limit"].gsub('%{limit}', "#{@MAX_INVITES_ALLOWED}")).wait_until_present
      Watir::Wait.until { !@LIST_DEPENDANT_USERS.div(:text, @EMAIL).parent.div(:text, 'Pending').present? }
      Watir::Wait.until { !@LIST_DEPENDANT_USERS.div(:text, @EMAIL).parent.div(:text, 'Delete').present? }
      puts "User with email address '#{@EMAIL}' has been added as the max limit has been exceed"
    end

    if @BROWSER.div(:text => HERMES_STRINGS["dependant_accounts"]["delete"]).present?
      @LIST_DEPENDANT_USERS.div(:text, HERMES_STRINGS["dependant_accounts"]["email"]).wait_until_present
      @BROWSER.span(:text, /#{HERMES_STRINGS["api_errors"]["dependant_already_limit"].gsub('%{limit}', "#{@MAX_INVITES_ALLOWED}")}/).wait_until_present
    else
      @LIST_DEPENDANT_USERS.div(:text, HERMES_STRINGS["dependant_accounts"]["email"]).wait_while_present
    end
  end

  # Check that the profile is match to the give profile
  # @param profile - to match with
  def check_profile_is_match_to (profile)
    click_button('Edit Profile')
    puts "Role is #{USER_PROFILE[:"#{profile}"][:role_title]}"

    if @TXF_JOB_TITLE.value != USER_PROFILE[:"#{profile}"][:role_title]
      fail(msg = "Error. check_profile_is_match_to. Job title is not match. Job title is #{@TXF_JOB_TITLE.value}, but it should be #{USER_PROFILE[:"#{profile}"][:role_title]}")
    elsif @TXF_JOINED_DAY.value != USER_PROFILE[:"#{profile}"][:date_join_day]
      fail(msg = 'Error. check_profile_is_match_to. Joined day is not match.')
    elsif @TXF_JOINED_MONTH.value != USER_PROFILE[:"#{profile}"][:date_join_month_code]
      fail(msg = 'Error. check_profile_is_match_to. Joined month is not match.')
    elsif @TXF_JOINED_YEAR.value != USER_PROFILE[:"#{profile}"][:date_join_year]
      fail(msg = 'Error. check_profile_is_match_to. Joined year is not match.')
    elsif @TXF_PHONE.value !=  USER_PROFILE[:"#{profile}"][:phone]
      fail(msg = 'Error. check_profile_is_match_to. Phone number is not match.')
    elsif (@BROWSER.div(:id, 'gender').text).to_s != (USER_PROFILE[:"#{profile}"][:gender]).to_s
      fail(msg = 'Error. check_profile_is_match_to. Gender is not match.')
    elsif @TXF_MOBILE.value !=  USER_PROFILE[:"#{profile}"][:phone]
      fail(msg = 'Error. check_profile_is_match_to. Mobile number is not match.')
    elsif @TXF_BIRTH_DAY.value != USER_PROFILE[:"#{profile}"][:b_day_date]
      fail(msg = 'Error. check_profile_is_match_to. Birth day is not match.')
    elsif @TXF_BIRTH_MONTH.value != USER_PROFILE[:"#{profile}"][:b_day_month_code]
      fail(msg = 'Error. check_profile_is_match_to. Birth month is not match.')
    elsif @TXF_BIRTH_YEAR.value != USER_PROFILE[:"#{profile}"][:b_day_year]
      fail(msg = 'Error. check_profile_is_match_to. Birth year is not match.')
    elsif @TXF_ABOUT.value != USER_PROFILE[:"#{profile}"][:about]
      fail(msg = 'Error. check_profile_is_match_to. About text is not match.')
    end

    click_button('Save')
  end

  # Change the current profile to the give profile
  # @param profile - profile to change to
  def change_profile_data_to (profile)
    click_button('Edit Profile')
    puts "#{profile}"
    @TXF_JOB_TITLE.wait_until_present
    @TXF_JOB_TITLE.to_subtype.clear
    @TXF_JOB_TITLE.set USER_PROFILE[:"#{profile}"][:role_title]
    
    @TXF_JOINED_DAY.select USER_PROFILE[:"#{profile}"][:date_join_day]
    @TXF_JOINED_MONTH.select USER_PROFILE[:"#{profile}"][:date_join_month]
    @TXF_JOINED_YEAR.to_subtype.clear
    @TXF_JOINED_YEAR.send_keys USER_PROFILE[:"#{profile}"][:date_join_year]

    @TXF_PHONE.to_subtype.clear
    @TXF_PHONE.send_keys USER_PROFILE[:"#{profile}"][:phone]
    @BROWSER.div(:id, 'gender').click
    @BROWSER.div(:id, 'gender').parent.div(:class => 'flag__body', :text => "#{USER_PROFILE[:"#{profile}"][:gender]}").wait_until_present
    @BROWSER.div(:id, 'gender').parent.div(:class => 'flag__body', :text => "#{USER_PROFILE[:"#{profile}"][:gender]}").fire_event(:click)
    @TXF_MOBILE.to_subtype.clear
    @TXF_MOBILE.send_keys USER_PROFILE[:"#{profile}"][:phone]
    @TXF_PHONE.to_subtype.clear
    @TXF_PHONE.send_keys USER_PROFILE[:"#{profile}"][:phone]
    @TXF_BIRTH_DAY.select USER_PROFILE[:"#{profile}"][:b_day_date]
    @TXF_BIRTH_MONTH.select USER_PROFILE[:"#{profile}"][:b_day_month]
    @TXF_BIRTH_YEAR.to_subtype.clear
    @TXF_BIRTH_YEAR.send_keys USER_PROFILE[:"#{profile}"][:b_day_year]
    @TXF_ABOUT.set USER_PROFILE[:"#{profile}"][:about]
    click_button('Save')
  end

  def set_birthday_joined_data_today
    time = Time.new
    click_button('Edit Profile')
    
    @TXF_JOINED_DAY.select time.day
    @TXF_JOINED_MONTH.select time.month
    @TXF_JOINED_YEAR.to_subtype.clear
    @TXF_JOINED_YEAR.send_keys USER_PROFILE[:user1][:date_join_year]
    
    @TXF_BIRTH_DAY.select time.day
    @TXF_BIRTH_MONTH.select time.month
    @TXF_BIRTH_YEAR.to_subtype.clear
    @TXF_BIRTH_YEAR.send_keys USER_PROFILE[:user1][:b_day_year]

    click_button('Save')
  end


  # Check that the carousel have text in each bullet
  def check_carousel
    click_button('Edit Profile')
    user_name = @BROWSER.input(:id, 'firstName').value + ' ' + @BROWSER.input(:id, 'lastName').value
    user_job_title = @BROWSER.input(:id, 'jobTitle').value

    if !@BROWSER.input(:id, 'joinedDate-year').value.to_s.empty?
      joined_date_not_nil = true
    end
  
    if !@BROWSER.textarea(:id, 'aboutMe').value.to_s.empty?
      about_text = @BROWSER.textarea(:id, 'aboutMe').value
      about_text_not_nil = true
      about_text_length = @BROWSER.textarea(:id, 'aboutMe').value.length
    end  

    @BROWSER.button(:class, %w(btn btn--secondary btn--large)).wait_until_present
    @BROWSER.button(:class, %w(btn btn--secondary btn--large)).click
    @BTN_EDIT_PROFILE.wait_until_present
    @BROWSER.div(:class, %w(slick-slide slick-active)).h3(:text, "#{user_name}").wait_until_present
    @BROWSER.div(:class, %w(slick-slide slick-active)).h4(:text, "#{user_job_title}").wait_until_present

    if (joined_date_not_nil == true) && (about_text_not_nil == true)
      @BROWSER.ul(:class => 'slick-indicators').li(:index , 2).click
      @BROWSER.div(:class, %w(slick-slide slick-active)).h3(:text => HERMES_STRINGS["profile"]["card"]["about_me"]).wait_until_present

      if (about_text_length == 100)
        @BROWSER.a(:class, 'readMoreBtn').wait_until_present
        @BROWSER.a(:class, 'readMoreBtn').click
        @BROWSER.a(:class => 'readMoreBtn', :text => HERMES_STRINGS["components"]["read_more"]["read_less"]).wait_until_present 
      end     

      if !@BROWSER.div(:class, %w(slick-slide slick-active)).div(:text, /#{about_text}/).exists?
        fail("Error. check_carousel. Users About text does not match")
      end

      sleep(1)
      @BROWSER.ul(:class => 'slick-indicators').li(:index , 1).click
      @BROWSER.div(:class, %w(slick-slide slick-active)).h3(:text => /#{HERMES_STRINGS["profile"]["card"]["joined_2"].gsub('%{rootCompanyName}', ACCOUNT[:account_1][:valid_account][:company_nick_name])}/).wait_until_present
    elsif (joined_date_not_nil != true) && (about_text_not_nil == true)
      @BROWSER.ul(:class => 'slick-indicators').li(:index , 1).click
      @BROWSER.div(:class, %w(slick-slide slick-active)).h3(:text => HERMES_STRINGS["profile_edit"]["about_me"]).wait_until_present
    end
  end

  # Set/Unset 'Hide my age'
  # @param hide_my_age - True or False
  def hide_dont_hide_my_age (hide_my_age)
    @BROWSER.div(:id, 'hideAge').wait_until_present
    
    if !@BROWSER.input(:id, 'birthDate-year').value.to_s.empty?
      birthyear = @BROWSER.input(:id, 'birthDate-year').value
      birhtday_not_null = true
    end

    if hide_my_age == 'hide'
      if @BROWSER.div(:id, 'hideAge').img.src.to_s.include? 'checkbox_off'
        @BROWSER.div(:id, 'hideAge').click
        Watir::Wait.until{@BROWSER.div(:id, 'hideAge').img.src.to_s.include? 'checkbox_on'}
      end
    elsif hide_my_age == 'dont hide'
      if @BROWSER.div(:id, 'hideAge').img.src.to_s.include? 'checkbox_on'
        @BROWSER.div(:id, 'hideAge').click
        Watir::Wait.until{@BROWSER.div(:id, 'hideAge').img.src.to_s.include? 'checkbox_off'}
      end
    end

    click_button('Save')

    if (hide_my_age == 'hide') && (birhtday_not_null == true)
      @BROWSER.div(:id => 'birthday').wait_until_present
      dob_last_one =  @BROWSER.div(:id => 'birthday').parent.text[-1]
      puts "dob last 1 = #{dob_last_one}"
      if ((dob_last_one =~ /[a-z]/) != 0)
        fail("Error. hide_dont_hide_my_age. User birthday date is visible while 'Hide my age' button is ticked")
      end
    elsif (hide_my_age == 'dont hide') && (birhtday_not_null == true)
      if ((dob_last_one =~ /[a-z]/) == 0)
        fail("Error. hide_dont_hide_my_age. User birthday date is NOT visible while 'Hide my age' button is unticked")
      end
    end
    
  end

  # Untick all interests
  # @param tick_untick - 'tick' or 'untick'
  def tick_untick_all_interests (tick_untick)
    @BROWSER.div(:class => 'page', :index => 2).img.wait_until_present
    selectable_interests = @BROWSER.div(:class => 'page', :index => 2).imgs
   
    # Go over all the intersts and if they are selected, deselect them
    selectable_interests.each do |interest|

      if tick_untick == 'tick'
        if interest.parent.img(:src, /unselected/).exist?
          interest.fire_event('click')
          Watir::Wait.until {!interest.parent.img(:src, /unselected/).exist?}
        end
      elsif tick_untick == 'untick'
        if !interest.parent.img(:src, /unselected/).exist?
          interest.fire_event('click')
          Watir::Wait.until {interest.parent.img(:src, /unselected/).exist?}
        end       
      end
    end

    click_button('Save changes')

    if tick_untick == 'tick'
      @BTN_INTERESTS.parent.span(:text, '15').wait_until_present
    else
      @BTN_INTERESTS.parent.span(:text, '0').wait_until_present
    end
  end

  # Validate achievements
  def validate_achievements
    @achievements_counter = 0
    validate_medals
    validate_milstones
    total_achievements_recived = /\d+/.match(@BROWSER.div(:class, 'page-tabs__header').a(:text, /#{HERMES_STRINGS["profile"]["profile"]["achievement"]}/).parent.text)[0].to_i 
    puts "Total achievements #{total_achievements_recived}"
    
    if total_achievements_recived != @achievements_counter 
      fail(msg = "Error. validate_achievements. Total achievements is #{total_achievements_recived} while #{@achievements_counter} was found")
    else
      puts "Total achievements is #{total_achievements_recived} and #{@achievements_counter} was found"
    end
  end

  # Validate medals and milstones
  def validate_medals
    @BROWSER.div(:id, 'view').send_keys [:down]*2
    sleep(0.5)

    for i in 0..2
      if i == 0
        current_medal = 'gold'
      elsif i == 1
        current_medal = 'silver'
      else 
        current_medal = 'bronze'
      end

      puts "current_medal: #{current_medal}"
      @BROWSER.div(:class, 'user-medals').div(:class, /medal #{current_medal}/).span.wait_until_present
      medal_counter = @BROWSER.div(:class, 'user-medals').div(:class, /medal #{current_medal}/).span.text.to_i
      puts "medal_counter: #{medal_counter}"
      @achievements_counter += medal_counter

      @BROWSER.div(:class, 'user-medals').div(:class, /medal #{current_medal}/).hover
      if medal_counter == 0
        @BROWSER.div(:class, 'user-medals').div(:class, /medal #{current_medal} no-medal active/).div(:class => 'no-medal-detail', :text => /#{HERMES_STRINGS["profile"]["achievements"]["earn_medal"]}/).wait_until_present
      else 
        @BROWSER.div(:class, 'user-medals').div(:class, /medal #{current_medal}/).div(:class, 'medal-detail').wait_until_present
      end
    end
  end

  # Validate milstones
  def validate_milstones
    @BROWSER.div(:class, 'page-tabs__header').span(:text, HERMES_STRINGS["profile"]["achievements"]["recognitions"]).wait_until_present
    total_recognition_recived = (/\d+/.match (@BROWSER.div(:class, 'page-tabs__header').span(:text, HERMES_STRINGS["profile"]["achievements"]["recognitions"]).parent.text))[0].to_i

    puts "User got #{total_recognition_recived} recogntions"

    if total_recognition_recived >= 25
      @BROWSER.div(:class, /milestone newbie complete/).wait_until_present
      puts "Milstone newbie"
      @achievements_counter += 1
    else
      @BROWSER.div(:class, /milestone newbie  incomplete/).wait_until_present
      puts "User should not have any Milstone"
    end

    if total_recognition_recived >= 50
      @BROWSER.div(:class, /milestone hotshot complete/).wait_until_present
      puts "Milstone hotshot"
      @achievements_counter += 1
    else
      @BROWSER.div(:class, /milestone hotshot  incomplete/).wait_until_present
    end

    if total_recognition_recived >= 100
      @BROWSER.div(:class, /milestone rockstar complete/).wait_until_present
      puts "Milstone rock-star"
      @achievements_counter += 1
    else
      @BROWSER.div(:class, /milestone rockstar  incomplete/).wait_until_present
    end

    if total_recognition_recived >= 200
      @BROWSER.div(:class, 'milestone master complete').wait_until_present
      puts "Milstone master"
      @achievements_counter += 1
    else
      @BROWSER.div(:class, /milestone master  incomplete/).wait_until_present
    end

    if total_recognition_recived >= 500
      @BROWSER.div(:class, 'milestone champion complete').wait_until_present
      puts "Milstone champion"
      @achievements_counter += 1
    else
      @BROWSER.div(:class, /milestone champion  incomplete/).wait_until_present
    end

    if total_recognition_recived >= 1000
      @BROWSER.div(:class, 'milestone legend complete').wait_until_present
      puts "Milstone legend"
      @achievements_counter += 1
    else
      @BROWSER.div(:class, /milestone legend  incomplete/).wait_until_present
    end
  end

  def validate_settings 
     @BROWSER.div(:class => 'title-velocity-hook', :text => HERMES_STRINGS["settings"]["title"]).wait_until_present
  end

end
    
