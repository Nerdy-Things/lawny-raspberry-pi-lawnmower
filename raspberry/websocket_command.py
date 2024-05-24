from dataclasses import dataclass
from enum import Enum

class WebsocketCommandType(Enum):
  MOTOR = 1

@dataclass
class WebsocketCommand:
  type: WebsocketCommandType
  left: int
  right: int
  cutter: bool

  def __post_init__(self):
      self.type = WebsocketCommandType[self.type]
