classdef HoldAndDragTemplate < handle
    %HoldAndDragTemplate Example how to great click and drag callbacks
    %       Hold left click to rotate.
    %       Shift+left click or middle mouse to move
    %       Scroll wheel to change view angle

    properties (Access = public)
        fig
        ax
        object
    end

    methods (Access = public)
        function obj = HoldAndDragTemplate(inputArg1, inputArg2)
            %HoldAndDragTemplate Construct an instance of this class
            %   Detailed explanation goes here

            obj.fig = uifigure("Visible", "off", ...
            "Name", "Drag and hold example", ...
                "Scrollable", "on", ...
                "WindowScrollWheelFcn", @obj.mouseWheelAction, ...
                "WindowButtonMotionFcn", @obj.mouseMovementAction, ...
                "WindowButtonDownFcn", @obj.mouseButtonDownAction, ...
                "WindowButtonUpFcn", @obj.mouseButtonUpAction, ...
                "Position", [1 1 1400 900]);

            obj.ax = axes(obj.fig, "DataAspectRatio", [1 1 1]);

            obj.object = Rectangle(1, 1, 1, "color", "red");
            obj.object.draw(obj.ax);
            obj.ax.XLim = [-2 2];
            obj.ax.YLim = [-2 2];
            obj.ax.ZLim = [-2 2];
            obj.fig.Visible = "on";
            grid(obj.ax, "on");
        end

    end

    properties (Access = private)
        moveCamera (1, 1) logical
        rotateCamera (1, 1) logical
        previousCursorPos (1, 2)
    end

    methods (Access = private)
        function mouseWheelAction(obj, src, event)
            currentObject = getCurrentObject("Type", "axes");
            if isempty(currentObject)
                return;
            end
            % Mouse wheel is scrolled on top of the simulation axes.
            oldAngle = obj.ax.CameraViewAngle;
            newAngle = oldAngle + event.VerticalScrollCount * 2;
            newAngle = max([newAngle, 1]);
            newAngle = min([newAngle, 179]);
            obj.ax.CameraViewAngle = newAngle;
        end

        function mouseMovementAction(obj, ~, ~)

            if obj.moveCamera || obj.rotateCamera
                % Mouse was clicked on top of axis and mouse button is currently held down.
                newCursorPos = obj.fig.CurrentPoint;
                dx = obj.previousCursorPos(1) - newCursorPos(1);
                dy = obj.previousCursorPos(2) - newCursorPos(2);
                obj.previousCursorPos = newCursorPos;

                if obj.moveCamera
                    moveMode = "movetarget";
                elseif obj.rotateCamera
                    moveMode = "fixtarget";
                    dx = 5*dx;
                    dy = 5*dy;
                else
                    error("Neither rotate or move mode is activated, should not be here");
                end
                camdolly(obj.ax, dx, dy, 0, moveMode, "pixels");
            end
        end

        function mouseButtonDownAction(obj, src, event)

            pause(0.15)

            currentObject = getCurrentObject("Type", "axes");
            if ~isempty(currentObject)
                % Mouse was clicked on top of the axis
                clickType = obj.fig.SelectionType;

                if strcmpi(clickType, "normal")
                    obj.rotateCamera = true;
                    obj.previousCursorPos = obj.fig.CurrentPoint;
                elseif strcmpi(clickType, "extend")
                    obj.moveCamera = true;
                    obj.previousCursorPos = obj.fig.CurrentPoint;
                end
            end
        end

        function mouseButtonUpAction(obj, ~, ~)
            % Set all click and drag flags to false
            obj.moveCamera = false;
            obj.rotateCamera = false;
        end
    end
end
