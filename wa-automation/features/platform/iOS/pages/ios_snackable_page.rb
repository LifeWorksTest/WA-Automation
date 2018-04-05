# -*- encoding : utf-8 -*-
require 'calabash-cucumber/ibase'

class IOSSnackablePage < Calabash::IBase
  BTN_EDIT_PROFILE = "button marked:'#{IOS_STRINGS["WAMEditUserProfileTitle"]}'"
  BTN_NEXT = "label marked:'#{IOS_STRINGS["WAMWBVCOnboardingCategoriesNextButton"]}'"
  BTN_EXPLORE = "label marked:'#{IOS_STRINGS["WAMWBVCOnboardingSummaryStartButtonText"]}'"

  LBL_WELLBEING = "UILabel marked:'Wellbeing'"
  
  def trait	
	LBL_WELLBEING
  end

  def is_visible (page)
  	case page
  	when 'Main'
  	  wait_for(:timeout => 30, :post_timeout => 1){element_exists(LBL_WELLBEING)}
  	  sleep(2)
  	end 	
  end

  def click_button (button)
    case button
    when 'Next'
      wait_for(:timeout => 30){element_exists(BTN_NEXT)}
      flash(BTN_NEXT)
      touch(BTN_NEXT)
      wait_for(:timeout => 10) {element_does_not_exist("button marked:'#{IOS_STRINGS["WAMFoundationCloseKey"]}'")}
    when 'Explore'
      wait_for(:timeout => 30){element_exists(BTN_EXPLORE)}
      flash(BTN_EXPLORE)
      touch(BTN_EXPLORE)
      wait_for(:timout => 30, :post_timeout => 1){element_does_not_exist(BTN_EXPLORE)}
    else
      fail(msg = "Error. click_button. The button #{button} is not defined.")
    end
  end

  # @param categories_to_select
  # @param topics_to_select
  # Selects x amount of Wellness categories and Wellness topics. Verifies that you cant exceed the max amount of categories/topics
  def select_wellness_categories(categories_to_select,topics_to_select)
    categories_to_select = categories_to_select.to_i
    topics_to_select = topics_to_select.to_i

    wait_for(:timeout => 30) {element_exists("* id: 'net.wamapp.wam.Calabash.WAMWBCategoryCell.title'")}
    number_of_visible_categories = query("* id: 'net.wamapp.wam.Calabash.WAMWBCategoryCell.title'").count
    random_category_array = (0..number_of_visible_categories - 1).to_a.sample(categories_to_select + 1)

    if categories_to_select + 1 <= number_of_visible_categories
      i = 0
      random_category_array.each_with_index do |i, index|
        flash("* id: 'net.wamapp.wam.Calabash.WAMWBCategoryCell.title' index:#{i}")
        touch("* id: 'net.wamapp.wam.Calabash.WAMWBCategoryCell.title' index:#{i}")

        if index == random_category_array.size - 1
          wait_for(:timeout => 30, timeout_message: "Could not find OK button") do
            element_exists("UILabel {text CONTAINS '#{IOS_STRINGS["WAMFoundationOkKey"]}'}")
          end
          sleep(0.5)
          touch("UILabel {text CONTAINS '#{IOS_STRINGS["WAMFoundationOkKey"]}'}")
        end
      end
    else
      fail(msg = "Error. select_wellness_categories. categories_to_select - #{categories_to_select} must be less than number_of_visible_categories - #{number_of_visible_categories}")
    end

    click_button('Next')
    scroll('scrollView', :down)
    wait_for_none_animating
    sleep(0.5)
      for i in 1 ..topics_to_select + 1
        wait_poll(:retry_frequency => 0.5, :until_exists => "WAMWBOnboardingSubCategoryCell index:#{i}") do
          scroll("scrollView", :down)
        end

        flash("WAMWBOnboardingSubCategoryCell index:#{i}")
        touch("WAMWBOnboardingSubCategoryCell index:#{i}")
        sleep(1)
      end

      wait_for(:timeout => 60, timeout_message: "Could not find OK button") do
        element_exists("UILabel {text CONTAINS '#{IOS_STRINGS["WAMFoundationOkKey"]}'}")
      end

      touch("UILabel {text CONTAINS '#{IOS_STRINGS["WAMFoundationOkKey"]}'}")

    click_button('Next')
    # = query("UITableViewCellContentView").count

    #if topis_visible == topics_to_select
      click_button('Explore')
      sleep(1)
    #else
      #fail(msg = 'Error. select_wellness_categories. Number of topics visible differs from topics to select')
    #end
  end 
end