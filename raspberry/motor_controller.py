import time

from gpio_controller import GpioController
from gpio_controller import GpioChannel

from pwm_controller import PwmController
from pwm_controller import PwmChannel

class MotorController:
    _left_motor = PwmChannel.GPIO_12
    _right_motor = PwmChannel.GPIO_13
    
    _left_motor_direction_gpio = GpioChannel.GPIO_5
    _right_motor_direction_gpio = GpioChannel.GPIO_6

    _pwm_controller: PwmController = PwmController()
    _gpio_controller: GpioController = GpioController()

    def init(self):
        self._pwm_controller.init(channel=self._left_motor)
        self._pwm_controller.init(channel=self._right_motor)

    def set(self, left: float, right: float):
        self._pwm_controller.set(channel=self._left_motor, value=abs(left))
        self._gpio_controller.set_state(channel=self._left_motor_direction_gpio, state=left < 0)
        self._pwm_controller.set(channel=self._right_motor, value=abs(right))
        self._gpio_controller.set_state(channel=self._right_motor_direction_gpio, state=right < 0)

    def stop(self):
        self._pwm_controller.set(channel=self._left_motor, value=0)
        self._pwm_controller.set(channel=self._right_motor, value=0)
