#!/bin/bash

source $HOME/.bash_profile
total=0
passed=0
failed=0
dir_automation="/Users/admin/Desktop/wa-automation"
cmd_cucumber="/Users/admin/.rvm/gems/ruby-2.3.1/bin/cucumber"
dir_mutt="/usr/local/bin/mutt"
web_tests_to_execute="--tags @Hermes --tags @Web --tags ~@Not_UK --tags ~@H-Wallet --tags ~@Bug"
#web_tests_to_execute="--tags @H1.5"

web_profile=" -p Test_Web_UK"
export PATH="$HOME/bin:$PATH"
PATH="${PATH}:/Users/admin/.rvm/gems/ruby-2.3.1/bin"

cd "${dir_automation}"

${cmd_cucumber} ${web_tests_to_execute} ${web_profile} --format html -o web_test_report.html

latest_date_folder=`ls -t ${dir_automation}/tests_results/web | head -1`
latest_time_folder=`ls -t ${dir_automation}/tests_results/web/${latest_date_folder} | head -1`
cd "${dir_automation}/tests_results/web/${latest_date_folder}/${latest_time_folder}"

[[ $(cat web_test_report.html) =~ (\'totals\').*\<br ]] && text=${BASH_REMATCH[0]}

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
echo "file_name:$file_name"

# Move test results to GooleDrive
mv $file_name /Volumes/GoogleDrive/My\ Drive/test\ results\ /web

# Send email
echo "The current Web test execution results could be found in https://drive.google.com/open?id=1-0MvM7VsFrT0gbmqYEMwC3vFsXBpBVi_" | $dir_mutt -s "Web Tests Results $file_name (T:$total P:$passed F:$failed)" pardha.perali@lifeworks.com eliran.bitton@lifeworks.com joe.elmoufak@lifeworks.com

# Add
echo "${latest_date_folder},${latest_time_folder},$total,$passed,$failed" >> /Users/admin/Desktop/Web_Results_Summery.csv

# Display latest results on the screensaver
web_latest_results="Web:$(tail -1 /Users/admin/Desktop/Web_Results_Summery.csv)"
ios_latest_results="iOS:$(tail -1 /Users/admin/Desktop/iOS_Results_Summery.csv)"
android_latest_results="Android:$(tail -1 /Users/admin/Desktop/Android_Results_Summery.csv)"
defaults -currentHost write com.apple.screensaver moduleDict -dict path "/System/Library/Frameworks/ScreenSaver.framework/Resources/Computer Name.saver" moduleName "Computer Name" type 0
defaults -currentHost write com.apple.screensaver.Basic MESSAGE "$web_latest_results $ios_latest_results $android_latest_results"
killall cfprefsd
