line_one =    "Kai Parthy";
line_two =    "Laywoo Meta5";
line_three =  "Wood";
notes_three = "";


layer_height = 0.2;
first_layer_height = 0.25;

w=79.5; 
h=30;
th=2.15;

line_one_font = "The Bold Font";
line_one_size = 4.8;
line_one_margin = 1;

line_two_font = "The Bold Font";
line_two_size = 4.8;
line_two_margin = 1;

line_three_font = "The Bold Font";
line_three_size = 4.8;
line_three_margin = 1;

notes_three_font = "The Bold Font";
notes_three_size = 4.8;
notes_three_margin = 1;

// The size of the little finger-notches to make removal easier.
// Set to zero to hide.
finger_size = 1.5;

// Width of the outer border.
border = 2;

// The depth of the recess. Should be a multiple of the layer height.
depth = layer_height*2;

// Cut out the layer step indents.
show_steps = "yes"; // Set to "no" to hide.
steps_width = w*1; // Total width of the indents. If 0, fefaults to full width.
steps_height = 5; // Height of the indents, similar to the text height.

// Cut a hanger loop
hanger_size = 0; // Set to 0 to hide.

circle_fn=80;
j = 0.01;

module RoundCube(size, roundness) {
    hull() {
        translate([roundness, roundness, 0])
        cylinder(r=roundness, h=size[2], $fn=circle_fn);
        
        translate([size[0]-roundness, roundness, 0])
        cylinder(r=roundness, h=size[2], $fn=circle_fn);

        translate([roundness, size[1]-roundness, 0])
        cylinder(r=roundness, h=size[2], $fn=circle_fn);

        translate([size[0]-roundness, size[1]-roundness, 0])
        cylinder(r=roundness, h=size[2], $fn=circle_fn);
    }    
}

module Base() {
    small_roundness = 0.2;
    corner_roundness = 5;
    corner_positionTL = [border+small_roundness, h-border-small_roundness];
    corner_positionTR = [w-border-small_roundness, h-border-small_roundness];
    corner_positionBL = [border+corner_roundness, border+corner_roundness];
    corner_positionBR = [w-border-corner_roundness, border+corner_roundness];

    difference() {
        hull() {
            // Main body of the swatch

            // Top-left corner
            translate(corner_positionTL)
            cylinder(r=small_roundness+border, h=th, $fn=circle_fn);

            // Top-right corner
            translate(corner_positionTR)
            cylinder(r=small_roundness+border, h=th, $fn=circle_fn);

            // Bottom-left corner
            translate(corner_positionBL)
            cylinder(r=corner_roundness+border, h=th, $fn=circle_fn);

            // Bottom-right corner
            translate(corner_positionBR)
            cylinder(r=corner_roundness+border, h=th, $fn=circle_fn);
        }

        // Remove the space that forms the indentation
        hull() {
            // Top-left corner
            translate([0, 0, th-depth])
            translate(corner_positionTL)
            cylinder(r=small_roundness, h=depth+j, $fn=circle_fn);
            
            // Top-right corner
            translate([0, 0, th-depth])
            translate(corner_positionTR)
            cylinder(r=small_roundness, h=depth+j, $fn=circle_fn);
            
            // Bottom-left corner
            translate([0, 0, th-depth])
            translate(corner_positionBL)
            cylinder(r=corner_roundness, h=depth+j, $fn=circle_fn);

            // Bottom-right corner
            translate([0, 0, th-depth])
            translate(corner_positionBR)
            cylinder(r=corner_roundness, h=depth+j, $fn=circle_fn);
        }

        // Remove the finger grips
        if(finger_size > 0) {
            translate([0, h-5, -j])
            scale([0.8, 1, 1])
            cylinder(r=finger_size, h=th+j+j, $fn=circle_fn);

            translate([w, h-5, -j])
            scale([0.8, 1, 1])
            cylinder(r=finger_size, h=th+j+j, $fn=circle_fn);
        }

        // Cut a hole for a string or something
        if(hanger_size > 0) {
            translate([hanger_size/2, -hanger_size/2, -j])
            translate(corner_positionTL)
            cylinder(r=hanger_size/2, h=th, $fn=circle_fn);
        }

        // Make some thickness steps
        if(show_steps=="yes") {
            // number of steps is one per layer
            steps = (th-depth)/layer_height;
            step_width = ((steps_width/w) * (w-corner_roundness*2-border*2))/steps;

            color("purple")
            translate([corner_roundness+border, border*2, 0])
            union() {
                for(i = [0:steps-1]) {
                    hole_start = (first_layer_height * min(1, i)) + (max(0, (i-1)*layer_height));

                    translate([i*step_width, 0, hole_start-j])
                    RoundCube([step_width+j, steps_height, th+j+j], 0.5);
                }
            }
        }
    }
}

module TextMain(text) {
    color("DarkRed")
    linear_extrude(height=depth,convexity = 10)
    text(text, size=line_one_size, font=line_one_font, halign="right", valign="bottom");
}

module Textline_two(text) {
    color("Orange")
    linear_extrude(height=depth,convexity = 10)
    text(text, size=line_two_size, font=line_two_font, halign="right", valign="bottom");
}

module Textline_three(text) {
    color("DarkBlue")
    linear_extrude(height=depth,convexity = 10)
    text(text, size=line_two_size, font=line_two_font, halign="right", valign="bottom");
}

module Textnotes_three(text) {
    color("Pink")
    linear_extrude(height=depth,convexity = 10)
    text(text, size=notes_three_size, font=notes_three_font, halign="left", valign="bottom");
}


Base();

line_one_y = h-border-line_one_size-line_one_margin;
line_two_y = line_one_y-line_one_margin-line_two_size;
line_three_y = line_two_y-line_two_margin-line_three_size;

if(line_one != "") {
    translate([w-border-line_one_margin, line_one_y, th-depth-j])
    TextMain(line_one);
}

if(line_two != "") {
    translate([w-border-line_two_margin, line_two_y, th-depth-j])
    Textline_two(line_two);
}

if(line_three != "") {
    translate([w-border-line_three_margin, line_three_y, th-depth-j])
    Textline_three(line_three);
}

if(notes_three != "") {
    translate([border+notes_three_margin, line_three_y, th-depth-j])
    Textnotes_three(notes_three);
}