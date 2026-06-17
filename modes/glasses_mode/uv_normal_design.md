here are my answers
rewrite this to include my responses below


Main issues
“Always active” conflicts with “stems from base mode”
Your base mode starts on ball_starting and stops on ball_will_end, so this mode would be active during balls only, not attract/idle. That is probably what you want.
----removed the flashing part from scope for this mode

This should probably be a separate mode, not inside base.yaml
Make modes/glasses_mode/config/glasses_mode.yaml, started by mode_base_started, stopped by mode_base_stopping. Cleaner and easier to debug.
----added this to the description

Your existing varitarget.yaml already controls the reset coil
You already have reset logic pulsing c_16_varitarget_reset from varitarget_reset_request / varitarget_reset_step in base. Adding another homing system could double-pulse or fight it. Better: either replace the existing reset logic, or have Glasses Mode use the existing varitarget_reset_request events.
----ignore this


“Active for >1 seconds” should use timers, not raw switch active events
The varitarget is rough, so your debounce idea is good. Each position should start a 1s confirm timer, and cancel/reset if another position appears before completion.
State 0 homing interruption logic is tricky
You say remember the starting position, then if a deeper position becomes active, cancel homing and go there. That is valid, but MPF YAML will need stored player variables like:
glasses_home_start_pos
glasses_current_state
glasses_homing_active

Without those, the mode cannot know whether a later switch is “greater than original homing position.”
----implement this




You say max 10 pulses, then failed, then 10 more pulses, then move on
fixed, 10 pulses only


This needs clearer final behaviour. After 10 failed pulses, should it:
move to State 1 anyway? 

----it should just wait for next state chage (ball hitting varitarget)




State movement should include both forward and backward movement
You mention “hit again and moved further back, or something else pulses reset coil.” That means the position can go deeper or return toward home. Your state lists include other switches, which is good, but the logic should simply say:
while any position 2–7 is confirmed, switch to that confirmed state. If position 1 is confirmed, go to State 1.
Show cleanup needs keys
To reliably stop shows like show_glasses_bottom_fast_1, they should be started with keys, for example:
key: glasses_bottom_fast

Then stop glasses_bottom_fast, not just the show name.

----implement all of this in a updated complete description of the state machine






Priority must be higher than music/background shows
Your ball music shows are priority 10–200, and hit effects are often 500/1500 in base.yaml.
For Glasses Mode, I’d use:
glasses/UV state shows: priority: 800

Basic UV flash uses switches already used by STARs mode
s_40 and s_41 are already part of STARs Mode target logic. That is okay, but the UV flash show should be short and keyed separately so it does not stop or interfere with STARs green target flashing.
---- do that - key it seperately


State 3 text has a mismatch
For show_glasses_mid_fast_1, you say “fast” in the name, but description says slow 1–2 seconds. Decide whether it is fast or slow.
----fixed



State 7 show name missing from cleanup list
You list cleanup for bottom/mid/top shows, but not show_glasses_all_1. Add it

----add it


__________________________________________________________________________________________________________________


State Machine - Glasses_Mode

Starts
mode_base_started

stops 
mode_base_stopping

new mode that will be listed in base.yaml
__________________________________________________________________________________________________________________
State 0: varitarget_homing
this defines the varitarget_home_command

post event varitarget_homing
pulse
c_16_varitarget_reset:
a maximum of 10 times OR until s_64_varitarget_position_1 = ACTIVE
if s_64_varitarget_position_1 = ACTIVE is not reached 
post event varitarget_homing_failed
move on

during homing remember the start position of homing
if any of these varitarget switches that are greater than the original homing position become active during varitarget_homing, because the varitarget is hit again and moved further back

for example
varitarget_homing starts at s_65_varitarget_position_2:
and then any of these switches become active
    s_66_varitarget_position_3:
    s_67_varitarget_position_4:
    s_68_varitarget_position_5:
    s_69_varitarget_position_6:
    s_70_varitarget_position_7:
post event varitarget_home_interrupted
cancel the varitarget_home_command AND move to that switches respective state

Else if s_64_varitarget_position_1 = ACTIVE
post event varitarget_home_success

