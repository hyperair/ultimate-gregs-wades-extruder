// Ultimate Greg's Wade's Geared Extruder - Bowden version
// Licensed under the GNU GPLV3. 
// Copyright Greg Frost, 2010
// Various modifications to the original source code by various authors:
//
// - Jonas Kuehling (2012)
// - vlnofka (2012)
// - Misan (2013)
// - Marty Rice (2013)
// - AndrewBCN (August 2015)

// This version of Greg's Wade's Geared Extruder was designed to use with a Bowden
// filament system. Filament diameter is fixed at 1.75mm, because using 3mm filament
// with a Bowden system is not recommended.

// A mounting bracket is optional; check the basic bracket module at the end of the code.
// Note that using a bracket removes a lot of material from the base.

// AndrewBCN : I have included the OpenSCAD source code for the "fishbone" gears
// in separate files. You must pass the distance between axles (hobbed bolt and
// stepper) as a parameter.

// Assembly tip: use heat (e.g. a soldering iron) to insert the M3 nut in its nut trap in the idler.

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

render_bracket = true; // select an extra mounting bracket or not
render_supports = false;

// Measure the Bowden pushfit connector you are using with a caliper.
// In my case, so these are the defaults:

bowden_pushfit_d = 9.6;      // Bowden pushfit diameter
bowden_pushfit_thread = 6.0; // Bowden pushfit thread length

bowden_type = "nut";        // pushfit or nut

// The Bowden connector will just be force-threaded into the base of the extruder.

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

include<configuration.scad>
include<functions.scad>

epsilon = 0.01;

// Define the hotend_mounting style you want by specifying hotend_mount=style1+style2 etc.
//e.g. wade(hotend_mount=groovemount+peek_reprapsource_mount);

bowden_mount=256;

// Make the default Bowden
default_extruder_mount=bowden_mount;

// Filament diameter
// - use 1.80 or 1.85 for 1.75mm diameter filament
filament_diameter=1.85;

// Base Extra Depth allows extra space for longer NEMA 17 steppers
// not used in this version, so value is zero.
base_extra_depth=0;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// These variables are not used anymore

mounting_holes_legacy=1;
mounting_holes_symmetrical=2;
default_mounting_holes=mounting_holes_symmetrical;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Render the various parts
// AndrewBCN : I suggest printing them separately, so comment out
// the lines for the parts you don't want to print

// Extruder body
wade(hotend_mount=default_extruder_mount,mounting_holes=default_mounting_holes);

// Bearing Washer
translate([52,70,0]) bearing_washer();

// Guidler
translate([-20,0,15.25]) rotate([0,-90,0]) wadeidler();

if (bowden_type == "nut")
translate ([-40, 0, 0])
bowden_clamp ();

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Visualisation
// (disabled)

//color("red")
//x-carriage v2
//translate([24,-32.75,base_extra_depth+wade_block_depth]) 
  //rotate([0,0,0]) 
    //import("../output/x-carriageV2.stl");


//%translate([45.0, 55.50, 1]) //[46.78,55, 1]
//  rotate([0, 0, 0])
//    nema17(places=[0,1,1,1], holes=true, shadow=5);

