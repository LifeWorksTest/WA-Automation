
  # -*- encoding : utf-8 -*-
require 'calabash-android/abase'

class AndroidLifePage < Calabash::ABase
  BTN_VIEW_RESULTS = "android.support.v7.widget.AppCompatButton text:'View results'" 
  BTN_RETAKE_ASSESSMENT = "android.widget.Button text:'Retake assessment'"
  BTN_MORE = "* id:'smallLabel' text:'More'"
  BTN_LETS_BEGIN= "android.widget.Button id:'fragment_self_assessment_top_fragment_info_screen_button'"
  BTN_TRUE = "android.widget.TextView text:'True'"
  BTN_FALSE = "android.widget.TextView text:'False'"
  BTN_TXT_ANSWER = "android.widget.TextView id:'self_assessment_answer_text' index:3"

  TXV_ASSESSMENT_COMPLETE = "AppCompatTextView text:'Assessment Complete'"  
  LBL_ASP = "* text:'Assessments'"

  def trait
    LBL_ASP
  end
  
# Retake the current assessment the amt of times specified in the scenario
  def retake_assessment
   wait_for(:timeout => 30, :post_timeout => 2){element_exists(BTN_VIEW_RESULTS)}
   touch(BTN_VIEW_RESULTS)
   is_visible("Assessment Complete")
   click_button("Retake Assissment")
   answering_assessment_questions
   wait_for(:timeout => 30, :post_timeout => 2){element_exists("AppCompatTextView text:'Assessment Complete!'")}
   touch(BTN_VIEW_RESULTS) 
   wait_for(:timeout => 30, :post_timeout => 2){element_exists("android.widget.ImageButton")}
   touch("android.widget.ImageButton")     
  end

  def click_button(button)
    case button
    when 'Retake Assissment'
      touch(BTN_RETAKE_ASSESSMENT)
      is_visible("Lets Begin")
      touch(BTN_LETS_BEGIN)
    else
      fail(msg = "Error. click_button. The button #{button} is not defined in menu.")
    end
  end

  def answering_assessment_questions
    q = query(BTN_TXT_ANSWER)
    i = 0
    while q.empty?
 
      if i%2 == 0
      touch(BTN_TRUE)
      else
        touch(BTN_FALSE)
      end
      i = i+1
      sleep(0.5)
      q = query(BTN_TXT_ANSWER)
    end
    touch(BTN_TXT_ANSWER)
  end

  def is_visible(screen_name)
    case screen_name
    when 'Assessment Complete'
      wait_for(:timeout => 30, :post_timeout => 2){element_exists(TXV_ASSESSMENT_COMPLETE)}
    when 'Lets Begin'
      wait_for(:timeout => 30, :post_timeout => 2){element_exists(BTN_LETS_BEGIN)}
    else
      fail(msg = "Error. is_visible. The page option #{screen_name} is not defined in menu.")
    end
  end

  def navigate_back_to_more
    q = query(BTN_MORE)
    while q.empty? 
    press_button('KEYCODE_BACK')
    sleep(0.5)
    q = query(BTN_MORE)
    end
    touch(BTN_MORE)
  end 
end