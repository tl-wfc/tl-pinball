GLASSES MODE - STATE MACHINE DESCRIPTION
=======================================

Purpose
-------
Glasses Mode is a dedicated MPF mode that runs alongside Base Mode during a ball.
It manages the vari-target driven UV/glasses feature.

The mode is designed so that the confirmed vari-target position drives the entire
state machine. Instead of manually listing every possible transition from every
state, any confirmed vari-target position immediately becomes the active state.

This makes the mode easier to maintain and more reliable when the vari-target is
rough, bounces, moves forward, moves backward, or is affected by the reset coil.


Mode Lifecycle
--------------

Mode name:
  glasses_mode

Suggested file location:
  modes/glasses_mode/config/glasses_mode.yaml

Started by:
  mode_base_started

Stopped by:
  mode_base_stopping

The mode should be listed as a normal MPF mode and should be started/stopped by
Base Mode.

This means Glasses Mode is active during gameplay, but not during attract mode or
machine idle.


Mode Priority
-------------

Recommended mode priority:
  800

Recommended show priority for Glasses Mode state shows:
  800

Reason:
  The shows need to appear above normal background/music lightshows, but should
  still allow very high priority hit effects or special mode effects to override
  them if required.


Core Design Rule
----------------

The confirmed vari-target position controls the state machine.

Any vari-target position switch must remain active for 1 second before that
position is considered confirmed.

When a position confirms:

  1. Post the matching confirmed event.
  2. Stop any currently running Glasses Mode state shows.
  3. Cancel the current state timer if one is running.
  4. Set glasses_current_state to the confirmed position.
  5. Start the shows for that position.
  6. Start a 10 second state timer for that position.

If another vari-target position confirms while a state is already active, the
mode immediately moves to the newly confirmed position. This applies whether the
vari-target moves deeper or returns toward home.

Examples:

  State 5 is active and Position 7 confirms:
    Move immediately to State 7.

  State 6 is active and Position 3 confirms:
    Move immediately to State 3.

  State 4 is active and Position 1 confirms:
    Move immediately to State 1, the home/waiting state.


Required Player Variables
-------------------------

The mode should maintain these player variables:

  glasses_current_state
    Stores the current active Glasses Mode state.

    Values:
      0 = Homing
      1 = Home / waiting
      2 = Vari-target Position 2
      3 = Vari-target Position 3
      4 = Vari-target Position 4
      5 = Vari-target Position 5
      6 = Vari-target Position 6
      7 = Vari-target Position 7

  glasses_homing_active
    Tracks whether the homing command is currently active.

    Values:
      0 = Not homing
      1 = Homing in progress

  glasses_home_start_pos
    Stores the vari-target position at the moment homing begins.

    This allows the mode to detect when the vari-target has been hit deeper
    during homing.

  glasses_pending_position
    Stores the latest position currently being checked by the 1 second debounce
    confirmation timer.

  glasses_confirmed_position
    Stores the last confirmed vari-target position.

  glasses_home_pulse_count
    Counts how many reset coil pulses have been attempted during the current
    homing command.


Vari-target Position Mapping
----------------------------

Position 1:
  Switch: s_64_varitarget_position_1
  State: 1
  Confirmed event: varitarget_position_1_confirmed

Position 2:
  Switch: s_65_varitarget_position_2
  State: 2
  Confirmed event: varitarget_position_2_confirmed

Position 3:
  Switch: s_66_varitarget_position_3
  State: 3
  Confirmed event: varitarget_position_3_confirmed

Position 4:
  Switch: s_67_varitarget_position_4
  State: 4
  Confirmed event: varitarget_position_4_confirmed

Position 5:
  Switch: s_68_varitarget_position_5
  State: 5
  Confirmed event: varitarget_position_5_confirmed

Position 6:
  Switch: s_69_varitarget_position_6
  State: 6
  Confirmed event: varitarget_position_6_confirmed