/*
color("silver")
translate(large_wheel_translation) {
	translate([0,0,-15])import("../output/biggearmod_fixed.stl");
	rotate([0,0,29.5]) translate([gear_separation,0, 5]) {
		rotate([180,0,0]) import("../output/smallgearmod_fixed.stl");
		rotate([0,0,-29.5]) translate([0,0,-4]) {nema17(places=[0,1,1,1], holes=true, shadow=5, $fn=7, h=8);
		}
	}
}
*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Extruder
 * @name Extruder
 * @assembled
 * @using 1 small-gear
 * @id extruder
 * @using 1 idler
 * @using 1 extruder-body
 * @using 1 m3nut
 * @using 1 m3washer
 * @using 1 m3x25
 * @step Take idler and insert nut into small nut-trap inside the hinge.
 * @step While holding the nut in place, preprare M3x25 bolt with washer and screw it into the hinge just enough to hold the nut.
 * @step Now take the extruder body and idler. Place idler on the hinge counterpart and compleately screw the M3x25 bolt. This will create secured hinge.
 * 
 * @using 2 m4nut
 * @step Place M4 nuts into their nut traps, secure them with piece of tape. We need them in place, since later they would be harder to access.
 * 
 * @using 3 m3x10
 * @using 3 m3washer
 * @using 1 NEMA17
 * @step Prepare your NEMA17 stepper motor and three M3x10 screws with washers.
 * @step Hold motor on place and lightly tighten the screws. We need to adjust motor position later, no need to tighten it hard.
 * 
 * @using 1 large-gear
 * @using 1 m8washer
 * @using 2 m8nut
 * @using 2 bearing-608
 * @step Place two skate bearings on ther position, they should snuggly fit in.
 * @step Insert prepared large gear into the body with mounted bearings.
 * @step Check if the alignment of hobbed part with the filament path. Adjust it accordingly with adding or removing M8 washers.
 * @step After adjusting, we need to fix the bolt in. So we place washer at the end of hobbed bolt and with two M8 nuts we will do locknut by tightening them against each other.
 * @step Check if large gear turns freely.
 * 
 * @using 2 m3x40
 * @using 4 m3washer
 * @using 2 extruder-spring
 * @step Prepare two M3x40 screws with sandwitch of washer-spring-washer.
 * @step Insert two M3 nuts into nut traps on top of drive mechanism. [[extruder/top-nut-traps.png]]
 * @step Insert prepared screws into the holes on idler. Close the idler and tighten the screws into the trapped nuts. More you tighten those screws, more pressure will be on fillament.
 * @step Your extruder is done. [[extruder/assembled.jpg]]
 */

/**
 * Extruder body
 * @name Extruder body
 * @category Printed
 * @id extruder-body
 */

/**
 * Extruder idler
 * @name Extruder Idler
 * @id idler
 * @category Printed
 * @using 1 bearing-608
 * @using 1 idler-m8-piece
 * @step Insert piece of M8 rod into bearing.
 * @step Insert 608 bearing with rod into printed idler part.
 */

/**
 * Small M8 rod 
 * @name Idler
 * @id idler-m8-piece
 * @category Rods and Bars
 */

/**
 * Spring used for idler on extruder.
 * @name Extruder spring
 * @id extruder-spring
 */

//===================================================
// Parameters defining the wade body:

elevation = 2; // AndrewBCN: was 15mm, decreased to 2mm for Bowden version
wade_block_height=55+elevation;
wade_block_width=24;
wade_block_depth=28;

block_bevel_r=6;

base_thickness=10;
base_length=70+2-6;
base_leadout=25+2+1-6;
//base_extra_depth=0; // commented out here since we defined it above

nema17_hole_spacing=1.2*25.4;//31; 
nema17_width=1.7*25.4;
nema17_support_d=nema17_width-nema17_hole_spacing;

screw_head_recess_diameter=7.2;
screw_head_recess_depth=3;

motor_mount_rotation=0;
motor_mount_translation=[48,50+elevation,0];
//motor_mount_translation=[52.5,38,0]; //original
motor_mount_thickness=8;

large_wheel_translation=[50.5-(7.4444+32.0111+0.25),34+elevation,0];

m8_clearance_hole=8 + 0.6;

hole_for_608=22.15; // AndrewBCN : was 22.3mm, decreased to 22.15mm
608_diameter=22;

block_top_right=[wade_block_width,wade_block_height];

layer_thickness=0.2; // AndrewBCN : 0.2mm recommended
filament_feed_hole_d=(filament_diameter*1.1)/cos(180/8);
hobbing_depth=0.4;
echo ("filament_feed_hole_d", filament_feed_hole_d);

//This is the distance from the centre of the filament to the centre of the hobbed bolt.
filament_feed_hole_offset=8/2-hobbing_depth+filament_diameter/2;

echo ("filament_feed_hole_offset", filament_feed_hole_offset);

idler_nut_trap_depth=7.5;
idler_nut_thickness=m3_nut_thickness;

gear_separation_tolerance=0.25;
gear_separation=7.4444+32.0111+gear_separation_tolerance;

echo ("distance between axles (excluding tolerance)", gear_separation-gear_separation_tolerance);

