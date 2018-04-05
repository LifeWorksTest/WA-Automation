require 'calabash-cucumber/launcher'
require 'calabash-cucumber/cucumber'
require 'fileutils'

# You can find examples of more complicated launch hooks in these
# two repositories:
#
# https://github.com/calabash/ios-smoke-test-app/blob/master/CalSmokeApp/features/support/01_launch.rb
# https://github.com/calabash/ios-webview-test-app/blob/master/CalWebViewApp/features/support/01_launch.rb

module Calabash::Launcher
  @first_launch = true

  def self.set_is_first_lunch_state (state)
    @first_launch = state
  end

  def self.get_is_first_lunch_state
    return @first_launch
  end

  def self.launcher
    @@launcher ||= Calabash::Cucumber::Launcher.new

  end

  def self.launcher=(launcher)
    @@launcher = launcher
  end
end

current_date = Time.now.strftime("%d-%m-%y")
current_time = Time.now.strftime("%H:%M:%S")

# Create a unique name for the current test run which is used to store screenshots, test reports and failure logs in one place
Dir::mkdir(@directory_path) if not FileUtils.mkdir_p("#{ @directory_path = "tests_results/ios/#{Time.now.strftime("%d-%b-%Y")}/#{Time.now.strftime("%H.%M")}" }")
puts "@directory_path:#{@directory_path}"
Dir::mkdir("screenshots") if not FileUtils.mkdir_p("screenshots")
ENV['SCREENSHOT_PATH'] = "screenshots/"
puts "SCREENSHOT_PATH: #{ ENV['SCREENSHOT_PATH'] }"

Before do |scenario|
  if Calabash::Launcher.get_is_first_lunch_state
    #launcher = Calabash::Launcher.launcher
    options = {
      # Add launch options here.
    }

    launcher.relaunch(options)
    Calabash::Launcher.set_is_first_lunch_state(false)
  end
end

After do |scenario|
  # Calabash can shutdown the app cleanly by calling the app life cycle methods
  # in the UIApplicationDelegate.  This is really nice for CI environments, but
  # not so good for local development.
  #
  # See the documentation for QUIT_APP_AFTER_SCENARIO for a nice debugging workflow
  #
  # http://calabashapi.xamarin.com/ios/file.ENVIRONMENT_VARIABLES.html#label-QUIT_APP_AFTER_SCENARIO
  # http://calabashapi.xamarin.com/ios/Calabash/Cucumber/Core.html#console_attach-instance_method
  if ENV['RESET_APP'] != nil
    reset_app_flag = eval(ENV['RESET_APP'])
  else
    reset_app_flag = false
  end

  if (launcher.quit_app_after_scenario? && reset_app_flag) || scenario.failed?
    Calabash::Launcher.set_is_first_lunch_state(true)
    calabash_exit
  end
end

at_exit do
  FileUtils.mv 'screenshots', @directory_path
  FileUtils.mv("ios_test_report.html", @directory_path)
end