turn off light shows
show_glasses_bottom_fast_1
show_glasses_bottom_slow_1
show_glasses_mid_fast_1
show_glasses_mid_slow_1
show_glasses_top_fast_1
show_glasses_top_slow_1
show_uvleds_slings_1
show_uvleds_drops_1
show_uvleds_pop_left_1
show_uvleds_top_left_1
show_uvleds_top_right_1
show_uvleds_mid_pop_1

THEN

Move to State 1


__________________________________________________________________________________________________________________

State 1: s_64_varitarget_position_1 = ACTIVE, varitarget is in the 'home position'
waiting on the varitarget to be hit and moved to another state


__________________________________________________________________________________________________________________
State 2: 
If
s_65_varitarget_position_2:
is active for > 1 seconds (debouncing as varitarget is very rough)
post event: varitarget_position_2_confirmed
this state is now active for 10 seconds

play light shows
    Light show name: show_glasses_bottom_fast_1
    turn on LEDs
        l_pf1_1_9
        l_pf1_1_10
        l_pf1_1_11
    with a bright Green to Purple Fading between each colour at a fast 0.5 seconds rate

AND
    
    Light show name: show_uvleds_slings_1
    turn on LEDs
    l_pf2_1_1 
    l_pf2_1_2
    l_pf2_1_3
    l_pf2_1_4
    l_pf2_1_5
    l_pf2_1_6
    l_pf2_1_7
    RED
while this mode is active
if the varitarget switches become active (the varitarget is hit again and moved further back, or something else pulses the reset coil)
    s_66_varitarget_position_3:
    s_67_varitarget_position_4:
    s_68_varitarget_position_5:
    s_69_varitarget_position_6:
    s_70_varitarget_position_7:
    move to their respective state


after 10 seconds (state length) of
    varitarget_position_2_confirmed
    post event varitarget_position_2_complete
then
Move to state 0 - Varitarget_homing






__________________________________________________________________________________________________________________
State 3: 
If
s_66_varitarget_position_3:
is active for > 1 seconds (debouncing as varitarget is very rough)
post event: varitarget_position_3_confirmed
this state is now active for 10 seconds

play light shows
    Light show name: show_glasses_bottom_slow_1
    turn on LEDs
        l_pf1_1_9
        l_pf1_1_10
        l_pf1_1_11
    with a bright Green to Purple Fading between each colour at a slow 1-2 seconds rate

AND
play light shows 
    Light show name: show_glasses_mid_fast_1
    turn on LEDs
        l_pf1_1_12
        l_pf1_1_13
        l_pf1_1_14
    with a bright Green to Purple Fading between each colour at a fast 0.5 seconds rate

AND
    
    Light show name: show_uvleds_slings_1
    turn on LEDs
    l_pf2_1_1 
    l_pf2_1_2
    l_pf2_1_3
    l_pf2_1_4
    l_pf2_1_5
    l_pf2_1_6
    l_pf2_1_7
    RED

AND
    
    Light show name: show_uvleds_drops_1
    turn on LEDs
    l_pf2_1_8 
    l_pf2_1_9
    l_pf2_1_10
    RED




while this mode is active
if the varitarget switches become active (the varitarget is hit again and moved further back, or something else pulses the reset coil)
    s_65_varitarget_position_2:
    s_67_varitarget_position_4:
    s_68_varitarget_position_5:
    s_69_varitarget_position_6:
    s_70_varitarget_position_7:
    move to their respective state


after 10 seconds (state length) of
    varitarget_position_3_confirmed
    post event varitarget_position_3_complete

then
Move to state 0 - Varitarget_homing



__________________________________________________________________________________________________________________

State 4: 
If
s_67_varitarget_position_4:
is active for > 1 seconds (debouncing as varitarget is very rough)
post event: varitarget_position_4_confirmed
this state is now active for 10 seconds

play light shows
    Light show name: show_glasses_bottom_slow_1
    turn on LEDs
        l_pf1_1_9
        l_pf1_1_10
        l_pf1_1_11
    with a bright Green to Purple Fading between each colour at a slow 1-2 seconds rate

