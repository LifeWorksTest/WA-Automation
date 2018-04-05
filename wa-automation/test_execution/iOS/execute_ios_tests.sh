#!/bin/bash

source $HOME/.bash_profile
total=0
passed=0
failed=0
dir_automation="/Users/admin/Desktop/wa-automation"
app_budle_path="/Users/admin/Desktop/WorkAngel.app"
ios_profile="-p iOS"
ios_tests_to_execute="--tags @iOS --tags ~@Bug --tags ~@I-Wallet --tags ~@I-ShopOnline"
#ios_tests_to_execute="--tags @I1.5"
cmd_cucumber="/Users/admin/.rvm/gems/ruby-2.3.1/bin/cucumber"
dir_mutt="/usr/local/bin/mutt"

cd $HOME/Desktop/wa-ios/ && git pull

xcodebuild -workspace WorkAngel.xcworkspace -scheme 'WorkAngel (Calabash)' SYMROOT='$HOME/Desktop/build'  -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 7 Plus,OS=10.3.1'

if [ -e $HOME/Desktop/WorkAngel.app ]
  then
    rm -r $HOME/Desktop/WorkAngel.app
fi

#Move .app file to the desktop
cp -R $HOME/Desktop/build/Calabash-iphonesimulator/WorkAngel.app $HOME/Desktop/WorkAngel.app

cd "${dir_automation}"

APP_BUNDLE_PATH=${app_budle_path} ${cmd_cucumber} ${ios_profile} ${ios_tests_to_execute}  --format html -o ios_test_report.html

latest_date_folder=`ls -t ${dir_automation}/tests_results/ios | head -1`
latest_time_folder=`ls -t ${dir_automation}/tests_results/ios/${latest_date_folder} | head -1`
cd "${dir_automation}/tests_results/ios/${latest_date_folder}/${latest_time_folder}"

[[ $(cat ios_test_report.html) =~ (\'totals\').*\<br ]] && text=${BASH_REMATCH[0]}

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
mv $file_name /Volumes/GoogleDrive/My\ Drive/test\ results\ /ios

# Send email
echo "The current iOS test execution results could be found in https://drive.google.com/open?id=1--X87nLOkCVqxIPvOchB_Io9AAE6gYYx" | $dir_mutt -s "iOS Tests Results $file_name (T:$total P:$passed F:$failed)" pardha.perali@lifeworks.com eliran.bitton@lifeworks.com joe.elmoufak@lifeworks.com

# Add
echo "${latest_date_folder},${latest_time_folder},$total,$passed,$failed" >> /Users/admin/Desktop/iOS_Results_Summery.csv

# Display latest results on the screensaver
web_latest_results="Web:$(tail -1 /Users/admin/Desktop/Web_Results_Summery.csv)"
ios_latest_results="iOS:$(tail -1 /Users/admin/Desktop/iOS_Results_Summery.csv)"
android_latest_results="Android:$(tail -1 /Users/admin/Desktop/Android_Results_Summery.csv)"
defaults -currentHost write com.apple.screensaver moduleDict -dict path "/System/Library/Frameworks/ScreenSaver.framework/Resources/Computer Name.saver" moduleName "Computer Name" type 0
defaults -currentHost write com.apple.screensaver.Basic MESSAGE "$web_latest_results $ios_latest_results $android_latest_results"
killall cfprefsd
