# -*- encoding : utf-8 -*-
class HermesLeaderboardPage

  def initialize (browser)
    @BROWSER = browser

    @BOX_MY_POSITION = @BROWSER.div(:id, 'automation-my-position')
  
  end

  def is_visible
    @BROWSER.h1(:text, HERMES_STRINGS["leaderboard"]["leaderboard"]).wait_until_present

    if !@BROWSER.h2(:text, /#{ACCOUNT[:"#{$account_index}"][:valid_account][:company_name]}/).present?
      @BROWSER.h2(:text, /#{$COMPANY_NICKNAME}/).wait_until_present
    end
     
    @BROWSER.div(:text, "#{HERMES_STRINGS["leaderboard"]["select_period"]}:").wait_until_present
  end

  # Validate grouoing name
  # @param grouping_enabled_disabled
  def grouping_is_valid (grouping_enabled_disabled)
    is_visible
    
    if grouping_enabled_disabled == 'enabled'
      group_name = @file_service.get_from_file('latest_group_name:')[0..-2]
      @BROWSER.h2(:text, /#{group_name}/).wait_until_present
      @BROWSER.h2.parent.parent.div.text

      ((x.gsub(group_name, '')).match /\d+/)[0].to_i

      if number_of_members_in_group != 1
        fail(msg = "Error. grouping_is_valid. The expected number of gorup is 1 however the number present was #{}")
      end
    else
      @BROWSER.h2(:text, /#{ACCOUNT[:account_1][:valid_account][:group_name_base]}/).wait_until_present
    end
  end

 # Validating current users position by scrolling through the colleauges directory
  def check_my_position
    my_result = @BOX_MY_POSITION.div(:index, 4).text
    my_pos = @BOX_MY_POSITION.div(:index, 0).text.to_i

    i = 0
    
    while ! @BROWSER.div(:id => /automation-user/, :index => my_pos - 1).present?
      @BROWSER.scroll.to :bottom
      puts "i = #{i}"
      sleep(0.5)

      i += 1 

      if i == 20
        fail(msg = "Error. check_my_position. i = #{i} -  Could not find my position in the leaderboard list")
      end
    end

    result_to_compare = @BROWSER.div(:id => /automation-user/, :index => my_pos - 1).div(:index, 4).text
    
    puts "my_result: #{my_result}"
    puts "result to compare with: #{result_to_compare}"

    if ! my_result.eql? result_to_compare
      fail(msg = "Error. chack_my_position. User is not in the right place in the leaderboard table. Result to compare = #{result_to_compare}.... My Result = #{my_result}")
    end 
  end

  def select_period (period)
    @PERIOD_TEXT = "#{HERMES_STRINGS["leaderboard"]["select_period"]}:"

    @BROWSER.div(:class , 'preloader').wait_while_present
    @BROWSER.div(:text, "#{@PERIOD_TEXT}").parent.wait_until_present
    @BROWSER.div(:text, "#{@PERIOD_TEXT}").parent.scroll.to :bottom
    @BROWSER.div(:text, "#{@PERIOD_TEXT}").parent.click
    @BROWSER.div(:text, "#{@PERIOD_TEXT}").parent.div(:text, LEADERBOARD_FILTER_OPTIONS[:"#{period}"]).wait_until_present
    sleep(1)
    @BROWSER.div(:text, "#{@PERIOD_TEXT}").parent.div(:text, LEADERBOARD_FILTER_OPTIONS[:"#{period}"]).fire_event('click')
    Watir::Wait.until { @BROWSER.div(:text, "#{@PERIOD_TEXT}").parent.div(:index, 1).text == period }
    is_visible
  end

  # Check if the current table is sorted
  def check_table_is_sorted
    i = 1
    while !@BROWSER.div(:id => /automation/, :index => i + 1 )
      if @BROWSER.div(:id => /automation/, :index => i).div(:index, 0).text.to_i > @BROWSER.div(:id => /automation/, :index => i+1).div(:index, 0).text.to_i
        fail(msg = "Error. check_table_is_sorted. User position in index i=#{i} is bigger then the next user total recognition")
      end

      if @BROWSER.div(:id => /automation/, :index => i).div(:index, 4).text.to_i < @BROWSER.div(:id => /automation/, :index => i+1).div(:index, 4).text.to_i
        fail(msg = "Error. check_table_is_sorted. User total recognition in index i=#{i} is smaller then the next user total recognition")
      end

    i += 1
    end
  end

  # See all users recognitions
  def see_users_recognitions (users_to_validate)
    i = 1 
    while @BROWSER.div(:id => /automation/, :index => i ).exists?
      @BROWSER.div(:id => /automation/, :index => i).div(:index, 4).wait_until_present
      total_recognitions = @BROWSER.div(:id => /automation/, :index => i).div(:index, 4).text.to_i
      puts "user total amount: #{total_recognitions}"
      @BROWSER.div(:id => /automation/, :index => i).div(:index, 2).a.click
      @BROWSER.span(:text, HERMES_STRINGS["profile"]["achievements"]["recognitions"]).parent.span(:text => /#{total_recognitions}/).wait_until_present
      sleep(1)
      @BROWSER.back
      select_period('All Time')
      i == users_to_validate ? break : nil
      i += 1
    end
  end
  
end
