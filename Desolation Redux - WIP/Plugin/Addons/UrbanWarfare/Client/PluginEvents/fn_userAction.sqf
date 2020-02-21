/*
- this fix is for Desolation Redux mod (zombies required this)
*/
params ["_object","_player","_index","_action","_text","_priority","_showWindow","_hideOnUse","_shortcut","_visible","_eventName"];


// dsr_patches door_fix
uiNamespace setVariable ['LastActionTime',diag_tickTime];
uiNamespace setVariable ['LastActionTarget',_object];


false