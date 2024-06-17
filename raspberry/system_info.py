import subprocess as sp

base_model = sp.getoutput("cat /sys/firmware/devicetree/base/model")

raspberry_five = "Raspberry Pi 5"
is_raspberry_five = base_model.startswith(raspberry_five)

class SystemInfo:

    @staticmethod
    def is_rasbperry_5() -> bool:
        return is_raspberry_five
    