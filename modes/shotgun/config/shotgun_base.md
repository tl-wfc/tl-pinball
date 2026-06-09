This is a new mode called shotgun that runs when the base mode is active
write the yaml mode file so i can add it to my MPF project

if base mode is active

if 
s_62_top_lane_a
is activated it charges up the shotgun and starts a 30 second timer counting down (top_lane_a_countdown_timer)
while the timer is inbetween 20-30 seconds
leds 
l_pf1_2_31 is lit bright green
l_pf1_2_30
l_pf1_2_29
are all lit bright green
while the timer is inbetween 10-19 seconds
leds 
l_pf1_2_31 is off
l_pf1_2_30 is lit bright green and flashing a 2hz
l_pf1_2_29 is lit bright green and flashing a 2hz
while the timer is inbetween 1-9 seconds
leds 
l_pf1_2_31 is off
l_pf1_2_30 is off
l_pf1_2_29 is lit bright green and flashing a 6hz
once the timer gets to 0 seconds the countdown timer stops and
leds 
l_pf1_2_31 is off
l_pf1_2_30 is off
l_pf1_2_29 is off

if 
s_62_top_lane_a
is re-triggered at any time while top_lane_a_countdown timer is active, then it will reset the countdown timer and it will start counting down from 30 seconds again and the lights will follow the rules set above

at the same time

if 
s_61_top_lane_b
is activated it charges up the shotgun and starts a 30 second timer counting down (top_lane_b_countdown_timer)
while the timer is inbetween 20-30 seconds
leds 
l_pf1_2_24 is lit bright green
l_pf1_2_25
l_pf1_2_26
are all lit bright green
# while the timer is inbetween 10-19 seconds
leds 
l_pf1_2_24 is off
l_pf1_2_25 is lit bright green and flashing a 2hz
l_pf1_2_26 is lit bright green and flashing a 2hz
# while the timer is inbetween 1-9 seconds
leds 
l_pf1_2_24 is off
l_pf1_2_25 is off
l_pf1_2_26 is lit bright green and flashing a 6hz
# once the timer gets to 0 seconds the countdown timer stops and
leds 
l_pf1_2_24 is off
l_pf1_2_25 is off
l_pf1_2_26 is off

if 
s_61_top_lane_b
is re-triggered at any time while top_lane_a_countdown timer is active, then it will reset the countdown timer and it will start counting down from 30 seconds again and the lights will follow the rules set above

WHEN
both 
top_lane_a_countdown_timer is counting down (between 1 and 30 seconds)
AND
top_lane_b_countdown_timer is counting down (between 1 and 30 seconds)
this qualifys shotgun mode

once it is qualified setup shotgun mode by 
trigger 
c_40_fourbank_drop_reset:
confirm it is reset by
s_73_fourbank_drop_1 = inactive
s_74_fourbank_drop_2 = inactive
s_75_fourbank_drop_3 = inactive
s_76_fourbank_drop_4 = inactive
(if it doesnt achieve this after 3 attempts move forward)

then trigger
c_33_fourbank_drop_1_trip:
c_34_fourbank_drop_2_trip:
c_35_fourbank_drop_3_trip:


once this is done
while both timers are still active
if s_76_fourbank_drop_4 is triggered
award 500,000 points
stop both countdown timers and reset them awaiting for a new activation
turn on
l_pf1_2_28 bright red with a breathing pulse

if both timers reach zero and if s_76_fourbank_drop_4 = inactive
then
trigger
c_36_fourbank_drop_4_trip:
and the mode is ended awaiting to be qualified again
