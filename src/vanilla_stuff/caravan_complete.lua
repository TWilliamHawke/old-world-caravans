---@diagnostic disable: param-type-mismatch
---@param context CaravanCompleted
function Old_world_caravans:complete_caravans(context)
  local node = context:complete_position():node()
  local region_name = node:region_key()
  local region_owner = node:region_data():region():owning_faction();
  local faction = context:faction()
  local faction_sc = faction:subculture()
  local award = Old_world_caravans.awards.vanilla[region_name];
  out.design("Caravan (player) arrived in: " .. region_name)

  local faction_key = faction:name();
  local prev_total_goods_moved = cm:get_saved_value("caravan_goods_moved_" .. faction_key) or 0;
  local num_caravans_completed = cm:get_saved_value("caravans_completed_" .. faction_key) or 0;
  cm:set_saved_value("caravan_goods_moved_" .. faction_key, prev_total_goods_moved + context:cargo());
  cm:set_saved_value("caravans_completed_" .. faction_key, num_caravans_completed + 1);
  core:trigger_event("ScriptEventCaravanCompleted", context);

  if faction:is_human() and faction_sc == "wh3_main_sc_cth_cathay" and award then
    reward_item_check(faction, region_name, context:caravan_master())
  end

  if not region_owner:is_null_interface() then
    local region_owner_key = region_owner:name()
    out.design("Inserting a diplomatic event for caravan arriving. Factions: " .. region_owner_key .. ", " ..
      faction_key)
    ---@diagnostic disable-next-line: undefined-field
    cm:cai_insert_caravan_diplomatic_event(region_owner_key, faction_key)

    if region_owner:is_human() and faction_key ~= region_owner_key then
      cm:trigger_incident_with_targets(
        region_owner:command_queue_index(),
        "wh3_main_cth_caravan_completed_received", 0, 0,
        context:caravan_master():character():command_queue_index(), 0, 0, 0
      )
    end
  end

  --Reduce demand
  local cargo = context:caravan():cargo()
  local value = math.floor(-cargo / 18);

  if not faction:is_human() then
    value = value / 3;
  end
  out.design("Reduce " .. region_name)

  cm:callback(function() adjust_end_node_value(region_name, value, "add") end, 5);
end
