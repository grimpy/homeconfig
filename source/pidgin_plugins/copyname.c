/*
 * Copy name of buddy
 * Copyright (C) 2007-2008
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02111-1301, USA.
 */

#define PLUGIN_ID           "grimpy-copyname"
#define PLUGIN_STATIC_NAME  "copyname"
#define PLUGIN_AUTHOR       "Grimpy <grimpy.reaper@gmail.com>"
#define PLUGIN_WEBSITE      "http://localhost/"
#define PLUGIN_VERSION      "0.1"
/* System headers */
#include <glib.h>

/* Purple headers */
#include <plugin.h>
#include <blist.h>
#include <version.h>

#include <gtk/gtkclipboard.h>

#define PREF_ROOT "/plugins/core/plugin_pack/" PLUGIN_STATIC_NAME
#define PREF_NOTIFY PREF_ROOT "/notify"

static void
copy_acount_id(PurpleBlistNode *node, gpointer plugin)
{
    PurpleBuddy *buddy;

    if (PURPLE_BLIST_NODE_IS_CONTACT(node))
        node = (PurpleBlistNode*)purple_contact_get_priority_buddy((PurpleContact*)node);
    if (!PURPLE_BLIST_NODE_IS_BUDDY(node))
        return;

    buddy = (PurpleBuddy*)node;
    GtkClipboard *clipboard = gtk_clipboard_get(GDK_SELECTION_CLIPBOARD);
    gtk_clipboard_set_text(clipboard, buddy->name, -1);
}

static void
context_menu(PurpleBlistNode *node, GList **menu, gpointer plugin)
{
    PurpleMenuAction *action;

    if (!PURPLE_BLIST_NODE_IS_BUDDY(node) && !PURPLE_BLIST_NODE_IS_CONTACT(node))
        return;

    action = purple_menu_action_new("Copy account name",
                    PURPLE_CALLBACK(copy_acount_id), plugin, NULL);
    (*menu) = g_list_prepend(*menu, action);
}

static gboolean
plugin_load(PurplePlugin *plugin)
{
    purple_signal_connect(purple_blist_get_handle(), "blist-node-extended-menu", plugin,
                        PURPLE_CALLBACK(context_menu), plugin);
    return TRUE;
}

static gboolean
plugin_unload(PurplePlugin *plugin)
{
    return TRUE;
}

static PurplePluginInfo info = {
    PURPLE_PLUGIN_MAGIC,        /* Magic                */
    PURPLE_MAJOR_VERSION,       /* Purple Major Version */
    PURPLE_MINOR_VERSION,       /* Purple Minor Version */
    PURPLE_PLUGIN_STANDARD,     /* plugin type          */
    NULL,                       /* ui requirement       */
    0,                          /* flags                */
    NULL,                       /* dependencies         */
    PURPLE_PRIORITY_DEFAULT,    /* priority             */

    PLUGIN_ID,                  /* plugin id            */
    NULL,                       /* name                 */
    PLUGIN_VERSION,                      /* version              */
    NULL,                       /* summary              */
    NULL,                       /* description          */
    PLUGIN_AUTHOR,              /* author               */
    PLUGIN_WEBSITE,             /* website              */

    plugin_load,                /* load                 */
    plugin_unload,              /* unload               */
    NULL,                       /* destroy              */

    NULL,                       /* ui_info              */
    NULL,                       /* extra_info           */
    NULL,                       /* prefs_info           */
    NULL                        /* actions              */
};

static void
init_plugin(PurplePlugin *plugin) {

    info.name = "Copy account-name";
    info.summary = "Copy an account name to the clipboard.";
    info.description = "Copy an account name to the clipboard.";

    purple_prefs_add_none(PREF_ROOT);
    purple_prefs_add_bool(PREF_NOTIFY, TRUE);
}

PURPLE_INIT_PLUGIN(PLUGIN_STATIC_NAME, init_plugin, info)