AND
play light shows 
    Light show name: show_glasses_mid_slow_1
    turn on LEDs
        l_pf1_1_12
        l_pf1_1_13
        l_pf1_1_14
    with a bright Green to Purple Fading between each colour at a slow 1-2 seconds rate

AND
    
    Light show name: show_uvleds_slings_1
    turn on LEDs
    l_pf2_1_1 
    l_pf2_1_2
    l_pf2_1_3
    l_pf2_1_4
    l_pf2_1_5
    l_pf2_1_6
    l_pf2_1_7
    RED

AND
    
    Light show name: show_uvleds_drops_1
    turn on LEDs
    l_pf2_1_8 
    l_pf2_1_9
    l_pf2_1_10
    RED

AND
    
    Light show name: show_uvleds_pop_left_1
    turn on LEDs
    l_pf2_1_11 
    l_pf2_1_12
    RED



while this mode is active
if the varitarget switches become active (the varitarget is hit again and moved further back, or something else pulses the reset coil)
    s_65_varitarget_position_2:
    s_66_varitarget_position_3:
    s_68_varitarget_position_5:
    s_69_varitarget_position_6:
    s_70_varitarget_position_7:
    move to their respective state


after 10 seconds (state length) of
    varitarget_position_4_confirmed
    post event varitarget_position_4_complete

then
Move to state 0 - Varitarget_homing


___________________________________________________________________________________________________________

State 5: 
If
s_68_varitarget_position_5:
is active for > 1 seconds (debouncing as varitarget is very rough)
post event: varitarget_position_5_confirmed
this state is now active for 10 seconds

play light shows
    Light show name: show_glasses_bottom_slow_1
    turn on LEDs
        l_pf1_1_9
        l_pf1_1_10
        l_pf1_1_11
    with a bright Green to Purple Fading between each colour at a slow 1-2 seconds rate

AND
play light shows 
    Light show name: show_glasses_mid_slow_1
    turn on LEDs
        l_pf1_1_12
        l_pf1_1_13
        l_pf1_1_14
    with a bright Green to Purple Fading between each colour at a slow 1-2 seconds rate


AND
play light shows 
    Light show name: show_glasses_top_fast_1
    turn on LEDs
        l_pf1_1_15
        l_pf1_1_16
        l_pf1_1_17
    with a bright Green to Purple Fading between each colour at a fast 0.5 seconds rate

AND
    
    Light show name: show_uvleds_slings_1
    turn on LEDs
    l_pf2_1_1 
    l_pf2_1_2
    l_pf2_1_3
    l_pf2_1_4
    l_pf2_1_5
    l_pf2_1_6
    l_pf2_1_7
    RED

AND
    
    Light show name: show_uvleds_drops_1
    turn on LEDs
    l_pf2_1_8 
    l_pf2_1_9
    l_pf2_1_10
    RED

AND
    
    Light show name: show_uvleds_pop_left_1
    turn on LEDs
    l_pf2_1_11 
    l_pf2_1_12
    RED

AND
    
    Light show name: show_uvleds_top_left_1
    turn on LEDs
    l_pf2_1_13 
    l_pf2_1_14
    RED


while this mode is active
if the varitarget switches become active (the varitarget is hit again and moved further back, or something else pulses the reset coil)
    s_65_varitarget_position_2:
    s_66_varitarget_position_3:
    s_67_varitarget_position_4:
    s_69_varitarget_position_6:
    s_70_varitarget_position_7:
    move to their respective state


after 10 seconds (state length) of
    varitarget_position_5_confirmed
    post event varitarget_position_5_complete

then
Move to state 0 - Varitarget_homing

___________________________________________________________________________________________________________

State 6: 
If
s_69_varitarget_position_6:
is active for > 1 seconds (debouncing as varitarget is very rough)
post event: varitarget_position_6_confirmed
this state is now active for 10 seconds

play light shows
    Light show name: show_glasses_bottom_slow_1
    turn on LEDs
        l_pf1_1_9
        l_pf1_1_10
        l_pf1_1_11
    with a bright Green to Purple Fading between each colour at a slow 1-2 seconds rate

AND
play light shows 
    Light show name: show_glasses_mid_slow_1
    turn on LEDs
        l_pf1_1_12
        l_pf1_1_13
        l_pf1_1_14
    with a bright Green to Purple Fading between each colour at a slow 1-2 seconds rate


