# SeekDB
Aardwolf MUSHclient plugin to report and store Seekers clanskill Seek data.

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
\
The miniwindow will always display the current enemy and SnD quest/campaign/global quest or quickwhere target.

Mob weaknesses are shown in green, in order from weakest to strongest.
Mob strengths are shown in orange (magenta in the output), in order from strongest to weakest.
Mob immunites are shown in red.

Strengths and weaknesses below 10% are not shown.

Mob alignment is shown in output as red, white, or yellow brackets around the mob name.

Data is stored in SeekDB.db.

## Known Issues
- Seekrep and seekdb only take one keyword as a name argument.
- It's difficult to tell what type of damage to use on mobs with a lot of immunities and no weaknesses or strengths.

## Future Updates
- Trigger on seek rather than using seekrep
- Scan and con overwriting
- Scan for mobs missing from database
- Database backups
- Miscellaneous other stuff probably

## Credits
- Anssett: SeekRep 
- Crowley: Plugin Updating, SnD
- Fiendish: Aardwolf MUSHclient, GMCP Handler,  Stat Monitor
- Nick Gammon: MUSHclient, all the documentation
