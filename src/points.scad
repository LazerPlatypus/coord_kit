// LibFile: points.scad
//   Exposes utilities for generating & interacting with radiiPoints for the
//   [Round-Anything](https://github.com/Irev-Dev/Round-Anything/tree/master) library
// Includes:
//   use <core.scad>;

use <../deps/round_anything/Round-Anything/polyround.scad>;

// Function: points_to_coords()
// Usage:
//   coords = points_to_coords(points, fn);
// Description:
//   Creates polyRound coordinates from a set of 2D points
// Arguments:
//   points = array of 2D points, each point is an object with x and y properties, with an optional 'Z' (radius) property. if 'Z' is not specified, it defaults to '0'
//   ---
//   fn = resolution of shape. substitution for $fn
// Example(3D): Create a square
//   coords = points_to_coords([[0, 0], [10, 0], [10, 10], [0, 10]]);
//   // common use-case
//   linear_extrude(height = 5) { polygon(coords); };
// Example(3D): Create a rounded square
//   coords = points_to_coords([[0, 0, 2], [10, 0, 2], [10, 10, 2], [0, 10, 2]]);
//    // extrude into 3D
//   linear_extrude(height = 5) { polygon(coords); };
function points_to_coords(
    points,
    fn = 5,
) =
    let (
        radii_points = [for (point = points) [point.x, point.y, len(point) > 2 ? point.z : 0]]
    ) polyRound(radii_points, fn=fn, mode=0);


// Function: translate_points()
// Usage: 
//   translated_points = translate_points(coords, translation, rotation);
// Description:
//   Translates 2D coordinates in the XY plane, allowing rotation about the Z axis
// Arguments:
//   coords = array of coordinates to translate consisting of [x, y, z] where `z` is optional
//   translation = vector of [x, y] for the translation
//   rotation = an angle (in degrees) to rotate about the Z axis
// Example(3D):
//   // points
//   points = [[0, 0, 2], [10, 0, 2], [10, 10, 2], [0, 10, 2]];
//   // create coords
//   coords = points_to_coords(points);
//   // extrude into 3D
//   linear_extrude(height = 5) { polygon(coords); };
//   // translate points
//   translated_points = translate_points(points, [20, 0], 45);
//   // create translated coords
//   translated_coords = points_to_coords(translated_points);
//   color("#FF0000") {
//      linear_extrude(height = 5) { polygon(translated_coords); };
//   }
function translate_points(
    coords,
    translation,
    rotation,
) =
    translateRadiiPoints(coords, translation, rotation);

