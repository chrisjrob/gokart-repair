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

// Extrusion width in mm
printer_extrusion_width = 0.6; //mm

// Nut parameters
// What you need is the diameter of the circle around the nut
// a. you may enter the nut size (i.e. the spanner size):
nut_size             = 23.10; //mm - the nut "spanner" size
// b. or you may enter the nut diameter (which will always be twice once of the side lengths):
nut_diameter         = (((nut_size/2) / cos(30)) + printer_extrusion_width) *2; //mm - this is the circular diameter not nut size
// nut_diameter      = 27; //mm - uncomment line to over-ride calculation from nut size

// Base parameters
base_diameter_large  = 90; //mm
base_diameter_small  = 83; //mm

// Core parameters
core_diameter_large  = base_diameter_large/2; //mm
core_diameter_small  = nut_diameter + 10; //mm
core_height          = 35; //mm

// Other parameters
hole_diameter        = 5; //mm
washer_diameter      = 10; //mm
pin_diameter         = 0.3; //mm
circular_precision   = 100;
layer_height         = 0.3; //mm
shim                 = 0.1; //mm

// Selection:
// 1 = the whole thing
// 2 = nut test - for checking actual size of nut hole
select = 1;

module repair() {

    difference() {

        // Things that exist
        union() {
            // The core - the cone part that will contain the nut
            translate( v = [0, 0, 0] ) {
                cylinder( r1 = base_diameter_large/2, r2 = core_diameter_small/2, core_height, $fn = circular_precision );
            }
        }

        // Things that don't exist
        union() {
            // The nut hole
            translate( v = [0, 0, +shim] ) {
                cylinder( r = nut_diameter/2, h = core_height, $fn = 6 );
            }
            // Chamferring nut entrance
            translate( v = [0, 0, core_height - 3]) {
                cylinder(r2=nut_diameter/2 + 3,r1=nut_diameter/2,h=3+shim,$fn=6);
            }
            if (select == 1) {
                // Bolt holes and washers around base
                for (a = [0 : 60 : 360] ) {
                    rotate( a = [0, 0, a] ) {
                        // Bolt holes
                        translate( v = [ (base_diameter_small - (base_diameter_small - core_diameter_large)/2)/2, 0, -shim] ) {
                            cylinder( r = hole_diameter/2, core_height + 0.2, $fn = circular_precision );
                        }
                        // Washer holes
                        translate( v = [ (base_diameter_small - (base_diameter_small - core_diameter_large)/2)/2 +washer_diameter/3, 0, core_height * 0.3] ) {
                            scale([ 1, 1, 1 ]) {
                                cylinder( r1 = washer_diameter, r2 = washer_diameter * 1.5, core_height + 0.2, $fn = circular_precision );
                            }
                        }
                    }
                }
                // Strengthening pin holes
                for (a = [30 : 60 : 360] ) {
                    rotate( a = [0, 0, a] ) {
                        for (y = [-nut_diameter/4 : nut_diameter/8 : nut_diameter/4] ) {
                            translate( v = [ core_diameter_small * 0.43, y, layer_height] ) {
                                # cylinder( r = pin_diameter/2, core_height - layer_height * 2, $fn = circular_precision );
                            }
                        }
                    }
                }
            }
        }
    
    }

}

if (select == 1) {
    repair();
}

if (select == 2) {
    difference() {
        union() {
            translate( [0, 0, -core_height * 0.85] ) {
                repair();
            }
        }
        union() {
            translate( [-base_diameter_large/2, -base_diameter_large/2, -core_height] ) {
                # cube( [base_diameter_large, base_diameter_large, core_height] );
            }
        }
    }
}

