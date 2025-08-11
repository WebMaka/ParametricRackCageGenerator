/*

 Parametric Rack Cage Generator v. 0.1 (10 Aug 2025)
 --------------------------------------------------------------------------------
 Copyright © 2025 by WebMaka - this file is licensed under CC BY-NC-SA 4.0.
 To view a copy of this license, visit
   https://creativecommons.org/licenses/by-nc-sa/4.0/

 Quickly create a 3D-printable object file for a rack cage for any device
 of a given size. Simply provide the device's dimensions, and optionally
 tweak a few settings, then press F6 then F7 to generate and save a STL
 file.


 If this is useful to you, please consider donating or subscribing to my
 Patreon. I fund my projects entirely out-of-pocket, and any additional
 funding will help.

   https://patreon.com/webmaka

 
 
 Patch Notes
 -------------------------------------------------------------------------------- 
 0.1 - 10 Aug 2025 
   Initial Release
 
*/



// Customizer setup

/* [Target Device Dimensions] */

// Depth/length (front-to-back) of device in mm
device_depth = 120.0; // [0::254]

// Width (left-to-right) of device in mm
device_width = 150.0; // [0::222]

// Height (top-to-bottom) of device in mm
device_height = 45.0; // [0::200]

// Clearance in mm - lower values make for a tighter fit, but remember that 3D printers have dimensional tolerances on their prints.
device_clearance = 1; // [0.0:0.25:5.0]



/* [Options] */

// Rack width (inches) - NOTE: 6.33" and 9.5" are 1/3-width and 1/2-width for a 19" rack. Use in conjunction with the bolt-together faceplate option below.
rack_width = 10; // [6,6.33,9.5,10,19]

// Bolt-together faceplate ears - adds a mounting ear on one or both sides for mounting multiple devices into a single 19" wide faceplate - NOTE: For 19" racks, set rack width above to 9.5 for two-part faceplates or 6.33 for three-part faceplates
bolt_together_faceplate_ears = "None"; // ["None","One Side","Both Sides"]

// Heavy device - thickens all surfaces to support additional weight
heavy_device = 0; // [0,1,2]

// Additional top/bottom support - divides upper/lower space and adds center reinforcing
extra_support = false; 



/* [Rarely-Changed Options] */

// Faceplate corner radius in mm, for rounded corners
faceplate_radius = 5; // [1::25]

// Support structure radius in mm, for rounded corners on the backside of the mount
support_radius = 4; // [1::25]

// Side/top/bottom cutout edge thickness in mm (higher number makes the cutout smaller)
cutout_edge = 4; // [1::25]

// Side/top/bottom cutout corner radius in mm
cutout_radius = 5; // [1::25]

// Detail level of all curved/rounded surfaces - higher is better but slower
this_fn = 64; // [0::360]



// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 



// Create a plate with two rounded corners (e.g., support frame)
module two_rounded_corner_plate(plate_height, plate_width, plate_thickness, corner_radius)
{
    linear_extrude(plate_thickness, center=false, twist=0, $fn=this_fn)
        hull()
        {
            translate([0-(plate_width / 2)+corner_radius, 0-(plate_height / 2)+corner_radius, 0])
                circle(r=corner_radius, $fn=this_fn);
            translate([0-(plate_width / 2)+corner_radius, (plate_height / 2)-corner_radius, 0])
                circle(r=corner_radius, $fn=this_fn);
            translate([(plate_width / 2), 0-(plate_height / 2), 0])
                circle(r=0.001, $fn=this_fn);
            translate([(plate_width / 2), (plate_height / 2), 0])
                circle(r=0.001, $fn=this_fn);
        }
}

// Create a plate with four rounded corners (e.g., faceplate)
module four_rounded_corner_plate(plate_height, plate_width, plate_thickness, corner_radius)
{
    linear_extrude(plate_thickness, center=false, twist=0, $fn=this_fn)
        hull()
        {
            translate([0-(plate_width / 2)+corner_radius, 0-(plate_height / 2)+corner_radius, 0])
                circle(r=corner_radius, $fn=this_fn);
            translate([0-(plate_width / 2)+corner_radius, (plate_height / 2)-corner_radius, 0])
                circle(r=corner_radius, $fn=this_fn);
            translate([(plate_width / 2)-corner_radius, 0-(plate_height / 2)+corner_radius, 0])
                circle(r=corner_radius, $fn=this_fn);
            translate([(plate_width / 2)-corner_radius, (plate_height / 2)-corner_radius, 0])
                circle(r=corner_radius, $fn=this_fn);
        }
}

