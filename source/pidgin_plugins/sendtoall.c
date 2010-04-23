/*
 * Adds a command to flip a coin in a conversation and outputs the result
 * Copyright (C) 2005 Gary Kramlich <grim@reaperworld.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02111-1301, USA.
 */

#include <time.h>
#include <stdlib.h>

#include <cmds.h>
#include <conversation.h>
#include <debug.h>
#include <plugin.h>
#include <version.h>

static PurpleCmdId cmd_id = 0;

static PurpleCmdRet
send_to_all(PurpleConversation *conv, const gchar *cmd, gchar **markup,
        gchar *error, void *data)
{
    PurpleConversation *conversation = NULL;
    GList *conversations = purple_get_conversations();
    while(conversations != NULL)
    {
        conversation = conversations->data;
        if(conv->type == PURPLE_CONV_TYPE_IM)
            purple_conv_im_send(PURPLE_CONV_IM(conversation), markup[0]);
        else if(conv->type == PURPLE_CONV_TYPE_CHAT)
            purple_conv_chat_send(PURPLE_CONV_CHAT(conversation), markup[0]);

        conversations = conversations->next;
    }
    //g_free(msg);

    return PURPLE_CMD_RET_OK;
}

static gboolean
plugin_load(PurplePlugin *plugin) {
    cmd_id = purple_cmd_register("all", "s", PURPLE_CMD_P_PLUGIN,
                                    PURPLE_CMD_FLAG_IM | PURPLE_CMD_FLAG_CHAT,
                                    NULL, PURPLE_CMD_FUNC(send_to_all),
                                    "Sends message to all open windows",
                                    NULL);

    return TRUE;
}

static gboolean
plugin_unload(PurplePlugin *plugin) {
    purple_cmd_unregister(cmd_id);

    return TRUE;
}

static PurplePluginInfo info =
{
    PURPLE_PLUGIN_MAGIC,                                /**< magic          */
    PURPLE_MAJOR_VERSION,                               /**< major version  */
    PURPLE_MINOR_VERSION,                               /**< minor version  */
    PURPLE_PLUGIN_STANDARD,                             /**< type           */
    NULL,                                               /**< ui_requirement */
    0,                                                  /**< flags          */
    NULL,                                               /**< dependencies   */
    PURPLE_PRIORITY_DEFAULT,                            /**< priority       */

    "grimpy-sendtoall",                            /**< id             */
    NULL,                                               /**< name           */
    "0.1",                                         /**< version        */
    NULL,                                               /**  summary        */
    NULL,                                               /**  description    */
    "grimpy.reaer@gmail.com",         /**< author         */
    "http://localhost/",                                         /**< homepage       */

    plugin_load,                                        /**< load           */
    plugin_unload,                                      /**< unload         */
    NULL,                                               /**< destroy        */

    NULL,                                               /**< ui_info        */
    NULL,                                               /**< extra_info     */
    NULL,                                               /**< prefs_info     */
    NULL,                                               /**< actions        */
    NULL,                                               /**< reserved 1     */
    NULL,                                               /**< reserved 2     */
    NULL,                                               /**< reserved 3     */
    NULL,                                               /**< reserved 4     */
};

static void
init_plugin(PurplePlugin *plugin) {

    info.name = "Send to all";
    info.summary = "Send message to all";
    info.description = "Adds a command (/all) to a message to all open conversations ";
}

PURPLE_INIT_PLUGIN(sendtoall, init_plugin, info)
