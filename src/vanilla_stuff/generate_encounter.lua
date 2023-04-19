function caravans:generate_event(conditions)
  --look throught the events table and create a table for weighted roll
  --pick one and return the event name

  local weighted_random_list = {};
  local total_probability = 0;
  local i = 0;

  local culture = conditions.faction:culture()
  local events = caravans.event_tables[culture]

  --build table for weighted roll
  for _, val in pairs(events) do
    i = i + 1;

    --Returns the probability of the event
    local args = val[1](conditions)
    local prob = args[1];
    total_probability = prob + total_probability;
    --Returns the name and target of the event
    local name_args = args[2];

    --Returns if a battle is possible from this event
    --i.e. does it need to waylay
    local is_battle = val[3];

    weighted_random_list[i] = { total_probability, name_args, is_battle }
  end

  --check all the probabilites until matched
  local no_event_chance = math.floor(Old_world_caravans.no_encounter_weight / 2)
  local random_int = cm:random_number(total_probability + no_event_chance, 1);
  local is_battle = nil;
  local contextual_event_name = nil;

  for j = 1, i do
    if weighted_random_list[j][1] >= random_int then
      contextual_event_name = weighted_random_list[j][2];
      is_battle = weighted_random_list[j][3];
      break;
    end
  end

  if cm:tol_campaign_key() then
    contextual_event_name = nil;
  end

  return contextual_event_name, is_battle
end

