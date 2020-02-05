FACTION.name = "Civis"
-- This faction is default by the server.
-- This faction does not requires a whitelist.
-- A description used in tooltips in various menus.
FACTION.desc = "The civilian faction of the city."
-- A color to distinguish factions from others, used for stuff such as
-- name color in OOC chat.
FACTION.color = Color(20, 150, 15)
-- The list of models of the citizens.
-- Only default citizen can wear Advanced Citizen Wears and new facemaps.
local CITIZEN_MODELS = {
	"models/newbetacitizens/male_07.mdl",
	"models/newbetacitizens/male_02.mdl",
	"models/newbetacitizens/male_01.mdl",
	"models/newbetacitizens/male_06.mdl",
	"models/newbetacitizens/male_05.mdl",
	"models/newbetacitizens/male_04.mdl",
	"models/newbetacitizens/male_03.mdl",
	"models/newbetacitizens/male_12.mdl",
	"models/humans/group01/female_01.mdl",
	"models/humans/group01/female_02.mdl",
	"models/humans/group01/female_03.mdl",
	"models/humans/group01/female_04.mdl",
	"models/humans/group01/female_06.mdl",
	"models/humans/group01/female_07.mdl"
}
FACTION.models = CITIZEN_MODELS
FACTION_CITIZEN = FACTION.index