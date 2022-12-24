function object = getCurrentObject(varargin)
    %getCurrentObject Get handle of object the pointer is over.
    %   H = getCurrentObject(TYPE) check searches visible objects in
    %   the PointerWindow looking for one that is under the pointer.  It
    %   returns the handle to the first object it finds under the pointer
    %   or else the empty matrix.
    %
    %   Example:
    %********************************************************************************************
    %       getCurrentObject("Type", "axes", "Tag", "Camera view")
    %       returns an object that matches the arguments if pointer is hovering over it.
    %********************************************************************************************
    %       getCurrentObject()
    %       Returns first child object that pointer is hovering over.
    %********************************************************************************************
    %   See also UICONTROL, UIPANEL
    %
    %   Modified from undocumented Matlab funtion overobj
    %   Searches all child objects, not just directly belove the figure
    %   Ville Heikkinen - 12/2022

    %   Copyright 1984-2013 The MathWorks, Inc.

    % Make sure root units are in pixels, store old units
    oldUnits = get(0, "Units");
    set(0, "Units", "pixels");

    % Get figure which is currently under mouse pointer
    fig = matlab.ui.internal.getPointerWindow();

    % Look for quick exit. Mouse pointer is not over a figure.
    if fig == 0
        object = [];
        return
    end

    % Get mouse pointer location in computer screen coordinates (pixels)
    p = get(0, 'PointerLocation');

    % Change back  to old units
    set(0, "Units", oldUnits);

    % Get figure position in pixels on screen
    figPosition = getpixelposition(fig);

    % Transform pointer location from screen coordinate to the figure coordinates.
    x = p(1) - figPosition(1);
    y = p(2) - figPosition(2);

    % Find all objects that match given arguments and are current figures children
    objects = findobj(get(fig, 'Children'), varargin{:});

    % Check to see if the cursor hovering any matching object.
    for object = objects'
        pos = getpixelposition(object, true);
        if ((x > pos(1)) && (x < pos(1) + pos(3)) && (y > pos(2)) && (y < pos(2) + pos(4)))
            return;
        end
    end
    object = [];

    % end getCurrentObject
