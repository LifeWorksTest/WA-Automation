# -*- encoding : utf-8 -*-
class ZeusDashboardPage

  def initialize (browser)
    @file_service = FileService.new
    @BROWSER = browser
    @BTN_VIEW_ALL_TOP_RECOGNITION = @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["top_rec"]["title"]}/).a(:text, /#{ZEUS_STRINGS["widget"]["recognition"]["btn"]}/i)
    @BTN_VIEW_ALL_LATEST_RECOGNITIONS = @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["recognition"]["title"]}/).a(:text => /#{ZEUS_STRINGS["widget"]["recognition"]["btn"]}/i)
    @BTN_VIEW_ALL_POPULAR_VALUES = @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["values"]["title"]}/).a(:text => /#{ZEUS_STRINGS["widget"]["recognition"]["btn"]}/i)
    @BTN_VIEW_ALL_USER_MANAGEMENT = @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["management"]["title"]}/).a(:text => /#{ZEUS_STRINGS["widget"]["recognition"]["btn"]}/i)
    @BTN_POST = @BROWSER.a(:class => %w(btn btn-primary), :text => /#{ZEUS_STRINGS["new_post"]["post_btn"]}/)
    @BTN_TOP_PERFORMERS = @BROWSER.span(:text, ZEUS_STRINGS["widget"]["dashboard"]["top_perf"])
    @BTN_TOP_RECOGNISERS = @BROWSER.span(:text, ZEUS_STRINGS["widget"]["dashboard"]["top_reco"])
    @BTN_ADD_NEW_COLLEAGUES = @BROWSER.a(:text, ZEUS_STRINGS["widget"]["dashboard"]["btn"])
    
    @LBL_POPULAR_BRANDS_SHOP_ONLINE = ZEUS_STRINGS["widget"]["brands"]["title"].sub("&middot;","·")
    @LBL_POPULAR_CATEGORIES_SHOP_ONLINE = ZEUS_STRINGS["widget"]["categories"]["title"].sub("&middot;","·")
                                   
    @TXF_ENTER_EMAIL_ADDRESS = @BROWSER.textarea(:class, 'form-control')

    @IMG_SPINNER = @BROWSER.div(:class, %w(spinner ng-scope))
  end

  def is_visible
    @BROWSER.h2(:text, /#{ZEUS_STRINGS["post_login"]["dashboard"]}/).wait_until_present
    @BTN_ADD_NEW_COLLEAGUES.wait_until_present

    # Coleeague Management
    @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["management"]["title"]}/).wait_until_present
    @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["management"]["title"]}/).p(:text, /#{ZEUS_STRINGS["widget"]["management"]["label_1"]}/).present?
    
    # Perks · Popular categories in Shop Online 
    @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["categories"]["title"]}/).wait_until_present
    
    # Perks · Popular brands in Shop Online
    # TODO - Issue accessing global variables? dashboard test cases are failing when run as a group but passing when executed individually
    # @BROWSER.div(:class => 'panel panel-benefits js-velocity-hook ng-scope', :index => 1).span(:text, @LBL_POPULAR_BRANDS_SHOP_ONLINE).wait_until_present
    @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["brands"]["title"]}/).wait_until_present

    # Perks · Total Spending
    @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["spending"]["title"]}/).wait_until_present
    
    if @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["brands"]["title"]}/).th(:text, /#{ZEUS_STRINGS["widget"]["brands"]["tlabel_1"]}/).present?
      @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["spending"]["title"]}/).canvas.wait_until_present
    end
    
    # Engagement
    @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["engagement"]["title"]}/).wait_until_present
    @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["engagement"]["title"]}/).p(:text, /#{ZEUS_STRINGS["widget"]["engagement"]["label_1"]}/).wait_until_present
    @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["engagement"]["title"]}/).p(:text, /#{ZEUS_STRINGS["widget"]["engagement"]["label_2"]}/).wait_until_present
    @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["engagement"]["title"]}/).p(:text, /#{ZEUS_STRINGS["widget"]["engagement"]["label_3"]}/).wait_until_present
    @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["engagement"]["title"]}/).p(:text, /#{ZEUS_STRINGS["widget"]["engagement"]["label_4"]}/).wait_until_present
  end

  def click_button (button)
    case button 
    when 'Add New Colleagues'
      @BTN_ADD_NEW_COLLEAGUES.wait_until_present
      @BTN_ADD_NEW_COLLEAGUES.click
      @BTN_ADD_NEW_COLLEAGUES.wait_while_present
    when 'VIEW ALL Latest Recognitions'
      @BTN_VIEW_ALL_LATEST_RECOGNITIONS.wait_until_present
      @BTN_VIEW_ALL_LATEST_RECOGNITIONS.click
      @BROWSER.div(:text, /#{ZEUS_STRINGS["post_login"]["timeline"]}/).wait_until_present
    when 'VIEW ALL Top Recognition'
      @BTN_VIEW_ALL_TOP_RECOGNITION.wait_until_present
      @BTN_VIEW_ALL_TOP_RECOGNITION.click
      @BROWSER.div(:text, /#{ZEUS_STRINGS["post_login"]["leaderboard"]}/).wait_until_present
    when 'VIEW ALL Popular Values'
      @BTN_VIEW_ALL_POPULAR_VALUES.wait_until_present
      @BTN_VIEW_ALL_POPULAR_VALUES.click
      @BROWSER.div(:text, /#{ZEUS_STRINGS["post_login"]["leaderboard"]}/).wait_until_present
    when 'VIEW ALL User Management'
      @BTN_VIEW_ALL_USER_MANAGEMENT.wait_until_present
      @BTN_VIEW_ALL_USER_MANAGEMENT.click
      @BROWSER.div(:text, /#{ZEUS_STRINGS["post_login"]["colleague_directory"]}/).wait_until_present
    when 'Top Recognisers'
      @BTN_TOP_RECOGNISERS.wait_until_present
      @BTN_TOP_RECOGNISERS.click
      @BROWSER.div(:class, %w(top-recognisers-list ng-scope)).wait_until_present
    when 'Post'
      @BTN_POST.wait_until_present
      @BTN_POST.click
      @BTN_POST.wait_while_present
    when 'Back'
      @BROWSER.div(:class, %w(btn btn-inverse)).wait_until_present
      @BROWSER.div(:class, %w(btn btn-inverse)).click
      @BROWSER.div(:class, %w(btn btn-inverse)).wait_while_present
    when 'All Time'
        @BROWSER.a(:class, 'filter-dropdown__toggle').wait_until_present
        @BROWSER.a(:class, 'filter-dropdown__toggle').click
        @BROWSER.li(:class => 'filter-dropdown__item ',:text => 'All Time').wait_until_present
        @BROWSER.li(:class => 'filter-dropdown__item ',:text => 'All Time').click
        sleep(1)
    else
      fail(msg = "Error. click_button. The option #{button} is not defined in menu.")
    end
  end

  # Check that the data in the box valid
  # @param box_name - which box to validate
  def validate_date_in (box_name)
    case box_name
    when 'Latest Recognitions'
      validate_latest_recognitions
    when 'Top Performers'
      validate_top_recognition(false)
    when 'Top Recognisers'
      @BTN_TOP_RECOGNISERS.wait_until_present
      @BTN_TOP_RECOGNISERS.click
      validate_top_recognition(true)
    when 'Popular Values'
      validate_popular_values
    when 'User Management'
      validate_user_management
    end
  end

  # Click on all the 'VIEW ALL' button and check that the right pgae is open
  def view_all_button_functionality
    @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["management"]["title"]}/).wait_until_present
    click_button('VIEW ALL Latest Recognitions')
    @BROWSER.div(:class => 'flexible-column-module__flexible-column___2TfjO', :text => ZEUS_STRINGS["post_login"]["dashboard"]).wait_until_present
    @BROWSER.div(:class => 'flexible-column-module__flexible-column___2TfjO', :text => ZEUS_STRINGS["post_login"]["dashboard"]).click
    is_visible
    @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["management"]["title"]}/).wait_until_present
    click_button('VIEW ALL Top Recognition')
    @BROWSER.div(:class => 'flexible-column-module__flexible-column___2TfjO', :text => ZEUS_STRINGS["post_login"]["dashboard"]).wait_until_present
    @BROWSER.div(:class => 'flexible-column-module__flexible-column___2TfjO', :text => ZEUS_STRINGS["post_login"]["dashboard"]).click
    @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["management"]["title"]}/).wait_until_present
    is_visible
    click_button('VIEW ALL Popular Values')
    @BROWSER.div(:class => 'flexible-column-module__flexible-column___2TfjO', :text => ZEUS_STRINGS["post_login"]["dashboard"]).wait_until_present
    @BROWSER.div(:class => 'flexible-column-module__flexible-column___2TfjO', :text => ZEUS_STRINGS["post_login"]["dashboard"]).click
    @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["management"]["title"]}/).wait_until_present
    is_visible
    click_button('VIEW ALL User Management')
    @BROWSER.div(:class => 'flexible-column-module__flexible-column___2TfjO', :text => ZEUS_STRINGS["post_login"]["dashboard"]).wait_until_present
    @BROWSER.div(:class => 'flexible-column-module__flexible-column___2TfjO', :text => ZEUS_STRINGS["post_login"]["dashboard"]).click
    is_visible
    @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["management"]["title"]}/).wait_until_present
  end

  # Validate data in Latest Recognitions box
  # @param text_dashboard - recognition text from as it shown in dashboard
  # @param recognition_badge
  # @param reciver_dashboard - reciver name as it shown in dashboard
  def validate_latest_recognitions(text_dashboard = nil, recognition_badge = nil, reciver_dashboard=nil)
    if text_dashboard != nil
      @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["recognition"]["title"]}/).a(:text, /#{reciver_dashboard}/).wait_until_present
      @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["recognition"]["title"]}/).span(:text, /#{BADGES[:"#{$badge_name}"]}/).wait_until_present
      @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["recognition"]["title"]}/).span(:text, /#{text_dashboard}/).wait_until_present
    else
      recognition_badge =  BADGES["{@BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["recognition"]["title"]}/).span(:index, 0).text}"]
      text_dashboard = @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["recognition"]["title"]}/).span(:index, 1).text
      reciver_dashboard = @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["recognition"]["title"]}/).a(:index, 2).text
    end

    sender_dashboard = @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["recognition"]["title"]}/).strong.text
    puts "\nDashboard\nReciver name:#{reciver_dashboard}\nText:#{text_dashboard}\nSender name:#{sender_dashboard}"
    click_button('VIEW ALL Latest Recognitions')
    @IMG_SPINNER.wait_while_present
    @BROWSER.a(:class, %w(post-module__tile__username___3Pakb post-module__tile__username--dark___kvcmf)).wait_until_present
    puts "User that was found: #{@BROWSER.a(:class, %w(post-module__tile__username___3Pakb post-module__tile__username--dark___kvcmf)).text}"

    if !@BROWSER.a(:class, %w(post-module__tile__username___3Pakb post-module__tile__username--dark___kvcmf)).text.include? "#{reciver_dashboard}"
      fail(msg = "User name (#{reciver_dashboard}) was not found in the first post")
    end

    puts "text_dashboard #{text_dashboard}"
    puts "sender_dashboard #{sender_dashboard}"
    @BROWSER.div(:class => 'flag-module__flag__body___2R3yD', :index => 1).div(:text, /#{text_dashboard.gsub(':)', ':\)')}/).wait_until_present
    @BROWSER.div(:class => 'post-module__tile__activity___3pZx6',:text => /#{sender_dashboard}/).wait_until_present
    
    # Check image upload is present
    if @BROWSER.div(:class => 'tile feed-post-types-recognition panel panel-post ng-scope').div(:class, 'post-module__tile__photo--holder___2lPaq').present?
      @BROWSER.div(:class => 'flag-module__flag__body___2R3yD', :index => 1).div(:text, /Good work!!/).parent.parent.parent.img(:srcset, /image\/upload/).wait_until_present
    end
  end

  # Validate data in Top Recognitions box (top performers/top recognisers)
  # @param is_recognisers - true or false
  def validate_top_recognition (is_recognisers)
    puts "#{is_recognisers}" 

    if is_recognisers
      @BROWSER.element(css: "div[style^='text-align: center; background-color: rgb(255, 255, 255); font-weight: 600; font-size: 14px; height: 40px; cursor: pointer; padding: 13px 0px;']").text.include? ZEUS_STRINGS["widget"]["dashboard"]["top_reco"]
    else
      @BROWSER.element(css: "div[style^='text-align: center; background-color: rgb(255, 255, 255); font-weight: 600; font-size: 14px; height: 40px; cursor: pointer; padding: 13px 0px;']").text.include? ZEUS_STRINGS["widget"]["dashboard"]["top_perf"]
    end

    dashboard_first_place = @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["top_rec"]["title"]}/).img(:index, 0).parent.parent.parent.text[1..-1]
    dashboard_second_place = @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["top_rec"]["title"]}/).img(:index, 1).parent.parent.parent.text[1..-1]
    dashboard_third_place =  @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["top_rec"]["title"]}/).img(:index, 2).parent.parent.parent.text[1..-1]


    puts("\n**Dashboard**\nFirst place:#{dashboard_first_place}\nSecond place:#{dashboard_second_place}\nThird place:#{dashboard_third_place}\n")
    
    click_button('VIEW ALL Top Recognition')

    if is_recognisers
      @BROWSER.li(:class => 'ng-isolate-scope', :index => 1).a(:text, ZEUS_STRINGS["leaderboard"]["engagement"]["engagement"]).wait_until_present
      @BROWSER.li(:class => 'ng-isolate-scope', :index => 1).a(:text, ZEUS_STRINGS["leaderboard"]["engagement"]["engagement"]).click
      @BROWSER.div(:class, %w(spinner ng-animate ng-hide-animate ng-hide-add ng-hide ng-hide-add-active)).wait_while_present
      @BROWSER.div(:text, 'Recognition given').wait_until_present
    end

    # The line below checks that a badge image is displayed in the 1st top 3 recognition placeholder for the user that is in 1st position in the leaderboard (filtered by MONTH)
    Watir::Wait.until { @BROWSER.div(:class => 'employee-list-item velocity-opposites-transition-slideUpIn ng-scope', :index => 0).div(:class => 'col col-xs-4', :index => 0).source(:srcset => /test\/badge/).exists? }
    @BROWSER.a(:class, 'filter-dropdown__toggle').click
    @BROWSER.ul(:class, 'filter-dropdown__menu').li(:class => 'filter-dropdown__item', :index => 0).wait_until_present
    @BROWSER.ul(:class, 'filter-dropdown__menu').li(:class => 'filter-dropdown__item', :index => 0).click
    @BROWSER.div(:class => %w(col-sm-7 col-xs-6 leaderboard-kpi-list-item-label ng-binding),:text => ZEUS_STRINGS["leaderboard"]["kpi"]["reco"]).wait_until_present
    @BROWSER.div(:class, %w(spinner ng-animate ng-hide-animate ng-hide-add ng-hide ng-hide-add-active)).wait_while_present
    @BROWSER.div(:class => %w(employee-list-item velocity-opposites-transition-slideUpIn ng-scope)).wait_until_present
    @BROWSER.div(:class, %w(spinner ng-animate ng-hide-animate ng-hide-add ng-hide ng-hide-add-active)).wait_while_present
    
    # The line below checks that a badge image is displayed in the 1st top 3 recognition placeholder for the user that is in 1st position in the leaderboard (filtered by ALL TIME)
    Watir::Wait.until(30) { @BROWSER.div(:class => %w(employee-list-item velocity-opposites-transition-slideUpIn ng-scope), :index => 0).div(:class => %w(col col-xs-4), :index => 0).source(:srcset => /test\/badge/).exists? }
    leaderboard_first_place = @BROWSER.div(:class => %w(employee-list-item velocity-opposites-transition-slideUpIn ng-scope), :index => 0).text
    leaderboard_second_place = @BROWSER.div(:class => %w(employee-list-item velocity-opposites-transition-slideUpIn ng-scope), :index => 1).text
    leaderboard_third_place = @BROWSER.div(:class => %w(employee-list-item velocity-opposites-transition-slideUpIn ng-scope), :index => 2).text
    puts("\n**Leaderboard**\nFirst place:#{leaderboard_first_place}\nSecond place:#{leaderboard_second_place}\nThird place:#{leaderboard_third_place}\n")

    if dashboard_first_place != leaderboard_first_place
      fail(msg = "Error. check_top_recognition. First place are not match dashboard_first_place:#{dashboard_first_place} leaderboard_first_place:#{leaderboard_first_place}.")
    elsif dashboard_second_place != leaderboard_second_place
      fail(msg = "Error. check_top_recognition. Second place are not match dashboard_second_place:#{dashboard_second_place} leaderboard_second_place:#{leaderboard_second_place}.")
    elsif dashboard_third_place != leaderboard_third_place
      fail(msg = "Error. check_top_recognition. Third place are not match dashboard_third_place:#{dashboard_third_place} leaderboard_third_place:#{leaderboard_third_place}.")
    end
  end


  # Validate that in case the company is new with no recognitions all field related to recognitions are 0
  # @Return true if the company don't have 0 recognitions
  def validate_company_have_zero_recogntions
    if @BROWSER.div(:class => %w(panel panel-primary panel-popular-values js-velocity-hook ng-scope)).p(:class => 'text-center',:text => 'Most popular values will appear here!').exist? &&
      @BROWSER.div(:class => %w(empty-state text-center ng-scope),:text => ZEUS_STRINGS["widget"]["recognition"]["label_1"]).exist? &&
      @BROWSER.div(:class, %w(panel panel-warning panel-user-management js-velocity-hook ng-scope)).div(:class => 'row', :text => /#{ZEUS_STRINGS["widget"]["management"]["label_1"]}\n1/).exists? &&
      @BROWSER.div(:class, %w(panel panel-warning panel-user-management js-velocity-hook ng-scope)).div(:class => 'row', :text => /#{ZEUS_STRINGS["widget"]["management"]["label_2"]}\n0/).exists?
        return true
      else
        #fail(msg = "validate_company_have_zero_recogntions")
        return false
      end
    end


  # Validate data in Popular Values box
  def validate_popular_values 
    dashboard_order = ''
    leaderboard_order = ''

    if ! validate_company_have_zero_recogntions
      # Create string of the badges name
      amount_of_badges = @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["values"]["title"]}/).imgs.count
      for i in 0..amount_of_badges - 1
        dashboard_order += "\n" + @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["values"]["title"]}/).img(:index, i).parent.div.text
      end

      puts "**Leaderbaord**\n#{dashboard_order}"
      click_button('VIEW ALL Popular Values')

      # Create string of the badges name
      # Click on the drop down and select All time 
      click_button ('All Time')
      for i in 0..amount_of_badges - 1 
        @BROWSER.div(:class, 'leaderboard-values-list').div(:class => 'col-xs-4', :index => i).div(:class, %w(leaderboard-values-list-item-count ng-binding)).wait_until_present
        leaderboard_order += "\n" + @BROWSER.div(:class, 'leaderboard-values-list').div(:class => 'col-xs-4', :index => i).div(:class, %w(leaderboard-values-list-item-count ng-binding)).text
      end 

      puts  "\n**Dashboard**\n#{leaderboard_order}"
      
      # Compere both strings. If they are not eqaul the order is not equal.
      if dashboard_order != leaderboard_order
        fail(msg = 'Error. popular_values. The order of the badges is different in Dashboard and Leaderbaord.')
      end
    end
  end

  # Validate data in User Management box
  def validate_user_management
    is_visible                                      
    dashboard_total_user = @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["management"]["title"]}/).span(:index, 0).text
    dashboard_awaiting_approval = @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["management"]["title"]}/).span(:index, 1).text
    dashboard_pending_users = @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["management"]["title"]}/).span(:index, 2).text

    puts "\nDashboard: Total User:#{dashboard_total_user}\nAwaiting Approval:#{dashboard_awaiting_approval}\nPending Users:#{dashboard_pending_users}\n"
    click_button('VIEW ALL User Management')

    @BROWSER.li(:class, %w(ng-isolate-scope active)).span(:class, %w(badge pull-right ng-binding)).wait_until_present
    employees_total_user = @BROWSER.li(:class, %w(ng-isolate-scope active)).span(:class, %w(badge pull-right ng-binding)).text
    
    @BROWSER.li(:class => 'ng-isolate-scope', :index => 1).a(:class,'ng-binding').span(:class => %w(badge pull-right ng-binding)).wait_until_present
    employees_awaiting_approval =  @BROWSER.li(:class => 'ng-isolate-scope', :index => 1).a(:class,'ng-binding').span(:class => %w(badge pull-right ng-binding)).text
    
    @BROWSER.li(:class => 'ng-isolate-scope', :index => 2).a(:class,'ng-binding').span(:class => %w(badge pull-right ng-binding)).wait_until_present
    employees_pending_users =  @BROWSER.li(:class => 'ng-isolate-scope', :index => 2).a(:class,'ng-binding').span(:class => %w(badge pull-right ng-binding)).text

    puts "\nEmployess: Total User:#{employees_total_user}\nAwaiting Approval:#{employees_awaiting_approval}\nPending Users:#{employees_pending_users}\n"

    if dashboard_total_user != employees_total_user
      fail(msg = 'Error. user_management. Total is not match in Dashboard and Colleagues.')
    elsif dashboard_awaiting_approval != employees_awaiting_approval
      fail(msg = 'Error. user_management. Awaiting Approval is not match in Dashboard and Colleagues.')
    elsif dashboard_pending_users != employees_pending_users
      fail(msg = 'Error. user_management. Pending is not match in Dashboard and Colleagues.')
    end
  end

  # Send post
  # @param post_text
  def send_new_post (post_text)
    @BROWSER.div(:class, 'panel-body').click
    @BROWSER.div(:class, 'public-DraftEditor-content').wait_until_present
    @BROWSER.div(:class, 'public-DraftStyleDefault-block public-DraftStyleDefault-ltr').wait_until_present
    @BROWSER.div(:class, 'public-DraftStyleDefault-block public-DraftStyleDefault-ltr').fire_event('click')
    @BROWSER.div(:class, 'DraftEditor-editorContainer').send_keys post_text
    click_button('Post')
  end
 
  # set engagement
  def set_engagement
    @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["engagement"]["title"]}/).wait_until_present
    
    total_recognitions = @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["engagement"]["title"]}/).p(:text, /#{ZEUS_STRINGS["widget"]["engagement"]["label_1"]}/).span.text.to_i
    recognitions_this_month = @BROWSER.div(:class => 'module', :text => /#{ZEUS_STRINGS["widget"]["engagement"]["title"]}/).p(:text, /#{ZEUS_STRINGS["widget"]["engagement"]["label_2"]}/).span.text.to_i
    puts "total_recognitions#{total_recognitions} recognitions_this_month:#{recognitions_this_month}"
    @file_service.insert_to_file('total_recognitions:', total_recognitions)
    @file_service.insert_to_file('recognitions_this_month:', recognitions_this_month) 
  end

  # Get engagement
  def get_engagement
    engagementArray = Array.new(2)
    engagementArray[0] = @file_service.get_from_file('total_recognitions:')
    engagementArray[1] = @file_service.get_from_file('recognitions_this_month:') 
    return engagementArray 
  end

  # Validate engagement after update
  def validate_engagement_after_update
    oldEngagementArray = get_engagement
    set_engagement
    newEngagementArray = get_engagement

    for i in 0..oldEngagementArray.size - 1 
      puts "oldEngagementArray[i]+1:#{oldEngagementArray[i].to_i + 1} newEngagementArray[i]:#{newEngagementArray[i].to_i}"
      if oldEngagementArray[i].to_i + 1 != newEngagementArray[i].to_i
        fail (msg = "Error. validate_engagement_after_update.")
      end
    end
  end

  # set total spending
  def set_total_spending
    @BROWSER.div(:class, %w(panel panel-engagement js-velocity-hook ng-scope)).wait_until_present
    @BROWSER.div(:class, %w(panel panel-benefits panel-benefits--spending js-velocity-hook ng-scope)).div(:text, ZEUS_STRINGS['widget']['spending']['title']).wait_until_present
    @BROWSER.div(:class, %w(panel panel-benefits panel-benefits--spending js-velocity-hook ng-scope)).canvas.wait_until_present
    @BROWSER.div(:text, @LBL_POPULAR_BRANDS_SHOP_ONLINE).wait_until_present
    @BROWSER.div(:text, @LBL_POPULAR_CATEGORIES_SHOP_ONLINE).wait_until_present

    @file_service.insert_to_file('shop_online:', (/\d+.*/.match @BROWSER.div(:class => %w(panel panel-benefits panel-benefits--spending js-velocity-hook ng-scope)).li(:text, /Shop Online/).text)[0][0..-4].delete(','))
    @file_service.insert_to_file('daily_deals:', (/\d+.*/.match @BROWSER.div(:class => %w(panel panel-benefits panel-benefits--spending js-velocity-hook ng-scope)).li(:text, /Daily Deals/).text)[0][0..-4].delete(','))
    @file_service.insert_to_file('total:', (/\d+.*/.match @BROWSER.div(:class => %w(panel panel-benefits panel-benefits--spending js-velocity-hook ng-scope)).li(:text, /Total/).text)[0][0..-4].delete(','))
    
    if @BROWSER.div(:text, popular_categories_lable).parent.tr(:text, /#{@file_service.get_from_file('retailer_category:')[0..-2]}/).td(:index, 1).exists?
      category_total = (/\d+.*/.match (@BROWSER.div(:text, popular_categories_lable).parent.tr(:text, /#{@file_service.get_from_file('retailer_category:')[0..-2]}/).td(:index, 1).text))[0][0..-4].delete(',')
    else
      category_total = 0
    end

    @file_service.insert_to_file('category_total:', category_total)

    if @BROWSER.div(:text, @LBL_POPULAR_BRANDS_SHOP_ONLINE).parent.tr(:text, /#{@file_service.get_from_file('retailer_name:')[0..-2]}/).td(:index, 1).exists?
      retailer_total = (/\d+.*/.match (@BROWSER.div(:text, @LBL_POPULAR_BRANDS_SHOP_ONLINE).parent.tr(:text, /#{@file_service.get_from_file('retailer_name:')[0..-2]}/).td(:index, 1).text))[0][0..-4].delete(',')
      totalSpendingArray = get_toal_spending
    else
      totalSpendingArray = 0
    end

    @file_service.insert_to_file('retailer_total:', retailer_total)
    
    puts "The current data befor new transaction is shop_online:#{totalSpendingArray[0]} daily_deals:#{totalSpendingArray[1]} total:#{totalSpendingArray[2]}"
  end

  # Get total spending
  def get_toal_spending
    totalSpendingArray = Array.new(5)
    totalSpendingArray[0] = @file_service.get_from_file('shop_online:')
    totalSpendingArray[1] = @file_service.get_from_file('daily_deals:')
    totalSpendingArray[2] = @file_service.get_from_file('total:')
    totalSpendingArray[3] = @file_service.get_from_file('category_total:')
    totalSpendingArray[4] = @file_service.get_from_file('retailer_total:')

    puts "The current data befor new transaction is shop_online:#{totalSpendingArray[0]} daily_deals:#{totalSpendingArray[1]} total:#{totalSpendingArray[2]}"
    return totalSpendingArray 
  end

  # Validate total spending after update
  def validate_total_spending_after_update
    oldTotalSpendingArray = get_toal_spending
    set_total_spending
    newTotalSpendingArray = get_toal_spending
    puts "oldTotalSpendingArray:#{oldTotalSpendingArray} newTotalSpendingArray:#{newTotalSpendingArray} "
    if oldTotalSpendingArray[0].to_i + $purchase_amount_incentive_networks != newTotalSpendingArray[0].to_i
      fail (msg = "Error. validate_total_spending_after_update. #{oldTotalSpendingArray[0].to_i} + #{$purchase_amount_incentive_networks} != #{newTotalSpendingArray[0].to_i}")
    elsif oldTotalSpendingArray[1].to_i + $purchase_amount_bownty != newTotalSpendingArray[1].to_i
      fail (msg = "Error. validate_total_spending_after_update. #{oldTotalSpendingArray[1].to_i} + #{$purchase_amount_incentive_networks} != #{newTotalSpendingArray[1].to_i}")
    elsif oldTotalSpendingArray[2].to_i + $purchase_amount_incentive_networks + $purchase_amount_bownty != newTotalSpendingArray[2].to_i  
      fail (msg = "Error. validate_total_spending_after_update. #{oldTotalSpendingArray[2].to_i} + #{$purchase_amount_incentive_networks} != #{newTotalSpendingArray[2].to_i}")  
    elsif oldTotalSpendingArray[3].to_i + $purchase_amount_incentive_networks != newTotalSpendingArray[3].to_i
      fail (msg = "Error. validate_total_spending_after_update. #{oldTotalSpendingArray[3].to_i} + #{$purchase_amount_incentive_networks} != #{newTotalSpendingArray[3].to_i}")
    elsif oldTotalSpendingArray[4].to_i + $purchase_amount_incentive_networks != newTotalSpendingArray[4].to_i
      fail (msg = "Error. validate_total_spending_after_update. #{oldTotalSpendingArray[4].to_i} + #{$purchase_amount_incentive_networks} != #{newTotalSpendingArray[4].to_i}")
    end
  end

  def validate_dashboard_empty_state
    if @BROWSER.div(:class, %w(panel panel-engagement js-velocity-hook ng-scope)).span(:text, ZEUS_STRINGS["widget"]["engagement"]["label_1"]).parent.parent.span(:text => '0').exists?
      @BROWSER.span(:text, /#{ZEUS_STRINGS["widget"]["recognition"]["label_1"][0..10]}/).wait_until_present
      @BROWSER.span(:text, /#{ZEUS_STRINGS["widget"]["categories"]["if_empty_title"][10...16]}/).wait_until_present
      @BROWSER.span(:text, /#{ZEUS_STRINGS["widget"]["brands"]["if_empty_title"][10...16]}/).wait_until_present
      
      @BROWSER.div(:class, %w(panel panel-warning panel-user-management js-velocity-hook ng-scope)).div(:class => 'row', :text => /#{ZEUS_STRINGS["widget"]["management"]["label_1"]}\n1/).wait_until_present
      @BROWSER.div(:class, %w(panel panel-warning panel-user-management js-velocity-hook ng-scope)).div(:class => 'row', :text => /#{ZEUS_STRINGS["widget"]["management"]["label_2"]}\n0/).wait_until_present
      @BROWSER.div(:class, %w(panel panel-warning panel-user-management js-velocity-hook ng-scope)).div(:class => 'row', :text => /#{ZEUS_STRINGS["widget"]["management"]["label_3"]}\n0/).wait_until_present

      @BROWSER.div(:class, %w(panel panel-engagement js-velocity-hook ng-scope)).span(:text, ZEUS_STRINGS["widget"]["engagement"]["label_2"]).parent.parent.span(:text => '0').wait_until_present
      @BROWSER.div(:class, %w(panel panel-engagement js-velocity-hook ng-scope)).span(:text, ZEUS_STRINGS["widget"]["engagement"]["label_3"]).parent.parent.span(:text => '0').wait_until_present
      @BROWSER.div(:class, %w(panel panel-engagement js-velocity-hook ng-scope)).span(:text, ZEUS_STRINGS["widget"]["engagement"]["label_3"]).parent.parent.span(:text => '0').wait_until_present
    end
  end
end
