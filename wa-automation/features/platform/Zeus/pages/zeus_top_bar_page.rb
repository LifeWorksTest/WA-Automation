# -*- encoding : utf-8 -*-
class ZeusTopBarPage

  def initialize (browser)
    @BROWSER = browser
        
    @BTN_DASHBOARD = @BROWSER.div(:class => 'flexible-column-module__flexible-column___2TfjO', :text => ZEUS_STRINGS["post_login"]["dashboard"])
    @BTN_PERFORMANCE = @BROWSER.div(:class => 'flexible-row-module__flexible-row-item--left___2xb1l', :text => ZEUS_STRINGS["post_login"]["performance"])
    @BTN_EMPLOYEES = @BROWSER.div(:class => 'flexible-row-module__flexible-row-item--left___2xb1l', :text => ZEUS_STRINGS["post_login"]["employees"])
    @BTN_REWARDS = @BROWSER.div(:class => 'flexible-column-module__flexible-column___2TfjO', :text => ZEUS_STRINGS["post_login"]["rewards"])
    @BTN_TIMELINE = @BROWSER.div(:class => 'flexible-row-module__flexible-row-item--left___2xb1l', :text => ZEUS_STRINGS["post_login"]["timeline"])
    @BTN_VIEW_COLLEAGUES = @BROWSER.div(:class => 'menu-module__label___1K3v4 menu-module__section___1u0VG', :text => ZEUS_STRINGS["post_login"]["view_colleagues"])
    @BTN_MENU = @BROWSER.div(:class, %w(menu-module__item-container___3jx62 menu-module__right-item___1N2Nu))
    @BTN_LOGOUT = @BROWSER.div(:class => %w(menu-module__label___1K3v4 menu-module__section___1u0VG), :text => ZEUS_STRINGS["post_login"]["logout"])
    @BTN_LEADERBOARD = @BROWSER.div(:class => 'flexible-column-module__flexible-column___2TfjO', :text => ZEUS_STRINGS["post_login"]["leaderboard"])
    @BTN_COMPANY = @BROWSER.div(:class => 'flexible-column-module__flexible-column___2TfjO', :text => ZEUS_STRINGS["post_login"]["company_values"])
    @BTN_ADD_NEW_EMPLOYEES = @BROWSER.a(:text, ZEUS_STRINGS["widget"]["dashboard"]["btn"])
    @BTN_BACK = @BROWSER.a(:text, ZEUS_STRINGS["add_user"]["invitation"]["inv_btn"])
    @BTN_GROUPS = @BROWSER.div(:text, ZEUS_STRINGS["post_login"]["groups"])
    @TXF_ENTER_EMAIL_ADDRESS = @BROWSER.textarea(:placeholder, 'Enter email address')
    
    @IMG_SPINNER = @BROWSER.div(:class, %w(spinner ng-scope))
    is_visible('dashboard')
  end

  def is_visible (page)
    #@BTN_DASHBOARD.wait_until_present
    #@BTN_EMPLOYEES.wait_until_present
    #@BTN_TIMELINE.wait_until_present
    #@BTN_MENU.wait_until_present
    #@BTN_PERFORMANCE.wait_until_present
    #@BTN_REWARDS.wait_until_present
  end
    
  def click_button (button)
    sleep(0.5)
    case button
    when 'Groups'
      @BTN_GROUPS.wait_until_present
      @BTN_GROUPS.click
      @BROWSER.h2(:text, ZEUS_STRINGS["post_login"]["groups"]).wait_until_present
    when 'Account'
      @BROWSER.div(:class => 'flexible-row-module__flexible-row___2kaQw', :text => ZEUS_STRINGS["post_login"]["account"], :index => 0).wait_until_present
      @BROWSER.div(:class => 'flexible-row-module__flexible-row___2kaQw', :text => ZEUS_STRINGS["post_login"]["account"], :index => 0).click
      @BROWSER.h2(:text, /#{ZEUS_STRINGS["post_login"]["account"]}/).wait_until_present
    when 'Settings'
      @BROWSER.div(:class => 'menu-module__label___1K3v4 menu-module__section___1u0VG', :text => ZEUS_STRINGS["post_login"]["settings"]).wait_until_present
      @BROWSER.div(:class => 'menu-module__label___1K3v4 menu-module__section___1u0VG', :text => ZEUS_STRINGS["post_login"]["settings"]).click
      @BROWSER.h2(:text, ZEUS_STRINGS["post_login"]["settings"]).wait_until_present
    when 'Dashboard'
      @BTN_DASHBOARD.wait_until_present
      @BTN_DASHBOARD.click
      @BTN_ADD_NEW_EMPLOYEES.wait_until_present
    when 'Performance'
      @BTN_PERFORMANCE.wait_until_present
      @BTN_PERFORMANCE.hover
      @BTN_LEADERBOARD.wait_until_present
    when 'Colleagues'
      @BTN_EMPLOYEES.wait_until_present
      @BTN_EMPLOYEES.hover
      @BTN_VIEW_COLLEAGUES.wait_until_present
    when 'View Colleagues'
      @BTN_VIEW_COLLEAGUES.wait_until_present
      @BTN_VIEW_COLLEAGUES.fire_event('click')
      @BROWSER.h2(:text, /#{ZEUS_STRINGS["post_login"]["colleague_directory"]}/).wait_until_present
    when 'Add New Colleagues'
      @BTN_ADD_NEW_EMPLOYEES.wait_until_present
      @BTN_ADD_NEW_EMPLOYEES.click
      @BTN_BACK.wait_until_present
    when 'Timeline'
      @BTN_TIMELINE.wait_until_present
      @BTN_TIMELINE.click
      @BROWSER.h2(:text, /#{ZEUS_STRINGS["post_login"]["timeline"]}/).wait_until_present
    when 'Menu'
      @BTN_MENU.wait_until_present 
      @BTN_MENU.scroll.to :top
      @BTN_MENU.hover
      sleep 1

      if !@BTN_LOGOUT.present?
        click_button('Colleagues')
        @BTN_MENU.hover
        @BTN_LOGOUT.wait_until_present
      end
    when 'Log out'
      @BTN_LOGOUT.wait_until_present
      @BTN_LOGOUT.fire_event('click')
      @BTN_MENU.wait_while_present
      @BROWSER.a(:class => 'btn btn-primary', :text => ZEUS_STRINGS["login"]["login_btn"]).wait_until_present
    when 'Leaderboard'
      @BTN_LEADERBOARD.wait_until_present
      @BTN_LEADERBOARD.click
      @BROWSER.h2(:text, /#{ZEUS_STRINGS["post_login"]["leaderboard"]}/).wait_until_present
    when 'Company'
      @BTN_COMPANY.wait_until_present
      @BTN_COMPANY.click
      @BROWSER.h2(:text, /#{ZEUS_STRINGS["post_login"]["company_values"]}/).wait_until_present
    when 'Back'
      @BTN_BACK.wait_until_present
      @BTN_BACK.click
      @BTN_BACK.wait_while_present
    when 'Options'
      @BTN_OPTIONS.wait_until_present
      @BTN_OPTIONS.click
      @BTN_OPTIONS.wait_while_present
    when 'Rewards'
      @BTN_REWARDS.wait_until_present
      @BTN_REWARDS.click
      @BROWSER.h2(:text, ZEUS_STRINGS["post_login"]["rewards"]).wait_until_present
    else
      fail(msg = "Error. click_button. The option #{button} is not defined in menu.")
    end
  end 
  
  def logout
    click_button('Menu')
    click_button('Log out')
  end
end