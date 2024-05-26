import time

from pwm_controller import PwmController
from pwm_controller import PwmChannel

from gpio_controller import GpioChannel
from gpio_controller import GpioController

gpio_controller: GpioController= GpioController()
pwm_control: PwmController = PwmController()

print("Set control")
pwm_control.init(channel=PwmChannel.GPIO_12)
pwm_control.init(channel=PwmChannel.GPIO_13)

gpio_controller.set_state(GpioChannel.GPIO_5, True)
gpio_controller.set_state(GpioChannel.GPIO_6, True)
gpio_controller.set_state(GpioChannel.GPIO_7, True)

print("Set 100%")
pwm_control.set(PwmChannel.GPIO_12, 50)
pwm_control.set(PwmChannel.GPIO_13, 50)
time.sleep(5)

pwm_control.set(PwmChannel.GPIO_12, 0)
pwm_control.set(PwmChannel.GPIO_13, 0)

gpio_controller.set_state(GpioChannel.GPIO_5, False)
gpio_controller.set_state(GpioChannel.GPIO_6, False)
gpio_controller.set_state(GpioChannel.GPIO_7, False)

pwm_control.set(PwmChannel.GPIO_12, 50)
pwm_control.set(PwmChannel.GPIO_13, 50)

time.sleep(5)

pwm_control.set(PwmChannel.GPIO_12, 0)
pwm_control.set(PwmChannel.GPIO_13, 0)