#####################################################################################################################################
INSTRUCTION CARD

SHOTGUN
Charge the shotgun by shooting BOTH TOP LANES.
ALIEN 1 Expose the alien.Shoot the final target.500,000
ALIEN 2 The alien adapts.Expose it twice.500,000 + 2,000,000
ALIEN 3 THEY LIVE.
Only targets 1, 4 & 7 remain.Drop all three before time expires.
Avoid the BLUE STANDUP TARGETS.
10,000,000

OBEY? NO.DESTROY THEM ALL.


SHOTGUN
Shoot BOTH TOP LANES to charge the shotgun.
The lit timer begins counting down. Shoot both lanes before either timer expires to arm the shotgun.
ALIEN 1
Hit the lone standing target before time runs out.
500,000

ALIEN 2
Hit the lone standing target.
BANK RESETS!
Hit it again before time runs out.
500,000 + 2,000,000

ALIEN 3
Only targets 1, 4 & 7 remain standing.
Drop all three before time expires.
Avoid the warning targets!
10,000,000

Complete ALIEN 3 to reset the invasion and start again.





#####################################################################################################################################
LIGHTSHOW / CALL-OUT TRIGGERS

These are the highest-value events to attach shows to:

shotgun_qualified

alien_first_started
alien_second_started
alien_third_started

fourbank_reset_request
fourbank_reset_confirmed
fourbank_reset_failed

threebank_reset_request
threebank_reset_confirmed
threebank_reset_failed

fourbank_drop_4_only

drop_1_4_7_active

shotgun_mode_active_started

alien_first_hit

alien_second_part1_hit
alien_second_final_hit

alien_third_active
alien_third_achieved
alien_third_failed

shotgun_failed

shotgun_sequence_reset
shotgun_overall_reset




#####################################################################################################################################
SHOTGUN MASTER STATE MACHINE
shotgun_lane_a_charged
shotgun_lane_b_charged
↓ BOTH ACTIVE
shotgun_qualified

STAGE 1 - ALIEN FIRST
Entry Condition
alien_first_achieved = FALSE
Sequence
shotgun_qualified
↓
alien_first_started
↓
fourbank_reset_attempts_clear
↓
fourbank_reset_request
↓
fourbank_reset_requested
↓
fourbank_reset_confirmed
   OR
fourbank_reset_failed
Retry loop:
fourbank_reset_failed
↓
fourbank_reset_retry_timer
↓
fourbank_reset_request
(max 3 attempts)
Prepare Playfield
fourbank_reset_confirmed
↓
fourbank_drop_4_only
↓
fourbank_drop_1_tripped
↓
fourbank_drop_2_tripped
↓
fourbank_drop_3_tripped
↓
threebank_drop_1_tripped
↓
threebank_drop_2_tripped
↓
threebank_drop_3_tripped
Active Shotgun Window
shotgun_mode_active_started
↓
shotgun_mode_active = TRUE
Success
s_76_fourbank_drop_4_active
↓
alien_first_hit
↓
500,000 points
↓
alien_first_achieved
↓
l_pf1_2_28 breathing red
↓
shotgun_sequence_reset
Failure
top_lane_a_countdown_timer = 0
AND
top_lane_b_countdown_timer = 0
↓
shotgun_failed
↓
shotgun_sequence_reset


STAGE 2 - ALIEN SECOND
Entry Condition
alien_first_achieved = TRUE
alien_second_achieved = FALSE
Sequence
shotgun_qualified
↓
alien_second_started
↓
fourbank_reset_attempts_clear
↓
fourbank_reset_request
↓
fourbank_reset_confirmed
↓
fourbank_drop_4_only
↓
shotgun_mode_active_started

PART 1
shotgun_mode_active
↓
s_76_fourbank_drop_4_active
↓
alien_second_part1_hit
↓
500,000 points
↓
alien_second_achieved_part1
↓
fourbank_reset_attempts_clear
↓
fourbank_reset_request
Rebuild
fourbank_reset_confirmed
↓
fourbank_drop_4_only
↓
shotgun_mode_active_started


PART 2
shotgun_mode_active
↓
s_76_fourbank_drop_4_active
↓
alien_second_final_hit
↓
2,000,000 points
↓
alien_second_achieved
↓
l_pf1_2_27 breathing red
↓
shotgun_sequence_reset


STAGE 3 - ALIEN THIRD
Entry Condition
alien_first_achieved = TRUE
alien_second_achieved = TRUE
alien_third_achieved = FALSE
Startup
shotgun_qualified
↓
alien_third_started
Reset Both Banks
fourbank_reset_attempts_clear
↓
threebank_reset_attempts_clear
↓
fourbank_reset_request
↓
threebank_reset_request
Fourbank Reset Path
fourbank_reset_request
↓
fourbank_reset_requested
↓
fourbank_reset_confirmed
or
fourbank_reset_failed
↓
retry
↓
fourbank_reset_request
Threebank Reset Path
threebank_reset_request
↓
threebank_reset_requested
↓
threebank_reset_confirmed
or
threebank_reset_failed
↓
retry
↓
threebank_reset_request
Both Banks Ready
fourbank_reset_confirmed
AND
threebank_reset_confirmed
↓
drop_1_4_7_active
Build 1 / 4 / 7 Pattern
Drop:
c_34_fourbank_drop_2_trip
↓
c_35_fourbank_drop_3_trip
↓
c_37_threebank_drop_1_trip
↓
c_38_threebank_drop_2_trip

Leaving:
Target 1 standing
Target 4 standing
Target 7 standing
Stage 3 Active
drop_1_4_7_active
↓
alien_third_active
At this point:
top lane A timer reset to 30
top lane B timer reset to 30
lane retriggers disabled
STAGE 3 SUCCESS
s_73_fourbank_drop_1_active
AND
s_76_fourbank_drop_4_active
AND
s_79_threebank_drop_3_active
↓
alien_third_achieved
Award
10,000,000 points
↓
alien_third_achieved
↓
shotgun_drop_all_targets
↓
shotgun_overall_reset
STAGE 3 FAILURE
Any of:
s_83_standup_target_active
OR
s_86_standup_target_active
OR
both countdown timers expire
↓
alien_third_failed
↓
shotgun_drop_all_targets
↓
shotgun_overall_reset











