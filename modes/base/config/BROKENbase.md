#config_version=6
# modes/base/config/base.yaml

mode:
  start_events: ball_starting
  stop_events: ball_will_end
  priority: 100

config:
  - base_points.yaml
  - varitarget.yaml
  - shots.yaml
  #- shot_groups.yaml
  #- shot_profiles.yaml
  #- consume_qualify.yaml

event_player:
  mode_base_started: BASE_YAML_LOADED

  s_03_service_enter_active: end_game

  manual_ball_search_requested:
    - start_manual_ball_search

variable_player:
  mode_base_started:
    pf_multiplier:
      action: set
      int: 1

slide_player:
  mode_base_started: 
    base_slide:
      priority: 5

  ball_will_end:
    base_slide:
      action: remove

sound_player:

  spinner_left_hit:
    spinner:
      bus: effects
      max_queue_time: 5ms

  spinner_right_hit:
    spinner:
      bus: effects
      max_queue_time: 40ms

  # -----------------------------------
  # BALL 1 BACKGROUND MUSIC
  # -----------------------------------

  ball_started{current_player.ball==1}:
    tl_m_hysteria_fullsong:
      bus: music
      loops: -1
      key: ball_background_music

  # -----------------------------------
  # BALL 2 BACKGROUND MUSIC
  # Replace later
  # -----------------------------------

  ball_started{current_player.ball==2}:
    tl_m_hysteria_fullsong:
      bus: music
      loops: -1
      key: ball_background_music

  # -----------------------------------
  # BALL 3 BACKGROUND MUSIC
  # Replace later
  # -----------------------------------

  ball_started{current_player.ball==3}:
    tl_m_hysteria_fullsong:
      bus: music
      loops: -1
      key: ball_background_music

  # -----------------------------------
  # STOP MUSIC
  # -----------------------------------

  ball_will_end:
    ball_background_music:
      action: stop

show_player:

  # -----------------------------------
  # POP BUMPERS
  # -----------------------------------

  s_58_pop_bumper_left_active:
    show_pop_bumper_left_hit_1:
      loops: 1
      speed: 1.0
      priority: 500

  s_57_pop_bumper_center_active:
    show_pop_bumper_center_hit_1:
      loops: 1
      speed: 1.0
      priority: 500

  s_56_pop_bumper_right_active:
    show_pop_bumper_right_hit_1:
      loops: 1
      speed: 1.0
      priority: 500

  # -----------------------------------
  # SPINNERS
  # -----------------------------------

  spinner_left_hit:
    show_left_spinner_white_strobe_1:
      loops: 1
      speed: 1.0
      priority: 500

  spinner_right_hit:
    show_right_spinner_white_strobe_1:
      loops: 1
      speed: 1.0
      priority: 500

  # -----------------------------------
  # BALL 1 BACKGROUND SHOWS
  # -----------------------------------

  ball_started{current_player.ball==1}:
    show_muse_hysteria_radio_full:
      loops: 0
      speed: 1.0
      priority: 10
      key: ball_background_lights

    show_floods_hysteria_bassline_1:
      loops: 0
      speed: 1.0
      priority: 200
      key: ball_cab_background

  # -----------------------------------
  # BALL 2 BACKGROUND SHOWS
  # Replace later
  # -----------------------------------

  ball_started{current_player.ball==2}:
    show_muse_hysteria_radio_full:
      loops: 0
      speed: 1.0
      priority: 10
      key: ball_background_lights

    show_floods_hysteria_bassline_1:
      loops: 0
      speed: 1.0
      priority: 200
      key: ball_cab_background

  # -----------------------------------
  # BALL 3 BACKGROUND SHOWS
  # Replace later
  # -----------------------------------

  ball_started{current_player.ball==3}:
    show_muse_hysteria_radio_full:
      loops: 0
      speed: 1.0
      priority: 10
      key: ball_background_lights

    show_floods_hysteria_bassline_1:
      loops: 0
      speed: 1.0
      priority: 200
      key: ball_cab_background

  # -----------------------------------
  # STOP BACKGROUND SHOWS
  # -----------------------------------

  ball_will_end:
    ball_background_lights:
      action: stop

    ball_cab_background:
      action: stop

combo_switches:
  cab_arrows_ball_search:
    switches_1: s_19_cab_arrow_left
    switches_2: s_20_cab_arrow_right
    hold_time: 5s
    events_when_both: manual_ball_search_requested