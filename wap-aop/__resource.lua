name "Webadmin AOP Plugin"
author "glitchdetector"
contact "glitchdetector@gmail.com"
version "1.0"

description "AOP page for webadmin"

--dependency 'Area-of-Patrol'
dependency 'webadmin-lua'
webadmin_plugin 'yes'

webadmin_settings 'yes'
convar_category 'Area of Patrol' {
    '',
    {
        {'Page Top', 'wap_aop_top', 'CV_BOOL', true, 'Show the current Area of Patrol on the top of the page'},
        {'Front Page', 'wap_aop_front', 'CV_BOOL', true, 'Show the current Area of Patrol on the front page'},
    }
}

server_script 'plugin.lua'
