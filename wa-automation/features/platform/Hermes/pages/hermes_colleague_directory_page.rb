# -*- encoding : utf-8 -*-
class HermesColleagueDirectoryPage
  def initialize (browser)
    @file_service = FileService.new
    @BROWSER = browser
  end

  def is_visible
    @BROWSER.label(:text, HERMES_STRINGS["directory"]["subtitle"]).wait_until_present
    @BROWSER.button(:text => HERMES_STRINGS["components"]["user_action_comp"]["more"]).wait_until_present
  end

  # Go over the list of colleagues and check that it is sorted
  def check_list_is_sorted
    @BROWSER.button(:text => HERMES_STRINGS["components"]["user_action_comp"]["more"]).wait_until_present
    i = 0
    
    while @BROWSER.button(:text => HERMES_STRINGS["components"]["user_action_comp"]["more"], :index => i + 1).exists?
      puts "i = #{i}"
      user_1 = @BROWSER.button(:text => HERMES_STRINGS["components"]["user_action_comp"]["more"], :index => i).parent.parent.parent.span.text.downcase
      user_2 = @BROWSER.button(:text => HERMES_STRINGS["components"]["user_action_comp"]["more"], :index => i + 1).parent.parent.parent.span.text.downcase
      puts "#{user_1} #{user_2}"
      
      if user_1 > user_2 
        fail(msg = "Error. check_list_is_sorted. user_1 = #{user_1} user_2 = #{user_2}")
      end

      i += 1

      if i % 5 == 0
        @BROWSER.send_keys :space
        sleep(0.5)
      end
    end
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

  # Tap on the search bar in the Colleague directory page for finding the user and verify the result
  # @param user_name
  # @param state - if user should exists in the list of search results or not
  def search_user (user_name, state)
    @BROWSER.input(:placeholder, HERMES_STRINGS["directory"]["input_search"]).exists?
    @BROWSER.input(:placeholder, HERMES_STRINGS["directory"]["input_search"]).fire_event :focus
    @BROWSER.input(:placeholder, HERMES_STRINGS["directory"]["input_search"]).send_keys user_name

    if state == 'existing'

      @BROWSER.div(:class => %w(flag background-transition)).wait_until_present
      search_result_exists = false
      i = 0

      while @BROWSER.div(:class => %w(flag background-transition), :index => i).present?
        search_result = @BROWSER.div(:class => %w(flag background-transition), :index => i).div(:class, 'flag__body').div.text
        puts "i : #{i}. The current search result is : #{search_result}" 

        if search_result == user_name
          search_result_exists = true
          break
        else
          puts "i : #{i}. Trying next search result in the list. The search result found was '#{search_result}'"
          i += 1
        end
      end

      if !search_result_exists
         fail(msg = "Error. search_user. #{user_name} does not exist in list of search results")
      end  

    elsif state == 'not existing'
      @BROWSER.div(:text, HERMES_STRINGS["directory"]["no_results"]).wait_until_present
    end

    @BROWSER.refresh
  end

  # Validate total number of Colleagues
  def validate_total_number_of_colleagues 
    total_colleague =  (/\d+/.match (@BROWSER.h4.text))[0].to_i
    i = 0

    while @BROWSER.button(:text => HERMES_STRINGS["components"]["user_action_comp"]["more"], :index => i).exists?
      i += 1
      
      if i % 5 == 0
        @BROWSER.scroll.to :bottom
        sleep(0.5)
      end
    end

    if total_colleague != i + 1
      fail(msg = "Error. validate_total_number_of_colleague. Total number of colleague is not correct, number_of_colleague_in_page:#{i + 1} total_colleague:#{total_colleague}")
    end

    puts "The total amount of colleagues not including the current user is #{total_colleague} and #{i-1} users was found while iterating the list"
  end

  def validate_empty_state
    @BROWSER.a(:text, HERMES_STRINGS["directory"]["new_colleagues"]).wait_until_present
    @BROWSER.div(:text, /#{HERMES_STRINGS["directory"]["empty_1"]}/).wait_until_present
    @BROWSER.div(:text, /#{HERMES_STRINGS["directory"]["empty_2"]}/).wait_until_present
  end
  
end 
