#!/bin/bash

# Hestia Control Panel upgrade script for target version 1.6.2

#######################################################################################
#######                      Place additional commands below.                   #######
#######################################################################################
####### Pass through information to the end user in case of a issue or problem  #######
#######                                                                         #######
####### Use add_upgrade_message "My message here" to include a message          #######
####### in the upgrade notification email. Example:                             #######
#######                                                                         #######
####### add_upgrade_message "My message here"                                   #######
#######                                                                         #######
####### You can use \n within the string to create new lines.                   #######
#######################################################################################

upgrade_config_set_value 'UPGRADE_UPDATE_WEB_TEMPLATES' 'no'
upgrade_config_set_value 'UPGRADE_UPDATE_DNS_TEMPLATES' 'no'
upgrade_config_set_value 'UPGRADE_UPDATE_MAIL_TEMPLATES' 'no'
upgrade_config_set_value 'UPGRADE_REBUILD_USERS' 'no'
upgrade_config_set_value 'UPGRADE_UPDATE_FILEMANAGER_CONFIG' 'false'

system_filter=$(cat /etc/exim4/exim4.conf.template | grep 'system_filter');
if [ -z "$system_filter" ]; then
    sed -i '/SMTP_RELAY_PASS = \${lookup{pass}lsearch{SMTP_RELAY_FILE}}/a #shouldberemoved\n# Custom Filter\nsystem_filter = \/etc\/exim4\/system.filter\nsystem_filter_user = Debian-exim' /etc/exim4/exim4.conf.template
    # Keep the spacing between the reley_pass and Custom Filter we need to insert a dummy text and remove it later on
    sed -i 's/#shouldberemoved//g' /etc/exim4/exim4.conf.template
fi