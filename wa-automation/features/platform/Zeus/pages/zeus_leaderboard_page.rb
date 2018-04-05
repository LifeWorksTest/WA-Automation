# -*- encoding : utf-8 -*-
class ZeusLeaderboardPage

  def initialize (browser)
    @BROWSER = browser

    @LBL_LEADERBOARD = @BROWSER.h2(:text, /Leaderboard/)
    @LBL_RECOGNITION_NAME_DESCRIPTION = ZEUS_STRINGS["leaderboard"]["achievements"]["description"].gsub('amp;','')
    @BTN_SELECT_MONTH = @BROWSER.a(:class, 'filter-dropdown__toggle')
    @BTN_PREFORMANCE = @BROWSER.a(:text, ZEUS_STRINGS["leaderboard"]["performance"]["performance"])
    @BTN_ENGAGEMENT = @BROWSER.a(:text, ZEUS_STRINGS["leaderboard"]["engagement"]["engagement"])
    @BTN_VALUES = @BROWSER.a(:text, ZEUS_STRINGS["leaderboard"]["values"])
    @LEADERBOARD_TRANSLATION_HELPER = Array.new
  end

  def is_visible
    @LBL_LEADERBOARD.wait_until_present
    @BTN_SELECT_MONTH.wait_until_present
    @BTN_PREFORMANCE.wait_until_present
    @BTN_ENGAGEMENT.wait_until_present
    @BTN_VALUES.wait_until_present
    @BTN_SELECT_MONTH.wait_until_present
  end

  def click_button (button)
    case button
    when 'Performance'
      @LEADERBOARD_TRANSLATION_HELPER = ['performance', 'rec_received', 'rec_received_pl']
      @BTN_PREFORMANCE.wait_until_present
      @BTN_PREFORMANCE.click
      @BROWSER.div(:class => %w(col-sm-3 text-center), :text => ZEUS_STRINGS["leaderboard"]["performance"]["recognition"]).wait_until_present
    when 'Engagement'
      @LEADERBOARD_TRANSLATION_HELPER = ['engagement', 'rec_given', 'rec_given_pl']

      @BTN_ENGAGEMENT.wait_until_present
      @BTN_ENGAGEMENT.click
      @BROWSER.div(:class => %w(col-sm-3 text-center), :text => ZEUS_STRINGS["leaderboard"]["engagement"]["recognition"]).wait_until_present
    when 'Values'
      @BTN_VALUES.wait_until_present
      @BTN_VALUES.click
      @BROWSER.div(:class => 'col-sm-7', :text => @LBL_RECOGNITION_NAME_DESCRIPTION).wait_until_present
    when 'select month'
      @BTN_SELECT_MONTH.wait_until_present
      @BTN_SELECT_MONTH.click
      @BROWSER.li(:class => %w(filter-dropdown__item ), :text => ZEUS_STRINGS["timeline"]["date_filter"]["all_time"]).wait_until_present
    else
      fail(msg = 'Error. click_button. The option from the menu is not defined.')
    end
  end
  
  # Go over the table and make sure it is sorted
  def check_table_is_sorted
    is_visible

    i = 0

    @BROWSER.div(:class => %w(employee-field)).wait_until_present

    if @BROWSER.li(:class, %w(ng-isolate-scope active)).text == 'Performance'
      element = %w(employee-list-item velocity-opposites-transition-slideUpIn ng-scope)
    elsif @BROWSER.li(:class, %w(ng-isolate-scope active)).text == 'Engagement'
      element = %w(row employee-list-item velocity-opposites-transition-slideUpIn ng-scope)
    else
      element = %w(row employee-list-item ng-scope)
    end

    while @BROWSER.div(:class => element, :index => i+1).exists?
      @BROWSER.div(:class => element, :index => i+1).scroll.to :bottom
      @BROWSER.div(:class => element, :index => i).div(:class => /col col/, :index => 2).wait_until_present
      
      recognitions_1 = @BROWSER.div(:class => element, :index => i).div(:class => /col col/, :index => 2).text.to_i
      recognitions_2 = @BROWSER.div(:class => element, :index => i+1).div(:class => /col col/, :index => 2).text.to_i
      
      puts "Rank 1 is:#{recognitions_1}   Rank 2 is:#{recognitions_2}"
    
      if recognitions_1 < recognitions_2
        fail(msg = "Error. check_table_is_sorted. Table is not sorted well. rank_1=#{recognitions_1} rank_2=#{recognitions_2}.")
      end
      
      if recognitions_2 == 0
        break
      elsif  (i + 1) % 5 == 0
        @BROWSER.scroll.to :bottom
      end

      i += 1
    end
  end

