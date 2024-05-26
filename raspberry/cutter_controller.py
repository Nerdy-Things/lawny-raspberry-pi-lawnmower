from gpio_controller import GpioController
from gpio_controller import GpioChannel

class CutterController: 
    _cutter_state = None
    _cutter_gpio = GpioChannel.GPIO_7
    _gpio_control: GpioController = GpioController()

    def set_state(self, state: bool):
        if self._cutter_state != state:
            self._gpio_control.set_state(self._cutter_gpio, state=state)
