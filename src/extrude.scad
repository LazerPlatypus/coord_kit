// LibFile: extrude.scad
//   Exposes utilities for extruding shapes and radiiPoints for the
//   [Round-Anything](https://github.com/Irev-Dev/Round-Anything/tree/master) library
// Includes:
//   use <core.scad>;

use <../deps/round_anything/Round-Anything/polyround.scad>;
use <points.scad>;

// Module: planar_linear_extrude()
// Usage:
//   planar_linear_extrude(
//      length,
//      plane,
//      center,
//      convexity,
//      twist,
//      slices
//   ) { polygon(coords); };
// Description:
//   Extrudes a 2D shape along a specified plane, allowing for twisting with a given number of slices
// Arguments:
//   length = `number`: the length of the extrusion
//   ---
//   plane = `str`: the plane along which to extrude (allowed values are "X", "-X", "Y", "-Y", "Z", "-Z"). Default: "Z"
//   center = `bool`: whether to center the extrusion along the specified plane. Default: false
//   convexity = `number`: the convexity of the extrusion (used for rendering, see [OpenSCAD User Manual/Convexity Affects Rendering](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Convexity_Affects_Rendering)). Default: 10
//   twist = `number`: the angle (in degrees) to twist the extrusion. Default: 0
//   slices = `number`: the number of faces to create when twisting the part. Does nothing if `twist` is not specified. Default: 20
// Example(3D): Simple Extrude
//   planar_linear_extrude(30) { polygon([[0,0],[10,0],[10,10],[0,10]]); }
// Example(3D): Extrude into "Y" Plane
//   planar_linear_extrude(30, plane="Y") { polygon([[0,0],[10,0],[10,10],[0,10]]); }
// Example(3D): Extrude with Twist
//   planar_linear_extrude(30, twist=45) { polygon([[0,0],[10,0],[10,10],[0,10]]); }
// Example(3D): Extrude with Twist and Slices
//   planar_linear_extrude(30, twist=45, slices=10) { polygon([[0,0],[10,0],[10,10],[0,10]]); }
module planar_linear_extrude(
    length,
    plane = "Z",
    center = false,
    convexity = 10,
    twist = 0,
    slices = 20,
) {
    _assert_plane_valid(plane);
    let (
        translation = _plane_to_translation(plane, length, center),
        rotation = _plane_to_rotation(plane, length, center),
    ) {
        translate(translation) {
            rotate(rotation) {
                linear_extrude(
                    height = length, 
                    center = center, 
                    convexity = convexity, 
                    twist = twist, 
                    slices = slices
                ) {
                    children();
                };
            };
        };
    };
};

// Module: planar_linear_extrude_points()
// Usage:
//   planar_linear_extrude_points(
//      points,
//      length,
//      plane,
//      center,
//      r1,
//      r2,
//      fn,
//      convexity
//   );
// Description:
//   Extrudes a set of points along a specified plane, allowing for radii on the extrusion ends.
//   Points are vectors in the format [x, y, r] where `r` is an optional radius for the point.
// Arguments:
//   points = `list`: the set of points to extrude in the format [[x, y, r], [x, y, r], ...]
//   length = `number`: the length of the extrusion
//   ---
//   plane = `str`: the plane along which to extrude (allowed values are "X", "-X", "Y", "-Y", "Z", "-Z"). Default: "Z"
//   center = `bool`: whether to center the extrusion along the specified plane. Default: false
//   r1 = `number`: the radius of the face opposite to the extrusion direction. Default: 0
//   r2 = `number`: the radius of the face in the extrusion direction. Default: 0
//   fn = `number`: the number of fragments for rounded features. Default: 10
//   convexity = `number`: the convexity of the extrusion (used for rendering, see [OpenSCAD User Manual/Convexity Affects Rendering](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Convexity_Affects_Rendering)). Default: 10
// Example(3D): rounded square extrude
//   planar_linear_extrude_points(
//      [[0, 0, 2], [10, 0, 2], [10, 10, 2], [0, 10, 2]],
//      10,
//   );
// Example(3D): rounded square extrude with radius
//   planar_linear_extrude_points(
//      [[0, 0, 2], [10, 0, 2], [10, 10, 2], [0, 10, 2]],
//      10,
//      r1 = 4,
//   );
// Example(3D): rounded square extrude with negative radius
//   planar_linear_extrude_points(
//      [[0, 0, 2], [10, 0, 2], [10, 10, 2], [0, 10, 2]],
//      10,
//      r2 = -4,
//   );
module planar_linear_extrude_points(
    points,
    length,
    plane = "Z",
    center = false,
    r1 = 0,
    r2 = 0,
    fn = 10,
    convexity = 10
) {
    _assert_plane_valid(plane);
    let (
        translation = _plane_to_translation(plane, length, center),
        rotation = _plane_to_rotation(plane, length, center),
        radii_points = [for (point = points) [point.x, point.y, len(point) > 2 ? point.z : 0]],
    ) {
        translate(translation) {
            rotate(rotation) {
                polyRoundExtrude(
                    radiiPoints=radii_points,
                    length=length,
                    r1=r1,
                    r2=r2,
                    fn=fn,
                    convexity=convexity,
                );
            };
        };
    };
};