function motor_hole(hole)=[
	motor_mount_translation[0],
	motor_mount_translation[1]]+
	rotated(45+motor_mount_rotation+hole*90)*nema17_hole_spacing/sqrt(2);

// Parameters defining the idler.

filament_pinch=[
	large_wheel_translation[0]-filament_feed_hole_offset-filament_diameter/2,
	large_wheel_translation[1],
	wade_block_depth/2];
idler_axis=filament_pinch-[608_diameter/2,0,0];
idler_fulcrum_offset=608_diameter/2+3.5+m3_diameter/2;
idler_fulcrum=idler_axis-[0,idler_fulcrum_offset,0];
idler_corners_radius=4; 
idler_height=12;
idler_608_diameter=608_diameter+2;
idler_608_height=9;
idler_mounting_hole_across=8;
idler_mounting_hole_up=15;
idler_short_side=wade_block_depth-2;
idler_hinge_r=m3_diameter/2+3.5;
idler_hinge_width=6.5;
idler_end_length=(idler_height-2)+5;
idler_mounting_hole_diameter=m4_diameter+0.25;
idler_mounting_hole_elongation=1;
idler_long_top=idler_mounting_hole_up+idler_mounting_hole_diameter/2+idler_mounting_hole_elongation+2.5;
idler_long_bottom=idler_fulcrum_offset;
idler_long_side=idler_long_top+idler_long_bottom;

module bearing_washer() {
  difference() {
    cylinder(r=hole_for_608/2-0.15,h=1,$fn=64);
    translate([0,0,-1])
    cylinder(r=8,h=3,$fn=64);
  }
}

module wade(
	hotend_mount=default_extruder_mount,
	mounting_holes=default_mounting_holes)
{
	difference ()
	{
		union()
		{
			// The wade block.
			cube([wade_block_width,wade_block_height,wade_block_depth]);

			// Filler between wade block and motor mount.
			translate([10-2,0,0])
			cube([wade_block_width,
				wade_block_height,
				motor_mount_thickness]);

			// Round the ends of the base
			translate([base_length-base_leadout,0,0])
			cylinder(r=base_thickness/2,h=wade_block_depth+base_extra_depth,$fn=20);

			translate([-base_leadout,0,0])
			cylinder(r=base_thickness/2,h=wade_block_depth+base_extra_depth,$fn=20);

			//Provide the bevel betweeen the base and the wade block.
			render()
			difference()
			{
				translate([-block_bevel_r,0,0])
				cube([block_bevel_r*2+wade_block_width,
					base_thickness/2+block_bevel_r,wade_block_depth+base_extra_depth]);				
				translate([-block_bevel_r,block_bevel_r+base_thickness/2])
				cylinder(r=block_bevel_r,h=wade_block_depth+base_extra_depth,$fn=60);
				translate([wade_block_width+block_bevel_r,
					block_bevel_r+base_thickness/2])
				cylinder(r=block_bevel_r,h=wade_block_depth+base_extra_depth,$fn=60);
			}

			// The idler hinge.
			translate(idler_fulcrum)
			{
				translate([idler_hinge_r,0,0])
				cube([idler_hinge_r*2,idler_hinge_r*2,idler_short_side-2*idler_hinge_width-0.5],
					center=true);
				rotate(-30)
				{
					cylinder(r=idler_hinge_r,
						h=idler_short_side-2*idler_hinge_width-0.5,
						center=true,$fn=60);
					translate([idler_hinge_r,0,0])
					cube([idler_hinge_r*2,idler_hinge_r*2,
						idler_short_side-2*idler_hinge_width-0.5],
						center=true);
				}
			}

			// The idler hinge support.
			if (render_supports)
			translate(idler_fulcrum)
			{
				rotate(-15)
				translate([-(idler_hinge_r+3),-idler_hinge_r-2,-wade_block_depth/2])
				difference()
				{
				cube([idler_hinge_r+3,
					idler_hinge_r*2+4,
					wade_block_depth/2-
					idler_short_side/2+
					idler_hinge_width+0.25+
					layer_thickness]);
				translate([idler_hinge_r+2,(idler_hinge_r*2+4)/2,layer_thickness*3])
				cylinder(r=idler_hinge_r+1,h=10,$fn=50);
				}
				rotate(-15)
				translate([-(idler_hinge_r+3),-idler_hinge_r-2,
					-idler_short_side/2+idler_hinge_width+0.25])
				cube([idler_hinge_r+3+15,
					idler_hinge_r*2+4,
					layer_thickness]);
			}

			//The base.
			translate([-base_leadout,-base_thickness/2,0])
			cube([base_length,base_thickness,wade_block_depth+base_extra_depth]);
			//Base aligement helper
			//translate([-base_leadout,-base_thickness/2,wade_block_depth+base_extra_depth])
			//cube([base_length,1,layer_thickness]);
			

			motor_mount ();
		}

		block_holes(mounting_holes=mounting_holes);
		motor_mount_holes ();

		// the hole for the Bowden pushfit connector
		translate([large_wheel_translation[0]-filament_feed_hole_offset,
			-base_thickness/2,wade_block_depth/2])
		rotate([-90,0,0])
		{
			if (in_mask (hotend_mount,bowden_mount))
				bowden_holes ();
		}
		// AndrewBCN : small chamfer of top left corner
		translate([-1,wade_block_height+4,15/2-1]) rotate([0,0,45]) cube([10,10,15], center=true);
		if (render_bracket == true) {
		  // if using a bracket we can remove some material from the base
		  // straight cut one
		  translate([-35,-30,-1]) cube([20,40,50]);
		  // straight cut two
		  translate([-20,-15,23]) cube([90,20,20]);
		  // straight cut three
		  translate([34,-10,18]) cube([90,20,20]);
		  // diagonal cut one
		  translate([-20,5,23]) rotate([45,0,0]) cube([90,20,20]);
		  // diagonal cut two
		  translate([20,-10,32.1]) rotate([0,45,0]) cube([20,20,20]);
		  // chamfer one
		  translate([-20,-10,13]) rotate([0,-45,0]) cube([20,20,20]);
		}		
	}
	if (render_bracket == true) {
	  translate([-10,-45,0]) basic_bracket();
	}
}

