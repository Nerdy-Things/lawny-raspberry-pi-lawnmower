import time
import gpiod
from gpiod.line import Direction, Value

chip_name = "/dev/gpiochip4"

with gpiod.Chip(chip_name) as chip:
    info = chip.get_info()
    print(f"{info.name} [{info.label}] ({info.num_lines} lines)")

gpiod.is_gpiochip_device(chip_name)

LINE = 5
with gpiod.request_lines(
    chip_name,
    consumer="me",
    config={
        LINE: gpiod.LineSettings(
            direction=Direction.OUTPUT, output_value=Value.ACTIVE
        )
    },
) as request:
    while True:
        request.set_value(LINE, Value.ACTIVE)
        print(f"{LINE} ACTIVE")
        time.sleep(1)
        request.set_value(LINE, Value.INACTIVE)
        print(f"{LINE} INACTIVE")
        time.sleep(1)
    