-- Copyright 2007 The Omni Group.  All rights reserved.
--
-- $Header: svn+ssh://source.omnigroup.com/Source/svn/Omni/tags/OmniFocus/1.10/GM-77.90.3/OmniGroup/Applications/OmniFocus/App/Preferences/MailAction.applescript 110059 2009-03-12 04:33:13Z kc $

using terms from application "Mail"
	-- Trims "foo <foo@bar.com>" down to "foo@bar.com"
	on trim_address(theAddress)
		try
			set AppleScript's text item delimiters to "<"
			set WithoutPrefix to item 2 of theAddress's text items
			set AppleScript's text item delimiters to ">"
			set MyResult to item 1 of WithoutPrefix's text items
		on error
			set MyResult to theAddress
		end try
		set AppleScript's text item delimiters to {""} --> restore delimiters to default value
		return MyResult
	end trim_address
	
	
	on process_message(theMessage)
		tell application "OmniFocus"
			log "OmniFocus calling process_message in MailAction script"
		end tell
		-- Allow the user to type in the full sender address in case our trimming logic doesn't handle the address they are using.
		set theSender to sender of theMessage
		set trimmedSender to my trim_address(theSender)
		tell application "OmniFocus"
			set AllowedSender to allowed mail senders
			if AllowedSender does not contain trimmedSender and AllowedSender does not contain theSender then
				return
			end if
		end tell
		
		set theSubject to subject of theMessage
		set singleTask to false
		if (theSubject starts with "Fwd: ") then
			-- Whole forwarded messages shouldn't split.
			set singleTask to true
			set theSubject to text 6 through -1 of theSubject
		end if
		set theText to theSubject & return & content of theMessage
		tell application "OmniFocus"
			tell default document
				set theTask to parse tasks with transport text theText as single task singleTask
				my add_attachments_to_task(theMessage, theTask)
			end tell
		end tell
	end process_message
	
	on add_attachments_to_task(theMessage, theTaskList)
		using terms from application "OmniFocus"
				set t to item 1 of theTaskList
				tell note of t
					using terms from application "Mail"
						repeat with theAttachment in mail attachments of theMessage
							
							set theAttachmentPath to "/tmp/" & name of theAttachment
							
							-- Ensure that there isn't already a file in /tmp with the name we want.
							-- This really shouldn't delete existing files, instead a new 
							try
								tell application "Finder" to delete POSIX file theAttachmentPath as string
							end try
							
							try
								save theAttachment in theAttachmentPath
							on error
								-- Failed the save the attachment, we should just bail here
							end try
							
							try
								using terms from application "OmniFocus"
									set theRTFAttachment to make new file attachment with properties {file name:theAttachmentPath, embedded:true}
									insert theRTFAttachment
								end using terms from
							end try
							
							try
								tell application "Finder" to delete POSIX file theAttachmentPath as string
							end try
						end repeat
					end using terms from
				end tell
		end using terms from
	end add_attachments_to_task
	
	on perform mail action with messages theMessages
		try
			set theMessageCount to count of theMessages
			repeat with theMessageIndex from 1 to theMessageCount
				my process_message(item theMessageIndex of theMessages)
			end repeat
		on error m number n
			tell application "OmniFocus"
				log "Exception in Mail action: (" & n & ") " & m
			end tell
		end try
	end perform mail action with messages
end using terms from