AND
play light shows 
    Light show name: show_glasses_top_slow_1
    turn on LEDs
        l_pf1_1_15
        l_pf1_1_16
        l_pf1_1_17
    with a bright Green to Purple Fading between each colour at a slow 1-2 seconds rate

AND
    
    Light show name: show_uvleds_slings_1
    turn on LEDs
    l_pf2_1_1 
    l_pf2_1_2
    l_pf2_1_3
    l_pf2_1_4
    l_pf2_1_5
    l_pf2_1_6
    l_pf2_1_7
    RED

AND
    
    Light show name: show_uvleds_drops_1
    turn on LEDs
    l_pf2_1_8 
    l_pf2_1_9
    l_pf2_1_10
    RED

AND
    
    Light show name: show_uvleds_pop_left_1
    turn on LEDs
    l_pf2_1_11 
    l_pf2_1_12
    RED

AND
    
    Light show name: show_uvleds_top_left_1
    turn on LEDs
    l_pf2_1_13 
    l_pf2_1_14
    RED

AND

    Light show name: show_uvleds_top_right_1
    turn on LEDs
    l_pf2_1_15 
    l_pf2_1_16
    l_pf2_1_17
    RED




while this mode is active
if the varitarget switches become active (the varitarget is hit again and moved further back, or something else pulses the reset coil)
    s_65_varitarget_position_2:
    s_66_varitarget_position_3:
    s_67_varitarget_position_4:
    s_68_varitarget_position_5:
    s_70_varitarget_position_7:
    move to their respective state


after 10 seconds (state length) of
    varitarget_position_6_confirmed
    post event varitarget_position_6_complete

then
Move to state 0 - Varitarget_homing

__________________________________________________________________________________________________________________

State 7: 
If
s_70_varitarget_position_7:
is active for > 1 seconds (debouncing as varitarget is very rough)
post event: varitarget_position_7_confirmed
this state is now active for 10 seconds

play light shows
    Light show name: show_glasses_all_1
    turn on LEDs
        l_pf1_1_9
        l_pf1_1_10
        l_pf1_1_11
    then off

    THEN
    
    turn on LEDs
        l_pf1_1_12
        l_pf1_1_13
        l_pf1_1_14
    then off
    
    THEN
    
    turn on LEDs
        l_pf1_1_15
        l_pf1_1_16
        l_pf1_1_17
    then off
    with a bright Green to Purple Fading between each colour at a slow 1-2 seconds rate

AND
    
    Light show name: show_uvleds_slings_1
    turn on LEDs
    l_pf2_1_1 
    l_pf2_1_2
    l_pf2_1_3
    l_pf2_1_4
    l_pf2_1_5
    l_pf2_1_6
    l_pf2_1_7
    RED

AND
    
    Light show name: show_uvleds_drops_1
    turn on LEDs
    l_pf2_1_8 
    l_pf2_1_9
    l_pf2_1_10
    RED

AND
    
    Light show name: show_uvleds_pop_left_1
    turn on LEDs
    l_pf2_1_11 
    l_pf2_1_12
    RED

AND
    
    Light show name: show_uvleds_top_left_1
    turn on LEDs
    l_pf2_1_13 
    l_pf2_1_14
    RED

AND

    Light show name: show_uvleds_top_right_1
    turn on LEDs
    l_pf2_1_15 
    l_pf2_1_16
    l_pf2_1_17
    RED

AND

    Light show name: show_uvleds_mid_pop_1
    turn on LEDs
    l_pf2_1_18
    l_pf2_1_19
    l_pf2_1_20
    l_pf2_1_21
    RED


while this mode is active
if the varitarget switches become active (the varitarget is hit again and moved further back, or something else pulses the reset coil)
    s_65_varitarget_position_2:
    s_66_varitarget_position_3:
    s_67_varitarget_position_4:
    s_68_varitarget_position_5:
    s_69_varitarget_position_6:
    move to their respective state


after 10 seconds (state length) of
    varitarget_position_7_confirmed
    post event varitarget_position_7_complete

then
Move to state 0 - Varitarget_homing