Position 7:
  Switch: s_70_varitarget_position_7
  State: 7
  Confirmed event: varitarget_position_7_confirmed


Position Confirmation / Debounce Rule
-------------------------------------

The vari-target is physically rough, so raw switch events must not directly enter
a state.

When any vari-target position switch activates:

  1. Store that position as glasses_pending_position.
  2. Restart a 1 second confirmation timer.

If a different vari-target position switch activates before the 1 second timer
finishes:

  1. Replace glasses_pending_position with the new position.
  2. Restart the 1 second confirmation timer.

When the 1 second confirmation timer completes:

  1. Post the confirmed event for glasses_pending_position.
  2. Store it as glasses_confirmed_position.
  3. Enter the matching state.

This prevents the state machine from reacting to short bounce events.


Global State Entry Rule
-----------------------

All confirmed position events use the same high-level process:

  Event: varitarget_position_X_confirmed

  Actions:
    1. Stop all Glasses Mode state shows by key.
    2. Cancel any active 10 second Glasses Mode state timer.
    3. Set glasses_current_state = X.
    4. Set glasses_confirmed_position = X.
    5. If homing is active, stop/cancel the homing command.
    6. Start the shows for State X.
    7. If X is 2-7, start the 10 second timer for State X.
    8. If X is 1, remain in home/waiting state with no shows active.


Global Show Cleanup Rule
------------------------

Before entering any new state, before homing, and when stopping the mode, stop all
Glasses Mode shows using their keys.

Show keys to stop:

  glasses_bottom_fast
  glasses_bottom_slow
  glasses_mid_fast
  glasses_mid_slow
  glasses_top_fast
  glasses_top_slow
  glasses_all

  uv_slings
  uv_drops
  uv_pop_left
  uv_top_left
  uv_top_right
  uv_mid_pop

This avoids stale shows remaining active after state changes.


Show Key Naming Convention
--------------------------

All shows must be started with keys so they can be stopped cleanly.

Glasses shows:

  show_glasses_bottom_fast_1
    key: glasses_bottom_fast

  show_glasses_bottom_slow_1
    key: glasses_bottom_slow

  show_glasses_mid_fast_1
    key: glasses_mid_fast

  show_glasses_mid_slow_1
    key: glasses_mid_slow

  show_glasses_top_fast_1
    key: glasses_top_fast

  show_glasses_top_slow_1
    key: glasses_top_slow

  show_glasses_all_1
    key: glasses_all

UV shows:

  show_uvleds_slings_1
    key: uv_slings

  show_uvleds_drops_1
    key: uv_drops

  show_uvleds_pop_left_1
    key: uv_pop_left

  show_uvleds_top_left_1
    key: uv_top_left

  show_uvleds_top_right_1
    key: uv_top_right

  show_uvleds_mid_pop_1
    key: uv_mid_pop


State 0 - Vari-target Homing
----------------------------

Purpose:
  Return the vari-target to Position 1/home after a timed state completes.

Entry event:
  varitarget_homing

On entry:

  Set:
    glasses_current_state = 0
    glasses_homing_active = 1
    glasses_home_pulse_count = 0

  Store the current vari-target position as:
    glasses_home_start_pos

  Stop all Glasses Mode shows by key.

Homing command:

  Pulse:
    c_16_varitarget_reset

  Maximum attempts:
    10 pulses

  Stop early if:
    s_64_varitarget_position_1 becomes active and confirms as Position 1.

Homing success:

  Condition:
    s_64_varitarget_position_1 is active and Position 1 confirms.

  Post event:
    varitarget_home_success

  Set:
    glasses_homing_active = 0
    glasses_current_state = 1

  Stop all Glasses Mode shows by key.

  Move to:
    State 1 - Home / waiting

