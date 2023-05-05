---@param context CaravanWaylaid
function Old_world_caravans:magic_item_handler(context)
  local faction = context:faction()
  local faction_name = context:faction():name();
  local caravan_force = context:caravan():caravan_force();
  local caravan = context:caravan();
  local faction_sc = faction:culture();

  local dilemma_name = "owc_main_dilemma_caravan_good_deal";

  caravans:attach_battle_to_dilemma(
    dilemma_name,
    caravan,
    nil,
    false,
    nil,
    nil,
    nil,
    function()
      self:increase_caravan_cargo(caravan, 200)
    end);

  local ancillary_categories = {
    "armour",
    "enchanted_item",
    "banner",
    "talisman",
    "weapon",
  };

  if faction_sc ~= "wh_main_dwf_dwarfs" then
    table.insert(ancillary_categories, "arcane_item")
  end

  local category = ancillary_categories[cm:random_number(#ancillary_categories)]

  local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
  local payload_builder = cm:create_payload();

  --works incorrectly for dwarfs
  local random_item = get_random_ancillary_key_for_faction(faction_name, category, "rare");
  payload_builder:faction_ancillary_gain(faction, random_item);

  dilemma_builder:add_choice_payload("FIRST", payload_builder);
  payload_builder:clear();

  local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
  cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 200);
  cargo_bundle:set_duration(0);
  payload_builder:effect_bundle_to_force(caravan_force, cargo_bundle);
  dilemma_builder:add_choice_payload("SECOND", payload_builder);

  dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
  dilemma_builder:add_target("target_military_1", caravan_force);

  self:log("dilemma_builder is finished, launch the dilemma")

  cm:launch_custom_dilemma_from_builder(dilemma_builder, faction);

end