function in_mask(mask,value)=(mask%(value*2))>(value-1); 

//block_holes();

module block_holes(mounting_holes=default_mounting_holes)
{
	echo("bhmh", mounting_holes);
	//Round off the top of the block. 
	translate([0,wade_block_height-block_bevel_r,-1])
	render()
	difference()
	{
		translate([-1,0,0])
		cube([block_bevel_r+1,block_bevel_r+1,wade_block_depth+2]);
		translate([block_bevel_r,0,0])
		cylinder(r=block_bevel_r,h=wade_block_depth+2,$fn=40);
	}

	// Idler fulcrum hole.
	translate(idler_fulcrum + [0, 0, render_supports ? 0.4 : -epsilon])
	cylinder(r=m3_diameter/2,h=idler_short_side-2*idler_hinge_width-0.5,center=true,$fn=16);

	translate(idler_fulcrum+[0,0,idler_short_side/2-idler_hinge_width-1])
	cylinder(r=m3_nut_diameter/2+0.25,h=1,$fn=40);

	//Rounded cutout for idler hinge.
	render()
	translate(idler_fulcrum)
	difference()
	{
		cylinder(r=idler_hinge_r+0.5,h=idler_short_side+0.5,center=true,$fn=60);
		cylinder(r=idler_hinge_r+1,h=idler_short_side-2*idler_hinge_width-0.5,center=true);
	}

