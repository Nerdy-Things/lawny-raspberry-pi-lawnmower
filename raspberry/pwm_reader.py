import pigpio

class PWMReader:
    def __init__(self, gpio_pins):
        """
        Initialize the PWMReader with the GPIO pins to read from.
        :param gpio_pins: List of GPIO pins connected to the PWM channels.
        """
        print(f"__init__ {gpio_pins}")
        self.gpio_pins = gpio_pins
        self.pi = pigpio.pi()
        if not self.pi.connected:
            raise RuntimeError("Failed to connect to pigpio daemon. Is it running?")
        
        self.pulse_widths = {pin: 0 for pin in gpio_pins}
        self.pulse_start = {}  # Initialize pulse_start as a dictionary
        
        # Set up callbacks for each GPIO pin
        for pin in gpio_pins:
            print(f"__init__ {pin}")
            self.pi.set_mode(pin, pigpio.INPUT)
            self.pi.set_pull_up_down(pin, pigpio.PUD_OFF)
            self.pi.callback(pin, pigpio.EITHER_EDGE, self._pulse_callback)
    
    def _pulse_callback(self, gpio, level, tick):
        """
        Callback function to measure pulse width.
        :param gpio: GPIO pin number.
        :param level: Signal level (0 or 1).
        :param tick: Time of the edge in microseconds.
        """
        # print(f"Callback triggered for GPIO {gpio}, level {level}, tick {tick}")
        if level == 1:  # Rising edge
            self.pulse_start[gpio] = tick
        elif level == 0:  # Falling edge
            if gpio in self.pulse_start:
                pulse_width = pigpio.tickDiff(self.pulse_start[gpio], tick)
                self.pulse_widths[gpio] = pulse_width
                # print(f"Pulse width for GPIO {gpio}: {pulse_width} µs")

    def read_channels(self, channels):
        """
        Read the pulse widths for the specified channels.
        :param channels: List of GPIO pins to read from.
        :return: List of pulse widths in microseconds.
        """
        if not self.pi.connected:
            print("Lost connection to pigpio daemon")
        return [self.pulse_widths.get(channel, 0) for channel in channels]

    def stop(self):
        """
        Stop the PWMReader and release resources.
        """
        self.pi.stop()