# Click on every user and check that the correct profile was opend and that 
  # the total recognitions is match on both screen.
  # If the the user profile was opened from Leaderboard Performance the compriantion will be against
  # User profile Performance. The same for Engagment.
  def check_link_to_users
    @BROWSER.div(:class, /employee-list-item velocity-opposites-transition-slideUpIn ng-scope/).wait_until_present
    
    i = 0
    while ((@BROWSER.div(:class => /employee-list-item velocity-opposites-transition-slideUpIn ng-scope/, :index => i).exists?) && (@BROWSER.div(:class => /employee-list-item velocity-opposites-transition-slideUpIn ng-scope/, :index => i+1).text != ""))
      puts "i is #{i}"
      user_name = @BROWSER.div(:class => %w(employee-list-item velocity-opposites-transition-slideUpIn ng-scope), :index => i).div(:class, 'name').text
      total_recognitions = @BROWSER.div(:class => %w(employee-list-item velocity-opposites-transition-slideUpIn ng-scope), :index => i).div(:class, /position text-center/).text
      puts "User name:#{user_name}  Recognitions:#{total_recognitions}"
      @BROWSER.div(:class => %w(employee-list-item velocity-opposites-transition-slideUpIn ng-scope), :index => i).div(:class, 'name').a.click
      @BROWSER.h2(:text, 'Profile').wait_until_present
      @BROWSER.div(:class, %w(description text-center)).h2(:class => %w(name ng-binding), :text => "#{user_name}").wait_until_present
      
      if total_recognitions.to_i == 0
        string_matchers = {'%{firstName} %{lastName}' => user_name, '%{month}' => Date.today.strftime("%B")}
        no_recognition_ever = ZEUS_STRINGS["user_profile"]["#{@LEADERBOARD_TRANSLATION_HELPER[0]}"]["label_1"].gsub(/%{firstName} %{lastName}|%{month}/) { |match| string_matchers[match] } 
        no_recognition_this_month = ZEUS_STRINGS["user_profile"]["#{@LEADERBOARD_TRANSLATION_HELPER[0]}"]["label_2"].gsub(/%{firstName} %{lastName}|%{month}/) { |match| string_matchers[match] }
        
        @BROWSER.div(:class, /container ng-scope/).span(:text, /(#{no_recognition_ever}|#{no_recognition_this_month})/).wait_until_present
      elsif total_recognitions.to_i == 1
        @BROWSER.div(:class => %w(toolbar ng-scope), :text => /#{total_recognitions} #{(ZEUS_STRINGS["user_profile"]["#{@LEADERBOARD_TRANSLATION_HELPER[0]}"]["#{@LEADERBOARD_TRANSLATION_HELPER[1]}"])[9..-10]}/).wait_until_present
      else
        # Added the below line das the Zeus string has an extra white space character that was causing the test to to fail. This needs to be converted to 1 space for the entire string
        string_to_match = "#{total_recognitions} #{(ZEUS_STRINGS["user_profile"]["#{@LEADERBOARD_TRANSLATION_HELPER[0]}"]["#{@LEADERBOARD_TRANSLATION_HELPER[2]}"])[9..-10]}".gsub(/\s+/,' ')
        puts "string to match = #{string_to_match}"
        @BROWSER.div(:class => %w(toolbar ng-scope), :text => /#{string_to_match}/).wait_until_present
      end

      @BROWSER.back
      is_visible

      if (i + 1) % 7 == 0
        @BROWSER.element.send_keys [:space] 
      end

      i = i + 1
    end
  end

  # Sum all the recognition in the current table
  def sum_recognition 
    total_of_recognitions = 0
    i = 0
    
    while @BROWSER.div(:class => /row employee-list-item ng-scope/, :index => i).exists?
      previous_total = total_of_recognitions
      if @BROWSER.div(:class => 'col-sm-7', :text => @LBL_RECOGNITION_NAME_DESCRIPTION).exists?
        total_of_recognitions +=  @BROWSER.div(:class => %w(col col-sm-2 text-center), :index => i).text.to_i
      else
        total_of_recognitions +=  @BROWSER.div(:class => %w(employee-list-item velocity-opposites-transition-slideUpIn ng-scope), :index => i).div(:class, /position text-center/).text.to_i
      end
      
      if total_of_recognitions == previous_total
        break
      elsif
        (i + 1) % 7 == 0
        @BROWSER.scroll.to :bottom
      end

      puts "running total = #{total_of_recognitions}"

      i += 1
    end

    puts "Total number of recognitions that was count is:#{total_of_recognitions}"
    return total_of_recognitions
  end

  # Compere total recognition with 'Network Summery'
  # @total_of_recognition - total recogniton to match with the total in 'Network Summery'
  def compere_total_recognition_with_network_summery (total_of_recognition)
     @BROWSER.div(:class, 'col-sm-3').div(:class, %w(panel panel-primary)).div(:class, %w(row leaderboard-kpi-list-item)).div(:class, %w(col-sm-5 col-xs-6 leaderboard-kpi-list-item-count text-semibold ng-binding)).wait_until_present
     total_recognition_network_summery = @BROWSER.div(:class, 'col-sm-3').div(:class, %w(panel panel-primary)).div(:class, %w(row leaderboard-kpi-list-item)).div(:class, %w(col-sm-5 col-xs-6 leaderboard-kpi-list-item-count text-semibold ng-binding)).text.delete(',').to_i   
   
    if total_recognition_network_summery != total_of_recognition  
      fail(msg = "Error. check_table_is_sorted. Total amount of recognitions is: #{total_of_recognition} and it does not match upto with the total number of recognitions in the network summary -  #{total_recognition_network_summery}.")
    end

    puts "Total sum from Network Summary is:#{total_recognition_network_summery} and it is equal to the amount of recognitions that was counted:#{total_of_recognition}"
  end

  def set_time_filter_to (filter)
    puts "filter month is #{filter}"
    click_button('select month')
    @BROWSER.li(:class, /filter-dropdown__item/).a(:text, "#{filter}").click
    sleep(3)
  end

  def set_network_summery
    $NETWORK_SUMMERY = Array.new(4)
    $NETWORK_SUMMERY[0] = @BROWSER.span(:class => %w(badge pull-right ng-binding), :index => 0).text
    $NETWORK_SUMMERY[1] = @BROWSER.span(:class => %w(badge pull-right ng-binding), :index => 1).text
    $NETWORK_SUMMERY[2] = @BROWSER.span(:class => %w(badge pull-right ng-binding), :index => 2).text
    $NETWORK_SUMMERY[3] = @BROWSER.span(:class => %w(badge pull-right ng-binding), :index => 3).text
  end

  # Go over all months in list for this year and validate recognitions per day calculation  
  def validate_recognitions_per_day_by_month 
    click_button('select month')
    num_of_elements = @BROWSER.ul(:class, 'filter-dropdown__menu').lis.count - 1

    for i in 1..num_of_elements 
      @BROWSER.ul(:class, 'filter-dropdown__menu').li(:index => i).wait_until_present
      month_or_year_temp = @BROWSER.ul(:class, 'filter-dropdown__menu').li(:index => i).text
      month_or_year = /\d\d\d\d/.match (month_or_year_temp)
      company_created_day_of_month = (Time.at($COMPANY_CREATION_DATE)).strftime("%e")
      today_of_month = (Time.now).strftime("%e")

      # If month_or_year it is not year 
      if month_or_year != nil
        current_year = @BROWSER.ul(:class, 'filter-dropdown__menu').li(:index => i).text
        puts "Current Year #{current_year}"
      else
        month = month_or_year_temp
        puts "month:#{month}"

        if num_of_elements == 2
          # Calculates the number of days between company creation day and today.Incremeting by 1 since our logic included current day while calculating the avegrage
          total_days_of_month = (today_of_month.to_i - company_created_day_of_month.to_i) + 1
        elsif i == 2
          total_days_of_month = Date.today.day.to_f
        elsif i == num_of_elements
          total_days_of_month = (Date.new(current_year.to_i, Date::MONTHNAMES.index("#{month}"), -1).day.to_f - company_created_day_of_month.to_i) + 1 
        else
          total_days_of_month = Date.new(current_year.to_i, Date::MONTHNAMES.index("#{month}"), -1).day.to_f
        end

        @BROWSER.ul(:class, 'filter-dropdown__menu').li(:index => i).fire_event('click')
        @BROWSER.a(:class => 'filter-dropdown__toggle', :text => month).wait_until_present
        sleep(3)
        @BROWSER.div(:class, 'col-sm-3').div(:class, %w(panel panel-primary)).div(:class, %w(row leaderboard-kpi-list-item)).div(:class, %w(col-sm-5 col-xs-6 leaderboard-kpi-list-item-count text-semibold ng-binding)).wait_until_present
        total_recognition_network_summery = @BROWSER.div(:class, 'col-sm-3').div(:class, %w(panel panel-primary)).div(:class, %w(row leaderboard-kpi-list-item)).div(:class, %w(col-sm-5 col-xs-6 leaderboard-kpi-list-item-count text-semibold ng-binding)).text.delete(',').to_f
        puts "total_recognition_network_summery:#{total_recognition_network_summery}"
        @BROWSER.div(:class, 'col-sm-3').div(:class, %w(panel panel-primary)).div(:class => %w(row leaderboard-kpi-list-item), :index => 1).div(:class, %w(col-sm-5 col-xs-6 leaderboard-kpi-list-item-count text-semibold ng-binding)).wait_until_present
        recognitions_per_day = @BROWSER.div(:class, 'col-sm-3').div(:class, %w(panel panel-primary)).div(:class => %w(row leaderboard-kpi-list-item), :index => 1).div(:class, %w(col-sm-5 col-xs-6 leaderboard-kpi-list-item-count text-semibold ng-binding)).text.delete(',').to_f
        calculated_recognitions_per_day = sprintf('%.3f', total_recognition_network_summery/total_days_of_month)
      
        if calculated_recognitions_per_day.to_f != recognitions_per_day.to_f
          fail(msg = "Error.validate_recognitions_per_day_by_month. In #{month} #{current_year} there are #{total_days_of_month} days and the total amount of recognition for this month is:#{total_recognition_network_summery} therefor expected to get #{calculated_recognitions_per_day} avg of recognitions per day but the presented value is #{recognitions_per_day}")
        end

        click_button('select month')
      end
    end 
  end

  # Validate empty state labels are present
  def validate_empty_state
    @file_service = FileService.new
    empty_rec_received_text = "0\n#{ZEUS_STRINGS["leaderboard"]["kpi"]["rec_received"]}".gsub('<br>',"\n")
    empty_rec_per_day_text = "0\n#{ZEUS_STRINGS["leaderboard"]["kpi"]["rec_per_day"]}".gsub('<br>',"\n")
    company_identifier = @file_service.get_from_file('admin_account_counter:')[0..-2]
    
    @BROWSER.span(:text, /#{ZEUS_STRINGS["leaderboard"]["performance"]["invite"].gsub('%{vmCompanyName}', "#{USER_PROFILE[:new_admin_user][:company_name]} #{company_identifier}")}/).wait_until_present
    @BROWSER.div(:class => %w(row leaderboard-kpi-list-item), :text => /#{empty_rec_received_text}/).wait_until_present
    @BROWSER.div(:class => %w(row leaderboard-kpi-list-item), :text => /#{empty_rec_per_day_text}/).wait_until_present
  end

end
