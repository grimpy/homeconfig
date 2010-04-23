# notification.py
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

import dbus
 
class Notification:

	def __init__(self):
		self.app_name = ""
		self.replaces_id = 0
		self.app_icon = ""
		self.summary = ""
		self.body = ""
		self.actions = []
		self.hints = {}
		self.bus_id=0
		self.expire_timeout = 1000

		try:
			self.session_bus = dbus.SessionBus()
			self.obj = self.session_bus.get_object("org.freedesktop.Notifications","/org/freedesktop/Notifications")
			self.interface = dbus.Interface(self.obj, "org.freedesktop.Notifications")
		except Exception:
			self.interface = None

	def setAppName(self, app_name):
		self.app_name = app_name

	def setReplacesId(self, replaces_id):
		self.replaces_id = replaces_id

	def setIcon(self, app_icon):
		self.app_icon = app_icon

	def setSummary(self, summary):
		self.summary = summary

	def setBody(self, body):
		self.body = body

	def setXY(self, x, y):
		self.hints['x']=x
		self.hints['y']=y

	def setTimeout(self, expire_timeout):
		self.expire_timeout = expire_timeout * 1000

	def notify(self):
		self.bus_id=self.interface.Notify(self.app_name, self.replaces_id, self.app_icon, self.summary, self.body, self.actions, self.hints, self.expire_timeout)

	def close(self):
		self.interface.CloseNotification(self.bus_id)
	
	#def __del__(self):
	# Anything not auto-deleted?
