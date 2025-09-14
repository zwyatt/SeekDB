--   version="1.7"
require 'wrapped_captures'
require 'aardwolf_colors'
require 'tprint'

-------------------------- DebugNote -----------------------------
-- Credit: Crowley SnD
local debug_mode = GetVariable("debug_mode") or "off"
NOTE_COLORS = {
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

function DebugNote(...)
    if debug_mode == "on" then
        ColourTell(NOTE_COLORS.DEBUG_HIGHLIGHT, "", "DEBUG: ")
        print_alternating_note({...}, NOTE_COLORS.DEBUG, NOTE_COLORS.DEBUG_HIGHLIGHT)
    end
end

function print_alternating_note(messages, regular_color, highlight_color, background)
    local current_color, other_color = regular_color, highlight_color
    background = background or ""

    for i, message in ipairs(messages) do
        ColourTell(current_color, background, message)
        current_color, other_color = other_color, current_color
    end
    print("")
end

function test_print(xs)
  local test = ""
  for i, v in ipairs(xs) do
    if v == true then
      test = test .. "true, "
    else
      test = test .. v.name .. " " .. v.value .. ", "
    end
  end
  print(test)
end
-------------------------- End DebugNote -------------------------

function seek_trigger_capture(name, line, args)
  table.insert(trigger_lines, line)
end

function seek_trigger_end()
  processCapture(trigger_lines)
  trigger_lines = {}
end

-- [[ Set seek trigger 'omit_from_output' on or off ]] -- 
function set_omit(value)
  SetTriggerOption("seek_start", "omit_from_output", value)
  SetTriggerOption("seek_capture", "omit_from_output", value)
  SetTriggerOption("seek_end", "omit_from_output", value)
end

function seek_init()
  seek_now = false
  seekrep_enabled = tostring(GetVariable("seekrep_enabled")) or true
  seekrep_enabled = seekrep_enabled == "true"
  if not seekrep_enabled then set_omit("n") end
  trigger_lines = {}
end

seek_init()

function seekrep_toggle()
  seekrep_enabled = not seekrep_enabled
  SetVariable("seekrep_enabled", tostring(seekrep_enabled))
  if seekrep_enabled then
    set_omit("y")
    Note("Seekrep reporting enabled.")
  else
    set_omit("n")
    Note("Seekrep reporting disabled.")
  end
end

function seek_enemy()
  DebugNote("Seeking")
  local name = ""
  if exists(enemy) and gmcp("char.status.pos") == "Fighting" then
    name = Replace(enemy.name, "Enemy: ", "")
  elseif exists(snd_target) then
    name = Replace(snd_target.name, "Target: ", "")
  end
  name = string.lower(name)
  if name ~= "" then
    name = Replace(name, ",", "")
    name = Replace(name, " a ", " ")
    name = Replace(name, " an ", " ")
    name = Replace(name, " of the ", " ")
    name = Replace(name, " the ", " ")
    name = Replace(name, " of ", " ")
    name = Replace(name, " from ", " ")
    name = Replace(name, " and ", " ")
    name = Replace(name, "'s ", " ")
    name = Replace(name, "?", "")
    name = Replace(name, "!", "")
    name = string.gsub(name, "^a ", "")
    name = string.gsub(name, "^an ", "")
    name = string.gsub(name, "^the ", "")
    name = string.gsub(name, "-%a* ", " ")
    name = string.gsub(name, "-%a*$", "")
    Send("seek '" .. name .. "'")
  end
end

function initTarget()
  local targetArray = {
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
  return targetArray
end

function trim(s)
  return(string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

function OnHelp ()
  local borderColor = "@x025"
  local textColor = "@x178"
  local cmdColor = "@W"
  
  colorsToAnsiNote(borderColor .. "------------------" .. textColor .. " SeekDB Help " .. borderColor .. "------------------")
  colorsToAnsiNote(borderColor .. "--==  " .. textColor .. "Initial Setup" .. borderColor .. "  ==--")
  colorsToAnsiNote(textColor .. "After the first installation, run " .. cmdColor .. "seekrep config help")
  Note()
  colorsToAnsiNote(borderColor .. "--==" .. textColor .. "  General Use  " .. borderColor .. "==--")
  colorsToAnsiNote(borderColor .. "-=  " .. textColor .. "Seek or SeekRep to add a target to the database  " .. borderColor .. "=-")
  colorsToAnsiNote(cmdColor .. "seek [target]")
  colorsToAnsiNote(cmdColor .. "   [target]" .. textColor .. "    Optional. Defaults to current enemy or SnD target.")

  Note()
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
  colorsToAnsiNote(borderColor .. "-=" .. textColor .. "  Switch SeekRep on and off for normal seek  " .. borderColor .. "=-")
  colorsToAnsiNote(cmdColor .. "seekrep toggle")
  Note()
  colorsToAnsiNote(borderColor .. "-=" .. textColor .. "  Search for a mob in the database  " .. borderColor .. "=-")
  colorsToAnsiNote(cmdColor .. "seekdb find [target] [area]")
  colorsToAnsiNote(cmdColor .. "   [target]" .. textColor .. "   Optional. Single keyword of target. 'all' to search for all mobs in the area.")
  colorsToAnsiNote(cmdColor .. "   [area]" .. textColor .. "     Optional. Defaults to current area. 'all' to search in every area. Must match")
  colorsToAnsiNote(textColor .. "              area keyword exactly.")
  Note()
  colorsToAnsiNote(borderColor .. "-=" .. textColor .. "  Show number of mobs weak/strong/immune to each damtype in the area  " .. borderColor .. "=-")
  colorsToAnsiNote(cmdColor .. "seekdb summary [full|totals|average]")
  colorsToAnsiNote(cmdColor .. "   [full|totals|average]" .. textColor .. "   Optional. Defaults to full, showing totals and average.")
  Note()
  colorsToAnsiNote(borderColor .. "--==" .. textColor .. "  Examples  " .. borderColor .. "==--")
  colorsToAnsiNote(cmdColor .. "seekrep lasher top 3" .. textColor .. "  Performs " .. cmdColor .. "seek" .. textColor .. " on lasher, then prints his highest 3 resistances.")
  Note()
  colorsToAnsiNote(cmdColor .. "seekrep lasher 5" .. textColor .. "      Performs " .. cmdColor .. "seek" .. textColor .. " on lasher, then prints his lowest 5 resistances.")
  Note()
  colorsToAnsiNote(cmdColor .. "seekdb find imp" .. textColor .. "            Searches DB for all mobs with 'imp' in the name in the current area.")
  Note()
  colorsToAnsiNote(cmdColor .. "seekdb find all aylor" .. textColor .. "      Searches DB for all mobs in the area 'aylor'.")
  Note()
  colorsToAnsiNote(borderColor .. "--==" .. textColor .. "  Right-Click Menu   " .. borderColor .. "==--")
  colorsToAnsiNote(textColor .. "Right-click on the miniwindow to customize the font, colours, whitelists, etc.")
  Note()
  colorsToAnsiNote(borderColor .. "--==" .. textColor .. "  Updating   " .. borderColor .. "==--")
  colorsToAnsiNote(cmdColor .. "seekdb update check" .. textColor .. "   Checks if there's an update to the plugin.")
  colorsToAnsiNote(cmdColor .. "seekdb update install" .. textColor .. " Installs any available updates to this plugin.")
  colorsToAnsiNote(borderColor .. "--------------------------------------------------")
end


function startSeek(name, line, args)
  seek_now = true
  target = args.name
  dir = args.dir or "nil"
  qty = tonumber(args.qty) or -1

  local command = "seek " .. target
  Send(command)
end

function processCapture(lines, db_ready)
  local targetArray = initTarget()

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

  function getVal(searchStr)
    for i,j in pairs(targetArray.resists) do
      if string.lower(j.resName) == string.lower(searchStr) then
          return j.resval
      end
    end
    --  tprint(targetArray.resists)
    return 0
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

  new_table = {}
  local outText = ""

  --remove color data etc
  for k, v in ipairs(lines) do
    stripped = v

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

  new_seek(targetArray)

  if not seekrep_enabled and not seek_now then return end
  seek_now = false

  if dir == "all" then
    redrawSeek(targetArray)
  elseif dir == "verbose" then
    tprint(targetArray)
  elseif dir == "immcheck" then
    outText = showVuln()    
  else
    if qty and qty>0 then
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

function redrawSeek(targetArray)
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

function colorsToAnsiNote(data)
  return AnsiNote(ColoursToANSI(data))
end

function tblLT(a,b)
  return a.resval<b.resval
end

function tblGT(a,b)
  return b.resval<a.resval
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
db_path = GetPluginInfo(GetPluginID(), 20) .. "SeekDB.db"

function open_db()
  return assert(sqlite3.open(db_path))
end -- open_db --

function sql_exec(query, need_id)
  DebugNote(query)
  local db = open_db()
  local result = nil
  assert(db:exec(query))
  if need_id then
   result = db:last_insert_rowid()
  end
  db:close_vm()
  db:close()
  return result
end -- sql_exec --

function sql_prepare(query)
  DebugNote(query)
  local db = open_db()
  local result = assert(db:prepare(query))
  return db, result
end -- sql_prepare --

function create_tables()
  local query = [[
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

  sql_exec(query)
end -- create_tables --

create_tables()

function read(area, name, exact_name)
  local area = fix_sql(area)
  local name = fix_sql(name)
  area = area or get_area()

  if exact_name then
    return read_by_area_name(area, name)
  elseif name == "all" and area == "all" then
    return read_all()
  elseif name == "all" or not exists(name) then
    return read_by_area(area)
  elseif exists(name) and area == "all" then
    return read_by_keyword(name)
  elseif exists(name) then
    return read_by_area_keyword(area, name)
  end
  return read_by_area(area)
end -- read --

function read_by_id(id)
  local query = "SELECT * FROM mob WHERE id = '" .. id .. "'"
  return sql_prepare(query)
end -- read_by_id --

function read_by_area(area)
  local query = "SELECT * FROM mob WHERE area = '" .. area  .. "'"
  return sql_prepare(query)
end -- read_by_area --

function keyword_query(name)
  local keywords = utils.split(name, " ")
  local query = ""

  for i, word in ipairs(keywords) do
    if i == 1 then
      query = query .. " name LIKE '%" .. word .. "%'"
    else
      query = query .. " AND name LIKE '%" .. word .. "%'"
    end
  end
  return query
end -- keyword_query --

function read_by_keyword(name)
  local query = "SELECT * FROM mob WHERE" .. keyword_query(name)
  return sql_prepare(query)
end -- read_by_keyword --

function read_by_area_keyword(area, name)
  local query = "SELECT * FROM mob WHERE" .. keyword_query(name) .. " AND area = '" .. area .. "'"
  return sql_prepare(query)
end -- read_by_area_keyword --

function read_by_area_name(area, name)
  local query = "SELECT * FROM mob WHERE area = '%s' AND name = '%s'"
  query = string.format(query, area, name)
  return sql_prepare(query)
end -- read_by_area_name --

function read_all()
  local query = "SELECT * FROM mob"
  return sql_prepare(query)
end -- read_all --

function read_resists(resists_id)
  local query ="SELECT * FROM resists WHERE id = '" .. resists_id .. "'"
  return sql_prepare(query)
end -- read_resists --

function read_immunities(immunities_id)
  local query = "SELECT * FROM immunities WHERE id = '" .. immunities_id .. "'"
  return sql_prepare(query)
end -- read_immunities --

function delete_entry(row)
  if exists(row) then
    DebugNote("Deleting entry:")
    delete_mob(row.id)
    delete_resists(row.resistsID)
    delete_immunities(row.immunitiesID)
  else
    DebugNote("Failure to delete entry, no row")
  end
end -- delete_entry --

function delete_mob(mob_id)
  if exists(mob_id) then
    DebugNote("Deleting mob: <" .. mob_id .. ">")
    local query = "DELETE FROM mob WHERE id = '" .. mob_id .. "'"
    sql_exec(query)
  else
    DebugNote("Failure to delete_mob, no mob_id")
  end
end -- delete_mob --

function delete_resists(resists_id)
  if exists(resists_id) then
    DebugNote("Deleting resists: <" .. resists_id .. ">")
    local query = "DELETE FROM resists WHERE id = '" .. resists_id .. "'"
    sql_exec(query)
  else
    DebugNote("Failure to delete_resists, no resists_id")
  end
end -- delete_resists --

function delete_immunities(immunities_id)
  if exists(immunities_id) then
    DebugNote("Deleting immunities: <" .. immunities_id .. ">") 
    local query = "DELETE FROM immunities WHERE id = '" .. immunities_id .. "'"
    sql_exec(query)
  else
    DebugNote("Failure to delete_immunities, no immunities_id")
  end
end -- delete_immunities --

--[[ alias: seekdb delete <id> ]]--
function delete_check(x, y, args)
  if debug_mode == "on" then
    local id = args.id
    DebugNote("Delete check: <" .. id .. ">")
    db, results = read_by_id(id)
    local found = false
    for row in results:nrows() do
      found = true
      DebugNote("Are you sure you want to delete <" .. row.id .. "> " .. row.name .. "?")
      DebugNote("Confirm delete with 'seekdb delete " .. row.id .. " confirm'")
    end
    results:finalize()
    db:close()

    if not found then
      DebugNote("<" .. id .. "> not found in DB.")
    end
  else
    colorsToAnsiNote(textColor .. "Enable debug mode using 'seekdb debug' to delete entries.")
  end
end -- delete_check -- 

--[[ alias: seekdb delete <id> confirm ]]--
function delete_confirm(x, y, args)
  if debug_mode == "on" then
    local id = args.id
    DebugNote("Delete confirm: <" .. id .. ">")
    local db, results = read_by_id(id)
    local found = false
    for row in results:nrows() do
      found = true
      delete_entry(row)
    end
    results:finalize()
    db:close()

    if not found then
      DebugNote("<" .. id .. "> not found in DB.")
    end
  end
end -- delete_confirm --


--[[ Helpers ]]--
function exists(x)
  return x and x ~= ""
end -- exists --

function is_empty(xs)
  if exists(xs) then
    return next(xs) == nil
  else
    return true
  end
end -- is_empty --

function fix_sql(sql)
  if exists(sql) then
    return Replace(sql, "'", "''", true)
  end
  return nil
end -- fix_sql --

function get_area()
  return gmcp("room.info.zone")
end -- get_area --

-- [[ DB stores immunity value as 0 or 1, use to convert targetArray value to compare ]]
function fix_bool(val)
  if val then
    return 1
  end
  return 0
end

function table.shallow_copy(xs)
  local ys = {}
  for k, v in pairs(xs) do
    ys[k] = v
  end
  return ys
end -- shallow_copy --

function table.merge(xs, ys)
  for i, y in ipairs(ys) do
    table.insert(xs, y)
  end
  return xs
end -- merge --

function sort_ascending(a, b)
  if a.name == "All Physical" then
    return true
  elseif a.name == "All Magic" then
    return true
  elseif b.name == "All Physical" or b.name == "All Magic" then
    return false
  end
  return a.value < b.value
end -- sort_ascending --

function sort_descending(a, b)
  if a.name == "All Physical" then
    return true
  elseif a.name == "All Magic" then
    return true
  elseif b.name == "All Physical" or b.name == "All Magic" then
    return false
  end
  return a.value > b.value
end

evil = "@r"
neutral_mob = "@w"
good = "@y"

aligns = {
  ["a Lord of Ruin"] = evil,
  ["an Avatar of Darkness"] = evil,
  ["a Harbinger of Doom"] = evil,
  ["an Emissary of Evil"] = evil,
  ["nefarious"] = evil,
  ["wicked"] = evil,
  ["diabolical"] = evil,
  ["heartless"] = evil,
  ["heinous"] = evil,
  ["foul"] = evil,
  ["cruel"] = evil,
  ["corrupt"] = evil,
  ["mean"] = evil,
  ["unpleasant"] = evil,

  ["grey"] = neutral_mob,
  ["neutral"] = neutral_mob,

  ["kind"] = good,
  ["pure"] = good,
  ["good"] = good,
  ["righteous"] = good,
  ["virtuous"] = good,
  ["reverent"] = good,
  ["beneficent"] = good,
  ["angelic"] = good,
  ["saintly"] = good,
  ["seraphic"] = good,
  ["an Emissary of Good"] = good,
  ["a Harbinger of Hope"] = good,
  ["an Avatar of Light"] = good,
  ["a Lord of Angels"] = good
}

function align_colour(align)
  DebugNote("Getting align_colour")
  return aligns[align]
end -- align_colour --

--[[ End helpers ]]--

function create_resists(resists)
  DebugNote("Creating resists entry")
  local query = "INSERT INTO resists VALUES (NULL"
  for _, resist in ipairs(resists) do
    query = query .. "," .. tostring(resist.resval)
  end
  query = query .. ");"

  return sql_exec(query, true)
end -- create_resists --

function create_immunities(immunities)
  DebugNote("Creating immunities entry")
  local query = "INSERT INTO immunities VALUES (NULL"
  for _, immunity in ipairs(immunities) do
    query = query .. "," .. tostring(immunity.immuVal)
  end
  query = query .. ");"

  return sql_exec(query, true)
end -- create_immunities --

function create_mob(targetArray, resists_id, immunities_id)
  DebugNote("Creating mob entry")
  local query = string.format(
    "INSERT INTO mob VALUES (NULL, '%s', '%s', %i, '%s', %i, %i);",
    fix_sql(targetArray.shortn),
    get_area(),
    targetArray.baselev,
    targetArray.align,
    resists_id,
    immunities_id)
  sql_exec(query)
end -- create_mob --

VARIANCE = 5

--[[ Compare seek and db resists ]]--
function compare_resists(t_resists, resists_id)
  DebugNote("Comparing seek and DB resistances")
  local db, db_resists = read_resists(resists_id)
  local are_equal = true

  db_resists:step()

  for i, resist in ipairs(t_resists) do
    local db_val = db_resists:get_value(i)
    DebugNote("targetArray: " .. resist.resval .. " || db: " .. db_val)

    -- +/- variance to account for slight differences (from buffs/level?)
    if resist.resval > db_val + VARIANCE or resist.resval < db_val - VARIANCE then
      DebugNote("Resistances not equal")
      are_equal = false
      break
    end
  end
  db_resists:finalize()
  db:close()
  if are_equal then DebugNote("Resistances equal") end
  return are_equal
end -- check_resists --

--[[ Compare seek and db immunities ]]--
function compare_immunities(t_immunities, immunities_id)
  DebugNote("Comparing seek and DB immunities")
  local db, db_immunities = read_immunities(immunities_id)
  local are_equal = true
  db_immunities:step()

  for i, immunity in ipairs(t_immunities) do
    local db_val = db_immunities:get_value(i)
    DebugNote("targetArray: " .. fix_bool(immunity.immuVal) .. " || db: " .. db_val)

    if fix_bool(immunity.immuVal) ~= db_val then
      DebugNote("Immunities not equal")
      are_equal = false
    end
  end
  if are_equal then DebugNote("Immunities equal") end
  db_immunities:finalize()
  db:close()
  return are_equal
end -- check_immunities --

--[[ Compare seek and db mobs]]--
function compare_seek_db(targetArray, name, area, level, align, resists_id, immunities_id)
  DebugNote("Comparing seek and DB attributes")
  DebugNote("db: " .. name .. " || seek: " .. targetArray.shortn)
  DebugNote("db: " .. area .. " || seek: " .. get_area())
  DebugNote("db: " .. align .. " || seek: " .. targetArray.align)
  DebugNote("db: " .. level .. " || seek: " .. targetArray.baselev)

  return name == targetArray.shortn and
      area == get_area() and
      align == targetArray.align and
      tonumber(level) == tonumber(targetArray.baselev) and
      compare_resists(targetArray.resists, resists_id) and
      compare_immunities(targetArray.immunities, immunities_id)
end -- compare_seek_db --

--[[ Create DB entry from Seek ]]--
function new_seek(targetArray)
  DebugNote("New seek")
  targetArray.align = string.match(targetArray.align, " is (.*).")
  local existing = false -- Check for duplicates in the db
  local db, results = read(get_area(), targetArray.shortn, true) -- (area, name, exact_name)

  for row in results:nrows() do
    DebugNote(row.name)
    DebugNote(row.area)
    DebugNote(row.level)
    DebugNote(row.align)
    DebugNote(row.resistsID)
    DebugNote(row.immunitiesID)
    if compare_seek_db(
        targetArray,
        row.name,
        row.area,
        row.level,
        row.align,
        row.resistsID,
        row.immunitiesID
    ) then
      Note("Seek complete: duplicate DB entry found.")
      existing = true
      break
    end
  end
  results:finalize()
  db:close()

  if not existing then
    Note("Seek complete: creating DB entry.")
    local resists_id = create_resists(targetArray.resists)
    local immunities_id = create_immunities(targetArray.immunities)
    create_mob(targetArray, resists_id, immunities_id)
    window_new_seek() -- Retry window target search
  end  
end -- new_seek --

seekdb_results = {}

--[[
  - 'seekdb' alias
  - Search for mobs that match name and area or current area
]]--
function read_seekdb(x, y, args)
  DebugNote("Searching DB for seekdb")
  seekdb_results = {}
  local found = false
  local db, results = read(args.area, args.name)

  for row in results:nrows() do
    found = true
    if pcall(function() Note(format_output(row)) end) then -- Output to main window
      table.insert(seekdb_results, row_to_window_mob(row)) -- Load mobs for window
    else
      DebugNote("Errors while running format_output.")
    end
  end
  results:finalize()
  db:close()

  if found then
    window_draw()
  else
    Note("No results from SeekDB.")
  end
end -- read_seekdb --

--[[
  - Create output string for DB results
  - mobname (alignment coloured?) || weak (green) || immune (bright red) || strong (purple)
  - Weak/strong in descending order
]]--
function format_output(mob)
  DebugNote("Formatting output for seekdb results")
  local output = ""
  if debug_mode == "on" then
    output = "<" .. mob.id .. "> "
  end

  local colour = align_colour(mob.align)
  output = output .. colour .. "(@w" .. mob.name .. colour .. ") "
  local weak = "" 
  local neutral = ""
  local strong = ""
  local immune = ""
  weak, neutral, strong, immune = conc_resists(parse_resists(mob.resistsID, mob.immunitiesID))

  if exists(weak) then
    output = output .. "@w| @G" .. weak .. " "
  end
  if exists(neutral) then
    output = output .. "@w | " .. neutral .. " "
  end
  if exists(strong) then
    output = output .. "@w| @x208" .. strong .. " "
  end
  if exists(immune) then
    output = output .. "@w| @R" .. immune
  end
  return colorsToAnsiNote(output)
end -- format_output --

--[[ Group resists by weak/neutral/strong/immune, allphys/allmag ]]--
function group_resists(resists_db, immunities_db)
  DebugNote("Grouping resists")
  local targetArray = initTarget() -- base targetArray for immunity mag/phys types
  local weak_phys = {}
  local weak_mag = {}
  local neutral_phys = {}
  local neutral_mag = {}
  local strong_phys = {}
  local strong_mag = {}
  local immune_phys = {}
  local immune_mag = {}

  -- [[ Split into physical/magic types ]] --
  function type_split(type, name, phys, mag, resist)
    if type == "physical" then
      table.insert(phys, {name = name, value = resist})
    else
      table.insert(mag, {name = name, value = resist})
    end
    return phys, mag
  end -- type_split --

  -- [[ Merge physical/magic into one, combine allphys/allmag ]] --
  function type_merge(phys, mag, wl)
    function filter(xs)
      local filtered = {}

      for i, v in ipairs(xs) do
        if wl[v.name] then
          table.insert(filtered, v)
        end
      end
      return filtered
    end -- type_merge --

    local group = {}

    if #phys == 3 then
      table.insert(group, {name = "All Physical"})
    else
      group = table.merge(group, filter(phys))
    end

    if #mag == 17 then
      table.insert(group, {name = "All Magic"})
    else
      group = table.merge(group, filter(mag))
    end
    return group
  end

  resists_db:step()
  immunities_db:step()

  for i, imm in ipairs(targetArray.immunities) do
    local type = imm.immuType
    local name = imm.immuName
    local db_resist = resists_db:get_value(i)
    local db_immunity = immunities_db:get_value(i)

    if db_immunity == 1 then
      immune_phys, immune_mag = type_split(type, name, immune_phys, immune_mag)
    elseif db_resist <= weak_threshold then
      weak_phys, weak_mag = type_split(type, name, weak_phys, weak_mag, db_resist)
    elseif db_resist >= strong_threshold then
      strong_phys, strong_mag = type_split(type, name, strong_phys, strong_mag, db_resist)
    else
      neutral_phys, neutral_mag = type_split(type, name, neutral_phys, neutral_mag, db_resist)
    end
  end

  resists_db:finalize()
  immunities_db:finalize()

  local weak = type_merge(weak_phys, weak_mag, weak_whitelist)
  local strong = type_merge(strong_phys, strong_mag, strong_whitelist)
  local immune = type_merge(immune_phys, immune_mag, immune_whitelist)
  local neutral = {}
  if #immune >= neutral_threshold or #strong >= neutral_threshold then
    neutral = type_merge(neutral_phys, neutral_mag, neutral_whitelist)
  end
  return weak, neutral, strong, immune
end -- group_resists --

--[[ Sort weak in ascending order and strong in descending order ]]--
function sort_resists(weak, neutral, strong)
  DebugNote("Sorting resists")
  table.sort(weak, sort_ascending)
  table.sort(neutral, sort_ascending)
  table.sort(strong, sort_descending)
  return weak, neutral, strong
end -- sort_resists --

short_resists = {
  ["All Physical"] = "*Phys",
  ["All Magic"] = "*Mag",
  ["Air"] = "Air",
  ["Acid"] = "Acd",
  ["Bash"] = "Bsh",
  ["Cold"] = "Cld",
  ["Disease"] = "Disz",
  ["Earth"] = "Erth",
  ["Electric"] = "Elec",
  ["Energy"] = "Nrg",
  ["Fire"] = "Fir",
  ["Holy"] = "Hly",
  ["Light"] = "Lyt",
  ["Magic"] = "Mag",
  ["Mental"] = "Mntl",
  ["Negative"] = "Neg",
  ["Pierce"] = "Prce",
  ["Poison"] = "Psn",
  ["Shadow"] = "Shdw",
  ["Slash"] = "Slsh",
  ["Sonic"] = "Snic",
  ["Water"] = "Wtr"
}

SEPARATOR = ", "

function conc(resists)
  local conced = {}

  for i, res in ipairs(resists) do
    local name = res.name
    if short_resists_enabled then name = short_resists[name] end
    if res.value then
      if res.value > 1 or res.value < 0 then
        if res.avg then
          name = name .. " " .. math.floor(res.value + 0.5) .. "%"
        elseif res.summary then
          name = name .. " " .. res.value
        end
      end
    end
    table.insert(conced, name)
  end
  return table.concat(conced, SEPARATOR)
end -- conc --

--[[ Concatenate resists/immunities to strings ]]--
function conc_resists(weak, neutral, strong, immune)
  DebugNote("Concatenating resists")

  weak = conc(weak)
  neutral = conc(neutral)
  strong = conc(strong)
  immune = conc(immune)
  return weak, neutral, strong, immune
end -- conc_resists --

--[[
  - Group resists by weak and strong, filter by threshold
  - Sort weak/strong
]]--
function parse_resists(resists_id, immunities_id)
  DebugNote("Parsing resists")
  local db1, resists_db = read_resists(resists_id)
  local db2, immunities_db = read_immunities(immunities_id)
  local weak, neutral, strong, immune = group_resists(resists_db, immunities_db)
  db1:close()
  db2:close()
  weak, neutral, strong = sort_resists(weak, neutral, strong)
  return weak, neutral, strong, immune
end -- parse_resists --

------------------------ End Database Code -----------------------

------------------------- Miniwindow Code ------------------------
-- Credit: Fiendish's Stat Monitor plugin, more or less 

require "mw_theme_base"
require "movewindow"

-- [[ Generate whitelist table from GetVariable string ]] --
function parse_whitelist(wl)
  if exists(wl) then
    wl = utils.split(wl, " ")
    local new_wl = table.shallow_copy(BASE_WHITELIST)
    for i, res in ipairs(wl) do
      new_wl[res] = true
    end
    return new_wl
  else
    return table.shallow_copy(DEFAULT_WHITELIST)
  end
end -- parse_whitelist --

function generate_whitelist(bool)
  local targetArray = initTarget() -- base targetArray for resist list
  local wl = {}
  for i, v in ipairs(targetArray.resists) do
    wl[v.resName] = bool
  end
  return wl
end

function window_init()
  DEFAULT_WIDTH = 300
  DEFAULT_HEIGHT = 200
  DEFAULT_X = 50
  DEFAULT_Y = 700

  MIN_SIZE = 50
  LEFT_MARGIN = 10
  TOP_MARGIN = 5

  width = 0
  height = 0

  font_id = "font_" .. GetPluginID()
  font_name = ""
  font_size = ""

  win = "win_" .. GetPluginID()
  windowinfo = ""

  DEFAULT_BASE_COLOUR = ColourNameToRGB("white")
  DEFAULT_WEAK_COLOUR = ColourNameToRGB("green")
  DEFAULT_NEUTRAL_COLOUR = ColourNameToRGB("gray")
  DEFAULT_STRONG_COLOUR = ColourNameToRGB("orange")
  DEFAULT_IMMUNE_COLOUR = ColourNameToRGB("red")

  DEFAULT_WEAK_THRESHOLD = -10
  DEFAULT_NEUTRAL_THRESHOLD = 0
  DEFAULT_STRONG_THRESHOLD = 10

  DEFAULT_WHITELIST = generate_whitelist(true)
  BASE_WHITELIST = generate_whitelist(false)

  base_colour = GetVariable("base_colour") or DEFAULT_BASE_COLOUR
  short_resists_enabled = GetVariable("short_resists_enabled") == "true"

  weak_enabled = GetVariable("weak_enabled") or true
  weak_enabled = tostring(weak_enabled) == "true"
  weak_threshold = tonumber(GetVariable("weak_threshold")) or DEFAULT_WEAK_THRESHOLD
  weak_whitelist = parse_whitelist(GetVariable("weak_whitelist"))
  weak_colour = GetVariable("weak_colour") or DEFAULT_WEAK_COLOUR

  neutral_enabled = GetVariable("neutral_enabled") or true
  neutral_enabled = tostring(neutral_enabled) == "true"
  neutral_threshold = tonumber(GetVariable("neutral_threshold")) or DEFAULT_NEUTRAL_THRESHOLD
  neutral_whitelist = parse_whitelist(GetVariable("neutral_whitelist"))
  neutral_colour = GetVariable("neutral_colour") or DEFAULT_NEUTRAL_COLOUR

  strong_enabled = GetVariable("strong_enabled") or true
  strong_enabled = tostring(strong_enabled) == "true"
  strong_threshold = tonumber(GetVariable("strong_threshold")) or DEFAULT_STRONG_THRESHOLD
  strong_whitelist = parse_whitelist(GetVariable("strong_whitelist"))
  strong_colour = GetVariable("strong_colour") or DEFAULT_STRONG_COLOUR

  immune_enabled = GetVariable("immune_enabled") or true
  immune_enabled = tostring(immune_enabled) == "true"
  immune_whitelist = parse_whitelist(GetVariable("immune_whitelist"))
  immune_colour = GetVariable("immune_colour") or DEFAULT_IMMUNE_COLOUR
end

window_init()

function window_send_front()
  CallPlugin("462b665ecb569efbf261422f","boostMe", win)
end

function window_send_back()
  CallPlugin("462b665ecb569efbf261422f","dropMe", win)
end

--[[ OnPluginInstall ]]--
function window_install()
  DebugNote("Setting window width and height from variable")
  width = tonumber(GetVariable("width"))
  if not exists(width) or width == 0 then
    width = DEFAULT_WIDTH
  end
  height = tonumber(GetVariable("height"))
  if not exists(height) or height == 0 then
    height = DEFAULT_HEIGHT
  end

  DebugNote("Installing movewindow")
  windowinfo =
    movewindow.install(
      win,
      miniwin.pos_bottom_left, -- default_position
      miniwin.create_absolute_location,
      false,
      nil,
      {mouseup=MouseUp, mousedown=LeftClickOnly, dragmove=LeftClickOnly, dragrelease=LeftClickOnly},
      {x=DEFAULT_X, y=DEFAULT_Y}
    )

  DebugNote("Creating window")
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

  DebugNote("win: " .. win)
  DebugNote("window_left: " .. windowinfo.window_left)
  DebugNote("window_top: " .. windowinfo.window_top)
  DebugNote("width: " .. width)
  DebugNote("height: " .. height)

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
    default_font_name = "Courier New"
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
  window_send_front()
  WindowShow(win, true)
end -- window_install --

json = require 'json'
gmcp_id = "3e7dedbe37e44942dd46d264"
snd_id = "30000000537461726c696e67"

new_entry = false
last_status = ""
enemy = ""
last_enemy = {name = "", area = ""}
snd_target = ""
last_msg = 2

--[[ OnPluginBroadcast ]]--
function window_broadcast(msg, id, name, text)
  local changed = false
  local mob = ""
  local name = ""
  local area = ""

  if id == gmcp_id then
    if gmcp("char.status.pos") == "Fighting" then
      name = strip_colours(gmcp("char.status.enemy"))
      area = get_area()
      -- only update if it's different enemy or there is a new seek entry
      if name ~= last_enemy.name or area ~= last_enemy.area then 
        DebugNote("New enemy")
        last_enemy = {name = name, area = area}
        window_enemy()
        changed = true
      end
    elseif last_status == "Fighting" then
      DebugNote("Fighting ended")
      enemy = ""
      last_enemy = {name = "", area = ""}
      changed = true
    end
    last_status = gmcp("char.status.pos")
  end

  if (id == snd_id) then
    -- print(msg, id, name, text)
    if (msg == 1) then -- New target
      DebugNote("New target")
      window_target() -- Get the target from SnD
      changed = true
    elseif (msg == 2) then -- Target cleared
      DebugNote("Target cleared")
      snd_target = ""
      changed = true
    end
  end

  if changed then
    window_draw()
  end
end -- window_broadcast --

-- [[ Search DB for window enemy mob ]] --
function window_enemy()
  enemy = window_search_db(last_enemy.area, last_enemy.name, true)
  enemy.name = "Enemy: " .. last_enemy.name
end

--[[ Search DB for window target mob ]]--
function window_target()
  code, target_as_json = CallPlugin(snd_id, "target_as_json") -- Call SnD for the target
  mob = json.decode(target_as_json)
  name = mob.name or mob.keyword
  area = mob.area or get_area()
  snd_target = window_search_db(area, name, exists(mob.name))
  snd_target.name = "Target: " .. name
end -- window_target --

--[[ New mob in database, retry window target and enemy search ]]--
function window_new_seek()
  local changed = false
  if exists(snd_target) then
    window_target()
    changed = true
  end
  if exists(enemy) then
    window_enemy()
    changed = true
  end
  if changed then window_draw() end
end -- window_new_seek --

--[[ Parse database row to window mob ]]--
function row_to_window_mob(row)
  local weak = {}
  local neutral = {}
  local strong = {}
  local immune = {}
  weak, neutral, strong, immune = parse_resists(row.resistsID, row.immunitiesID)
  window_mob = {
    name = row.name,
    weak = weak,
    neutral = neutral,
    strong = strong,
    immune = immune,
    found = true
  }
  return window_mob
end -- row_to_window_mob --

--[[ Search DB for window mobs ]]--
function window_search_db(area, name, exact_name)
  local db, results = read(area, name, exact_name)
  local window_mob = {found = false}

  for row in results:nrows() do
    window_mob = row_to_window_mob(row)
  end
  results:finalize()
  db:close()
  return window_mob
end -- window_search_db --

summary = ""

--[[ Sum the number of mobs weak/strong/immune to each damage type ]]
function area_summary(name, line, args)
  local totals, avg = false
  local cmd = args.cmd or "full"
  if cmd == "full" then
    totals = true
    avg = true
  elseif cmd == "totals" then
    totals = true
  elseif cmd == "average" then
    avg = true
  end

  local db, results = read(get_area())
  local target = initTarget()
  local weak = {}
  local neutral = {}
  local strong = {}
  local immune = {}
  local total = {}
  local mobs = 0

  for i, v in ipairs(target.resists) do -- Initialize all totals to 0
    local name = v.resName
    weak[name] = 0
    neutral[name] = 0
    strong[name] = 0
    immune[name] = 0
    total[name] = 0
  end

  for row in results:nrows() do -- for each mob
    mobs = mobs + 1
    local db1, db_resists = read_resists(row.resistsID)
    local db2, db_immunes = read_immunities(row.immunitiesID)
    db_resists:step()
    db_immunes:step()
    local resists = db_resists:get_named_values()
    local immunes = db_immunes:get_named_values()
    db_resists:finalize()
    db_immunes:finalize()
    db1:close()
    db2:close()

    for i, v in ipairs(target.resists) do -- for each resist/immunity
      local name = v.resName
      local res = resists[string.lower(name)]
      local imm = immunes[string.lower(name)]

      if totals then -- sum
        if res <= weak_threshold then
          weak[name] = weak[name] + 1
        elseif res >= strong_threshold then
          strong[name] = strong[name] + 1
        elseif imm == 1 then
          immune[name] = immune[name] + 1
        else
          neutral[name] = neutral[name] + 1
        end
      end
      total[name] = total[name] + res
    end
  end

  results:finalize()
  db:close()

  function mobify(xs, avg) -- format for conc()
    local mobbed = {}
    for k, v in pairs(xs) do
      if v > 0 or v < 0 then
        table.insert(mobbed, {name = k, value = v, summary = true, avg = avg})
      end
    end
    if #mobbed > 0 then
      if avg then
        table.sort(mobbed, sort_ascending)
      else
        table.sort(mobbed, sort_descending)
      end
    end
    return mobbed
  end

  local average = {}
  if avg then
    for k, v in pairs(total) do
      average[k] = v / mobs
    end
    average = mobify(average, true)
  end

  if totals then
    weak = mobify(weak)
    neutral = mobify(neutral)
    strong = mobify(strong)
    immune = mobify(immune)
  end

  summary = { 
    name = "Area: " .. get_area() .. " || Mobs in database: " .. mobs,
    average = average,
    weak = weak,
    -- neutral = neutral,
    strong = strong,
    immune = immune,
    found = true
  }

  colorsToAnsiNote("@WArea: " .. get_area() .. " || Mobs in database: " .. mobs)
  if not is_empty(average) then
    colorsToAnsiNote("@w" .. conc(average))
  end
  if not is_empty(weak) then
    colorsToAnsiNote("@G" .. conc(weak))
  end
  if not is_empty(strong) then
    colorsToAnsiNote("@x208" .. conc(strong))
  end
  if not is_empty(immune) then
    colorsToAnsiNote("@R" .. conc(immune))
  end
  window_draw()
end -- area_summary --

--[[ Draw the border and text ]]--
function window_draw()
  local left = LEFT_MARGIN
  local top = 0
  local line = 1

  local win_text = {}

  -- Border
  bodyleft, bodytop, bodyright, bodybottom = Theme.DrawBorder(win)
  WindowRectOp(win, 2, bodyleft, bodytop, bodyright+1, bodybottom+1, Theme.PRIMARY_BODY) -- blank

  function draw_text(text, colour)
    top = TOP_MARGIN + (line - 1) * line_height
    WindowText(win, font_id, text, left, top, bodyright, bodybottom, colour, false)
    line = line + 1
  end -- draw_text --

  function prepare_text(resists, enabled, colour)
    function wrap(head)
      local head = table.shallow_copy(head)
      local tail = {}
      local txt = conc(head)
      local txtlen = WindowTextWidth(win, font_id, txt)

      while txtlen + left >= width do
        local pop = table.remove(head, #head)
        table.insert(tail, 1, pop)
        txt = conc(head) .. ","
        txtlen = WindowTextWidth(win, font_id, txt)
      end
      draw_text(txt, colour)
      return tail
    end

    if enabled then
      while not is_empty(resists) do
        resists = wrap(resists)
      end
    end
  end -- prepare_text --

  if exists(enemy) then -- Currently fighting
    table.insert(win_text, enemy)
  else
    table.insert(win_text, {name = "Enemy: <no enemy>", found = true})
  end

  if exists(snd_target) then -- Search and Destroy target
    table.insert(win_text, snd_target)
  else
    table.insert(win_text, {name = "Target: <no target>", found = true})
  end

  if exists(summary) then -- Area summary
    table.insert(win_text, summary)
  end

  win_text = table.merge(win_text, seekdb_results)

  -- Draw the text lines
  for i, mob in ipairs(win_text) do
    if exists(mob.name) then
      draw_text(mob.name, base_colour)
    end
 
    if not mob.found then
      draw_text("<not found in SeekDB>", base_colour)
    else
      prepare_text(mob.average, true, base_colour)
      prepare_text(mob.weak, weak_enabled, weak_colour)
      prepare_text(mob.neutral, neutral_enabled, neutral_colour)
      prepare_text(mob.strong, strong_enabled, strong_colour)
      prepare_text(mob.immune, immune_enabled, immune_colour)
    end

    line = line + 1 -- Line break between mobs
  end

  win_text = {}

  Theme.AddResizeTag(win, 1, nil, nil, "MouseDown", "ResizeMoveCallback", "ResizeReleaseCallback")

  CallPlugin("abc1a0944ae4af7586ce88dc", "BufferedRepaint") -- Resizes window immediately
end -- draw --

-- [[ Generate a string from a whitelist for storing in SetVariable ]] --
function whitelist_tostring(wl)
  local wl_str = ""
  for res, is_wl in pairs(wl) do
    if is_wl then wl_str = wl_str .. res .. " " end
  end
  return string.sub(wl_str, 1, -2)
end -- whitelist_tostring --

function right_click_menu()
  -- [[ Generate part of the menustring from a whitelist ]] --
  function whitelist_tomenu(wl, name)
    local menu_wl = ""
    for res, is_wl in pairs(wl) do
      menu_wl = menu_wl .. (is_wl and "+" or "") .. name .. res .. "|"
    end
    return menu_wl
  end -- whitelist_tomenu --

-- [[ Generate menustring ]] --
  local menustring = ""
  menustring = "Font|"
  menustring = menustring .. "Base Colour|"
  menustring = menustring .. (short_resists_enabled and "+" or "") .. "Short Resists|-|"

  menustring = menustring .. ">Weak|"
  menustring = menustring .. (weak_enabled and "+" or "") .. "Weak - Enabled|"
  menustring = menustring .. ">Weak - Threshold|"
  menustring = menustring .. (weak_threshold == -20 and "+" or "") .."Weak - -20%|"
  menustring = menustring .. (weak_threshold == -15 and "+" or "") .."Weak - -15%|"
  menustring = menustring .. (weak_threshold == -10 and "+" or "") .."Weak - -10%|"
  menustring = menustring .. (weak_threshold == -5 and "+" or "") .."Weak - -5%|<|"
  menustring = menustring .. ">Weak - Whitelist|" .. whitelist_tomenu(weak_whitelist, "Weak - ") .. "<|"
  menustring = menustring .. "Weak - Colour|<|-|"

  menustring = menustring .. ">Neutral|"
  menustring = menustring .. (neutral_enabled and "+" or "") .. "Neutral - Enabled|"
  menustring = menustring .. ">Neutral - Threshold|"
  menustring = menustring .. (neutral_threshold == 15 and "+" or "") .."Neutral - 15|"
  menustring = menustring .. (neutral_threshold == 10 and "+" or "") .."Neutral - 10|"
  menustring = menustring .. (neutral_threshold == 5 and "+" or "") .."Neutral - 5|"
  menustring = menustring .. (neutral_threshold == 0 and "+" or "") .."Neutral - 0|<|"
  menustring = menustring .. ">Neutral - Whitelist|" .. whitelist_tomenu(neutral_whitelist, "Neutral - ") .. "<|"
  menustring = menustring .. "Neutral - Colour|<|-|"

  menustring = menustring .. ">Strong|"
  menustring = menustring .. (strong_enabled and "+" or "") .. "Strong - Enabled|"
  menustring = menustring .. ">Strong - Threshold|"
  menustring = menustring .. (strong_threshold == 20 and "+" or "") .."Strong - 20%|"
  menustring = menustring .. (strong_threshold == 15 and "+" or "") .."Strong - 15%|"
  menustring = menustring .. (strong_threshold == 10 and "+" or "") .."Strong - 10%|"
  menustring = menustring .. (strong_threshold == 5 and "+" or "") .."Strong - 5%|<|"
  menustring = menustring .. ">Strong - Whitelist|" .. whitelist_tomenu(strong_whitelist, "Strong - ") .. "<|"
  menustring = menustring .. "Strong - Colour|<|-|"
  
  menustring = menustring .. ">Immune|"
  menustring = menustring .. (immune_enabled and "+" or "") .. "Immune - Enabled|"
  menustring = menustring .. ">Immune - Whitelist|" .. whitelist_tomenu(immune_whitelist, "Immune - ") .. "<|"
  menustring = menustring .. "Immune - Colour|<|-|"

  menustring = menustring .. "Bring to Front|"
  menustring = menustring .. "Send to Back|-|"

  menustring = menustring .. "Reset Defaults"
-- [[ End generate menustring ]] --
  
  result = WindowMenu(
    win,
    WindowInfo(win, 14), -- x
    WindowInfo(win, 15), -- y
    menustring
  )

-- [[ Choose result ]] --
  local redraw_window = true
  -- General options
  if result == "Font" then
    local wanted_font = utils.fontpicker(font_name, font_size) -- font dialog
    if wanted_font then
      font_name = wanted_font.name
      font_size = wanted_font.size
      SetVariable("font_name", font_name)
      SetVariable("font_size", font_size)
      SaveState()
      OnPluginInstall()
    end
  elseif result == "Base Colour" then
    local new_colour = PickColour(base_colour)
    if new_colour ~= -1 then
      base_colour = new_colour
      SetVariable("base_colour", base_colour)
    end
  elseif result == "Short Resists" then
    short_resists_enabled = not short_resists_enabled
    SetVariable("short_resists_enabled", tostring(short_resists_enabled))

  elseif result == "Weak - Enabled" then
    weak_enabled = not weak_enabled
    SetVariable("weak_enabled", tostring(weak_enabled))
  elseif result == "Weak - Colour" then
    local new_colour = PickColour(weak_colour)
    if new_colour ~= -1 then
      weak_colour = new_colour
      SetVariable("weak_colour", weak_colour)
    end
  elseif string.find(result, "Weak - ") then
    local res = string.gsub(result, "Weak %- ", "")
    res = string.gsub(res, "%%", "")
    local res_num = tonumber(res)
    if res_num then
      weak_threshold = res_num
      SetVariable("weak_threshold", weak_threshold)
    else
      weak_whitelist[res] = not weak_whitelist[res]
      SetVariable("weak_whitelist", whitelist_tostring(weak_whitelist))
    end

  elseif result == "Neutral - Enabled" then
    neutral_enabled = not neutral_enabled
    SetVariable("neutral_enabled", tostring(neutral_enabled))
  elseif result == "Neutral - Colour" then
    local new_colour = PickColour(neutral_colour)
    if new_colour ~= -1 then
      neutral_colour = new_colour
      SetVariable("neutral_colour", neutral_colour)
    end
  elseif string.find(result, "Neutral - ") then
    local res = string.gsub(result, "Neutral %- ", "")
    local res_num = tonumber(res)
    if res_num then
      neutral_threshold = res_num
      SetVariable("neutral_threshold", neutral_threshold)
    else
      neutral_whitelist[res] = not neutral_whitelist[res]
      SetVariable("neutral_whitelist", whitelist_tostring(neutral_whitelist))
    end

  elseif result == "Strong - Enabled" then
    strong_enabled = not strong_enabled
    SetVariable("strong_enabled", tostring(strong_enabled))
  elseif result == "Strong - Colour" then
    local new_colour = PickColour(strong_colour)
    if new_colour ~= -1 then
      strong_colour = new_colour
      SetVariable("strong_colour", strong_colour)
    end
  elseif string.find(result, "Strong - ") then
    local res = string.gsub(result, "Strong %- ", "")
    res = string.gsub(res, "%%", "") 
    local res_num = tonumber(res)
    if res_num then
      strong_threshold = res_num
      SetVariable("strong_threshold", strong_threshold)
    else
      strong_whitelist[res] = not strong_whitelist[res]
      SetVariable("strong_whitelist", whitelist_tostring(strong_whitelist))
    end

  elseif result == "Immune - Enabled" then
    immune_enabled = not immune_enabled
    SetVariable("immune_enabled", tostring(immune_enabled))
  elseif result == "Immune - Colour" then
    local new_colour = PickColour(immune_colour)
    if new_colour ~= -1 then
      immune_colour = new_colour
      SetVariable("immune_colour", immune_colour)
    end
  elseif string.find(result, "Immune - ") then
    local res = string.gsub(result, "Immune %- ", "")
    immune_whitelist[res] = not immune_whitelist[res]
    SetVariable("immune_whitelist", whitelist_tostring(immune_whitelist))

  elseif result == "Bring to Front" then
    window_send_front()
  elseif result == "Send to Back" then
    window_send_back()

  elseif result == "Reset Defaults" then
    font_name = default_font_name
    font_size = default_font_size
    width = DEFAULT_WIDTH
    height = DEFAULT_HEIGHT

    snd_target = ""
    enemy = ""
    seekdb_results = {}
    short_resists_enabled = false

    weak_enabled = true
    neutral_enabled = true
    strong_enabled = true
    immune_enabled = true

    weak_whitelist = table.shallow_copy(DEFAULT_WHITELIST)
    neutral_whitelist = table.shallow_copy(DEFAULT_WHITELIST)
    strong_whitelist = table.shallow_copy(DEFAULT_WHITELIST)
    immune_whitelist = table.shallow_copy(DEFAULT_WHITELIST)

    weak_threshold = DEFAULT_WEAK_THRESHOLD
    neutral_threshold = DEFAULT_NEUTRAL_THRESHOLD
    strong_threshold = DEFAULT_STRONG_THRESHOLD

    base_colour = DEFAULT_BASE_COLOUR
    weak_colour = DEFAULT_WEAK_COLOUR
    neutral_colour = DEFAULT_NEUTRAL_COLOUR
    strong_colour = DEFAULT_STRONG_COLOUR
    immune_colour = DEFAULT_IMMUNE_COLOUR
    
    window_save()
    window_install()
  else
    redraw_window = false -- Nothing changed, don't redraw_window
  end
-- [[ End choose result ]] --

  if redraw_window then window_draw() end
end -- right_click_menu --

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

  if width < MIN_SIZE then
    width = MIN_SIZE
    startx = windowinfo.window_left + width
  elseif windowinfo.window_left + width > GetInfo(281) then -- client window width
    width = GetInfo(281) - windowinfo.window_left
    startx = GetInfo(281)
  end
    
  height = height + posy - starty
  starty = posy

  if height < MIN_SIZE then
    height = MIN_SIZE
    starty = windowinfo.window_top + height
  elseif windowinfo.window_top + height > GetInfo(280) then -- client window height
    height = GetInfo(280) - windowinfo.window_top
    starty = GetInfo(280)
  end

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
  if bit.band(flags, miniwin.hotspot_got_rh_mouse) ~= 0 then
    right_click_menu()
  end
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

  SetVariable("font_name", font_name)
  SetVariable("font_size", font_size)

  CallPlugin("462b665ecb569efbf261422f","boostMe", win)

  SetVariable("short_resists_enabled", tostring(short_resists_enabled))

  SetVariable("weak_enabled", tostring(weak_enabled))
  SetVariable("strong_enabled", tostring(strong_enabled))
  SetVariable("immune_enabled", tostring(immune_enabled))

  SetVariable("weak_whitelist", whitelist_tostring(weak_whitelist))
  SetVariable("strong_whitelist", whitelist_tostring(strong_whitelist))
  SetVariable("immune_whitelist", whitelist_tostring(immune_whitelist))

  SetVariable("weak_threshold", weak_threshold)
  SetVariable("strong_threshold", strong_threshold)

  SetVariable("base_colour", base_colour)
  SetVariable("weak_colour", weak_colour)
  SetVariable("strong_colour", strong_colour)
  SetVariable("immune_colour", immune_colour)
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
  window_install()
end

function OnPluginSaveState()
  window_save()
end

function OnPluginBroadcast(msg, id, name, text)
  window_broadcast(msg, id, name, text)
end

function OnPluginClose()
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

plugin_url = ""
xml_url = "https://raw.githubusercontent.com/zwyatt/SeekDB/refs/heads/main/SeekDB.xml"
lua_url = "https://raw.githubusercontent.com/zwyatt/SeekDB/refs/heads/main/SeekDB.lua"

pluginFile = ""
xml_path = GetPluginInfo(GetPluginID(), 6) -- SeekDB.xml
lua_path = Replace(xml_path, "SeekDB.xml", "SeekDB.lua")


plugin_protocol = "HTTPS"
plugin_prefix = "[SeekDB]"

function update_check()
  update_plugin("check")
  ColourNote("white", "", plugin_prefix .. " Checking for updated version...")
end

function update_install()
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

reload_ready = false

function update_plugin(mode)
  update_mode = mode
  reload_ready = false
  
  plugin_url = xml_url
  pluginFile = xml_path
  wait.make(get_plugin_file)
  
  plugin_url = lua_url
  pluginFile = lua_path
  wait.make(get_plugin_file)
end

function get_plugin_file()
  local loc_plugin_url = plugin_url
  local loc_pluginFile = pluginFile
  local urlThread = async.request(loc_plugin_url, plugin_protocol)

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

    local file = io.open(loc_pluginFile, "wb")
    file:write(pluginData)
    file:close()
    if reload_ready then
      reload_plugin()
    else
      reload_ready = true
    end
  else
    ColourNote("red", "", plugin_prefix .. " Invalid update mode: " .. update_mode)
  end
end
----------------------- End Plugin Update Code -----------------------