	//translate(motor_mount_translation)
	translate(large_wheel_translation)
	{

			// Open the top to remove overhangs and to provide access to the hobbing.
			translate([-wade_block_width+2,0,9.5])
			cube([wade_block_width,
				wade_block_height-large_wheel_translation[1]+1,
				wade_block_depth]);
		
			translate([0,0,-1])
			b608(h=9);
		
			translate([0,0,20])
			b608(h=9);
		
			translate([-(m8_clearance_hole/2 + hole_for_608/2),0,9.5])
			b608(h=wade_block_depth);

			render()
			difference() {
			  translate([0,0,8 + (render_supports ? layer_thickness : -epsilon)])
				cylinder(r=m8_clearance_hole/2,h=wade_block_depth-(8+layer_thickness)+2);

			  // constraint for flex filament
			  *translate([
				-filament_feed_hole_offset + filament_diameter/2,
				-2,
				wade_block_depth/2
			  ])
				resize([hobbing_depth * 2, filament_diameter, filament_diameter])
				sphere(r=filament_diameter, $fn=10);

			  translate([0, 0, wade_block_depth / 2])
			  rotate_extrude()
				translate([2 + m8_clearance_hole/2 - hobbing_depth, 0])
				circle(r=2);   // m4 hobbing tap
			}

			translate([0,0,20-2])
			cylinder(r=16/2,h=wade_block_depth-(8+layer_thickness)+2);

			// Filament feed.
			translate([-filament_feed_hole_offset,-10,wade_block_depth/2])
			rotate([90,0,0])
			rotate(360/16)
			// AndrewBCN : I increased the number of facets from 8 to 16 and increased the diameter by 10%
			cylinder(r=filament_feed_hole_d*1.1/2,h=wade_block_depth*3+elevation+50,center=true,$fn=16);	

			//Widened opening for hobbed bolt access.
			translate([2,wade_block_height/2+2,wade_block_depth/2+0.2])
			rotate([90,0,0])
			rotate(-45)
			union()
			{
			cylinder(r=5,h=wade_block_height,center=true,$fn=30);	
			translate([-5,0,0])
			cube([10,10,wade_block_height],center=true);
			}

			// Mounting holes on the base.
			//translate([0,-base_thickness/2,0])
			if (render_bracket == false) {
			  translate(
				  (mounting_holes==mounting_holes_legacy)?[-3.4,0,-1]:[0,0,0])
			  for (mount=[0:1])
			  {
				  translate([-filament_feed_hole_offset+25*((mount<1)?1:-1),
					  -large_wheel_translation[1]-1-base_thickness/2,wade_block_depth/2])
				  rotate([-90,0,0])
				  rotate(360/16)
				  cylinder(r=m4_diameter/2,h=base_thickness+2,$fn=8);	
	  
				  translate([-filament_feed_hole_offset+25*((mount<1)?1:-1),
					  -large_wheel_translation[1],
					  wade_block_depth/2])
				  rotate([-90,0,0])
			  //fixme: correct height
				  //cylinder(r=m4_nut_diameter/2,h=base_thickness,$fn=6);	
				  cylinder(r=m4_nut_diameter/2,h=29.3,$fn=6);
			  }
			}

	}

	// Idler mounting holes and nut traps.
	for (idle=[-1,1])
	{
		translate([0,
			idler_mounting_hole_up+large_wheel_translation[1],
			wade_block_depth/2+idler_mounting_hole_across*idle])
		rotate([0,90,0])
		{
			rotate([0,0,180/8])
			translate([0,0,-1])
			cylinder(r=m3_diameter/2,h=wade_block_depth+6,$fn=8);	
			rotate([0,0,180/6])
			translate([0,0,wade_block_width-idler_nut_trap_depth])
			cylinder(r=m3_nut_diameter/2,h=idler_nut_thickness,$fn=6);	

			translate([0,10/2,wade_block_width-idler_nut_trap_depth+idler_nut_thickness/2])
			cube([m3_nut_diameter*cos(30),10,idler_nut_thickness],center=true);
		}
	}
}

module motor_mount()
{
	linear_extrude(height=motor_mount_thickness)
	{
		barbell (motor_hole(1),motor_hole(2),nema17_support_d/2, nema17_support_d/2,20,160);
		barbell (motor_hole(2),motor_hole(3),nema17_support_d/2, nema17_support_d/2,20,160);

		// Connect block to top of motor mount.
		barbell(block_top_right-[0,5],motor_hole(1),5,nema17_support_d/2,100,60);

		//Connect motor mount to base.
		barbell([base_length-base_leadout,
			0],motor_hole(3),base_thickness/2,
			nema17_support_d/2,100,60);
	}
}

module motor_mount_holes()
{
	radius=4/2;
	slot_left=1;
	slot_right=2;

