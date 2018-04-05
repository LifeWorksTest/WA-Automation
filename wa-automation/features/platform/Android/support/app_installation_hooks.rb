# -*- encoding : utf-8 -*-3
  require 'calabash-android/cucumber'
  require 'calabash-android/management/app_installation'
  require 'calabash-android/management/adb'

  AfterConfiguration do |config|
    FeatureMemory.feature = nil
  end

  if ENV['ENV'] == nil
    ENV_LOWCASE = 'test'
  else
    ENV_LOWCASE = ENV['ENV'].downcase
  end

  if ENV['ACCOUNT'] == nil
    $ACCOUNT_INDEX = 'account_1'
  end

  # Create a unique name for the current test run which is used to store screenshots, test reports and failure logs in one place
  Dir::mkdir(@directory_path) if not FileUtils.mkdir_p("#{ @directory_path = "tests_results/android/#{Time.now.strftime("%d-%b-%Y")}/#{Time.now.strftime("%H.%M")}" }")
  Dir::mkdir("screenshots") if not FileUtils.mkdir_p("screenshots")
  ENV['SCREENSHOT_PATH'] = "screenshots/"

  Before do |scenario|
    current_date = Time.now.strftime("%d-%m-%y")
    current_time = Time.now.strftime("%H:%M:%S")

    #Dir::mkdir("screenshots") if not File.directory?("screenshots")
    #Dir::mkdir("screenshots/#{current_date}") if not File.directory?("screenshots/#{current_date}")

    #ENV["SCREENSHOT_PATH"] = "./screenshots/#{current_date}/#{scenario.source_tags[0].name}-#{current_time}-"

    scenario = scenario.scenario_outline if scenario.respond_to?(:scenario_outline)

    feature = scenario.feature
    if FeatureMemory.feature != feature || ENV['RESET_BETWEEN_SCENARIOS'] == '1'
      if ENV['RESET_BETWEEN_SCENARIOS'] == '1'
        log 'New scenario - reinstalling apps'
      else
        log 'First scenario in feature - reinstalling apps'
      end

    #  uninstall_apps
      install_app(ENV['TEST_APP_PATH'])
      install_app(ENV['APP_PATH'])
      FeatureMemory.feature = feature
      FeatureMemory.invocation = 1
    else
      FeatureMemory.invocation += 1
    end
  end

  FeatureMemory = Struct.new(:feature, :invocation).new

  After do |scenario|
    if scenario.failed?
      puts "Scenario faild reset app"
      start_test_server_in_background
    end
  end

  at_exit do
    FileUtils.mv 'screenshots', @directory_path
    FileUtils.mv("android_test_report.html", @directory_path)
  end
