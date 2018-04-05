# -*- encoding : utf-8 -*-
require 'watir'
require 'date'
require 'selenium-webdriver'
require 'watir-scroll'

Watir.always_locate = true 

# Set all URL's
def set_urls
  $HERMES = "#{URL[:hermes]}".gsub! '[company_wa_subdomain]' , "#{ACCOUNT[:"#{$account_index}"][:valid_account][:workangel_subdomain]}"
  $ZEUS = "#{URL[:zeus]}".gsub! '//' , '//' + "#{URL[:zeus_password]}" + '@'
  $SANTANDER_SIGNUP = "#{$SANTANDER_SIGNUP}"+ '/santander'
  $ARCH = "#{URL[:arch]}".gsub! '//' ,'//' + "#{URL[:password]}" + '@'
  $SSO = "#{URL[:sso]}".gsub! '//' , '//' + "#{URL[:password]}" + '@'
  $AVIATO = "#{URL[:aviato]}"
end

# Reset external data file. external_data_file used to store relevant information about the current test, user and company
# @param is_vagrant_env - as a defult will set to True
def reset_external_data_file (is_vagrant_env = true, all_tests_run = false)
  file_service = FileService.new

  if is_vagrant_env
    file_service.insert_to_file('admin_account_counter:', '0')
    file_service.insert_to_file('company_invitation_code:', '0')
    file_service.insert_to_file('invite_email_counter:', '0')
    file_service.insert_to_file('purchase_date_unix:', '0')
    file_service.insert_to_file('cinema_name:', '')
    file_service.insert_to_file('cinema_total_to_pay:', '')
    file_service.insert_to_file('cinema_pre_discount_total_to_pay:', '')
    file_service.insert_to_file('cinema_order_number:', '')
    file_service.insert_to_file('Adult 2d Lifeworkstesting UK all:', '0000')
    file_service.insert_to_file('Child 2d Lifeworkstesting UK all:', '0000')
    file_service.insert_to_file('shared_account_user_name:', '')
    file_service.insert_to_file('limited_account_user_name:', '')
    file_service.insert_to_file('limited_email_counter:', '')
  else
    # Reset external file settings ready for next test run
    file_service.insert_to_file('cinema_name:', '')
    file_service.insert_to_file('cinema_total_to_pay:', '')
    file_service.insert_to_file('cinema_pre_discount_total_to_pay:', '')
    file_service.insert_to_file('cinema_order_number:', '')
    file_service.insert_to_file('Adult 2d Lifeworkstesting UK all:', '0000')
    file_service.insert_to_file('Child 2d Lifeworkstesting UK all:', '0000')
  end

  if all_tests_run
    file_service.insert_to_file('did_run_failed_tests:', 'false')
    file_service.insert_to_file('parallel_processes_run:', '0')
    file_service.insert_to_file('test_report_folder_name:', '')
  end
end

# Default value for closing window after scenario complete
if ENV['CLOSE_WINDOW'] == nil
  ENV['CLOSE_WINDOW'] = 'true'
end

# Default value for logout after scenario complete
if ENV['LOGOUT_AFTER_SCENARIO'] == nil
  ENV['LOGOUT_AFTER_SCENARIO'] = 'true'
end

# Default value for vagrant scenarios
if ENV['VAGRANT'] != nil
  $IS_VAGRANT_ENV = eval(ENV['LOGOUT_AFTER_SCENARIO'])
  ENV['VAGRANT'] = 'false'
end

$IS_FIRST_USER_LOGIN = true
$CLICKED_PERKS_HOMEPAGE = false
$COMPANY_FEATURE_LIST = nil
set_urls

puts "******** Configuration ********"
puts "Search for emails? #{VALIDATION[:check_email]}"
puts "To delete email if was found? #{VALIDATION[:to_delete_email]}"
puts "To check for notifications? #{VALIDATION[:check_notification]}"
puts "To close window after scenario or exist? #{eval(ENV['CLOSE_WINDOW'])}"
puts "To close logout after scenario? #{eval(ENV['LOGOUT_AFTER_SCENARIO'])}"
puts "HERMES:#{$HERMES}"
puts "ZEUS:#{$ZEUS}"
puts "ARCH:#{$ARCH}"
puts "SSO:#{$SSO}"
puts "SANTANDER_SIGNUP:#{$SANTANDER_SIGNUP}"
puts "*******************************"