Homing failure:

  Condition:
    10 reset coil pulses have been attempted and Position 1 has not confirmed.

  Post event:
    varitarget_homing_failed

  Set:
    glasses_homing_active = 0

  Behaviour:
    Do not make any more reset attempts.
    Do not force the mode into State 1.
    Remain idle and wait for the next confirmed vari-target position caused by
    the ball hitting the vari-target.

Homing interruption:

  While glasses_homing_active = 1:

    If a vari-target position greater than glasses_home_start_pos confirms,
    treat this as the vari-target being hit deeper during homing.

  Example:

    Homing begins from Position 2.
    glasses_home_start_pos = 2.
    Position 3, 4, 5, 6, or 7 confirms during homing.

  Then:

    Post event:
      varitarget_home_interrupted

    Cancel remaining homing pulses.

    Set:
      glasses_homing_active = 0

    Enter the newly confirmed position state immediately.

Important note:

  Because confirmed positions drive the state machine, the interruption logic is
  only needed to cancel the homing command. The confirmed position event itself
  handles the move into the correct state.


State 1 - Home / Waiting
------------------------

Active condition:
  Position 1 is confirmed.

Switch:
  s_64_varitarget_position_1

Confirmed event:
  varitarget_position_1_confirmed

On entry:

  Set:
    glasses_current_state = 1
    glasses_homing_active = 0

  Stop all Glasses Mode shows by key.

Behaviour:

  No Glasses Mode shows are active.

  The mode waits for the ball to hit the vari-target.

  When any position from 2-7 confirms, immediately enter the matching state.

No 10 second state timer is used in State 1.


State 2 - Vari-target Position 2
--------------------------------

Active condition:
  Position 2 is confirmed after 1 second.

Switch:
  s_65_varitarget_position_2

Confirmed event:
  varitarget_position_2_confirmed

On entry:

  Set:
    glasses_current_state = 2

  Start a 10 second state timer.

  Start these shows:

    show_glasses_bottom_fast_1
      key: glasses_bottom_fast
      priority: 800
      LEDs:
        l_pf1_1_9
        l_pf1_1_10
        l_pf1_1_11
      Effect:
        Bright green to purple fade.
        Fast rate: approximately 0.5 seconds.

    show_uvleds_slings_1
      key: uv_slings
      priority: 800
      LEDs:
        l_pf2_1_1
        l_pf2_1_2
        l_pf2_1_3
        l_pf2_1_4
        l_pf2_1_5
        l_pf2_1_6
        l_pf2_1_7
      Colour:
        Red

While active:

  If any other vari-target position confirms, immediately move to that state.

On 10 second timer complete:

  Post event:
    varitarget_position_2_complete

  Stop all Glasses Mode shows by key.

  Move to:
    State 0 - Vari-target Homing


State 3 - Vari-target Position 3
--------------------------------

Active condition:
  Position 3 is confirmed after 1 second.

Switch:
  s_66_varitarget_position_3

Confirmed event:
  varitarget_position_3_confirmed

On entry:

  Set:
    glasses_current_state = 3

  Start a 10 second state timer.

  Start these shows:

    show_glasses_bottom_slow_1
      key: glasses_bottom_slow
      priority: 800
      LEDs:
        l_pf1_1_9
        l_pf1_1_10
        l_pf1_1_11
      Effect:
        Bright green to purple fade.
        Slow rate: approximately 1-2 seconds.

    show_glasses_mid_fast_1
      key: glasses_mid_fast
      priority: 800
      LEDs:
        l_pf1_1_12
        l_pf1_1_13
        l_pf1_1_14
      Effect:
        Bright green to purple fade.
        Fast rate: approximately 0.5 seconds.

    show_uvleds_slings_1
      key: uv_slings
      priority: 800
      LEDs:
        l_pf2_1_1
        l_pf2_1_2
        l_pf2_1_3
        l_pf2_1_4
        l_pf2_1_5
        l_pf2_1_6
        l_pf2_1_7
      Colour:
        Red

    show_uvleds_drops_1
      key: uv_drops
      priority: 800
      LEDs:
        l_pf2_1_8
        l_pf2_1_9
        l_pf2_1_10
      Colour:
        Red

