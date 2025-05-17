from motor_controller import MotorController
from cutter_controller import CutterController
from pwm_reader import PWMReader
import asyncio
import math
import time

motor_controller: MotorController = MotorController()
cutter_controller: CutterController = CutterController()

pwm_channels = [16, 8, 21, 19]
pwm_reader: PWMReader = PWMReader(pwm_channels)

motor_controller.init()

async def main():
    while True:
        try:
            pwm_values = pwm_reader.read_channels(pwm_channels)
            (horizontal, direction, speed, cutter) = pwm_values

            # Map horizontal [985; 2015] to [-100, 100] with 1500 as center (0)
            horizontal = max(990, min(horizontal, 2010))
            horizontal_adjusted = math.floor((horizontal - 1500) * 100 / 510)  # 515 is half the range (2010-990)/2

            # Clamp speed value to range [990, 2010] and map to [0, 100]
            speed_clamped = max(990, min(speed, 2010))
            speed_adjusted = math.floor((speed_clamped - 990) * 100 / (2010 - 990))

            # Reverse direction based on a switcher
            if direction > 1600:
                speed_adjusted *= -1
            elif direction > 1400 and direction < 1600:
                speed_adjusted = 0

            print(f"Horizontal: {horizontal_adjusted}, Direction: {direction}, Speed: {speed_adjusted}, Cutter: {cutter}")
            # time.sleep(1)
            
            motor_controller.set(horizontal_adjusted, speed_adjusted)
            cutter_controller.set_state(cutter > 1600)
        except KeyboardInterrupt:
            print("Server stopped by user.")
            break
        except Exception as e:
            print(f"Error: {e}")
            await asyncio.sleep(1)
    pwm_reader.stop()

asyncio.run(main())