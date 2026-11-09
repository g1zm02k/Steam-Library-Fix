# Steam Library Fix

Pre-Note: I find that running Steam™ under DevMode is more convenient for me so these changes are done immediately without restarting...
  If you wish to follow along, just create a shortcut and append `-dev` so it looks like `"C:\Program Files (x86)\Steam\Steam.exe" -dev`

The main script gives the option to restart Steam™ regardless so this _isn't_ a requirement.

## Anyway...

This is a fix for Steam™'s Library to hide the annoying "What's New" and/or "Shelf" section(s) — also the "Big Picture icon" for those clumsy clickers too.

What started as a simple enough script on PasteBin — now with over 2.1K views (https://pastebin.com/WXbp8X46) — has now been modified to have a nice little GUI.

Since I went that far, I decided to add auto-detection of the Steam directory, and some nice GUI elements to tell you the status of the offending CSS file, along with which of the three fixes have already been sorted.

I've added the original script purely for posterity reasons and for those with a 'No Frills' attitude and just want to get the job done (with the suffix "-basic".

**Recent additions (26/11/09):** Added a 'History' directory to show my working over time for those curious sorts; no-one's perfect, and here's proof!

### Upcoming (done, but still bug-fixing):
* Checking all CSS files for matches in case Valve™ decides to change the filename again; trying to keep ahead for less updates in the future!
* Rewrote the install directory check to stop searching when it finds a match rather than processing all tests regardless.
* Check for github updates and alert the user (casually) that there's an update available.

### Notes:
I've uploaded the script (why not)...

The CSS check is set up to default to the current naming of "sp.css" if it _fails_ to find a match in other "css" files. That way it won't fail outright if all changes were made (there won't be a match to find otherwise and it'll have a hissy-fit otherwise).

As "sp.css" is the current name set by Valve it should be safe to reference for the time being (until I add in the "ini" change at least - see below).

### Stuff to add/fix:
* Back up any changes to an "ini" to restore if required; tiny text block holding only the changes made vs. a 4MB complete backup makes far more sense (the fix is working on a test script, restoring them is more of an issue although I have an idea or two).
* Still debating whether it's _worth_ putting in a restore option since you can just rename the backup and run the script again; with the console running it's done almost instantaneously anyway...
* Other...
