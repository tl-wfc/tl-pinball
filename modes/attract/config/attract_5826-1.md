#config_version=6
# modes/attract/config/attract.yaml

mode_settings:
  selectable_items:
    - title
    - title2
  next_item_events: s_16_right_flipper_active, timer_attract_carousel_timer_complete
  previous_item_events: s_08_left_flipper_active

slide_player:
  mode_attract_started:
    attract:
      priority: 200




event_player:
  mode_attract_started:
    - start_mode_attract_scores
    - start_mode_attract_credits
    - attract_backglass_cycle_start
    #- attract_music_start
    # - play_directional_attract_audio

  mode_attract_will_stop:
    - stop_mode_attract_scores
    - stop_mode_attract_credits
    - attract_music_stop
    - stop_directional_audio

  timer_backglass_cycle_restart_delay_complete:
    - attract_backglass_cycle_start
  
  attract_step_audio_1:
    - set_directional_volume_15
    - start_directional_track_1_delay

  set_directional_volume_15:
    audio_command:
      command: 245

  # Command 0 = pause/stop
  # Command 1-239 = play matching track"
  # Command 240 = volume 5
  # Command 241 = volume 10
  # Command 242 = volume 15
  # Command 243 = volume 20
  # Command 244 = volume 25
  # Command 245 = volume 30
  # Command 246-255 = reserved



  timer_directional_track_1_delay_complete:
    - play_directional_attract_audio
    - attract_step_2

  play_directional_attract_audio:
    audio_command:
      command: 1

  attract_step_audio_2:
    - play_directional_track_2
    - attract_step_8

  play_directional_track_2:
    audio_command:
      command: 2

  stop_directional_audio:
    audio_command:
      command: 0

  # timer_attract_music_on_timer_complete:
  #   - attract_music_stop

  s_08_left_flipper_active: attract_music_start
  s_16_right_flipper_active: attract_music_start

