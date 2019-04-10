# Assistant

The **Assistant** is an application to display html messages and action buttons to the user.

**This project is under development**. It will be reworked and modified during september '18. This tool is part of the MacHelper project but can also be used for different purposes.

**Action Buttons are currently disabled**


## Principles

Tierce applications can post distributed notifications to the **Assistant** to display information to the user. The view is defined with a html file and buttons can be defined in the payload.

### Notification payload

The messages structure is defined in the userinfo of the notification. An example of the structure can be found in the demo scenario of the MacHelper project.

#### Message structure

- frame
	- position
	- size
- view
	- path to the html file
	- buttons
		- frame
		- label
		- script

### Buttons

There are currently 3 types of buttons:

- Close button: close the window
- Terminate button: terminate the **Assistant**
- Script button: run a script

#### Script buttons

The script can be written in bash, python or applescript (coming soon). It can also be used to communicate with the MacHelper.

#### Communication with the MacHelper

Notifications can be sent to the MacHelper to trigger conditions. Notifications are sent to the MacHelper with the application **MacHelperNotifier**. For example, define a bash script for a button to inform the MacHelper that the user correctly pressed a button on the assistant view:

```
/path/to/MacHelperNotifier -signal GoToSceneSkype
```

