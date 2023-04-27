---comment
---@param context CaravanWaylaid
function Old_world_caravans:ogres_my_lord_handler(context)
  local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_ogre_mercenaries";
  local caravan = context:caravan();
  local caravan_force = caravan:caravan_force();
  local faction = context:faction()

  caravans:attach_battle_to_dilemma(
    dilemma_name,
    caravan,
    nil,
    false,
    nil,
    nil,
    nil,
    nil);

  local orge_unit = self:select_random_key_by_weight(self.ogre_mercenaries, function(val)
        return val;
      end) or "wh3_main_ogr_inf_ironguts_0";

  local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
  local payload_builder = cm:create_payload();

  payload_builder:add_unit(caravan_force, orge_unit, 1, 0);
  payload_builder:treasury_adjustment(-1000);
  payload_builder:text_display("dummy_convoy_ogres_first");
  dilemma_builder:add_choice_payload("FIRST", payload_builder);
  payload_builder:clear();

  payload_builder:text_display("dummy_convoy_ogres_second");
  dilemma_builder:add_choice_payload("SECOND", payload_builder);

  dilemma_builder:add_target("default", caravan_force);

  out.design("Triggering dilemma:" .. dilemma_name)
  cm:launch_custom_dilemma_from_builder(dilemma_builder, faction);
end
