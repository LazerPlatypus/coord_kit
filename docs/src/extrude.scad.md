# LibFile: extrude.scad

Exposes utilities for extruding shapes and radiiPoints for the
[Round-Anything](https://github.com/Irev-Dev/Round-Anything/tree/master) library

To use, add the following lines to the beginning of your file:

    use <core.scad>;

## File Contents

- [`planar_linear_extrude()`](#module-planar_linear_extrude)
- [`planar_linear_extrude_points()`](#module-planar_linear_extrude_points)
- [`planar_shell_extrude()`](#module-planar_shell_extrude)
- [`planar_beam_extrude()`](#module-planar_beam_extrude)
- [`_assert_plane_valid()`](#module-_assert_plane_valid)
- [`_plane_to_translation()`](#function-_plane_to_translation)
- [`_plane_to_rotation()`](#function-_plane_to_rotation)


### Module: planar\_linear\_extrude()

**Usage:** 

- planar_linear_extrude(
-    length,
-    plane,
-    center,
-    convexity,
-    twist,
-    slices
- ) { polygon(coords); };

**Description:** 

Extrudes a 2D shape along a specified plane, allowing for twisting with a given number of slices

**Arguments:** 

<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`length`             | `number`: the length of the extrusion

<abbr title="These args must be used by name, ie: name=value">By&nbsp;Name</abbr> | What it does
-------------------- | ------------
`plane`              | `str`: the plane along which to extrude (allowed values are "X", "-X", "Y", "-Y", "Z", "-Z"). Default: "Z"
`center`             | `bool`: whether to center the extrusion along the specified plane. Default: false
`convexity`          | `number`: the convexity of the extrusion (used for rendering, see [OpenSCAD User Manual/Convexity Affects Rendering](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Convexity_Affects_Rendering)). Default: 10
`twist`              | `number`: the angle (in degrees) to twist the extrusion. Default: 0
`slices`             | `number`: the number of faces to create when twisting the part. Does nothing if `twist` is not specified. Default: 20

**Example 1:** Simple Extrude

![planar\_linear\_extrude() Example 1](images/extrude/planar_linear_extrude.png "planar\_linear\_extrude() Example 1")

``` {.C linenos=True}
use <core.scad>;
planar_linear_extrude(30) { polygon([[0,0],[10,0],[10,10],[0,10]]); }
```

**Example 2:** Extrude into "Y" Plane

![planar\_linear\_extrude() Example 2](images/extrude/planar_linear_extrude_2.png "planar\_linear\_extrude() Example 2")

``` {.C linenos=True}
use <core.scad>;
planar_linear_extrude(30, plane="Y") { polygon([[0,0],[10,0],[10,10],[0,10]]); }
```

**Example 3:** Extrude with Twist

![planar\_linear\_extrude() Example 3](images/extrude/planar_linear_extrude_3.png "planar\_linear\_extrude() Example 3")

``` {.C linenos=True}
use <core.scad>;
planar_linear_extrude(30, twist=45) { polygon([[0,0],[10,0],[10,10],[0,10]]); }
```

**Example 4:** Extrude with Twist and Slices

![planar\_linear\_extrude() Example 4](images/extrude/planar_linear_extrude_4.png "planar\_linear\_extrude() Example 4")

``` {.C linenos=True}
use <core.scad>;
planar_linear_extrude(30, twist=45, slices=10) { polygon([[0,0],[10,0],[10,10],[0,10]]); }
```

---

### Module: planar\_linear\_extrude\_points()

**Usage:** 

- planar_linear_extrude_points(
-    points,
-    length,
-    plane,
-    center,
-    r1,
-    r2,
-    fn,
-    convexity
- );

**Description:** 

Extrudes a set of points along a specified plane, allowing for radii on the extrusion ends.
Points are vectors in the format [x, y, r] where `r` is an optional radius for the point.

**Arguments:** 

<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`points`             | `list`: the set of points to extrude in the format [[x, y, r], [x, y, r], ...]
`length`             | `number`: the length of the extrusion

<abbr title="These args must be used by name, ie: name=value">By&nbsp;Name</abbr> | What it does
-------------------- | ------------
`plane`              | `str`: the plane along which to extrude (allowed values are "X", "-X", "Y", "-Y", "Z", "-Z"). Default: "Z"
`center`             | `bool`: whether to center the extrusion along the specified plane. Default: false
`r1`                 | `number`: the radius of the face opposite to the extrusion direction. Default: 0
`r2`                 | `number`: the radius of the face in the extrusion direction. Default: 0
`fn`                 | `number`: the number of fragments for rounded features. Default: 10
`convexity`          | `number`: the convexity of the extrusion (used for rendering, see [OpenSCAD User Manual/Convexity Affects Rendering](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Convexity_Affects_Rendering)). Default: 10

**Example 1:** rounded square extrude

``` {.C linenos=True}
use <core.scad>;
planar_linear_extrude_points(
   [[0, 0, 2], [10, 0, 2], [10, 10, 2], [0, 10, 2]],
   10,
);
```

![planar\_linear\_extrude\_points() Example 1](images/extrude/planar_linear_extrude_points.png "planar\_linear\_extrude\_points() Example 1")

**Example 2:** rounded square extrude with radius

``` {.C linenos=True}
use <core.scad>;
planar_linear_extrude_points(
   [[0, 0, 2], [10, 0, 2], [10, 10, 2], [0, 10, 2]],
   10,
   r1 = 4,
);
```

![planar\_linear\_extrude\_points() Example 2](images/extrude/planar_linear_extrude_points_2.png "planar\_linear\_extrude\_points() Example 2")

**Example 3:** rounded square extrude with negative radius

``` {.C linenos=True}
use <core.scad>;
planar_linear_extrude_points(
   [[0, 0, 2], [10, 0, 2], [10, 10, 2], [0, 10, 2]],
   10,
   r2 = -4,
);
```

![planar\_linear\_extrude\_points() Example 3](images/extrude/planar_linear_extrude_points_3.png "planar\_linear\_extrude\_points() Example 3")

---

### Module: planar\_shell\_extrude()

**Usage:** 

- planar_shell_extrude(
-    points,
-    length,
-    offset_inner,
-    offset_outer,
-    plane,
-    center,
-    r1,
-    r2,
-    min_r_outer,
-    min_r_inner,
-    fn,
- ) { /* optional 2D children to fill shell */ };

**Description:** 

Extrudes a hollow shell along a specified plane from a set of points with inner and outer offsets.
The shell is created using Round-Anything's shell2d, with optional 2D children to fill the interior.
Points are vectors in the format [x, y, r] where `r` is an optional radius for the point.

**Arguments:** 

<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`points`             | `list`: the set of points defining the shell perimeter in the format [[x, y, r], [x, y, r], ...]
`length`             | `number`: the length of the extrusion
`offset_inner`       | `number`: the offset from the perimeter toward the interior (negative moves toward center, positive moves outward)
`offset_outer`       | `number`: the offset from the perimeter toward the exterior (negative moves toward center, positive moves outward)

<abbr title="These args must be used by name, ie: name=value">By&nbsp;Name</abbr> | What it does
-------------------- | ------------
`plane`              | `str`: the plane along which to extrude (allowed values are "X", "-X", "Y", "-Y", "Z", "-Z"). Default: "Z"
`center`             | `bool`: whether to center the extrusion along the specified plane. Default: false
`r1`                 | `number`: the radius of the face opposite to the extrusion direction. Default: 0
`r2`                 | `number`: the radius of the face in the extrusion direction. Default: 0
`min_r_outer`        | `number`: the minimum outer radius of the shell. Default: 0
`min_r_inner`        | `number`: the minimum inner radius of the shell. Default: 0
`fn`                 | `number`: the number of fragments for rounded features. Default: 30

**Example 1:** Basic shell extrude

``` {.C linenos=True}
use <core.scad>;
planar_shell_extrude(
   [[0, 0, 2], [20, 0, 2], [20, 20, 2], [0, 20, 2]],
   10,
   -2,
   2
);
```

![planar\_shell\_extrude() Example 1](images/extrude/planar_shell_extrude.png "planar\_shell\_extrude() Example 1")

**Example 2:** Shell with interior fill

``` {.C linenos=True}
use <core.scad>;
planar_shell_extrude(
   [[0, 0, 2], [20, 0, 2], [20, 20, 2], [0, 20, 2]],
   10,
   -2,
   2
) {
   circle(r=5, $fn=30);
}
```

![planar\_shell\_extrude() Example 2](images/extrude/planar_shell_extrude_2.png "planar\_shell\_extrude() Example 2")

**Example 3:** Shell extruded in Y plane with end radii

``` {.C linenos=True}
use <core.scad>;
planar_shell_extrude(
   [[0, 0, 2], [20, 0, 2], [20, 20, 2], [0, 20, 2]],
   10,
   -2,
   2,
   plane="Y",
   r1=2,
   r2=2
);
```

![planar\_shell\_extrude() Example 3](images/extrude/planar_shell_extrude_3.png "planar\_shell\_extrude() Example 3")

**Example 4:** Shell with asymmetric offsets

``` {.C linenos=True}
use <core.scad>;
planar_shell_extrude(
   [[0, 0, 3], [30, 0, 3], [30, 30, 3], [0, 30, 3]],
   15,
   -1,
   3
);
```

![planar\_shell\_extrude() Example 4](images/extrude/planar_shell_extrude_4.png "planar\_shell\_extrude() Example 4")

---

### Module: planar\_beam\_extrude()

**Usage:** 

- planar_beam_extrude(
-    points,
-    length,
-    offset_inner,
-    offset_outer,
-    plane,
-    start_angle,
-    end_angle,
-    mode,
-    center,
-    r1,
-    r2,
-    fn,
-    convexity
- );

**Description:** 

Extrudes a beam of constant thickness along a path defined by points.
The beam is created using Round-Anything's beamChain, which connects sequential point pairs
with a defined thickness. Supports transitioning radii between beam endpoints.
Points are vectors in the format [x, y, r] where `r` is an optional radius for the point.
Note: negative radii are only allowed for the first and last points.

**Arguments:** 

<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`points`             | `list`: the set of points defining the beam path in the format [[x, y, r], [x, y, r], ...]
`length`             | `number`: the length of the extrusion
`offset_inner`       | `number`: the first offset defining beam thickness (when mode=2, only this offset is used)
`offset_outer`       | `number`: the second offset defining beam thickness

<abbr title="These args must be used by name, ie: name=value">By&nbsp;Name</abbr> | What it does
-------------------- | ------------
`plane`              | `str`: the plane along which to extrude (allowed values are "X", "-X", "Y", "-Y", "Z", "-Z"). Default: "Z"
`start_angle`        | `number`: the angle at the first beam endpoint. Interpretation depends on mode. If undefined, uses beamChain's default. Default: undef
`end_angle`          | `number`: the angle at the last beam endpoint. Interpretation depends on mode. If undefined, uses beamChain's default. Default: undef
`mode`               | `number`: controls how end angles are interpreted. mode=1: angles relative to last two points (default 90°), mode=2: forward path only, mode=3: angles absolute from x-axis (default 0°). If undefined, uses beamChain's default. Default: undef
`center`             | `bool`: whether to center the extrusion along the specified plane. Default: false
`r1`                 | `number`: the radius of the face opposite to the extrusion direction. Default: 0
`r2`                 | `number`: the radius of the face in the extrusion direction. Default: 0
`fn`                 | `number`: the number of fragments for rounded features. Default: 30
`convexity`          | `number`: the convexity of the extrusion (used for rendering, see [OpenSCAD User Manual/Convexity Affects Rendering](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Convexity_Affects_Rendering)). Default: 10

**Example 1:** Simple straight beam

``` {.C linenos=True}
use <core.scad>;
planar_beam_extrude(
   [[0, 0], [50, 0], [0, 50]],
   10,
   2,
   -2
);
```

![planar\_beam\_extrude() Example 1](images/extrude/planar_beam_extrude.png "planar\_beam\_extrude() Example 1")

**Example 2:** Curved beam with radius

``` {.C linenos=True}
use <core.scad>;
planar_beam_extrude(
   [[0, 0, 2], [20, 10, 3], [40, 0, 2]],
   10,
   2,
   -2
);
```

![planar\_beam\_extrude() Example 2](images/extrude/planar_beam_extrude_2.png "planar\_beam\_extrude() Example 2")

**Example 3:** Beam extruded in X plane

``` {.C linenos=True}
use <core.scad>;
planar_beam_extrude(
   [[0, 0], [20, 20], [40, 10]],
   15,
   3,
   -3,
   plane="X"
);
```

![planar\_beam\_extrude() Example 3](images/extrude/planar_beam_extrude_3.png "planar\_beam\_extrude() Example 3")

**Example 4:** Beam with custom end angles

``` {.C linenos=True}
use <core.scad>;
planar_beam_extrude(
   [[0, 0], [30, 0], [30, 30]],
   10,
   2,
   -2,
   start_angle=45,
   end_angle=135
);
```

![planar\_beam\_extrude() Example 4](images/extrude/planar_beam_extrude_4.png "planar\_beam\_extrude() Example 4")

**Example 5:** Beam with end radii

``` {.C linenos=True}
use <core.scad>;
planar_beam_extrude(
   [[0, 0], [40, 0], [40, 40], [0, 40]],
   12,
   3,
   -3,
   r1=2,
   r2=2
);
```

![planar\_beam\_extrude() Example 5](images/extrude/planar_beam_extrude_5.png "planar\_beam\_extrude() Example 5")

---

### Module: \_assert\_plane\_valid()

**Status:** INTERNAL


**Usage:** 

- _assert_plane_valid(plane);

**Description:** 

Asserts that the given plane is valid (one of "X", "-X", "Y", "-Y", "Z", "-Z")

**Arguments:** 

<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`plane`              | `str`: the plane to validate (must be one of "X", "-X", "Y", "-Y", "Z", "-Z")

---

### Function: \_plane\_to\_translation()

**Status:** INTERNAL


**Usage:** 

- _plane_to_translation(plane, length, center);

**Description:** 

Returns the translation vector for a given plane, length, and center flag

**Arguments:** 

<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`plane`              | `str`: the plane to translate along (must be one of "X", "-X", "Y", "-Y", "Z", "-Z")
`length`             | `number`: the length of the extrusion
`center`             | `bool`: whether to center the extrusion

---

### Function: \_plane\_to\_rotation()

**Status:** INTERNAL


**Usage:** 

- _plane_to_rotation(plane, length, center);

**Description:** 

Returns the rotation vector for a given plane, length, and center flag

**Arguments:** 

<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`plane`              | `str`: the plane to rotate along (must be one of "X", "-X", "Y", "-Y", "Z", "-Z")
`length`             | `number`: the length of the extrusion
`center`             | `bool`: whether to center the extrusion

---