show_player:

  # ==========================================================
  # PERMANENT BACKGLASS WHITE BASE LAYER
  # ==========================================================
  #
  # Priority 50 keeps the entire backglass white.
  # Individual backglass shows use priority 500 and temporarily
  # replace white only on the LEDs used by those shows.
  #
  # When an individual show finishes, its LEDs automatically
  # return to the white layer underneath.
  # ==========================================================

  mode_attract_started:
    show_backglass_all_white:
      key: backglass_white_base
      loops: -1
      priority: 50


  # ==========================================================
  # BACKGLASS INDIVIDUAL SHOW SEQUENCE
  # ==========================================================

  attract_backglass_cycle_start:
    show_backglass_portal:
      key: backglass_feature_show
      loops: 10
      speed: 1.0
      priority: 500
      events_when_completed: attract_backglass_helicopter_rotor


  attract_backglass_helicopter_rotor:
    show_backglass_helicopter_rotor:
      key: backglass_feature_show
      loops: 5
      speed: 1.0
      priority: 500
      events_when_completed: attract_backglass_small_searchlight


  attract_backglass_small_searchlight:
    show_backglass_small_helicopter_searchlight:
      key: backglass_feature_show
      loops: 2
      speed: 1.0
      priority: 500
      events_when_completed: attract_backglass_left_searchlight


  attract_backglass_left_searchlight:
    show_backglass_left_helicopter_searchlight:
      key: backglass_feature_show
      loops: 2
      speed: 1.0
      priority: 500
      events_when_completed: attract_backglass_title


  attract_backglass_title:
    show_backglass_they_live_title:
      key: backglass_feature_show
      loops: 2
      speed: 1.0
      priority: 500
      events_when_completed: attract_backglass_main_alien


  attract_backglass_main_alien:
    show_backglass_main_alien_head:
      key: backglass_feature_show
      loops: 4
      speed: 1.0
      priority: 500
      events_when_completed: attract_backglass_police_alien


  attract_backglass_police_alien:
    show_backglass_alien_police_head:
      key: backglass_feature_show
      loops: 4
      speed: 1.0
      priority: 500
      events_when_completed: attract_backglass_broken_buzz


  attract_backglass_broken_buzz:
    show_backglass_they_live_broken_buzz:
      key: backglass_feature_show
      loops: 5
      speed: 1.0
      priority: 500
      events_when_completed: attract_backglass_watch


  attract_backglass_watch:
    show_backglass_watch_transporter_open:
      key: backglass_feature_show
      loops: 3
      speed: 1.0
      priority: 500
      events_when_completed: attract_backglass_signs


  attract_backglass_signs:
    show_backglass_subliminal_signs:
      key: backglass_feature_show
      loops: 4
      speed: 1.0
      priority: 500
      events_when_completed: attract_backglass_guns


  attract_backglass_guns:
    show_backglass_dual_machine_guns:
      key: backglass_feature_show
      loops: 15
      speed: 1.0
      priority: 500
      events_when_completed:
        - attract_step_audio_1
        - attract_backglass_cycle_restart_delay


  attract_step_2:
    show_tv_staticbreath_1:
      loops: 5
      priority: 100

    show_tv_staticfast_1:
      loops: 5
      priority: 100

    show_reel_1:
      loops: 5
      speed: 1.0
      priority: 200

    show_fig8_attract_2:
      loops: 5
      speed: 1.0
      priority: 200
      events_when_completed: attract_step_3
  
  attract_step_3:
    rainbow_pops_1:
      loops: 3
      speed: 2
      priority: 300
      events_when_completed: attract_step_4

  attract_step_4:
    show_modeinserts_sweep_green_1:
      loops: 2
      priority: 600
      speed: 2
      events_when_completed: attract_step_5
  
  attract_step_5:
    show_multi_attract_1:
      loops: 0
      priority: 500
      events_when_completed: attract_step_6

  attract_step_6:
    show_vari_red_1:
      loops: 0
      priority: 700
      events_when_completed: attract_step_7


  attract_step_7:
    show_shotgun_attract_1:
      loops: 0
      speed: 1.0
      priority: 900

    show_inlaneinserts_attract_1:
      loops: 0
      speed: 2.0
      priority: 910
      events_when_completed: attract_step_audio_2
  
  attract_step_8:
    show_uv_swipe_1:
      loops: 4
      speed: 1.0
      events_when_completed: attract_step_9


  attract_step_9:
    show_leftramp_attract_1:
      loops: 0
      speed: 1.0
      priority: 800

    show_tiltwarnings_attract_1:
      loops: 0
      speed: 5.0
      priority: 910
      events_when_completed: attract_step_10

  attract_step_10:
    show_gi_attract_1:
      loops: 0
      speed: 1.0

    show_light_bar_attract_1:
      loops: 0
      speed: 1.0
      events_when_completed: attract_step_11

  attract_step_11:
    show_rainbow_spin_1:
      loops: 0
      speed: 1.0
      events_when_completed: attract_step_12
      
  attract_step_12:
    show_uv_swipe_1:
      loops: 0
      speed: 1.0
      events_when_completed: attract_step_13

  attract_step_13:
    show_uv_searchlight_1:
      loops: 0
      speed: 1.0
      events_when_completed: attract_step_14

  attract_step_14:
    show_tv_staticbreath_1:
      loops: 5
      priority: 100
    
    show_tv_staticfast_1:
      loops: 5
      priority: 100

    show_reel_1:
      loops: 5
      speed: 1.0
      priority: 200
    
    show_fig8_attract_2:
      loops: 5
      speed: 1.0
      priority: 200
  
    rainbow_pops_1:
      loops: 3
      speed: 2
      priority: 300

    show_modeinserts_sweep_green_1:
      loops: 2
      priority: 600
      speed: 2
  
    show_multi_attract_1:
      loops: 0
      priority: 500

    show_vari_red_1:
      loops: 0
      priority: 700

    show_shotgun_attract_1:
      loops: 0
      speed: 1.0
      priority: 900

    show_inlaneinserts_attract_1:
      loops: 0
      speed: 2.0
      priority: 910

    show_leftramp_attract_1:
      loops: 0
      speed: 1.0
      priority: 800

    show_tiltwarnings_attract_1:
      loops: 0
      speed: 5.0
      priority: 910

    show_gi_attract_1:
      loops: 0
      speed: 1.0

    show_light_bar_attract_1:
      loops: 0
      speed: 1.0

    show_rainbow_spin_1:
      loops: 0
      speed: 1.0
      events_when_completed: attract_step_15
      
  attract_step_15:
    show_uv_searchlight_1:
      loops: 0
      speed: 1.0
      events_when_completed: attract_step_2

  # attract_step_17:
  #   speaker_test_1:
  #     loops: -1
  #     speed: 1.0
  #     events_when_completed: attract_step_3

sounds:
  tl-m-Hysteria-smallintro:
    simultaneous_limit: 1
    stealing_method: skip

sound_player:
  attract_music_start:
    tl-m-Hysteria-smallintro:
      action: play
      bus: music
      loops: 3
      fade_in: 2s

  attract_music_stop:
    tl-m-Hysteria-smallintro:
      action: stop
      fade_out: 5s

timers:
  backglass_cycle_restart_delay:
    start_value: 0
    end_value: 2
    direction: up
    tick_interval: 1s
    start_running: false
    control_events:
      - event: attract_backglass_cycle_restart_delay
        action: restart
      - event: mode_attract_will_stop
        action: stop

  directional_track_1_delay:
    start_value: 0
    end_value: 1
    direction: up
    tick_interval: 100ms
    start_running: false
    control_events:
      - event: start_directional_track_1_delay
        action: restart

  attract_carousel_timer:
    end_value: 1
    tick_interval: 5s
    start_running: true
    control_events:
      - event: timer_attract_carousel_timer_complete
        action: restart
      - event: s_16_right_flipper_active
        action: restart
      - event: s_08_left_flipper_active
        action: restart
      - event: flipper_cradle
        action: stop
      - event: flipper_cradle_release
        action: restart

  # attract_music_on_timer:
  #   start_value: 10   # change to 180 once tested
  #   end_value: 0
  #   direction: down
  #   tick_interval: 1s
  #   start_running: false
  #   control_events:
  #     - event: attract_music_start
  #       action: restart
  #     - event: attract_music_stop
  #       action: stop
  #     - event: mode_attract_will_stop
  #       action: stop