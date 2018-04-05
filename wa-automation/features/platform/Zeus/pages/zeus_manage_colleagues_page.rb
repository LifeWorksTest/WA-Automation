class ZeusManageColleaguesPage
  def initialize (browser)
    @BROWSER = browser
    @file_service = FileService.new

    @BTN_ADD_NEW_JOINERS = @BROWSER.div(:class, %w(btn btn-block btn-primary))
    @BTN_INVITE = @BROWSER.button(:class, %w(btn btn-primary pull-right))

    @TXF_EDIT_REMOVE_COLLEAGUES = @BROWSER.div(:class, %w(col-xs-8 col-xs-offset-2)).input
    @TXF_QUICK_INVITE = @BROWSER.textarea(:class, 'form-control')

    @LBL_ADD_NEW_JOINER = @BROWSER.div(:class => 'title-3', :text => ZEUS_STRINGS["manage_employees"]["add_card"]["title"])
    @LBL_MANAGE_COLLEAGUES = @BROWSER.h2(:text => ZEUS_STRINGS["manage_employees"]["section"])
	  @LBL_USER_SEARCH = @BROWSER.div(:class => 'headline-3', :text => ZEUS_STRINGS["user_search"]["title"])
    @LBL_QUICK_INVITATIONS = @BROWSER.div(:class => 'subhead-3', :text => ZEUS_STRINGS["add_user"]["invitation"]["title_1"])
  end

  def is_visible
  	@LBL_MANAGE_COLLEAGUES.wait_until_present
  	@LBL_USER_SEARCH.wait_until_present
    @TXF_EDIT_REMOVE_COLLEAGUES.wait_until_present

    # If user upload feature key is enabled then check for the 'Add new joiners' button. If it is not enabled then check for the quick invitations section.
    if $ADMIN_FEATURE_LIST['ap_user_upload']
      @LBL_ADD_NEW_JOINER.wait_until_present
      @BTN_ADD_NEW_JOINERS.wait_until_present
    else
      @LBL_QUICK_INVITATIONS.wait_until_present
      @TXF_QUICK_INVITE.wait_until_present
      @BTN_INVITE.wait_until_present
    end

  end

  def click_button (button)
    case button 
    when 'Add New Joiners'
      @BTN_ADD_NEW_JOINERS.wait_until_present
      @BTN_ADD_NEW_JOINERS.fire_event('click')
      @TXF_QUICK_INVITE.wait_until_present
    end
  end

  # Send email invitation to join the the web app
  def invite
    # If admin user upload is enabled in arch, then the user has to click on the 'Add new joiners' button in order to see the 'quick invite' text field
    # If admin user upload is NOT enabled in arch, then the user can see the 'Quick invite' text field on the 'Manage colleagues' screen 
    if $ADMIN_FEATURE_LIST['ap_user_upload']
      click_button('Add New Joiners')
    end

    # Counter is used to create a different (unique) email address
    @COUNTER_INDEX = @file_service.get_from_file("invite_email_counter:")
    @file_service.insert_to_file('invite_email_counter:', "#{rand(36**6).to_s(36)}")
    @COUNTER_INDEX = @file_service.get_from_file('invite_email_counter:')[0..-2]

    @TXF_QUICK_INVITE.wait_until_present
    @TXF_QUICK_INVITE.set "#{ACCOUNT[:"#{$account_index}"][:valid_account][:email_subdomain]}" + '+' + "#{ACCOUNT[:"#{$account_index}"][:valid_account][:country_code]}" + "#{@COUNTER_INDEX}" + '@' + "#{ACCOUNT[:"#{$account_index}"][:valid_account][:email_domain]}"
    @BTN_INVITE.wait_until_present
    @BTN_INVITE.fire_event('click')
    # Uncomment the line below when LT-1878 has been fixed
    # @BROWSER.div(:text, /#{ZEUS_STRINGS["add_user"]["invitation"]["success"]["part1"]}/).wait_until_present
    Watir::Wait.until { !@TXF_QUICK_INVITE.value.include? "#{ACCOUNT[:"#{$account_index}"][:valid_account][:email_subdomain]}" + '+' + "#{ACCOUNT[:"#{$account_index}"][:valid_account][:country_code]}" + "#{@COUNTER_INDEX}" + '@' + "#{ACCOUNT[:"#{$account_index}"][:valid_account][:email_domain]}" }
    @file_service.insert_to_file("invite_email_counter:", @COUNTER_INDEX)
  end
end