# Run perks importer
# @param perks_feature
def run_perks_importer (perks_feature)
  case perks_feature
  when 'Gift Cards'
    system("/srv/wa-api/bin/api giftcards import")
  when 'Shop Online'
    system("timeout 30s php /srv/wa-backend/public/index.php retailer incentivenetworks import")
  when 'Restaurants'
    system("php /srv/wa-backend/public/index.php hi-life restaurant discover")
    system("timeout 30s php /srv/wa-backend/public/index.php hi-life restaurant import")
    system("php /srv/wa-backend/public/index.php bookatable cuisine")
    system("php /srv/wa-backend/public/index.php bookatable cuisine count")
    system("php /srv/wa-backend/public/index.php bookatable restaurant discover --location=gb")
    system("timeout 30s php /srv/wa-backend/public/index.php bookatable restaurant import")
    system("timeout 30s php /srv/wa-backend/public/index.php bookatable restaurant import-detail")
  when 'Local'
    system("php /srv/wa-backend/public/index.php bownty import sites --country=gb")
    system("php /srv/wa-backend/public/index.php bownty import categories --country=gb")
    system("timeout 30s php /srv/wa-backend/public/index.php bownty import deals --country=gb")
    system("php /srv/wa-backend/public/index.php bownty count deals")
  end
end

# If running tests in HEADLESS mode
if ENV['CURRENT_CUCUMBER_PROFILE'].include? 'Headless'
  require 'headless'

  $account_index = 'account_1'
  headless = Headless.new
  headless.start

  reset_external_data_file(true,false)

  #dump WAM and ARCH DB
  system("sh #{Dir.pwd}/features/support_files/db_dump.sh")

  #run_perks_importer('Gift Cards')
  #run_perks_importer('Restaurants')
  #run_perks_importer('Local')
  #run_perks_importer('Shop Online')

  Before do |scenario|
    steps "Given I create a new company using the API"

    @@current_scenario_tags = scenario.source_tag_names

    $COOKIE_PRIVATE_MESSAGE_DISMISSED = false
    @browser = Watir::Browser.start :ff

    $current_user_email = ''
    $browser = @browser
    @browser.cookies.clear
    @browser.window.resize_to(1200, 1000)
  end

  After do |scenario|
    if @@current_scenario_tags.include? '@Web'
      if scenario.failed?
        current_date = Time.now.strftime("%d-%m-%y")
        current_time = Time.now.strftime("%H:%M:%S")
        Dir::mkdir("screenshots") if not File.directory?("screenshots")
        Dir::mkdir("screenshots/#{current_date}") if not File.directory?("screenshots/#{current_date}")
        screenshot = "screenshots/#{Time.now.strftime("%d-%m-%y")}/#{scenario.source_tags[0].name}-#{Time.now.strftime("%H:%M:%S")}.png"
        @browser.driver.save_screenshot(screenshot)
        encoded_img = @browser.driver.screenshot_as(:base64)
        embed("data:image/png;base64,#{encoded_img}", 'image/png')
      end

      @browser.cookies.clear
      @browser.close

      # restore the old WAM and ARCH DB
      system("sh #{Dir.pwd}/features/support_files/db_restore.sh")
    end
  end

  at_exit do
    headless.destroy
  end
end

