function Old_world_caravans:logCore(text)
  local logText = tostring(text);
  local logFile = io.open("Old_world_caravans_log.txt","a");
  if(logFile == nil) then return end;

  logFile:write("FLUC: "..logText .. "  \n");
  logFile:flush();
  logFile:close();
end

function Old_world_caravans:log(text)
  if not self.debug_mode then return end
  self:logCore(text)
end

function Old_world_caravans:create_new_log()
  local logTimeStamp = os.date("%d, %m %Y %X");

  local logFile = io.open("Old_world_caravans_log.txt","w+");
  if(logFile == nil) then return end;

  logFile:write("NEW LOG ["..logTimeStamp.."] \n");
  logFile:flush();
  logFile:close();
end

