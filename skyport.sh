#!/bin/sh

if [ $# -lt 2 ]; then
  echo "Usage: $0 <yourskypename> (-c <conversationname> | <otherskypename>)"
  echo ""
  echo "Dumps either a user's chat history or, if '-c' was provided, a  "
  echo "conversation history. By default the name of a conversation is the  "
  echo "concatenation of its members separated by ','. This can be changed  "
  echo "by right-clicking on the conversation and setting its topic to      "
  echo "something else (recommended). Dumps author, timestamp and body "
  echo "(as xml), one per line"
  echo ""
  echo "It's been developed on OXx and does not work for other systems      "
  echo "currently. Tested with Skype version 5.7.0.1037."
  echo ""
  echo "Dependencies:                                                       "
  echo " - (OSx) Developer Tools for sqlite3"
  echo ""
  echo "Credits: "
  echo "http://superuser.com/questions/312119/is-there-a-way-to-export-chat-history-in-skype-5-2-x-for-os-x."
  echo ""
  echo "Licensed as GNU GPL v3. "
  echo "See LICENSE file or http://www.gnu.org/licenses/"
  exit 1
fi

# Points to the Skype directory that keeps the user folders
SKYPE_HOME="$HOME/Library/Application Support/Skype"

echo $SKYPE_HOME
# Dump conversation or chat history?
if [ $2 == '-c' ]; then
    echo "Dumping conversation '$3'..."
    sqlite3 "$SKYPE_HOME/$1/main.db" "SELECT author, datetime(Messages.timestamp, 'unixepoch'), body_xml from Messages INNER JOIN Chats ON Messages.chatname = Chats.name WHERE Chats.friendlyname=\"$3\""
else
    echo "Dumping chat history for '$2'..."
    sqlite3 "$SKYPE_HOME/$1/main.db" "SELECT author, datetime(timestamp, 'unixepoch'), body_xml FROM Messages WHERE dialog_partner = '$2'"
fi

## Statements for the curious:

# List tables
# sqlite3  ~/Library/Application\ Support/Skype/$1/main.db "SELECT name FROM sqlite_master  WHERE type='table' ORDER BY name;"

# List table definition (here for messages table)
# sqlite3 ~/Library/Application\ Support/Skype/$1/main.db "pragma table_info(messages)"