While active:

  If any other vari-target position confirms, immediately move to that state.

On 10 second timer complete:

  Post event:
    varitarget_position_3_complete

  Stop all Glasses Mode shows by key.

  Move to:
    State 0 - Vari-target Homing


State 4 - Vari-target Position 4
--------------------------------

Active condition:
  Position 4 is confirmed after 1 second.

Switch:
  s_67_varitarget_position_4

Confirmed event:
  varitarget_position_4_confirmed

On entry:

  Set:
    glasses_current_state = 4

  Start a 10 second state timer.

  Start these shows:

    show_glasses_bottom_slow_1
      key: glasses_bottom_slow
      priority: 800
      LEDs:
        l_pf1_1_9
        l_pf1_1_10
        l_pf1_1_11
      Effect:
        Bright green to purple fade.
        Slow rate: approximately 1-2 seconds.

    show_glasses_mid_slow_1
      key: glasses_mid_slow
      priority: 800
      LEDs:
        l_pf1_1_12
        l_pf1_1_13
        l_pf1_1_14
      Effect:
        Bright green to purple fade.
        Slow rate: approximately 1-2 seconds.

    show_uvleds_slings_1
      key: uv_slings
      priority: 800
      LEDs:
        l_pf2_1_1
        l_pf2_1_2
        l_pf2_1_3
        l_pf2_1_4
        l_pf2_1_5
        l_pf2_1_6
        l_pf2_1_7
      Colour:
        Red

    show_uvleds_drops_1
      key: uv_drops
      priority: 800
      LEDs:
        l_pf2_1_8
        l_pf2_1_9
        l_pf2_1_10
      Colour:
        Red

    show_uvleds_pop_left_1
      key: uv_pop_left
      priority: 800
      LEDs:
        l_pf2_1_11
        l_pf2_1_12
      Colour:
        Red

While active:

  If any other vari-target position confirms, immediately move to that state.

On 10 second timer complete:

  Post event:
    varitarget_position_4_complete

  Stop all Glasses Mode shows by key.

  Move to:
    State 0 - Vari-target Homing


State 5 - Vari-target Position 5
--------------------------------

Active condition:
  Position 5 is confirmed after 1 second.

Switch:
  s_68_varitarget_position_5

Confirmed event:
  varitarget_position_5_confirmed

On entry:

  Set:
    glasses_current_state = 5

  Start a 10 second state timer.

  Start these shows:

    show_glasses_bottom_slow_1
      key: glasses_bottom_slow
      priority: 800
      LEDs:
        l_pf1_1_9
        l_pf1_1_10
        l_pf1_1_11
      Effect:
        Bright green to purple fade.
        Slow rate: approximately 1-2 seconds.

    show_glasses_mid_slow_1
      key: glasses_mid_slow
      priority: 800
      LEDs:
        l_pf1_1_12
        l_pf1_1_13
        l_pf1_1_14
      Effect:
        Bright green to purple fade.
        Slow rate: approximately 1-2 seconds.

    show_glasses_top_fast_1
      key: glasses_top_fast
      priority: 800
      LEDs:
        l_pf1_1_15
        l_pf1_1_16
        l_pf1_1_17
      Effect:
        Bright green to purple fade.
        Fast rate: approximately 0.5 seconds.

    show_uvleds_slings_1
      key: uv_slings
      priority: 800
      LEDs:
        l_pf2_1_1
        l_pf2_1_2
        l_pf2_1_3
        l_pf2_1_4
        l_pf2_1_5
        l_pf2_1_6
        l_pf2_1_7
      Colour:
        Red

    show_uvleds_drops_1
      key: uv_drops
      priority: 800
      LEDs:
        l_pf2_1_8
        l_pf2_1_9
        l_pf2_1_10
      Colour:
        Red

    show_uvleds_pop_left_1
      key: uv_pop_left
      priority: 800
      LEDs:
        l_pf2_1_11
        l_pf2_1_12
      Colour:
        Red

    show_uvleds_top_left_1
      key: uv_top_left
      priority: 800
      LEDs:
        l_pf2_1_13
        l_pf2_1_14
      Colour:
        Red

