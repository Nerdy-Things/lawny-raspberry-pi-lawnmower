from raspberry.gpio_controller import GpioControl
from raspberry.gpio_controller import GpioChannel

class CutterController: 
    _cutter_state = None
    _cutter_gpio = GpioChannel.GPIO_7
    _gpio_control: GpioControl = GpioControl()

    def set_state(self, state: bool):
        if self._cutter_state != state:
            self._gpio_control.set_state(self._cutter_gpio, state=state)
