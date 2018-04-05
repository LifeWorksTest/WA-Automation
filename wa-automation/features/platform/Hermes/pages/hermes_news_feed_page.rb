# -*- encoding : utf-8 -*-
class HermesNewsFeedPage

  def initialize (browser)
    @file_service = FileService.new
    @BROWSER = browser

    @BTN_GIVE_RECOGNITION = @BROWSER.div(:text, HERMES_STRINGS["feed"]["give_recognition"])
    @BTN_WRITE_NEW_POST = @BROWSER.div(:text, HERMES_STRINGS["feed"]["write_post"])
    @BTN_POST = @BROWSER.button(:class => %w(validate btn), :text => 'Post')
    @BTN_LIKE =  @BROWSER.div(:class => 'flag-icon__body', :text => HERMES_STRINGS["feed"]["action"]["like"])
    @BTN_UNLIKE = @BROWSER.div(:class => 'flag-icon__body', :text => HERMES_STRINGS["feed"]["action"]["liked"])
    @BTN_VIEW_ALL_GROUPS = @BROWSER.div(:text, HERMES_STRINGS["feed"]["subscribed_groups"]["view_all"])
    @BTN_PERSONALISE_YOUR_CONTENT = @BROWSER.a(:text, HERMES_STRINGS["onboarding"]["feed_post"]["cta"].upcase)
    @BTN_CREATE_LIMITED_ACCOUNT = @BROWSER.a(:text, HERMES_STRINGS["limited_account"]["feed_post"]["cta"].upcase)
    @BTN_REFINE_BY = @BROWSER.img(:src, /arrows/)

    @LBL_REFINE_BY = @BROWSER.div(:text, "#{HERMES_STRINGS['components']['dropdown']['label']}:")
  end

  def is_visible
    if $ACCOUNT_TYPE == 'personal'
      @BROWSER.div(:text, HERMES_STRINGS["feed"]["my_news_feed"]).wait_until_present
      $USER_FEATURE_LIST['social_recognition'] ? @BTN_GIVE_RECOGNITION.wait_until_present : Watir::Wait.until { !@BTN_GIVE_RECOGNITION.present? }
      ( $USER_FEATURE_LIST['social_feed_post'] && $USER_FEATURE_LIST['social_colleague_directory'] ) ? @BTN_WRITE_NEW_POST.wait_until_present : Watir::Wait.until { !@BTN_WRITE_NEW_POST.present? }  
    else
    # Checks that user is unable to create a recognition or write a post if they have logged in with a shared or limited account user
      Watir::Wait.until { !@BTN_GIVE_RECOGNITION.present? }
      Watir::Wait.until { !@BTN_WRITE_NEW_POST.present? }
      @BROWSER.div(:id, 'feed').wait_until_present
      @BROWSER.div(:text, HERMES_STRINGS["feed"]["my_news_feed"]).wait_until_present    
      if ($USER_FEATURE_LIST['eap_wellness'])
        if $ACCOUNT_TYPE == 'shared'
          @BTN_CREATE_LIMITED_ACCOUNT.wait_until_present
          Watir::Wait.until { !@BTN_PERSONALISE_YOUR_CONTENT.present? }
        else
          @BTN_PERSONALISE_YOUR_CONTENT.wait_until_present
          Watir::Wait.until { !@BTN_CREATE_LIMITED_ACCOUNT.present? }
        end
      else
        Watir::Wait.until { !@BTN_PERSONALISE_YOUR_CONTENT.present? }
      end
    end
  end      

  def click_button (button)
    @BROWSER.div(:class, %w(preloader velocity-animating)).wait_while_present
    case button
    when 'Refine by'
      @BTN_REFINE_BY.wait_until_present
      
      if !@BTN_REFINE_BY.parent.parent.img(:src, /selected/).present?
        @BTN_REFINE_BY.click
        @BTN_REFINE_BY.parent.parent.img(:src, /selected/).wait_until_present
      end
    when 'View all groups'
      @BTN_VIEW_ALL_GROUPS.wait_until_present
      @BTN_VIEW_ALL_GROUPS.click
      @BTN_VIEW_ALL_GROUPS.wait_while_present
    when 'Give Recognition'
      @BTN_GIVE_RECOGNITION.wait_until_present
      @BTN_GIVE_RECOGNITION.click
      @BROWSER.input(:placeholder, /#{HERMES_STRINGS["feed"]["give_rec"]["choose_coll"]}/).wait_until_present
    when 'Write New Post'
      @BTN_WRITE_NEW_POST.wait_until_present
      @BTN_WRITE_NEW_POST.click
      @BTN_POST.wait_until_present
    when 'Post'
      @BTN_POST.wait_until_present
      @BTN_POST.click
    when 'Recognitions'
      @BTN_RECOGNITIONS.wait_until_present
      @BTN_RECOGNITIONS.click
    when 'Posts'
      @BTN_POSTS.wait_until_present
      @BTN_POSTS.click
    when 'Re-recognise'
      @BROWSER.div(:class => %w(card ng-scope)).div(:class, 'footer').a(:class, 're-recognise').wait_until_present
      @BROWSER.div(:class => %w(card ng-scope)).div(:class, 'footer').a(:class, 're-recognise').click
      @BROWSER.div(:class => %w(card ng-scope)).div(:class, 'footer').a(:class, %w(re-recognise actioned)).span(:text, HERMES_STRINGS["feed"]["action"]["Recognised"]).wait_until_present
    when 'Like'
      @BTN_LIKE.wait_until_present
      @BTN_LIKE.click
      @BTN_UNLIKE.wait_until_present
    when 'Unlike'
      @BTN_UNLIKE.parent.wait_until_present
      @BTN_UNLIKE.parent.fire_event('click')
      @BTN_LIKE.parent.wait_until_present
    when 'Personalise your content'   
      @BTN_PERSONALISE_YOUR_CONTENT.wait_until_present
      @BTN_PERSONALISE_YOUR_CONTENT.click
      @BTN_PERSONALISE_YOUR_CONTENT.wait_while_present
    else
      fail(msg = "Error. click_button. The option #{button} is not defined in menu.")
    end
  end

  def disabled_enabled_features (feature, is_enabled)
    case feature
    when 'Social Recognition'
      if eval(is_enabled)
        @BTN_GIVE_RECOGNITION.wait_until_present
      else
        if @BTN_GIVE_RECOGNITION.present?
          fail(msg = "Error. disabled_enabled_features - #{feature} should be #{state}")
        end
      end
    when 'Like'
      if eval(is_enabled)
        @BTN_LIKE.wait_until_present
      else
        if @BTN_LIKE.present?
          fail(msg = "Error. disabled_enabled_features - #{feature} should be #{state}")
        end
      end
    end
  end

  # Validate grouping functionality
  # @param on_off - grouping feature key is on or off
  def validate_grouping_fuctionlity (on_off)
    if on_off == 'visible'
      @BROWSER.h3(:text, HERMES_STRINGS["feed"]["subscribed_groups"]["my_groups"]).wait_until_present
      @BROWSER.h4(:text, /#{ACCOUNT[:account_1][:valid_account][:group_name_base]}/).wait_until_present
      @BTN_VIEW_ALL_GROUPS.wait_until_present
      click_button('View all groups')
      @BROWSER.div(:class => 'title-velocity-hook', :text => /#{ACCOUNT[:account_1][:valid_account][:group_name_base]}/)
      @BROWSER.div(:class, 'background-transition').div(:text, /#{ACCOUNT[:account_1][:valid_account][:group_name_base]}/).wait_until_present
      @BROWSER.div(:class, 'background-transition').div(:text, /#{ACCOUNT[:account_1][:valid_account][:group_name_base]}/).click
      @BROWSER.div(:class, 'background-transition').div(:text, /#{ACCOUNT[:account_1][:valid_account][:group_name_base]}/).wait_while_present
      @BROWSER.a(:href, /feed\//).wait_until_present
    elsif on_off == 'not visible'
      @BROWSER.h3(:text, HERMES_STRINGS["feed"]["subscribed_groups"]["my_groups"]).wait_while_present
      @BROWSER.h4(:text, /#{ACCOUNT[:account_1][:valid_account][:group_name_base]}/).wait_while_present
      @BTN_VIEW_ALL_GROUPS.wait_while_present
    end
  end

  # Validate if the current user belong to latest group that was created
  # @param belong_or_not - 'belong'/'not belong'
  def validate_user_belong_to_latest_group (belong_or_not)
    @file_service = FileService.new
    latest_group_name = @file_service.get_from_file('latest_group_name:')[0..-2]
    group_counter = @file_service.get_from_file('group_counter:')[0..-2]
    puts "latest_group_name:#{latest_group_name}"
    @BROWSER.h3(:text, HERMES_STRINGS["feed"]["subscribed_groups"]["my_groups"]).wait_until_present

    if belong_or_not == 'belong'
      @BROWSER.h4(:text, /#{ACCOUNT[:account_1][:valid_account][:group_name_base]}#{group_counter[0]}/).wait_until_present
      @BTN_VIEW_ALL_GROUPS.wait_until_present

      click_button('View all groups')
      @BROWSER.span(:text, /#{latest_group_name}/).wait_until_present
      @BROWSER.span(:text, /#{latest_group_name}/).parent.div(:text, /1/).wait_until_present
      @BROWSER.span(:text, /#{ACCOUNT[:account_1][:valid_account][:group_name_base]}/).wait_until_present
      @BROWSER.span(:text, "#{ACCOUNT[:account_1][:valid_account][:group_name_base]}").parent.div(:text, /#{$NUMBER_OF_EMPLOYEES_IN_THE_COMPANY_GROUP}/).exists?

      @BROWSER.span(:text, /#{latest_group_name}/).parent.click
      @BROWSER.div(:class, 'background-transition').span(:text, /#{latest_group_name}/).wait_while_present
      @BROWSER.article(:class, 'search-empty').wait_until_present
    elsif belong_or_not == 'not belong'
      if @BROWSER.h4(:text, /#{latest_group_name}/).exists?
        fail(msg = "Error. validate_user_belong_to_latest_group. The current user shouldn't be part of #{latest_group_name}")
      end

      click_button('View all groups')
      sleep(2)

      @BROWSER.div(:class, 'background-transition').div(:text, /#{ACCOUNT[:account_1][:valid_account][:group_name_base]}/).wait_until_present
      @BROWSER.span(:text, /#{ACCOUNT[:account_1][:valid_account][:group_name_base]}/).parent.div(:text, /#{$NUMBER_OF_EMPLOYEES_IN_THE_COMPANY_GROUP}/).wait_until_present

      if @BROWSER.div(:class, 'background-transition').div(:text, /#{latest_group_name}/).exists?
        fail(msg = "Error. validate_user_belong_to_latest_group. The current user shouldn't be part of #{latest_group_name}")
      end
    end
    
  end

  # Give recognition
  # @param recognition_text 
  # @param badge - badge name
  # @param user_name array of users to mention
  def give_recognition (recognition_text, badge_name, users_name, to_mention = false)
    badge_name = BADGES[:"#{badge_name}"]
    users_name_array = users_name.split(",")
    users_name_array.each do |user_name|
      @BROWSER.input(:placeholder, /#{HERMES_STRINGS["feed"]["give_rec"]["choose_coll"]}/).wait_until_present
      @BROWSER.div(:class, /preloader/).wait_while_present
      @BROWSER.input(:placeholder, /#{HERMES_STRINGS["feed"]["give_rec"]["choose_coll"]}/).click
      sleep(0.5)
      @BROWSER.input(:placeholder, /#{HERMES_STRINGS["feed"]["give_rec"]["choose_coll"]}/).send_keys "#{user_name}"
      @BROWSER.div(:class => 'flag__body', :text => /#{user_name} #{user_name}/).wait_until_present
      sleep(0.5)
      @BROWSER.div(:class => 'flag__body', :text => /#{user_name} #{user_name}/).fire_event('click')
      sleep(0.5)
    end

    @BROWSER.div(:text, HERMES_STRINGS["feed"]["give_rec"]["select"]).wait_until_present
    @BROWSER.div(:text, HERMES_STRINGS["feed"]["give_rec"]["select"]).click
    @BROWSER.div(:text, HERMES_STRINGS["feed"]["give_rec"]["select"]).parent.div(:class => 'flag', :text => /#{badge_name}/).wait_until_present
    @BROWSER.div(:text, HERMES_STRINGS["feed"]["give_rec"]["select"]).parent.div(:class => 'flag', :text => /#{badge_name}/).fire_event('click')
    sleep(0.5)
    user_to_mention_string = ''
    
    if to_mention
      users_name_array.each do |user_name|
        @BROWSER.textarea.wait_until_present
        @BROWSER.textarea.click
        @BROWSER.textarea.send_keys "@#{user_name}"
        @BROWSER.div(:class => 'flag__body', :index => 1, :text => /#{user_name} #{user_name}/).wait_until_present
        @BROWSER.div(:class => 'flag__body', :index => 1, :text => /#{user_name} #{user_name}/).fire_event('click')
        @BROWSER.textarea.send_keys " "
        sleep(0.5)
        user_to_mention_string = "#{user_name} #{user_name}"  + ' '
      end
    end

    @BROWSER.textarea(:placeholder, HERMES_STRINGS["feed"]["give_rec"]["placeholder"]).send_keys "#{recognition_text}"
    sleep(0.5)
    @BROWSER.file_field(:index, 0).wait_until_present
    @BROWSER.file_field(:index, 0).set eval(IMAGE_FILES[:newsfeed][:png])
    @BROWSER.element(css: "div[style^='margin-bottom: 10px; padding-top: 10px; position: relative;']").span(:class, 'icon icon-close').wait_until_present
    Watir::Wait.until { @BROWSER.button(:text, HERMES_STRINGS["feed"]["give_rec"]["btn"]).disabled? != true }
    @BROWSER.button(:text, HERMES_STRINGS["feed"]["give_rec"]["btn"]).click
    puts "Recognition text is:\"#{user_to_mention_string}#{recognition_text}\""
    @BROWSER.div(:class, 'post-module__post__badge-tag___2wLBO').parent.parent.parent.parent.parent.parent.parent.div(:text, /#{HERMES_STRINGS["feed"]["timeline_message"]}/).wait_until_present
    @BROWSER.div(:class => 'post-module__post__badge-tag___2wLBO', :text => /#{BADGES[:"#{$badge_name}"]}/).wait_until_present
    @BROWSER.span(:text, recognition_text).parent.parent.parent.parent.img(:srcset, /image\/upload/).wait_until_present
  end

  # Validate that the recognition is first in the news feed
  def validate_recognition_is_first_in_feed (recognition_text)
    @BROWSER.div(:class, 'break-word').span(:text, recognition_text).wait_until_present
  end

  # Validate that the refine by dropdown list contains the correct options according to user type and feature key enable/disable
  def validate_refine_by_dropdown_list
    click_button('Refine by')
    @LBL_REFINE_BY.parent.div(:text, HERMES_STRINGS['feed']['filter']['everything']).wait_until_present
    
    NEWSFEED_FILTER.each do |filter_type|
      post_type = eval(filter_type[1][:POST_NAME])
      is_enabled = eval(filter_type[1][:FEATURE_KEY_NAME])

      if is_enabled 
        if ( $ACCOUNT_TYPE == 'personal' ) || ( post_type == HERMES_STRINGS['feed']['filter']['company_posts'] )
          @LBL_REFINE_BY.parent.div(:text, eval(filter_type[1][:POST_NAME])).wait_until_present
        else
          Watir::Wait.until { !@LBL_REFINE_BY.parent.div(:text, eval(filter_type[1][:POST_NAME])).present? }
        end
      else
        Watir::Wait.until { !@LBL_REFINE_BY.parent.div(:text, eval(filter_type[1][:POST_NAME])).present? }
      end   
    end
  end

  # Give comment by index of the post, in addition check that the counter is update and that there is the correct amount of comments
  # @param comment_text
  # @param index - post index
  def give_comment (comment_text, index) 
   @BROWSER.button(:class => 'tile__box', :index => 1,:text => /#{HERMES_STRINGS["feed"]["post"]["comment"]}/).wait_until_present
    old_comments_counter = @BROWSER.span(:class => 'text', :index => 1).text.to_i
    @BROWSER.button(:class => 'tile__box', :text => /#{HERMES_STRINGS["feed"]["post"]["comment"]}/).click
    @BROWSER.textarea(:placeholder, HERMES_STRINGS["feed"]["comments"]["placeholder"]).wait_until_present
    @BROWSER.textarea(:placeholder, HERMES_STRINGS["feed"]["comments"]["placeholder"]).fire_event('click')
    @BROWSER.textarea(:placeholder, HERMES_STRINGS["feed"]["comments"]["placeholder"]).send_keys comment_text
    @BROWSER.button(:class => %w(validate btn btn--flat), :text => /#{HERMES_STRINGS["feed"]["comments"]["btn_text"]}/).wait_until_present
    @BROWSER.button(:class => %w(validate btn btn--flat), :text => /#{HERMES_STRINGS["feed"]["comments"]["btn_text"]}/).fire_event('click')
    
    # The line below checks tha tthe comments counter on the recognition has incremented by 1 (as a new commented has been created)
    Watir::Wait.until { @BROWSER.span(:class => 'text', :index => 1).text.to_i == (old_comments_counter + 1) }
    @BROWSER.div(:class, 'flag flag_custom-content').div(:class, 'flag__body').a(:text, ACCOUNT[:"#{$account_index}"][:valid_account][:user_name]).wait_until_present
    @BROWSER.div(:class, 'flag flag_custom-content').div(:class, 'flag__body').span(:text, /#{HERMES_STRINGS["feed"]["timeline_message"]}/).wait_until_present
    @BROWSER.div(:class, 'flag flag_custom-content').div(:class, 'flag__body').div(:text, /#{comment_text}/).wait_until_present

    # click 'View more comments' until all comments are visible
    while @BROWSER.textarea(:placeholder, HERMES_STRINGS["feed"]["comments"]["placeholder"]).parent.parent.parent.parent.parent.parent.parent.parent.div.a(:text, HERMES_STRINGS["feed"]["comments_comp"]["view"]).exists?
      @BROWSER.textarea(:placeholder, HERMES_STRINGS["feed"]["comments"]["placeholder"]).parent.parent.parent.parent.parent.parent.parent.parent.div.a(:text, HERMES_STRINGS["feed"]["comments_comp"]["view"]).click
      sleep(1)
    end 

  end

  # Write post and check that the post is in the feed
  # @param post_text
  def write_post (post_text)
    # upload image to post
    @BROWSER.file_field(:index, 1).wait_until_present
    @BROWSER.file_field(:index, 1).set eval(IMAGE_FILES[:newsfeed][:png])
    @BROWSER.element(css: "div[style^='margin-bottom: 10px; padding-top: 10px; position: relative;']").span(:class, 'icon icon-close').wait_until_present
    @BROWSER.textarea(:placeholder => HERMES_STRINGS["feed"]["new_post"]["placeholder"], :index => 1).wait_until_present
    @BROWSER.textarea(:placeholder => HERMES_STRINGS["feed"]["new_post"]["placeholder"], :index => 1).send_keys "#{post_text}"
    click_button('Post')
    
    # validate that the post text, uploaded image, user name and time as expected
    @BROWSER.div(:class => %w(post-module__tile__username___3Pakb post-module__tile__username--dark___kvcmf), :text => "#{ACCOUNT[:"#{$account_index}"][:valid_account][:user_name]}").wait_until_present
    @BROWSER.div(:class => 'post-module__tile__content___fGbVw', :text => post_text).wait_until_present
    @BROWSER.div(:class => %w(post-module__tile__username___3Pakb post-module__tile__username--dark___kvcmf), :text => 'user0 user0').parent.parent.parent.parent.parent.div(:class, 'post-module__tile__photo--holder___2lPaq').img(:srcset, /image\/upload/).wait_until_present
  end

  # Check if the given post is first feed
  # @param post_text
  def check_if_post_is_first_feed (post_text)
    @BROWSER.div(:class => 'tile__content___ws', :index => 0, :text => /#{post_text}/).exist?
  end

  # Write post with mention and check that the post is in the feed
  # @param @post_text
  def write_post_with_mention (post_text, user_name_to_mention)
    @BROWSER.textarea(:index, 1).wait_until_present
    @BROWSER.textarea(:index, 1).send_keys "#{post_text}"

    users_name_array = user_name_to_mention.split(",")
    users_name_array.each do |user_name|

      @BROWSER.textarea(:index, 1).send_keys ' ' + "@#{user_name}"
      @BROWSER.div(:class => 'flag__body', :text => /#{user_name}/).wait_until_present
      sleep(0.5)
      @BROWSER.div(:class => 'flag__body', :text => /#{user_name}/).fire_event('click')
      sleep(0.5)
      user_name_to_mention = ' ' + "#{user_name}"
    end

    click_button('Post')    
    puts "#{post_text}#{user_name_to_mention}"
    
    # validate that the post text, user name and time as expected
    @BROWSER.div(:class => 'post-module__tile__content___fGbVw', :text => /#{post_text}#{user_name_to_mention}/).wait_until_present
    # @BROWSER.div(:class, 'post-module__post__badge-tag___3X0m5').parent.parent.parent.parent.parent.parent.parent.div(:text, /#{HERMES_STRINGS["feed"]["timeline_message"]}/).wait_until_present
  end

  # Click on button like or unlike on the first post
  # @param @like_or_unlike - 'Like' or 'Unlike'
  def like_or_unlike (like_or_unlike)
    if like_or_unlike == 'Like'
      click_button('Like')
    elsif like_or_unlike == 'Unlike'
      click_button('Unlike')
    end
  end

  def welcome_new_user
    @BROWSER.div(:class, %w(card ng-scope)).div(:class, 'footer').a(:text, HERMES_STRINGS["action"]["welcome"]).wait_until_present
    @BROWSER.div(:class, %w(card ng-scope)).div(:class, 'footer').a(:text, HERMES_STRINGS["action"]["welcome"]).click
    @BROWSER.div(:class, %w(card ng-scope)).div(:class, 'footer').a(:text, HERMES_STRINGS["action"]["welcomed"]).wait_until_present
  end

  def congratulated_user
    post_id = @file_service.get_from_file('post_id:')[0..-2]
    @BROWSER.div(:class => %w(masonry-brick ng-scope loaded), :id => post_id).div(:class, 'tile__footer').button(:text, HERMES_STRINGS["action"]["congratulate"]).wait_until_present
    @BROWSER.div(:class => %w(masonry-brick ng-scope loaded), :id => post_id).div(:class, 'tile__footer').button(:text, HERMES_STRINGS["action"]["congratulate"]).click
    @BROWSER.div(:class => %w(masonry-brick ng-scope loaded), :id => post_id).div(:class => 'tile__activity',:text => /#{HERMES_STRINGS["action"]["modal"]["title_mobile"]["congratulated"]}/).wait_until_present
  end

  def get_badges_list
    @BROWSER.div(:text, HERMES_STRINGS["feed"]["give_rec"]["select"]).wait_until_present
    @BROWSER.div(:text, HERMES_STRINGS["feed"]["give_rec"]["select"]).click
    @BROWSER.div(:class, 'flag__body').wait_until_present
    i = 0
    badges_list = Array.new

    while @BROWSER.div(:class => 'flag__body', :index => i).exist?
      badges_list[i] = (@BROWSER.div(:class => 'flag__body', :index => i).text)
      i = i+1
    end
                                                                                                                                            
    return badges_list
  end

  def validate_badges_state (state)
    badges_list = get_badges_list
    puts "The badge list is: #{badges_list}"
    i = 0
    BADGES.each {|badge_name, badge_hashtag|
                                                                                                                                            
      if i % 2 == 1
        i += 1
        next
      end
      
      i += 1
      if state == 'not visible' && badges_list == ""
        break
      elsif  state == 'visible' && badges_list == ""
          fail(msg = 'Error. List is empty while expecting to see badges')
      end

      if (state == 'visible') && (badge_name == 'Customer Is Always Right')
        if ! badges_list.grep(/Customer Is/).any?
          fail(msg = "Error. Badge #{badge_name} was not found in list")
        end
      elsif state == 'visible'
        if ! badges_list.grep(/#{badge_name}/).any?
          fail(msg = "Error. Badge #{badge_name} was not found in list")
        end
      elsif state == 'not visible'
        if (badges_list.include? badge_name) && (badge_name != BADGE_TO_KEEP[:badge_name])
          fail(msg = "Error. Badge #{badge_name} was found in list")
        end
      end
    }
  end

  def check_if_badge_exists_in_list (badge_name, exists_or_not)
    @BROWSER.input(:placeholder, /#{HERMES_STRINGS["feed"]["give_rec"]["choose_coll"]}/).wait_until_present
    @BROWSER.input(:placeholder, /#{HERMES_STRINGS["feed"]["give_rec"]["choose_coll"]}/).send_keys 'user'
    @BROWSER.li(:class, %w(droplist__item ng-scope droplist__item--active)).wait_until_present
    @BROWSER.li(:class, %w(droplist__item ng-scope droplist__item--active)).click
    @BROWSER.li(:class, %w(droplist__item ng-scope droplist__item--active)).wait_while_present
    @BROWSER.div(:class, %w(droplist droplist--badges)).div.click
    @BROWSER.li.wait_until_present
    @BROWSER.div(:class, %w(droplist droplist--badges)).ul.text

    if exists_or_not == 'exists'
      if ! @BROWSER.div(:class, %w(droplist droplist--badges)).ul.text.include? badge_name
        fail("Error. check_if_badge_exists_in_list. Badge name #{badge_name} was not found in list")
      end
    elsif exists_or_not == 'not_exists'
      if @BROWSER.div(:class, %w(droplist droplist--badges)).ul.text.include? badge_name
        fail("Error. check_if_badge_exists_in_list. Badge name #{badge_name} should not be in list")
      end
    end
  end

  # Check if the given post exist in the 6 first post in the feed
  def check_if_post_exists_in_feed (text)
    puts "check_if_post_exists_in_feed, text to check:#{text}"
    for i in 0..5 
      @BROWSER.div(:class, 'masonry-container').div(:class => %w(masonry-brick ng-scope loaded'), :index => i).wait_until_present
      if @BROWSER.div(:class, 'masonry-container').div(:class => %w(masonry-brick ng-scope loaded'), :index => i, :text => /#{text}/).exists?
        post_id = @BROWSER.div(:class, 'masonry-container').div(:class => %w(masonry-brick ng-scope loaded'), :index => i, :text => /#{text}/).id
        @file_service.insert_to_file('post_id:', post_id)
        return
      end
    end

    fail(msg = "Error. check_if_post_exists_in_feed. The next post (#{text}) was not found")
  end

  # Click on the user name that is shown in the post and wait for his profile to open
  # @param user_name
  def go_to_user_profile_from_post (user_name)
    @BROWSER.a(:class => 'post-module__tile__username___3Pakb', :text => /#{user_name}/).wait_until_present
    @BROWSER.a(:class => 'post-module__tile__username___3Pakb', :text => /#{user_name}/).click
    @BROWSER.h3(:text, user_name).wait_until_present
  end

  def validate_empty_state
    @BROWSER.h4(:text, HERMES_STRINGS["feed"]["empty_network"]["subtitle"]).wait_until_present
    @BROWSER.a(:text, HERMES_STRINGS["feed"]["manage_colleagues"]).wait_until_present
  end

  def verify_uploaded_images
    locale = ACCOUNT[:"#{$account_index}"][:valid_account][:user_locale].downcase.gsub('-', '_').to_sym

    $IMAGE_HASH[locale].each_pair {|key, value| 
      if key.include? 'company_logo'
        puts "company-logo value should be #{value}"
        @BROWSER.div(:class, 'hide-print').img(:src, /#{value}/).wait_until_present
      elsif key.include? 'square_logo'
        puts "company-logo value should be #{value}"
        @BROWSER.element(css: "div[style^='position: absolute; left: 0px; bottom: 20px; color: rgb(255, 255, 255); max-width: 600px; text-align: left;']").img(:src, /#{value}/).wait_until_present
      else
        puts 'cover-image. No assdertions her as the cover image is missing from the dom. Need to investigate'
      end
    }
  end
  
end
