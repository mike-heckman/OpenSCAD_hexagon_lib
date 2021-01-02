CONST_HEX_APOTHEM = sqrt(3)/2;

/*
 Create a solid cube with all complete or partial hexagons removed.

 width:     maximum distance in the x plane to create hexagons
 depth:     maximum distance in the y plane to create hexagons
 radius:    maximum width of the hexagon from vertex to vertex
 height:    the height of each hexagon
 thickness: the wall thickness for each hexagon
*/
module hex_sheet_cutout(width, depth, radius, height, thickness) {
    cheat = $preview ? 0.002 : 0; // deal with z fighting during preview
    excess = radius * 3;
    difference() {
        cube([width, depth, height]);
        translate([-radius,-radius,cheat*-0.5]) hex_sheet(width+excess, depth+excess, radius, height+cheat, thickness);
    }
}

/*
 Create a solid cube with all complete hexagons removed.

 width:     maximum distance in the x plane to create hexagons
 depth:     maximum distance in the y plane to create hexagons
 radius:    maximum width of the hexagon from vertex to vertex
 height:    the height of each hexagon
 thickness: the wall thickness for each hexagon
*/
module hex_sheet_cutout_whole(width, depth, radius, height, thickness) {
    cheat = $preview ? 0.002 : 0; // deal with z fighting during preview

    difference() {
        cube([width, depth, height]);
        translate([0,0,cheat*-0.5]) hex_sheet_constrained(width, depth, radius, height+cheat, thickness);
    }
}

/*
 Create a matrix of hexagons that fit entirely or partially in the width and depth provided

 width:     maximum distance in the x plane to create hexagons
 depth:     maximum distance in the y plane to create hexagons
 radius:    maximum width of the hexagon from vertex to vertex
 height:    the height of each hexagon
 thickness: the wall thickness for each hexagon
*/
module hex_sheet(width, depth, radius, height, thickness) {
    apothem = radius * CONST_HEX_APOTHEM;
    min_R = (apothem * 2 + thickness)/2;
    offset_x = sqrt(3)*min_R;

    // first line
    for (x=[0:offset_x*2:depth]) {
        translate([x,0,0]) hex_line(width, radius, height, thickness);
    }
    // ofset line
    for (x=[offset_x:offset_x*2:depth]) {
        translate([x,min_R,0]) hex_line(width, radius, height, thickness);
    }
}

/*
 Create a matrix of hexagons that fit entirely in the width and depth provided

 width:     maximum distance in the x plane to create hexagons
 depth:     maximum distance in the y plane to create hexagons
 radius:    maximum width of the hexagon from vertex to vertex
 height:    the height of each hexagon
 thickness: the wall thickness for each hexagon

*/
module hex_sheet_constrained(width, depth, radius, height, thickness) {
    apothem = radius * CONST_HEX_APOTHEM;
    min_R = (apothem * 2 + thickness)/2;
    offset_x = sqrt(3)*min_R;

    maxdepth = (floor((depth) / apothem) * apothem) + thickness;
    maxwidth = (floor((width) / apothem) * apothem) + thickness - apothem;

    // first line
    for (x=[radius:offset_x*2:maxdepth-offset_x]) {
        translate([x,0,0]) hex_line(maxwidth, radius, height, thickness);
    }
    // ofset line
    for (x=[radius+offset_x:offset_x*2:maxdepth-offset_x]) {
        translate([x,min_R,0]) hex_line(maxwidth, radius, height, thickness);
    }
}

/*
 Create a line of hexagons for /distance/ y

 distance:  maximum distance in the y plane to create hexagons
 radius:    maximum width of the hexagon from vertex to vertex
 height:    the height of each hexagon
 thickness: the wall thickness for each hexagon
*/
module hex_line(distance, radius, height, thickness) {
    apothem = radius * CONST_HEX_APOTHEM;
    advance = (apothem * 2) + thickness;

    for (y=[apothem:advance:distance-apothem]) {
        translate([0,y,0]) hex(radius, height);
    }
}

/*
 Create a hollow hexagon with the specified thickness.

 radius:    maximum width of the hexagon from vertex to vertex
 height:    the height of each hexagon
 thickness: the wall thickness for each hexagon
*/
module hex_hollow(radius, height, thickness) {
    cheat = $preview ? 0.002 : 0; // deal with z fighting during preview
    
    difference() {
        hex(radius+thickness, height);
        translate([0,0,cheat*-0.5]) hex(radius, height+cheat);
    }
}

/*
 Create a single hexagon

 radius:    maximum width of the hexagon from vertex to vertex
 height:    the height of each hexagon
*/
module hex(radius, height) {
    cylinder(r=radius, h=height, $fn=6);
}

