#!/usr/bin/env python
import xdg
import xdg.IconTheme
import xdg.DesktopEntry
import os

programs = dict()

categories = {"Accessories": "Utility", "Development" : "Development",
    "Education": "Education", "Games": "Game",
    "Graphics" : "Graphics", "Multimedia": "AudioVideo",
    "Network": "Network", "Office": "Office",
    "Other": "Other", "Settings": "Settings",
    "System Tools": "System"}
valid_cat = categories.values()
programs = dict()
terminal = "urxvt"
used_cat = set()

filecontents = ["local table = table",
                "module('myrc.xdg_menu')",
                "" ,
                "local programs = {}"]
for cat in categories.itervalues():
    filecontents.append('programs["%s"] = {}' % cat)

def get_command_line(entry):
    cmd = entry.getExec().split(" ")[0]
    if entry.getTerminal():
        cmd = terminal + " -e " + cmd
    return cmd

xdg.Config.setIconTheme('Tango')
for appdir in set(xdg.BaseDirectory.xdg_data_dirs):
    appdir = os.path.join(appdir, 'applications')
    print appdir
    if os.path.isdir(appdir):
        for fl in os.listdir(appdir):
            fl_path = os.path.join(appdir, fl)
            if os.path.isfile(fl_path) and fl.lower().endswith(".desktop"):
                entry = xdg.DesktopEntry.DesktopEntry(fl_path)
                if not entry.getHidden():
                    for cat in entry.getCategories():
                        if cat in valid_cat:
                            icon =  xdg.IconTheme.getIconPath(entry.getIcon(), extensions=["png"])
                            if not icon or not icon.endswith("png"):
                                icon = 'nil'
                            else:
                                icon = '"%s"' % icon
                            args = cat, entry.getName(), get_command_line(entry), icon
                            filecontents.append('table.insert(programs["%s"], { "%s", "%s", %s })' % (args))
                            used_cat.add(cat)
                            break

icons = ('applications-accessories.png', 'applications-development.png', 'applications-science.png',
        'applications-games.png', 'applications-graphics.png', 'applications-internet.png',
        'applications-multimedia.png', 'applications-office.png', 'applications-other.png',
        'package_utilities.png', 'applications-system.png')
filecontents.append("menu = {")
for (menu_name, category), icon in zip(sorted(categories.items()), icons):
    if category in used_cat:
        line = '{ "%s", programs["%s"], "%s"},' % (menu_name, category, xdg.IconTheme.getIconPath(icon, extensions=["png"]))
        filecontents.append(line)
filecontents.append("}")
fd = open("xdg_menu.lua", "w")
fd.write("\n".join(filecontents))
fd.close()
