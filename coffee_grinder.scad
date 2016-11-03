/*
   all units are in mm, things that fell in between a mm line will be noted in a comment
   
   the outside vertical pieces are the same on each side
   the horizontal parts are different sizes 
   
   the entire piece is mirrored around the horizontal center
   
   most of these variables are a result of my measurements of the segments, convenience identifiers below that for easier
   polyhedron definition
 */
outsideVerticalUpper = 11;
outsideVerticalMiddle = 44;
outsideVerticalLower = 89; // minus a hair - 88.8?

outsideHorizontalLower = 56; // plus a hair - 56.2?
outsideHorizontalUpper = 41;

// these chute horizontal sizes aren't actually important but it might be nice to use them to double check that my measurements were correct
// i.e. if the resulting polyhedron isn't this width at this location, I goofed.
chuteHorizontalLower = 47.5; 
chuteHorizontalUpper = 42.5;

// the chute is rectangular
chuteHorizontalInner = 20;
chuteVerticalInner = 23.5;

thickness = 2;

// convenience identifiers 
upper_horizontal_offset = (outsideHorizontalLower - outsideHorizontalUpper) / 2;

plate_front = 0;
plate_back = thickness;
plate_top = outsideVerticalUpper + outsideVerticalMiddle + outsideVerticalLower;
plate_bottom = 0;
plate_bottom_left = 0;
plate_bottom_right = plate_bottom_left + outsideHorizontalLower;
plate_top_left = plate_bottom_left + upper_horizontal_offset;
plate_top_right = outsideHorizontalUpper + upper_horizontal_offset;

middle = outsideHorizontalLower / 2;

chute_vertical_offset = (outsideVerticalMiddle - chuteVerticalInner) / 2;

chute_lower = outsideVerticalLower + chute_vertical_offset;
chute_upper = outsideVerticalLower + outsideVerticalMiddle - chute_vertical_offset;
chute_left = middle - (chuteHorizontalInner / 2);
chute_right = middle + (chuteHorizontalInner / 2);
chute_front = plate_front;
chute_back = plate_back;


plate_points = [
    [plate_bottom_left, plate_front, plate_bottom], // front bottom left [0]
    [plate_bottom_right, plate_front, plate_bottom], // front bottom right [1]
    [plate_bottom_right, plate_back, plate_bottom], // back bottom right [2]
    [plate_bottom_left, plate_back, plate_bottom], // back bottom left [3]
    [plate_top_left, plate_front, plate_top], // front top left [4]
    [plate_top_right, plate_front, plate_top], // front top right [5]
    [plate_top_right, plate_back, plate_top], // back top right [6]
    [plate_top_left, plate_back, plate_top] // back top left [7]
];

plate_faces = [
    [0, 1, 2, 3], // bottom
    [4, 5, 1, 0], // front
    [7, 6, 5, 4], // top
    [5, 6, 2, 1], // right
    [6, 7, 3, 2], // back
    [7, 4, 0, 3]  // left
];

chute_deduction_points = [
    [chute_left, chute_front, chute_lower], // front bottom left [0]
    [chute_right, chute_front, chute_lower], // front bottom right [1]
    [chute_right, chute_back, chute_lower], // back bottom right [2]
    [chute_left, chute_back, chute_lower], // back bottom left [3]
    [chute_left, chute_front, chute_upper], // front top left [4]
    [chute_right, chute_front, chute_upper], // front bottom right [5]
    [chute_right, chute_back, chute_upper], // back bottom right [6]
    [chute_left, chute_back, chute_upper], // back bottom left [7]
];

chute_deduction_faces = [
    [0, 1, 2, 3], // bottom
    [4, 5, 1, 0], // front
    [7, 6, 5, 4], // top
    [5, 6, 2, 1], // right
    [6, 7, 3, 2], // back
    [7, 4, 0, 3]  // left
];
difference() {
    polyhedron(plate_points, plate_faces);
    polyhedron(chute_deduction_points, chute_deduction_faces);
}