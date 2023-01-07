<!-- omit in toc -->
# Undocumented useful Matlab functions

This document consists of undocumented Matlab functions that can be useful in some scenarios.

- [Structs](#structs)
  - [renameStructField](#renamestructfield)
- [Axis](#axis)
  - [Axes Camera](#axes-camera)

## Structs

Functions related to structs

### renameStructField

Renames the given structure field. Needs 3 inputs, the structure, old name and new name.
**Note** names must be supplied as character vectors, strings do not work.

```Matlab {cmd = true}
s.Vertices = [1,2;3,4];
s = renameStructField(s,'Vertices','newName');
```

## Axis

In some old Matlab versions (<2014) you could get camera/view transformation matrices from axis hidden properties. This is not possible anymore sadly.

### Axes Camera

Get some hidden properties from axis camera.

```Matlab
h = axes;
h.Camera.get;
```
