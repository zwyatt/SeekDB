# SeekDB
Aardwolf MUSHclient plugin to report and store Seekers clanskill Seek data.

## Updates:
### 1.6
- Triggers on seek, no more cooldown, can toggle seek reporting on/off
- "Neutral" resists added, with customizable immunity threshold
- Resists are now grouped if they are All Phys or All Mag the same way immunities are
- Strong resists are now orange in output
- Database safety improvements
- Fixed window enemy swapping between <no target> and the actual enemy when aggrod

### 1.51
- Added:
  - Right-click menu to the SeekDB window to customize font, colours, threshold, and damage type whitelists
  - "Short Resists" mode, Bring to Front/Send to Back and Reset to Defaults functionality
  - NOTE: Window does not update immediately after toggling Short Resists mode or making whitelist changes
- Fixes:
  - Seekrep can now take puncuated mob names (apostrophes, dashes, etc.) - still no guarantee that the mob keywords actually include those, however
  - Window has a set minimum size so it can no longer be resized to disappear

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

The miniwindow displays the current enemy and SnD quest/campaign/global quest or quickwhere target, in addition to 'seekdb <target> <area>' results.

Mob weaknesses are shown in green, in order from weakest to strongest.
Neutral resists are shown in grey, in order from weakest to strongest. Neutral resists are only shown when the number of immunities meets or exceeds the set threshold (5 by default).
Mob strengths are shown in orange, in order from strongest to weakest.
Mob immunites are shown in red.

Data is stored in SeekDB.db.

## Known Issues
- Window does not update immediately after toggling Short Resists mode or whitelist changes
- The order of damage types in whitelist menu can change, but they still work correctly
- seekrep and seekdb only take one keyword as a name argument
- Window enemy/target can only show one mob even if there are multiple database results
- Search & Destroy quickwhere doesn't show the name of the actual mob found in SeekDB
- Seekdb takes Fractal Anomaly's name colour codes as literal text, it still works though

## Future Updates
- Option to show and group resist values
- Fixes for multiple database results, window updating after short resist and whitelist changes
- Scan and con overwriting
- Scan for mobs missing from database
- Database backups
- Etc.

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
