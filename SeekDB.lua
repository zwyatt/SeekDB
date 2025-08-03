require 'wrapped_captures'
require 'aardwolf_colors'
require 'tprint'

function seekFail()
  Note("Something broke, or seek failed and you need to try again.")
end

function initTarget()
targetArray = {
  shortn = "",
  baselev = 0,
  timeskilled = 0,
  align = "",
  identical = 0,
  immunities={
    {immuName="Air", immuVal=false, immuType="magic" },
    {immuName="Acid", immuVal=false, immuType="magic" },
    {immuName="Bash", immuVal=false, immuType="physical" },
    {immuName="Cold", immuVal=false, immuType="magic" },
    {immuName="Disease", immuVal=false, immuType="magic" },
    {immuName="Earth", immuVal=false, immuType="magic" },
    {immuName="Electric", immuVal=false, immuType="magic" },
    {immuName="Energy", immuVal=false, immuType="magic" },
    {immuName="Fire", immuVal=false, immuType="magic" },
    {immuName="Holy", immuVal=false, immuType="magic" },
    {immuName="Light", immuVal=false, immuType="magic" },
    {immuName="Magic", immuVal=false, immuType="magic" },
    {immuName="Mental", immuVal=false, immuType="magic" },
    {immuName="Negative", immuVal=false, immuType="magic" },
    {immuName="Pierce", immuVal=false, immuType="physical" },
    {immuName="Poison", immuVal=false, immuType="magic" },
    {immuName="Shadow", immuVal=false, immuType="magic" },
    {immuName="Slash", immuVal=false, immuType="physical" },
    {immuName="Sonic", immuVal=false, immuType="magic" },
    {immuName="Water", immuVal=false, immuType="magic" }
  },
  notes = "",
  resists={
    {resName="Air", resval=0},
    {resName="Acid", resval=0},
    {resName="Bash", resval=0},
    {resName="Cold", resval=0},
    {resName="Disease", resval=0},
    {resName="Earth", resval=0},
    {resName="Electric", resval=0},
    {resName="Energy", resval=0},
    {resName="Fire", resval=0},
    {resName="Holy", resval=0},
    {resName="Light", resval=0},
    {resName="Magic", resval=0},
    {resName="Mental", resval=0},
    {resName="Negative", resval=0},
    {resName="Pierce", resval=0},
    {resName="Poison", resval=0},
    {resName="Shadow", resval=0},
    {resName="Slash", resval=0},
    {resName="Sonic", resval=0},
    {resName="Water", resval=0}
  }
}
end

