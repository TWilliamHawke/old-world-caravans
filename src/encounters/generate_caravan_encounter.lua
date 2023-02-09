---@param context QueryShouldWaylayCaravan | CaravanMoved
function Old_world_caravans:generate_caravan_event(context)
  local list_of_regions = self:get_regions_list_from_context(context);
  if not list_of_regions then return end
  local caravan = context:caravan();
  local caravan_master = context:caravan_master():character();
  local faction = context:faction();
  local start_region = self:get_region_by_node(caravan, context:from());
  local end_region = self:get_region_by_node(caravan, context:to());
  local bandit_threat = self:calculate_bandit_threat(list_of_regions);

  ---@type Encounter_creator_context
  local conditions = {
    caravan = caravan,
    caravan_master = caravan_master,
    list_of_regions = list_of_regions,
    bandit_threat = bandit_threat,
    faction = faction,
    from = start_region,
    to = end_region,
  };

  local event = "new_agent_creator"
  local probability, event_string = self:enemy_attack_creator(conditions);
  
  local ok, err = pcall(function()
    self:local_trouble_handler(context, event_string)

    if probability > 0 then
    end
  end);

  if not ok then
    self:logCore(tostring(err));
  end




end
