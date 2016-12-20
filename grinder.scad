// cone_top_diameter is more sensitive
// due to lower resolution (diameter instead of circumference)
// try increasing it slightly first...
cone_top_diameter = 130;
cone_bottom_circumference = 470;
cone_bottom_inset = 16.75;

height = 144;
cylinder_diameter = 123;

cone_bottom_radius = cone_bottom_circumference / (2 * PI);
cone_top_radius = cone_top_diameter / 2;
cylinder_radius = cylinder_diameter / 2;

module grinder(){
    cylinder(r1=cone_bottom_radius, r2=cone_top_radius , h=height, $fn=100);
}

// I'm using the receptacle to intersect with, so I changed it's height
// to half the plate's height, and gave it a top and bottom to form the ledges.
module receptacle(){
    difference(){
        cylinder(r=cylinder_radius, h=height/2, $fn=100);
        translate([0, 0, 2])
            cylinder(r=cylinder_radius-2, h=height/2-4, $fn=100);
    }
}

module plate_top(){
    difference(){
        translate([0, -cone_bottom_inset/2, 0])
        intersection(){
            translate([0, cone_bottom_radius, 0])
                grinder();
            translate([0, -cylinder_radius+1 + cone_bottom_inset, 0])
                receptacle();
        }
        union(){
            // round hole
            cylinder(r=3.5, h=4, center=true, $fn=100);
            // chute hole
            translate([0, 0, 89+11.75])
                cube([20, 100, 23.5], center=true);
        }
    }
}

module plate_bottom(){
    difference(){
        translate([0, -cone_bottom_inset/2, 0])
        intersection(){
            translate([0, cone_bottom_radius, 0])
                grinder();
            translate([0, -cylinder_radius+1 + cone_bottom_inset, height/2])
                receptacle();
        }
        union(){
            // round hole
            cylinder(r=3.5, h=4, center=true, $fn=100);
            // chute hole
            translate([0, 0, 89+11.75])
                cube([20, 100, 23.5], center=true);
        }
    }
}

plate_bottom();
plate_top();
