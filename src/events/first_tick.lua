function Old_world_caravans:add_first_tick_callbacks()
  cm:add_first_tick_callback_new(
    function()
      Old_world_caravans:recruit_start_caravan();
    end
  )

  cm:add_first_tick_callback(
    function()

      Old_world_caravans:hide_caravan_button_for_belegar();
    end
  )
end
