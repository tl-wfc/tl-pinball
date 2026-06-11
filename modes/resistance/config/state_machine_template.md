state machine template
mode_name: resistance

purpose:
  description: >
    this is a mini mode like shotgun mode that is activated from the base mode

start_conditions:
  mode_starts_when:
    - ball started

  mode_should_not_start_if:
    - Future full modes are running (CONSUME, OBEY, CONFORM, FOR YOUR SAFETY) not written yet

Mode Qualification conditions



stop_conditions:
  mode_ends_when:
    - ball is ending
  mode_fails_when:
    - 
  mode_succeeds_when:
    - 

state_machine:
  initial_state: state_1

  states:

    state_1:
      description: state_1_resistance_qualification_part_1
        
        s_32_right_inlane is hit
        

      on_enter:
        events_posted:
         Confirm all previous states in the state machine are reset so it is ready to progress through the states
          set event: resistance_qualification_failed = false
          post event: resistance_qualification_started = true
          post event: right_inlane_countdown_timer_started = true
          and start
          right_inlane_countdown_timer
          counting down from 15 seconds
         
           while 
           right_inlane_countdown_timer 
           is counting down
           IF 
           s_32_right_inlane 
           is hit 
           post event 
           right_inlane_countdown_timer_reset
           and 
           right_inlane_countdown_timer restarts counting down from 15 seconds.

          

        lights:
          - while right_inlane_countdown_timer is == 11-15 seconds
          - lights
          - l_pf1_1_5 is solid amber
          - l_pf1_1_4 is solid amber
          - l_pf1_1_3 is solid amber
          - l_pf1_1_21 is flashing 12hz amber
          - l_pf1_1_22 is flashing 12hz amber
          - l_pf1_1_6 is flashing 12hz amber
          - l_pf1_1_7 is flashing 12hz amber
          - l_pf1_1_8 is flashing 12hz amber
          
          - while right_inlane_countdown_timer is == 5-10.9 seconds
          - lights
          - l_pf1_1_5 is OFF (but allow other light shows)
          - l_pf1_1_4 is flashing 2hz amber
          - l_pf1_1_3 is flashing 2hz amber
          - l_pf1_1_21 is flashing 12hz amber
          - l_pf1_1_22 is flashing 12hz amber
          - l_pf1_1_6 is flashing 12hz amber
          - l_pf1_1_7 is flashing 12hz amber
          - l_pf1_1_8 is flashing 12hz amber
          
          - while right_inlane_countdown_timer is == 0.1-4.9 seconds
          - lights
          - l_pf1_1_5 is OFF (but allow other light shows)
          - l_pf1_1_4 is OFF (but allow other light shows)
          - l_pf1_1_3 is flashing 6hz amber
          - l_pf1_1_21 is flashing 12hz amber
          - l_pf1_1_22 is flashing 12hz amber
          - l_pf1_1_6 is flashing 12hz amber
          - l_pf1_1_7 is flashing 12hz amber
          - l_pf1_1_8 is flashing 12hz amber

          - when right_inlane_countdown_timer is == 0 seconds
          - lights
          - l_pf1_1_5 is OFF (but allow other light shows)
          - l_pf1_1_4 is OFF (but allow other light shows)
          - l_pf1_1_3 is OFF (but allow other light shows)
          - l_pf1_1_21 is OFF (but allow other light shows)
          - l_pf1_1_22 is OFF (but allow other light shows)
