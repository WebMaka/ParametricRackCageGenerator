# Parametric Rack Cage Generator
 Copyright © 2025 by WebMaka - this file is licensed under CC BY-NC-SA 4.0.
 To view a copy of this license, visit
   https://creativecommons.org/licenses/by-nc-sa/4.0/
   
Quickly create a 3D-printable object file for a rack cage for any device of a given size. Simply provide the device's dimensions, and optionally tweak a few settings, then press F6 then F7 to generate and save a STL file.

 If this is useful to you, please consider donating or subscribing to my
 Patreon. I fund my projects entirely out-of-pocket, and any additional
 funding will help.
 
   https://patreon.com/webmaka

 

## Features

*    Generates a front-loaded (read: device is slotted in from the front) corner-cage support structure for any device by its dimensions plus a clearance value (default is 1mm), and creates a faceplate for a standard 6"/10"/19" rack that is set up to comply with EIA-310 standards. Triple-hole per 1.75"/44.45mm "unit" of height, slotted, sized for #10/M5 screws.
*    Height is automatically scaled in multiples of rack units to suit the dimensions of the device plus the support structure to hold it (which adds 20mm in all axes to the device's dimensions). So, anything shorter than 24mm will be 1U, 25-68mm tall will be 2U, and so on.
*    Width is also automatically scaled if the device plus support structure won't fit within the desired rack width minus the rack-rail clearance space of at least 5/8" on each side. So, the hard cap on widths for a 6" rack is 120mm and 10" rack is 220mm.
*    Depth is only limited by practical considerations like print volume and the weight of the device making the cage sag/twist/distort. I have a Minisforum MS-01 in a cage this script generated and it's almost 200mm deep.
*    Back/sides/top/bottom are mostly open for ventilation as long as the device is at least 28mm deep. (Back is always open with a retaining lip around the perimeter regardless of depth.) There may be clearance issues for devices that have connections close to their edges, but thus far everything I've tried has fit without issue. (You'll probably have to remove any rubber/plastic feet on the bottom of the device though.)
*    This script can also generate cages for things you might not think about caging, such as having a 120mm square by 25mm tall 2U cage to hold a 120mm case fan horizontally above/below/between devices. It can also make tall but not very deep cages to hold things like LCD panels - I'm debating printing one to hold a 5" touchscreen LCD for my 10" 6U network rack, for example.
*    The script currently does not generate custom faceplate cutouts like connector holes, keystone jacks, ventilation holes/slots, etc. I may add that in the future if there's interest, but in the meantime it's still perfectly usable for things that are in their own enclosures, so while it won't make a fancy three-part 19" rack cage for your triple-Raspberry-Pi cluster that only exposes the connectors, it can make three bolt-together cage segments for a trio of Pis in cases.
*    The device is centered on the faceplate in both axes. There's no up/top or down/bottom - the cage is symmetrical.
*    Intended for light duty use only - I've tested it with 5kg/12 lb. devices, but it's not intended to generate cages to hold things like big drive arrays and what not. However, for things like networking gear or SFF PCs (read: basically most common homelab/minilab gear) it should be great.
*    Can generate half- and third-width bolt-together subpanels for 19" racks. Due to standards-matching on dimensions/holes, you can mix-and-match things of the same width, e.g., a 2U half-width on one side with two 1U half-widths on the other holding three different devices of different sizes. (Again, device height will determine unit height and there are maximums on width.)
*    Default thickness of the faceplate and structural components is 4mm, but it can be thickened to 5mm or 6mm for heavier objects. I also have an option to add additional anti-sagging supports at the top and bottom for things that have a bit more weight to them.



## Printing Requirements

What you'll need to be able to print the STLs this script creates:

*    A 3D printer capable of at least PETG if not something more durable, e.g. ASA. I'm not sure if PLA is a good idea (unless you're using a fancy new high-temp variant) since some networking and compute gear can emit quite a bit of heat.
*    Dimensional accuracy will be critical as this is millimeter-precise. Make sure your printer will at least reasonably match the dimensions, and if it's off-scale, make sure it's slightly oversized and not under so your print will still be usable even if it's not exactly to size.
*    Resulting STLs up to 10" rack size and up to 2U tall should (key word!) fit at a 45° angle on a 240mm square print bed, so smaller-volume printers like an Ender 3 might be usable, but I'd recommend printing on a 300mm+ printer if you have access to one.
*    They do need to be printed pretty sturdily. My settings are 5 walls, 100%/solid infill, and supports will be required unless your printer has godlike bridging capability. (I found that tree supports waste less material than zig-zag. If you do use a non-tree support, have your slicer generate them at a 45° angle for better support.)
*    Print orientation is faceplate-down, so the print quality of your first layer will be pretty important if you care about aesthetics. Make sure your build plate is nice and clean.
*    If you want to rack-mount something that will be heavier and/or subjected to a lot of movement, such as a touchscreen LCD, change the _heavy device_ setting to bump up the thicknesses of all the things for increased structural durability.

 

## Usage

This script was built to work with/in OpenSCAD version 2021.01, but may well work with other versions or as an import into FreeCAD, although this has not been tested. To obtain a copy of OpenSCAD, visit this URL:

  https://openscad.org/

To use this script:

1. Launch OpenSCAD.
2. Open this script.
3. Use the Customizer to configure the size of the object that you wish to rack-mount. Optionally, configure other settings to suit.
4. Press F6 to instruct OpenSCAD to fully calculate and render the rack cage as an object.
5. Press F7 to save the created object as a STL file.
6. Slice and print the object.

