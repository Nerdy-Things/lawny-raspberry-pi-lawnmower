import time

from gpio_control import GpioControl
from gpio_control import GpioChannel

from pwm_control import PwmControl
from pwm_control import PwmChannel

class MotorHandler:
    _left_motor = PwmChannel.GPIO_12
    _right_motor = PwmChannel.GPIO_13
    
    _left_motor_direction_gpio = GpioChannel.GPIO_5
    _right_motor_direction_gpio = GpioChannel.GPIO_6

    _pwm_control: PwmControl = PwmControl()
    _gpio_control: GpioControl = GpioControl()

    def init(self):
        self._pwm_control.init(channel=self._left_motor)
        self._pwm_control.init(channel=self._right_motor)
        self._gpio_control.init(channel=self._left_motor_direction_gpio)
        self._gpio_control.init(channel=self._right_motor_direction_gpio)

    def set(self, left: float, right: float):
        self._pwm_control.set(channel=self._left_motor, value=abs(left))
        self._gpio_control.set_state(channel=self._left_motor_direction_gpio, state=left > 0)
        self._pwm_control.set(channel=self._right_motor, value=abs(right))
        self._gpio_control.set_state(channel=self._left_motor_direction_gpio, state=right > 0)

    def stop(self):
        self._pwm_control.set(channel=self._left_motor, value=0)
        self._pwm_control.set(channel=self._right_motor, value=0)
        self._gpio_control.close()
