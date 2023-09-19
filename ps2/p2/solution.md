### Solution
#### (a)

* `MTCP_BIOC_ON ` is sent when the computer wants to enable interrupts from the Mouse/Tux controller buttons.
  The effect is that the Tux controller can send interrupt signals when the button is pressed. The result is that 
  the `MTCP_ACK ` signal is returned. `MTCP_ACK ` is simply the signal that is returned when the Mouse/Tux controller successfully completes a command.

* `MTCP_LED_SET` is sent when the LED is in USR mode and the user wants to set the LED values. The first byte of this argument determines which of the LEDs to set, and consequently how many bytes to set for each LED. The number of bytes that follow equal to the number of bits set to 1 in the first byte. These bytes correspond to particular LEDs, and the bits of each byte (which corresponds to an LED) correspond to the eight segments of its respective LED's display. (7 segment and a dot)

##### (b)

* `MTCP_ACK ` is the response returned when the Mouse/Tux controller successfully completes a command. The information 
  conveyed by the message is that the Mouse/Tux controller successfully completed a command that the computer sent it.
* `MTCP_BIOC_EVENT ` is the response generated when interrupts are enabled for the buttons for the Mouse/Tux controller and a button is pressed/released. This response conveys the information that a button has been pressed or released.
* `MTCP_RESET` is the response generated when the device is powered-up and re-initialized, or if the reset button is pressed, or
  when an `MTCP_RESET_DEV` command is sent from the computer to the Mouse/Tux controller. An `MTCP_RESET_DEV` command can be sent by the computer to the Mouse/Tux controller, and this causes the device to reset. The device doesn't respond until it finishes initializing itself, at which point it sends the `MTCP_RESET` signal. This message conveys that some sort of reset was applied to the Mouse/Tux controller.

**(c)**

The function `tuxctl_handle_packet` cannot wait because it's called by `tuxctl_ldisc_data_callback`, which document said that `This function is called from an interrupt context... It also must not take up too much time.`, so we cannot wait and take up too much time..

