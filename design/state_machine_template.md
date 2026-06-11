state machine template
mode_name: my_mode_name

purpose:
  description: >
    What the mode is meant to do in plain English.

start_conditions:
  mode_starts_when:
    - event_or_switch: 
    - condition: 
  mode_should_not_start_if:
    - 

stop_conditions:
  mode_ends_when:
    - 
  mode_fails_when:
    - 
  mode_succeeds_when:
    - 

state_machine:
  initial_state: state_1

  states:

    state_1:
      description: >
        What the player needs to do in this state.

      on_enter:
        events_posted:
          - 
        lights:
          - 
        shows:
          - show_name:
              action: play
              loops: -1
              speed: 1.0

      active_shots:
        - shot_name:
            switch: 
            success_event: 
            fail_event: 

      transitions:
        - when: 
          go_to_state: state_2
        - when:
          go_to_state: failed

      timeout:
        enabled: false
        duration: 10s
        on_timeout_go_to: failed

      scoring:
        on_success: 10000
        on_fail: 0

    state_2:
      description: >
        Next step in the mode.

      on_enter:
        events_posted:
          - 
        shows:
          - 

      active_shots:
        - shot_name:
            switch:
            success_event:
            fail_event:

      transitions:
        - when:
          go_to_state: completed

    completed:
      description: Mode completed successfully.
      on_enter:
        events_posted:
          - my_mode_completed
        shows:
          - success_show
        scoring:
          points: 50000

    failed:
      description: Mode failed.
      on_enter:
        events_posted:
          - my_mode_failed
        shows:
          - fail_show
        scoring:
          points: 0

shots:
  shot_1:
    switch:
    light:
    show_when_lit:
    show_when_hit:

  shot_2:
    switch:
    light:
    show_when_lit:
    show_when_hit:

timers:
  main_timer:
    duration:
    starts_when:
    stops_when:
    timeout_event:

variables:
  player_variables:
    - name:
      start_value:
      used_for:

  mode_variables:
    - name:
      start_value:
      used_for:

scoring:
  base_hit:
  state_complete:
  mode_complete:
  mode_failed:

lights_and_shows:
  mode_active_show:
  state_1_show:
  state_2_show:
  success_show:
  fail_show:

sounds_or_godot_events:
  on_mode_start:
  on_state_change:
  on_success:
  on_fail:
  on_timeout:

notes:
  - Any special rules, lockouts, exceptions, or weird behaviour.

###################################################################
worked example
###################################################################


  mode_name: shotgun_mode

state_machine:
  initial_state: stage_1

  states:
    stage_1:
      description: Hit left target first.
      active_shots:
        - left_target:
            switch: s_83_standup_target
            success_event: shotgun_stage_1_success
        - right_target:
            switch: s_86_standup_target
            fail_event: shotgun_stage_1_failed

      transitions:
        - when: shotgun_stage_1_success
          go_to_state: stage_2
        - when: shotgun_stage_1_failed
          go_to_state: failed

    stage_2:
      description: Hit right target second.
      active_shots:
        - right_target:
            switch: s_86_standup_target
            success_event: shotgun_stage_2_success
        - left_target:
            switch: s_83_standup_target
            fail_event: shotgun_stage_2_failed

      transitions:
        - when: shotgun_stage_2_success
          go_to_state: completed
        - when: shotgun_stage_2_failed
          go_to_state: failed