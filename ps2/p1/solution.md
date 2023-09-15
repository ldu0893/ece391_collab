### P1 Solution

a. yada yada yada

b. To write a palette entry, output the palette entry's index value to the DAC Address Write Mode Register then perform 3 writes to the DAC Data Register, loading the red, green, then blue values into the palette RAM. The internal write address automatically advances allowing the next value's RGB values to be loaded without having to reprogram the DAC Address Write Mode Register.  This allows the entire palette to be loaded in one write operation.