# -*- encoding : utf-8 -*-
require 'calabash-cucumber/ibase'

class IOSSignUpPage < Calabash::IBase
  BTN_CONTINUE = "UIButtonLabel marked:'#{IOS_STRINGS["WAMFoundationContinueKey"]}'"
  BTN_X = "button marked:'close button'"
  BTN_PHOTO = "button marked:'add photo'"
  BTN_CHOOSE_F_L = "label marked:'#{IOS_STRINGS["WAMImageRetrieveInteractorActionSheetGallery"]}'"
  BTN_CLOSE = "button marked:'close button'"
  BTN_CANCEL = "label marked:'#{IOS_STRINGS["WAMFoundationCancelKey"]}'"
  BTN_OK = "label marked:'#{IOS_STRINGS["WAMFoundationOkKey"]}'"
  BTN_FINISH = "button marked:'Finish'"
  BTN_EMAIL_ADMIN = "button marked:'#{IOS_STRINGS["WAMNetworkDeactivatedViewControllerEmailAdministratorButtonText"]}'"
  BTN_SKIP = "button marked:'#{IOS_STRINGS["WBUpsellSkipButton"]}'"
  
  LBL_SIGN_UP = "label marked:'#{IOS_STRINGS["WAMSignupViewControllerTitle"]}'"
  LBL_SPORTS_OUTOOR = "label marked:'Sports & Outdoor'"
  LBL_TECHNOLOGY = "label marked:'Technology'"
  LBL_INTERESTS = "label marked:'To help us give you better suggestions, tell us about your interests'"
  LBL_APPROVEL_PENDING = "label marked:'#{IOS_STRINGS["WAMLoginSingUpErrorViewControllerApprovalPendingTitleText"]}'"
  LBL_ADD_PHOTO_VIDEO = "label marked:'You can sync photos and videos onto your iPhone using iTunes.'"

  TXF_FIRST_NAME = "label marked:'#{IOS_STRINGS["WAMSignupFirstName"]}' * parent textField"
  TXF_LAST_NAME = "label marked:'#{IOS_STRINGS["WAMSignupLastName"]}' * parent textField"
  TXF_JOB_TITLE = "label marked:'#{IOS_STRINGS["WAMSignupJobTitle"]}' * parent textField"
  TXF_WORK_E_M_A = "label marked:'#{IOS_STRINGS["WAMSignupWorkEmail"]}' * parent textField"
  TXF_PASSWORD = "label marked:'#{IOS_STRINGS["WAMSignupPassword"]}' * parent textField"
  
  def trait
    LBL_SIGN_UP
  end

  def click_button (button)
    case button
    when 'Continue'
      wait_for(:timeout => 30){element_exists(BTN_CONTINUE)}
      flash(BTN_CONTINUE)
      touch(BTN_CONTINUE)
      wait_for(:timeout => 30){element_does_not_exist(BTN_SKIP)}
    when 'PHOTO'
      wait_for(:timeout => 30){element_exists(BTN_PHOTO)}
      touch(BTN_PHOTO)
      wait_for(:timeout => 30){element_exists(BTN_CANCEL)}
    when 'Choose from Library'
      wait_for(:timeout => 30){element_exists(BTN_CHOOSE_F_L)}
      touch(BTN_CHOOSE_F_L)
      wait_for(:timeout => 30){element_does_not_exist(BTN_CHOOSE_F_L)}
    when 'Cancel'
      wait_for(:timeout => 30){element_exists(BTN_CANCEL)}
      touch(BTN_CANCEL)
      wait_for(:timeout => 30){element_does_not_exists(BTN_CANCEL)}
    when 'Sports & Outdoor'
      wait_for(:timeout => 30){element_exists(LBL_SPORTS_OUTOOR)}
      touch(LBL_SPORTS_OUTOOR)
      sleep(0.8)
    when 'Technology'
      wait_for(:timeout => 30){element_exists(LBL_TECHNOLOGY)}
      touch(LBL_TECHNOLOGY)
      sleep(0.8)
    when 'Finish'
      wait_for(:timeout => 30){element_exists(BTN_FINISH)}
      touch(BTN_FINISH)
      wait_for(:timeout => 30){element_does_not_exist(BTN_CLOSE)}
    when 'Email administrator'
      wait_for(:timeout => 30){element_exists(BTN_CLOSE)}
      touch(BTN_CLOSE)
      wait_for(:timeout => 30){element_exists("button marked:'#{IOS_STRINGS["WAMAppIntroLetsGoButtonTitle"]}'")}
    when 'X'
      wait_for(5){element_exists(BTN_X)}
      touch(BTN_X)
      wait_for(5) {element_does_not_exist(BTN_X)}
    else
      fail(msg = "Error. click_button. Button '#{button}' is not defined.")
    end
  end
  
  # The first part of the sign up process
  def enter_details 
    @file_service = FileService.new
    
    # add_photo
    scroll("scrollView", :down)
    sleep(1)

    @file_service.insert_to_file('invite_email_counter:', "#{rand(36**6).to_s(36)}")
    @COUNTER_INDEX = @file_service.get_from_file('invite_email_counter:')[0..-2]
    wait_for(:timeout => 30){element_exists(TXF_FIRST_NAME)}
    touch(TXF_FIRST_NAME)
    wait_for_keyboard
    keyboard_enter_text("#{USER_PROFILE[:new_user][:first_name]}" + "#{@COUNTER_INDEX}")

    wait_for(:timeout => 30){element_exists(TXF_LAST_NAME)}
    touch(TXF_LAST_NAME)
    wait_for_keyboard
    keyboard_enter_text("#{USER_PROFILE[:new_user][:last_name]}" + "#{@COUNTER_INDEX}")

    wait_for(:timeout => 30){element_exists(TXF_JOB_TITLE)}
    touch(TXF_JOB_TITLE)
    wait_for_keyboard
    keyboard_enter_text("#{USER_PROFILE[:new_user][:job_title]}")
    
    scroll("scrollView", :down)
    sleep(1)

    if $invitation_code == 'Company Code'
      touch(TXF_WORK_E_M_A)
      wait_for_keyboard
      @EMAIL = keyboard_enter_text("lifeworkstesting+#{@COUNTER_INDEX}@#{ACCOUNT[:"#{$account_index}"][:valid_account][:email_domain]}")
    elsif $invitation_code == 'Personal Code'
      @EMAIL = query("UILabel marked:'#{IOS_STRINGS["WAMSignupWorkEmail"]}' parent * index:0 descendant JVFloatLabeledTextField")[0]['value']
    end

    if ($invitation_code == nil && @EMAIL == nil)
      fail(msg = 'Error. signup_step_2. Expected to see e-maill address.')
    end

    wait_for(:timeout => 30){element_exists(TXF_PASSWORD)}
    touch(TXF_PASSWORD)
    wait_for_keyboard
    keyboard_enter_text("#{USER_PROFILE[:new_user][:password]}")

    scroll("scrollView", :down)
    click_button ('Continue')    
  end

  # Add photo function (just chack the buttons functionality 
  # without adding photo)
  def add_photo 
    if element_does_not_exist(BTN_PHOTO)
      fail(msg = 'Error. add_photo. Could not find BTN_PHOTO.')
    end

    click_button('PHOTO')
    wait_for(:timeout => 30){element_exists(BTN_CHOOSE_F_L)}
    click_button('Choose from Library')
    wait_for(:timeout => 30){element_exists(LBL_ADD_PHOTO_VIDEO)}
    click_button('Cancel')
    wait_for(:timeout => 30){element_exists(LBL_SIGN_UP)}
  end

  # Choose intersts 
  def choose_intersts
    click_button('Sports & Outdoor')
    
    scroll("tableView", :down)
    sleep(1)
    scroll("tableView", :down)
    sleep(1)

    click_button('Technology')
    click_button('Continue')
    wait_for(:timeout => 30){element_exists(LBL_APPROVEL_PENDING)}
  end
end