function trim(s)
  return(string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

function resSplit(instring)
  split1 = trim(string.sub(instring,0,31))
  split2 = trim(string.sub(instring,31,58))
  if(split1 ~= "") then
    local tbl = resSubSplit(split1)
    for i,j in ipairs(targetArray.resists) do
        if j.resName == tbl[1] then j.resval = tonumber(tbl[2]) end
    end
  end
  if (split2 ~= "") then
    local tbl=resSubSplit(split2)
    for i,j in ipairs(targetArray.resists) do
        if j.resName == tbl[1] then j.resval = tonumber(tbl[2]) end
    end
  end
end

function resSubSplit(instring)
  local splitTable = {}
  for str in string.gmatch(instring,"([^:]+)") do
    local tmpstr = string.gsub(str,"%%","")
    table.insert(splitTable,trim(tmpstr))
  end
  return splitTable
end

function parseImm(input)
  for _,j in pairs(input) do
    for x,y in ipairs(targetArray.immunities) do
      if string.lower(targetArray.immunities[x].immuName) == trim(string.lower(j)) then
        targetArray.immunities[x].immuVal = true
      elseif trim(string.lower(j)) == "allmagic" then
        if targetArray.immunities[x].immuType == "magic" then targetArray.immunities[x].immuVal = true end
      elseif trim(string.lower(j)) == "allphysical" then
        if targetArray.immunities[x].immuType == "physical" then targetArray.immunities[x].immuVal = true end
      end
    end
  end
end

function showVuln()
  local sepColor = getSepColor()
  local resNameColor = getResNameColor()
  local resValColor = getResValColor()

  local outString = resNameColor .. targetArray.shortn .. " NOT immune to: "
  local vulnArray = {}
  for i=1,#targetArray.immunities do
    if not targetArray.immunities[i].immuVal then
      table.insert(vulnArray,targetArray.immunities[i].immuName)
    end
  end
  catString = table.concat(vulnArray,", " )
  catSring = string.gsub(catString,", ",sepColor..", "..resValColor)
  outString = outString .. resValColor .. catString
  return outString
end

function OnHelp ()
  local borderColor = "@x025"
  local textColor = "@x178"
  local cmdColor = "@W"
  
  colorsToAnsiNote(borderColor .. "------------------" .. textColor .. " SeekRep Help " .. borderColor .. "------------------")
  Note()
  colorsToAnsiNote(borderColor .. "--==" .. textColor .. "Initial Setup" .. borderColor .. "==--")
  colorsToAnsiNote(textColor .. "After the first installation, run " .. cmdColor .. "seekrep config help")
  Note()
  colorsToAnsiNote(borderColor .. "--==" .. textColor .. " General Use " .. borderColor .. "==--")
  Note()
  colorsToAnsiNote(borderColor .. "- " .. textColor .. "Add a mob to the database (and report seek too, I guess) " .. borderColor .. "-")
  colorsToAnsiNote(cmdColor .. "seekrep <target> [top|bot] [quantity]")
  colorsToAnsiNote(cmdColor .. "   <target>" .. textColor .. "    Required. Single keyword of target. Ordinal targets are ok (1.lasher,")
  colorsToAnsiNote(textColor .. "               2.lasher, etc.) multiple words or quotes are not.")
  colorsToAnsiNote(cmdColor .. "   [top|bot|immcheck|all|verbose]" .. textColor .. "   Optional. If nothing given, defaults to " .. cmdColor .. "bot" .. textColor .. ". " .. cmdColor)
  colorsToAnsiNote(cmdColor .. "               bot" .. textColor .. " sorts ascending, " .. cmdColor .. "top" .. textColor .. " sorts descending.")
  colorsToAnsiNote(cmdColor .. "               immcheck" .. textColor .. " returns non-immune damtypes. " .. cmdColor .."all" .. textColor .. " does a rewrite of seek output to")
  colorsToAnsiNote(textColor .. "                        include 0 value resists instead of hiding them.")
  colorsToAnsiNote(cmdColor .. "               verbose" .. textColor .. " is mostly used for debugging right now.")
  colorsToAnsiNote(cmdColor .. "   [quantity]" .. textColor .. "  Optional. Restricts quantity of results.")
  Note()
  colorsToAnsiNote(borderColor .. "- " .. textColor .. "Search for a mob in the database " .. borderColor .. "-")
  colorsToAnsiNote(cmdColor .. "seekdb <target> <area>")
  colorsToAnsiNote(cmdColor .. "   <target>" .. textColor .. "   Optional. Single keyword of target.")
  colorsToAnsiNote(cmdColor .. "   <area>" .. textColor .. "     Optional. Defaults to current area. Requires " .. cmdColor .. "<target> " .. textColor .. "argument and must match")
  colorsToAnsiNote(textColor .. "              area keyword exactly.")
  Note()
  colorsToAnsiNote(borderColor .. "--==" .. textColor .. "  Examples   " .. borderColor .. "==--")
  Note()
  colorsToAnsiNote(cmdColor .. "seekrep lasher top 3" .. textColor .. "  Performs " .. cmdColor .. "seek" .. textColor .. " on lasher, then prints his highest 3 resistances.")
  Note()
  colorsToAnsiNote(cmdColor .. "seekrep lasher 5" .. textColor .. "      Performs " .. cmdColor .. "seek" .. textColor .. " on lasher, then prints his lowest 5 resistances.")
  Note()
  colorsToAnsiNote(cmdColor .. "seekdb" .. textColor .. "                Searches DB for all mobs in the area.")
  Note()
  colorsToAnsiNote(cmdColor .. "seekdb imp" .. textColor .. "            Searches DB for all mobs with 'imp' in the name in the current area.")
  Note()
  colorsToAnsiNote(cmdColor .. "seekrep imp aylor" .. textColor .. "     Searches DB for all mobs with 'imp' in the name in the area 'aylor'.")
  colorsToAnsiNote(borderColor .. "--------------------------------------------------")
end

function startSeek(name, line, args)
  target = args.name
  dir = args.dir or "nil"
  qty = tonumber(args.qty) or -1
  initTarget()

  local command = "seek " .. target
  local startTag = "^\\-+$"
  local endTag = "^\\-+$"
  local tagsAreRegex=true
  local noCommandEcho=false
  local omitResponse=true
  local noFollowPrompt=false
  local sendViaExecute=true

  -- uncomment next 2 lines once wrapped_capture update from Crowley goes in. If it goes in.
--  local timeoutDuration=5
--  Capture.tagged_output(command,startTag,endTag,tagsAreRegex,noCommandEcho,omitResponse,noFollowPrompt,processCapture,sendViaExecute,seekFail,timeoutDuration)

  Capture.tagged_output(command,startTag,endTag,tagsAreRegex,noCommandEcho,omitResponse,noFollowPrompt,processCapture,sendViaExecute,seekFail)

end

function processCapture(lines)
  new_table = {}
  local outText = ""

  --remove color data etc
  for k, v in ipairs(lines) do
      stripped = strip_colours_from_styles(v)
      if (stripped ~= "" and 
          stripped ~="------------------------- [ Resistances ] ----------------------") then
          table.insert(new_table, stripped)
      end
  end

  --process de-colored data
  for i,j in ipairs(new_table) do
      if string.find(j,"Mob Short Name") ~=nil then
        targetArray.shortn = trim(string.match(j, ":(.*)"))
      elseif string.find(j,"Mob Base Level") ~= nil then
        targetArray.baselev = trim(string.match(j, ":(.*)"))
      elseif string.find(j,"Identical Mobs") ~= nil then
        targetArray.identical = trim(string.match(j, ":(.*)"))
      elseif string.find(j,"Times Killed") ~= nil then
        targetArray.timeskilled = trim(string.match(j, ":(.*)"))
      elseif string.find(j,"Alignment") ~= nil then
        targetArray.align = trim(string.match(j, ":(.*)"))
      elseif string.find(j,"Note") ~= nil then
        targetArray.notes = trim(string.match(j, ":(.*)"))
      elseif string.find(j,"%a+%s+:%s+[-%.%d]+") ~= nil then
        resSplit(j)
      elseif string.find(j,"Immunities") ~= nil then
        parseImm(utils.split(trim(string.match(j, ":(.*)")),","))
      elseif string.find(j,"(%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s)(.*)") ~= nil then
        parseImm(utils.split(trim(j),","))
      end
  end

  new_seek()

  if dir == "verbose" then
    tprint(targetArray)
  elseif dir=="immcheck" then
    outText = showVuln()
  elseif dir=="all" then
    redrawSeek()
  else
    if qty>0 then
      outText = tableString(getTableX(qty,dir))
    else
      --tprint(targetArray)
      --nobody's going to use this, right?
      --wrong.
      outText = tableString(getTableX(#targetArray.resists,"bot"))
    end
  end

if outText ~= "" then
    outType = getOutput()
    if (outType == "echo") or (outType == "both") then
      colorsToAnsiNote(outText)
    end
    if (outType == "channel") or (outType == "both") then
      SendNoEcho(getChannel() .. " "..outText)
    end
  end
end

function redrawSeek()
  colorsToAnsiNote("@W----------------------------------------------------------------@w")
  colorsToAnsiNote("@WYour research into @R" .. targetArray.shortn .. "@W reveals the following .... @w")
  Note() --"@W"
  colorsToAnsiNote("@GMob Short Name   : @w" .. targetArray.shortn .. "@w")
  colorsToAnsiNote("@GMob Base Level   : @w" .. targetArray.baselev .. "@w")
  colorsToAnsiNote("@GIdentical Mobs   : @w" .. targetArray.identical .. "@w")
  colorsToAnsiNote("@GTimes Killed     : @w" .. targetArray.timeskilled .. "@w")
  colorsToAnsiNote("@GAlignment        : @w" .. targetArray.align .. "@w")
  colorsToAnsiNote("@WNote             @w: @G" .. targetArray.notes .. "@w")
  colorsToAnsiNote("@WImmunities       : @w" .. "<do something here to reconstruct immunities>" .. "@w")
  colorsToAnsiNote("@W------------------------- @G[ Resistances ]@W ----------------------@w")
  colorsToAnsiNote("@gBash            @W:@g    " .. getVal("Bash") .. "%      Pierce          @W:@g    " .. getVal("Pierce") .. "% @w")
  colorsToAnsiNote("@gSlash           @W:@g    " .. getVal("Slash") .. "%      Acid            @W:@g    " .. getVal("Slash") .. "% @w")
  colorsToAnsiNote("@gAir             @W:@g    " .. getVal("Air") .. "%      Cold            @W:@g    " .. getVal("Cold") .. "% @w")
  colorsToAnsiNote("@gDisease         @W:@g    " .. getVal("Disease") .. "%      Earth           @W:@g    " .. getVal("Earth") .. "% @w")
  colorsToAnsiNote("@gElectric        @W:@g    " .. getVal("Electric") .. "%      Energy          @W:@g    " .. getVal("Energy") .. "% @w")
  colorsToAnsiNote("@gFire            @W:@g    " .. getVal("Fire") .. "%      Holy            @W:@g    " .. getVal("Holy") .. "% @w")
  colorsToAnsiNote("@gLight           @W:@g    " .. getVal("Light") .. "%      Magic           @W:@g    " .. getVal("Magic") .. "% @w")
  colorsToAnsiNote("@gMental          @W:@g    " .. getVal("Mental") .. "%      Negative        @W:@g    " .. getVal("Negative") .. "% @w")
  colorsToAnsiNote("@gPoison          @W:@g    " .. getVal("Poison") .. "%      Shadow          @W:@g    " .. getVal("Shadow") .. "% @w")
  colorsToAnsiNote("@gSonic           @W:@g    " .. getVal("Sonic") .. "%      Water           @W:@g    " .. getVal("Water") .. "% @w")
  colorsToAnsiNote("@W---------------------------------------------------------------- @w")


end

function getVal(searchStr)
  for i,j in pairs(targetArray.resists) do
    if string.lower(j.resName) == string.lower(searchStr) then
        return j.resval
    end
  end
--  tprint(targetArray.resists)
  return 0
end

function colorsToAnsiNote(data)
  return AnsiNote(ColoursToANSI(data))
end

function tblLT(a,b)
  return a.resval<b.resval
end

function tblGT(a,b)
  return b.resval<a.resval
end

function getTableX(amount,direction)
  local outTable = {}
  if(direction == "top") then --sort largest -> smallest
    table.sort(targetArray.resists,tblGT)
  else -- sort smallest -> largest. default for now, probably most common.
    table.sort(targetArray.resists,tblLT)
  end
  if amount<1 then amount=#targetArray.resists end
  if amount>#targetArray.resists then amount=#targetArray.resists end --lol ty scars
    for x=1,amount do
        table.insert(outTable,targetArray.resists[x])
    end
  return outTable
end

function tableString(intab)
  local buildString = ""
  local sepColor = getSepColor()
  local resNameColor = getResNameColor()
  local resValColor = getResValColor()
  local dupVals = false
--  local lastVal = -1

  buildString = resNameColor .. "Target: " .. resValColor .. targetArray.shortn .. sepColor .. " | "
  for x=1,#intab do
    if (x+1<=#intab) and (intab[x].resval == intab[x+1].resval) then
      --resval and resval+1 are equal, enter duplicate cluster loop
      if dupVals==false then --previous loop was not a duplicate loop, start duplicate loop
        dupVals = true
      end
      buildString = buildString .. resNameColor .. intab[x].resName
    elseif (dupVals ==true and x==#intab) then --last record, gotta check if dupvals flag is set
      buildString = buildString .. resNameColor .. intab[x].resName .. " " .. resValColor .. intab[x].resval .. "%" .. sepColor .. " | @w"
      dupVals = false
    else
      if dupVals == true then
        buildString = buildString ..intab[x].resName .. " " .. resValColor .. intab[x].resval .. "%".. sepColor .. " | @w"
        dupVals = false
      else
        buildString = buildString .. resNameColor.. intab[x].resName..": "..resValColor ..intab[x].resval .. "%" .. sepColor .. " | @w"
      end
    end

    if dupVals == true then 
      buildString = buildString .. ", "
    end
--[[ uncomment to restore to old functionality
    buildString = buildString .. resNameColor.. intab[x].resName..": "..resValColor ..intab[x].resval .. "%" .. sepColor .. " | @w"
    ]]
  end

  return buildString
end

function config_handler(name, line, args)
    arg = args.command
   if arg=="" then
    local sepColor = getSepColor()
    local resNameColor = getResNameColor()
    local resValColor = getResValColor()
     colorsToAnsiNote(resNameColor .. "--------------[" .. resValColor .. " SeekRep configuration "..resNameColor .. "]--------------")
     colorsToAnsiNote(resNameColor .. "")
     colorsToAnsiNote(resNameColor .. " Output config:       " .. resValColor .. getOutput())
     colorsToAnsiNote(resNameColor .. " Channel:             " .. resValColor .. getChannel())
     colorsToAnsiNote(resNameColor .. " Resist Value Color:  ")
                 Note("                      " .. getResValColor())
     colorsToAnsiNote(resNameColor .. " Resist Name Color:   ")
     Note("                      " .. getResNameColor())
     colorsToAnsiNote(resNameColor .. " Separator Color:     ")
     Note("                      " .. getSepColor())
     colorsToAnsiNote(resNameColor .. "")
     colorsToAnsiNote(resNameColor .. "----------------[" .. resValColor .. " End configuration "..resNameColor .. "]----------------")
   elseif arg == "channel" then
      Note("Set reporting channel to " .. args.value)
      setChannel(args.value)
   elseif arg == "rvcolor" then
      Note("Set resist value color to ".. args.value)
      setResValColor(args.value)
   elseif arg == "rncolor" then
      Note("Set resist name color to ".. args.value)
      setResNameColor(args.value)
   elseif arg == "sepcolor" then
      Note("Set separator color to " .. args.value)
      setSepColor(args.value)
   elseif arg == "output" then
      Note("Set output method to " .. args.value)
      setOutput(args.value)
   elseif arg == "help" then
      configHelp()
   elseif arg== "reset" then
     Note("Resetting config to defaults.")
     --reset things
     SaveState()
   end
 end

 function setOutput(value)
  SetVariable("output",value)
  SaveState()
 end
 
 function getOutput()
  local output = GetVariable("output")
  return output
 end

 function setChannel(value)
  SetVariable("outChannel",value)
  SaveState()
 end

 function getChannel()
  local chan = GetVariable("outChannel")
  return chan
 end
 
 function setResValColor(value)
  SetVariable("resValColor",value)
  SaveState()
 end

 function getResValColor()
  local rvColor = GetVariable("resValColor")
  return rvColor
 end

 function setResNameColor(value)
  SetVariable("resNameColor",value)
  SaveState()
 end
 
 function getResNameColor()
  local rnColor = GetVariable("resNameColor")
  return rnColor
 end
 
 function setSepColor(value)
  SetVariable("sepColor",value)
  SaveState()
 end
 
 function getSepColor()
  local sepColor = GetVariable("sepColor")
  return sepColor
 end

function configHelp()
  local sepColor = getSepColor()
  local resNameColor = getResNameColor()
  local resValColor = getResValColor()
  Note()
  colorsToAnsiNote(resNameColor .. "----------[" .. resValColor .. " SeekRep configuration options "..resNameColor .. "]----------")
  colorsToAnsiNote(resNameColor .. "")
  colorsToAnsiNote(resNameColor .. " seekrep config" .. resValColor .. " [output|channel|rvcolor|rncolor|sepcolor|reset|help] <value>")
  colorsToAnsiNote(resNameColor .. "   output:   "..resValColor.."[echo|channel|both] " ..resNameColor .. "set the output method - to echo, to a channel or to both echo and channel.")
  colorsToAnsiNote(resNameColor .. "   channel:  "..resValColor.."[string]            " ..resNameColor .. "set the game channel that seek reports to")
  colorsToAnsiNote(resNameColor .. "   rvcolor:  "..resValColor.."[string]            " ..resNameColor .. "set the color code for resist values. Use @ prefixed colors. Supports xterm or mud colors.")
  colorsToAnsiNote(resNameColor .. "   rncolor:  "..resValColor.."[string]            " ..resNameColor .. "set the color code for resist names. Use @ prefixed colors. Supports xterm or mud colors.")
  colorsToAnsiNote(resNameColor .. "   sepcolor: "..resValColor.."[string]            " ..resNameColor .. "set the color code for the separator characters. Supports xterm or mud colors.")
  colorsToAnsiNote(resNameColor .. "   reset:    "..resValColor.."                    " ..resNameColor .. "resets config values to defaults.")
  colorsToAnsiNote(resNameColor .. "   help:     "..resValColor.."                    " ..resNameColor .. "This data.")
  colorsToAnsiNote(resNameColor .. "")
  colorsToAnsiNote(resNameColor .. "---------------------[" .. resValColor .. " End help "..resNameColor .. "]---------------------")
end

function isEmpty(testme)
  return testme == nil or testme==""
end

function resetVars()
  setResValColor("@x184")
  setResNameColor("@W")
  setSepColor("@M")
  setChannel("gtell")
  setOutput("echo")
end

function initVars()
  if isEmpty(getResValColor()) then setResValColor("@x184") end
  if isEmpty(getResNameColor()) then setResNameColor("@W") end
  if isEmpty(getSepColor()) then setSepColor("@M") end
  if isEmpty(getChannel()) then setChannel("gtell") end
  if isEmpty(getOutput()) then setOutput("echo") end
end

---------------------- End SeekRep Code ---------------------

----------------------- Database Code -----------------------
local db_path = GetPluginInfo(GetPluginID(), 20) .. "SeekDB.db"
db = sqlite3.open(db_path)
-- db = sqlite3.open_memory()

db:exec[[
  CREATE TABLE IF NOT EXISTS mob (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    area TEXT,
    level INTEGER,
    align TEXT,
    resistsID INTEGER,
    immunitiesID integer,
    FOREIGN KEY(resistsID) REFERENCES resists(id),
    FOREIGN KEY(immunitiesID) REFERENCES immunities(id)
  );

  CREATE TABLE IF NOT EXISTS resists (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    air REAL,
    acid REAL,
    bash REAL,
    cold REAL,
    disease REAL,
    earth REAL,
    electric REAL,
    energy REAL,
    fire REAL,
    holy REAL,
    light REAL,
    magic REAL,
    mental REAL,
    negative REAL,
    pierce REAL,
    poison REAL,
    shadow REAL,
    slash REAL,
    sonic REAL,
    water REAL
  );

  CREATE TABLE IF NOT EXISTS immunities (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    air INTEGER,
    acid INTEGER,
    bash INTEGER,
    cold INTEGER,
    disease INTEGER,
    earth INTEGER,
    electric INTEGER,
    energy INTEGER,
    fire INTEGER,
    holy INTEGER,
    light INTEGER,
    magic INTEGER,
    mental INTEGER,
    negative INTEGER,
    pierce INTEGER,
    poison INTEGER,
    shadow INTEGER,
    slash INTEGER,
    sonic INTEGER,
    water INTEGER
  );
]]

--[[ Helpers ]]--

-- Credit: Crowley SnD
local debug_mode = GetVariable("debug_mode") or "off" -- ***
NOTE_COLORS = {
    INFO = "#FF5000",
    INFO_HIGHLIGHT = "#00B4E0",
    IMPORTANT = "#FFFFFF",
    IMPORTANT_HIGHLIGHT = "#00FF00",
    IMPORTANT_BACKGROUND = "#000080",
    ERROR = "#FFFFFF",
    ERROR_HIGHLIGHT = "#FFE32E",
    ERROR_BACKGROUND = "#650101",
    DEBUG = "#87CEFA",
    DEBUG_HIGHLIGHT = "#FFD700"
}


function debug_toggle()
  if debug_mode == "on" then
    DebugNote("Debug mode is now off.")
    debug_mode = "off"
  else
    debug_mode = "on"
    DebugNote("Debug mode is now on.")
  end
  SetVariable("debug_mode", debug_mode)
end


-- Credit: Crowley SnD
function DebugNote(...)
    if debug_mode == "on" then
        ColourTell(NOTE_COLORS.DEBUG_HIGHLIGHT, "", "DEBUG: ")
        print_alternating_note({...}, NOTE_COLORS.DEBUG, NOTE_COLORS.DEBUG_HIGHLIGHT)
    end
end

-- Credit: Crowley SnD
function print_alternating_note(messages, regular_color, highlight_color, background)
    local current_color, other_color = regular_color, highlight_color
    background = background or ""

    for i, message in ipairs(messages) do
        ColourTell(current_color, background, message)
        current_color, other_color = other_color, current_color
    end
    print("")
end


function merge(xs, ys)
  for i, y in ipairs(ys) do
    table.insert(xs, y)
  end
  return xs
end

evil = "@r"
neutral = "@w"
good = "@y"

aligns = {}
aligns["a Harbinger of Doom"] = evil
aligns["a Lord of Ruin"] = evil
aligns["an Avatar of Darkness"] = evil
aligns["an Emissary of Evil"] = evil
aligns["diabolical"] = evil
aligns["nefarious"] = evil
aligns["wicked"] = evil

aligns["grey"] = neutral
aligns["kind"] = neutral
aligns["neutral"] = neutral

aligns["a Harbinger of Hope"] = good
aligns["an Avatar of Light"] = good
aligns["a Lord of Angels"] = good
aligns["an Emissary of Good"] = good
aligns["angelic"] = good
aligns["saintly"] = good
aligns["seraphic"] = good

function align_colour(align)
  return aligns[align]
end


function exists(x)
  return x and x ~= ""
end


function fix_sql(sql)
  if exists(sql) then
    return Replace(sql, "'", "''", true)
  end
  return nil
end


function read(area, name, is_keyword)
  local area = fix_sql(area)
  local name = fix_sql(name)
  area = area or get_area()

  if exists(name) then
    if is_keyword then -- Partial name (seekdb alias or SnD qw)
      return read_by_keyword(area, name) 
    else -- Exact name (SnD target)
      return read_by_area_name(area, name) 
    end
  else
    return read_by_area(area)
  end
end


function read_by_area(area)
  return assert(db:prepare("SELECT * FROM mob WHERE area = '" .. area  .. "'"))
end


function read_by_keyword(area, name)
  local keywords = utils.split(name, " ")
  local query = "SELECT * FROM mob WHERE area = '" .. area .. "'"
  for i, word in ipairs(keywords) do
    query = query .. " AND name LIKE '%" .. word .. "%'"
  end
  return assert(db:prepare(query))
end


function read_by_area_name(area, name)
  local query = "SELECT * FROM mob WHERE area = '%s' AND name = '%s'"
  query = string.format(query, area, name)
  return assert(db:prepare(query))
end

-- not used (yet)
function read_all()
  local query = "SELECT * FROM mob"
  return assert(db:prepare(query))
end


function read_resists(resists_id)
  return assert(db:prepare("SELECT * FROM resists WHERE id = '" .. resists_id .. "'"))
end


function read_immunities(immunities_id)
  return assert(db:prepare("SELECT * FROM immunities WHERE id = '" .. immunities_id .. "'"))
end


function get_area()
  return gmcp("room.info.zone")
end


function trim_align()
  targetArray.align = string.match(targetArray.align, " is (.*).")
end


function fix_bool(val)
  if val == false then
    return 0
  end
  return 1
end
--[[ End helpers ]]--


--[[ Create resists entry ]]--
function create_resists()
  DebugNote("Creating resists entry:")
  local resists_query = "INSERT INTO resists VALUES (NULL"
  for _, resist in ipairs(targetArray.resists) do
    resists_query = resists_query .. "," .. tostring(resist.resval)
  end
  resists_query = resists_query .. ");"

  assert(db:exec(resists_query))
  return db:last_insert_rowid()
end -- create_resists --


--[[ Create immunities entry ]]--
function create_immunities()
  DebugNote("Creating immunities entry:")
  local immunities_query = "INSERT INTO immunities VALUES (NULL"
  for _, immunity in ipairs(targetArray.immunities) do
    immunities_query = immunities_query .. "," .. tostring(immunity.immuVal)
  end
  immunities_query = immunities_query .. ");"

  assert(db:exec(immunities_query))
  return db:last_insert_rowid()
end -- create_immunities --


--[[ Create mob entry ]]--
function create_mob(resists_id, immunities_id)
  DebugNote("Creating mob_query:")
  local mob_query = string.format(
    "INSERT INTO mob VALUES (NULL, '%s', '%s', %i, '%s', %i, %i);",
    fix_sql(targetArray.shortn),
    get_area(),
    targetArray.baselev,
    targetArray.align,
    resists_id,
    immunities_id)
  
  DebugNote(mob_query)
  assert(db:exec(mob_query))
end -- create_mob --


--[[ Compare seek and db resists ]]--
function compare_resists(resists_id)
  DebugNote("Comparing seek and DB resistances:")
  local THRESHOLD = 5
  local resists = read_resists(resists_id)
  resists:step()
  for i, resist in ipairs(targetArray.resists) do
    local db_val = resists:get_value(i)
    DebugNote("targetArray: " .. resist.resval .. " || db: " .. db_val)
    -- +/- threshold to account for slight differences (from buffs/level?)
    if resist.resval > db_val + THRESHOLD or resist.resval < db_val - THRESHOLD then
      DebugNote("Resistances not equal")
      return false
    end
  end
  DebugNote("Resistances equal")
  return true
end -- check_resists --


--[[ Compare seek and db immunities ]]--
function compare_immunities(immunities_id)
  DebugNote("Comparing seek and DB immunities:")
  local immunities = read_immunities(immunities_id)
  immunities:step()
  for i, immunity in ipairs(targetArray.immunities) do
    local db_val = immunities:get_value(i)
    DebugNote("targetArray: " .. fix_bool(immunity.immuVal) .. " || db: " .. db_val)
    if fix_bool(immunity.immuVal) ~= db_val then
      DebugNote("Immunities not equal")
      return false
    end
  end
  DebugNote("Immunities equal")
  return true
end -- check_immunities --


--[[ Compare seek and db mobs]]--
function compare_seek_db(name, area, level, align, resists_id, immunities_id)
  DebugNote("Comparing seek and DB attributes:")
  DebugNote("db: " .. name .. " || seek: " .. targetArray.shortn)
  -- DebugNote(name == targetArray.shortn)
  DebugNote("db: " .. area .. " || seek: " .. get_area())
  -- DebugNote(area == get_area())
  DebugNote("db: " .. align .. " || seek: " .. targetArray.align)
  -- DebugNote(align == targetArray.align)
  DebugNote("db: " .. level .. " || seek: " .. targetArray.baselev)
  -- DebugNote(tonumber(level) == tonumber(targetArray.baselev))
  return name == targetArray.shortn and
      area == get_area() and
      align == targetArray.align and
      tonumber(level) == tonumber(targetArray.baselev) and
      compare_resists(resists_id) and
      compare_immunities(immunities_id)
end -- compare_seek_db --


--[[ Create DB entry from SeekRep ]]--
function new_seek()
  DebugNote("New seek:")
  trim_align() -- trim targetArray.align
  local existing = false -- Check for duplicates in the db
  local result = read(nil, targetArray.shortn)
  for row in result:nrows() do
    if compare_seek_db(row.name, row.area, row.level, row.align, row.resistsID, row.immunitiesID) then
      DebugNote("Found in database")
      existing = true
      break
    end
  end

  if not existing then
    DebugNote("Not found in database")
    local resists_id = create_resists()
    local immunities_id = create_immunities()
    create_mob(resists_id, immunities_id)
    window_new_seek() -- Retry window target search
  end
end -- new_seek --


function db_close()
  db:close()
end

seekdb_results = {}

--[[
  - 'seekdb' alias
  - Search for mobs that match name and area or current area
]]--
function read_seekdb(x, y, args)
  DebugNote("Searching DB for seekdb:")
  seekdb_results = {}
  local found = false
  local results = read(args.area, args.name, true)
  for row in results:nrows() do
    found = true
    Note(format_output(row)) -- Output to main window
    table.insert(seekdb_results, row_to_window_mob(row)) -- Load mobs for window
  end

  if found then
    window_draw()
  else
    Note("No results from SeekDB.")
  end
end -- read_target --


--[[
  - Create output string for DB results
  - mobname (alignment coloured?) || weak (green) || immune (bright red) || strong (purple)
  - Weak/strong in descending order
]]--
function format_output(mob)
  DebugNote("Formatting output for seekdb results:")
  local output = align_colour(mob.align) .. "(" .. neutral .. mob.name .. align_colour(mob.align) .. ")"
  local weak = "" 
  local strong = ""
  local immune = ""
  weak, strong, immune = parse_resists(mob.resistsID, mob.immunitiesID)
  if exists(weak) then
    output = output .. "@w|| @G" .. weak
  end
  if exists(strong) then
    output = output .. "@w|| @M" .. strong
  end
  if exists(immune) then
    output = output .. "@w|| @R" .. immune
  end

  return colorsToAnsiNote(output)
end -- format_output --


--[[ Group resists by weak/strong, immunities if all physical/all magical ]]--
function group_resists(resists_db, immunities_db, weak_threshold, strong_threshold)
  local weak = {}
  local strong = {}
  local immune = {}
  local phys_imms = {}
  local mag_imms = {}

  resists_db:step()
  immunities_db:step()

  for i, imm in ipairs(targetArray.immunities) do
    local db_resist = resists_db:get_value(i)
    local db_immunity = immunities_db:get_value(i)

    if db_immunity == 1 then
      if imm.immuType == "magic" then
        table.insert(mag_imms, imm.immuName)
      else
        table.insert(phys_imms, imm.immuName)
      end
    elseif db_resist <= weak_threshold then
      table.insert(weak, {type = imm.immuName, value = db_resist})
    elseif db_resist >= strong_threshold then
      table.insert(strong, {type = imm.immuName, value = db_resist})
    end
  end

  -- Display "Magic" or "Physical" instead of individual immunities if mob is fully immune
  if #phys_imms == 3 then
    table.insert(immune, "All Physical")
  else
    for i, imm in ipairs(phys_imms) do
      table.insert(immune, imm)
    end
  end

  if #mag_imms == 17 then
    table.insert(immune, "All Magic")
  else
    for i, imm in ipairs(mag_imms) do
      table.insert(immune, imm)
    end
  end

  return weak, strong, immune
end -- group_resists --


--[[ Sort weak in ascending order and strong in descending order ]]--
function sort_resists(weak, strong)
  table.sort(weak, function (a, b)
    return a.value < b.value
  end)
  table.sort(strong, function (a, b)
    return a.value > b.value
  end)
  return weak, strong
end


--[[ Concatenate resists/immunities to strings ]]--
function conc_resists(weak, strong, immune)
  function conc(resists)
    local conced = ""

    for i, res in ipairs(resists) do
      conced = conced .. res.type .. " "
    end

    return conced
  end

  weak = conc(weak)
  strong = conc(strong)
  if immune then
    immune = table.concat(immune, " ")
  end

  return weak, strong, immune
end -- conc_resists --

WEAK_THRESHOLD = -10
STRONG_THRESHOLD = 10

--[[
  - Group resists by weak and strong, filter by threshold
  - Sort weak/strong
  - String concatenate
]]--
function parse_resists(resists_id, immunities_id)
  resists_db = read_resists(resists_id)
  immunities_db = read_immunities(immunities_id)
  weak, strong, immune = group_resists(resists_db, immunities_db, WEAK_THRESHOLD, STRONG_THRESHOLD)
  weak, strong = sort_resists(weak, strong)
  return conc_resists(weak, strong, immune)
end -- parse_resists --

------------------------ End Database Code -----------------------

------------------------- Miniwindow Code ------------------------
-- Credit: Fiendish's Stat Monitor plugin, more or less 

require "mw_theme_base"
require "movewindow"

DEFAULT_WIDTH = 200
DEFAULT_HEIGHT = 200
DEFAULT_X = 100
DEFAULT_Y = 700

-- TODO: min_size not used
MIN_SIZE = 100
LEFT_MARGIN = 10
TOP_MARGIN = 5

width = 0
height = 0

font_id = "font_" .. GetPluginID()

win = "win_" .. GetPluginID()
windowinfo = ""

--[[ OnPluginInstall ]]--
function window_install()
  windowinfo =
    movewindow.install(
      win,
      miniwin.pos_bottom_left, -- default_position
      miniwin.create_absolute_location,
      false,
      nil,
      {mouseup=MouseUp, mousedown=LeftClickOnly, dragmove=LeftClickOnly, dragrelease=LeftClickOnly},
      {x=default_x, y=default_y}
    )

  width = tonumber(GetVariable("width")) or DEFAULT_WIDTH
  height = tonumber(GetVariable("height")) or DEFAULT_HEIGHT

  WindowCreate(
    win,
    windowinfo.window_left,
    windowinfo.window_top,
    width,
    height,
    windowinfo.window_mode,
    windowinfo.window_flags,
    Theme.PRIMARY_BODY
  )

  -- Fonts
  local fonts = utils.getfontfamilies()

  if not fonts.Dina then
    AddFont(GetInfo(66) .. "/Dina.fon")
    fonts = utils.getfontfamilites()
  end

  if fonts["Dina"] then
    default_font_size = 8
    default_font_name = "Dina"
  elseif fonts["Courier New"] then
    default_font_size = 9
    default_font_name "Courier New"
  else
    default_font_size = 9
    default_font_name = "Lucida Console"
  end

  font_name = GetVariable("font_name") or default_font_name
  font_size = tonumber(GetVariable("font_size")) or default_font_size
  WindowFont(win, font_id, font_name, font_size, false, false, false, false, 0)

  -- Calculate font size metrics
  line_height = WindowFontInfo(win, font_id, 1) - WindowFontInfo(win, font_id, 4) + 2

  resize_window()
  WindowShow(win, true)
end -- window_install --

json = require 'json'
gmcp_id = "3e7dedbe37e44942dd46d264"
snd_id = "30000000537461726c696e67"

win_text = {}
enemy = ""
snd_target = ""
last_msg = 2

--[[ OnPluginBroadcast ]]--
function window_broadcast(msg, id, name, text)
  local changed = false
  local mob = ""
  local name = ""
  local area = ""

  if id == gmcp_id and gmcp("char.status.pos") == "Fighting" then
    name = gmcp("char.status.enemy")
    area = get_area()
    enemy = window_search_db(area, name)
    enemy.name = "Enemy: " .. name
    changed = true
  else
    enemy = ""
    changed = true
  end

  -- SnD target?
  if (id == snd_id) then
    if (msg == 1) then -- New target
      window_target() -- Get the target from SnD
      changed = true
    elseif (msg == 2) then -- Target cleared
      snd_target = ""
      changed = true
    end
  end

  if changed then
    window_draw()
  end
end -- window_broadcast --


--[[ Search DB for window target mob ]]--
function window_target()
  code, target_as_json = CallPlugin(snd_id, "target_as_json") -- Call SnD for the target
  mob = json.decode(target_as_json)
  name = mob.name or mob.keyword
  area = mob.area or get_area()
  snd_target = window_search_db(area, name, exists(mob.keyword))
  if debug_mode == "on" then
    tprint(snd_target)
  end
  snd_target.name = "Target: " .. name
end


--[[ Parse database row into window mob ]]--
function row_to_window_mob(row)
  local weak = {}
  local strong = {}
  local immunities = {}
  weak, strong, immune = parse_resists(row.resistsID, row.immunitiesID)
  window_mob = {
    name = row.name,
    weak = weak,
    strong = strong,
    immune = immune,
    found = true
  }
  return window_mob
end


--[[ Search DB for window mobs ]]--
function window_search_db(area, name, is_keyword)
  local results = read(area, name, is_keyword)
  local window_mob = {name = name, weak = "", strong = "", immune = "", found = false}

  for row in results:nrows() do
    window_mob = row_to_window_mob(row)
  end
  return window_mob
end -- window_search_db --


--[[ New mob in database, retry window target search ]]--
function window_new_seek()
  if exists(snd_target) then
    window_target()
    window_draw()
  end
end -- window_new_seek --


--[[ Draw the border and text ]]--
function window_draw()
  -- Border
  bodyleft, bodytop, bodyright, bodybottom = Theme.DrawBorder(win)
  WindowRectOp(win, 2, bodyleft, bodytop, bodyright+1, bodybottom+1, Theme.PRIMARY_BODY) -- blank

  local left = LEFT_MARGIN
  local top = 0
  local line = 1

  if (exists(enemy)) then -- Currently fighting
    table.insert(win_text, enemy)
  else
    table.insert(win_text, {name = "Enemy: <no enemy>", found = true})
  end

  if (exists(snd_target)) then -- Search and Destroy target
    table.insert(win_text, snd_target)
  else
    table.insert(win_text, {name = "Target: <no target>", found = true})
  end

  win_text = merge(win_text, seekdb_results)

  function draw_text(text, colour)
    top = TOP_MARGIN + (line - 1) * line_height
    WindowText(win, font_id, text, left, top, bodyright, bodybottom, ColourNameToRGB(colour), false)
    line = line + 1
  end

  -- Draw the text lines
  for i, mob in ipairs(win_text) do
    if exists(mob.name) then
      draw_text(mob.name, "white")
    end
 
    if not mob.found then
      draw_text("<not found in SeekDB>", "white")
    else
      if exists(mob.weak) then
        draw_text(mob.weak, "green")
      end

      if exists(mob.strong) then
        draw_text(mob.strong, "orange")
      end

      if exists(mob.immune) then
        draw_text(mob.immune, "red")
      end
    end

    line = line + 1 -- Line break between mobs
  end

  win_text = {}

  Theme.AddResizeTag(win, 1, nil, nil, "MouseDown", "ResizeMoveCallback", "ResizeReleaseCallback")

  CallPlugin("abc1a0944ae4af7586ce88dc", "BufferedRepaint") -- Resizes window immediately
end -- draw --

startx = ""
starty = ""
last_refresh = 0

function ResizeMoveCallback()
  if (startx == "") or (starty == "") then
    startx = WindowInfo(win, 17)
    starty = WindowInfo(win, 18)
  end

  local posx = WindowInfo(win, 17)
  local posy = WindowInfo(win, 18)

  width = width + posx - startx
  startx = posx

  height = height + posy - starty
  starty = posy

  if (utils.timer() - last_refresh > 0.033) then
    resize_window()
    last_refresh = utils.timer()
  end
end -- ResizeMoveCallback --


function ResizeReleaseCallback()
  resize_window()
end -- ResizeReleaseCallback --


function MouseDown(flags, hotspot_id)
  if (hotspot_id == win.. "_resize") then
    startx = WindowInfo(win, 17)
    starty = WindowInfo(win, 18)
  end
end -- MouseDown --


function MouseUp(flags, hotspot_id, win)
  return true
end -- MouseUp --


function LeftClickOnly(flags, hotspit_id, win)
  if bit.band(flags, miniwin.hotspot_got_rh_mouse) ~= 0 then
    return true
  end
  return false
end -- LeftClickOnly --


function resize_window()
  WindowResize(win, width, height, Theme.PRIMARY_BODY)
  movewindow.add_drag_handler(win, 0, 0, 0, 0)
  window_draw()
end -- resize_window --


--[[ OnPluginSaveState ]]--
function window_save()
  movewindow.save_state(win)
  SetVariable("width", width)
  SetVariable("height", height)
end -- window_save --


--[[ OnPluginClose ]]--
function window_close()
   WindowDelete(win)
end


--[[ OnPluginDisable ]]--
function window_disable()
  WindowShow(win, false)
end


--[[ OnPluginEnable ]]--
function window_enable()
  WindowShow(win, true)
end

----------------------- End Miniwindow Code ----------------------

----------------------- Plugin Handler Code ----------------------
require 'gmcphelper'

function OnPluginInstall()
  OnHelp()
  initVars()
  initTarget()
  window_install()
end

function OnPluginSaveState()
  window_save()
end

function OnPluginBroadcast(msg, id, name, text)
  window_broadcast(msg, id, name, text)
end

function OnPluginClose()
  db_close()
  window_close()
  OnPluginDisable()
end

function OnPluginDisable()
  window_disable()
end

function OnPluginEnable()
  window_enable()
end

-------------------- End Plugin Handler Code ---------------------


----------------------- Plugin Update Code -----------------------
-- Code taken from Durel's dinv plugin, originally via Crowley
require("wait")
require("async")
json = require("json")

plugin_url = "https://raw.githubusercontent.com/Anssett/Aard-Plugins/main/SeekRep/SeekRep.xml"
SetVariable("DownloadURL", plugin_url)
plugin_protocol = "HTTPS"
plugin_prefix = "[SeekRep]"
 
function update_check_alias()
  update_plugin("check")
  ColourNote("white", "", plugin_prefix .. " Checking for updated version...")
end
 
function update_install_alias()
    update_plugin("install")
    ColourNote("white", "", plugin_prefix .. " Checking for and installing updated version...")
end
 
function reload_plugin()
    local scriptPrefix = GetAlphaOption("script_prefix")
    local retval
 
    -- If the user has not already specified the script prefix for this version of mush, pick a
    -- reasonable default value
    if (scriptPrefix == "") then
        scriptPrefix = "\\\\\\"
        SetAlphaOption("script_prefix", scriptPrefix)
    end
 
    -- Tell mush to reload the plugin in one second.  We can't do it directly here because a
    -- plugin can't unload itself.  Even if it could, how could it tell mush to load it again
    -- if it weren't installed? 
    retval = Execute(scriptPrefix.."DoAfterSpecial(0.1, \"ReloadPlugin('"..GetPluginID().."')\", sendto.script)")
end
 
function update_plugin(mode)
    update_mode = mode
 
    wait.make(get_plugin_file)
end
 
function get_plugin_file()
  local urlThread = async.request(plugin_url, plugin_protocol)
 
  if not urlThread then
    note_error("Couldn't create async url request.")
    return
  end
 
  local timeout = 10
  local totTime = 0
  while (urlThread:alive() and totTime < timeout) do
    wait.time(0.1)
    totTime = totTime + 0.1
  end
 
  local remoteRet, pluginData, status, headers, fullStatus = urlThread:join()
 
  if not status then
    ColourNote("red", "", plugin_prefix .. " Couldn't download plugin file. No status code.")       
    return
  end
 
  if (status ~= 200) then
    ColourNote("red", "", plugin_prefix .. " Plugin file request status code: " .. status .. ": " .. fullStatus)
    return
  end
     
    local currentVersion = GetPluginInfo(GetPluginID(), 19) or 0
    local currentVerStr  = string.format("%1.3f", currentVersion)
    local remoteVerStr   = string.match(pluginData, '%s%s+version="([0-9%.]+)"')
    local remoteVersion  = tonumber(remoteVerStr or "") or 0
 
    if remoteVersion == currentVersion then
        ColourNote("white", "", plugin_prefix .. " You are running the most recent version (v" .. currentVerStr .. ")")
    elseif (remoteVersion < currentVersion) then
        ColourNote("white", "", plugin_prefix .. " You have a newer version than is publicly available. (v" .. currentVerStr .. ")")
    elseif (update_mode == "check") then
        ColourNote("white", "", plugin_prefix .. " You are running v" .. currentVerStr .. ", but there's a newer version v" .. remoteVerStr)
    elseif (update_mode == "install") then
        ColourNote("white", "", plugin_prefix .. " Updating plugin from version " .. currentVerStr .. " to version " .. remoteVerStr) 
 
        local pluginFile = GetPluginInfo(GetPluginID(), 6)
        local file = io.open(pluginFile, "wb")
        file:write(pluginData)
        file:close()
        reload_plugin()
    else
        ColourNote("red", "", plugin_prefix .. " Invalid update mode: " .. update_mode)
    end
end
------------------------ End Plugin Update Code -----------------------