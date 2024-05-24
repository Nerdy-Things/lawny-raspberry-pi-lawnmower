from rpi_hardware_pwm import HardwarePWM
from enum import Enum

frequency = 20000

class AlreadyStartedException(Exception):
    pass

class ChannelNotFoundException(Exception):
    pass

class OutOfBoundsException(Exception):
    pass

class PwmChannel(Enum):
    GPIO_12 = 0
    GPIO_13 = 1

class PwmControl:
    _pwms = {}

    def init(self, channel: PwmChannel):
        if channel in self._pwms:
            raise AlreadyStartedException("Pwm was initialized on that channel")
        else:
            print(f"Init {channel}")
            pwm = HardwarePWM(pwm_channel=channel.value, hz=frequency, chip=2)
            pwm.start(0)
            self._pwms[channel] = pwm

    def set(self, channel: PwmChannel, value: int):
        pwm = self._pwms[channel]
        if not pwm:
            raise ChannelNotFoundException("There is no PWM for this channel")
        value = min(value, 100)
        value = max(value, 0)
        print(f"Set {channel} {value}")
        pwm.change_duty_cycle(value)

    def stop(self, channel: PwmChannel):
        pwm = self._pwms[channel]
        if not pwm:
            raise ChannelNotFoundException("There is no PWM for this channel")