// Module: planar_shell_extrude()
// Usage:
//   planar_shell_extrude(
//      points,
//      length,
//      offset_inner,
//      offset_outer,
//      plane,
//      center,
//      r1,
//      r2,
//      min_r_outer,
//      min_r_inner,
//      fn,
//   ) { /* optional 2D children to fill shell */ };
// Description:
//   Extrudes a hollow shell along a specified plane from a set of points with inner and outer offsets.
//   The shell is created using Round-Anything's shell2d, with optional 2D children to fill the interior.
//   Points are vectors in the format [x, y, r] where `r` is an optional radius for the point.
// Arguments:
//   points = `list`: the set of points defining the shell perimeter in the format [[x, y, r], [x, y, r], ...]
//   length = `number`: the length of the extrusion
//   offset_inner = `number`: the offset from the perimeter toward the interior (negative moves toward center, positive moves outward)
//   offset_outer = `number`: the offset from the perimeter toward the exterior (negative moves toward center, positive moves outward)
//   ---
//   plane = `str`: the plane along which to extrude (allowed values are "X", "-X", "Y", "-Y", "Z", "-Z"). Default: "Z"
//   center = `bool`: whether to center the extrusion along the specified plane. Default: false
//   r1 = `number`: the radius of the face opposite to the extrusion direction. Default: 0
//   r2 = `number`: the radius of the face in the extrusion direction. Default: 0
//   min_r_outer = `number`: the minimum outer radius of the shell. Default: 0
//   min_r_inner = `number`: the minimum inner radius of the shell. Default: 0
//   fn = `number`: the number of fragments for rounded features. Default: 30
// Example(3D): Basic shell extrude
//   planar_shell_extrude(
//      [[0, 0, 2], [20, 0, 2], [20, 20, 2], [0, 20, 2]],
//      10,
//      -2,
//      2
//   );
// Example(3D): Shell with interior fill
//   planar_shell_extrude(
//      [[0, 0, 2], [20, 0, 2], [20, 20, 2], [0, 20, 2]],
//      10,
//      -2,
//      2
//   ) {
//      circle(r=5, $fn=30);
//   }
// Example(3D): Shell extruded in Y plane with end radii
//   planar_shell_extrude(
//      [[0, 0, 2], [20, 0, 2], [20, 20, 2], [0, 20, 2]],
//      10,
//      -2,
//      2,
//      plane="Y",
//      r1=2,
//      r2=2
//   );
// Example(3D): Shell with asymmetric offsets
//   planar_shell_extrude(
//      [[0, 0, 3], [30, 0, 3], [30, 30, 3], [0, 30, 3]],
//      15,
//      -1,
//      3
//   );
module planar_shell_extrude(
    points,
    length,
    offset_inner,
    offset_outer,
    plane = "Z",
    center = false,
    r1 = 0,
    r2 = 0,
    min_r_outer = 0,
    min_r_inner = 0,
    fn = 30,
) {
    _assert_plane_valid(plane);
    let (
        radii_points = [for (point = points) [point.x, point.y, len(point) > 2 ? point.z : 0]],
        translation = _plane_to_translation(plane, length, center),
        rotation = _plane_to_rotation(plane, length, center),
    ) {
        translate(translation) {
            rotate(rotation) {
                extrudeWithRadius(
                    length=length,
                    r1=r1,
                    r2=r2,
                    fn=fn,
                ) {
                    shell2d(
                        offset1=offset_inner,
                        offset2=offset_outer,
                        minOR=min_r_outer,
                        minIR=min_r_inner,
                    ) {
                        polygon(polyRound(radii_points, fn=fn));
                        children();
                    };
                };
            };
        };
    };
};

