# -*- encoding : utf-8 -*-
class ZeusTimelinePage

  def initialize (browser)
    @BROWSER = browser
    @BTN_POST = @BROWSER.a(:class => %w(btn btn-primary), :text => ZEUS_STRINGS["new_post"]["post_btn"])
    @BTN_MONTHS = @BROWSER.a(:class, 'filter-dropdown__toggle')
  end

  # Check that page element are in the page
  def is_visible
    @BROWSER.h2(:text, /#{ZEUS_STRINGS["post_login"]["timeline"]}/).wait_until_present
    @BROWSER.div(:class, 'panel-heading').span(:text, ZEUS_STRINGS["new_post"]["title"]).wait_until_present
    @BROWSER.div(:class, 'panel-heading').span(:text, ZEUS_STRINGS["new_post"]["title"]).parent.parent.textarea.wait_until_present

    @LBL_ALL
    if @BROWSER.div(:class, 'feed-post-filters').ul.lis.count != 11
      fail(msg = 'Error. is_visible. Expected to see 11 Timeline filters.') 
    end

    @BTN_MONTHS.wait_until_present
  end

  def click_button (button)
    case button
    when 'All posts'
      @BROWSER.label(:class => 'ng-binding', :text => ZEUS_STRINGS["timeline"]["feed_type_filter"]["all_posts"]).wait_until_present
      @BROWSER.label(:class => 'ng-binding', :text => ZEUS_STRINGS["timeline"]["feed_type_filter"]["all_posts"]).click
    when 'User posts'
      @BROWSER.label(:class => 'ng-binding', :text => ZEUS_STRINGS["timeline"]["feed_type_filter"]["user_posts"]).wait_until_present
      @BROWSER.label(:class => 'ng-binding', :text => ZEUS_STRINGS["timeline"]["feed_type_filter"]["user_posts"]).click
      @CONTAINER_NAME = %w(tile feed-post-types-user-post panel panel-post ng-scope)
    when 'Company posts'
      @BROWSER.label(:class => 'ng-binding', :text => ZEUS_STRINGS["timeline"]["feed_type_filter"]["company_posts"]).wait_until_present
      @BROWSER.label(:class => 'ng-binding', :text => ZEUS_STRINGS["timeline"]["feed_type_filter"]["company_posts"]).click
      @CONTAINER_NAME = %w(tile feed-post-types-company-post panel panel-post ng-scope)
    when 'Recognitions'
      @BROWSER.span(:class => 'ng-scope', :text => ZEUS_STRINGS["timeline"]["feed_type_filter"]["recognition"]).wait_until_present
      @BROWSER.span(:class => 'ng-scope', :text => ZEUS_STRINGS["timeline"]["feed_type_filter"]["recognition"]).click
      @CONTAINER_NAME = %w(tile feed-post-types-recognition panel panel-post ng-scope)
    when 'Top performers'
      @BROWSER.label(:class => 'ng-binding', :text => ZEUS_STRINGS["timeline"]["feed_type_filter"]["top_performers"]).wait_until_present
      @BROWSER.label(:class => 'ng-binding', :text => ZEUS_STRINGS["timeline"]["feed_type_filter"]["top_performers"]).click
      @CONTAINER_NAME = %w(tile feed-post-types-most-recognized panel panel-post ng-scope)
    when 'User milestones'
      @BROWSER.label(:class => 'ng-binding', :text => ZEUS_STRINGS["timeline"]["feed_type_filter"]["user_milestones"]).wait_until_present
      @BROWSER.label(:class => 'ng-binding', :text => ZEUS_STRINGS["timeline"]["feed_type_filter"]["user_milestones"]).click
      @CONTAINER_NAME = %w(tile feed-post-types-user-milestone panel panel-post ng-scope)
    when 'New joiners'
      @BROWSER.label(:class => 'ng-binding', :text => 'New joiners').wait_until_present
      @BROWSER.label(:class => 'ng-binding', :text => 'New joiners').click
      @CONTAINER_NAME = %w(tile feed-post-types-user-new panel panel-post ng-scope)
    when 'User years of service'
      @BROWSER.label(:class => 'ng-binding', :text => 'User years of service').wait_until_present
      @BROWSER.label(:class => 'ng-binding', :text => 'User years of service').click
      @CONTAINER_NAME = %w(tile feed-post-types-user-anniversary panel panel-post ng-scope)
    when 'Company anniversary'
      @BROWSER.label(:class => 'ng-binding', :text => 'Company anniversary').wait_until_present
      @BROWSER.label(:class => 'ng-binding', :text => 'Company anniversary').click
      @CONTAINER_NAME = %w(tile feed-post-types-company-anniversary panel panel-post ng-scope)
    when 'Birthdays'
      @BROWSER.label(:class => 'ng-binding', :text => 'Birthdays').wait_until_present
      @BROWSER.label(:class => 'ng-binding', :text => 'Birthdays').click
      @CONTAINER_NAME = %w(tile feed-post-types-user-birthday panel panel-post ng-scope)
    when 'Post'
      @BTN_POST.wait_until_present
      @BTN_POST.click
      @BTN_POST.wait_while_present
    else
      fail(msg = "Error. click_button. The option #{button} is not defined in menu.")
    end
  end

  # Validate all filters
  def check_all_timeline_filters
    check_timeline_filters('User posts')
    check_timeline_filters('Company posts')
    check_timeline_filters('Recognitions')
    check_timeline_filters('Top performers')
    check_timeline_filters('User milestones')
    check_timeline_filters('New joiners')
    check_timeline_filters('User years of service')
    check_timeline_filters('Company anniversary')
    check_timeline_filters('Birthdays')
  end

  # Validate filter results
  def check_timeline_filters (filter_name) 
  @BROWSER.a(:class, 'filter-dropdown__toggle').wait_until_present
  
  # Choose  'Select Period' value of 'All Time' if it is not already selected
  if !@BROWSER.li(:class => %w(filter-dropdown__toggle), :text => ZEUS_STRINGS["timeline"]["date_filter"]["all_time"]).exist?
    @BROWSER.a(:class, 'filter-dropdown__toggle').fire_event('click')
    @BROWSER.li(:class => 'filter-dropdown__item', :text => ZEUS_STRINGS["timeline"]["date_filter"]["all_time"]).wait_until_present
    @BROWSER.li(:class => 'filter-dropdown__item', :text => ZEUS_STRINGS["timeline"]["date_filter"]["all_time"]).fire_event('click')
    Watir::Wait.until { @BROWSER.a(:class => %w(filter-dropdown__toggle), :text => ZEUS_STRINGS["timeline"]["date_filter"]["all_time"]).exist? }
  end

  Watir::Wait.until { @BROWSER.div(:class, %w(spinner full-screen ng-hide)).exist? }
  click_button (filter_name)
  Watir::Wait.until { @BROWSER.div(:class, %w(spinner full-screen ng-hide)).exist? }

  @BROWSER.div(:class, %w(timeline-feed-list-item ng-scope)).wait_until_present
  i = 0

  while @BROWSER.div(:class => %w(timeline-feed-list-item ng-scope), :index => i).present?
    if @BROWSER.div(:class => %w(timeline-feed-list-item ng-scope), :index => i).div(:class, @CONTAINER_NAME).present?
      puts "#{i} - #{filter_name} - Post is correctly filtered"
      i += 1
    else
      fail(msg = "Error. check_timeline_filters. Post index #{i} is not from type - #{filter_name}.") 
    end

    if i > 10
      break
    elsif i % 3 == 0
      @BROWSER.scroll.to :bottom
      sleep(0.3)
    end

  end
  click_button('All posts')
  end

  def check_post_is_first_in_timeline (post_text)
    @BROWSER.div(:class => 'post-module__tile__content___fGbVw', :index => 0, :text => "#{post_text}").wait_until_present
  end                     

  # Send post
  # @param post_text
  def send_new_post (post_text)
    @BROWSER.div(:class, 'panel-heading').span(:text, ZEUS_STRINGS["new_post"]["title"]).wait_until_present
    @BROWSER.div(:class, 'panel-heading').span(:text, ZEUS_STRINGS["new_post"]["title"]).parent.parent.textarea.wait_until_present
    @BROWSER.div(:class, 'panel-heading').span(:text, ZEUS_STRINGS["new_post"]["title"]).parent.parent.textarea.click
    @BROWSER.div(:class, 'public-DraftEditor-content').wait_until_present
    @BROWSER.div(:class, 'public-DraftStyleDefault-block public-DraftStyleDefault-ltr').fire_event('click')
    @BROWSER.div(:class, 'DraftEditor-editorContainer').send_keys post_text
    click_button('Post')
  end

  # Write post with mention and check that the post is in the feed
  # @param @post_text
  def write_post_with_mention (post_text, user_name_to_mention)
    @BROWSER.div(:class, %w(panel panel-primary js-velocity-hook)).textarea.wait_until_present
    @BROWSER.textarea.send_keys "#{post_text}"
        puts "#{post_text} #{user_name_to_mention}"  

    users_name_array = user_name_to_mention.split(",")
    user_name_to_mention = ''
    users_name_array.each do |user_name|
      @BROWSER.textarea.send_keys ' ' + "@#{user_name}"
      @BROWSER.div(:class => 'col-xs-10', :text => "#{user_name} #{user_name}").wait_until_present
      @BROWSER.div(:class => 'col-xs-10', :text => "#{user_name} #{user_name}").click
      @BROWSER.div(:class => 'col-xs-10', :text => "#{user_name} #{user_name}").wait_while_present
    end

    click_button('Post')
    @BROWSER.div(:class, %w(timeline-feed-list-item ng-scope)).p(:text, /#{post_text}/).wait_until_present
    @BROWSER.div(:class, %w(timeline-feed-list-item ng-scope)).span(:class => %w(pull-right small), :text => 'a few seconds ago').wait_until_present  
  end
end
