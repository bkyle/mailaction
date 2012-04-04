MailAction.applescript

Originally Developed by OmniGroup Inc.
Modified by Bryan Kyle <bryan.kyle@gmail.com>

Thanks to OmniGroup for allowing me to share these modifications!

The MailAction.applescript that comes bundled with OmniFocus will create new OmniFocus actions from specially formatted email messages.  One thing it doesn't do is attach any of the mail message's attachments to the newly created OmniFocus action.  This modified version of the default MailAction.applescript adds this functionality.

Installation
------------

1. Locate the OmniFocus.app bundle in your /Applications folder.
2. Right click on the OmniFocus.app bundle and select *Show Package Contents*
3. Navigate from the root of the bundle into Contents/Resources
4. Locate the file called MailAction.applescript and rename it to OldMailAction.applscript[^oldmailaction]
5. Copy the [modified MailAction.applescript][download] into the Contents/Resources folder.

Caveats
-------

This script will attach all of the mail attachments to only the first OmniFocus action that gets created.  If you're in the habit of creating multiple OmniFocus actions from a single mail message then you should take this into consideration.