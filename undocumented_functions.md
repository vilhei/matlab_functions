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

![Example of renameStructField](images/2023-01-06-19-37-04.png)

## Axis

### Axes Camera

Get

```Matlab
h = axes;
h.Camera.get;
```
![Example of Camera.get](images/2023-01-06-19-43-52.png)