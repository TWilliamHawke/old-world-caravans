---@param context QueryShouldWaylayCaravan | CaravanMoved | CaravanWaylaid
function Old_world_caravans:generate_caravan_event(context)
  local region_names, list_of_regions = self:get_regions_list(context);
  if not region_names then return end
  local caravan = context:caravan();
  local caravan_master = context:caravan_master():character();
  local faction = context:faction();
  local start_region = self:get_region_by_node(caravan, context:from());
  local end_region = self:get_region_by_node(caravan, context:to());
  local bandit_threat = self:calculate_bandit_threat(region_names);

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
  local probability, event_string = self:local_trouble_creator(conditions);
  
  local ok, err = pcall(function()
    self:local_trouble_handler(context, event_string)

    if probability > 0 then
      self:logCore("probability is "..probability)
    end
  end);

  if not ok then
    self:logCore(tostring(err));
  end




end
