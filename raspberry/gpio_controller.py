import gpiod
from gpiod.line import Direction, Value
from enum import Enum

chip_name = "/dev/gpiochip4"
    
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
    _prev_states = {}
    
    def _init(self, channel: GpioChannel):
        config = {}
        config[channel.value] = gpiod.LineSettings(direction=Direction.OUTPUT, output_value=Value.ACTIVE)
        request = gpiod.request_lines(
            chip_name,
            consumer = "GpioControl",
            config = config
        )
        return request

    def set_state(self, channel: GpioChannel, state: bool):
        if channel not in self._prev_states or self._prev_states[channel] != state: 
            request = self._init(channel)
            with request as opened:
                if state:
                    opened.set_value(channel.value, Value.ACTIVE)
                else:
                    opened.set_value(channel.value, Value.INACTIVE)
            self._prev_states[channel] = state
