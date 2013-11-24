// gokart-repair.scad
// OpenSCAD Document
// 
// Copyright (C) 2013 Christopher Roberts
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

// Nut parameters
nut_diameter         = 27; //mm - this is the circular diameter not nut size
cnut_diameter        = 28; //mm - this is the circular diameter not nut size

// Base parameters
base_height          = 5;  //mm
base_diameter_large  = 90; //mm
base_diameter_small  = 82; //mm

// Core parameters
core_diameter_large  = base_diameter_large/2; //mm
core_diameter_small  = nut_diameter + 10; //mm
core_height          = 30; //mm

// Buttress parameters
buttress_width       = 4; //mm

// Other parameters
hole_diameter        = 5; //mm
circular_precision   = 100;

module buttress(r1, r2, h, b) {

    difference() {

        // Things that exist
        union() {
            cylinder( r1 = r1, r2 = r2, h, $fn = circular_precision );
        }

        // Things that don't exist
        union() {
            translate( v = [-r1, b/2, -0.1] ) {
                cube( size = [ r1*2, r1*2, h + 0.2] );
            }
            translate( v = [-r1, -b/2, -0.1] ) {
                mirror([ 0, 1, 0 ]) {
                    cube( size = [ r1*2, r1*2, h + 0.2] );
                }
            }
            translate( v = [-r1*2, -r1, -0.1] ) {
                cube( size = [ r1*2, r1*2, h + 0.2] );
            }

        }
    
    }

}

module repair() {

    difference() {

        // Things that exist
        union() {
            cylinder( r1 = base_diameter_large/2, r2 = base_diameter_small/2, base_height, $fn = circular_precision );
            translate( v = [0, 0, base_height] ) {
                cylinder( r1 = core_diameter_large/2, r2 = core_diameter_small/2, core_height, $fn = circular_precision );
            }
            for (a = [30 : 60 : 360] ) {
                rotate( a = [0, 0, a] ) {
                    buttress( base_diameter_large/2, core_diameter_small/2, base_height + core_height, buttress_width );
                }
            }
            // translate( v = [0, -23/2, base_height + core_height - 23/2] ) {
            //     cube( size = [ 10, 23, 23] );
            // }

        }

        // Things that don't exist
        union() {
            translate( v = [0, 0, base_height +0.1] ) {
                nut(nut_diameter/2, core_height);
            }
            // Chamferring for nut entrance
            for (a = [30 : 60 : 360] ) {
                rotate( a = [0, 0, a] ) {
                    translate( v = [-cnut_diameter/2, -cnut_diameter/4 *1.15, base_height + core_height] ) {
                        rotate( a = [0, 45, 0] ) {
                            cube( size = [cnut_diameter/8,cnut_diameter/2 *1.15,cnut_diameter/16] );
                        }
                    }
                }
            }
            // Bolt holes
            for (a = [0 : 60 : 360] ) {
                rotate( a = [0, 0, a] ) {
                    translate( v = [ (base_diameter_small - (base_diameter_small - core_diameter_large)/2)/2, 0, -0.1] ) {
                        cylinder( r = hole_diameter/2, base_height + 0.2, $fn = circular_precision );
                    }
                }
            }
        }
    
    }

}

module nut(r,h) {

    difference() {

        // Things that exist
        union() {
            cylinder( r = r, h = h, $fn = 6 );
        }

    }

}

repair();

// -------------------------------------------------------------------------------------------
// Commands
// -------------------------------------------------------------------------------------------

// http://en.wikibooks.org/wiki/OpenSCAD_User_Manual

// primitives
// cube(size = [1,2,3], center = true);
// sphere( r = 10, $fn=100 );
// circle( r = 10 );
// cylinder( h = 10, r = 20, $fs = 6, center = true );
// cylinder( h = 10, r1 = 10, r2 = 20, $fs = 6, center = false );
// polyhedron(points = [ [x, y, z], ... ], triangles = [ [p1, p2, p3..], ... ], convexity = N);
// polygon(points = [ [x, y], ... ], paths = [ [p1, p2, p3..], ... ], convexity = N);

// transormations
// scale(v = [x, y, z]) { ... }
// rotate(a=[0,180,0]) { ... }
// translate(v = [x, y, z]) { ... }
// mirror([ 0, 1, 0 ]) { ... }

// rounded box by combining a cube and single cylinder
// $fn=50;
// minkowski() {
//   cube([10,10,1]);
//   cylinder(r=2,h=1);
// }

// hull() {
//   translate([15,10,0]) circle(10);
//   circle(10);
// }

// linear_extrude(height=1, convexity = 1) import("tridentlogo.dxf");
// deprecated - dxf_linear_extrude(file="tridentlogo.dxf", height = 1, center = false, convexity = 10);
// deprecated - import_dxf(file="design.dxf", layer="layername", origin = [100,100], scale = 0.5);
// linear_extrude(height = 10, center = true, convexity = 10, twist = 0, $fn = 100)
// rotate_extrude(convexity = 10, $fn = 100)
// import_stl("example012.stl", convexity = 5);

// for (z = [-1, 1] ) { ... } // two iterations, z = -1, z = 1
// for (z = [ 0 : 5 ] ) { ... } // range of interations step 1
// for (z = [ 0 : 2 : 5 ] ) { ... } // range of interations step 2

// for (i = [ [ 0, 0, 0 ], [...] ] ) { ... } // range of rotations or vectors
// usage say rotate($i) or translate($i)
// if ( x > y ) { ... } else { ... }
// assign (angle = i*360/20, distance = i*10, r = i*2)

// text http://www.thingiverse.com/thing:25036
// inkscape / select all items
// objects to path
// select the object to export
// extensions / generate from path / paths to openscad

