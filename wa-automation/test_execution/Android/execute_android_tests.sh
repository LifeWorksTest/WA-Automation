#!/bin/bash

source $HOME/.bash_profile
dir_automation="/Users/admin/Desktop/wa-automation"
apk_path="/Users/admin/Desktop/app-debug.apk"
android_profile="-p Android"
android_tests_to_execute="--tags @Android --tags ~@Bug --tags ~@AN-Wallet"
#android_tests_to_execute="--tag @AN1.5"
cmd_calabash="/Users/admin/.rvm/gems/ruby-2.3.1/bin/calabash-android"
dir_mutt="/usr/local/bin/mutt"

export PATH="$HOME/bin:$PATH"
PATH="${PATH}:/Users/admin/.rvm/gems/ruby-2.3.1/bin"

cd $HOME/Desktop/wa-android/ && git pull
#./gradlew assembleDebug

#if [ -e $HOME/Desktop/app-debug.apk ]
#  then
  #  rm -r $HOME/Desktop/app-debug.apk
#fi

#Move .app file to the desktop
#cp -R $HOME/Desktop/wa-android/app/build/outputs/apk/debug/app-debug.apk $HOME/Desktop/app-debug.apk

#/Users/admin/Library/Android/sdk/emulator/emulator -avd Nexus_6_API_27
#/Users/admin/Library/Android/sdk/emulator/emulator adb install $HOME/Desktop/app-debug.apk
cd "${dir_automation}"

SCREENSHOT_VIA_USB=false ${cmd_calabash} run ${apk_path} ${android_profile} ${android_tests_to_execute} --format html -o android_test_report.html

latest_date_folder=`ls -t ${dir_automation}/tests_results/android | head -1`
latest_time_folder=`ls -t ${dir_automation}/tests_results/android/${latest_date_folder} | head -1`
cd "${dir_automation}/tests_results/android/${latest_date_folder}/${latest_time_folder}"

[[ $(cat android_test_report.html) =~ (\'totals\').*\<br ]] && text=${BASH_REMATCH[0]}

# Set "Total"
[[ ${text} =~ ([0-9][0-9]*)[[:space:]]scenario ]] && total=${BASH_REMATCH[0]}
[[ ${total} =~ ([0-9][0-9]*) ]] && total=${BASH_REMATCH[0]}
if [ -z $total ]
then
total=0
fi

# Set "Failed"
[[ ${text} =~ ([0-9][0-9]*)[[:space:]]failed ]] && failed=${BASH_REMATCH[0]}
[[ ${failed} =~ ([0-9][0-9]*) ]] && failed=${BASH_REMATCH[0]}
if [ -z $failed ]
then
failed=0
fi

# Set "Passed"
[[ ${text} =~ ([0-9][0-9]*)[[:space:]]passed ]] && passed=${BASH_REMATCH[0]}
[[ ${passed} =~ ([0-9][0-9]*) ]] && passed=${BASH_REMATCH[0]}
if [ -z $passed ]
then
passed=0
fi

# Zip folder
file_name=${latest_date_folder}+${latest_time_folder}.zip
zip -r $file_name .

# Move test results to GooleDrive
mv $file_name /Volumes/GoogleDrive/My\ Drive/test\ results\ /android

# Send email
echo "The current Android test execution results could be found in https://drive.google.com/open?id=19Lbk6roC5VTn7Cae_XojUcVRq6K7BURy" | $dir_mutt -s "Android Tests Results $file_name (T:$total P:$passed F:$failed)" pardha.perali@lifeworks.com eliran.bitton@lifeworks.com joe.elmoufak@lifeworks.com

# Add
echo "${latest_date_folder},${latest_time_folder},$total,$passed,$failed" >> /Users/admin/Desktop/Android_Results_Summery.csv

# Display latest results on the screensaver
web_latest_results="Web:$(tail -1 /Users/admin/Desktop/Web_Results_Summery.csv)"
ios_latest_results="iOS:$(tail -1 /Users/admin/Desktop/iOS_Results_Summery.csv)"
android_latest_results="Android:$(tail -1 /Users/admin/Desktop/Android_Results_Summery.csv)"

defaults -currentHost write com.apple.screensaver moduleDict -dict path "/System/Library/Frameworks/ScreenSaver.framework/Resources/Computer Name.saver" moduleName "Computer Name" type 0
defaults -currentHost write com.apple.screensaver.Basic MESSAGE "$web_latest_results $ios_latest_results $android_latest_results"
killall cfprefsd
