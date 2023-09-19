### Solution

#### (a)

To add a non-scrolling status bar. We need to split the screen horizontally into 2 sections, where one is the main window, and the other one is the status bar. 

From the documentation:

>The Line Compare field in the VGA, of which bit 9 is in the [Maximum Scan Line Register](http://www.osdever.net/FreeVGA/vga/crtcreg.htm#09), bit 8 is in the [Overflow Register](http://www.osdever.net/FreeVGA/vga/crtcreg.htm#07), and bits 7-0 are in the [Line Compare Register](http://www.osdever.net/FreeVGA/vga/crtcreg.htm#18), specifies the scan line address of the horizontal division
>
>The Line Compare field specifies the scan line at which a horizontal division can occur, providing for split-screen operation. 

That means we want to set the **Line Compare Register** **to the scan line address we want to split at**. Do notice that there is a limitation:

>...... The second limitation is that either both windows are panned by the same amount, or only the top window pans, in which case, the bottom window's panning values are fixed at 0. ......

We want the status bar to be non-scrolling, that means we have to put the status bar on the bottom window, and the main content on the top window. To do this

>If the [Pixel Panning Mode](http://www.osdever.net/FreeVGA/vga/attrreg.htm#10) field is set to 1 then the [Pixel Shift Count](http://www.osdever.net/FreeVGA/vga/attrreg.htm#13) and [Byte Panning](http://www.osdever.net/FreeVGA/vga/crtcreg.htm#08) fields are reset to 0 for the remainder of the display cycle allowing the top window to pan while the bottom window remains fixed. 

We set the **Pixel Panning Mode field to 1** to make the top window (main content) to pan and bottom window (status bar) fixed.



#### (b)

To change the **VGA's color palette**:

1. Output the **palette index** you want to change to **DAC Address Write Mode Register**
2. Output the `RED`, `GREEN`, `BLUE` to the **DAC Data Register**

>Note: The internal write address automatically advances allowing the next value's RGB values to be loaded without having 
>to reprogram the DAC Address Write Mode Register.  This allows the entire palette to be loaded in one write operation.

An possible example

```assembly
movw $0x3c8, %dx
movb $COLOR_INDEX, %al
outb %al, (%dx)

movw $0x3c9, %dx
movb $RED, %al
outb %al, (%dx)
movb $GREEN, %al
outb %al, (%dx)
movb $BLUE, %al
outb %al, (%dx)
```

where `COLOR_INDEX` is the **palette index** you want to change, `RED`, `GREEN`, `BLUE` is a `6-bit` number that get extended to `8-bit` (only the lower `6-bit` will actually be used by VGA). `0x3c8` is the **DAC Address Write Mode Register**, and `0x3c9` is the **DAC Data Register** in this case. 