While active:

  If any other vari-target position confirms, immediately move to that state.

On 10 second timer complete:

  Post event:
    varitarget_position_5_complete

  Stop all Glasses Mode shows by key.

  Move to:
    State 0 - Vari-target Homing


State 6 - Vari-target Position 6
--------------------------------

Active condition:
  Position 6 is confirmed after 1 second.

Switch:
  s_69_varitarget_position_6

Confirmed event:
  varitarget_position_6_confirmed

On entry:

  Set:
    glasses_current_state = 6

  Start a 10 second state timer.

  Start these shows:

    show_glasses_bottom_slow_1
      key: glasses_bottom_slow
      priority: 800
      LEDs:
        l_pf1_1_9
        l_pf1_1_10
        l_pf1_1_11
      Effect:
        Bright green to purple fade.
        Slow rate: approximately 1-2 seconds.

    show_glasses_mid_slow_1
      key: glasses_mid_slow
      priority: 800
      LEDs:
        l_pf1_1_12
        l_pf1_1_13
        l_pf1_1_14
      Effect:
        Bright green to purple fade.
        Slow rate: approximately 1-2 seconds.

    show_glasses_top_slow_1
      key: glasses_top_slow
      priority: 800
      LEDs:
        l_pf1_1_15
        l_pf1_1_16
        l_pf1_1_17
      Effect:
        Bright green to purple fade.
        Slow rate: approximately 1-2 seconds.

    show_uvleds_slings_1
      key: uv_slings
      priority: 800
      LEDs:
        l_pf2_1_1
        l_pf2_1_2
        l_pf2_1_3
        l_pf2_1_4
        l_pf2_1_5
        l_pf2_1_6
        l_pf2_1_7
      Colour:
        Red

    show_uvleds_drops_1
      key: uv_drops
      priority: 800
      LEDs:
        l_pf2_1_8
        l_pf2_1_9
        l_pf2_1_10
      Colour:
        Red

    show_uvleds_pop_left_1
      key: uv_pop_left
      priority: 800
      LEDs:
        l_pf2_1_11
        l_pf2_1_12
      Colour:
        Red

    show_uvleds_top_left_1
      key: uv_top_left
      priority: 800
      LEDs:
        l_pf2_1_13
        l_pf2_1_14
      Colour:
        Red

    show_uvleds_top_right_1
      key: uv_top_right
      priority: 800
      LEDs:
        l_pf2_1_15
        l_pf2_1_16
        l_pf2_1_17
      Colour:
        Red

While active:

  If any other vari-target position confirms, immediately move to that state.

On 10 second timer complete:

  Post event:
    varitarget_position_6_complete

  Stop all Glasses Mode shows by key.

  Move to:
    State 0 - Vari-target Homing


State 7 - Vari-target Position 7
--------------------------------

Active condition:
  Position 7 is confirmed after 1 second.

Switch:
  s_70_varitarget_position_7

Confirmed event:
  varitarget_position_7_confirmed

