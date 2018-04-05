# -*- encoding : utf-8 -*-
class ZeusUserProfilePage

  def initialize (browser)
    @BROWSER = browser

    @BTN_PERFORMANCE = @BROWSER.ul(:class, %w(nav nav-tabs nav-justified)).a(:text, ZEUS_STRINGS["leaderboard"]["performance"]["performance"])
    @BTN_ENGAGEMENT = @BROWSER.ul(:class, %w(nav nav-tabs nav-justified)).a(:text, ZEUS_STRINGS["leaderboard"]["engagement"]["engagement"])
    @BTN_ACHIEVEMENTS = @BROWSER.ul(:class, %w(nav nav-tabs nav-justified)).a(:text, ZEUS_STRINGS["leaderboard"]["achievements"]["achievements"])
    @BTN_MONTHS = @BROWSER.a(:class, 'filter-dropdown__toggle')
    @BTN_MAKE_ADMIN = @BROWSER.div(:class => 'body-2', :text => /#{ZEUS_STRINGS["user_profile"]["actions"]["make_admin"]}/)
    @BTN_REVOKE_ADMIN_PERMISSION = @BROWSER.div(:class => 'body-2', :text => /#{ZEUS_STRINGS["user_profile"]["actions"]["revoke_admin"]}/)
    @BTN_EDIT_PROFILE = @BROWSER.div(:class => 'body-2', :text => /#{ZEUS_STRINGS["user_profile"]["actions"]["edit_profile"]}/)
    @BTN_SAVE = @BROWSER.button(:class => %w(btn btn-success), :text => ZEUS_STRINGS["user_profile"]["save_btn"])
    @BTN_CANCEL = @BROWSER.div(:class, %w(btn btn-inverse))
    @BTN_ARCHIVE_USER = @BROWSER.div(:text, ZEUS_STRINGS["user_profile"]["actions"]["archive"])
    @BTN_ARCHIVE = @BROWSER.button(:text, ZEUS_STRINGS["user_profile"]["actions"]["archive"])
    #@BTN_ACTIVATE = @BROWSER.button(:text, 'Activate')
    @BTN_REACTIVATE = @BROWSER.button(:text, ZEUS_STRINGS["user_profile"]["react_btn"])
    @BTN_USER_SETTINGS = @BROWSER.a(:class => 'link',:text => ZEUS_STRINGS["post_login"]["settings"])
    @LBL_CHANGES_SAVED = @BROWSER.element(:text, ZEUS_STRINGS["user_profile"]["changes_saved"])
    @LBL_EDIT_USER = @BROWSER.h2(:text, ZEUS_STRINGS["user_profile"]["edit_colleague"])
    @TXF_EMPLOYEE_TITLE = @BROWSER.text_field(:class, %w(job-title ng-valid ng-dirty ng-touched))
    @IMG_SPINNER = @BROWSER.div(:class, %w(spinner full-screen))
  end

  def click_button (button)
    case button
    when 'months'
      @BTN_MONTHS.wait_until_present
      @BTN_MONTHS.click
      @BROWSER.li(:class, %w(filter-dropdown__item selected)).exists?
    when 'Edit profile'
      @BTN_EDIT_PROFILE.wait_until_present 
      @BTN_EDIT_PROFILE.click
      @LBL_EDIT_USER.wait_until_present
    when 'Save'
      @BTN_SAVE.wait_until_present
      @BTN_SAVE.click
      @BTN_SAVE.wait_while_present
      @BROWSER.div(:class, %w(toast__item velocity-opposites-transition-slideDownBigIn ng-scope toast-approved)).wait_until_present
      @BROWSER.div(:class, %w(toast__item velocity-opposites-transition-slideDownBigIn ng-scope toast-approved)).wait_while_present
    when 'Archive user'
      @BTN_ARCHIVE_USER.wait_until_present
      @BTN_ARCHIVE_USER.click
      @BTN_ARCHIVE.wait_until_present
    when 'Activate'
      #@BTN_ACTIVATE.wait_until_present
      #@BTN_ACTIVATE.click
      #@BTN_REACTIVATE.wait_until_present
    when 'Archive'
      @BTN_ARCHIVE.wait_until_present
      @BTN_ARCHIVE.click
      @BTN_ARCHIVE.wait_while_present
      @BTN_REACTIVATE.wait_until_present
      # Re enable line below when LT-2005 has been fixed
      # @BROWSER.element(:text => /has been deactivated and has been moved to the Archived Users section/).wait_until_present
    when 'Reactivate'
      @BTN_REACTIVATE.wait_until_present
      @BTN_REACTIVATE.click
    when 'Performance'
      @BTN_PERFORMANCE.wait_until_present
      @BTN_PERFORMANCE.click
      @BROWSER.div(:class, %w(performance-container ng-scope)).wait_until_present
    when 'Engagement'
      @BTN_ENGAGEMENT.wait_until_present
      @BTN_ENGAGEMENT.click
      @BROWSER.div(:class, %w(engagement-container ng-scope)).wait_until_present
    when 'Achievements'
      @BTN_ACHIEVEMENTS.wait_until_present
      @BTN_ACHIEVEMENTS.click
      is_visible('Achievements')
    when 'User settings'
      @BTN_USER_SETTINGS.wait_until_present
      @BTN_USER_SETTINGS.click
      @BTN_EDIT_PROFILE .wait_until_present
    when 'Revoke admin permission'
      @BTN_REVOKE_ADMIN_PERMISSION.wait_until_present
      @BTN_REVOKE_ADMIN_PERMISSION.click
      @BTN_REVOKE_ADMIN_PERMISSION.wait_while_present
    when 'Make Admin'
      @BTN_MAKE_ADMIN.wait_until_present
      @BTN_MAKE_ADMIN.click
      @BTN_MAKE_ADMIN.wait_while_present
    else
      fail(msg = "Error. click_button. The option #{button} is not defined in menu.")
    end
  end

  # Check that page element are in the page
  # @param page - page to check
  def is_visible (page = nil)
    @BTN_PERFORMANCE.wait_until_present
    @BTN_ENGAGEMENT.wait_until_present
    @BTN_ACHIEVEMENTS.wait_until_present
    @BROWSER.div(:class, 'user-profile-view').img(:class, %w(img-circle img-responsive center-block)).wait_until_present
    @BROWSER.div(:class, %w(description text-center)).wait_until_present
    @BROWSER.div(:class, 'user-profile-view-info').wait_until_present
    @BROWSER.div(:class, 'job-title').wait_until_present
    
    case page
    when 'profile_update'
      @BROWSER.text_field(:name, 'tel_work').wait_until_present
      @BROWSER.text_field(:name, 'job_title').wait_until_present
      @BROWSER.select(:name, 'gender').wait_until_present
      @BROWSER.text_field(:name, 'birthday_day').wait_until_present
      @BROWSER.select(:name, 'birthday_month').wait_until_present
      @BROWSER.text_field(:name, 'work_start_day').wait_until_present
      @BROWSER.select(:name, 'work_start_month').wait_until_present
      @BROWSER.text_field(:name, 'work_start_year').wait_until_present
      @BTN_SAVE.wait_until_present
      @BTN_CANCEL.wait_until_present
    when 'Achievements'
      @BROWSER.div(:class, %w(achievements-container ng-scope)).wait_until_present
      @BROWSER.div(:class, 'medals-container').div(:class, %w(icon gold)).wait_until_present
      @BROWSER.div(:class, 'medals-container').div(:class, %w(icon silver)).wait_until_present
      @BROWSER.div(:class, 'medals-container').div(:class, %w(icon bronze)).wait_until_present
      @BROWSER.div(:class => %w(heading text-center), :text => 'Milestones').wait_until_present
      @BROWSER.span(:text, 'Recognition by Values').wait_until_present
      @BROWSER.img(:class => 'img-responsive', :title => 'Organised').wait_until_present
      @BROWSER.img(:class => 'img-responsive', :title => 'Full Of Energy').wait_until_present
      @BROWSER.img(:class => 'img-responsive', :title => 'Creative').wait_until_present
      @BROWSER.img(:class => 'img-responsive', :title => 'Mathematician').wait_until_present
      @BROWSER.img(:class => 'img-responsive', :title => 'Genius').wait_until_present
      @BROWSER.img(:class => 'img-responsive', :title => 'Late Worker').wait_until_present
      @BROWSER.img(:class => 'img-responsive', :title => 'Inspired').wait_until_present
      @BROWSER.img(:class => 'img-responsive', :title => 'Positive Attitude').wait_until_present
      @BROWSER.img(:class => 'img-responsive', :title => 'Newbie').wait_until_present
      @BROWSER.img(:class => 'img-responsive', :title => 'Helpful').wait_until_present
      @BROWSER.img(:class => 'img-responsive', :title => 'Customer Is Always Right').wait_until_present
      @BROWSER.img(:class => 'img-responsive', :title => 'Superstar').wait_until_present
      @BROWSER.img(:class => 'img-responsive', :title => 'Leadership').wait_until_present
      @BROWSER.img(:class => 'img-responsive', :title => 'Passion').wait_until_present
      @BROWSER.img(:class => 'img-responsive', :title => 'Social Butterfly').wait_until_present
      @BROWSER.img(:class => 'img-responsive', :title => 'Presentation Skills').wait_until_present
      @BROWSER.img(:class => 'img-responsive', :title => 'Team Player').wait_until_present
      @BROWSER.img(:class => 'img-responsive', :title => 'Star').wait_until_present
      @BROWSER.img(:class => 'img-responsive', :title => 'Recognition').wait_until_present
    end
  end

  # Change profile
  # @param profile - change the current profile to 'profile' 
  def change_profile_data_to (profile)
    click_button('User settings')
    click_button('Edit profile')
    is_visible('profile_update')

    if profile == 'user1'
      @BROWSER.text_field(:name, 'job_title').set USER_PROFILE[:user1][:role_title]
      @BROWSER.text_field(:name, 'tel_work').set USER_PROFILE[:user1][:phone]
      @BROWSER.select(:name, 'gender').select USER_PROFILE[:user1][:gender]
      @BROWSER.text_field(:name, 'birthday_day').set USER_PROFILE[:user1][:b_day_date]
      @BROWSER.select(:name, 'birthday_month').select USER_PROFILE[:user1][:b_day_month]
      @BROWSER.text_field(:name, 'birthday_year').set USER_PROFILE[:user1][:b_day_year]
      @BROWSER.text_field(:name, 'work_start_day').set USER_PROFILE[:user1][:date_join_day]
      @BROWSER.select(:name, 'work_start_month').select USER_PROFILE[:user1][:date_join_month]
      @BROWSER.text_field(:name, 'work_start_year').set USER_PROFILE[:user1][:date_join_year]
    else
      @BROWSER.text_field(:name, 'job_title').set USER_PROFILE[:user2][:role_title]
      @BROWSER.text_field(:name, 'tel_work').set USER_PROFILE[:user2][:phone]
      @BROWSER.select(:name, 'gender').select USER_PROFILE[:user2][:gender]
      @BROWSER.text_field(:name, 'birthday_day').set USER_PROFILE[:user2][:b_day_date]
      @BROWSER.select(:name, 'birthday_month').select USER_PROFILE[:user2][:b_day_month]
      @BROWSER.text_field(:name, 'birthday_year').set USER_PROFILE[:user2][:b_day_year]
      @BROWSER.text_field(:name, 'work_start_day').set USER_PROFILE[:user2][:date_join_day]
      @BROWSER.select(:name, 'work_start_month').select USER_PROFILE[:user2][:date_join_month]
      @BROWSER.text_field(:name, 'work_start_year').set USER_PROFILE[:user2][:date_join_year]
    end

    click_button('Save')
    is_visible
  end

  # Check that the current profile date are like 'profile'
  # @param - Profile to compare with
  def check_that_profile_as_change_to(profile)
    if profile == 'user2'
      if @BROWSER.text_field(:name, 'job_title').value != USER_PROFILE[:user2][:role_title]
        fail(msg = 'Error. check_that_profile_as_change_to_user2. Job title is not match.')
      elsif @BROWSER.text_field(:name, 'tel_work').value != USER_PROFILE[:user2][:phone]
        fail(msg = 'Error. check_that_profile_as_change_to_user2. Phone is not match.')
      elsif @BROWSER.select(:name, 'gender').value != USER_PROFILE[:user2][:gender_code]
        fail(msg = 'Error. check_that_profile_as_change_to_user2.')
      # elsif @BROWSER.text_field(:name, 'birthday_day').value != USER_PROFILE[:user2][:b_day_date]
      #   fail(msg = 'Error. check_that_profile_as_change_to_user2. Day of birthday is not match.')
      # elsif @BROWSER.select(:name, 'birthday_month').value != USER_PROFILE[:user2][:b_day_month_code]
      #   fail(msg = 'Error. check_that_profile_as_change_to_user2. Month of birthday is not match.')
      # elsif @BROWSER.text_field(:name, 'birthday_year').value != USER_PROFILE[:user2][:b_day_year]
      #   fail(msg = 'Error. check_that_profile_as_change_to_user2. Year of birthday is not match.')
      # elsif @BROWSER.text_field(:name, 'work_start_day').value != USER_PROFILE[:user2][:date_join_day]
      #   fail(msg = 'Error. check_that_profile_as_change_to_user2. Day of joined is not match.')
      # elsif @BROWSER.select(:name, 'work_start_month').value != USER_PROFILE[:user2][:date_join_month_code]
      #   fail(msg = 'Error. check_that_profile_as_change_to_user2. Month of joined is not match.')
      # elsif @BROWSER.text_field(:name, 'work_start_year').value != USER_PROFILE[:user2][:date_join_year]
      #   fail(msg = 'Error. check_that_profile_as_change_to_user2. Year of joined is not match.')
      end
    else
      if @BROWSER.text_field(:name, 'job_title').value != USER_PROFILE[:user1][:role_title]
        fail(msg = 'Error. check_that_profile_as_change_to_user2. Job title is not match.')
      elsif @BROWSER.text_field(:name, 'tel_work').value !=  USER_PROFILE[:user1][:phone]
        fail(msg = 'Error. check_that_profile_as_change_to_user2. Phone is not match.')
      elsif @BROWSER.select(:name, 'gender').value != USER_PROFILE[:user1][:gender_code]
        fail(msg = 'Error. check_that_profile_as_change_to_user2. Gender is not match.')
      # elsif @BROWSER.text_field(:name, 'birthday_day').value != USER_PROFILE[:user1][:b_day_date]
      #   fail(msg = 'Error. check_that_profile_as_change_to_user2. Day of birthday is not match.')
      # elsif @BROWSER.select(:name, 'birthday_month').value != USER_PROFILE[:user1][:b_day_month_code]
      #   fail(msg = 'Error. vvalue. Month of birthday is not match.')
      # elsif @BROWSER.text_field(:name, 'birthday_year').value != USER_PROFILE[:user1][:b_day_year]
      #   fail(msg = 'Error. check_that_profile_as_change_to_user2. Year of birthday is not match.')
      # elsif @BROWSER.text_field(:name, 'work_start_day').value != USER_PROFILE[:user1][:date_join_day]
      #   fail(msg = 'Error. check_that_profile_as_change_to_user2. Day of joined is not match.')
      # elsif @BROWSER.select(:name, 'work_start_month').value != USER_PROFILE[:user1][:date_join_month_code]
      #   fail(msg = 'Error. check_that_profile_as_change_to_user2. Month of joined is not match.')
      # elsif @BROWSER.text_field(:name, 'work_start_year').value != USER_PROFILE[:user1][:date_join_year]
      #   fail(msg = 'Error. check_that_profile_as_change_to_user2. Year of joined is not match.')
      end 
    end
  end

  # Deactivate user
  def deactivate_user
    click_button('User settings')
    click_button('Archive user')
    click_button('Archive')
  end

  # Reactivate user
  def reactivate_user
    click_button('User settings')
    click_button('Reactivate')
    @BROWSER.div(:class, 'modal-content').button(:class => %w(btn btn-primary), :text => ZEUS_STRINGS["employee"]["archived"]["react_btn"]).wait_until_present
    @BROWSER.div(:class, 'modal-content').button(:class => %w(btn btn-primary), :text => ZEUS_STRINGS["employee"]["archived"]["react_btn"]).click
    @BROWSER.div(:class, 'modal-content').button(:class => %w(btn btn-primary), :text => ZEUS_STRINGS["employee"]["archived"]["react_btn"]).wait_while_present
  end

  # Validate the total amount of recognitions that the user sent (Engagement)
  def valid_total_amount_of_recognition_given
    @BROWSER.div(:class, 'user-profile-view-info').div(:class => %w(col-xs-4 user-profile-view-info-item), :index => 2).wait_until_present
    total_recognition_given_from_summery = @BROWSER.div(:class, 'user-profile-view-info').div(:class => %w(col-xs-4 user-profile-view-info-item), :index => 2).h4.text.to_i
    
    @BROWSER.a(:class, 'filter-dropdown__toggle').wait_until_present
    current_month = @BROWSER.a(:class, 'filter-dropdown__toggle').text
        
    # if user didn't sent recognitions this month or for All Time
    if @BROWSER.div(:class, /no-recognitions/).present?
      if current_month == 'All Time' && total_recognition_given_from_summery != 0
        fail(msg = "Error. valid_total_amount_of_recognition_given. Total recognition given from summery is #{total_recognition_given_from_summery} while in Engagement there are no recognition")
      else
        puts "No recognitions was sent for #{current_month}"
        return
      end
    end

    @BROWSER.a(:class, 'filter-dropdown__toggle').wait_until_present

    if 'All Time' == @BROWSER.a(:class, 'filter-dropdown__toggle').text
      total_recognition_from_engagement = total_recognition_given_from_summery
    else
      total_recognition_from_engagement = (/\d+/.match @BROWSER.div(:class, 'toolbar').text)[0].to_i
    end

    i = 0
    recognition_counter = 0
    @BROWSER.div(:class, %w(panel panel-post ng-scope)).wait_until_present
    while @BROWSER.div(:class => %w(panel panel-post ng-scope), :index => i).exists?
      recognition_recivers = @BROWSER.div(:class => %w(panel panel-post ng-scope), :index => i).div(:class, 'panel-recognition-signature').text

      # validate current month against the timestamp in the post
      if current_month != 'All Time'
        # TODO: to fix the logic for checking the date
        #@BROWSER.div(:class => 'panel panel-post ng-scope', :index => i).div(:class, 'col-xs-9 panel-post-content').h3(:text, current_month).wait_until_present
      end

      i += 1
      recognition_counter = i

      # scroll the page
      if i % 2 == 0
        @BROWSER.scroll.to :bottom
        sleep(0.3)
      end
    end

    if total_recognition_from_engagement != recognition_counter
      fail(msg = "Error. valid_total_amount_of_recognition. Total recognition is not equal to the amount of recognitions that was found. total_recognition_from_engagement:#{total_recognition_from_engagement} recognition_counter:#{recognition_counter}")
    end
    puts "According to Engagement #{total_recognition_from_engagement} recognitions was sent by the user for #{current_month} and #{recognition_counter} was found in the Engagement list"
  end

  # Validate the total amount of recognitions that the user received
  def valid_total_amount_of_recognition_received
    @BROWSER.div(:class, 'user-profile-view-info').div(:class => %w(col-xs-4 user-profile-view-info-item), :index => 1).wait_until_present
    total_recognition_recived_from_summery = @BROWSER.div(:class, 'user-profile-view-info').div(:class => %w(col-xs-4 user-profile-view-info-item), :index => 1).h4.text.to_i

    @BROWSER.a(:class, 'filter-dropdown__toggle').wait_until_present
    current_month = @BROWSER.a(:class, 'filter-dropdown__toggle').text
    
    # if user didn't received recogntions for this month or All Time
    if @BROWSER.div(:class, /no-recognitions/).present?
      if current_month == 'All Time' && total_recognition_recived_from_summery != 0
        fail(msg = "Error. valid_total_amount_of_recognition_received. Total recognition recived from summery is #{total_recognition_from_summery} while in Performance there are no recognition")
      else
        puts "No recognitions was received for All Time"
        return
      end
    end
    
    # if user didn't received recogntions for the current month
    if @BROWSER.div(:class, %w(no-recognitions total ng-scope)).present?
      puts "No recognitions was received for #{current_month}"
      return
    end

    @BROWSER.div(:class, %w(tabset ng-isolate-scope)).div(:class, 'tab-content').wait_until_present
    @BROWSER.a(:class, 'filter-dropdown__toggle').wait_until_present

    if current_month == 'All Time'
      total_recognition_from_performance = total_recognition_recived_from_summery
    else
      if @BROWSER.div(:class, %w(no-recognitions month ng-scope)).present?
        total_recognition_from_performance = 0
        puts "recognition_counter: #{total_recognition_from_performance}"
      else
        @BROWSER.div(:class, 'toolbar').wait_until_present
        total_recognition_from_performance = (/\d+/.match @BROWSER.div(:class, 'toolbar').text)[0].to_i
        puts "recognition_counter: #{total_recognition_from_performance}"
      end
    end

    i = 0
    recognition_counter = 0
    
    while @BROWSER.div(:class => %w(panel panel-post ng-scope), :index => i).exists?
      recognition_sender = @BROWSER.div(:class => %w(panel panel-post ng-scope), :index => i).div(:class, 'panel-recognition-signature').text

      # validate current month against the timestamp in the post
      # if current_month != 'All Time'
      #   @BROWSER.div(:class => 'panel panel-post ng-scope', :index => i).div(:class, 'col-xs-9 panel-post-content').h3(:text, /#{current_month[0..2]}/).wait_until_present
      # end

      # count the number of user that re-recognized this post
      if (recognition_sender.match /.* and /) == nil
        recognition_counter += 1
      else
        recognition_counter +=  /\d+/.match((recognition_sender.match /and .*/)[0])[0].to_i + 1
      end

      i += 1

      # scroll the page
      if i % 2 == 0
        @BROWSER.scroll.to :bottom
        sleep(0.3)
      end
    end

    if total_recognition_from_performance != recognition_counter
      fail(msg = "Error. valid_total_amount_of_recognition. Total recognition is not equal to the amount of recognitions that was found. total_recognition_from_performance:#{total_recognition_from_performance} recognition_counter:#{recognition_counter}")
    end
    puts "Accourding to Performance #{total_recognition_from_performance} recognitions was given to the user for #{current_month} and #{recognition_counter} was found in the Performance list"
  end

  # Counting the amount of each badge that the user sent to his colleagues
  def count_badges_by_type
    @BADGE_COUNTER = {
      '#welcome' => 0,
      '#sociable' => 0,
      '#recognition' => 0,
      '#presentable' => 0,
      '#mathematician' => 0,
      '#superstar' => 0,
      '#inspired' => 0,
      '#creative' => 0,
      '#leadership' => 0,
      '#passionate' => 0,
      '#helpful' => 0,
      '#customerfocus' => 0,
      '#positive' => 0,
      '#energetic' => 0,
      '#einstein' => 0,
      '#star' => 0,
      '#organised' => 0,
      '#nightowl' => 0,
    }

    i = 0

    if @BROWSER.span(:text, /#{ZUES_STRINGS["user_profile"]["performance"]["label_1"].gsub('%{firstName} %{lastName} ','')}/).exists?
      return
    else  
      @BROWSER.div(:class, %w(panel panel-post ng-scope)).wait_until_present
    end

    while @BROWSER.div(:class => %w(panel panel-post ng-scope), :index => i).exists?
      @BROWSER.div(:class => %w(panel panel-post ng-scope), :index => i).div(:class, %w(col-xs-9 panel-post-content)).h3.wait_until_present
      hash_teg = ((@BROWSER.div(:class => %w(panel panel-post ng-scope), :index => i).div(:class, %w(col-xs-9 panel-post-content)).h3.text).match /#.*/)[0]
      puts "#{hash_teg}"
      counter = @BADGE_COUNTER["#{hash_teg}"].to_i
      counter += 1
      @BADGE_COUNTER["#{hash_teg}"] = counter

      i += 1

      # scroll the page
      if i % 2 == 0
        @BROWSER.div(:class, 'panel-body').send_keys :up
        sleep(1)
        @BROWSER.div(:class, 'panel-body').send_keys :space
        sleep(1)
      end
    end
  end

  # Go over the @BADGES_COUNTER array and compere the total in the array with the total of "Recognitions by value" 
  def match_total_amount_of_badges
    @BADGE_COUNTER.each {|badge_hashtag, badge_counter| 
      badge_name = BADGES[badge_hashtag]
      amount =  @BROWSER.div(:class => %w(count ng-binding), :text =>/#{badge_name}/).parent.div(:class, %w(icon-count ng-binding)).text.to_i
      if amount != badge_counter
        fail(msg = "ERROR. match_total_amount_of_badges. Total amonut for badge #{badge_name} in 'Recognitions by value' is #{amount} while expected to #{badge_counter}") 
      end
      puts "#{badge_name}"
      puts "#{@BROWSER.div(:class => %w(count ng-binding), :text =>/#{badge_name}/).parent.div(:class, %w(icon-count ng-binding)).text.to_i}"
    }
  end

  # Check that the correrct images are shown in the Milestines accourding to the total regocnitions that the user received
  def check_milestones
    total_recognition_from_summery = @BROWSER.div(:class, 'user-profile-view-info').div(:class => %w(col-xs-4 user-profile-view-info-item), :index => 1).h4.text.to_i  
    puts "User got #{total_recognition_from_summery} recogntions"

    if total_recognition_from_summery >= 25
      @BROWSER.div(:class, 'milestones-icons').li(:index, 0).img(:src, '/img/milestone-icon-newbie.png').wait_until_present
      puts "Milstone newbie"
    else
      @BROWSER.div(:class, 'milestones-icons').li(:index, 0).img(:src, '/img/milestone-icon-inactive.png').wait_until_present
      puts "User should not have any Milstone"
    end

    if total_recognition_from_summery >= 50
      @BROWSER.div(:class, 'milestones-icons').li(:index, 1).img(:src, '/img/milestone-icon-star.png').wait_until_present
      puts "Milstone star"
    else
      @BROWSER.div(:class, 'milestones-icons').li(:index, 1).img(:src, '/img/milestone-icon-inactive.png').wait_until_present
    end

    if total_recognition_from_summery >= 100
      @BROWSER.div(:class, 'milestones-icons').li(:index, 2).img(:src, '/img/milestone-icon-rock-star.png').wait_until_present
      puts "Milstone rock-star"
    else
      @BROWSER.div(:class, 'milestones-icons').li(:index, 2).img(:src, '/img/milestone-icon-inactive.png').wait_until_present
    end

    if total_recognition_from_summery >= 200
      @BROWSER.div(:class, 'milestones-icons').li(:index, 3).img(:src, '/img/milestone-icon-vip.png').wait_until_present
      puts "Milstone vip"
    else
      @BROWSER.div(:class, 'milestones-icons').li(:index, 3).img(:src, '/img/milestone-icon-inactive.png').wait_until_present
    end

    if total_recognition_from_summery >= 500
      @BROWSER.div(:class, 'milestones-icons').li(:index, 4).img(:src, '/img/milestone-icon-ace.png').wait_until_present
      puts "Milstone ace"
    else
      @BROWSER.div(:class, 'milestones-icons').li(:index, 4).img(:src, '/img/milestone-icon-inactive.png').wait_until_present
    end

    if total_recognition_from_summery >= 1000
      @BROWSER.div(:class, 'milestones-icons').li(:index, 5).img(:src, '/img/milestone-icon-legend.png').wait_until_present
      puts "Milstone legend"
    else
      @BROWSER.div(:class, 'milestones-icons').li(:index, 5).img(:src, '/img/milestone-icon-inactive.png').wait_until_present
    end
  end

  # Validate Performance and engagement for every month
  # TODO to complete logic 
  def check_performance_and_engagment_for_every_month
    click_button('months') 
    @BROWSER.section(:class, %w(filter-dropdown pull-right)).li(:class, 'filter-dropdown__item_title').wait_until_present

    number_of_years = @BROWSER.section(:class, %w(filter-dropdown pull-right)).lis(:class, 'filter-dropdown__item_title').count

    for i in 0..number_of_years - 1
      if ! @BROWSER.ul(:class, 'filter-dropdown__menu').li(:class, 'filter-dropdown__item_title').present?
        click_button('months') 
      end

      current_year = @BROWSER.li(:class, %w(filter-dropdown__item selected)).parent.li(:class, 'filter-dropdown__item_title').text
      number_of_months = @BROWSER.li(:class, %w(filter-dropdown__item selected)).parent.li(:class, 'filter-dropdown__item_title').parent.lis(:class, %w(filter-dropdown__item )).count
      
      for j in 1..number_of_months - 1
        if !@BROWSER.ul(:class, 'filter-dropdown__menu').li(:class, 'filter-dropdown__item_title').present?
          click_button('months') 
        end

        if j == 1
          current_month = @BROWSER.ul(:class, 'filter-dropdown__menu').li(:class => 'filter-dropdown__item selected').text
        else
          current_month = @BROWSER.ul(:class, 'filter-dropdown__menu').li(:class => 'filter-dropdown__item_title', :text => current_year).parent.li(:class => 'filter-dropdown__item ', :index => j).text
          change_month(current_month, current_year)
        end

        valid_total_amount_of_recognition_received
        click_button('Engagement')
        change_month(current_month, current_year)
        valid_total_amount_of_recognition_given
        click_button('Performance')

        j == 5 ? break : nil
      end
    end
  end

  # Change month by index
  # @param month
  def change_month (month, year)
    if year == nil 
      year = Date.today.year
    end

    puts "month:#{month} year:#{year}"
    
    if ! @BROWSER.ul(:class, 'filter-dropdown__menu').li(:class => 'filter-dropdown__item_title', :text => "#{year}").parent.li(:class => 'filter-dropdown__item ', :text => "#{month}").present?
      click_button('months')
    end

    if ((/\d+/).match "#{month}") != nil
      @BROWSER.ul(:class, 'filter-dropdown__menu').li(:class => /filter-dropdown__item/, :index => (month + 1)).wait_until_present
      @BROWSER.ul(:class, 'filter-dropdown__menu').li(:class => /filter-dropdown__item/, :index => (month + 1)).click
    else
      @BROWSER.ul(:class, 'filter-dropdown__menu').li(:class => 'filter-dropdown__item_title', :text => year).parent.li(:class => /filter-dropdown__item /, :text => month).wait_until_present
      @BROWSER.ul(:class, 'filter-dropdown__menu').li(:class => 'filter-dropdown__item_title', :text => year).parent.li(:class => /filter-dropdown__item /, :text => month).click
    end

  end

  # Add/Remove user from admin list
  # @param action - 'add' or 'remove'
  # @param user_name
  def add_remove_user_from_admin_list (action, user_name)
    if action == 'add'
      click_button('User settings')
      click_button('Make Admin')

      @BROWSER.div(:class, 'modal-dialog').h1(:text, user_name).wait_until_present
      @BROWSER.div(:class, 'modal-dialog').strong(:text, ZEUS_STRINGS["user_profile"]["confirm_new_admin"]["title"]).wait_until_present

      @BROWSER.div(:class, 'modal-dialog').button(:class, %w(btn btn-primary)).wait_until_present
      @BROWSER.div(:class, 'modal-dialog').button(:class, %w(btn btn-primary)).click
      @BROWSER.div(:class, 'modal-dialog').button(:class, %w(btn btn-primary)).wait_while_present
    elsif action == 'remove'
      click_button('User settings')
      click_button('Revoke admin permission')

      @BROWSER.div(:class, 'modal-dialog').h1(:text, user_name).wait_until_present
      @BROWSER.div(:class, 'modal-dialog').span(:text, 'Admin').wait_until_present

      @BROWSER.div(:class, 'modal-dialog').p(:text, (ZEUS_STRINGS["user_profile"]["revoke_admin"]["help_text"]).gsub('%{firstName} %{lastName}',user_name)).wait_until_present

      @BROWSER.div(:class, 'modal-dialog').button(:class, %w(btn btn-primary)).wait_until_present
      @BROWSER.div(:class, 'modal-dialog').button(:class, %w(btn btn-primary)).click
      @BROWSER.div(:class, 'modal-dialog').button(:class, %w(btn btn-primary)).wait_while_present
    end
  end
  
end