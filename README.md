# fencing-score-xmit
Remote fencing scoring light display transmitter

This project is used to transmit the display from a fencing scoring machine to up to four remote displays, which could be wall lights or in-mask lights. A fencing scoring machine display consists of four lights from left to right: white, red, green, white. The red light indicates a valid hit by the fencer on the left and the green light indicates a valid hit by the fencer on the right. The corresponding white (or yellow) lights indicate a an off-target hit or equipment malfunction for the fencer on that side.

This was designed to work with a Triplette Club Scoring machine which I reverse engineered to discover the gate on each MOSFET that drives one of the lights. Inputs to the the transmitter module are soldered to the corresponding gate on the MOSFET allowing the signal to be observed without affecting the function of the scoring machine.