	{
		translate([0,0,screw_head_recess_depth+(render_supports ? layer_thickness : -epsilon)])
		for (hole=[0:3])
		translate([motor_hole(hole)[0],motor_hole(hole)[1],0])
		rotate([0,0,25])
		{
			translate([-slot_left,0,0])
			cylinder(h=motor_mount_thickness + epsilon * 2-screw_head_recess_depth,r=radius,$fn=16);
			translate([slot_right,0,0])
			cylinder(h=motor_mount_thickness + epsilon * 2-screw_head_recess_depth,r=radius,$fn=16);

			translate([-slot_left,-radius,0])
			cube([slot_left+slot_right,radius*2,motor_mount_thickness + epsilon * 2-screw_head_recess_depth]);
		}

		translate([0,0,-1])
		for (hole=[0:3])
		translate([motor_hole(hole)[0],motor_hole(hole)[1],0])
		rotate([0,0,25])
		{
			translate([-slot_left,0,0])
			cylinder(h=screw_head_recess_depth+1,
				r=screw_head_recess_diameter/2,$fn=16);
			translate([slot_right,0,0])
			cylinder(h=screw_head_recess_depth+1,
				r=screw_head_recess_diameter/2,$fn=16);

			translate([-slot_left,-screw_head_recess_diameter/2,0])
			cube([slot_left+slot_right,
				screw_head_recess_diameter,
				screw_head_recess_depth+1]);
		}
	}
}

module wadeidler() 
{
    guide_height=12.3;
    guide_length=10;

    union()
    {
         // thumb saver added by Marty Rice, shape modified by AndrewBCN
	 translate(idler_axis+[-idler_height/2+2,+idler_long_side/2-idler_long_bottom,0])
         translate([-idler_height/4,20,0])
         { 
	    difference() {
	      hull() {
		translate([0,-2,idler_short_side/3]) rotate([0,90,0]) cylinder(h=idler_height/2,r=1, $fn=16, center=true);
		translate([0,-2,-idler_short_side/3]) rotate([0,90,0]) cylinder(h=idler_height/2,r=1, $fn=16, center=true);
		translate([0,3.8,idler_short_side/3-0.5]) rotate([0,90,0]) cylinder(h=idler_height/2,r=1, $fn=16, center=true);
		translate([0,3.8,-idler_short_side/3+0.5]) rotate([0,90,0]) cylinder(h=idler_height/2,r=1, $fn=16, center=true);
	      }
	      //smooth slope to "guide" the thumb
	      translate([idler_height/2+2,3.8,0]) rotate([0,0,0]) cylinder(h=idler_short_side,r=7.5, $fn=64, center=true);
	    }
	    // a small ridge to avoid the thumb slipping
	    hull() {
	      translate([idler_height/4-2.3,3.8,idler_short_side/3-1]) sphere(r=1, $fn=16);
	      translate([idler_height/4-2.3,3.8,-idler_short_side/3+1]) sphere(r=1, $fn=16);	    
	    }
         } // end of thumb saver code


