# -*- encoding : utf-8 -*-
class HermesMenusPage
  def initialize (browser)
    @BROWSER = browser
    
    @BTN_WORK = @BROWSER.div(:id, 'company')
    @BTN_PERKS = @BROWSER.div(:id, 'perksHomePage')
    @BTN_PROFILE = @BROWSER.div(:id, 'profile')
    @BTN_LIFE = @BROWSER.div(:text, HERMES_STRINGS["components"]["main_menu"]["life"]["title"])
    @PERKS_MENU = @BROWSER.div(:class, %w(perks-menu))
    @SKIP_BUTTON = @BROWSER.div(:id, 'skip-button')
  end

  def click_button (button)
    case button
    when 'Gift Cards'
      @PERKS_MENU.a(:text, HERMES_STRINGS["components"]["main_menu"]["gift_cards"]).wait_until_present
      @PERKS_MENU.a(:text, HERMES_STRINGS["components"]["main_menu"]["gift_cards"]).click  
      @BROWSER.div(:class => 'title-velocity-hook', :text => HERMES_STRINGS["giftcards"]["title_1"]).wait_until_present
    when 'Shop Online'
      @PERKS_MENU.a(:text, HERMES_STRINGS["components"]["main_menu"]["shop_online"]).wait_until_present
      @PERKS_MENU.a(:text, HERMES_STRINGS["components"]["main_menu"]["shop_online"]).click
      @BROWSER.span(:text, HERMES_STRINGS["constants"]["categories"]["featured"]).wait_until_present 
    when 'Restaurant'
      @PERKS_MENU.a(:text, HERMES_STRINGS["components"]["main_menu"]["restaurants"]).wait_until_present
      @PERKS_MENU.a(:text, HERMES_STRINGS["components"]["main_menu"]["restaurants"]).click
      @BROWSER.div(:class => 'title-velocity-hook', :text => HERMES_STRINGS["restaurants"]["banner_title"]).wait_until_present
    when 'Cinemas'
      @PERKS_MENU.a(:text, HERMES_STRINGS["components"]["main_menu"]["cinemas"]).wait_until_present
      @PERKS_MENU.a(:text, HERMES_STRINGS["components"]["main_menu"]["cinemas"]).click
      @BROWSER.div(:class => 'title-velocity-hook', :text => HERMES_STRINGS["cinemas"]["banner_title"]).wait_until_present
    when 'In-Store Offers'
      @PERKS_MENU.a(:text, HERMES_STRINGS["components"]["main_menu"]["instore_offers"]).wait_until_present
      @PERKS_MENU.a(:text, HERMES_STRINGS["components"]["main_menu"]["instore_offers"]).click
      @BROWSER.div(:class => 'title-velocity-hook', :text => HERMES_STRINGS["offers"]["title_1"]).wait_until_present
    when 'Exclusive Offers'
      @PERKS_MENU.a(:text, HERMES_STRINGS["components"]["main_menu"]["colleague_offers"]).wait_until_present
      @PERKS_MENU.a(:text, HERMES_STRINGS["components"]["main_menu"]["colleague_offers"]).click
      @BROWSER.div(:class => 'title-velocity-hook', :text => HERMES_STRINGS["offers"]["title_2"]).wait_until_present
    when 'News Feed'
      if !@BROWSER.a(:href, /\/feed\//).present?
        @BROWSER.div(:id, 'feed').wait_until_present
        @BROWSER.div(:id, 'feed').click
      end
    when 'Colleague Directory'
      @BTN_WORK.parent.a(:text, HERMES_STRINGS["components"]["main_menu"]["colleague_directory"]).wait_until_present
      @BTN_WORK.parent.a(:text, HERMES_STRINGS["components"]["main_menu"]["colleague_directory"]).click
      @BROWSER.label(:text, HERMES_STRINGS["directory"]["subtitle"]).wait_until_present
    when 'Leaderboard'
      @BTN_WORK.parent.a(:text, HERMES_STRINGS["components"]["main_menu"]["leaderboard"]).wait_until_present
      @BTN_WORK.parent.a(:text, HERMES_STRINGS["components"]["main_menu"]["leaderboard"]).click
      @BROWSER.h1(:text, HERMES_STRINGS["components"]["main_menu"]["leaderboard"]).wait_until_present
    when 'Wallet'
      @BROWSER.div(:id, 'profile').a(:text, HERMES_STRINGS["components"]["main_menu"]["wallet"]).wait_until_present
      @BTN_PROFILE.a(:text, HERMES_STRINGS["components"]["main_menu"]["wallet"]).click
      
      if $ACCOUNT_TYPE == 'shared'
        @BROWSER.div(:id, 'skip-button').wait_until_present
      else
        @BROWSER.div(:class => 'title-velocity-hook', :text => /#{HERMES_STRINGS["components"]["main_menu"]["wallet"]}/).wait_until_present
      end
    when 'Help'
      @BTN_PROFILE.a(:text, HERMES_STRINGS["components"]["main_menu"]["help"]).wait_until_present
      @BTN_PROFILE.a(:text, HERMES_STRINGS["components"]["main_menu"]["help"]).click
      
      if $ACCOUNT_TYPE == 'shared'
        @BROWSER.div(:id, 'skip-button').wait_until_present
      else
        @BROWSER.div(:text, HERMES_STRINGS["employee_assistance"]["search_placeholder"]).wait_until_present
      end
    when 'Profile'
      @BTN_PROFILE.a(:text, HERMES_STRINGS["components"]["main_menu"]["profile"]).wait_until_present
      @BTN_PROFILE.a(:text, HERMES_STRINGS["components"]["main_menu"]["profile"]).fire_event('click')
      @BROWSER.button(:text, HERMES_STRINGS["profile"]["card"]["edit"].upcase).wait_until_present
    when 'Settings'
      @BTN_PROFILE.a(:text, HERMES_STRINGS["components"]["main_menu"]["settings"]).wait_until_present
      @BTN_PROFILE.a(:text, HERMES_STRINGS["components"]["main_menu"]["settings"]).fire_event('click')
      @BROWSER.div(:class => 'title-velocity-hook', :text => HERMES_STRINGS["settings"]["title"]).wait_until_present
    when 'Logout'
      @BTN_PROFILE.a(:text, HERMES_STRINGS["components"]["main_menu"]["logout"]).wait_until_present
      @BTN_PROFILE.a(:text, HERMES_STRINGS["components"]["main_menu"]["logout"]).fire_event('click')
      @BROWSER.cookies.clear
      @BROWSER.div(:class, %w(page login)).wait_until_present
    when 'Rewards'
      @BTN_PROFILE.a(:text, HERMES_STRINGS["components"]["main_menu"]["rewards"]).wait_until_present
      @BTN_PROFILE.a(:text, HERMES_STRINGS["components"]["main_menu"]["rewards"]).fire_event('click')
      @BROWSER.div(:class => 'title-velocity-hook', :text => HERMES_STRINGS["components"]["main_menu"]["rewards"]).wait_until_present
    when 'Work'
      @BTN_WORK.wait_until_present
      
        if ! @BROWSER.a(:id, 'directory').present?
          @BTN_WORK.i(:class, 'icon-web_arrow_down').hover
          @BROWSER.a(:id, 'directory').wait_until_present
        end 

    when 'Global Action'
      sleep(1)

      if ! @BROWSER.a(:id, 'help').present?
        if @BTN_LIFE.i(:class, 'icon-web_arrow_down').present?
          @BTN_LIFE.i(:class, 'icon-web_arrow_down').hover
          @BTN_PROFILE.hover
        else
          @BTN_PROFILE.fire_event "onmouseover"
        end
        @BROWSER.a(:id, 'help').wait_until_present
      end
      
      if $ACCOUNT_TYPE == 'shared'
        @BROWSER.a(:id, 'settings').wait_until_present
        @BROWSER.a(:id, 'logout').wait_until_present
        Watir::Wait.until { 
          !@BROWSER.a(:id, 'rewards').present? 
          !@BROWSER.a(:id, 'profile').present? 
        }
      end  
    when 'Perks'
      @BROWSER.div(:id, 'spinner').wait_while_present
      if $USER_FEATURE_LIST['benefit']
        if !@PERKS_MENU.present?
          if $ACCOUNT_TYPE == 'shared'
            if !$CLICKED_PERKS_HOMEPAGE
              @BTN_PERKS.wait_until_present
              @BTN_PERKS.fire_event('click')
              @LIMITED_ACCOUNT_PAGE = HermesLimitedAccountPage.new @BROWSER
              @LIMITED_ACCOUNT_PAGE.is_visible('main')
              @LIMITED_ACCOUNT_PAGE.skip_limited_account_page
              $CLICKED_PERKS_HOMEPAGE = true
            end
          else
            @BTN_PERKS.wait_until_present
            @BTN_PERKS.fire_event('click')
            @PERKS_MENU.wait_until_present
          end
        end
      else
        Watir::Wait.until { !@BTN_PERKS.present? }
      end
    when 'Life'
      if !@BTN_LIFE.parent.a(:text, HERMES_STRINGS["components"]["main_menu"]["need_help"]).present?
        @BTN_LIFE.i(:class, 'icon-web_arrow_down').wait_until_present
        @BTN_LIFE.i(:class, 'icon-web_arrow_down').hover
        sleep(1)
        if !@BTN_LIFE.parent.a(:text, HERMES_STRINGS["components"]["main_menu"]["need_help"]).present?
          @BTN_LIFE.i(:class, 'icon-web_arrow_down').fire_event "onmouseover"
          @BTN_LIFE.parent.a(:text, HERMES_STRINGS["components"]["main_menu"]["need_help"]).wait_until_present
        end
      end
    when 'Notification'
      @BROWSER.a(:class, 'notification-indicator').wait_until_present
      @BROWSER.a(:class, 'notification-indicator').fire_event('click')
      @BROWSER.section(:class, 'notifications-dropdown').wait_until_present
    when 'Need Help'
      @BTN_LIFE.parent.a(:text, HERMES_STRINGS["components"]["main_menu"]["need_help"]).wait_until_present
      @BTN_LIFE.parent.a(:text, HERMES_STRINGS["components"]["main_menu"]["need_help"]).fire_event('click')
      @BROWSER.h1(:text, HERMES_STRINGS["components"]["main_menu"]["need_help"]).wait_while_present
    when 'Employee Assitance'
      @BTN_LIFE.parent.a(:text, HERMES_STRINGS["components"]["main_menu"]["employee_assistance"]).wait_until_present
      @BTN_LIFE.parent.a(:text, HERMES_STRINGS["components"]["main_menu"]["employee_assistance"]).click
      @BROWSER.h1(:text, HERMES_STRINGS["components"]["main_menu"]["employee_assistance"]).wait_while_present
    when 'Chat'
      @BROWSER.a(:id, 'chat').wait_until_present
      @BROWSER.a(:id, 'chat').click

      if $ACCOUNT_TYPE == 'shared'
        @BROWSER.div(:id, 'skip-button').wait_until_present
      else
        @BROWSER.div(:class => 'title-velocity-hook', :text => /#{HERMES_STRINGS["chat"]["hero"]["title"]}/).wait_until_present
      end
    when 'Health Library'
      @BROWSER.a(:id, 'healthLibrary').wait_until_present
      @BROWSER.a(:id, 'healthLibrary').click
      @BROWSER.a(:id, 'healthLibrary').wait_while_present   
    when 'Legal Services'
      @BROWSER.a(:id, 'legalServices').wait_until_present
      @BROWSER.a(:id, 'legalServices').click
      @BROWSER.a(:id, 'legalServices').wait_while_present
    when 'Wellness Tools'
      if ENV['CURRENT_CUCUMBER_PROFILE'].include? 'Web_US'
        @BROWSER.a(:id, 'wellnessTools').wait_until_present
        @BROWSER.a(:id, 'wellnessTools').click
        @BROWSER.a(:id, 'wellnessTools').wait_while_present
      else
        Watir::Wait.until { !@BROWSER.a(:id, 'wellnessTools').present? }
      end
    when 'Assessments'
      @BROWSER.a(:id, 'selfAssessmentHub').wait_until_present
      @BROWSER.a(:id, 'selfAssessmentHub').fire_event('click')
      @BROWSER.div(:text, HERMES_STRINGS["self_assessment_2"]["title"]).wait_while_present
    else
      fail(msg = "Error. click_button. The option #{button} is not defined in menu.")
    end
  end

  def disabled_enabled_features (feature, is_enabled)
    case feature
    when 'News feed'
      if eval(is_enabled)
        @BROWSER.div(:id, 'feed').wait_until_present
      else
        if @BROWSER.div(:id, 'feed').present?
          fail(msg = "Error. disabled_enabled_features - #{feature} feature should be disabled. However, the #{feature} menu is still present")
        end
      end

    when 'Colleague Directory'
      if eval(is_enabled)
        @BTN_WORK.wait_until_present
        @BTN_WORK.click
        @BTN_WORK.parent.a(:text, HERMES_STRINGS["components"]["main_menu"]["colleague_directory"]).wait_until_present
      else
        if @BTN_WORK.present?
          @BTN_WORK.click
          if @BTN_WORK.parent.a(:text, HERMES_STRINGS["components"]["main_menu"]["colleague_directory"]).present?
            fail(msg = 'Error. disabled_enabled_features - #{feature} feature should be disabled. However, the #{feature} menu is still present')
          end
        end
      end

    end
  end
  
  
  # Search for the given text
  # @param search - text
  def search (state, user_name)
    @BROWSER.input(:placeholder, 'Search within your company').exists?
    @BROWSER.input(:placeholder, 'Search within your company').send_keys user_name
    
    if state == 'existing'
      @BROWSER.div(:class, %w(flag background-transition)).wait_until_present
      user_displayed = @BROWSER.div(:class, %w(flag background-transition)).text.split("\n").first
      
      if !(user_displayed == user_name)
        fail(msg = 'Error, user name does not exist')
      end    
    elsif state == 'not existing'
      @BROWSER.div(:text, HERMES_STRINGS["directory"]["no_results"]).wait_until_present
    end
    @BROWSER.div(:class, 'title-velocity-hook').click
  end
  

  # Check if the given App notification is in the user notification's box
  # @param notification text 
  def check_for_notification (notification)
    @BROWSER.section(:class, 'notifications-dropdown').article(:index, 0).wait_until_present

    # while notification is not existing in the first and second place in the notification's box
    for i in 0..6
      if @BROWSER.section(:class, 'notifications-dropdown').article(:index, 0).div(:class => %w(message ng-isolate-scope), :text => /#{notification}/).exists?
        return
      end
      
      sleep(2)
      @BROWSER.refresh
      sleep(2)
      click_button('Notification')
    end
    
    fail(msg = "Error. check_for_notification. The next notification '#{notification}' was not found")
  end
end



