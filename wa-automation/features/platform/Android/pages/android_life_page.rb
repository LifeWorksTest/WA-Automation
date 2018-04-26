# -*- encoding : utf-8 -*-
require 'calabash-android/abase'

class AndroidLifePage < Calabash::ABase
  BTN_VIEW_RESULTS = "android.support.v7.widget.AppCompatButton text:'View results'" 
  BTN_RETAKE_ASSESSMENT = "android.widget.Button text:'Retake assessment'"
  BTN_MORE = "* id:'smallLabel' text:'More'"
  BTN_LETS_BEGIN= "android.widget.Button id:'fragment_self_assessment_top_fragment_info_screen_button'"
  BTN_TRUE = "android.widget.TextView text:'True'"
  BTN_FALSE = "android.widget.TextView text:'False'"
  BTN_TXT_ANSWER = "android.widget.TextView id:'self_assessment_answer_text' index:2"
  BTN_COMPLETE_ASSESSMENT = "android.widget.Button text:'Complete assessment'"

  TXV_ASSESSMENT_COMPLETE = "AppCompatTextView text:'Assessment Complete'"  
  LBL_ASP = "* text:'Assessments'"
  LBL_EAP = "* text:'Employee Assistance'"

  def trait
      LBL_EAP
      LBL_ASP
  end

  def is_visible(page)
      case page
      when 'EAP_Page'
        wait_for(:timeout => 30,:post_timeout => 2){element_exists(LBL_EAP)}
        wait_for(:timeout => 30,:post_timeout => 2){element_exists("WebView css:'DIV' class:'size-xl font-semibold'")}
        @CATEGORY_LIST = query("WebView css:'DIV' class:'size-xl font-semibold'")  
      else 
        fail(msg = "Error. is_visible. The button #{button} is not defined.")
      end  
  end

  # Validates that Categories are displayed on EAP life screen and that they have sub-categories limked to them
  def validate_catogries
    is_visible('EAP_Page')
    no_of_categories = query("WebView css:'DIV' class:'size-xl font-semibold'").count
        
    if no_of_categories == 0
       fail(msg = "Error. validate_catogries. There are no categories displayed in this page.")
    end

    for i in 0..no_of_categories - 1
        label = @CATEGORY_LIST[i]["textContent"]
        
        touch("WebView css:'Div' textContent:'#{label}'")
	      wait_for(:timeout => 30, :post_timeout => 2){element_exists("WebView css:'DIV' class:'font-bold size-lg'")}
	      no_of_sub_categories = query("WebView css:'DIV' class:'font-bold size-lg'").count
        puts "no_of_sub_categories is #{no_of_sub_categories}"
         
        if no_of_sub_categories == 0
           fail(msg = "Error. validate_catogries. There are no sub-categories displayed in this page.")
        end

        touch("WebView css:'Div' textContent:'#{label}'")
        wait_for(:timeout => 30, :post_timeout => 2){element_does_not_exist("WebView css:'DIV' class:'font-bold size-lg'")}
    end 
  end

  def open_an_article
      is_visible('EAP_Page')
      
      category_lbl = @CATEGORY_LIST[2]["textContent"]
      touch("WebView css:'Div' textContent:'#{category_lbl}'")
      wait_for(:timeout => 30){element_exists("WebView css:'DIV' class:'font-bold size-lg'")}
      
      # Clicks on the last displayed sub-category for opening the article
      sub_category_lbl = query("WebView css:'DIV' class:'font-bold size-lg'")[1]["textContent"]
      touch("WebView  css:'Div' textContent:'#{sub_category_lbl}'")
      wait_for(:timeout => 30){element_exists("WebView css:'DIV' class:'font-bold size-lg'")}
      text_before_opening_article = query("WebView css:'DIV' class:'font-bold size-lg'")[0]["textContent"]
      touch("WebView css:'DIV' class:'font-bold size-lg'")
      wait_for(:timeout => 30,:post_timeout => 2){("WebView css:'DIV' class:'font-bold'")}
      text_after_opening_article = query("WebView css:'DIV' class:'font-bold pdf-article-title'")[0]["textContent"]
      touch("WebView css:'SPAN'{textContent CONTAINS 'Home'}")
      wait_for(:timeout => 30){element_exists(LBL_EAP)}      
      
      unless text_before_opening_article == text_after_opening_article       
       fail "Wrong article is opened!! Expected to see '#{text_before_opening_article}' article, but opened '#{text_after_opening_article}' article."
      else
       puts "Correct article is opened!! Expected to see '#{text_before_opening_article}' article and opened '#{text_after_opening_article}' article."
      end              
  end  	        

  # Retake the current assessment
  def retake_assessment
      wait_for(:timeout => 30, :post_timeout => 2){element_exists(BTN_VIEW_RESULTS)}
      touch(BTN_VIEW_RESULTS)
      is_visible("Assessment Complete")
      click_button("Retake Assissment")
      process_assessment     
  end

  def process_assessment
    answer_assessment_question
    wait_for(:timeout => 30, :post_timeout => 2){element_exists("AppCompatTextView text:'Assessment Complete!'")}
    touch(BTN_VIEW_RESULTS) 
    wait_for(:timeout => 30, :post_timeout => 2){element_exists("android.widget.ImageButton")}
    touch("android.widget.ImageButton")
  end

  def click_button (button)

    case button
    when 'Retake Assissment'
      touch(BTN_RETAKE_ASSESSMENT)
      is_visible("Lets Begin")
      touch(BTN_LETS_BEGIN)
    when 'Complete Assessment'
      touch(BTN_COMPLETE_ASSESSMENT)
      is_visible("Lets Begin")
      touch(BTN_LETS_BEGIN)
    else
      fail(msg = "Error. click_button. The button #{button} is not defined in menu.")
    end
  end

  def answer_assessment_question
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

  def is_visible (screen_name)

    case screen_name
      when 'Assessment Complete'
        wait_for(:timeout => 30, :post_timeout => 2){element_exists(TXV_ASSESSMENT_COMPLETE)}
      when 'Lets Begin'
        wait_for(:timeout => 30, :post_timeout => 2){element_exists(BTN_LETS_BEGIN)}
      else
        fail(msg = "Error. is_visible. The page option #{screen_name} is not defined in menu.")
    end

  end

  def complete_new_assessment
    wait_for(:timeout => 30, :post_timeout => 2){element_exists(BTN_COMPLETE_ASSESSMENT)}
    click_button('Complete Assessment')
    process_assessment
  end

  # Retake the current assessment the amt of times specified in the scenario
  def complete_assessment_series (times_to_retake_assessment)

    for i in 1..times_to_retake_assessment
      retake_assessment
    end

  end
end
