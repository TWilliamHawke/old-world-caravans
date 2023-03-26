---@class Encounter_creator_context
---@field faction FACTION_SCRIPT_INTERFACE
---@field caravan CARAVAN_SCRIPT_INTERFACE
---@field from REGION_SCRIPT_INTERFACE
---@field to REGION_SCRIPT_INTERFACE
---@field list_of_regions REGION_DATA_LIST_SCRIPT_INTERFACE
---@field bandit_threat integer
---@field ownership_mult number

---@alias enemy_data_callback fun() : string, string, 1|2|3

--TODO replace supply lines function

---@class MCT_settings
---@field default_enemy string
---@field default_encounter string
---@field override_enemy boolean
---@field override_encounters boolean
---@field scale_difficulty_cargo boolean
---@field scale_difficulty_strenght boolean
---@field enable_log boolean
---@field force_enable boolean
---@field default_difficult 1 | 2 | 3
---@field encounter_budget_1 integer
---@field encounter_budget_2 integer
---@field encounter_budget_3 integer
---@field filler_unit_weight integer
---@field no_encounter_weight integer

