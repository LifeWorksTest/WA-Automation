# -*- encoding : utf-8 -*-
require 'time'
class ZeusAccountPage

  def initialize (browser)
    @BROWSER = browser

    @BTN_SAVE = @BROWSER.button(:text, ZEUS_STRINGS["account"]["profile_edit"]["save"])
    @BTN_CANCEL = @BROWSER.a(:text, ZEUS_STRINGS["account"]["profile_edit"]["cancel"])
    @BTN_EDIT = @BROWSER.a(:text, ZEUS_STRINGS["account"]["company_profile"]["edit"])
    @BTN_ADD_NEW_ADMIN = @BROWSER.div(:class => 'btn btn-success', :text => ZEUS_STRINGS["account"]["admins"]["add_new_admin"])
    @BTN_TRANSFER_OWNERSHIP = @BROWSER.div(:class, 'btn btn-primary btn-ghost')
    @BTN_TRANSFER_OWNERSHIP_CNFRM = @BROWSER.div(:class => 'modal-new-admin ng-scope').button(:class => 'btn btn-primary', :text => ZEUS_STRINGS["account"]["transfer_ownership"]["confirm_btn"])
    
    @TXF_JOINED_YEAR = @BROWSER.text_field(:id, 'joinedyear')
    @TXF_EMAIL = @BROWSER.text_field(:id, 'email') 
    @TXF_PHONE = @BROWSER.text_field(:id, 'phone')
    @TXF_MOBILE = @BROWSER.text_field(:id, 'mobile')
    @TXF_BIRTH_DAY = @BROWSER.text_field(:id, 'birthday')
    @TXF_BIRTH_MONTH = @BROWSER.text_field(:id, 'birthmonth')
    @TXF_BIRTH_YEAR = @BROWSER.text_field(:id, 'birthyear')

    @IMG_SPINNER = @BROWSER.div(:class, %w(spinner full-screen))
  end

  def is_visible (page)
    @BROWSER.h2(:text, /#{ZEUS_STRINGS["post_login"]["account"]}/).wait_until_present

    case page
    when 'Company Profile'
      @BTN_EDIT.wait_until_present
      
      @BROWSER.div(:class, 'panel-hero-heading-nickname').wait_until_present
      nickname_panel = @BROWSER.div(:class, 'panel-hero-heading-nickname').text
      @BROWSER.div(:class, %w(panel-body panel-hero-heading)).h1.wait_until_present
      nickname_body = @BROWSER.div(:class, %w(panel-body panel-hero-heading)).h1.text

      if nickname_body != nickname_panel
        fail(msg = "Error. Company Profile. Nickname mismatch nickname_panel:#{nickname_panel} nickname_body:#{nickname_body}.") 
      end
    end
  end

  def click_button (button)
    case button
    when 'Transfer ownership'
      @BTN_TRANSFER_OWNERSHIP.wait_until_present
      @BTN_TRANSFER_OWNERSHIP.click
      
      # This if statement is here for a reason. If it is removed, then test Z6.4 will fail as this button is activated in 2 places.
      # 1) User profile page (BTN_TRANSFER_OWNERSHIP_CNFRM does exist)... 2) Account/admin page (BTN_TRANSFER_OWNERSHIP_CNFRM does not exist)
      if @BTN_TRANSFER_OWNERSHIP_CNFRM.exists?
          @BTN_TRANSFER_OWNERSHIP_CNFRM.click
      end
    when 'Cancel'
      @BTN_CANCEL.wait_until_present
      @BTN_CANCEL.click
      @BTN_CANCEL.wait_while_present
    when 'Edit'
      @BTN_EDIT.wait_until_present
      @BTN_EDIT.click
      @BTN_CANCEL.wait_until_present
      @BTN_SAVE.wait_until_present
    when 'Save'
      @BTN_SAVE.wait_until_present
      @BTN_SAVE.click
      # @BROWSER.div(:class, %w(toast__item velocity-opposites-transition-slideDownBigIn ng-scope toast-approved)).wait_until_present
      @BTN_EDIT.wait_until_present
    when 'Continue'
      @BROWSER.a(:class, %w(btn btn-large btn-primary btn-block)).wait_until_present
      @BROWSER.a(:class, %w(btn btn-large btn-primary btn-block)).click
      @BROWSER.label(:text, 'LifeWorks is too expensive').wait_until_present
    when 'Company Profile'
      @BROWSER.a(:class => 'ng-binding', :text => ZEUS_STRINGS["account"]["menu"]["profile"]).wait_until_present
      @BROWSER.a(:class => 'ng-binding', :text => ZEUS_STRINGS["account"]["menu"]["profile"]).click
      @BROWSER.div(:class, 'account-view').wait_until_present
    when 'Admins'
      @BROWSER.a(:class => 'ng-binding', :text => ZEUS_STRINGS["account"]["menu"]["admins"]).wait_until_present
      @BROWSER.a(:class => 'ng-binding', :text => ZEUS_STRINGS["account"]["menu"]["admins"]).click
      @BROWSER.div(:class => %w(btn btn-success), :text => ZEUS_STRINGS["account"]["admins"]["add_new_admin"]).wait_until_present
    when 'Add new admin'
      @BTN_ADD_NEW_ADMIN.wait_until_present
      @BTN_ADD_NEW_ADMIN.click
      @BROWSER.h2(:text, 'Select a colleague to become an admin').wait_until_present
      @BROWSER.div(:class, %w(employee-list-item ng-scope)).wait_until_present
    else
      fail(msg = "Error. click_button. The option #{button} is not defined in menu.")
    end
  end

  # Change user profile to the given profile
  # @param profile
  def change_profile_data_to (profile)
    click_button('Edit')    
    @BROWSER.text_field(:name, 'vm.company_day').wait_until_present
    @BROWSER.text_field(:name, 'vm.company_day').set COMPANY_PROFILE[:"#{profile}"][:founded_day]
    @BROWSER.select_list(:name, 'vm.company_month').wait_until_present
    @BROWSER.select_list(:name, 'vm.company_month').select COMPANY_PROFILE[:"#{profile}"][:founded_month]
    @BROWSER.text_field(:name, 'vm.company_year').wait_until_present
    @BROWSER.text_field(:name, 'vm.company_year').set COMPANY_PROFILE[:"#{profile}"][:founded_year]
    @BROWSER.select_list(:id, 'industry_type').wait_until_present
    @BROWSER.select_list(:id, 'industry_type').select COMPANY_PROFILE[:"#{profile}"][:industry_type]
    @BROWSER.text_field(:name, 'address_one').wait_until_present
    @BROWSER.text_field(:name, 'address_one').set COMPANY_PROFILE[:"#{profile}"][:address_line_1]
    @BROWSER.text_field(:name, 'address_line2').wait_until_present
    @BROWSER.text_field(:name, 'address_line2').set COMPANY_PROFILE[:"#{profile}"][:address_line_2]
    @BROWSER.text_field(:name, 'city').wait_until_present
    @BROWSER.text_field(:name, 'city').set COMPANY_PROFILE[:"#{profile}"][:city]
    @BROWSER.text_field(:name, 'post_code').wait_until_present
    @BROWSER.text_field(:name, 'post_code').set COMPANY_PROFILE[:"#{profile}"][:postcode]
    @BROWSER.select_list(:id, 'country').wait_until_present
    # @BROWSER.select_list(:id, 'country').select COMPANY_PROFILE[:"#{profile}"][:country]
  end

  # Change company founded date to today
  # @param profile
  def change_founded_date_to_today
    click_button('Edit')
    @BROWSER.text_field(:name, 'vm.company_day').wait_until_present
    @BROWSER.text_field(:name, 'vm.company_day').set Time.now.strftime("%d")
    @BROWSER.select_list(:name, 'vm.company_month').wait_until_present
    @BROWSER.select_list(:name, 'vm.company_month').select Date.today.strftime("%b")
    @BROWSER.text_field(:name, 'vm.company_year').wait_until_present
    @BROWSER.text_field(:name, 'vm.company_year').set COMPANY_PROFILE[:profile_1][:founded_year]
    click_button('Save')
  end

  # Check that the profile is match to the give profile
  # @param profile - to match with
  def check_profile_is_match_to (profile)
    puts "#{profile}"
    date = @BROWSER.div(:class, %w(panel panel-settings ng-scope)).div(:class => 'panel-body', :index => 1).div(:class => 'row', :index => 0).div(:class, 'col-sm-6').text
    if @BROWSER.div(:class, %w(panel panel-settings ng-scope)).div(:class => 'panel-body', :index => 1).div(:class => 'row', :index => 0).div(:class, 'col-sm-6').text != COMPANY_PROFILE[:"#{profile}"][:date_founded]
      fail(msg = 'Error. check_profile_is_match_to. Founded_date is not match.') 
    elsif @BROWSER.div(:class, %w(panel panel-settings ng-scope)).div(:class => 'panel-body', :index => 1).div(:class => 'row', :index => 2).div(:class, 'col-sm-6').text != COMPANY_PROFILE[:"#{profile}"][:industry_type]
      fail(msg = 'Error. check_profile_is_match_to. Industry_type is not match') 
    elsif @BROWSER.div(:class, %w(panel panel-settings ng-scope)).div(:class => 'panel-body', :index => 2).div(:class => 'row', :index => 0).div(:class, 'col-sm-6').text != COMPANY_PROFILE[:"#{profile}"][:address_line_1]
      fail(msg = 'Error. check_profile_is_match_to. Address_line_1 is not match') 
    elsif @BROWSER.div(:class, %w(panel panel-settings ng-scope)).div(:class => 'panel-body', :index => 2).div(:class => 'row', :index => 1).div(:class, 'col-sm-6').text != COMPANY_PROFILE[:"#{profile}"][:address_line_2]
      fail(msg = 'Error. check_profile_is_match_to. Address_line_2 is not match') 
    elsif @BROWSER.div(:class, %w(panel panel-settings ng-scope)).div(:class => 'panel-body', :index => 2).div(:class => 'row', :index => 2).div(:class, 'col-sm-6').text != COMPANY_PROFILE[:"#{profile}"][:city]
      fail(msg = 'Error. check_profile_is_match_to. City is not match') 
    elsif @BROWSER.div(:class, %w(panel panel-settings ng-scope)).div(:class => 'panel-body', :index => 2).div(:class => 'row', :index => 3).div(:class, 'col-sm-6').text != COMPANY_PROFILE[:"#{profile}"][:postcode]
      fail(msg = "Error. check_profile_is_match_to. Postcode is not match") 
    # elsif @BROWSER.div(:class, 'panel panel-settings ng-scope').div(:class => 'panel-body', :index => 2).div(:class => 'row', :index => 6).div(:class, 'col-sm-6').text.downcase != COMPANY_PROFILE[:"#{profile}"][:country].downcase
    #   fail(msg = 'Error. check_profile_is_match_to. Country is not match')
    end
  end

  # Add/Remove user from admin list
  # @param action - 'add' or 'remove'
  # @param user_name
  def add_remove_user_from_admin_list (action ,user_name)
    if action == 'add'
      click_button('Add new admin')
      @BROWSER.input(:id, 'search-box').wait_until_present
      @BROWSER.input(:id, 'search-box').send_keys user_name
      sleep(2)
      
      i = 0
      @BROWSER.div(:class, 'name').wait_until_present

      while ! @BROWSER.div(:class => 'name', :text => user_name, :index => i).present?
        if (i + 1) % 7 == 0
          @BROWSER.element.send_keys [:space]
          sleep(0.5)
        end

        i = i + 1
      end

      @BROWSER.div(:class => 'name', :text => user_name).parent.parent.parent.div(:text => ZEUS_STRINGS["add_admin"]["active_search"]["btn"]).wait_until_present
      @BROWSER.div(:class => 'name', :text => user_name).parent.parent.parent.div(:text => ZEUS_STRINGS["add_admin"]["active_search"]["btn"]).click
      @BROWSER.div(:class, 'modal-dialog').button(:class, %w(btn btn-primary)).wait_until_present
      @BROWSER.div(:class, 'modal-dialog').button(:class, %w(btn btn-primary)).fire_event('click')
      @BROWSER.div(:class => %w(btn btn-primary), :text => ZEUS_STRINGS["account"]["admins"]["transfer_ownership"]).wait_until_present
      @BROWSER.div(:class => %w(btn btn-success), :text => ZEUS_STRINGS["account"]["admins"]["add_new_admin"]).wait_until_present
      @BROWSER.div(:class, %w(employee-list-item ng-scope)).wait_until_present
      other_admin_size  = @BROWSER.divs(:class, %w(employee-list-item ng-scope)).count
      puts "other_admin_size:#{other_admin_size}"
      user_is_in_admin_list = false
      
      for i in 0..other_admin_size - 1
        @BROWSER.div(:class => %w(employee-list-item ng-scope), :index => i).div.span(:text, ZEUS_STRINGS["account"]["admins"]["admin"]).wait_until_present
        @BROWSER.div(:class => %w(employee-list-item ng-scope), :index => i).div(:class, %w(btn btn-inverse)).wait_until_present

        if @BROWSER.div(:class => %w(employee-list-item ng-scope), :index => i).a(:class => %w(name ng-binding), :text => user_name).exists?
          user_is_in_admin_list = true
          break
        else 
          puts "USER in index #{i}: #{@BROWSER.div(:class => %w(employee-list-item ng-scope), :index => i).a(:class => %w(name ng-binding)).text}"
        end
      end

      if !user_is_in_admin_list
        fail(msg = "Error, add_remove_user_from_admin_list, #{user_name} was not found in list after giving him Admin role")
      end
    
    elsif action == 'remove'
      @BROWSER.div(:class, %w(employee-list ng-scope)).div(:class, %w(btn btn-success)).wait_until_present
      @BROWSER.a(:text, user_name).wait_until_present
      @BROWSER.a(:text, user_name).parent.parent.parent.div(:class => %w(btn btn-inverse btn-ghost) ,:text => ZEUS_STRINGS["account"]["admins"]["revoke"]).wait_until_present
      @BROWSER.a(:text, user_name).parent.parent.parent.div(:class => %w(btn btn-inverse btn-ghost) ,:text => ZEUS_STRINGS["account"]["admins"]["revoke"]).click
      @BROWSER.div(:class => 'modal-dialog',:text => /#{user_name}’s admin rights will be revoked and he will not be able to access the admin panel./).wait_until_present
      @BROWSER.div(:class, 'modal-dialog').button(:class, %w(btn btn-primary)).wait_until_present
      @BROWSER.div(:class, 'modal-dialog').button(:class, 'btn btn-primary').click
      @BROWSER.div(:class, %w(employee-list-item ng-scope)).wait_until_present
      @BROWSER.refresh
      @BROWSER.div(:class, 'employee-list').wait_until_present
      other_admin_size  = @BROWSER.divs(:class, %w(employee-list-item ng-scope)).count
      user_is_in_admin_list = false
     
      # Check that the user is not in the Admin list
      puts "other_admin_size: #{other_admin_size}"
      
      if other_admin_size.to_i > 1
        for i in 0..other_admin_size - 1
          @BROWSER.div(:class => %w(employee-list-item ng-scope), :index => i).div.span(:text, ZEUS_STRINGS["account"]["admins"]["admin"]).wait_until_present
          @BROWSER.div(:class => %w(employee-list-item ng-scope), :index => i).div(:class, %w(btn btn-inverse)).wait_until_present

          if @BROWSER.div(:class => %w(employee-list-item ng-scope), :index => i).div(:text => user_name).exists?
            user_is_in_admin_list = true
            break
          end
      end
    end

    if user_is_in_admin_list
      fail(msg = "Error. add_remove_user_from_admin_list. #{user_name} was found in list after remove his Admin role")
    end
  end
end

  # Validate changes in view after changing admin list
  # @param action - 'add' or 'remove'
  # @param user_name
  def validate_changes_in_view_after_changing_admin_list(action, user_name)
    @BROWSER.input(:id, 'search-box').wait_until_present
    @BROWSER.input(:id, 'search-box').send_keys user_name
    @BROWSER.div(:class => 'name', :text => user_name).wait_until_present
    
    if action == 'add'
      @BROWSER.div(:class => 'name', :text => user_name).parent.span(:class => %w(text-semibold network-admin), :text => ZEUS_STRINGS["account"]["admins"]["admin"]).wait_until_present
      @BROWSER.div(:class => 'name', :text => user_name).a.wait_until_present
      @BROWSER.div(:class => 'name', :text => user_name).a.click
      @BROWSER.a(:text, /#{ZEUS_STRINGS["user_profile"]["settings"]}/).wait_until_present
      @BROWSER.a(:text, /#{ZEUS_STRINGS["user_profile"]["settings"]}/).click
      @BROWSER.div(:text, ZEUS_STRINGS["user_profile"]["actions"]["revoke_admin"]).wait_until_present
      @BROWSER.div(:text, ZEUS_STRINGS["user_profile"]["actions"]["transfer_ownership"]).wait_until_present
      @BROWSER.div(:text, ZEUS_STRINGS["user_profile"]["actions"]["edit_profile"]).wait_until_present
      @BROWSER.div(:text, ZEUS_STRINGS["user_profile"]["actions"]["archive"]).wait_until_present
    elsif action == 'remove'
      if @BROWSER.div(:class => 'name', :text => user_name).parent.span(:class => %w(text-semibold network-admin ng-scope), :text => ZEUS_STRINGS["account"]["admins"]["admin"]).present?
        fail(msg = 'Error. validate_changes_in_view. Admin label should not be present')
      end

      @BROWSER.div(:class => 'name', :text => user_name).parent.parent.parent.img.click
      @BROWSER.a(:text, /#{ZEUS_STRINGS["user_profile"]["settings"]}/).wait_until_present
      @BROWSER.a(:text, /#{ZEUS_STRINGS["user_profile"]["settings"]}/).click
      @BROWSER.div(:text, 'Make Admin').wait_until_present
      @BROWSER.div(:text, ZEUS_STRINGS["user_profile"]["actions"]["edit_profile"]).wait_until_present
      @BROWSER.div(:text, ZEUS_STRINGS["user_profile"]["actions"]["archive"]).wait_until_present

    end
  end

  # Get company profile
  def get_company_profile
    $company_profile_from_admin = Array.new(10)
    @BROWSER.div(:class, %w(panel panel-settings ng-scope)).wait_until_present
    @BROWSER.div(:class, %w(panel panel-settings ng-scope)).div(:class => 'panel-body', :index => 1).div(:class => 'row', :index => 0).div(:class, 'col-sm-6').wait_until_present
    @BROWSER.div(:class, 'account-view').h1.wait_until_present
    $company_profile_from_admin[0] = @BROWSER.h1.text
    $company_profile_from_admin[1] = Time.parse(@BROWSER.div(:class, %w(panel panel-settings ng-scope)).div(:class => 'panel-body', :index => 1).div(:class => 'row', :index => 0).div(:class, 'col-sm-6').text).strftime("%d/%m/%Y")
    $company_profile_from_admin[2] = (/[^\.]*/.match @BROWSER.div(:class, %w(panel panel-settings ng-scope)).div(:class => 'panel-body', :index => 1).div(:class => 'row', :index => 1).div(:class, 'col-sm-6').text)[0]
    $company_profile_from_admin[3] = @BROWSER.div(:class, %w(panel panel-settings ng-scope)).div(:class => 'panel-body', :index => 1).div(:class => 'row', :index => 2).div(:class, 'col-sm-6').text
    $company_profile_from_admin[4] = @BROWSER.div(:class, %w(panel panel-settings ng-scope)).div(:class => 'panel-body', :index => 2).div(:class => 'row', :index => 0).div(:class, 'col-sm-6').text
    $company_profile_from_admin[5] = @BROWSER.div(:class, %w(panel panel-settings ng-scope)).div(:class => 'panel-body', :index => 2).div(:class => 'row', :index => 1).div(:class, 'col-sm-6').text 
    $company_profile_from_admin[6] = @BROWSER.div(:class, %w(panel panel-settings ng-scope)).div(:class => 'panel-body', :index => 2).div(:class => 'row', :index => 2).div(:class, 'col-sm-6').text 
    $company_profile_from_admin[7] = @BROWSER.div(:class, %w(panel panel-settings ng-scope)).div(:class => 'panel-body', :index => 2).div(:class => 'row', :index => 3).div(:class, 'col-sm-6').text 
    $company_profile_from_admin[8] = @BROWSER.div(:class, %w(panel panel-settings ng-scope)).div(:class => 'panel-body', :index => 2).div(:class => 'row', :index => 4).div(:class, 'col-sm-6').text 
    $company_profile_from_admin[9] = @BROWSER.div(:class, %w(panel panel-settings ng-scope)).div(:class => 'panel-body', :index => 2).div(:class => 'row', :index => 5).div(:class, 'col-sm-6').text
  end

  def transfer_ownership
    click_button('Transfer ownership')
    
    @BROWSER.button(:class, %w(btn btn-primary)).wait_until_present
    @BROWSER.button(:class, %w(btn btn-primary)).click
    @BROWSER.span(:class, %w(icon icon-arrow-wright)).wait_until_present
    @BROWSER.span(:class, %w(icon icon-arrow-wright)).click
    # TODO - Check this logic with Eliran and uncomment below
    #@BROWSER.div(:class, 'modal-body').span(:class => 'ng-scope', :text => /#{(["user_profile"]["transfer_ownership"]["help_text"]).gsub('%{firstName} %{lastName}','')}/).wait_until_present
    @BROWSER.button(:class, %w(btn btn-primary)).wait_until_present
    @BROWSER.button(:class, %w(btn btn-primary)).click
    @BROWSER.div(:class, 'modal-new-admin').wait_while_present
  end

  # Upgrade company account to premium
  def upgrade_to_premium
    # The date in 3 months time
    month = (Date.today >> 3).strftime("%B")
    payment_month = (Date.today >> 4).strftime("%B")
    day = (Date.today >> 3).strftime("%-d")
    year = (Date.today >> 3).strftime("%Y")

    @BROWSER.div(:text, /#{(ZEUS_STRINGS["continue"]["title"]).gsub('%{package}','Premium')}/).wait_until_present
    @BROWSER.div(:text, /#{(ZEUS_STRINGS["continue"]["subtitle"]).gsub('%{package}','Premium')}/).wait_until_present
    #@BROWSER.div(:text => /Your current trial ends on the #{day}.. #{month} #{year}. Upgrade your account now to continue enjoying LifeWorks Premium./).wait_until_present
    @BROWSER.div(:text, 'Free Trial').wait_until_present
    #@BROWSER.div(:class => 'col-sm-8 col-xs-12',:text => /For only£2.50per employee \/ per month. Your first payment will be taken on the #{day}.. #{payment_month} #{year}./).wait_until_present

    @BROWSER.a(:text, (ZEUS_STRINGS["account"]["your_plan"]["get_premium"]).gsub('%{package}','Premium')).wait_until_present
    @BROWSER.a(:text, (ZEUS_STRINGS["account"]["your_plan"]["get_premium"]).gsub('%{package}','Premium')).click

    if $distributor == 'Santander'
      @BROWSER.input(:value, "#{USER_PROFILE[:new_admin_user][:santander_account_number]}").wait_until_present
      @BROWSER.input(:value, "#{USER_PROFILE[:new_admin_user][:santander_sort_code][:part_1]}").wait_until_present
      @BROWSER.input(:value, "#{USER_PROFILE[:new_admin_user][:santander_sort_code][:part_2]}").wait_until_present
      @BROWSER.input(:value, "#{USER_PROFILE[:new_admin_user][:santander_sort_code][:part_3]}").wait_until_present
      @BROWSER.input(:value, 'user0').wait_until_present
    else
      @BROWSER.input(:value, 'user0').wait_until_present
      @BROWSER.span(:text, 'Bank account number').wait_until_present
      @BROWSER.span(:text, 'Bank sort-code').wait_until_present
      @BROWSER.input(:index, 0).wait_until_present
      @BROWSER.input(:index, 1).wait_until_present
      @BROWSER.input(:index, 2).wait_until_present
      @BROWSER.input(:index, 3).wait_until_present
      @BROWSER.input(:index, 4).wait_until_present
      @BROWSER.input(:index, 1).send_keys USER_PROFILE[:new_admin_user][:santander_account_number]
      @BROWSER.input(:index, 2).send_keys USER_PROFILE[:new_admin_user][:santander_sort_code][:part_1]
      @BROWSER.input(:index, 3).send_keys USER_PROFILE[:new_admin_user][:santander_sort_code][:part_2]
      @BROWSER.input(:index, 4).send_keys USER_PROFILE[:new_admin_user][:santander_sort_code][:part_3]
    end

    @BROWSER.div(:text, ZEUS_STRINGS["opt_in"]["step_1"]["check_box"]).parent.div(:class, 'col-xs-1').wait_until_present
    @BROWSER.div(:text, ZEUS_STRINGS["opt_in"]["step_1"]["check_box"]).parent.div(:class, 'col-xs-1').click
    @BROWSER.span(:text, ZEUS_STRINGS["transfer_ownership"]["continue_btn"]).wait_until_present
    @BROWSER.span(:text, ZEUS_STRINGS["transfer_ownership"]["continue_btn"]).click
    @BROWSER.span(:text, ZEUS_STRINGS["transfer_ownership"]["continue_btn"]).wait_until_present
    @BROWSER.span(:text, ZEUS_STRINGS["transfer_ownership"]["continue_btn"]).click
    @BROWSER.a(:text, ZEUS_STRINGS["opt_in"]["step_3"]["done_btn"]).wait_until_present
    @BROWSER.a(:text, ZEUS_STRINGS["opt_in"]["step_3"]["done_btn"]).click
    @BROWSER.span(:text, /#{(ZEUS_STRINGS["billing_info"]["premium_acc"]).gsub('%{package}','Premium')}/).wait_until_present
  end
end
