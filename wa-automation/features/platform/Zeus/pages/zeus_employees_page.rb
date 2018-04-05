# -*- encoding : utf-8 -*-
class ZeusEmployeesPage

  def initialize (browser)
    @file_service = FileService.new
    @BROWSER = browser

    @TAB_ACTIVE_COLLEAGUES = @BROWSER.a(:text, /#{ZEUS_STRINGS["employee"]["directory"]["active"]}/)
    @TAB_AWITING_APPROVAL = @BROWSER.a(:text, /#{ZEUS_STRINGS["employee"]["directory"]["awaiting"]}/)
    @TAB_PENDING = @BROWSER.span(:text, /#{ZEUS_STRINGS["employee"]["directory"]["pending"]}/)
    @TAB_ARCHIVED = @BROWSER.a(:text, /#{ZEUS_STRINGS["employee"]["directory"]["archived"]}/)

    @BTN_MANAGE_COLLEAGUES = @BROWSER.a(:class, %w(btn btn-success section-header-button ng-scope))
    @BTN_APPROVE = ZEUS_STRINGS["employee"]["approval"]["approve_btn"]
    @BTN_REJECT = ZEUS_STRINGS["employee"]["approval"]["reject_btn"]
    @BTN_QUICK_INVITATION = ZEUS_STRINGS["add_user"]["invitation"]["title_1"]
    @BTN_INVITE = ZEUS_STRINGS["add_user"]["invitation"]["inv_btn"]
    @BTN_REACTIVEATE = ZEUS_STRINGS["employee"]["archived"]["react_btn"]
    @BTN_DELETE = ZEUS_STRINGS["employee"]["archived"]["del_btn"]

    @TXF_ENTER_EMAIL_ADDRESS = @BROWSER.textarea(:class, 'form-control')
    @TXF_SEARCH = @BROWSER.text_field(:id, 'search-box')

    @IMG_SPINNER = @BROWSER.div(:class, %w(spinner ng-scope))
  end

  def is_visible (page)
    @BROWSER.h2(:text, /#{ZEUS_STRINGS["post_login"]["colleagues"]}/).wait_until_present
    @BTN_MANAGE_COLLEAGUES.wait_until_present
    @TAB_ACTIVE_COLLEAGUES.wait_until_present
    @TAB_AWITING_APPROVAL.wait_until_present
    @TAB_PENDING.wait_until_present
    @TAB_ARCHIVED.wait_until_present
    
    case page
    when 'Active colleagues'
      @TXF_SEARCH.wait_until_present
      @TXF_SEARCH.clear
      sleep(0.5)
      @BROWSER.div(:class => 'col-sm-2').input(:id,'search-box').wait_until_present
    when 'Awaiting approval'
      @BROWSER.li(:class => 'ng-isolate-scope', :index => 1).span(:index, 1).wait_until_present
      
      if @BROWSER.li(:class => 'ng-isolate-scope', :index => 1).span(:index, 1).text.to_i != 0
        @BROWSER.div(:class, %w(employee-directory-header ng-scope)).p(:text, /#{ZEUS_STRINGS["employee"]["approval"]["label_2"][0..10]}/).wait_until_present
        @BROWSER.div(:class, %w(employee-directory-header ng-scope)).div(:class, %w(btn btn-primary)).wait_until_present
        @BROWSER.div(:class, %w(employee-directory-header ng-scope)).div(:class, %w(btn btn-primary btn-ghost)).wait_until_present
        @BROWSER.div(:class, %w(employee-list ng-scope)).wait_until_present
      else
        @BROWSER.h2(:text, ZEUS_STRINGS["employee"]["approval"]["label_1"]).wait_until_present
      end
    when 'Pending'
      @BROWSER.li(:class => 'ng-isolate-scope', :index => 2).span(:index, 1).wait_until_present
      
      if @BROWSER.li(:class => 'ng-isolate-scope', :index => 2).span(:index, 1).text.to_i != 0
        @BROWSER.div(:class, %w(employee-directory-header ng-scope)).p(:text, ZEUS_STRINGS["employee"]["pending"]["label_2"]).wait_until_present
        @BROWSER.div(:class, %w(employee-directory-header ng-scope)).div(:class, %w(btn btn-primary)).wait_until_present
        @BROWSER.div(:class, %w(employee-directory-header ng-scope)).div(:class, %w(btn btn-primary btn-ghost)).wait_until_present
        @BROWSER.div(:class, %w(employee-list ng-scope)).wait_until_present
      else 
        @BROWSER.h2(:text, ZEUS_STRINGS["employee"]["pending"]["label_1"]).wait_until_present
      end
    when 'Archived'
      @BROWSER.span(:class => %w(badge pull-right ng-binding), :index => 3).wait_until_present
      no_of_Archived = @BROWSER.span(:class => %w(badge pull-right ng-binding), :index => 3).text.to_i
      puts "no_of_Archived users is #{no_of_Archived}"
      
      if @BROWSER.span(:class => %w(badge pull-right ng-binding), :index => 3).text.to_i != 0
        @BROWSER.div(:class, %w(employee-directory-header ng-scope)).p(:text, ZEUS_STRINGS["employee"]["archived"]["label_2"]).wait_until_present
        @BROWSER.div(:class, %w(employee-directory-header ng-scope)).div(:class, %w(btn btn-primary)).wait_until_present
        @BROWSER.div(:class, %w(employee-directory-header ng-scope)).div(:class, %w(btn btn-primary btn-ghost)).wait_until_present
        @BROWSER.div(:class, %w(employee-list ng-scope)).wait_until_present
      else
        @BROWSER.h2(:text, ZEUS_STRINGS["employee"]["archived"]["label_1"]).wait_until_present
      end
    end
  end
  
  def click_button (page)
    case page
    when 'Approve all'
      @BROWSER.div(:class => %w(btn btn-primary), :text => 'Approve all').wait_until_present
      @BROWSER.div(:class => %w(btn btn-primary), :text => 'Approve all').click
      @BROWSER.button(:class => %w(btn btn-primary), :text => 'Approve All').wait_until_present
    when 'Approve All'
      @BROWSER.button(:class => %w(btn btn-primary), :text => 'Approve All').wait_until_present
      @BROWSER.button(:class => %w(btn btn-primary), :text => 'Approve All').click
      @BROWSER.button(:class => %w(btn btn-primary), :text => 'Approve All').wait_while_present
    when 'Delete All'
      @BROWSER.div(:class => %w(btn btn-primary btn-ghost), :text => 'Delete All').wait_until_present
      @BROWSER.div(:class => %w(btn btn-primary btn-ghost), :text => 'Delete All').click
      @BROWSER.div(:class => %w(btn btn-primary btn-ghost), :text => 'Delete All').wait_until_present
    when 'Delete All Blue'
      @BROWSER.button(:class => %w(btn btn-primary), :text => 'Delete All').wait_until_present
      @BROWSER.button(:class => %w(btn btn-primary), :text => 'Delete All').click
      @BROWSER.button(:class => %w(btn btn-primary), :text => 'Delete All').wait_while_present
    when 'Active colleagues'
      @TAB_ACTIVE_COLLEAGUES.wait_until_present
      @TAB_ACTIVE_COLLEAGUES.fire_event('click')
      @BROWSER.div(:class, %w(spinner full-screen)).wait_while_present
      sleep(2)
      is_visible('Active colleagues')
    when 'Awaiting approval'
      @TAB_AWITING_APPROVAL.wait_until_present
      @TAB_AWITING_APPROVAL.click
      @BROWSER.div(:class, %w(spinner full-screen)).wait_while_present
      sleep(2)
      is_visible('Awaiting approval')
    when 'Pending'
      @TAB_PENDING.wait_until_present
      @TAB_PENDING.click
      @BROWSER.div(:class, %w(spinner full-screen)).wait_while_present
      sleep(2)
      is_visible('Pending')
    when 'Archived'
      @TAB_ARCHIVED.wait_until_present
      @TAB_ARCHIVED.fire_event('click')
      @BROWSER.div(:class, %w(spinner full-screen)).wait_while_present
      sleep(2)
      is_visible('Archived')
    when 'Approve'
      @BROWSER.div(:class, 'modal-dialog').button(:class => %w(btn btn-primary), :text => @BTN_APPROVE).wait_until_present
      @BROWSER.div(:class, 'modal-dialog').button(:class => %w(btn btn-primary), :text => @BTN_APPROVE).click
      @BROWSER.button(:class => %w(btn btn-primary), :text => @BTN_APPROVE).wait_while_present
    when 'Reject'
      @BROWSER.div(:class, 'modal-dialog').button(:class => %w(btn btn-primary), :text => @BTN_REJECT).wait_until_present
      @BROWSER.div(:class, 'modal-dialog').button(:class => %w(btn btn-primary), :text => @BTN_REJECT).click
      @BROWSER.button(:class => %w(btn btn-primary), :text => @BTN_REJECT).wait_while_present 
    when 'Manage Colleagues'
      @BTN_MANAGE_COLLEAGUES.wait_until_present
      @BTN_MANAGE_COLLEAGUES.click
      @BTN_MANAGE_COLLEAGUES.wait_while_present
    when 'Back'
      @BROWSER.div(:class, %w(btn btn-inverse)).wait_until_present
      @BROWSER.div(:class, %w(btn btn-inverse)).click
      @BROWSER.div(:class, %w(btn btn-inverse)).wait_while_present
    else
      fail(msg = "Error. click_button. The option #{button} is not defined in menu.")
    end
  end
  
  # Validate the date in all the tabs
  def validate_all_data_in_all_tabs
    click_button('Active colleagues')
    validate_data_in_tab('Active colleagues')
    
    click_button('Awaiting approval')
    validate_data_in_tab('Awaiting approval')

    click_button('Pending')
    validate_data_in_tab('Pending')

    click_button('Archived')
    validate_data_in_tab('Archived')
  end
  
  # Validate the date in the give tab
  # Param tab_name
  def validate_data_in_tab (tab_name)
    puts "#{tab_name}"

    case tab_name
    when 'Active colleagues'
      current_number_in_tab = @BROWSER.li(:class => 'ng-isolate-scope', :index => 0).span(:index, 1).text.to_i
      
      if current_number_in_tab > 0
          current_number_in_tab = current_number_in_tab + 1 
      end    
    when 'Awaiting approval'
      current_number_in_tab = @BROWSER.li(:class => 'ng-isolate-scope', :index => 1).span(:index, 1).text.to_i
    when 'Pending'
      current_number_in_tab = @BROWSER.li(:class => 'ng-isolate-scope', :index => 2).span(:index, 1).text.to_i
       puts "current_number_in_tab:#{current_number_in_tab}"
    when 'Archived'
      current_number_in_tab = @BROWSER.li(:class => 'ng-isolate-scope', :index => 3).span(:index, 1).text.to_i
    end

    if (current_number_in_tab < 0)
      fail(msg = "Error. validate_data_in_tab. The current number in #{tab_name} is:#{number_of_items_in_list} and it can be negative")
    end

    sleep(1)

    while @BROWSER.divs(:class, 'employee-list-item').count != current_number_in_tab
      employee_count = @BROWSER.divs(:class, 'employee-list-item').count
      @BROWSER.scroll.to :bottom
      @BROWSER.div(:class, %w(spinner full-screen ng-animate ng-hide-animate ng-hide-add ng-hide ng-hide-add-active)).wait_while_present
      sleep(1)
      
      if @BROWSER.divs(:class, 'employee-list-item').count <= employee_count
        @BROWSER.scroll.to :top
        sleep(1)
        @BROWSER.scroll.to :bottom
        @BROWSER.div(:class, %w(spinner full-screen ng-animate ng-hide-animate ng-hide-add ng-hide ng-hide-add-active)).wait_while_present
      end

      Watir::Wait.until { @BROWSER.divs(:class, 'employee-list-item').count > employee_count }
    end

  end
  
  def go_to (tab_name)
    click_button('Colleagues')
    click_button("#{tab_name}")
    is_visible("#{tab_name}")
  end

  def perform_action (action)
    click_button(action)
  end

  # Search for employee 
  # @param employee_name
  def search_for (employee_name)
    @TXF_SEARCH.to_subtype.clear
    is_visible('Active colleagues')

    @TXF_SEARCH.set employee_name
    sleep(2)
  end

  # Check that the search results are valid
  # @param search - string to match with
  # @param with_results - 'No results' or 'Results'
  def check_search_results (search, with_results)
    if with_results == 'True'
      i = 0
      
      while @BROWSER.div(:class, %w(employee-list ng-scope)).div(:class => %w(employee-list-item ng-scope), :index => i).exists?
        employee_name = @BROWSER.div(:class, %w(employee-list ng-scope)).div(:class => %w(employee-list-item ng-scope), :index => i).div(:class, 'name').text
        employee_job_title = @BROWSER.div(:class, %w(employee-list ng-scope)).div(:class => %w(employee-list-item ng-scope), :index => i).p(:class, %w(small ng-binding)).text

        puts "#{employee_name}"
        puts "#{employee_job_title}"

        if /#{search}/i.match(employee_name) == nil 
          if /#{search}/i.match(employee_job_title) == nil
            fail(msg = "Error. check_search_results. Unexpected result: #{employee_name}")
          end
        end

        @BROWSER.execute_script("window.scrollBy(0,2000)")
        sleep(0.5)
        
        i += 150

        if i == 20
          fail (msg = 'Error. check_search_results. Prevent infinite loop')
        end 
      end
    elsif with_results == 'False'
      @BROWSER.div(:class => 'no-search-result', :text => ZEUS_STRINGS["add_admin"]["active_search"]["error"]).wait_until_present
    end
    
    while @TXF_SEARCH.value.length > 0 
      @TXF_SEARCH.send_keys :backspace
      sleep(0.2)
    end
  end

  def approve_or_reject (action)
    click_button('Awaiting approval')
    @BROWSER.div(:class => %w(employee-list-item ng-scope), :index => 0).wait_until_present

    counter = @file_service.get_from_file("invite_email_counter:")[0..-2]
    user_email_address = "#{ACCOUNT[:"#{$account_index}"][:valid_account][:email_subdomain]}" + '+' + "#{ACCOUNT[:"#{$account_index}"][:valid_account][:country_code]}" + "#{counter}" + '@' + "#{ACCOUNT[:"#{$account_index}"][:valid_account][:"#{$email_domain}"]}"
    number_in_tab = @BROWSER.li(:class => 'ng-isolate-scope', :index => 1).span(:index, 1).text.to_i

    for i in 0..number_in_tab - 1
      i % 5 == 0 ? (@BROWSER.scroll.to :bottom) : nil

      if @BROWSER.div(:class => %w(employee-list-item ng-scope), :index => i).div(:class => %w(ellipsis ng-binding), :text => user_email_address).present?
        user_name = @BROWSER.a(:class => %w(small ellipsis ng-binding), :index => i).text
        break
      elsif i == number_in_tab - 1
        fail(msg = "Error. approve_or_reject. Email Address: #{user_email_address} and User Name: #{user_name}. Cannot be found in the Awaiting Approval list")
      end

      i += 1
      i % 5 == 0 ? (@BROWSER.scroll.to :bottom) : nil
    end

    if action == 'Approve'
      @BROWSER.span(:class => 'ng-scope', :text => ZEUS_STRINGS["employee"]["modal"]["approve"]["approve_btn"], :index => i).wait_until_present
      @BROWSER.span(:class => 'ng-scope', :text => ZEUS_STRINGS["employee"]["modal"]["approve"]["approve_btn"], :index => i).click
      @BROWSER.div(:class, 'modal-title').wait_until_present
      click_button('Approve')
    elsif action == 'Reject'
      @BROWSER.span(:class => 'ng-scope', :text => ZEUS_STRINGS["employee"]["modal"]["reject"]["reject_btn"], :index => i).wait_until_present
      @BROWSER.span(:class => 'ng-scope', :text => ZEUS_STRINGS["employee"]["modal"]["reject"]["reject_btn"], :index => i).click
      @BROWSER.div(:class, 'modal-title').wait_until_present
      click_button('Reject')
    end

    # check that the number was decrease by one
    @BROWSER.li(:class => 'ng-isolate-scope', :index => 1).span(:text, "#{number_in_tab - 1}").wait_until_present

    #check that it was removed from the list
    Watir::Wait.until { !@BROWSER.div(:class, %w(employee-list ng-scope ng-isolate-scope)).text.include? user_email_address }

    return user_name
  end

  # Remond or Delete user for Pending list
  # @param action - 'Restore' or 'Delete'
  def remind_or_delete (action)
    click_button('Pending')
    @BROWSER.div(:class => %w(employee-list-item ng-scope), :index => 0).wait_until_present
    
    counter = @file_service.get_from_file("invite_email_counter:")[0..-2]
    user_email_address = "#{ACCOUNT[:"#{$account_index}"][:valid_account][:email_subdomain]}" + '+' + "#{ACCOUNT[:"#{$account_index}"][:valid_account][:country_code]}" + "#{counter}" + '@' + "#{ACCOUNT[:"#{$account_index}"][:valid_account][:email_domain]}"
    number_in_tab = @BROWSER.li(:class => 'ng-isolate-scope', :index => 2).span(:index, 1).text.to_i

    for i in 0..number_in_tab - 1
      i % 5 == 0 ? (@BROWSER.scroll.to :bottom) : nil

      if @BROWSER.div(:class => %w(employee-list-item ng-scope), :index => i).div(:class => %w(ellipsis ng-binding), :text => user_email_address).present?
        break
      elsif i == number_in_tab - 1
        fail(msg = "Error. remind_or_delete. Email Address: #{user_email_address}. Cannot be found in the Awaiting Approval list")
      end

      i += 1
      i % 5 == 0 ? (@BROWSER.scroll.to :bottom) : nil
    end
    
    if action == 'Remind'
      @BROWSER.span(:class => 'ng-scope', :text => ZEUS_STRINGS["employee"]["modal"]["remind"]["remind_btn"], :index => i).wait_until_present
      @BROWSER.span(:class => 'ng-scope', :text => ZEUS_STRINGS["employee"]["modal"]["remind"]["remind_btn"], :index => i).click
      @BROWSER.div(:class, 'modal-dialog').div(:class => 'modal-title', :text => "#{ZEUS_STRINGS["employee"]["modal"]["remind"]["title"].gsub('%{email}', "#{user_email_address}")}").wait_until_present

      @BROWSER.div(:class, 'modal-dialog').button(:class, %w(btn btn-primary)).wait_until_present
      @BROWSER.div(:class, 'modal-dialog').button(:class, %w(btn btn-primary)).click
      @BROWSER.div(:class, 'modal-dialog').wait_while_present
    else
      @BROWSER.span(:class => 'ng-scope', :text => ZEUS_STRINGS["employee"]["modal"]["delete"]["del_btn"], :index => i).wait_until_present
      @BROWSER.span(:class => 'ng-scope', :text => ZEUS_STRINGS["employee"]["modal"]["delete"]["del_btn"], :index => i).click
      @BROWSER.div(:class, 'modal-dialog').div(:class => 'modal-title', :text => "#{ZEUS_STRINGS["employee"]["modal"]["delete"]["title"].gsub('%{email}', "#{user_email_address}")}").wait_until_present

      @BROWSER.button(:class, %w(btn btn-primary)).wait_until_present
      @BROWSER.button(:class, %w(btn btn-primary)).fire_event('click')
      @BROWSER.div(:class, 'modal-dialog').wait_while_present
      
      # check that the number was decreased by one
      @BROWSER.li(:class => 'ng-isolate-scope', :index => 2).span(:text, "#{number_in_tab .to_i - 1}").wait_until_present

      #check that it was removed from the list
      Watir::Wait.until { !@BROWSER.div(:class, %w(employee-list ng-scope ng-isolate-scope)).text.include? user_email_address }
    end  
  end

  # Restore or Delete user from Archived list accourding the fivwn value
  # @param action - 'Restore' or 'Delete'
  def restore_or_delete (action)
    click_button('Archived')
    @BROWSER.div(:class => %w(employee-list-item ng-scope), :index => 0).wait_until_present

    number_in_tab = @BROWSER.span(:class => %w(badge pull-right ng-binding),:index => 3).text.to_i
    counter = @file_service.get_from_file("invite_email_counter:")[0..-2]
    user_name = "user#{counter} user#{counter}"
    company_name = ACCOUNT[:"#{$account_index}"][:valid_account][:company_nick_name]
    
    for i in 0..number_in_tab - 1
      i % 5 == 0 ? (@BROWSER.scroll.to :bottom) : nil

      if @BROWSER.div(:class => %w(employee-list-item ng-scope), :index => i).a(:class => %w(small ellipsis ng-binding), :text => user_name).present?
        break
      elsif i == number_in_tab - 1
        fail(msg = "Error. restore_or_delete. User Name: #{user_name}. Cannot be found in the Archived list")
      end

      i += 1
      i % 5 == 0 ? (@BROWSER.scroll.to :bottom) : nil
    end

    if action == 'Restore'
      @BROWSER.span(:class => 'ng-scope', :text => ZEUS_STRINGS["employee"]["modal"]["arch_rest"]["react_btn"], :index => i).wait_until_present
      @BROWSER.span(:class => 'ng-scope', :text => ZEUS_STRINGS["employee"]["modal"]["arch_rest"]["react_btn"], :index => i).click

      @BROWSER.div(:class, 'modal-dialog').div(:class => 'modal-title', :text => "#{ZEUS_STRINGS["employee"]["modal"]["arch_rest"]["title"].gsub('%{firstName} %{lastName}', "#{user_name}")}").wait_until_present
      @BROWSER.div(:class, 'modal-dialog').span(:class => 'ng-scope', :text => "#{ZEUS_STRINGS["employee"]["modal"]["arch_rest"]["label_1"].gsub('%{firstName} %{lastName}', "#{user_name}")}").wait_until_present
      
      @BROWSER.button(:class => %w(btn btn-primary), :text => @BTN_REACTIVEATE).wait_until_present
      @BROWSER.button(:class => %w(btn btn-primary), :text => @BTN_REACTIVEATE).click
      @BROWSER.div(:class, 'modal-dialog').wait_while_present
      
      click_button('Active colleagues') 
      search_for(user_name)
      check_search_results(user_name, 'True')
      click_button('Archived')
    else
      @BROWSER.span(:class => 'ng-scope', :text => ZEUS_STRINGS["employee"]["modal"]["arch_del"]["del_btn"], :index => i).wait_until_present
      @BROWSER.span(:class => 'ng-scope', :text => ZEUS_STRINGS["employee"]["modal"]["arch_del"]["del_btn"], :index => i).click

      @BROWSER.div(:class, 'modal-dialog').div(:class => 'modal-title', :text => "#{ZEUS_STRINGS["employee"]["modal"]["arch_del"]["title"].gsub('%{firstName} %{lastName}', "#{user_name}")}").wait_until_present
      @BROWSER.div(:class, 'modal-dialog').span(:class => 'ng-scope', :text => "#{ZEUS_STRINGS["employee"]["modal"]["arch_del"]["label_1"].gsub('%{firstName} %{lastName}', "#{user_name}").gsub('%{company}', "#{company_name}")}").wait_until_present

      @BROWSER.button(:class => %w(btn btn-primary), :text => @BTN_DELETE).wait_until_present
      @BROWSER.button(:class => %w(btn btn-primary), :text => @BTN_DELETE).click
      @BROWSER.div(:class, 'modal-dialog').wait_while_present
    end

    # check that the number was decrease by one
    @BROWSER.li(:class => 'ng-isolate-scope', :index => 3).span(:text, "#{number_in_tab - 1}").wait_until_present
    
    #check that the user was removed from the list
    Watir::Wait.until { !@BROWSER.div(:class, %w(employee-list ng-scope ng-isolate-scope)).text.include? user_name }
  end

  # For each employee in the employee list, click on the employee name and 
  # make sure that goes to the correct profile
  def check_links_to_colleagues
    is_visible('Active colleagues')

    @BROWSER.div(:class, %w(employee-list ng-scope)).wait_until_present        
    i = 0
    
    while @BROWSER.div(:class, %w(employee-list ng-scope)).div(:class => %w(employee-list-item ng-scope), :index => i).exists?
      employee_name = @BROWSER.div(:class, %w(employee-list ng-scope)).div(:class => %w(employee-list-item ng-scope), :index => i).div(:class, 'name').text
      puts "#{employee_name}"
      open_profile(employee_name, i)
      @BROWSER.back
      @BROWSER.div(:class, %w(employee-list-item ng-scope)).wait_until_present 

      @BROWSER.send_keys :space
      sleep(0.5)
      
      i += 1
      if i == 20
        fail (msg = 'Error. check_links_to_colleagues. Prevent infinite loop')
      end 
    end  
  end

  # Open user profile from employee list
  # @param employee_name - employee profile name
  # @param index - open index
  def open_profile (employee_name, index)
    puts "employee_name:#{employee_name}"
    i = 0
    if employee_name != nil && index == nil 
      @TXF_SEARCH.set employee_name
      sleep(2)
      @BROWSER.a(:class, %w(small ellipsis)).wait_until_present
      if @BROWSER.a(:class => %w(small ellipsis), :text => /#{employee_name}/).exists?
        @BROWSER.a(:class => %w(small ellipsis), :text => /#{employee_name}/).click
        @BROWSER.h2.wait_until_present
      else
        fail(msg = "Error. open_profile. Colleague '#{employee_name}' was not found")
      end   
    elsif employee_name == nil && index != nil
      @BROWSER.div(:class => 'name', :index => index).parent.parent.parent.image.click
      @BROWSER.h2.wait_until_present
    else
      @BROWSER.div(:class => 'name', :text => "#{employee_name}").parent.parent.parent.image.click
      @BROWSER.div(:class, 'user-profile-view').h2(:class => %w(name ng-binding), :text => "#{employee_name}").wait_until_present
    end
  end

    # Set colleague managment snapshot
  def set_colleague_managment_snapshot
    $colleague_managment_snapshot = Array.new(4)
    for i in 0..$colleague_managment_snapshot.size - 1
      $colleague_managment_snapshot[i] = @BROWSER.span(:class => %w(badge pull-right ng-binding), :index => i).text
    end
  end

  # Approve all user in Pending list
  def approve_all_pending
    click_button('Approve all')
    click_button('Approve All')
  end

  # Delete all users in Pending list
  def delete_all_pending
    click_button('Delete All')
    click_button('Delete All Blue')
  end

  # Check is the given user email is in list of not fail
  # @param user_email
  def check_user_is_in_pending_list (user_email)
    click_button('Pending')

    if ! @BROWSER.div(:text, "#{user_email}").present?
      fail(mag = 'Error. check_user_is_in_pending_list. User is not in Pending list')
    end
  end

  # Check if the given user's email is in the list, if not, fail
  # @param user_email
  def check_csv_uploaded_user_is_in_pending_list (number_of_users_to_check, email_or_id)
    @BROWSER.div(:class, %w(employee-list ng-scope ng-isolate-scope)).wait_until_present

    for i in 1..number_of_users_to_check.to_i
      if email_or_id == 'email'
        user_to_find = "#{USER_SIGNUP_INVITE_EMAIL[:local_part]}+csv#{i}@#{USER_SIGNUP_INVITE_EMAIL[:subdomain]}"
      else
        user_to_find = "user#{i} csv user#{i} csv (#{i})"
      end

      if ! @BROWSER.div(:text, "#{user_to_find}").present?
        fail(mag = 'Error. check_csv_uploaded_user_is_in_pending_list. User is not in Pending list')
      end

    end
  end

  # Go over colleagues list and accourding to click on the "action" button
  # @param action - 'Approve', 'Reject', 'Remind', 'Delete, Reactivate'
  def go_over_colleagues_list_and_do(action)
    @path = File.join(File.dirname(__FILE__),'/', 'list.rb')
    @aFile = File.new("#{@path}", "r")

    i = 0
    total_of_delete = 0
    while @BROWSER.div(:class => %w(employee-list-item ng-scope), :index => i).exists?
      current_email = @BROWSER.div(:class => %w(employee-list-item ng-scope), :index => i).div(:class, %w(employee-field small ng-binding)).text
      puts "Current_email:#{current_email}"
      File.readlines(@aFile).each do |line_text|
        if line_text.include? current_email
          total_of_delete += 1
          puts "Current email in the colleagues list to #{action}:#{current_email}"
          if action == 'Reject' ||  action == 'Delete'
            @BROWSER.div(:class => %w(employee-list-item ng-scope), :index => i).div(:class, %w(btn btn-primary btn-ghost)).click
          else
            @BROWSER.div(:class => %w(employee-list-item ng-scope), :index => i).div(:class, %w(btn btn-primary)).click
          end
          
          @BROWSER.div(:class, 'modal-dialog').div(:class => 'modal-title', :text => /current_email/).wait_until_present
          @BROWSER.button(:class, %w(btn btn-primary)).wait_until_present
          @BROWSER.button(:class, %w(btn btn-primary)).click
          @BROWSER.div(:class, 'modal-dialog').wait_while_present
          sleep(0.5)            
        end
      end
      
      i += 1

      if i % 5 == 0 && i != 0
        @BROWSER.scroll.to :bottom
        sleep(0.5)
      end
    end
  end

end