// Module: planar_beam_extrude()
// Usage:
//   planar_beam_extrude(
//      points,
//      length,
//      offset_inner,
//      offset_outer,
//      plane,
//      start_angle,
//      end_angle,
//      mode,
//      center,
//      r1,
//      r2,
//      fn,
//      convexity
//   );
// Description:
//   Extrudes a beam of constant thickness along a path defined by points.
//   The beam is created using Round-Anything's beamChain, which connects sequential point pairs
//   with a defined thickness. Supports transitioning radii between beam endpoints.
//   Points are vectors in the format [x, y, r] where `r` is an optional radius for the point.
//   Note: negative radii are only allowed for the first and last points.
// Arguments:
//   points = `list`: the set of points defining the beam path in the format [[x, y, r], [x, y, r], ...]
//   length = `number`: the length of the extrusion
//   offset_inner = `number`: the first offset defining beam thickness (when mode=2, only this offset is used)
//   offset_outer = `number`: the second offset defining beam thickness
//   ---
//   plane = `str`: the plane along which to extrude (allowed values are "X", "-X", "Y", "-Y", "Z", "-Z"). Default: "Z"
//   start_angle = `number`: the angle at the first beam endpoint. Interpretation depends on mode. If undefined, uses beamChain's default. Default: undef
//   end_angle = `number`: the angle at the last beam endpoint. Interpretation depends on mode. If undefined, uses beamChain's default. Default: undef
//   mode = `number`: controls how end angles are interpreted. mode=1: angles relative to last two points (default 90°), mode=2: forward path only, mode=3: angles absolute from x-axis (default 0°). If undefined, uses beamChain's default. Default: undef
//   center = `bool`: whether to center the extrusion along the specified plane. Default: false
//   r1 = `number`: the radius of the face opposite to the extrusion direction. Default: 0
//   r2 = `number`: the radius of the face in the extrusion direction. Default: 0
//   fn = `number`: the number of fragments for rounded features. Default: 30
//   convexity = `number`: the convexity of the extrusion (used for rendering, see [OpenSCAD User Manual/Convexity Affects Rendering](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Convexity_Affects_Rendering)). Default: 10
// Example(3D): Simple straight beam
//   planar_beam_extrude(
//      [[0, 0], [50, 0], [0, 50]],
//      10,
//      2,
//      -2
//   );
// Example(3D): Curved beam with radius
//   planar_beam_extrude(
//      [[0, 0, 2], [20, 10, 3], [40, 0, 2]],
//      10,
//      2,
//      -2
//   );
// Example(3D): Beam extruded in X plane
//   planar_beam_extrude(
//      [[0, 0], [20, 20], [40, 10]],
//      15,
//      3,
//      -3,
//      plane="X"
//   );
// Example(3D): Beam with custom end angles
//   planar_beam_extrude(
//      [[0, 0], [30, 0], [30, 30]],
//      10,
//      2,
//      -2,
//      start_angle=45,
//      end_angle=135
//   );
// Example(3D): Beam with end radii
//   planar_beam_extrude(
//      [[0, 0], [40, 0], [40, 40], [0, 40]],
//      12,
//      3,
//      -3,
//      r1=2,
//      r2=2
//   );
module planar_beam_extrude(
    points,
    length,
    offset_inner,
    offset_outer,
    plane = "Z",
    start_angle = 90,
    end_angle = 90,
    mode = 0,
    center = false,
    r1 = 0,
    r2 = 0,
    fn = 30,
    convexity = 10,
) {
    _assert_plane_valid(plane);
    // TODO: create point between the 2 given points rather than error
    assert(len(points) >= 2, "planar_beam_extrude requires at least 2 points");
    let (
        safe_points = len(points) > 2 ? points : [points[0], [(points[0].x + points[1].x) / 2, (points[0].y + points[1].y) / 2, 0], points[1]],
        radii_points = [for (point = safe_points) [point.x, point.y, len(point) > 2 ? point.z : 0]],
        // Only pass angle/mode parameters if they're explicitly set
        beam_radii_points = beamChain(
            radiiPoints=radii_points,
            offset1=offset_inner,
            offset2=offset_outer,
            startAngle=start_angle,
            endAngle=end_angle,
            mode=mode,
        ),
        translation = _plane_to_translation(plane, length, center),
        rotation = _plane_to_rotation(plane, length, center),
    ) {
        translate(translation) {
            rotate(rotation) {
                polyRoundExtrude(
                    radiiPoints=beam_radii_points,
                    length=length,
                    r1=r1,
                    r2=r2,
                    fn=fn,
                    convexity=convexity,
                );
            };
        };
    };
};


