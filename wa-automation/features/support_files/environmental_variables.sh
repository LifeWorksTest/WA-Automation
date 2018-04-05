#!/bin/sh

if [ "$1" = "DEV" ];
then
	echo Env: DEV
	export URL_WEB_APP_WITH_SUBDOMAIN=http://[company_wa_subdomain].hermes.dev.rs.lifeworks.com
	export URL_ADMIN_PANEL=http://zeus.dev.rs.lifeworks.com
	export URL_ARCH=http://arch.dev.rs.lifeworks.com
	export URL_PASSWORD=wamqa:N1mbus-20o1
	export URL_ADMIN_PANEL_PASSWORD=wam:wamadmin007
	export URL_API=http://api.dev.rs.lifeworks.com
elif [ "$1" = "TEST" ]
then
	echo Env: TEST
	export URL_WEB_APP_WITH_SUBDOMAIN=http://[company_wa_subdomain].test.lifeworks.com
	export URL_ADMIN_PANEL=http://zeus.test.lifeworks.com
	export URL_ARCH=http://arch.test.lifeworks.com
	export URL_PASSWORD=wamqa:N1mbus-20o1
	export URL_ADMIN_PANEL_PASSWORD=wam:wamadmin007
	export URL_API=http://api.test.lifeworks.com
elif [ "$1" = "PRODUCTION" ]
then
	echo Env: PRODUCTION
	export URL_WEB_APP_WITH_SUBDOMAIN=http://[company_wa_subdomain].lifeworks.com
	export URL_ADMIN_PANEL=http://zeus.test.lifeworks.com
	export URL_PASSWORD=wamqa:N1mbus-20o1
	export URL_ADMIN_PANEL_PASSWORD=wam:wamadmin007
	export URL_API=http://api.test.lifeworks.com
	echo ENV
fi
