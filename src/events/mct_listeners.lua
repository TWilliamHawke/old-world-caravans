function Old_world_caravans:add_mct_listeners()
  core:add_listener(
    "supply_lines_mct",
    "MctInitialized",
    true,
    function(context)
      self:mct_init(context)
      self:logCore("MCT was INIT")
    end,
    true
  )



  core:add_listener(
    "supply_lines_MctFinalized",
    "MctFinalized",
    true,
    function(context)
      self:mct_init(context)
      self:logCore("MCT FINALIZED")

      local ok, err = pcall(function()
        self:create_new_log();
        local army_key = tostring(self.default_enemy_culture).."_"..tostring(self.default_difficult)
        local budget_key = "encounter_budget_"..tostring(self.default_difficult);
        local budget = self[budget_key] or 3500;

        self:logCore(budget)
        for i = 1, 20 do
          self:logCore("army #"..i)
          self:generate_army(army_key, budget);
        end
      
      end);
      
      if not ok then
        self:logCore(tostring(err));
      end

    end,
    true
  )

end;