// Module: _assert_plane_valid()
// Status: INTERNAL
// Usage:
//   _assert_plane_valid(plane);
// Description:
//   Asserts that the given plane is valid (one of "X", "-X", "Y", "-Y", "Z", "-Z")
// Arguments:
//   plane = `str`: the plane to validate (must be one of "X", "-X", "Y", "-Y", "Z", "-Z")
module _assert_plane_valid(plane) {
    assert(
        plane == "X" ||
        plane == "-X" ||
        plane == "Y" ||
        plane == "-Y" ||
        plane == "Z" ||
        plane == "-Z"
    );
}

// Function: _plane_to_translation()
// Status: INTERNAL
// Usage:
//   _plane_to_translation(plane, length, center);
// Description:
//   Returns the translation vector for a given plane, length, and center flag
// Arguments:
//   plane = `str`: the plane to translate along (must be one of "X", "-X", "Y", "-Y", "Z", "-Z")
//   length = `number`: the length of the extrusion
//   center = `bool`: whether to center the extrusion
function _plane_to_translation(plane, length, center) = 
    plane == "X" ? [0, 0, 0]
        : plane == "-X" ? [center ? -length / 2 : -length, 0, 0]
        : plane == "Y" ? [0, center ? length / 2 : length, 0]
        : plane == "-Y" ? [0, 0, 0]
        : plane == "-Z" ? [0, 0, center ? -length / 2 : -length]
        : [0, 0, 0];

// Function: _plane_to_rotation()
// Status: INTERNAL
// Usage:
//   _plane_to_rotation(plane, length, center);
// Description:
//   Returns the rotation vector for a given plane, length, and center flag
// Arguments:
//   plane = `str`: the plane to rotate along (must be one of "X", "-X", "Y", "-Y", "Z", "-Z")
//   length = `number`: the length of the extrusion
//   center = `bool`: whether to center the extrusion
function _plane_to_rotation(plane, length, center) = 
    plane == "X" ? [90, 0, 90]
        : plane == "-X" ? [90, 0, 90]
        : plane == "Y" ? [90, 0, 0]
        : plane == "-Y" ? [90, 0, 0]
        : plane == "-Z" ? [0, 0, 0]
        : [0, 0, 0];