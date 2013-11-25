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
base_diameter_small  = 83; //mm

// Core parameters
core_diameter_large  = base_diameter_large/2; //mm
core_diameter_small  = nut_diameter + 10; //mm
core_height          = 30; //mm

// Buttress parameters
buttress_width       = 4; //mm

// Other parameters
hole_diameter        = 5; //mm
circular_precision   = 100;
shim                 = 0.1; //mm

module buttress(r1, r2, h, b) {

    difference() {

        // Things that exist
        union() {
            cylinder( r1 = r1, r2 = r2, h, $fn = circular_precision );
        }

        // Things that don't exist
        union() {
            translate( v = [-r1, b/2, -shim] ) {
                cube( size = [ r1*2, r1*2, h + 0.2] );
            }
            translate( v = [-r1, -b/2, -shim] ) {
                mirror([ 0, 1, 0 ]) {
                    cube( size = [ r1*2, r1*2, h + 0.2] );
                }
            }
            translate( v = [-r1*2, -r1, -shim] ) {
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
            translate( v = [0, 0, base_height +shim] ) {
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
                    translate( v = [ (base_diameter_small - (base_diameter_small - core_diameter_large)/2)/2, 0, -shim] ) {
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

