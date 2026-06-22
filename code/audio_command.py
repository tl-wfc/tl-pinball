from mpf.core.custom_code import CustomCode


class AudioCommand(CustomCode):

    BIT_LIGHTS = [
        "l_cab_2_1",  # bit 0
        "l_cab_2_2",  # bit 1
        "l_cab_2_3",  # bit 2
        "l_cab_2_4",  # bit 3
        "l_cab_2_5",  # bit 4
        "l_cab_2_6",  # bit 5
        "l_cab_2_7",  # bit 6
        "l_cab_2_8",  # bit 7
    ]

    LIGHT_KEY = "audio_command_bus"
    PRIORITY = 2000000

    def on_load(self):
        self.machine.events.add_handler("audio_command", self.audio_command)
        self.machine.events.add_handler("audio_command_clear", self.clear_audio_command)

    def audio_command(self, command=0, pulse_ms=None, **kwargs):
        command = int(command)

        if command < 0:
            command = 0

        if command > 255:
            command = 255

        for bit_index, light_name in enumerate(self.BIT_LIGHTS):
            bit_is_on = bool(command & (1 << bit_index))
            light = self.machine.lights[light_name]

            if bit_is_on:
                light.color("FF0000", fade_ms=0, priority=self.PRIORITY, key=self.LIGHT_KEY)
            else:
                light.off(fade_ms=0, priority=self.PRIORITY, key=self.LIGHT_KEY)

        if pulse_ms is not None:
            self.delay.add(ms=int(pulse_ms), callback=self.clear_audio_command)

    def clear_audio_command(self, **kwargs):
        for light_name in self.BIT_LIGHTS:
            self.machine.lights[light_name].off(
                fade_ms=0,
                priority=self.PRIORITY,
                key=self.LIGHT_KEY
            )