On entry:

  Set:
    glasses_current_state = 7

  Start a 10 second state timer.

  Start these shows:

    show_glasses_all_1
      key: glasses_all
      priority: 800
      LEDs / sequence:
        l_pf1_1_9
        l_pf1_1_10
        l_pf1_1_11
        then off

        l_pf1_1_12
        l_pf1_1_13
        l_pf1_1_14
        then off

        l_pf1_1_15
        l_pf1_1_16
        l_pf1_1_17
        then off
      Effect:
        Bright green to purple fade.
        Slow rate: approximately 1-2 seconds.

    show_uvleds_slings_1
      key: uv_slings
      priority: 800
      LEDs:
        l_pf2_1_1
        l_pf2_1_2
        l_pf2_1_3
        l_pf2_1_4
        l_pf2_1_5
        l_pf2_1_6
        l_pf2_1_7
      Colour:
        Red

    show_uvleds_drops_1
      key: uv_drops
      priority: 800
      LEDs:
        l_pf2_1_8
        l_pf2_1_9
        l_pf2_1_10
      Colour:
        Red

    show_uvleds_pop_left_1
      key: uv_pop_left
      priority: 800
      LEDs:
        l_pf2_1_11
        l_pf2_1_12
      Colour:
        Red

    show_uvleds_top_left_1
      key: uv_top_left
      priority: 800
      LEDs:
        l_pf2_1_13
        l_pf2_1_14
      Colour:
        Red

    show_uvleds_top_right_1
      key: uv_top_right
      priority: 800
      LEDs:
        l_pf2_1_15
        l_pf2_1_16
        l_pf2_1_17
      Colour:
        Red

    show_uvleds_mid_pop_1
      key: uv_mid_pop
      priority: 800
      LEDs:
        l_pf2_1_18
        l_pf2_1_19
        l_pf2_1_20
        l_pf2_1_21
      Colour:
        Red

While active:

  If any other vari-target position confirms, immediately move to that state.

On 10 second timer complete:

  Post event:
    varitarget_position_7_complete

  Stop all Glasses Mode shows by key.

  Move to:
    State 0 - Vari-target Homing


State Completion Events
-----------------------

Each timed active state posts a completion event when its 10 second timer expires.

State 2 complete:
  varitarget_position_2_complete

State 3 complete:
  varitarget_position_3_complete

State 4 complete:
  varitarget_position_4_complete

State 5 complete:
  varitarget_position_5_complete

State 6 complete:
  varitarget_position_6_complete

State 7 complete:
  varitarget_position_7_complete

All completion events should:

  1. Stop all Glasses Mode shows by key.
  2. Move to State 0 - Vari-target Homing.


Mode Stop Behaviour
-------------------

When the mode stops:

  Event:
    mode_glasses_mode_stopping

Actions:

  1. Stop all Glasses Mode shows by key.
  2. Stop the position confirmation timer.
  3. Stop any active 10 second state timer.
  4. Stop the homing pulse timer.
  5. Set glasses_homing_active = 0.


Optional Standup UV Flash Add-on
--------------------------------

This was removed from the core state machine scope, but if it is added later it
must be keyed separately so it does not interfere with STARs Mode or the state
shows.

Trigger switches:
  s_40_stand_up_target_5
  s_41_stand_up_target_6

Show:
  show_uv_all_flash

Key:
  uv_all_flash_standup

Recommended priority:
  1600

Behaviour:
  Short flash only.
  Do not stop any Glasses Mode state shows.
  Do not stop any STARs Mode green target shows.


Implementation Notes
--------------------

1. The state machine should be event-driven from confirmed positions, not from a
   manually written transition table between every state.

2. The 1 second confirmation timer is essential. Do not enter states directly
   from raw vari-target switch active events.

3. Every state entry should stop all existing Glasses Mode shows before starting
   the new state's shows.

4. Every show should be started with a key.

5. State 1 is a waiting state only. It does not need a 10 second timer.

6. States 2-7 are timed states. Each runs for 10 seconds unless another position
   confirms first.

7. After States 2-7 expire, the mode attempts to home the vari-target using the
   reset coil.

8. Homing only attempts 10 reset pulses. If home is not reached, the mode waits
   for the next confirmed vari-target position.

9. If the ball hits the vari-target deeper during homing, homing is interrupted
   and the confirmed deeper state takes over.

10. show_glasses_all_1 must be included in the cleanup list using key:
    glasses_all.


End of Specification
--------------------
