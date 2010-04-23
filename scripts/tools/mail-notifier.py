#!/usr/bin/env python

# mail-notifier.py
#
# Copyright (C) 2006 Quim Calpe <quim@kalpe.com>.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
 
import pygtk
pygtk.require('2.0')
import gtk
import gobject
import dbus
import dbus.glib
import notification
import ConfigParser
import os

def icon_clicked(icon):
	# hide status icon
	icon.set_visible(False)
	icon.set_blinking(False)
	# Force all folders as read
	for folder in unread_folders:
		unread_folders.remove(folder)
	# close all notifications
	for notif in notif_list:
		notif.close()
	os.system("rm /tmp/scrolllock")

def update_icon_visibility():
	# If there are not remaining unread folders neither notifications
	# opened, hide the status icon
	if len(unread_folders)==0 and len(notif_list)==0:
		status_icon.set_visible(False)
		status_icon.set_blinking(False)

def notif_closed(notif_id):
	# loop notification list
	for notif in notif_list:
		# remove the notification closed from the list
		if notif.bus_id==notif_id:
			notif_list.remove(notif)
			del notif
	# Hide status icon?
	update_icon_visibility()

def folder_reading(folder):
	# If we are reading a folder with unread mails, mark as read
	if folder in unread_folders:
		unread_folders.remove(folder)
	# Update tooltip
	status_icon.set_tooltip("You have new mail in folder(s):\n"+", ".join(unread_folders))
	# Hide status icon?
	if notification_method==0:
		# Hide always
		status_icon.set_visible(False)
		status_icon.set_blinking(False)
		for notif in notif_list:
			notif.close()
	else:
		update_icon_visibility()
	os.system("rm /tmp/scrolllock")

def show_notification(folder):
	# Get status icon position
	icon_geometry=status_icon.get_geometry()
	icon_x=icon_geometry[1].x+12
	icon_y=icon_geometry[1].y+15
	# Set notification contents
	notif_list.append(notification.Notification())
	notif_list[-1].setAppName("Correo")
	notif_list[-1].setSummary("You have new mail!")
	notif_list[-1].setBody("New mail has been received in folder:" \
							"<b>" + folder + "</b>")
	# Set icon from stock
	notif_list[-1].setIcon("stock_mail")
	# Set notification position
	notif_list[-1].setXY(icon_x, icon_y)
	# Set timeout time while notification will be shown
	notif_list[-1].setTimeout(10)
	# Show notification!
	notif_list[-1].notify()
	# return False to Destroy gobject.timeout_add interval
	return False

def new_mail(mbox, folder):
	# If folder is not banned
	if folder not in banned_folders:
		# Mark folder as unred
		actual_folder=folder.split('/')[-1]
		if actual_folder not in unread_folders:
			unread_folders.append(actual_folder)
		# Put status icon visible
		status_icon.set_visible(True)
		if enable_blinking:
			status_icon.set_blinking(True)
		# Update tooltip
		status_icon.set_tooltip("You have new mail in folder(s):\n"+", ".join(unread_folders))
		# Delay to be sure (sort of...) the status icon is properly rendered,
		# without the delay, notifications are badly positioned if there
		# is not enough room for the icon and applets has to be moved
		gobject.timeout_add(1500, show_notification, folder)
		os.system("scrolllock&")
		

if ( __name__ == "__main__"): 
	# read configuration file (thanks to Matt Nuzum)
	config = ConfigParser.ConfigParser()
	if not config.read(os.path.expanduser('~/.mail-notifier')):
		# if not exists, create a new one with sane defaults
		config.add_section('defaults')
		config.set('defaults','blinking','yes')
		config.set('defaults','method','0')
		config.add_section('banned')
		config.set('banned','folders','Trash|Spam|Sent')
		config.write(open(os.path.expanduser('~/.mail-notifier'),'w'))
	# Set banned folders, will be ignored for notification
	banned_folders = config.get('banned','folders').split('|')
	# Notification icon blinks?
	enable_blinking = config.getboolean('defaults','blinking')
	# Notification method?
	notification_method = config.getint('defaults','method')
	# Create a dbus handler
	bus = dbus.SessionBus()
	# Add a handler when receiving "Newmail" signal on Evo's channel
	bus.add_signal_receiver(new_mail, 'Newmail', \
							 'org.gnome.evolution.mail.dbus.Signal')
	# Add a handler when receiving "MessageReading" signal on Evo's channel
	bus.add_signal_receiver(folder_reading, 'MessageReading', \
							 'org.gnome.evolution.mail.dbus.Signal')
	# Add a event handler when a notification is closed
	bus.add_signal_receiver(notif_closed, 'NotificationClosed', \
							 'org.freedesktop.Notifications')
	# Create the StatusIcon instance
	status_icon=gtk.StatusIcon()
	status_icon.set_from_icon_name("stock_mail")
	status_icon.set_tooltip("You have new mail in folder(s):")
	status_icon.set_visible(False)
	status_icon.connect("activate", icon_clicked)
	# Create the notification list
	notif_list=[]
	# Create unread folders list
	unread_folders=[]
	# Start gobject main loop
	gobject.MainLoop().run()
