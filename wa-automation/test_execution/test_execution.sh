#!/bin/bash

if [ -z $option ]
  then
    option="All"
fi

case ${option} in
    "Android")
        /Users/admin/Desktop/wa-automation/test_execution/Android/execute_android_tests.sh
    ;;

    "iOS")
        /Users/admin/Desktop/wa-automation/test_execution/iOS/execute_ios_tests.sh
    ;;

    "Web")
        /Users/admin/Desktop/wa-automation/test_execution/Web/execute_web_tests.sh
    ;;

    "All")
        /Users/admin/Desktop/wa-automation/test_execution/Android/execute_android_tests.sh
        /Users/admin/Desktop/wa-automation/test_execution/Web/execute_web_tests.sh
        /Users/admin/Desktop/wa-automation/test_execution/iOS/execute_ios_tests.sh
    ;;
esac
