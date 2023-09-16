---@param context CaravanCompleted
function caravans:handle_caravan_complete(context)
  -- store a total value of goods moved for this faction and then trigger an onwards event, narrative scripts use this
  local node = context:complete_position():node()
  local region_name = node:region_key()
  local region = node:region_data():region()
  local region_owner = region:owning_faction();

  out.design("Caravan (player) arrived in: " .. region_name)

  local faction = context:faction()
  local faction_key = faction:name();
  local prev_total_goods_moved = cm:get_saved_value("caravan_goods_moved_" .. faction_key) or 0;
  local num_caravans_completed = cm:get_saved_value("caravans_completed_" .. faction_key) or 0;
  cm:set_saved_value("caravan_goods_moved_" .. faction_key, prev_total_goods_moved + context:cargo());
  cm:set_saved_value("caravans_completed_" .. faction_key, num_caravans_completed + 1);
  core:trigger_event("ScriptEventCaravanCompleted", context);

  if faction:is_human() then
    self:reward_item_check(faction, region_name, context:caravan_master())
  end
  --faction has tech that grants extra trade tariffs bonus after every caravan - create scripted bundle
  if faction:has_technology("wh3_dlc23_tech_chd_industry_24") then
    local temp_trade = self.trade_modifier + 5
    self.trade_modifier = temp_trade
    local trade_effect = "wh_main_effect_economy_trade_tariff_mod"
    local trade_effect_bundle = cm:create_new_custom_effect_bundle(
      "wh3_dlc23_effect_chd_convoy_trade_tariff_scripted_bundle")

    trade_effect_bundle:add_effect(trade_effect, "faction_to_faction_own_unseen", temp_trade)
    trade_effect_bundle:set_duration(0)

    if faction:has_effect_bundle(trade_effect_bundle:key()) then
      cm:remove_effect_bundle(trade_effect_bundle:key(), faction:name())
    end
    cm:apply_custom_effect_bundle_to_faction(trade_effect_bundle, faction)
  end

  if not region_owner:is_null_interface() then
    local region_owner_key = region_owner:name()
    ---@diagnostic disable-next-line: undefined-field
    cm:cai_insert_caravan_diplomatic_event(region_owner_key, faction_key)

    if region_owner:is_human() and faction_key ~= region_owner_key then
      local incident_key = "wh3_main_cth_caravan_completed_received"
					
      if faction:culture() == "wh3_dlc23_chd_chaos_dwarfs" then
        incident_key = "wh3_dlc23_chd_convoy_completed_received"
      end

      cm:trigger_incident_with_targets(
        region_owner:command_queue_index(),
        incident_key,
        ---@diagnostic disable-next-line: param-type-mismatch
        0, 0, 0, 0, region:cqi(), 0
      )
    end
  end

  --Reduce demand
  local cargo = context:caravan():cargo()
  local value = math.floor(-cargo / 18)
  local faction = self.culture_to_faction[context:faction():culture()];
  cm:callback(function() self:adjust_end_node_value(region_name, value, "add", faction) end, 5);
end