transitions:
        - when: 
        right_inlane_countdown_timer > 0 seconds
        AND
        switches
          - S_40_stand_up_target_5 is hit
          OR
          - S_41_stand_up_target_6 is hit
          post event: resistance_qualification_complete = true
          set event: resistance_qualification_started = false
          go_to_state: state_2_resistance_qualified


      timeout:
      if 
          right_inlane_countdown_timer == 0
          post event: right_inlane_countdown_timer_expired 
          post event: resistance_qualification_failed = true
          and go bcak to waiting for the start of State 1

      scoring:
        on_success: 100000
        on_fail: 0

    state_2: title - state_2_resistance_active_pt1
      description: >
        state_2_resistance_active_timer starts counting down from 45 seconds
        during this time
        must get 1 hit of
        s_60_top_lane_c
        before state_2_resistance_active_timer expires
        if state_2_resistance_active_timer expires go back to stage 1


      on_enter:
          post event: state_2_resistance_active_pt1 = true
          set event: resistance_qualification_complete = false
          post event: state_2_resistance_active_timer_started
        shows:
          - lights
          - l_pf1_1_6 is fading in and out slowly, amber
          - l_pf1_1_7 is fading in and out slowly, amber
          - l_pf1_1_8 is fading in and out slowly, amber
          - l_pf1_1_5 is fading in and out slowly, amber
          - l_pf1_1_4 is fading in and out slowly, amber
          - l_pf1_1_3 is fading in and out slowly, amber


      transitions:
        - when:
          state_2_resistance_active_timer > 0 seconds
          and
          s_60_top_lane_c = hit
          post event: state_2_resistance_active_pt1_complete = true
        
        transition to 
          state_3: state_3_resistance_active_pt2
    
        else if state_2_resistance_active_timer == 0 seconds
            go back to the entry condition of state 1
          post event: state_2_resistance_active_pt1_failed = true
          set event: state_2_resistance_active_pt1 = false

        
        
         scoring:
        on_success: 300000
        on_fail: 0 
    
    state_3: title - state_3_resistance_active_pt2
      description: >
        state_3_resistance_active_timer starts counting down from 30 seconds
        during this time
        must get 1 hit of
        s_60_top_lane_c
        before state_3_resistance_active_timer expires
        if state_3_resistance_active_timer expires go back to stage 1

      on_enter:
        events_posted:
          post event: state_3_resistance_active_pt2 = true
          post event: state_3_resistance_active_timer_started
          set event: state_2_resistance_active_pt1_complete = false
          - 
        shows:
          - lights
          - l_pf1_1_6 is fading in and out slowly, amber
          - l_pf1_1_7 is fading in and out slowly, amber
          - l_pf1_1_8 is fading in and out slowly, amber
          - l_pf1_1_5 is fading in and out slowly, amber
          - l_pf1_1_4 is fading in and out slowly, amber
          - l_pf1_1_3 is fading in and out slowly, amber
          - l_pf1_2_1 is solid BLUE
          - l_pf1_2_2 is solid BLUE
          - l_pf1_2_3 is solid BLUE
      
      transitions:
        - when:
          state_3_resistance_active_timer > 0 seconds
          and
          s_60_top_lane_c = hit
          post event: state_3_resistance_active_pt2_complete = true

        transition to 
          state_4: state_4_resistance_active_pt3
    
        else if state_3_resistance_active_timer == 0 seconds
          go back to the entry condition of state 1
          post event: state_3_resistance_active_pt2_failed = true
          set event: state_3_resistance_active_pt2 = false

         scoring:
        on_success: 10000000
        on_fail: 0 


    state_4: title - state_4_resistance_active_pt3
      description: >
        state_4_resistance_active_timer starts counting down from 20 seconds
        during this time
        must get 1 hit of
        s_60_top_lane_c
        before state_4_resistance_active_timer expires
        if state_4_resistance_active_timer expires go back to stage 1

      on_enter:
        events_posted:
          post event: state_4_resistance_active_pt3 = true
          post event: state_4_resistance_active_timer_started
          set event: state_3_resistance_active_pt2_complete = false
        shows:
          - lights
          - l_pf1_1_6 is fading in and out slowly, amber
          - l_pf1_1_7 is fading in and out slowly, amber
          - l_pf1_1_8 is fading in and out slowly, amber
          - l_pf1_1_5 is fading in and out slowly, amber
          - l_pf1_1_4 is fading in and out slowly, amber
          - l_pf1_1_3 is fading in and out slowly, amber
          - l_pf1_2_1 is solid BLUE
          - l_pf1_2_2 is solid BLUE
          - l_pf1_2_3 is solid BLUE
          - l_pf1_2_6 is solid BLUE
          - l_pf1_2_5 is solid BLUE
          - l_pf1_2_4 is solid BLUE
      
      transitions:
        - when:
          state_4_resistance_active_timer > 0 seconds
          and
          s_60_top_lane_c = hit
          post event: state_4_resistance_active_pt3_complete = true
        transition to 
          state_5: state_5_resistance_active_pt4
    
        else if state_4_resistance_active_timer == 0 seconds
            go back to the entry condition of state 1
          post event: state_4_resistance_active_pt3_failed = true
          set event: state_4_resistance_active_pt3 = false
         
         
         scoring:
        on_success: 25000000
        on_fail: 0 

    state_5: title - state_5_resistance_active_pt4
      description: >
        state_5_resistance_active_timer starts counting down from 20 seconds
        during this time
        reset single drop
        flash 
        l_pf1_5_22 fast blue
        l_pf1_5_23 fast blue
        l_pf1_5_24 fast blue
        must hit
        s_72_single_drop_1
        then
        s_81_saucer_left
        before state_5_resistance_active_timer expires
        if state_5_resistance_active_timer expires go back to stage 1

      on_enter:
        events_posted:
          post event: state_5_resistance_active_pt4 = true
          post event: state_5_resistance_active_timer_started
          set event: state_4_resistance_active_pt3_complete = false


          - 
          - pulse coil
          c_31_single_drop_1_reset
              confirm that s_72_single_drop_1 = inactive
                 if s_72_single_drop_1 is active, repeate 3 times then move forward

        shows:
          - lights
          - l_pf1_1_6 is fading in and out slowly, amber
          - l_pf1_1_7 is fading in and out slowly, amber
          - l_pf1_1_8 is fading in and out slowly, amber
          - l_pf1_1_5 is fading in and out slowly, amber
          - l_pf1_1_4 is fading in and out slowly, amber
          - l_pf1_1_3 is fading in and out slowly, amber
          - l_pf1_2_1 is solid BLUE
          - l_pf1_2_2 is solid BLUE
          - l_pf1_2_3 is solid BLUE
          - l_pf1_2_6 is solid BLUE
          - l_pf1_2_5 is solid BLUE
          - l_pf1_2_4 is solid BLUE
          - l_pf1_2_7 is solid BLUE
          - l_pf1_2_8 is solid BLUE
          - l_pf1_2_9 is solid BLUE
          - l_pf1_5_22 flashing 12hz blue
          - l_pf1_5_23 flashing 12hz blue
          - l_pf1_5_24 flashing 12hz blue
      
      transitions:
        - when:
          state_5_resistance_active_timer > 0 seconds
          and
          s_72_single_drop_1 = hit
          then
          while
          state_5_resistance_active_timer > 0 seconds
          s_81_saucer_left = hit

          post event: state_5_resistance_complete
          award 
          50,000,000 points 
          and 
          reset state machine back to the entry condition of condition 1
        
        else if state_5_resistance_active_timer == 0 seconds
          post event: state_5_resistance_failed
          and
          go back to the entry condition of state 1