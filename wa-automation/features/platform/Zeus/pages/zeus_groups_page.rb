# -*- encoding : utf-8 -*-
class ZeusGroupsPage

  def initialize (browser)
    @file_service = FileService.new
    @BROWSER = browser
    @BTN_ARCHIVED_GROUPS = @BROWSER.a(:text, ZEUS_STRINGS["groups"]["list"]["archive_groups"])
    @BTN_CREATE_NEW_GROUPS = @BROWSER.a(:text, ZEUS_STRINGS["groups"]["list"]["create_new_group"])
    @BTN_CREATE_GROUP = @BROWSER.a(:text, ZEUS_STRINGS["groups"]["create_group_modal"]["create_group"])
    @BTN_ARCHIVE_AND_REASSIGN = @BROWSER.a(:text, ZEUS_STRINGS["group"]["archive_modal"]["submit"])
    @BTN_ASSIGN_EMPLOYEES = @BROWSER.a(:text, ZEUS_STRINGS["group"]["archive_modal"]["assign"]["ok"])
    @BTN_EDIT_GROUP = @BROWSER.button(:text, ZEUS_STRINGS["group"]["edit_group"])
    @BTN_ARCHIVE_GROUP = @BROWSER.button(:text, ZEUS_STRINGS["group"]["archive_group"])
    @BTN_EDIT_DETAILS = @BROWSER.button(:text, ZEUS_STRINGS["group"]["edit_details"])
    @BTN_SAVE_CHANGES = @BROWSER.a(:text, ZEUS_STRINGS["group"]["edit_mode"]["save_changes"])
    @BTN_GOT_IT = @BROWSER.button(:text, ZEUS_STRINGS["group"]["banner"]["button"])
    @BTN_DELETE_GROUP = @BROWSER.button(:text, ZEUS_STRINGS["group"]["archived"]["delete_group"])
    @BTN_PERMENTLY_DELETE = @BROWSER.button(:text, ZEUS_STRINGS["group"]["archived"]["delete_modal"]["submit"])
  end

  def is_visible
    @BROWSER.h2(:text, ZEUS_STRINGS["groups"]["list"]["groups"]).wait_until_present
    @BTN_ARCHIVED_GROUPS.wait_until_present
    @BTN_CREATE_NEW_GROUPS.wait_until_present
    @BROWSER.div(:class, 'pointer').div(:text, /#{ACCOUNT[:account_1][:valid_account][:group_name_base]}/).wait_until_present
  end

  def click_button (button)
    case button
    when 'Archived groups'
      @BTN_ARCHIVED_GROUPS.wait_until_present
      @BTN_ARCHIVED_GROUPS.click
      @BTN_ARCHIVED_GROUPS.wait_while_present
    when 'Permanently delete'
      @BTN_PERMENTLY_DELETE.wait_until_present
      @BTN_PERMENTLY_DELETE.click
      @BTN_PERMENTLY_DELETE.wait_while_present
    when 'Delete Group'
      @BTN_DELETE_GROUP.wait_until_present
      @BTN_DELETE_GROUP.click
    when 'Save changes'
      @BTN_SAVE_CHANGES.wait_until_present
      @BTN_SAVE_CHANGES.click
      @BTN_SAVE_CHANGES.wait_while
    when 'Archive group'
      @BTN_EDIT_GROUP.wait_until_present
      @BTN_EDIT_GROUP.click
      @BTN_ARCHIVE_GROUP.wait_until_present
      @BTN_ARCHIVE_GROUP.fire_event('click')
      @BROWSER.div(:class, 'panel').wait_until_present
    when 'Edit details'
      @BTN_EDIT_GROUP.wait_until_present
      @BTN_EDIT_GROUP.click
      @BTN_EDIT_DETAILS.wait_until_present
      @BTN_EDIT_DETAILS.click
      @BTN_SAVE_CHANGES.wait_until_present
    when 'Assign employees'
      @BTN_ASSIGN_EMPLOYEES.wait_until_present
      @BTN_ASSIGN_EMPLOYEES.click
      @BTN_ASSIGN_EMPLOYEES.wait_while_present
    when 'Archive and reassign'
      @BTN_ARCHIVE_AND_REASSIGN.wait_until_present
      @BTN_ARCHIVE_AND_REASSIGN.click
      @BTN_ARCHIVE_AND_REASSIGN.wait_while_present
    when 'Create new group'
      @BTN_CREATE_NEW_GROUPS.wait_until_present
      @BTN_CREATE_NEW_GROUPS.click
      @BROWSER
      @BTN_CREATE_NEW_GROUPS.wait_until_present
    when 'Create Group'
      @BTN_CREATE_GROUP.wait_until_present
      @BTN_CREATE_GROUP.click
      @BTN_CREATE_GROUP.wait_while_present
      @BROWSER.div(:text, ZEUS_STRINGS["groups"]["toaster"]["new_group_created"].sub("\"%{group}\"", "\"" + @new_group_name + "\"")).wait_until_present
    else
      fail(msg = "Error. click_button. Button '#{button}' is not define")
    end
  end

  # Create new group
  def create_new_group    
    @BROWSER.div(:class => %w(subhead-1 text-semibold), :text => /#{ACCOUNT[:account_1][:valid_account][:group_name_base]} \(#{ZEUS_STRINGS["groups"]["list"]["default_group"]}\)/).wait_until_present
    $NUMBER_OF_EMPLOYEES_IN_THE_COMPANY_GROUP = ((@BROWSER.div(:class => %w(subhead-1 text-semibold), :text => /#{ACCOUNT[:account_1][:valid_account][:group_name_base]} \(#{ZEUS_STRINGS["groups"]["list"]["default_group"]}\)/).parent.div(:class, %w(caption-2 text-lighter)).text).match /\d+/)[0].to_i
    puts "$NUMBER_OF_EMPLOYEES_IN_THE_COMPANY_GROUP:#{$NUMBER_OF_EMPLOYEES_IN_THE_COMPANY_GROUP}"
    
    click_button('Create new group')

    if @BTN_GOT_IT.present?
      @BTN_GOT_IT.click
      @BTN_GOT_IT.wait_while_present
    end

    @BROWSER.div(:text, ZEUS_STRINGS["groups"]["create_group_modal"]["group_name"]).wait_until_present
    @BROWSER.div(:text, /#{ZEUS_STRINGS["groups"]["create_group_modal"]["add_employee"]}/).wait_until_present

    @BROWSER.input(:placeholder, ZEUS_STRINGS["groups"]["create_group_modal"]["group_placeholder"]).wait_until_present
    @BROWSER.input(:placeholder, ZEUS_STRINGS["groups"]["user_chooser"]["enter_employee"]).wait_until_present
    
    @file_service.insert_to_file('group_counter:', "#{rand(36**6).to_s(36)}")
    group_counter = @file_service.get_from_file('group_counter:')[0..-2]
    @new_group_name = "#{ACCOUNT[:account_1][:valid_account][:group_name_base]}" + "#{group_counter}"
    @file_service.insert_to_file('latest_group_name:', @new_group_name)
    puts "New group name: #{@new_group_name}"

    @BROWSER.input(:placeholder, ZEUS_STRINGS["groups"]["create_group_modal"]["group_placeholder"]).send_keys @new_group_name

    @BROWSER.input(:placeholder, ZEUS_STRINGS["groups"]["user_chooser"]["enter_employee"]).fire_event('focus')
    sleep(0.5)
    @BROWSER.input(:placeholder, ZEUS_STRINGS["groups"]["user_chooser"]["enter_employee"]).send_keys ACCOUNT[:account_1][:valid_account][:user_name]
    @BROWSER.label.div(:text, ACCOUNT[:account_1][:valid_account][:user_name]).wait_until_present
    @BROWSER.label.div(:text, ACCOUNT[:account_1][:valid_account][:user_name]).click
    sleep(0.5)

    click_button('Create Group')

    @BROWSER.div(:class => %w(subhead-1 text-semibold), :text => /#{ACCOUNT[:account_1][:valid_account][:group_name_base]} \(#{ZEUS_STRINGS["groups"]["list"]["default_group"]}\)/).wait_until_present
    
    Watir::Wait.until(nil, "Error. create_new_group. Number of employees expected in company group = #{$NUMBER_OF_EMPLOYEES_IN_THE_COMPANY_GROUP - 1}, however found #{@BROWSER.div(:class => %w(subhead-1 text-semibold), :text => /#{ACCOUNT[:account_1][:valid_account][:group_name_base]}/).parent.div(:class, %w(caption-2 text-lighter)).text.to_i}") { 
      @BROWSER.div(:class => %w(subhead-1 text-semibold), :text => /#{ACCOUNT[:account_1][:valid_account][:group_name_base]}/).parent.div(:class, %w(caption-2 text-lighter)).text.to_i == $NUMBER_OF_EMPLOYEES_IN_THE_COMPANY_GROUP - 1 
    }

    $NUMBER_OF_EMPLOYEES_IN_THE_COMPANY_GROUP = $NUMBER_OF_EMPLOYEES_IN_THE_COMPANY_GROUP - 1

    puts "$NUMBER_OF_EMPLOYEES_IN_THE_COMPANY_GROUP:#{$NUMBER_OF_EMPLOYEES_IN_THE_COMPANY_GROUP}"
  end

  # Edit/Archive/Delete group
  # @param action - Edit/Archive/Delete
  def edit_archive_delete_group (action)
    latest_group_name = @file_service.get_from_file('latest_group_name:')[0..-2]
    new_group_name = @file_service.get_from_file('latest_group_name:')[0..-2]

    @BROWSER.div(:class => %w(subhead-1 text-semibold), :text => /#{ACCOUNT[:account_1][:valid_account][:group_name_base]} \(#{ZEUS_STRINGS["groups"]["list"]["default_group"]}\)/).wait_until_present
    $NUMBER_OF_EMPLOYEES_IN_THE_COMPANY_GROUP = ((@BROWSER.div(:class => %w(subhead-1 text-semibold), :text => /#{ACCOUNT[:account_1][:valid_account][:group_name_base]} \(#{ZEUS_STRINGS["groups"]["list"]["default_group"]}\)/).parent.div(:class, %w(caption-2 text-lighter)).text).match /\d+/)[0].to_i
    puts "$NUMBER_OF_EMPLOYEES_IN_THE_COMPANY_GROUP:#{$NUMBER_OF_EMPLOYEES_IN_THE_COMPANY_GROUP}"

    if action != 'delete'
      @BROWSER.div(:class => %w(subhead-1 text-semibold), :text => latest_group_name).wait_until_present
      number_of_employees_in_the_latest_group = ((@BROWSER.div(:class => %w(subhead-1 text-semibold), :text => latest_group_name).parent.div(:class, %w(caption-2 text-lighter)).text).match /\d+/)[0].to_i
      puts "number_of_employees_in_the_latest_group:#{number_of_employees_in_the_latest_group}"

      @BROWSER.div(:class => %w(subhead-1 text-semibold), :text => latest_group_name).wait_until_present
      @BROWSER.div(:class => %w(subhead-1 text-semibold), :text => latest_group_name).click
      @BROWSER.h2(:text, latest_group_name).wait_until_present
    end

    if action == 'archive'
      click_button('Archive group')

      part_1 = ZEUS_STRINGS["group"]["archive_modal"]["explanation_part1"]
      part_2 = ZEUS_STRINGS["group"]["archive_modal"]["explanation_part2"]

      archive_message = part_1 + latest_group_name + part_2
      @BROWSER.p(:text, /#{archive_message}/).wait_until_present

      click_button('Archive and reassign')
      @BROWSER.div(:text, ACCOUNT[:account_1][:valid_account][:group_name_base]).wait_until_present
      @BROWSER.div(:text, ACCOUNT[:account_1][:valid_account][:group_name_base]).click
      click_button('Assign employees')

      @BROWSER.header(:text, ZEUS_STRINGS["group"]["archive_modal"]["success"]["title"]).wait_until_present
      @BROWSER.button(:text, ZEUS_STRINGS["group"]["archive_modal"]["success"]["ok"]).wait_until_present
      @BROWSER.button(:text, ZEUS_STRINGS["group"]["archive_modal"]["success"]["ok"]).click

      @BROWSER.div(:class => %w(subhead-1 text-semibold), :text => /#{ACCOUNT[:account_1][:valid_account][:group_name_base]} \(#{ZEUS_STRINGS["groups"]["list"]["default_group"]}\)/).wait_until_present

      if @BROWSER.div(:class => %w(subhead-1 text-semibold), :text => /#{latest_group_name}/).exists?
        fail(msg = "Error. edit_archive_delete_group. The following group: #{latest_group_name} was not deleted")
      end
      
      number_of_employees_in_the_company_group_temp = ((@BROWSER.div(:class => %w(subhead-1 text-semibold), :text => /#{ACCOUNT[:account_1][:valid_account][:group_name_base]} \(#{ZEUS_STRINGS["groups"]["list"]["default_group"]}\)/).parent.div(:class, %w(caption-2 text-lighter)).text).match /\d+/)[0].to_i

      if ($NUMBER_OF_EMPLOYEES_IN_THE_COMPANY_GROUP + number_of_employees_in_the_latest_group != number_of_employees_in_the_company_group_temp)
        fail (msg = "Error. create_new_group. Number of employees expected in the company group is #{$NUMBER_OF_EMPLOYEES_IN_THE_COMPANY_GROUP + number_of_employees_in_the_latest_group} however found #{number_of_employees_in_the_company_group_temp}")
      end

      $NUMBER_OF_EMPLOYEES_IN_THE_COMPANY_GROUP = $NUMBER_OF_EMPLOYEES_IN_THE_COMPANY_GROUP + number_of_employees_in_the_latest_group
      puts "$NUMBER_OF_EMPLOYEES_IN_THE_COMPANY_GROUP:#{$NUMBER_OF_EMPLOYEES_IN_THE_COMPANY_GROUP}"

    elsif action == 'edit'
      click_button('Edit details')
      @BROWSER.h2.input.wait_until_present
      @BROWSER.h2.input.send_keys ' new name'
      updated_group_name = @BROWSER.h2.input.value
      click_button('Save changes')
      Watir::Wait.until(30) { @BROWSER.h2(:text, updated_group_name).exists? }
      @file_service.insert_to_file('latest_group_name:', @new_group_name)
    elsif action == 'delete'
      click_button('Archived groups')
      @BROWSER.div(:class, %w(subhead-1 text-semibold)).wait_until_present      

      # The 'while' block below will iterate through the list of archived groups until the group that we want to delete is found
      i = 0
      while @BROWSER.div(:class => %w(subhead-1 text-semibold), :index => i).present? && !(@BROWSER.div(:class => %w(subhead-1 text-semibold), :index => i).text.include? new_group_name)
        @BROWSER.send_keys :space
        sleep(0.5)
        i += 1
      end
  
      @BROWSER.div(:class => %w(subhead-1 text-semibold), :text => new_group_name).click
      click_button('Delete Group')
      click_button('Permanently delete')
    elsif action == 'reactive'
    end
  end
end