if !(ENV['CURRENT_CUCUMBER_PROFILE'].include? 'Headless')
  file_service = FileService.new

  INDEX_OFFSET = -1
  WEBDRIVER = true

  # Create a unique name for the current test run which is used to store screenshots, test reports and failure logs in one place
  #if file_service.get_from_file('test_report_folder_name:')[0..-2] == '' && !((ENV['CURRENT_CUCUMBER_PROFILE'].include? 'iOS') || (ENV['CURRENT_CUCUMBER_PROFILE'].include? 'Android'))
  if !((ENV['CURRENT_CUCUMBER_PROFILE'].include? 'iOS') || (ENV['CURRENT_CUCUMBER_PROFILE'].include? 'Android'))
    if file_service.get_from_file("test_report_folder_name:")[0..-2] == ''
      Dir::mkdir(@@directory_path) if not FileUtils.mkdir_p("#{ @@directory_path = "tests_results/web/#{Time.now.strftime("%d-%b-%Y")}/#{Time.now.strftime("%H.%M")}" }")
      file_service.insert_to_file('test_report_folder_name:', @@directory_path)
    else
      @@directory_path = file_service.get_from_file("test_report_folder_name:")[0..-2]
    end
  end

  Before do |scenario|
    @@current_scenario_tags = scenario.source_tag_names
    
    if (@@current_scenario_tags.include? '@Web') && !(@@current_scenario_tags.include? '@VagrantOnly')
      if @browser == nil
        profile = Selenium::WebDriver::Firefox::Profile.new
        profile['geo.enabled'] = false
        profile['intl.accept_languages'] = ACCOUNT[:"#{$account_index}"][:valid_account][:user_locale]
        # profile['accept_untrusted_certs'] = true
        # profile['acceptInsecureCerts'] = true
        # profile['assume_untrusted_certificate_issuer'] = false
        @browser = Watir::Browser.new :firefox, :profile => profile

        $COOKIE_PRIVATE_MESSAGE_DISMISSED = false
        $current_user_email = ''
        $browser = @browser
        @browser.cookies.clear
        @browser.window.resize_to(1200, 1000)
      end

      # If we don't close the window between scenarios the the previous window is the same winddow for the current scenario
      if !eval(ENV['CLOSE_WINDOW'])
        @browser = $browser
      end
    end
  end

  After do |scenario|

    reset_external_data_file(false,false)

    puts "@@current_scenario_tags:#{@@current_scenario_tags}"
    $IS_FIRST_USER_LOGIN = false
    if (@@current_scenario_tags.include? '@Web') && !((ENV['CURRENT_CUCUMBER_PROFILE'].include? 'iOS') || (ENV['CURRENT_CUCUMBER_PROFILE'].include? 'Android'))
      if scenario.failed?
        Dir::mkdir(screenshot_folder) if not FileUtils.mkdir_p("#{screenshot_folder = "#{@@directory_path}/screenshots"}")
        screenshot = "#{screenshot_folder}/#{scenario.source_tags[0].name}-#{Time.now.strftime("%H:%M:%S")}.png"
        puts "screenshot folder = #{screenshot}"
        @browser.driver.save_screenshot(screenshot)
        encoded_img = @browser.driver.screenshot_as(:base64)
        embed("data:image/png;base64,#{encoded_img}", 'image/png')
      end

      if @browser.exists? && eval(ENV['CLOSE_WINDOW'])
        @browser.close
      end
    end
  end

  at_exit do
    puts "@@directory_path:#{@@directory_path}"

    if (@@current_scenario_tags.include? '@Web')
      
      # parallel_processes_counter - Everytime a parallel process is finished running, the counter increments by 1
      file_service.insert_to_file('parallel_processes_run:', "#{parallel_processes_counter = file_service.get_from_file('parallel_processes_run:').chomp.to_i + 1}")
      
      # Wait until all processes are finished running before attempting to rerun failed tests or store report files
      if ENV['PARALLEL_TEST_GROUPS'] == nil || parallel_processes_counter >= ENV['PARALLEL_TEST_GROUPS'].to_i

        # Checks if the failed tests have already been rerun and if the test run config is set to rerun failed tests
        if (!did_run_failed_tests = eval(file_service.get_from_file('did_run_failed_tests:').chomp)) && (eval(ENV['RERUN_FAILED_TESTS'].to_s))

          # Checks to see if there were any test failures that need to be rerun
          if File.zero?("cucumber_failures.log")
            puts "======== No Failures in initial test run. No test re-run required ========"
          else
            puts "======================= Re-Running Failed Scenarios ======================"
            # Flag is set in the external file so that the failed tests are only rerun once
            file_service.insert_to_file('did_run_failed_tests:', true)
            system "cucumber @cucumber_failures.log -p #{ENV['CURRENT_CUCUMBER_PROFILE']} --format html --out test_results_rerun.html"
            @browser.close
          end  
        end  

        # Moves all test report files & logs to the current test run directory after all tests runs are complete
        Dir["*report*.html" , 'cucumber_failures.log', 'test_results_rerun.html'].each do |filename| 
          FileUtils.mv(filename, @@directory_path)
        end
        
        reset_external_data_file(false,true)
      end

      if eval(ENV['CLOSE_WINDOW'])
        @browser.close
      end
    end
  end
end
