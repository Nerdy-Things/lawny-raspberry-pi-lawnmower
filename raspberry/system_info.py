import subprocess as sp

base_model = sp.getoutput("cat /sys/firmware/devicetree/base/model")

raspberry_five = "Raspberry Pi 5"
is_raspberry_five = base_model.startswith(raspberry_five)

class SystemInfo:

    @staticmethod
    def is_rasbperry_5() -> bool:
        return is_raspberry_five
    
    def pwm_chip() -> int:
        if SystemInfo.is_rasbperry_5():
            # For Raspberry PI 5
            return 2
        else:
            # For Raspberry PI (1,2,3,4,Zero)
            return 0
        
    def gpio_chip() -> str:
        if SystemInfo.is_rasbperry_5():
            # For Raspberry PI 5
            return "/dev/gpiochip4"
        else:
            # For Raspberry PI (1,2,3,4,Zero)
            return "/dev/gpiochip0"
