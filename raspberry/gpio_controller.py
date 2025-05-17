import pigpio
from enum import Enum

class GpioChannel(Enum):
    GPIO_5 = 5
    GPIO_6 = 6
    GPIO_7 = 7

channels: list[GpioChannel] = [
    GpioChannel.GPIO_5, 
    GpioChannel.GPIO_6,
    GpioChannel.GPIO_7,
]

class GpioController:
    def __init__(self):
        self.pi = pigpio.pi()
        if not self.pi.connected:
            raise RuntimeError("Failed to connect to pigpio daemon. Is it running?")
        self._prev_states = {}

    def set_state(self, channel: GpioChannel, state: bool):
        """
        Set the state of a GPIO channel.
        :param channel: The GPIO channel to control.
        :param state: True for HIGH, False for LOW.
        """
        gpio_pin = channel.value
        if channel not in self._prev_states or self._prev_states[channel] != state:
            print(f"Setting GPIO {gpio_pin} to {'HIGH' if state else 'LOW'}")
            self.pi.set_mode(gpio_pin, pigpio.OUTPUT)
            self.pi.write(gpio_pin, pigpio.HIGH if state else pigpio.LOW)
            self._prev_states[channel] = state

    def cleanup(self):
        """
        Clean up the GPIO controller and release resources.
        """
        self.pi.stop()