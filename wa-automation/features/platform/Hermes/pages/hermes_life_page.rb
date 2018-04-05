 # -*- encoding : utf-8 -*-
class HermesLifePage

  def initialize (browser)
    @BROWSER = browser
    @file_service = FileService.new
    @LABEL_GENERAL_ENQUIRY = @BROWSER.div(:text, HERMES_STRINGS["components"]["main_menu"]["general_enquiry"])
    @LABEL_CHILD_CARE = @BROWSER.div(:text, HERMES_STRINGS["components"]["main_menu"]["child_care"])
    @LABEL_ASSESSMENT_QUESTION = "div[style^='margin-top: -24px;']"
    @LABEL_ASSESSMENT_QUESTION_NUMBER = "div[style^='top: 0px; left: 0px; height: 24px; padding: 6px 12px; font-size: 20px; color: rgb(107, 107, 107);']"
    @LABEL_MORE_ASSESSMENTS =  @BROWSER.h3(:text, 'More Assessments')
    @LABEL_COMPLETED_ASSESSMENTS = @BROWSER.h3(:text, 'Completed assessments')
    @LABEL_ASSESSMENTS_IN_PROGRESS = @BROWSER.h3(:text, 'Assessments in progress')

    @BTN_CONTINUE_READING = @BROWSER.button(:text, HERMES_STRINGS["feed"]["wellness_post"]["continue_reading"])
    @BTN_SET_ANOTHER_INTEREST = @BROWSER.button(:text, HERMES_STRINGS["feed"]["wellness_post"]["set_another_interest"])
    @BTN_NO_CONTINUE = @BROWSER.button(:text, HERMES_STRINGS["feed"]["wellness_post"]["no_continue"])
    @BTN_BEGIN_ASSESSMENT = @BROWSER.div(:text, HERMES_STRINGS["self_assessment_2"]["assessment_start"]["begin_assessment"])
    @BTN_SUBMIT_ASSESSMENT = @BROWSER.button(:text, HERMES_STRINGS["self_assessment_2"]["view_results"])
    @BTN_NEXT_SNACK = @BROWSER.a(:text, /#{HERMES_STRINGS["feed"]["wellness_post"]["next_session"]}/i)
    @BTN_JUMP_FORWARD_ONE_QUESTION = "img[style^='cursor: pointer; position: absolute; right: -65px; top: 50%; transform: translateY(-50%) scale(-1); color: white;']"

    @ASSESSMENT_GROUP_SECTION = "div[style^='background-color: rgb(255, 255, 255); border-radius: 6px; box-shadow: 0px 0px 10px 0px rgba(7, 89, 132, 0.25); width: 100%; padding: 40px; text-align: center;']"

    @ASSESSMENTS_TO_COMPLETE = HERMES_STRINGS["self_assessment_2"]["assessments_to_complete"].match /(?!{smart_count} )(\w+\s\w+\s\w+) (\|{4} %{smart_count} )(\w+\s\w+\s\w+)/
    @ASSESSMENT_PROGRESS_BAR = "div[style^='position: relative; margin-top: 8px; margin-bottom: 15px;']"
    @ASSESSMENT_STRENGTH = "div[style^='display: initial; max-width: 100%; border-radius: 5px; padding: 10px 20px; font-size: 16px; background-color: rgb(255, 255, 255); color: rgb(107, 107, 107); font-weight: 600; border: medium none;']"
    @ASSESSMENT_ADVICE = "div[style^='outline: medium none; margin-top: 15px; color: rgb(117, 117, 117); font-size: 18px; width: 450px;']"
    @ASSESSMENT_LAST_COMPLETED_TIME = "div[style^='color: rgb(166, 166, 166); font-size: 14px;']"
    @ASSESSMENT_PARTIALLY_COMPLETED = false
  end

  def click_button (button)
    case button
    when 'Skip'
      @BROWSER.button(:text, HERMES_STRINGS["feed"]["wellness_post"]["skip"]).wait_until_present
      @BROWSER.div(:class => %w(size-lg font-bold), :text => @ARTICLE_NAME).wait_until_present
      @BROWSER.button(:text, HERMES_STRINGS["feed"]["wellness_post"]["skip"]).click
      @BROWSER.button(:text, HERMES_STRINGS["feed"]["wellness_post"]["skip"]).wait_while_present
    when 'Get Snack'
      snack_type = determine_article_type
      @ARTICLE_NAME = @BROWSER.div(:class, %w(size-lg font-bold)).text
      @ARTICLE_AUTHOR = @BROWSER.button(:text, HERMES_STRINGS["feed"]["wellness_post"]["#{snack_type}"]).parent.parent.div(:index, 1).text.gsub(/#{HERMES_STRINGS["feed"]["wellness_post"]["by"].capitalize}\s/, '').gsub(/,.*/, '')
      @BROWSER.button(:text, HERMES_STRINGS["feed"]["wellness_post"]["#{snack_type}"]).click 
      @BROWSER.button(:text, HERMES_STRINGS["feed"]["wellness_post"]["#{snack_type}"]).wait_while_present
      is_visible('Get Snack')
    when 'Next Snack'
      # If the end of a series has been reached, a popup window will appear after clicking the 'Next Snack' button
      # asking the user to continue with the same topic or select a new topic.
      read_now_btn = HERMES_STRINGS["feed"]["wellness_post"]["read_now"]
      watch_now_btn = HERMES_STRINGS["feed"]["wellness_post"]["watch_now"]
      listen_now_btn = HERMES_STRINGS["feed"]["wellness_post"]["listen_now"]
      new_topics_to_select = "div[style='margin-top: 20px; margin-bottom: 20px;']"
      continue_or_select_new_topic_window = "div[style='padding: 0px; text-align: left; opacity: 1; display: block;']"

      @BTN_NEXT_SNACK.wait_until_present
      @BTN_NEXT_SNACK.click

      Watir::Wait.until { 
        @BROWSER.button(:text, /(#{read_now_btn}|#{watch_now_btn}|#{listen_now_btn})/).present? ||
        @BROWSER.element(css: continue_or_select_new_topic_window).present?
      }

      if @BROWSER.element(css: continue_or_select_new_topic_window).present?
        if @BROWSER.element(css: continue_or_select_new_topic_window).div(:text, HERMES_STRINGS["feed"]["wellness_post"]["reflection"]["focus_new_topic"]).present?
          @BROWSER.element(css: continue_or_select_new_topic_window).button(:text, /#{HERMES_STRINGS["feed"]["wellness_post"]["reflection"]["continue"]}/).wait_until_present
          @BROWSER.element(css: continue_or_select_new_topic_window).a(:text, HERMES_STRINGS["feed"]["wellness_post"]["reflection"]["new_topic"]).wait_until_present
          # Randomly selects either a new new random topic, or will continue with the existing topic
          select_new_topic = [true, false].sample
        else
          @BROWSER.element(css: continue_or_select_new_topic_window).div(:text, HERMES_STRINGS["feed"]["wellness_post"]["reflection"]["focus_another_topic"]).wait_until_present
          @BROWSER.element(css: continue_or_select_new_topic_window).a(:text, HERMES_STRINGS["feed"]["wellness_post"]["reflection"]["new_topic"]).wait_until_present
        end      
        
        if select_new_topic || @BROWSER.element(css: continue_or_select_new_topic_window).div(:text, HERMES_STRINGS["feed"]["wellness_post"]["reflection"]["focus_another_topic"]).present?    
          new_topic_index = rand(0..(@BROWSER.element(css: new_topics_to_select).spans.count-1))
          puts "selecting new topic ------ #{@BROWSER.element(css: new_topics_to_select).span(:index, new_topic_index).text}"
          @BROWSER.element(css: new_topics_to_select).span(:index, new_topic_index).wait_until_present
          @BROWSER.element(css: new_topics_to_select).span(:index, new_topic_index).click
        else
          puts 'continuing existing topic'
          @BROWSER.element(css: continue_or_select_new_topic_window).button(:text, /#{HERMES_STRINGS["feed"]["wellness_post"]["reflection"]["continue"]}/).click
        end
        
        @BROWSER.element(css: continue_or_select_new_topic_window).wait_while_present
        @BTN_NEXT_SNACK.fire_event('click')
        @BTN_NEXT_SNACK.wait_while_present
        @BROWSER.button(:text, /(#{read_now_btn}|#{watch_now_btn}|#{listen_now_btn})/).wait_until_present
      end

    when 'No, Continue'
      @BTN_NO_CONTINUE.wait_until_present
      @BTN_NO_CONTINUE.click
      @BTN_NO_CONTINUE.wait_while_present
      @BROWSER.div(:class, %w(size-lg font-bold)).wait_until_present
      Watir::Wait.until { !@BROWSER.div(:class, %w(size-lg font-bold)).text.include? @ARTICLE_NAME }
    when 'Set Another Interest'
      @BTN_SET_ANOTHER_INTEREST.wait_until_present
      @BTN_SET_ANOTHER_INTEREST.click
      is_visible('Wellness Categories')
    when 'Start or resume assessment'
      # randomly clicks on either the Assessment group begin/resume assessment button or the assessement begin/resume assessment button
      if [true, false].sample 
        @BROWSER.element(css: @ASSESSMENT_GROUP_SECTION).div(:text, @ASSESSMENT_GROUP_NAME).parent.div(:text, @ASSESSMENT_GROUP_BTN).click
      else
        @ASSESSMENT_LIST.parent.img(:index, @CURRENT_ASSESSMENT_INDEX).parent.parent.div(:text, @CURRENT_ASSESSMENT_NAME).parent.parent.parent.span(:text, @ASSESSMENT_LIST_BTN).click
      end

      @ASSESSMENT_PARTIALLY_COMPLETED ? is_visible('Wellbeing Assessment') : is_visible('Begin Wellbeing Assessment') 
    when 'Begin Assessment'
      @BTN_BEGIN_ASSESSMENT.wait_until_present
      @BTN_BEGIN_ASSESSMENT.fire_event('click')
      @BTN_BEGIN_ASSESSMENT.wait_while_present
      is_visible('Wellbeing Assessment')
    when 'Submit Assessment'
      @BTN_SUBMIT_ASSESSMENT.wait_until_present
      sleep(4)      
      @BTN_SUBMIT_ASSESSMENT.fire_event('click')
      @BTN_SUBMIT_ASSESSMENT.wait_while_present
      is_visible('Assessment Results')
    else
      fail(msg = "Error. click_button. The button #{button} is not defined in menu.")
    end
  end

  def is_visible (screen_name)
  	case screen_name
  	when 'Need Help'
  	  @BROWSER.div(:class => 'title-velocity-hook',:text => HERMES_STRINGS["components"]["main_menu"]["need_help"]).wait_until_present
  	  @LABEL_GENERAL_ENQUIRY.wait_until_present
      @LABEL_CHILD_CARE.wait_until_present
    when 'Employee Assitance'
      @BROWSER.div(:class,'color-white').wait_until_present
      @BROWSER.div(:text, /#{HERMES_STRINGS["employee_assistance"]["home_title_featured_articles"]}/).wait_until_present
      @BROWSER.div(:text, /#{HERMES_STRINGS["employee_assistance"]["home_title_recently_updated"]}/).wait_until_present
      @CATEGORY_LIST = @BROWSER.divs(:class, %w(size-xl font-semibold))
    when 'Chat'
      if $ACCOUNT_TYPE == 'shared'
        @limited_account_page = HermesLimitedAccountPage.new @BROWSER
        @limited_account_page.skip_limited_account_page
      else   
        @BROWSER.div(:class => 'title-velocity-hook', :text => HERMES_STRINGS["chat"]["hero"]["title"]).wait_until_present

        if @BROWSER.div(:class => 'subtitle-velocity-hook',:text => HERMES_STRINGS["chat"]["hero"]["subtitle_available"]).exists?
          @BROWSER.div(:class, 'btn').wait_until_present
          @BROWSER.div(:class, 'btn').parent.parent.div(:text, /#{HERMES_STRINGS["chat"]["form"]["title"]}/).wait_until_present
          @BROWSER.div(:class => 'btn',:text => HERMES_STRINGS["chat"]["form"]["cta"].upcase).wait_until_present
        else
          @BROWSER.div(:class => 'subtitle-velocity-hook',:text => /(#{HERMES_STRINGS["chat"]["hero"]["subtitle_not_available"]}|Clavardage non offert)/).wait_until_present
        end
      end
    when 'Health Library'
      @BROWSER.div(:class => 'title-velocity-hook',:text => HERMES_STRINGS["components"]["main_menu"]["health_library"]).wait_until_present
      @BROWSER.div(:class => 'btn',:text => HERMES_STRINGS["health_library"]["hero"]["cta"].upcase).wait_until_present
    when 'Wellness Tools'
      if ENV['CURRENT_CUCUMBER_PROFILE'].include? 'Web_US'
        if $ACCOUNT_TYPE == 'shared'
          @limited_account_page = HermesLimitedAccountPage.new @BROWSER
          @limited_account_page.skip_limited_account_page
        else
          @BROWSER.div(:class => 'title-velocity-hook',:text => HERMES_STRINGS["components"]["main_menu"]["wellness_tools"]).wait_until_present
          @BROWSER.div(:class => 'btn',:text => HERMES_STRINGS["wellness_tools"]["hero"]["cta"].upcase).wait_until_present
        end
      end
    when 'Wellness Categories'
      @BROWSER.div(:text, HERMES_STRINGS["wellness_categories"]["cat_title"]).wait_until_present
      @BROWSER.div(:text, /#{HERMES_STRINGS["wellness_categories"]["privacy"]["title"]}/).wait_until_present
      @BROWSER.div(:text, /#{HERMES_STRINGS["wellness_categories"]["privacy"]["subtitle"]}/).wait_until_present
      @BROWSER.button(:text, HERMES_STRINGS["wellness_categories"]["action_banner_next"]).wait_until_present
      
      # Checks that there are one or more categories present
      Watir::Wait.until { @BROWSER.imgs(:src, /category-images/).count > 0 }
    when 'Select your relevant topics'
      topic_css_helper = "div[style^='display: table-cell; vertical-align: middle;']"

      @BROWSER.div(:text, HERMES_STRINGS["wellness_categories"]["subcat_title"]).wait_until_present
      @BROWSER.div(:text, HERMES_STRINGS["wellness_categories"]["subcat_subtitle"]).wait_until_present
      @BROWSER.div(:text, /#{HERMES_STRINGS["wellness_categories"]["privacy"]["title"]}/).wait_until_present
      @BROWSER.div(:text, /#{HERMES_STRINGS["wellness_categories"]["privacy"]["subtitle"]}/).wait_until_present
      @BROWSER.button(:text, HERMES_STRINGS["wellness_categories"]["action_banner_next"]).wait_until_present
      @BROWSER.a(:text, HERMES_STRINGS["wellness_categories"]["action_banner_back"]).wait_until_present
      
      # Checks that there is more than one topic to select for the first category displayed on the screen
      Watir::Wait.until { @BROWSER.img(:src => /category-images/, :index => 0).parent.parent.elements(css: "#{topic_css_helper}").count > 0 }
    when 'Select First Topic'
      @BROWSER.div(:text, HERMES_STRINGS["wellness_categories"]["summary_start"]).wait_until_present
      @BROWSER.div(:text, HERMES_STRINGS["wellness_categories"]["summary_title"]).wait_until_present
      @BROWSER.div(:text, HERMES_STRINGS["wellness_categories"]["summary_subtitle"]).wait_until_present
      @BROWSER.button(:text, HERMES_STRINGS["wellness_categories"]["summary_cta"]).wait_until_present
      @BROWSER.a(:text, HERMES_STRINGS["wellness_categories"]["summary_reconfigure"]).wait_until_present
      
      # Checks that there is more than one topic to select for the first category displayed on the screen
      Watir::Wait.until { @BROWSER.imgs(:src, /category-images/).count > 0 }
    when 'Legal Services'
      @BROWSER.div(:class => 'title-velocity-hook',:text => HERMES_STRINGS["legal_services"]["hero"]["title"]).wait_until_present
      @BROWSER.div(:class => 'btn',:text => HERMES_STRINGS["legal_services"]["hero"]["cta"].upcase).wait_until_present 
    when 'Get Snack'
      Watir::Wait.until { 
        @BROWSER.div(:class => 'font-bold', :text => @ARTICLE_NAME).present? ||
        @BROWSER.h1(:text => @ARTICLE_NAME).present?
      }

      @BROWSER.div(:class => %w(font-bold size-sm), :text => /#{@ARTICLE_AUTHOR}/).wait_until_present
      @BROWSER.div(:id => 'articleFooter', :text => /#{@ARTICLE_AUTHOR}/).wait_until_present
    when 'Assessment Homepage'      
      @BROWSER.div(:text, HERMES_STRINGS["self_assessment_2"]["title"]).wait_until_present
    when 'Begin Wellbeing Assessment'
      @BTN_BEGIN_ASSESSMENT.wait_until_present
      @BROWSER.div(:text, @CURRENT_ASSESSMENT_NAME).wait_until_present
    when 'Wellbeing Assessment'
      @BROWSER.element(css: @ASSESSMENT_PROGRESS_BAR).wait_until_present
      @BROWSER.i(:class, 'icon-padlock').parent.parent.div(:text, /#{HERMES_STRINGS["self_assessment_2"]["assessment_start"]["privacy"]}/).wait_until_present
      
      Watir::Wait.until { @BROWSER.buttons.count > 1 }
      # 2 lines below are the assessßment question text
      @BROWSER.element(css: "div[style^='margin-top: -24px;']").wait_until_present
      Watir::Wait.until { @BROWSER.element(css: "div[style^='margin-top: -24px;']").text.length > 1 }
      @BROWSER.element(css: @LABEL_ASSESSMENT_QUESTION_NUMBER).wait_until_present
      
      if @ASSESSMENT_PARTIALLY_COMPLETED
        # If we are resuming an incomplete assessment, then we expect to start the questionnaire on the highest question that was not answered
        Watir::Wait.until { 
          @BROWSER.element(css: @LABEL_ASSESSMENT_QUESTION_NUMBER).text.to_i == @CURRENT_ASSESSMENT_LAST_QUESTION_NUMBER
          !@BROWSER.span(:class => 'icon-web_close').present?
        }
      else
        # The user sees the 'close' assessment link on the first page of the questionnaire only. So when beginning a new assessment this element must be seen
        @BROWSER.span(:class => 'icon-web_close').wait_until_present
      end
    when 'Assessment Complete'
      @BROWSER.img(:src, /back-arrow/).wait_while_present
      @BROWSER.div(:text, HERMES_STRINGS["self_assessment"]["complete"]).wait_until_present   
      @BTN_SUBMIT_ASSESSMENT.wait_until_present
    when 'Assessment Results'
      @BROWSER.div(:text, HERMES_STRINGS["self_assessment_2"]["assessment_complete"]).wait_until_present
      @BROWSER.div(:text, HERMES_STRINGS["self_assessment_2"]["assessment_complete"]).parent.div(:text, /\w+/).wait_until_present
      @BROWSER.a(:text, HERMES_STRINGS["self_assessment_2"]["retake_assessment"]).wait_until_present
      @BROWSER.span(:text, HERMES_STRINGS["self_assessment_2"]["back_home"]).wait_until_present
      # Checks that the wellbeing strength result text is not nil
      @BROWSER.element(css: @ASSESSMENT_STRENGTH).wait_until_present
      Watir::Wait.until { @BROWSER.element(css: @ASSESSMENT_STRENGTH).text.length > 1 }
      @BROWSER.div(:text, HERMES_STRINGS["self_assessment_2"]["assessment_complete"]).parent.div(:index, 1).wait_until_present
    else
      fail(msg = "Error. is_visible. The page option #{screen_name} is not defined in menu.")
    end
  end

  # Validate that both the enquiry forms, General Enquiry & Child Care forms can be opened
  # @param form_type
  def open_enquiry (form_type)
    case form_type
    when 'General Enquiry'
      @LABEL_GENERAL_ENQUIRY.wait_until_present
      @LABEL_GENERAL_ENQUIRY.parent.div(:text, /#{HERMES_STRINGS["need_help"]["form_1"]["ctaCopy"]}/).click
      @BROWSER.div(:text, /#{HERMES_STRINGS["general_enquiry"]["title"]}/).wait_until_present
      @BROWSER.div(:text, /#{HERMES_STRINGS["general_enquiry"]["subtitle"]}/).wait_until_present
    when 'Childcare'
      @LABEL_CHILD_CARE.wait_until_present
      @LABEL_CHILD_CARE.parent.div(:text, /#{HERMES_STRINGS["need_help"]["form_2"]["ctaCopy"]}/).click
      @BROWSER.div(:text, /#{HERMES_STRINGS["child_care"]["title"]}/).wait_until_present
      @BROWSER.div(:text, /#{HERMES_STRINGS["child_care"]["subtitle"]}/).wait_until_present
      @BROWSER.div(:text, HERMES_STRINGS["child_care"]["form"]["submit"].upcase).wait_until_present
    end  
  end

  # Gets the name of the categories displayed in the EAP screen and stores them in categories_list array
  def eap_page_validate_categories
    @CATEGORY_LIST.each do |category|
      puts "Category is - #{category.text}"
      category.wait_until_present
      category.click

      # waiting for sub-categories to be visibile after clicking on the category
      @BROWSER.div(:class, %w(font-semibold size-sm)).wait_until_present
    end

    if @CATEGORY_LIST.size == 0
      fail(msg = "Error. eap_page_validate_categories. There are no categories displayed in this page.")
    end
  end 

  # Validates that only CMS phone numbers of the logged in user's locale will be displayed on the life Employee Assistance homepage
  def validate_cms_phone_numbers
    default_locale = COMPANY_PROFILE[:profile_1][:locale]
    
    LOCALES.each do |locales|
      if locales[0].to_s == default_locale
        @BROWSER.i(:class => 'icon-phone', :index => 0).parent.text.include? "#{HERMES_STRINGS["employee_assistance"]["contact_info"]} #{locales[1][:tel_no]} #{locales[1][:label]}"
      else
        Watir::Wait.until { !@BROWSER.i(:class => 'icon-phone', :index => 0).parent.text.include? "#{HERMES_STRINGS["employee_assistance"]["contact_info"]} #{locales[1][:tel_no]} #{locales[1][:label]}" }
      end
    end
  end
  
  # Opens one of the article in the first category element stored in categories_list array.
  def open_an_article
    @CATEGORY_LIST[1].wait_until_present
    @CATEGORY_LIST[1].click
    @BROWSER.div(:class, %w(font-bold size-lg)).wait_until_present
    @BROWSER.div(:class, %w(font-bold size-lg)).click
      
    # Clicks on the last displayed sub-category for opening the article
    sub_category_name = @BROWSER.spans(:class, %w(font-bold size-sm)).last.text
    @BROWSER.spans(:class, %w(font-bold size-sm)).last.click
    @BROWSER.div(:class => 'font-bold', :text => /#{sub_category_name}/i).wait_until_present
    
    # Clicks on the first displayed article in the list
    if @BROWSER.div(:class, %w(slick-slide slick-active)).present?
      first_article = @BROWSER.div(:class, %w(slick-slide slick-active)).div(:class, 'article-tile-shadow')
    else
      first_article = @BROWSER.div(:class, 'article-tile-shadow')
    end

    first_article.wait_until_present
    first_article.hover
    first_article.div(:class, %w(font-bold size-lg)).wait_until_present

    @ARTICLE_TITLE = @BROWSER.div(:class, %w(font-bold size-lg)).text
    puts "Article title is #{@ARTICLE_TITLE}"
    
    @BROWSER.div(:class, %w(font-bold size-lg)).fire_event('click')
    @BROWSER.div(:class, 'eap-container').div(:text, /#{@ARTICLE_TITLE}/).wait_until_present
    @BROWSER.div(:class, 'eap-container').div(:class, 'hide-print').span.div.span.wait_until_present
    @BROWSER.div(:class, 'eap-container').div(:class, 'hide-print').span.div.span.click
    @BROWSER.div(:text, /#{HERMES_STRINGS["employee_assistance"]["home_title_featured_articles"]}/).wait_until_present
  end

  # Opens an article by performing a search using @ARTICLE_TITLE string assigned in the above method
  def open_an_article_by_searching
    @BROWSER.input(:class, %w(search-input-transition source-sans)).send_keys  @ARTICLE_TITLE
    @BROWSER.i(:class, 'icon-web_search').click
    @BROWSER.div(:class, 'font-bold').wait_until_present
    @BROWSER.div(:class, %w(font-bold size-lg)).wait_until_present
    @BROWSER.div(:class, %w(font-bold size-lg)).click
    @BROWSER.div(:class, 'eap-container').div(:text , /#{@ARTICLE_TITLE}/).wait_until_present
  end 

  # Open external pages after clicking GOTO button displayed in Health Library, Legal Services and Wellness Tools pages
  def go_to_external_page
    @BROWSER.div(:class => 'btn', :index => 0).wait_until_present

    if @BROWSER.div(:class => 'btn', :index => 1).present?
      #Clicking the second button displayed as the first one is validated in the visible method
      @BROWSER.div(:class => 'btn', :index => 1).click
    else
      @BROWSER.div(:class => 'btn', :index => 0).click
    end

    #Add wait_until_present    
    #TODO - Added below sleep only for Wellness because of this defect / RA-7994, remove the below logic when this defect is fixed
    if (@BROWSER.div(:class => 'title-velocity-hook',:text => HERMES_STRINGS["components"]["main_menu"]["wellness_tools"])).exist?
      sleep(4)
    end  
  end

  # @param categories_to_select
  # @param topics_to_select
  # Selects x amount of Wellness categories and Wellness topics. Verifies that you cant exceed the max amount of categories/topics
  def select_wellness_categories (categories_to_select, topics_to_select)
    category_css_helpers = Array.new
    category_css_helpers[0] = "div[style^='text-align: left; position: relative;']"
    category_css_helpers[1] = "div[style^='display: table-cell; vertical-align: middle;']"
    category_css_helpers[2] = "div[style^='font-size: 14px; display: inline-block; vertical-align: middle; margin-left: 0px; font-weight: normal;']"

    categories_to_select = categories_to_select.to_i
    
    exceeded_max_selection_error_msg = "#{HERMES_STRINGS["wellness_categories"]["category_selection_limit"].gsub('%{limit}', "#{categories_to_select}")}"

    @BROWSER.img(:src, /category-images/).wait_until_present
    number_of_visible_categories = @BROWSER.imgs(:src, /category-images/).count

    # Selects x amount of random categories
    random_category_array = (0..number_of_visible_categories - 1).to_a.sample(categories_to_select + 1)
    random_category_array.each_with_index do |i, index|
      @BROWSER.img(:src => /category-images/, :index => i).wait_until_present
      @BROWSER.img(:src => /category-images/, :index => i).fire_event('click')

      if index == random_category_array.size - 1
        @BROWSER.p(:text, exceeded_max_selection_error_msg).wait_until_present
        @BROWSER.p(:text, exceeded_max_selection_error_msg).wait_while_present
      elsif @BROWSER.p(:text, exceeded_max_selection_error_msg).present?
        fail(msg = 'Error. select_wellness_categories. User is not able to select the max amount of categories')
      end
    end

    @BROWSER.button(:text, HERMES_STRINGS["wellness_categories"]["action_banner_next"]).click
    is_visible('Select your relevant topics')
    Watir::Wait.until { @BROWSER.imgs(:src, /category-images/).count == categories_to_select}
    number_of_visible_topics = @BROWSER.element(css: category_css_helpers[0]).elements(css: category_css_helpers[1]).count

    # Selects an amount of random topics/categories set by the categories_to_select variable + 1 extra topic on top of this
    # This validates that the when the extra topic/categories is selected, we expect to see a categories exceeded error msg.
    random_category_array = (0..number_of_visible_topics -1).to_a.sample(categories_to_select + 1)
    random_category_array.each_with_index do |i, index|
      @BROWSER.element(css: category_css_helpers[0]).element(css: category_css_helpers[1], :index => i).wait_until_present
      @BROWSER.element(css: category_css_helpers[0]).element(css: category_css_helpers[1], :index => i).fire_event('click')
      
      if index == random_category_array.size - 1
        @BROWSER.p(:text, exceeded_max_selection_error_msg).wait_until_present
        @BROWSER.p(:text, exceeded_max_selection_error_msg).wait_while_present
      elsif @BROWSER.p(:text, exceeded_max_selection_error_msg).present?
        fail(msg = 'Error. select_wellness_categories. User is not able to select the max amount of allowed categories.')
      end 
    end

    @BROWSER.button(:text, HERMES_STRINGS["wellness_categories"]["action_banner_next"]).wait_until_present
    @BROWSER.button(:text, HERMES_STRINGS["wellness_categories"]["action_banner_next"]).click
    
    if categories_to_select > 1
      is_visible('Select First Topic')
      # Validates that the number of visible topics/categories matches the number that were selected by the user
      Watir::Wait.until { @BROWSER.elements(css: category_css_helpers[2]).count == categories_to_select }
      @BROWSER.element(css: category_css_helpers[2], :index => 0).wait_until_present
      @BROWSER.element(css: category_css_helpers[2], :index => 0).click
      @BROWSER.element(css: category_css_helpers[2], :index => 0).wait_while_present
    end
  end

  # Returns the snackable button name eg 'Read, Listen or 'Watch' now
  def determine_article_type (continue_snack = false)
    @BROWSER.div(:class, %w(size-lg font-bold)).wait_until_present
    @BROWSER.div(:class => 'size-sm', :text => HERMES_STRINGS["feed"]["wellness_post"]["your_daily_wellbeing"]).wait_until_present
    
    continue_snack ? (read_snack = 'continue_reading') && (watch_snack = 'continue_watching') && (listen_snack = 'continue_listening') : 
    (read_snack = 'read_now') && (watch_snack = 'watch_now') && (listen_snack = 'listen_now')

    if @BROWSER.button(:text, HERMES_STRINGS["feed"]["wellness_post"]["#{read_snack}"]).present? 
      @SNACK_TYPE = read_snack
    elsif @BROWSER.button(:text, HERMES_STRINGS["feed"]["wellness_post"]["#{watch_snack}"]).present?
      @SNACK_TYPE = watch_snack
    elsif @BROWSER.button(:text, HERMES_STRINGS["feed"]["wellness_post"]["#{listen_snack}"]).present?
      @SNACK_TYPE = listen_snack
    else 
      fail(msg= 'Error. determine_article_type. Link to snack is not present')
    end
    
    return @SNACK_TYPE
  end

  # @param max_sessions
  # @param like_article
  # Verifies that you can only view x amount of snackable articles per day
  def verify_snackable_session_limit (max_sessions, like_article = true)
    
    like_article ? like_article = 'up' : like_article = 'down'
    article_name_array = Array.new
    max_sessions = max_sessions.to_i

    for i in 1..max_sessions do
      @BROWSER.div(:class, %w(size-lg font-bold)).wait_until_present      
      @BROWSER.div(:class => 'size-sm', :text => HERMES_STRINGS["feed"]["wellness_post"]["your_daily_wellbeing"]).wait_until_present
      
      if i > 1
        click_button('Next Snack')
      end

      click_button('Get Snack')
      article_name_array.push @ARTICLE_NAME

      # Like/dislike article window will not appear if page is zoomed out. This should be fixed with planned refactor of this functionality. Then the below can be uncommented
      # @BROWSER.execute_script("window.scrollBy(0,5000)")
      # @BROWSER.i(:class, 'icon-thumbs-up').wait_until_present
      # @BROWSER.i(:class, 'icon-thumbs-down').wait_until_present
      # @BROWSER.i(:class, "icon-thumbs-#{like_article}").click
      # @BROWSER.i(:class, "icon-thumbs-#{like_article}").wait_while_present

      @BROWSER.i(:class, 'icon-web_arrow_left').wait_until_present
      @BROWSER.i(:class, 'icon-web_arrow_left').click

      if i == max_sessions
        if max_sessions < 4 
          article_name_array.each do |article_name|
            @BROWSER.div(:class => 'flag__body', :text => @ARTICLE_NAME).wait_until_present
          end
        else
          for i in 0..1
            @BROWSER.div(:class => 'flag__body', :text => article_name_array[i]).wait_until_present
          end

          @BROWSER.div(:class => 'flag__body', :text => "#{max_sessions - 2} #{HERMES_STRINGS["feed"]["wellness_post"]["other_sessions"]}").wait_until_present
        end

        @BROWSER.div(:class => %w(size-lg font-bold), :text => HERMES_STRINGS["feed"]["wellness_post"]["session_completed_limit_reached"]).wait_until_present

        # The block below will check that the correct days are displayed and prdered correctly on the snackable session limit timeline
        days_array = HERMES_STRINGS["feed"]["wellness_post"]["days"]
        days_string = days_array["today"]
        days_array.delete("yesterday")
        days_array.delete("tomorrow")
        days_array.delete("today")
        todays_day_array_index = days_array.keys.index("#{Time.now.strftime("%A").downcase}")
  
        for i in 1..6
          days_string = "#{days_array.values[todays_day_array_index - i][0..2]}" + "\n" + days_string
        end
        
        Watir::Wait.until { @BROWSER.element(css: "div[style^='height: 70px;']").text.include? days_string }
      end
    end
  end

  # @params set_another_interest
  # Verifies re_engagement functionality for snackable. Eg You can re set topics if you skip an article 3 times
  def verify_re_engagement (set_another_interest)
    for i in 1..3 do            
      click_button('Get Snack')
      @BROWSER.div(:id, 'feed').wait_until_present
      @BROWSER.div(:id, 'feed').click
      @BROWSER.button(:text, HERMES_STRINGS["feed"]["wellness_post"]["#{determine_article_type(true)}"]).wait_until_present
      click_button('Skip')

      if i < 3
        @BROWSER.div(:class, %w(size-lg font-bold)).wait_until_present
        Watir::Wait.until { !@BROWSER.div(:class, %w(size-lg font-bold)).text.include? @ARTICLE_NAME }
      else
        Watir::Wait.until { !@BROWSER.div(:class, %w(size-lg font-bold)).present? }
        @BROWSER.div(:text, /#{HERMES_STRINGS["feed"]["wellness_post"]["skipped_session"]["focus_on_another_interest"]}/).wait_until_present
        @BROWSER.div(:text, /#{HERMES_STRINGS["feed"]["wellness_post"]["skipped_session"]["you_have_skipped"]} #{i} #{HERMES_STRINGS["feed"]["wellness_post"]["skipped_session"]["sessions"]}/).wait_until_present
        @BTN_SET_ANOTHER_INTEREST.wait_until_present 
        @BTN_NO_CONTINUE.wait_until_present 
        
        if set_another_interest 
          click_button('Set Another Interest')
        else
          click_button('No, Continue')
          @ARTICLE_NAME = @BROWSER.div(:class, %w(size-lg font-bold)).text
          click_button('Get Snack')
        end
      end
    end
  end

  # @param = times_to_retake_assessment
  # This method Will complete each assessment in an assessment group if user is limited/personal
  # If the user is shared, then only 1 assessment will be completed regardless of how many assessments are in the group
  def complete_assessment_series (times_to_retake_assessment)
    @TIMES_TO_RETAKE_CURRENT_ASSESSMENT = times_to_retake_assessment

    ($ACCOUNT_TYPE == 'shared') ? @TOTAL_ASSESSMENTS_IN_GROUP = 1 : nil

    @TOTAL_ASSESSMENTS_IN_GROUP.times do
      complete_current_assessment
      retake_assessment
      check_assessment_results_page
      check_assessment_homepage_when_assessment_complete
    end
  end

  # Fully or partially complete and submit a wellbeing assessment
  # @param = assessment_completed_once
  def complete_current_assessment (assessment_completed_once = false)
    @MENU_BAR = HermesMenusPage.new @BROWSER

    # If we are retaking a completed assessment, we do not have to execute the block below
    if !assessment_completed_once
      start_or_resume_assessment
    end
    
    @ASSESSMENT_PARTIALLY_COMPLETED = [true, false].sample

    # The loop below will keep calling the answer_assessment_question method until there are no more questions to answer
    while !@BROWSER.div(:text, HERMES_STRINGS["self_assessment"]["complete"]).present?

      # If half the questions in the assessment have been answered and partially_complete_assessment = true, then run this block
      if (@CURRENT_ASSESSMENT_QUESTION_TOTAL / 2 == @BROWSER.element(css: @LABEL_ASSESSMENT_QUESTION_NUMBER).text.to_i) && (@ASSESSMENT_PARTIALLY_COMPLETED)
        @CURRENT_ASSESSMENT_LAST_QUESTION_NUMBER = @BROWSER.element(css: @LABEL_ASSESSMENT_QUESTION_NUMBER).text.to_i
        @MENU_BAR.click_button('Life')
        @MENU_BAR.click_button('Assessments')
        # false = resume assessment / true = start new_assessment
        start_or_resume_assessment(false)
      end

      answer_assessment_question
    end

    click_button('Submit Assessment')
    @ASSESSMENT_PARTIALLY_COMPLETED = false
  end

  # Retake the current assessment the amt of times specified in the scenario
  def retake_assessment
    # If the specified amount of times to complete the current assessment is 0, then do not start retaking the current assessment. 
    if @TIMES_TO_RETAKE_CURRENT_ASSESSMENT > 0
      @TIMES_TO_RETAKE_CURRENT_ASSESSMENT.times do 
        @BROWSER.a(:text, HERMES_STRINGS["self_assessment_2"]["retake_assessment"]).wait_until_present
        @BROWSER.a(:text, HERMES_STRINGS["self_assessment_2"]["retake_assessment"]).fire_event('click')
        is_visible('Begin Wellbeing Assessment')
        click_button('Begin Assessment')
        # complete_current_assessment is called and assessment_completed_once is set to 'true' so start_or_resume_assessment is not run in the complete_current_assessment method
        complete_current_assessment(true)   
      end
    end   

    ($ACCOUNT_TYPE == 'shared') ? nil : @ASSESSMENTS_LEFT_TO_COMPLETE_IN_GROUP = @ASSESSMENTS_LEFT_TO_COMPLETE_IN_GROUP - 1
  end

  # The 'Assessment Group name', 'Total Amt of assessments in the group' and the 'assessments_left_to_complete_in_group' are assigned to variables
  def get_assessment_group_details
    @BROWSER.div(:text, HERMES_STRINGS["self_assessment_2"]["title"]).wait_until_present
    Watir::Wait.until { @BROWSER.element(css: @ASSESSMENT_GROUP_SECTION).div.text.length > 0 }
    @ASSESSMENT_GROUP_NAME = @BROWSER.element(css: @ASSESSMENT_GROUP_SECTION).div.text
    @TOTAL_ASSESSMENTS_IN_GROUP = @BROWSER.element(css: @ASSESSMENT_GROUP_SECTION).div(:index, 1).text.to_i
    @ASSESSMENTS_LEFT_TO_COMPLETE_IN_GROUP = @TOTAL_ASSESSMENTS_IN_GROUP
  end

  # Gets Stores the name and index value of the next incomplete assessment in the group
  def get_new_current_assessment
    @LABEL_MORE_ASSESSMENTS = @BROWSER.h3(:text, 'More Assessments')
    assessments_that_can_be_completed =  @LABEL_MORE_ASSESSMENTS.parent.imgs.count - 1

    for i in 0..assessments_that_can_be_completed
      # Grab the assessment name and index of the first assessment in the list with a 'Start' button
      if @LABEL_MORE_ASSESSMENTS.parent.img(:index, i).parent.parent.span(:text, HERMES_STRINGS["self_assessment_2"]["start"]).present?
        @CURRENT_ASSESSMENT_NAME = @LABEL_MORE_ASSESSMENTS.parent.img(:index, i).parent.parent.element(css: "div[style^='color: rgb(33, 33, 33); font-size: 20px;']").text
        @CURRENT_ASSESSMENT_INDEX = i
        @CURRENT_ASSESSMENT_QUESTION_TOTAL = @LABEL_MORE_ASSESSMENTS.parent.img(:index, i).parent.parent.element(css: "div[style^='color: rgb(166, 166, 166); font-size: 18px;']").text.to_i
        @LABEL_MORE_ASSESSMENTS.parent.img(:index, 0).parent.parent.div(:text, @CURRENT_ASSESSMENT_NAME).parent.parent.parent.span(:text, HERMES_STRINGS["self_assessment_2"]["start"]).wait_until_present
        puts "Starting new assessment = '#{@CURRENT_ASSESSMENT_NAME}', which has #{@CURRENT_ASSESSMENT_QUESTION_TOTAL} questions"
        break
      elsif i == assessments_that_can_be_completed
        fail(msg = 'Error. is_visible. Unable to find the next available assessment that has not been started in the assessment list')
      end
    end
  end

  # If the current assessment has just been completed, this method will check the assessment homepage and pass true in to the current_assessment_complete argument
  def check_assessment_homepage_when_assessment_complete
    if !@BROWSER.div(:text, HERMES_STRINGS["self_assessment_2"]["title"]).present?
      @MENU_BAR.click_button('Life')
      @MENU_BAR.click_button('Assessments')
      @BROWSER.div(:text, HERMES_STRINGS["self_assessment_2"]["title"]).wait_until_present
    end

    # If the user is a shared account, then do not run the check_assessment_list_is_sorted method
    ($ACCOUNT_TYPE == 'shared') ?  nil : check_assessment_list_is_sorted
    check_assessment_homepage(true)
  end

  # Checks that on the assessment homepage, the list of assessments is sorted correctly.
  # 1) In Progress 2) Completed, 3) Not started 4) Assessments not part of the main group
  def check_assessment_list_is_sorted
    for i in 0..@TOTAL_ASSESSMENTS_IN_GROUP - 1
      # Check that the current assessment that was just completed is displayed first in the assessment list along with the assessment result info
      if i == 0
        @LABEL_COMPLETED_ASSESSMENTS = @BROWSER.h3(:text, 'Completed assessments')
        @LABEL_COMPLETED_ASSESSMENTS.parent.img(:index, i).parent.parent.parent.span(:text, HERMES_STRINGS["self_assessment_2"]["view_results"]).wait_until_present
        @LABEL_COMPLETED_ASSESSMENTS.parent.img(:index, i).parent.parent.div(:text, @CURRENT_ASSESSMENT_NAME).wait_until_present
        @LABEL_COMPLETED_ASSESSMENTS.parent.img(:index, i).parent.parent.div(:text, @CURRENT_ASSESSMENT_ADVICE).wait_until_present
        @LABEL_COMPLETED_ASSESSMENTS.parent.img(:index, i).parent.parent.div(:text, @CURRENT_ASSESSMENT_STRENGTH).wait_until_present
      elsif i <= (@TOTAL_ASSESSMENTS_IN_GROUP - 1) - (@ASSESSMENTS_LEFT_TO_COMPLETE_IN_GROUP)
        # If there are anymore completed assessments these assessments should be ordered above assessment that have not yet been started 
        @LABEL_COMPLETED_ASSESSMENTS.parent.img(:index, i).parent.parent.parent.span(:text, HERMES_STRINGS["self_assessment_2"]["view_results"]).wait_until_present
      else
      # If an assessment has not been started yet, these should be ordered below completed assessments in the assessment list
        @BROWSER.h3(:text, 'More Assessments').parent.img(:index, i).parent.parent.parent.span(:text, HERMES_STRINGS["self_assessment_2"]["start"]).wait_until_present
      end
    end
  end

  # @param = start_new_assessment
  def start_or_resume_assessment (start_new_assessment = true)
    is_visible('Assessment Homepage')

    # If start_new_assessment = true, get the next incomplete assessment in the list and navigate as far as clicking the begin assessment button
    if start_new_assessment
      get_new_current_assessment
      check_assessment_homepage
      click_button('Start or resume assessment')
      click_button('Begin Assessment')
    else
      # A shared account user will never be able to resume a partially completed assessment
      ($ACCOUNT_TYPE == 'shared') ? @ASSESSMENT_PARTIALLY_COMPLETED = false : nil
      check_assessment_homepage
      click_button('Start or resume assessment')
      ($ACCOUNT_TYPE == 'shared') ? click_button('Begin Assessment') : nil
    end
  end

  # @param = current_assessment_complete
  # Depending on the the stage of the current assessment/user_type or number of assessments completed, check the buttons are labelled correctly on the assessment homepage
  def check_assessment_homepage (current_assessment_complete = false)
    @ASSESSMENTS_LEFT_TO_COMPLETE_IN_GROUP == 1 ? assessments_to_complete_text = @ASSESSMENTS_TO_COMPLETE[1] : assessments_to_complete_text = @ASSESSMENTS_TO_COMPLETE[3]
    is_visible('Assessment Homepage')

    # If assessment has been partially completed then resume assessment buttons should be displayed
    if @ASSESSMENT_PARTIALLY_COMPLETED
      @ASSESSMENT_GROUP_BTN = HERMES_STRINGS["self_assessment_2"]["continue_assessment"]
      @ASSESSMENT_LIST_BTN = HERMES_STRINGS["self_assessment_2"]["resume"]
      @ASSESSMENT_LIST = @BROWSER.h3(:text, 'Assessments in progress')
      @CURRENT_ASSESSMENT_INDEX = 0
      Watir::Wait.until{ @BROWSER.element(css: @ASSESSMENT_LAST_COMPLETED_TIME).text.include? "#{@ASSESSMENTS_LEFT_TO_COMPLETE_IN_GROUP} #{assessments_to_complete_text}" }
    # If no assessments has been started or the usertype == shared, then only 'start assessment' buttons should be displayed
    elsif ($ACCOUNT_TYPE == 'shared') || (@ASSESSMENTS_LEFT_TO_COMPLETE_IN_GROUP == @TOTAL_ASSESSMENTS_IN_GROUP) 
       @ASSESSMENT_GROUP_BTN = HERMES_STRINGS["self_assessment_2"]["start_assessment"]
       @ASSESSMENT_LIST_BTN = HERMES_STRINGS["self_assessment_2"]["start"]
       @ASSESSMENT_LIST = @BROWSER.h3(:text, 'More Assessments')
       @BROWSER.element(css: @ASSESSMENT_LAST_COMPLETED_TIME).wait_until_present
       Watir::Wait.until{ @BROWSER.element(css: @ASSESSMENT_LAST_COMPLETED_TIME).text.include? "#{@ASSESSMENTS_LEFT_TO_COMPLETE_IN_GROUP} #{assessments_to_complete_text}" }
      
      if @BROWSER.div(:text, HERMES_STRINGS["self_assessment_2"]["view_results"]).present? || @BROWSER.div(:text, HERMES_STRINGS["self_assessment_2"]["resume"]).present?
        fail(msg = 'Error. check_assessment_homepage. View results button should not be displayed')
      end
    elsif @ASSESSMENTS_LEFT_TO_COMPLETE_IN_GROUP == 0
      @ASSESSMENT_GROUP_BTN = HERMES_STRINGS["self_assessment_2"]["view_results"] 
      @ASSESSMENT_LIST_BTN = HERMES_STRINGS["self_assessment_2"]["view_results"]
      @ASSESSMENT_LIST = @BROWSER.h3(:text, 'Completed assessments')
      @BROWSER.element(css: @ASSESSMENT_LAST_COMPLETED_TIME).text.include? 'a minute ago'
      @CURRENT_ASSESSMENT_INDEX = 0
    elsif @ASSESSMENTS_LEFT_TO_COMPLETE_IN_GROUP < @TOTAL_ASSESSMENTS_IN_GROUP
      @BROWSER.element(css: @ASSESSMENT_LAST_COMPLETED_TIME).wait_until_present
      Watir::Wait.until{ @BROWSER.element(css: @ASSESSMENT_LAST_COMPLETED_TIME).text.include? "#{@ASSESSMENTS_LEFT_TO_COMPLETE_IN_GROUP} #{assessments_to_complete_text}" }
      @ASSESSMENT_GROUP_BTN = HERMES_STRINGS["self_assessment_2"]["continue_assessment"]
      current_assessment_complete ? (@ASSESSMENT_LIST_BTN = HERMES_STRINGS["self_assessment_2"]["view_results"]) && (@CURRENT_ASSESSMENT_INDEX = 0) && (@ASSESSMENT_LIST = @LABEL_COMPLETED_ASSESSMENTS) : (@ASSESSMENT_LIST_BTN = HERMES_STRINGS["self_assessment_2"]["start"]) && (@ASSESSMENT_LIST = @LABEL_MORE_ASSESSMENTS)
    end
    
    @BROWSER.element(css: @ASSESSMENT_GROUP_SECTION).div(:text, @ASSESSMENT_GROUP_NAME).parent.div(:text, @ASSESSMENT_GROUP_BTN).wait_until_present
    @ASSESSMENT_LIST.parent.img(:index, @CURRENT_ASSESSMENT_INDEX).parent.parent.div(:text, @CURRENT_ASSESSMENT_NAME).parent.parent.parent.span(:text, @ASSESSMENT_LIST_BTN).wait_until_present 
  end

  # Checks that the assessment results page is displayed correctly and that the assessment history results pages are appearing/are displayed correctly as well
  def check_assessment_results_page
    @LABEL_COMPLETED_ASSESSMENTS = @BROWSER.h3(:text, 'Completed assessments')
    # Capture 'assessment advice' & 'assessment strength'
    @BROWSER.div(:text, HERMES_STRINGS["self_assessment_2"]["assessment_complete"]).parent.div(:index, 1).wait_until_present
    @CURRENT_ASSESSMENT_ADVICE = @BROWSER.div(:text, HERMES_STRINGS["self_assessment_2"]["assessment_complete"]).parent.div(:index, 1).text
    @CURRENT_ASSESSMENT_STRENGTH = @BROWSER.element(css: @ASSESSMENT_STRENGTH).text

    check_assessment_advice_carousel
       
    # If the current assessment has been taken more than once, then the Assessment history section should appear on the view results page. If it has been taken only once, then this should not appear as there are not historical results to view
    if ($ACCOUNT_TYPE != 'shared') && (@TIMES_TO_RETAKE_CURRENT_ASSESSMENT > 0)
      @BROWSER.h3(:text, HERMES_STRINGS["self_assessment_2"]["assessment_history"]).wait_until_present
      Watir::Wait.until { @BROWSER.h3(:text, HERMES_STRINGS["self_assessment_2"]["assessment_history"]).parent.divs(:class, 'article-tile-shadow').count == (@TIMES_TO_RETAKE_CURRENT_ASSESSMENT) }

      # Iterates through the previously taken assessment history links for each completed assessment. User should see the results page for the the assessment result that was clicked on
      for i in 0..(@TIMES_TO_RETAKE_CURRENT_ASSESSMENT - 1)
        @BROWSER.h3(:text, HERMES_STRINGS["self_assessment_2"]["assessment_history"]).parent.div(:class => 'article-tile-shadow', :index => i).p(:text, @CURRENT_ASSESSMENT_NAME).wait_until_present
        @BROWSER.h3(:text, HERMES_STRINGS["self_assessment_2"]["assessment_history"]).parent.div(:class => 'article-tile-shadow', :index => i).a(:text, HERMES_STRINGS["self_assessment_2"]["view_results"]).wait_until_present
        @BROWSER.h3(:text, HERMES_STRINGS["self_assessment_2"]["assessment_history"]).parent.div(:class => 'article-tile-shadow', :index => i).a(:text, HERMES_STRINGS["self_assessment_2"]["view_results"]).fire_event('click')
        # Assessment history should not be displayed on the view results page unless you are viewing the results of the most recently taken assessment
        Watir::Wait.until(nil,'Error. is_visible. Assessment history is visible') { !@BROWSER.h3(:text, HERMES_STRINGS["self_assessment_2"]["assessment_history"]).present? }
        is_visible('Assessment Results')
        @BROWSER.span(:text, HERMES_STRINGS["self_assessment_2"]["back_home"]).wait_until_present
        @BROWSER.span(:text, HERMES_STRINGS["self_assessment_2"]["back_home"]).click
        @BROWSER.span(:text, HERMES_STRINGS["self_assessment_2"]["back_home"]).wait_while_present
        @LABEL_COMPLETED_ASSESSMENTS.parent.img(:index, 0).parent.parent.div(:text, @CURRENT_ASSESSMENT_NAME).parent.parent.parent.span(:text, HERMES_STRINGS["self_assessment_2"]["view_results"]).wait_until_present
        @BROWSER.refresh
        sleep(3)
        @LABEL_COMPLETED_ASSESSMENTS.parent.img(:index, 0).parent.parent.div(:text, @CURRENT_ASSESSMENT_NAME).parent.parent.parent.span(:text, HERMES_STRINGS["self_assessment_2"]["view_results"]).wait_until_present
        @LABEL_COMPLETED_ASSESSMENTS.parent.img(:index, 0).parent.parent.div(:text, @CURRENT_ASSESSMENT_NAME).parent.parent.parent.span(:text, HERMES_STRINGS["self_assessment_2"]["view_results"]).click
        is_visible('Assessment Results')
      end

    else
      puts "$ACCOUNT_TYPE = #{$ACCOUNT_TYPE}"
      Watir::Wait.until(nil,'Error. is_visible. Assessmenƒt history is visible') { !@BROWSER.h3(:text, HERMES_STRINGS["self_assessment_2"]["assessment_history"]).present? } 
    end
  end

  # If the 'doing well' or 'Area for improvement' sections are present, check text exists in each category and swipe functionality works
  def check_assessment_advice_carousel
    for i in 1..2
      if i == 1 ? section_name = HERMES_STRINGS["self_assessment_2"]["feedback_positive"] : section_name = HERMES_STRINGS["self_assessment"]["feedback_improvement"]
        if @BROWSER.div(:text, section_name).present?
          Watir::Wait.until { @BROWSER.div(:text, section_name).parent.elements(css: @ASSESSMENT_ADVICE).count > 0 }
          assessment_category_count = @BROWSER.div(:text, section_name).parent.elements(css: @ASSESSMENT_ADVICE).count
          Watir::Wait.until { @BROWSER.div(:text, section_name).parent.elements(css: @ASSESSMENT_ADVICE).count == assessment_category_count }
          Watir::Wait.until { @BROWSER.div(:text, section_name).parent.div(:class, %w(slick-slide slick-active)).text.length > 0 }
          
          if assessment_category_count > 1
            for i in 1..assessment_category_count -1 do    
              if i == 1
                category_text = @BROWSER.div(:text, section_name).parent.div(:class, %w(slick-slide slick-active)).text
              else
                category_text = @BROWSER.div(:text, section_name).parent.divs(:class, %w(slick-slide slick-active)).last.text
              end

              @BROWSER.div(:text, section_name).parent.div(:class, %w(slick-slide slick-active)).send_keys :arrow_right
              sleep(1)
              Watir::Wait.until { @BROWSER.div(:text, section_name).parent.divs(:class, %w(slick-slide slick-active)).last.text != category_text }
              Watir::Wait.until { @BROWSER.div(:text, section_name).parent.divs(:class, %w(slick-slide slick-active)).last.text.length > 0 }
            end
          end
        end
      end
    end
  end

  # Clicks on a random questionnaire answer. For every third question, navigate back to the previous question, then fprward to the current question
  def answer_assessment_question
    @BROWSER.element(css: @LABEL_ASSESSMENT_QUESTION_NUMBER).wait_until_present

    question_number = @BROWSER.element(css: @LABEL_ASSESSMENT_QUESTION_NUMBER).text.to_i
    question_text = @BROWSER.element(css: @LABEL_ASSESSMENT_QUESTION).text
    random_answer = rand(0..@BROWSER.buttons.count - 1)
    
    # For every 3rd question, click the back button and check that the question number decreases by 1 and the question text changes
    # Then click the forward arrow and check that the question number increments by 1 and the question text matches that which was stored in the question text variable
    if question_number % 3 == 0
      # Go back to previous question either using the back link or the back arrow (this is random)
      go_back_one_question = [@BROWSER.img(:src => /back-arrow/, :index => 0),@BROWSER.span(:class, 'icon-web_arrow_left')].sample
      go_back_one_question.wait_until_present
      go_back_one_question.fire_event('click')
     
      Watir::Wait.until { 
        @BROWSER.element(css: @LABEL_ASSESSMENT_QUESTION_NUMBER).text.to_i != question_number - 1
        @BROWSER.element(css: @LABEL_ASSESSMENT_QUESTION).text.length > 1 && @BROWSER.element(css: @LABEL_ASSESSMENT_QUESTION).text != question_text 
      }

      @BROWSER.element(css: @BTN_JUMP_FORWARD_ONE_QUESTION).wait_until_present
      @BROWSER.element(css: @BTN_JUMP_FORWARD_ONE_QUESTION).fire_event('click')
      
      Watir::Wait.until {
        @BROWSER.element(css: @LABEL_ASSESSMENT_QUESTION_NUMBER).text.to_i == question_number
        @BROWSER.element(css: @LABEL_ASSESSMENT_QUESTION).text == question_text
        !@BROWSER.element(css: @BTN_JUMP_FORWARD_ONE_QUESTION).present? 
      }
    end

    @BROWSER.button(:index, random_answer).wait_until_present
    sleep(2)
    puts "Answer chosen for question #{@BROWSER.element(css: @LABEL_ASSESSMENT_QUESTION_NUMBER).text} was -  '#{@BROWSER.button(:index, random_answer).text}'"
    @BROWSER.button(:index, random_answer).click
    Watir::Wait.until { !@BROWSER.div(:text, question_text).present? }

    if @BROWSER.button(:text, HERMES_STRINGS["self_assessment_2"]["view_results"]).present?
      is_visible('Assessment Complete')
    else
      Watir::Wait.until { 
        @BROWSER.element(css: @LABEL_ASSESSMENT_QUESTION).text != question_text
        question_number != @BROWSER.element(css: @LABEL_ASSESSMENT_QUESTION_NUMBER).text.to_i
      }

      @BROWSER.img(:src, /back-arrow/).wait_until_present   
      
      if (@BROWSER.element(css: @LABEL_ASSESSMENT_QUESTION_NUMBER).text.to_i <= question_number.to_i)
        fail(msg = "Error. click_button. #{button}. The current question number is #{@BROWSER.element(css: @LABEL_ASSESSMENT_QUESTION_NUMBER).text} but the previous question number was #{question_number}")
      end  
    end  
  end

end