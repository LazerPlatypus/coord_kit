# LibFile: points.scad

Exposes utilities for generating & interacting with radiiPoints for the
[Round-Anything](https://github.com/Irev-Dev/Round-Anything/tree/master) library

To use, add the following lines to the beginning of your file:

    use <core.scad>;

## File Contents

- [`points_to_coords()`](#function-points_to_coords)
- [`translate_points()`](#function-translate_points)


### Function: points\_to\_coords()

**Usage:** 

- coords = points_to_coords(points, fn);

**Description:** 

Creates polyRound coordinates from a set of 2D points

**Arguments:** 

<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`points`             | array of 2D points, each point is an object with x and y properties, with an optional 'Z' (radius) property. if 'Z' is not specified, it defaults to '0'

<abbr title="These args must be used by name, ie: name=value">By&nbsp;Name</abbr> | What it does
-------------------- | ------------
`fn`                 | resolution of shape. substitution for $fn

**Example 1:** Create a square

![points\_to\_coords() Example 1](images/points/points_to_coords.png "points\_to\_coords() Example 1")

``` {.C linenos=True}
use <core.scad>;
coords = points_to_coords([[0, 0], [10, 0], [10, 10], [0, 10]]);
// common use-case
linear_extrude(height = 5) { polygon(coords); };
```

**Example 2:** Create a rounded square

![points\_to\_coords() Example 2](images/points/points_to_coords_2.png "points\_to\_coords() Example 2")

``` {.C linenos=True}
use <core.scad>;
coords = points_to_coords([[0, 0, 2], [10, 0, 2], [10, 10, 2], [0, 10, 2]]);
 // extrude into 3D
linear_extrude(height = 5) { polygon(coords); };
```

---

### Function: translate\_points()

**Usage:** 

- translated_points = translate_points(coords, translation, rotation);

**Description:** 

Translates 2D coordinates in the XY plane, allowing rotation about the Z axis

**Arguments:** 

<abbr title="These args can be used by position or by name.">By&nbsp;Position</abbr> | What it does
-------------------- | ------------
`coords`             | array of coordinates to translate consisting of [x, y, z] where `z` is optional
`translation`        | vector of [x, y] for the translation
`rotation`           | an angle (in degrees) to rotate about the Z axis

**Example 1:** 

``` {.C linenos=True}
use <core.scad>;
// points
points = [[0, 0, 2], [10, 0, 2], [10, 10, 2], [0, 10, 2]];
// create coords
coords = points_to_coords(points);
// extrude into 3D
linear_extrude(height = 5) { polygon(coords); };
// translate points
translated_points = translate_points(points, [20, 0], 45);
// create translated coords
translated_coords = points_to_coords(translated_points);
color("#FF0000") {
   linear_extrude(height = 5) { polygon(translated_coords); };
}
```

![translate\_points() Example 1](images/points/translate_points.png "translate\_points() Example 1")

---

