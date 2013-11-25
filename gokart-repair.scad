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
            // Start with a cone shape created using cylinder
            cylinder( r1 = r1, r2 = r2, h, $fn = circular_precision );
        }

        // Things that don't exist
        union() {
            // Remove first one side
            translate( v = [-r1, b/2, -shim] ) {
                cube( size = [ r1*2, r1*2, h + 0.2] );
            }

            // And then the other
            translate( v = [-r1, -b/2, -shim] ) {
                mirror([ 0, 1, 0 ]) {
                    cube( size = [ r1*2, r1*2, h + 0.2] );
                }
            }

            // Finally halve the remaining slice of cone - to create the final buttress
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
            // The base
            cylinder( r1 = base_diameter_large/2, r2 = base_diameter_small/2, base_height, $fn = circular_precision );

            // The core - the cone part that will contain the nut
            translate( v = [0, 0, base_height] ) {
                cylinder( r1 = core_diameter_large/2, r2 = core_diameter_small/2, core_height, $fn = circular_precision );
            }

            // The buttresses
            for (a = [30 : 60 : 360] ) {
                rotate( a = [0, 0, a] ) {
                    buttress( base_diameter_large/2, core_diameter_small/2, base_height + core_height, buttress_width );
                }
            }

        }

        // Things that don't exist
        union() {
            // The nut hole
            translate( v = [0, 0, base_height +shim] ) {
                cylinder( r = nut_diameter/2, h = core_height, $fn = 6 );
            }
            // Chamferring nut entrance
            translate( v = [0, 0, base_height + core_height - 3]) {
                cylinder(r2=nut_diameter/2 + 3,r1=nut_diameter/2,h=3+shim,$fn=6);
            }
            // Bolt holes around base
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

repair();

