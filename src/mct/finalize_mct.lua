function Old_world_caravans:finalize_mct(context)
  if not context or not context.mct then return end
  local mct = context:mct()

  local ok, err = pcall(function()
    local fluc_mct = mct:get_mod_by_key("old_world_caravans")
    local settings = fluc_mct:get_settings(); ---@type MCT_settings

    if not settings.force_enable then return end

    local human_factions = cm:get_human_factions()
    if not human_factions or type(human_factions) ~= "table" then return end

    for _, faction_name in ipairs(human_factions) do
      local faction = cm:get_faction(faction_name)

      if faction and self:faction_has_caravans(faction)
          and not self:caravan_button_should_be_visible(faction)
      then
        self:logCore("show caravans for " .. faction_name)
        if cm:get_local_faction():name() == faction_name then
          self:show_caravan_button();
        end
        cm:set_saved_value(self.is_init_save_key .. faction_name, true)
      end
    end
  end);

  if not ok then
    self:logCore(tostring(err));
  end
end
