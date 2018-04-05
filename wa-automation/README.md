# wa-automation

Front-End automated scripts for all web platforms.

## Technical overview

* [Calabash](http://calaba.sh/): Library to interface with a mobile platform
* [Cucumber](https://cucumber.io/): Ruby testing framework
* [Watir webdriver](http://watirwebdriver.com/): Driver to run E2E tests on a browser

A Cucumber tutorial: http://watirmelon.com/tag/cucumber/

## Installation for the iOS automated tests

Notes:

Can be install and execute only on OSX operation system
To install Ruby we use RVM (manage multiple releases of Ruby)

```bash
# install rvm (downloading the signatures)
sudo gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

# install rvm for multi-users (note the use of sudo)
\curl -sSL https://get.rvm.io | sudo bash -s stable

# source the profile to get the rvm goodness
source /etc/profile.d/rvm.sh

# source environment to get environmental variables 
source /srv/environment

# Please chaek ruby was installed by runnig
rvm list

# If ruby was not install please install by running the following command 
rvm install ruby-2.3.0

# Install Bundler (makes sure Ruby applications run the same code on every machine)
gem install bundler 
# tests are currently not compatible with cucumber 2

# Follow the below link to pull and run iOS application
https://workivate.atlassian.net/wiki/pages/viewpage.action?pageId=62652493

# Find the executable '.app' file Xcode created after running the app in Xcode
1. open ~/Library/Developer/CoreSimulator/Devices
2. open the device folder that was last updated:
/DeviceID/data/Containers/Bundle/Application/ApplicationID/LifeWorks.app
example to the full path:
/Users/userName/Library/Developer/CoreSimulator/Devices/DE0A050B-A307-4EA9-AE53-4FAAC1C5FFB3/data/Containers/Bundle/Application/6F7D97E2-78C9-4941-B9A3-462F89A43C5C
3. store the appName.app location 

# Go to wa-automation folder in and run bundler
cd /vagrant/wa-automation
bundle install

# now you can run the tests
# in the test folder
APP_BUNDLE_PATH=/PATH/LifeWorks.app cucumber --tag @I1.4 -p iOS --format html --out report.html
```
## Installation for the Web automated tests

Notes:
* OSX installation is pretty much the same except that on OSX 1/ headless-related packages (headless, xvfb) are not required because the tests run on a real browser 2/ and you it's not necessary to install packages as root.
* To install Ruby we use RVM (manage multiple releases of Ruby)

```bash

Login to your Vagrant box

sudo yum update

sudo yum install Xvfb
sudo yum install firefox

# ubuntu doesn't have curl by default
sudo yum install curl

# downloading the signatures
sudo gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

# install rvm for multi-users (note the use of sudo)
\curl -sSL https://get.rvm.io | sudo bash -s stable

# source the profile to get the rvm goodness
source /etc/profile.d/rvm.sh

# source environment to get environmental variables 
source /srv/environment

# Please check ruby was installed by running
rvm list

# If ruby was not install please install by running the following command 
rvm install ruby-2.3.0

# Install Bundler (makes sure Ruby applications run the same code on every machine)
gem install bundler 
# tests are currently not compatible with cucumber 2

# Go to wa-automation folder in and run bundler
cd /vagrant/wa-automation
bundle install

# now you can run the tests
# in the test folder
cucumber --tag @H1.4 -p UK_Web HEADLESS="HEADLESS" --format html --out report.html
```
**Please note**

'-p' stands for 'profile' and this is being used to load a specific configuration settings for the current test execution. There are 3 profile defined in this project for UK,US and CA:
* UK_Web
* US_Web
* CA_Web

## Tags:
Tags are a great way to organise the features and scenarios and every Scenario or feature can have 
pal tags. 
All tags can be found in: wa-automation/features/RELEVANT_PROJECT/features/RELEVANT_SECTION.feature

In order to specify the tags we would like to execute we need to declar it in the cucumber command: --tag @TAG_NAME

Please find below the different tags that are being used in the wa-automation features and scenarios

**Hermes - Test tags by sections**
```bash
@H-Wallet
@H-Profile
@H-SignUp
@H-ShopOnline
@H-RestaurantDiscounts 
@H-NewsFeed
@H-Login
@H-Leaderboard
@H-InstoreColleagueOffers
@H-GiftCards
@H-DailyDeals
@H-ColleagueDirectory
```

**Zeus - Test tags by sections**
```bash
@Z-Account
@Z-Company
@Z-Dashboard
@Z-Employees
@Z-Leaderboard
@Z-Rewards
@Z-SignUp 
@Z-Timeline
@Z-Settings
@Z-UserProfile
```

**Arch - Test tags by sections**
```bash
@A-Companies
@A-Coupons
@A-Affiliate
@A-GiftCards
```

**Test tags by platform**
```bash
@Hermes
@Zeus
@Web (include all web projects)
@Arch
```

**Test tags according to testing methodologies**
```bash
@Smoke 
@Regression
```

**Test tags for specific scenarios examples:**
```bash
Hermes: @H1.1
Zeus: @Z1.1
Arch: @A1.1 
```
**For More Information:** https://github.com/cucumber/cucumber/wiki/Tags

