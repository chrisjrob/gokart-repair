Go-Kart Repair
==============

Copyright (C) 2013 Christopher Roberts

Licensed under the [GPL v3 Licence](https://github.com/chrisjrob/gokart-repair/blob/master/LICENCE.md "Read licence")

Description
-----------
Designed in OpenSCAD.
This is a repair to a Go-Kart's steering wheel, to enable it to be reattached to the steering bolt.
This is only suitable for go-karts that have a nut on the end of the steering shaft.

The model has an option of adding strengthening pin holes around the nut (see Credits below). 
Interestingly, if the pin holes do not protrude from at least one end of the model, the slicing program removes the pinholes entirely.

Status
------
Complete.

Instructions
------------
* Edit SCAD file with your preferred parameters, in particular the steering nut size.
* Compile and export to STL.
* Slice and print.

Credits
-------
Thank you to [Wildseyed Cabrer](https://plus.google.com/103153642711282733992) for suggesting that I do away with the buttresses of [v1](https://github.com/chrisjrob/gokart-repair/tree/v1) and instead design a solid cylinder. 
Of particular interest was his suggestion to use pinholes around the nut hole, to force the slicing program to add reinforcement; which has now been implemented in this design.
Thank you to [Andreas Thorn](https://plus.google.com/+AndreasThorn1) for reminding me to use the $fn = 6 for the chamferring of the nut hole, as I had for the nut hole itself.
