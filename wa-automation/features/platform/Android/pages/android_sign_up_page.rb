# -*- encoding : utf-8 -*-
require 'calabash-android/abase'

class AndroidSignUpPage < Calabash::ABase
  BTN_GOT_IT = "AppCompatButton marked:'Got it'"
  BTN_FINISH = "activity_singup_form_finish_button marked:'Finish'"

  TXF_FIRST_NAME = "android.widget.EditText index:#{0}"
  TXF_LAST_NAME = "android.widget.EditText index:#{1}"
  TXF_JOB_TITLE = "android.widget.EditText index:#{2}"
  TXF_WORK_E_M_A = "android.widget.EditText index:#{3}"
  TXF_PASSWORD = "android.widget.EditText index:#{4}"

  TXV_PHOTO = "FloatingActionButton id:'activity_singup_picture_field_camera_button'"

  def trait
    TXV_PHOTO
  end

  def click_button (button)
    case button
    when 'Finish'
      wait_for(10){element_exists(BTN_FINISH)}
      touch(BTN_CONTINUE)
      wait_for(10){element_does_not_exist(BTN_FINISH)}
    when 'Finish'
      wait_for(10){element_exists(BTN_FINISH)}
      touch(BTN_FINISH)
      wait_for(10){element_does_not_exist(BTN_FINISH)}
    when 'Got it'
      wait_for(10){element_exists(BTN_GOT_IT)}
      touch(BTN_OK_GOT_IT)
      wait_for(10){element_does_not_exist(BTN_GOT_IT)}
    else
      fail(msg = "Error. click_button. The button #{button} is not defined.")
    end
  end

  # Complete sign up process
  def enter_details
    file_service = FileService.new
    
    @COUNTER_INDEX = file_service.get_from_file("invite_email_counter:")
    @COUNTER_INDEX = @COUNTER_INDEX.to_i

    enter_text(TXF_FIRST_NAME, "#{USER_PROFILE[:new_user][:first_name]}" + "#{@COUNTER_INDEX}") 
    enter_text(TXF_LAST_NAME, "#{USER_PROFILE[:new_user][:last_name]}" + "#{@COUNTER_INDEX}") 
    enter_text(TXF_JOB_TITLE, "#{USER_PROFILE[:new_user][:job_title]}") 
    
    if $invitation_code == 'Company Code'
      @EMAIL = enter_text(TXF_WORK_E_M_A, "lifeworkstesting+#{@COUNTER_INDEX}@lifeworks.com") 
    elsif $invitation_code == 'Personal Code'
      @EMAIL = query("android.widget.EditText index:#{3}")[0]['text']
    end

    if ! $invitation_code && @EMAIL == nil
      fail(msg = 'Error. signup_step_2. Expected to see e-maill address.')
    end

    scroll_down
    sleep(0.5)
    
    enter_text(TXF_PASSWORD, "#{USER_PROFILE[:new_user][:password]}")     

    click_button ('Finish')

    wait_for(10){element_does_not_exist("AppCompatTextView id:'activity_login_informative_subtitle_text'")}
    wait_for(10){element_does_not_exist("AppCompatTextView id:'activity_login_informative_title_text'")}

    @COUNTER_INDEX = @COUNTER_INDEX.to_i + 1
    file_service.insert_to_file("invite_email_counter:", @COUNTER_INDEX)

    click_button ('Got it')
  end
end
