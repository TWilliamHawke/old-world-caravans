---@param force MILITARY_FORCE_SCRIPT_INTERFACE
function Old_world_caravans:remove_caravan_upkeep(force)
  local bundle_key = "owc_caravan_reduce_upkeep";

  if force:has_effect_bundle(bundle_key) then
    cm:remove_effect_bundle_from_force(bundle_key, force:command_queue_index());
  end

  if vfs.exist("script/campaign/mod/flexible_unit_caps.lua") then return end

  local difficulty = cm:model():combined_difficulty_level();

  local effect_bundle = cm:create_new_custom_effect_bundle(bundle_key);
  effect_bundle:set_duration(0);

  local upkeep_value = -1 -- easy
  if difficulty == 0 then
    upkeep_value = -1 -- normal
  elseif difficulty == -1 then
    upkeep_value = -2 -- hard
  elseif difficulty == -2 then
    upkeep_value = -4 -- very hard
  elseif difficulty == -3 then
    upkeep_value = -4 -- legendary
  end

  effect_bundle:add_effect("wh_main_effect_force_all_campaign_upkeep_hidden", "force_to_force_own_factionwide",
    upkeep_value);
  cm:apply_custom_effect_bundle_to_force(effect_bundle, force);
end
