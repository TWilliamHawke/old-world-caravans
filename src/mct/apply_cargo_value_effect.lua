---@param value integer
function Old_world_caravans:apply_cargo_value_effect(value)
  local human_factions = cm:get_human_factions() or {};
  local bundle_name = "owc_caravan_cargo_value";

  for i = 1, #human_factions do
    local faction = cm:get_faction(human_factions[i])

    if self:faction_has_caravans(faction) then
      if faction:has_effect_bundle(bundle_name) then
        cm:remove_effect_bundle(bundle_name, human_factions[i])
      end

      local effect_bundle = cm:create_new_custom_effect_bundle(bundle_name)
      effect_bundle:add_effect("wh3_main_effect_caravan_cargo_value", "faction_to_character_own", value - 100);
      effect_bundle:set_duration(0);

      cm:apply_custom_effect_bundle_to_faction(effect_bundle, faction);
    end
  end
end