	difference()
	{
		union()
		{
			//The idler block.
			translate(idler_axis+[-idler_height/2+2,+idler_long_side/2-idler_long_bottom,0])
			{
			cube([idler_height,idler_long_side,idler_short_side],center=true);

			//Filament Guide.
			translate([guide_height/2+idler_height/2-1,idler_long_side/2-guide_length/2,0])
			cube([guide_height+1,guide_length,8],center=true);
			}

			// The fulcrum Hinge
			translate(idler_fulcrum)
			rotate([0,0,-30])
			{
				cylinder(h=idler_short_side,r=idler_hinge_r,center=true,$fn=60);
				translate([-idler_end_length/2,0,0])
				cube([idler_end_length,idler_hinge_r*2,idler_short_side],center=true);
			}
		}

		//Filament Path	
		translate(idler_axis+[2+guide_height,+idler_long_side-idler_long_bottom-guide_length/2,0])
		{
		cube([7,guide_length+2,filament_diameter+0.5],center=true);
		translate([-7/2,0,0])
		rotate([90,0,0])
	    cylinder(h=guide_length+4,r=(filament_diameter+0.5)/2,center=true,$fn=16);
		}

		//Back of idler.
		translate(idler_axis+[-idler_height/2+2-idler_height,
			idler_long_side/2-idler_long_bottom-10,0])
		cube([idler_height,idler_long_side,idler_short_side+2],center=true);

		//Slot for idler fulcrum mount.
		translate(idler_fulcrum)
		{
			cylinder(h=idler_short_side-2*idler_hinge_width,
				r=idler_hinge_r+0.5,center=true,$fn=60);
			rotate(-30)
			translate([0,-idler_hinge_r-0.5,0])
			cube([idler_hinge_r*2+1,idler_hinge_r*2+1,
				idler_short_side-2*idler_hinge_width],center=true);
		}

		//Bearing cutout.
		translate(idler_axis)
		{
			difference()
			{
				cylinder(h=idler_608_height,r=idler_608_diameter/2,
					center=true,$fn=60);
				for (i=[0,1])
				rotate([180*i,0,0])
				translate([0,0,6.95/2]) // AndrewBCN: 0.05mm tolerance added here
				cylinder(r1=12/2,r2=16/2,h=2);
			}
			cylinder(h=idler_short_side-6,r=m8_diameter/2-0.25/*Tight*/,
				center=true,$fn=20);
		}

		//Fulcrum hole.
		translate(idler_fulcrum)
		rotate(180/8)
		cylinder(h=idler_short_side+2,r=m3_diameter/2-0.1,center=true,$fn=8);

		//Nut trap for fulcrum screw.
		translate(idler_fulcrum+[0,0,idler_short_side/2-idler_hinge_width-1])
		rotate(360/16)
		cylinder(h=3,r=m3_nut_diameter/2+0.2,$fn=6); // AndrewBCN: 0.2mm tolerance added here

		for(idler_screw_hole=[-1,1])
		translate(idler_axis+[2-idler_height,0,0])
		{
			//Screw Holes.
			translate([-1,idler_mounting_hole_up,
				idler_screw_hole*idler_mounting_hole_across])
			rotate([0,90,0])
			{
				cylinder(r=idler_mounting_hole_diameter/2,h=idler_height+2,$fn=16);
				translate([0,idler_mounting_hole_elongation,0])
				cylinder(r=idler_mounting_hole_diameter/2,h=idler_height+2,$fn=16);
				translate([-idler_mounting_hole_diameter/2,0,0])
				cube([idler_mounting_hole_diameter,idler_mounting_hole_elongation,
					idler_height+2]);
			}

			// Rounded corners.
			render()
			translate([idler_height/2,idler_long_top,
				idler_screw_hole*(idler_short_side/2)])
			difference()
			{
				translate([0,-idler_corners_radius/2+0.5,-idler_screw_hole*(idler_corners_radius/2-0.5)])
				cube([idler_height+2,idler_corners_radius+1,idler_corners_radius+1],
					center=true);
				rotate([0,90,0])
				translate([idler_screw_hole*idler_corners_radius,-idler_corners_radius,0])
				cylinder(h=idler_height+4,r=idler_corners_radius,center=true,$fn=40);
			}
		}
	}
    }
}

module b608(h=8)
{
	translate([0,0,h/2]) cylinder(r=hole_for_608/2,h=h,center=true,$fn=60);
}

module barbell (x1,x2,r1,r2,r3,r4) 
{
	x3=triangulate (x1,x2,r1+r3,r2+r3);
	x4=triangulate (x2,x1,r2+r4,r1+r4);
	render()
	difference ()
	{
		union()
		{
			translate(x1)
			circle (r=r1);
			translate(x2)
			circle(r=r2);
			polygon (points=[x1,x3,x2,x4]);
		}
		
		translate(x3)
		circle(r=r3,$fa=5);
		translate(x4)
		circle(r=r4,$fa=5);
	}
}

function triangulate (point1, point2, length1, length2) = 
point1 + 
length1*rotated(
atan2(point2[1]-point1[1],point2[0]-point1[0])+
angle(distance(point1,point2),length1,length2));

function distance(point1,point2)=
sqrt((point1[0]-point2[0])*(point1[0]-point2[0])+
(point1[1]-point2[1])*(point1[1]-point2[1]));

function angle(a,b,c) = acos((a*a+b*b-c*c)/(2*a*b)); 

function rotated(a)=[cos(a),sin(a),0];

//========================================================
// Modules for different extension brackets