// Create faceplate slotted screw hole (sized for M5 or 10-32)
module faceplate_screw_hole_slot()
{
    linear_extrude(6 + (heavy_device ? 2:0), center=false, twist=0, $fn=this_fn)
    {
        hull()
        {
            translate([-2.5, 0, 0])
                circle(d=5.5, $fn=this_fn, false);
            translate([2.5, 0, 0])
                circle(d=5.5, $fn=this_fn, false);    
        }
    }    
}


// Create a blank faceplate of a gvien unit count in height. This module also
// adds screw holes in EIA-310 standard spacing.
module create_blank_faceplate(desired_width, unit_height)
{
    difference()
    {
        // Create the faceplate itself, and optionally add ears to one or
        // both sides for 1/3- or 1/2-width faceplates for a 19" rack.
        if (bolt_together_faceplate_ears == "None")
          four_rounded_corner_plate(unit_height * 44.45, desired_width * 25.4, 4 + heavy_device, faceplate_radius);
        if (bolt_together_faceplate_ears == "One Side")
        {
            union()
            {
                two_rounded_corner_plate(unit_height * 44.45, desired_width * 25.4, 4 + heavy_device, faceplate_radius);
                translate([((desired_width * 25.4) / 2) - (4 + heavy_device), 0,  14 + heavy_device - 1])
                    rotate([0, 90, 0])
                        two_rounded_corner_plate(unit_height * 44.45, 21, 4 + heavy_device, 5);
            }
        }
        if (bolt_together_faceplate_ears == "Both Sides")
        {
            union()
            {
                four_rounded_corner_plate(unit_height * 44.45, desired_width * 25.4, 4 + heavy_device, 0.001);
                translate([((desired_width * 25.4) / 2) - (4 + heavy_device), 0,  14 + heavy_device - 1])
                    rotate([0, 90, 0])
                        two_rounded_corner_plate(unit_height * 44.45, 21, 4 + heavy_device, 5);
                translate([0-((desired_width * 25.4) / 2), 0,  14 + heavy_device - 1])
                    rotate([0, 90, 0])
                        two_rounded_corner_plate(unit_height * 44.45, 21, 4 + heavy_device, 5);
            }
        }
        
        // Faceplate screw slots - these are set to EIA-310 standard 
        // 1/2-5/8-5/8 spacing, sized for 10-24/M5 screws.
        for (unit_number = [0:unit_height])
        {
            if (bolt_together_faceplate_ears != "Both Sides")
            {
                translate([0-((desired_width * 25.4) / 2) + 8, (unit_number * 44.45) - ((unit_height * 44.45) / 2) + 6.35, -1])
                    faceplate_screw_hole_slot();
                translate([0-((desired_width * 25.4) / 2) + 8, (unit_number * 44.45) - ((unit_height * 44.45) / 2) + 22.225, -1])
                    faceplate_screw_hole_slot();
                translate([0-((desired_width * 25.4) / 2) + 8, (unit_number * 44.45) - ((unit_height * 44.45) / 2) + 38.1, -1])
                    faceplate_screw_hole_slot();
            }
            else
            {
                translate([0-((desired_width * 25.4) / 2) - 11, (unit_number * 44.45) - ((unit_height * 44.45) / 2) + 6.35, 14 + heavy_device])
                    rotate([0, 90, 0])
                        linear_extrude(22, center=false, twist=0, $fn=this_fn)
                            circle(d=5.5, $fn=this_fn, false);
                translate([0-((desired_width * 25.4) / 2) - 8, (unit_number * 44.45) - ((unit_height * 44.45) / 2) + 22.225, 14 + heavy_device])
                    rotate([0, 90, 0])
                        linear_extrude(22, center=false, twist=0, $fn=this_fn)
                            circle(d=5.5, $fn=this_fn, false);
                translate([0-((desired_width * 25.4) / 2) - 8, (unit_number * 44.45) - ((unit_height * 44.45) / 2) + 38.1, 14 + heavy_device])
                    rotate([0, 90, 0])
                        linear_extrude(22, center=false, twist=0, $fn=this_fn)
                            circle(d=5.5, $fn=this_fn, false);
            }

            if (bolt_together_faceplate_ears == "None")
            {
                translate([((desired_width * 25.4) / 2) - 8, (unit_number * 44.45) - ((unit_height * 44.45) / 2) + 6.35, -1])
                    faceplate_screw_hole_slot();
                translate([((desired_width * 25.4) / 2) - 8, (unit_number * 44.45) - ((unit_height * 44.45) / 2) + 22.225, -1])
                    faceplate_screw_hole_slot();
                translate([((desired_width * 25.4) / 2) - 8, (unit_number * 44.45) - ((unit_height * 44.45) / 2) + 38.1, -1])
                    faceplate_screw_hole_slot();
            }
            else
            {
                translate([((desired_width * 25.4) / 2) - 11, (unit_number * 44.45) - ((unit_height * 44.45) / 2) + 6.35, 14 + heavy_device])
                    rotate([0, 90, 0])
                        linear_extrude(22, center=false, twist=0, $fn=this_fn)
                            circle(d=5.5, $fn=this_fn, false);
                translate([((desired_width * 25.4) / 2) - 8, (unit_number * 44.45) - ((unit_height * 44.45) / 2) + 22.225, 14 + heavy_device])
                    rotate([0, 90, 0])
                        linear_extrude(22, center=false, twist=0, $fn=this_fn)
                            circle(d=5.5, $fn=this_fn, false);
                translate([((desired_width * 25.4) / 2) - 8, (unit_number * 44.45) - ((unit_height * 44.45) / 2) + 38.1, 14 + heavy_device])
                    rotate([0, 90, 0])
                        linear_extrude(22, center=false, twist=0, $fn=this_fn)
                            circle(d=5.5, $fn=this_fn, false);
            }            
        }
    }
}



// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 



// The Process™!
module do_the_thing()
{
    // Calculate how many units tall the mount needs to be in order to hold 
    // the device and provide at least 10mm of clearance above/below for support
    // structure.
    total_height_required = device_height + 20;
    units_required = ceil(total_height_required / 44.45);
    
    // Calculate whether the device will fit within the INTERNAL width for the
    // given rack width, again allowing at least 10mm of clearance on each side
    // for support structure. Note that for 1/2-width and 1/3-width sizes in 19"
    // racks, we will auto-scale 1/3-to-1/2, 1.2-to-full, or even 1/3-to-full
    // as required to fit the device dimensions.
    //
    // NOTE: This seems kludgy AF but has to be done this way, with a series of
    // conditional additions, because of how OpenSCAD handles variables.
    total_width_required = device_width + 20;    
    rack_width_required = rack_width + 
      (((rack_width == 6) && (total_width_required > 120) && (total_width_required <= 220)) ? 4:0) + // Too wide for 6" but not too wide for 10"
      (((rack_width == 6) && (total_width_required > 220) && (total_width_required < 220)) ? 13:0) + // Too wide for both 6" and 10"
   
      (((rack_width == 6.33) && (total_width_required > 130) && (total_width_required <= 220)) ? 3.17:0) + // Too wide for 1/3-rack @ 19" but not for 1/2-wide
      (((rack_width == 6.33) && (total_width_required > 220) && (total_width_required < 220)) ? 12.67:0) + // Too wide for both 1/3-rack and 1/2-rack @ 19"
    
      (((rack_width == 9.5) && (total_width_required > 210)) ? 9.5:0) +  // Too wide for 1/2-rack @ 19"
    
      (((rack_width == 10) && (total_width_required > 220)) ? 9:0); // Too wide for 10"
      
    total_depth_required = device_depth + 0;
    
    
    // Time for warnings based on settings...
    
