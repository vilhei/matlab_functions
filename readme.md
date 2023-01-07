<!-- omit in toc -->
# Matlab functions


This repository contains Matlab functions/classes etc. made by me (Ville Heikkinen). Main reason for this to exists is just to save them for later use for myself.

Document undocumented_functions contains undocumented Matlab functions that I have found use for and want to save for later use.

- [Functions](#functions)
  - [getCurrentObject](#getcurrentobject)
- [Classes](#classes)
  - [Rectangle](#rectangle)
  - [HoldAndDragTemplate](#holdanddragtemplate)

## Functions

### getCurrentObject

Modified version of undocumented Matlab function overobj;

Searches objects in pointerwindow (uifigure under the pointer). Returns the first object it finds under the pointer. 

It is possible to provide arguments which are used in the findobj function to search for specific object for example by type or tag etc. 

**TODO**  EXAMPLES!


## Classes

### Rectangle

Creates 2D (plane) or 3D rectangle. Main use is to create 3D rectangles. These objects can then be drawned using draw(axis) method which takes target axis as an argument.

**TODO**  EXAMPLES!


### HoldAndDragTemplate

Example class how to create hold and drag interactions inside Matlab GUI using uifigure callbacks. Example creates axis with object and ability to rotate and move the axis camera with hold and drag. 
Behaviour is different from default Matlab axis interactions. But this is just an example and you can do what ever you want with this.
Function getCurrentObject from this repository is useful with this to determine if the wanted object is currently under the cursor. 