module basic_bracket() {
  // AndrewBCN : the following is sample code that defines an optional basic bracket
  // that allows mounting the extruder, for example, to an extruded aluminum frame
  // (such as in a Kossel linear delta 3D printer).
  $fn=64;
  b_b_thickness = 4.3;
  difference() {
    union() {
      // bracket main block with rounded corners
      hull() {
        translate([-4.95,40,0]) cylinder(r=0.05, h=b_b_thickness);
        translate([46.5+4.95,40,0]) cylinder(r=0.05, h=b_b_thickness);
        translate([0,18.5,0]) cylinder(r=5, h=b_b_thickness);
        translate([46.5,0,0]) cylinder(r=5, h=b_b_thickness);
      }
      // reinforcements
      translate([48.5,28.5,4]) difference() {
        translate([0,0,0]) cube([3,12,12]);
        translate([-0.1,0,0.5]) rotate([45,0,0]) cube([3.5,20,12]);
      }
      translate([-5,28.5,4]) difference() {
        translate([0,0,0]) cube([3,12,12]);
        translate([-0.1,0,0.5]) rotate([45,0,0]) cube([3.5,20,12]);
      }
      // PTFE tube strain relief
      translate([11.7,10,4]) difference() {
        translate([0,0,0]) cube([12,8,10.5]);
        // PTFE tube rest
        translate([6,9,10.5]) rotate([90,0,0]) cylinder(r=2.4, h=10);
        // zip tie tunnel
        translate([-1,2.4,3.5]) cube([15,3.2,2.2]);
      }      
    }
    // holes in the bracket
    // M5 holes to attach to printer frame
    translate([2.8,21.3,-1]) cylinder(r=2.6, h=10);
    translate([43.8,4.8,-1]) cylinder(r=2.6, h=10);
    // big round holes for e.g. passing cables
    translate([17,32,-1]) cylinder(r=5, h=10);
    translate([38,32,-1]) cylinder(r=5, h=10);
    // pair of rectangular holes for zip tie
    translate([25,27.5,-1]) cube([5.5,2,10]);
    translate([25,34.5,-1]) cube([5.5,2,10]);
  }
}

//========================================================
// Modules for defining holes for hotend mounts:
// These assume the extruder is vertical with the bottom filament exit hole at [0,0,0].
// AndrewBCN : we only need to define the hole for the Bowden pushfit connector

//bowden_holes ();
module stretch(translation)
{
	children ();

	translate (translation)
	children ();
}
module bowden_holes ()
{
	if (bowden_type == "pushfit") {
		bowden_d_tolerance = 0.2; // extra tolerance so that the Bowden pushfit connector threads in
		extruder_recess_d=bowden_pushfit_d + bowden_d_tolerance;
		extruder_recess_h=bowden_pushfit_thread;

		// Recess in base
		translate([0,0,-1])
		cylinder(r=extruder_recess_d/2,h=extruder_recess_h+1, $fn=32);

	} else if (bowden_type == "nut") {
		// bowden tube
		translate([0, 0, -1])
		cylinder(r=2.4, h=10, $fn=32);

		// m4 nut recess
		translate ([0, 0, -epsilon])
		cylinder (d=m4_nut_diameter, h=m4_nut_thickness - 0.5, $fn=6);

		// screw holes for bowden capture plate
		for (x = [1, -1] * 10)
		translate ([x, 0, -epsilon]) {
			cylinder(d=m3_diameter, h=15, $fn=20);

			translate ([0, 0, 3])
			hull ()
			stretch ([0, -100, 0])
			rotate ([0, 0, 90])
			cylinder (d=m3_nut_diameter, h=m3_nut_thickness, $fn=6);
		}
	}
}

module bowden_clamp ()
{
	difference () {
		hull ()
		for (x=[1, -1] * 10)
		translate ([x, 0, 0])
		cylinder (r=6, h=6, $fn=32);

		translate ([0, 0, -epsilon]) {
			hull ()
			stretch ([0, 100, 0])
			cylinder (r=2.4, h=20, $fn=32);

			for (x=[1, -1] * 10)
			translate ([x, 0, 0])
			cylinder (r=m3_diameter/2, h=10, $fn=20);
		}
	}
}
