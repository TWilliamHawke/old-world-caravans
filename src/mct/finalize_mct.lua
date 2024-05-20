function Old_world_caravans:finalize_mct(context)
  if not context or not context.mct then return end
  local mct = context:mct()

  local ok, err = pcall(function()
    local fluc_mct = mct:get_mod_by_key("old_world_caravans")
    local settings = fluc_mct:get_settings(); ---@type MCT_settings

    self:apply_cargo_value_effect(settings.cargo_value)

    if cm:is_multiplayer() then return end

    local human_factions = cm:get_human_factions()
    if not human_factions or type(human_factions) ~= "table" then return end

    local access, check_access_foreach;

    if self.disable_player_caravans then
      access = false;
    elseif self.force_enable then
      access = true;
    elseif self.player_caravans_was_disabled then
      access = false;
      check_access_foreach = true;
      self.player_caravans_was_disabled = false;
    end

    if access == nil then return end

    for i = 1, #human_factions do
      local faction_name = human_factions[i]
      local faction = cm:get_faction(faction_name)

      if faction and self:faction_has_caravans(faction) and self:faction_is_supported(faction) then
        local save_key = self.is_init_save_key .. faction_name;

        if check_access_foreach then
          access = not self:caravan_button_should_be_hidden(faction);
        end

        if access == false then
          self:disband_all_caravans(faction);
        elseif not cm:get_saved_value(save_key) then
          cm:set_saved_value(save_key, true);
        end
        self:trigger_toggle_button_event(faction, access);
      end
    end
  end);

  if not ok then
    self:logCore(tostring(err));
  end
end
