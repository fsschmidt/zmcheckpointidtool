This script comes with no waranty written or implied. Use at your own risk.

Ocassionally, the zimbra table in mySQL will fail to update appropriately, causing users to receive "Object with that ID Already Exists" errors. The fix is to manually update the item_id_checkpoint for that user in the zimbra.mailbox table.

This utility will check for users that have this problem, and if you choose, fix them.

Running the utility with no options will simply print all affected accounts to the screen.

the -m flag will allow you to specify a single account to check for this problem.

the -f flag will tell the script to fix the problem. Note: If you specify -m, it will fix that mailbox ONLY. IF you do not specify -m with -f, it will find and fix ALL accounts on the mailstore with this issue.

Examples:

zmcheckpointidtool - will display all accounts with this problem.

zmcheckpointidtool -f -m user@domain.com - Will fix this one user account if it has this problem.

zmcheckpointidtool -f - will find an fix all accounts on the mailstore with this problem.

It's provided without a license. Feel free to use and distribute. An attribution would be nice, but hey, it's not like I'm going to actually be looking or checking.

This is unofficial and has no relation to nor is it endorsed by Zimbra.
