# SeekDB
Aardwolf MUSHclient plugin to report and store Seekers clanskill Seek data.

## Updates:
### 1.15
- Added:
  - Right-click menu to the SeekDB window to customize font, colours, threshold, and damage type whitelists
  - "Short Resists" mode, Bring to Front/Send to Back and Reset to Defaults functionality
  - NOTE: Window does not update immediately after toggling Short Resists mode or making whitelist changes
- Fixes:
  - Seekrep can now take puncuated mob names (apostrophes, dashes, etc.) - still no guarantee that the mob keywords actually include those, however
  - Window has a set minimum size so it can no longer be resized to disappear
### 1.14
- seekrep now has a 2 second cooldown to prevent data corruption
- seekdb now accepts 'all' parameter for target and area
- [debug mode and delete functionality added](https://github.com/zwyatt/SeekDB/tree/main?tab=readme-ov-file#debug-mode)

## Installation
Built on Anssett's SeekRep plugin. Only have one installed.
1. Download the raw SeekDB.xml and SeekDB.lua files.
2. Move them to your Aardwolf\worlds\plugins folder.
3. In MUSHclient, File->Plugins, click Add, open SeekDB.xml.

## Usage
### Seek the target and add it to the database (if it does not already exist):
```
seekrep <target>
```
### Search the database and display the results in miniwindow and output:
```
seekdb <target> <area>
```
### Right-click on the miniwindow to customize font, colours, whitelists, etc.

The miniwindow will always display the current enemy and SnD quest/campaign/global quest or quickwhere target.

Mob weaknesses are shown in green, in order from weakest to strongest.
Mob strengths are shown in orange (magenta in the output), in order from strongest to weakest.
Mob immunites are shown in red.

Strengths and weaknesses below 10% are not shown.

Mob alignment is shown in output as red, white, or yellow brackets around the mob name.

Data is stored in SeekDB.db.

## Known Issues
- Window does not update immediately after toggling Short Resists mode or whitelist changes
- The order of damage types in whitelist menu can change, but they still work correctly
- seekrep and seekdb only take one keyword as a name argument
- Window enemy/target can only show one mob even if there are multiple database results
- Search & Destroy quickwhere doesn't show the name of the actual mob found in SeekDB
- It's difficult to tell what type of damage to use on mobs with a lot of immunities and no weaknesses or strengths

## Future Updates
- Option to show and group resist values
- Fixes for multiple database results, mobs with many immunities, window updating after short resist and whitelist changes
- Trigger on seek rather than using seekrep
- Scan and con overwriting
- Scan for mobs missing from database
- Database backups
- Miscellaneous other stuff probably

## Debug Mode
### Toggle debug mode, will show mob IDs in seekdb results and additional DebugNotes (need cleaning up)
```
seekdb debug
```
### Delete a mob
```
seekdb delete <mobid>
```

### Confirm mob deletion
```
seekdb delete <mobid> confirm
```

## Credits
- Anssett: SeekRep 
- Crowley: Plugin updating stuff, SnD
- Fiendish: Aardwolf MUSHclient, GMCP Handler,  miniwindow stuff from Stat Monitor
- Nick Gammon: MUSHclient, all the documentation