    // Warn the user if the rack size had to be increased to fit the device.
    if (rack_width != rack_width_required)
    {
        echo();
        echo();
        echo(" * * * WARNING! * * *");
        echo(" Device dimensions are too large to fit the selected rack width.");
        echo(" Width increased from ", rack_width, "in. to ", rack_width_required, "in.");
        echo(" Double-check your settings, especially for bolt-together faceplates.");
        echo();
        echo();
    }

    // Warn the user if the rack is set to a full width but one or both ears
    // are enabled.
    if (
        ((rack_width_required == 6) || (rack_width_required == 10) || (rack_width_required == 19)) 
        &&
        (bolt_together_faceplate_ears != "None")
       )
    {
        echo();
        echo();
        echo(" * * * WARNING! * * *");
        echo(" Rack width is set to a full rack dimension, but bolt-together faceplate");
        echo(" ears are enabled on one or both sides. This is probably not desireable.");
        echo(" Double-check your settings, especially for bolt-together faceplates.");
        echo();
        echo();
    }

    // Warn the user if the rack is set to a 1/2- or 1/3-width @ 19" but
    // no ears are enabled.
    if (
        ((rack_width_required == 6.33) || (rack_width_required == 9.5)) 
        &&
        (bolt_together_faceplate_ears == "None")
       )
    {
        echo();
        echo();
        echo(" * * * WARNING! * * *");
        echo(" Rack width is set to a partial rack dimension, but bolt-together faceplate");
        echo(" ears are not enabled on one or both sides. This is probably not desireable.");
        echo(" Double-check your settings, especially for bolt-together faceplates.");
        echo();
        echo();
    }

    // Warn the user if the rack is set to 1/2-width @ 19" but both ears
    // are enabled.
    if (
        (rack_width_required == 9.5)
        &&
        (bolt_together_faceplate_ears == "Both Sides")
       )
    {
        echo();
        echo();
        echo(" * * * WARNING! * * *");
        echo(" Rack width is set to 1/2-width for a 19\" rack, but bolt-together faceplate");
        echo(" ears are enabled on both sides. This is probably not desireable.");
        echo(" Double-check your settings, especially for bolt-together faceplates.");
        echo();
        echo();
    }



