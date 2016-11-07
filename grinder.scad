// range from 0 to 30 by 1 degree
start = 0.5;
end = 8;
angle_from_vert=start + (end-start) * $t;

bottom_width = 56;
top_width = 41;
height = 144;
chute_width = 20;
chute_height = 23.5;
chute_offset = 89;

module flat_plate(thickness = 1){
    linear_extrude(thickness)
    difference(){
        polygon([ // names below are when facing in +Y direction
            [-bottom_width/2, 0],   // bottom left
            [bottom_width/2, 0],    // bottom right
            [top_width/2, height],  // top right
            [-top_width/2, height]  // top left
        ]);
        translate([0, chute_height/2 + chute_offset])
            square([chute_width, chute_height], true);
    }
}

module grinder(plate_top_width, plate_bottom_width, plate_height, angle_from_vert){
    echo("grinder plate angle=", angle_from_vert);
    // top view
    //           ^---------yc = center of circles
    //          /|\
    //         / | \
    //        /  |  \
    //       /---+---\--+--yt = top
    //      /    |   |\ | 
    //     /-----+---+-\|--yb = bottom (= 0)
    //              xt  xb
    xt = plate_top_width / 2;
    yt = plate_height * sin(angle_from_vert);
    zt = plate_height * cos(angle_from_vert);
    xb = plate_bottom_width / 2;
    yb = 0;
    zb = 0;
    xc = 0;
    yc = yt / (xb - xt) * xb;
    rt = sqrt((plate_top_width / 2)*(plate_top_width / 2) + (yc-yt)*(yc-yt));
    rb = sqrt((plate_bottom_width / 2)*(plate_bottom_width / 2) + yc*yc);
    echo("top circumference=", 2*PI*rt, "top diameter=", 2*rt, "top radius=", rt);
    echo("bottom circumference=", 2*PI*rb, "bottom diameter=", 2*rb, "bottom radius=", rb);
    translate([0, yc, 0])
        cylinder(r1=rb, r2=rt, h=zt, $fn=100);
}

function sq(x) = pow(x, 2);

module receptacle(plate_top_width, plate_bottom_width, plate_height, angle_from_vert, solid = false){
    echo("receptacle plate angle=", angle_from_vert);
    // top view
    //       /-----+-----\--+--yt = top
    //      / \    |     |\ | 
    //     /---\---+-----+-\|--yb = bottom (= 0)
    //      `   \  |    xt  xb
    //        `  \ |
    //          ` \|
    //            `v-----------yc = center of circle
    xt = plate_top_width / 2;
    yt = plate_height * sin(angle_from_vert);
    zt = plate_height * cos(angle_from_vert);
    xb = plate_bottom_width / 2;
    yb = 0;
    zb = 0;
    xc = 0;
    // sq(r) = sq(-yc+yt) + sq(xt) = sq(-yc) + sq(xb)
    // sq(yc) - 2*yc*yt + sq(yt) + sq(xt) = sq(yc) + sq(xb)
    // -2*yc*yt + sq(yt) + sq(xt) = sq(xb)
    // yc = (sq(xb) - sq(yt) - sq(xt)) / (-2yt)
    yc = (sq(xb) - sq(yt) - sq(xt)) / (-2*yt);
    r = sqrt(sq(yc) + sq(xb));
    echo("bottom circumference=", 2*PI*r, "bottom diameter=", 2*r, "bottom radius=", r);
    translate([0, yc, 0])
    if (solid) {
        cylinder(r=r, h=zt, $fn=100);
    } else {
        difference(){
            cylinder(r=r, h=zt, $fn=100);
            cylinder(r=r - 2, h=zt, $fn=100);
        }
    }
}

color("red")
rotate([90-angle_from_vert, 0, 0])
    flat_plate();

color("green")
//difference(){
intersection(){
    grinder(top_width, bottom_width, height, angle_from_vert);
    receptacle(top_width, bottom_width, height, angle_from_vert, solid=false);
}

