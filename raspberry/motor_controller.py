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

    def set(self, x: float, y: float):
        reverse_threshold = 75.0
        threshold_leftover = 100.0 - reverse_threshold
        power = abs(y)
        left_coefficient = 1.0
        right_coefficient = 1.0
        left_direction_forward = y > 0
        right_direction_forward = y > 0
        abs_x = abs(x)
        if abs_x > 0 and abs_x < reverse_threshold: 
            actual_coefficient = 1.0 - abs(x / reverse_threshold)
            if x < 0:
                right_coefficient = actual_coefficient
            else:
                left_coefficient = actual_coefficient
        elif abs_x >= reverse_threshold: 
            actual_coefficient = (abs_x - reverse_threshold) / threshold_leftover
            if x < 0:
                right_direction_forward = not right_direction_forward
                right_coefficient = actual_coefficient
            else:
                left_direction_forward = not left_direction_forward
                left_coefficient = actual_coefficient
                
        left_power = power * left_coefficient
        right_power = power * right_coefficient

        self._pwm_controller.set(channel = self._left_motor, value = left_power)
        self._gpio_controller.set_state(channel = self._left_motor_direction_gpio, state = left_direction_forward)
        self._pwm_controller.set(channel = self._right_motor, value = right_power)
        self._gpio_controller.set_state(channel = self._right_motor_direction_gpio, state = right_direction_forward)

    def stop(self):
        self._pwm_controller.set(channel = self._left_motor, value = 0)
        self._pwm_controller.set(channel = self._right_motor, value = 0)