    //  Time to build the rack cage. Let's get to it!    
    difference()
        {
            union()
            {
                // Create the faceplate.
                create_blank_faceplate(rack_width_required, units_required);
                
                // Create a reinforcing block behind the faceplate centered on where we
                // will cut out the opening for the device.
                translate([0, 0, 7.5 + (heavy_device ? 2:0)])
                    cube([total_width_required, total_height_required, 9], center=true);
            
                // Create two side plates and carve most of them out for ventillation
                translate([0-((device_width + device_clearance) / 2) - 4 - heavy_device, 0, ((device_depth + device_clearance) / 2) + 11 + (heavy_device ? 2:0) - (device_clearance / 2)])
                    rotate([90, 90, 90])
                        difference()
                        {
                            two_rounded_corner_plate(total_height_required, device_depth + device_clearance, 4 + (heavy_device ? 2:0), support_radius);
                            
                            // If the device depth is too shallow, skip the ventillation cutouts.
                            if (device_depth > 27)
                            {
                                translate([4, 0, -1])
                                    four_rounded_corner_plate(device_height - 8, device_depth - 16 - cutout_edge, 6 + (heavy_device ? 2:0), cutout_radius);    
                            }                
                        }        
                translate([((device_width + device_clearance) / 2) , 0, ((device_depth + device_clearance) / 2) + 11 + heavy_device - (device_clearance / 2)])
                    rotate([90, 90, 90])
                        difference()
                        {
                            two_rounded_corner_plate(total_height_required, device_depth + device_clearance, 4 + (heavy_device ? 2:0), support_radius);
                            if (device_depth > 27)
                            {
                                translate([4, 0, -1])
                                    four_rounded_corner_plate(device_height - 8, device_depth - 16 - cutout_edge, 6 + (heavy_device ? 2:0), cutout_radius);   
                            }                 
                        }
                        
                // Create two top/bottom plates and carve most of them out for ventillation
                translate([0, (device_height + device_clearance) / 2, ((device_depth + device_clearance) / 2) + 11 + heavy_device - (device_clearance / 2)])
                    rotate([0, 90, 90])
                        difference()
                        {
                            two_rounded_corner_plate(total_width_required, device_depth + device_clearance, 4 + heavy_device, support_radius);
                            if (device_depth > 27)
                            {
                                if (!extra_support)
                                {
                                    translate([4, 0, -1])
                                        four_rounded_corner_plate(device_width - 8, device_depth - 16 - cutout_edge, 6 + heavy_device, cutout_radius);      
                                } else {
                                    translate([4, (device_width - 8) / 4 + 8, -1])
                                        four_rounded_corner_plate((device_width - 8) / 2 - 16, device_depth - 16 - cutout_edge, 6 + heavy_device, cutout_radius);      
                                    translate([4, -(device_width - 8) / 4 - 8, -1])
                                        four_rounded_corner_plate((device_width - 8) / 2 - 16, device_depth - 16 - cutout_edge, 6 + heavy_device, cutout_radius);      

                                }
                            }
                        }
                // Enabling the extra support option adds center supports
                // and reinforcing structures to the top and bottom.
                if (extra_support)
                {
                    difference()
                    {
                        translate([-2 - heavy_device - 10, 0, ((device_depth + device_clearance) / 2) + 11 + (heavy_device ? 2:0) - (device_clearance / 2)])
                            rotate([90, 90, 90])
                                two_rounded_corner_plate(total_height_required, device_depth + device_clearance, 4 + (heavy_device ? 2:0), support_radius);

                        translate([0, 0, (device_depth / 2)])
                            cube([device_width + device_clearance + 1, device_height + device_clearance + 1, device_depth + device_clearance + 50], center=true);
                    }

                    difference()
                    {
                        translate([-2 - heavy_device + 10, 0, ((device_depth + device_clearance) / 2) + 11 + (heavy_device ? 2:0) - (device_clearance / 2)])
                            rotate([90, 90, 90])
                                two_rounded_corner_plate(total_height_required, device_depth + device_clearance, 4 + (heavy_device ? 2:0), support_radius);

                        translate([0, 0, (device_depth / 2)])
                            cube([device_width + device_clearance + 1, device_height + device_clearance + 1, device_depth + device_clearance + 50], center=true);
                    }
                }
                        
                translate([0, 0-((device_height + device_clearance) / 2) - 4 - heavy_device, ((device_depth + device_clearance) / 2) + 11 + heavy_device - (device_clearance / 2)])
                    rotate([0, 90, 90])
                        difference()
                        {
                            two_rounded_corner_plate(total_width_required, device_depth + device_clearance, 4 + heavy_device, support_radius);
                            
                            if (device_depth > 27)
                            {
                                if (!extra_support)
                                {
                                    translate([4, 0, -1])
                                        four_rounded_corner_plate(device_width - 8, device_depth - 16 - cutout_edge, 6 + heavy_device, cutout_radius);      
                                } else {
                                    translate([4, (device_width - 8) / 4 + 8, -1])
                                        four_rounded_corner_plate((device_width - 8) / 2 - 16, device_depth - 16 - cutout_edge, 6 + heavy_device, cutout_radius);      
                                    translate([4, -(device_width - 8) / 4 - 8, -1])
                                        four_rounded_corner_plate((device_width - 8) / 2 - 16, device_depth - 16 - cutout_edge, 6 + heavy_device, cutout_radius);      
                                }    
                            }        
                        }
                
                // Create a back plate and carve most of it out for ventillation
                translate([0, 0, 2 + device_depth + device_clearance + heavy_device])
                    difference()
                    {
                        cube([device_width + 2, device_height + 2, 4 + heavy_device], center=true);                    
                        translate([0, 0, -3 -  + (heavy_device ? 1:0)])
                            four_rounded_corner_plate(device_height - cutout_edge, device_width - cutout_edge, 6 + heavy_device, cutout_radius);
                    }
        }
                    
        // Carve out the device area
        translate([0, 0, -1])
            cube([device_width + device_clearance, device_height + device_clearance, 50], center=true);
    }
}



// Do the thing!
do_the_thing();



/* END! */