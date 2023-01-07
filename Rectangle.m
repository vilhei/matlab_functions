classdef Rectangle < matlab.mixin.Copyable
%{
 %Rectangle Defines one rectangle in 3D space
    %  TODO! Should be renamed because matlab has built in function called rectangle --> confusing and easy to misuse.
    %  TODO! In case of 2D, length is confusing name to use for points.
    %
    %  12/2022 - Ville Heikkinen
    %
    %  3D Rectangle uses transformation matrices for moving the object.
    %
    %  2D Rectangle uses 4 points to direcly set object position.
    %
    %  Above is subject to possibly change later.
    %
    %  On default lower top left corner (p5) is at origin (3D).
    %
    %    Lower          Upper
    %  p1*---*p2       p5*---*p6
    %    |   |           |   |
    %    |   |           |   |
    % Y  |   |           |   |
    %    |   |           |   |
    %    |   |           |   |
    %  p4*---*p3       p8*---*p7
    %      X
    %
    %  It is possible to supply transformation matrix to transform the rectangle
    %
    %  Use draw command to draw the rectangle in the axes supplied as argument
    %  rectangle.draw(axes)
    %
    %  Rectangle can only have one drawned instances.
    %  Create multiple Rectangle objects to have multiple drawned rectangles.
    %
    %  Constructor arguments:
    %   Positional arguments REQUIRED
    %   length y-axis size
    %   width x-axis size
    %   height z-axis size
    %
    %   Name-value pair OPTIONAL arguments
    %   xOffset, defaults to 0
    %   yOffset, defaults to 0
    %   zOffset, defaults to 0
    %   Offsets move the rectangle before transformation matrix. E.g. move the rectangle origin in reality
    %
    %   tMatrix, defaults to eye(4)
    %   rectangle is multiplied with tMatrix when the model is defined. 4x4 Transform matrix
    %
    %   rigCoordinates, defaults to false.
    %   If true then the model is additionally transformed by rotation around z axis (-90 degrees).
    %   This is to make rig coordinate system the base system.
    %
    %   name, optional name to recognize the rectangle later, e.g. to search for it.
    %
    %   dimensions, 2 or 3 dimensional (default 3).
    %
    % Rectangle Properties:
    %   length - 3D --> size in y direction. 2D --> 4 points in 3D space.
    %   width - 3D --> size in x direction. 2D --> Not used.
    %   height - 3D --> size in z direction. 2D --> Not used.
    %
    %   EXAMPLES:
    %   TODO
    %
%}

    properties (Access = public)
        length {mustBeFinite, mustBeReal};
        width {mustBeFinite, mustBeReal};
        height {mustBeFinite, mustBeReal};
        tMatrix (4, 4) {mustBeFinite, mustBeReal, mustBeNonmissing};

        xOffset (1, 1) {mustBeNumeric, mustBeFinite};
        yOffset (1, 1) {mustBeNumeric, mustBeFinite};
        zOffset (1, 1) {mustBeNumeric, mustBeFinite};

        color;

        transparency (1, 1) {mustBeNonnegative, mustBeLessThanOrEqual(transparency, 1)} = 0.1;

        points;

        name {mustBeTextScalar} = "";

        dimensions {mustBeMember(dimensions, [2, 3])};

    end

    methods (Access = public)
        function obj = Rectangle(length, width, height, options)
            %Rectangle Construct an instance of this class
            %   Detailed explanation goes here
            arguments
                length;
                width = 0;
                height = 0;
                options.tMatrix = eye(4);
                options.xOffset = 0;
                options.yOffset = 0;
                options.zOffset = 0;
                options.rigCoordinates logical = false;
                options.color = [0.8500 0.3250 0.0980];
                options.name = "";
                options.dimensions = 3;
            end

            obj.length = length;
            obj.width = width;
            obj.height = height;

            obj.color = options.color;
            obj.name = options.name;
            obj.dimensions = options.dimensions;

            if obj.dimensions == 3
                if ~isequal(size(length), [1, 1])
                    error("When creating 3 dimensional rectangle provide the length argument as scalar");
                end
                if ~isequal(size(width), [1, 1])
                    error("When creating 3 dimensional rectangle provide the width argument as scalar");
                end
                if ~isequal(size(height), [1, 1])
                    error("When creating 3 dimensional rectangle provide the height argument as scalar");
                end

                toRig = eye(4);
                if options.rigCoordinates
                    toRig = trotz(-90, 'deg');
                end

                translationMatrix = transl(options.xOffset, options.yOffset, options.zOffset);

                obj.tMatrix = options.tMatrix * toRig * translationMatrix;
                obj.xOffset = options.xOffset;
                obj.yOffset = options.yOffset;
                obj.zOffset = options.zOffset;
            end

            if obj.dimensions == 2
                dims = size(obj.length);
                if dims(3) ~= 3
                    error('When creating 2 dimensional object supply points in 3 column matrix.\nExample : [1,2,3 ; 4,5,6 ; 7,8,9 ; 10,11,12]');
                end
                if dims(1) ~= 4
                    error('%d points were given.\nGive exactly 4 points instead when using 2D rectangle', dims(1));
                end
            end

            obj.defineModel();
        end

        function draw(obj, ax)
            % draw  Draw the rectangle in the supplied axis
            %
            %	Checks if the model is defined,
            %   there really should not be any reason inside normal behaviour for it not to be.
            %   Deletes previous drawned model, meaning that this rectangle can only be drawn in one location only.
            %   To draw in multiple locations create copy of this object, using copy()
            %
            %	See also
            arguments
                obj Rectangle;
                ax matlab.graphics.axis.Axes;
            end

            if ~obj.modelDefined
                error(sprintf(['Rectangle model is not defined e.g. obj.defineModel() has not been called.\n' ...
                               'defineModel() is called in constructor or on property change']))
            end

            delete(obj.drawnModel);

            obj.drawnModel = patch(ax, obj.model);
        end

        function delete(obj)
            delete(obj.drawnModel);
        end
    end
    methods
        % Define model after properties of the rectangle are modified.

        function set.length(obj, length)
            obj.length = length;
            obj.modelDefined = false; %#ok<MCSUP>
            obj.defineModel();
        end

        function set.width(obj, width)
            obj.width = width;
            obj.modelDefined = false; %#ok<MCSUP>
            obj.defineModel();
        end

        function set.height(obj, height)
            obj.height = height;
            obj.modelDefined = false; %#ok<MCSUP>
            obj.defineModel();
        end

        function set.tMatrix(obj, matrix)
            obj.tMatrix = matrix;
            obj.modelDefined = false; %#ok<MCSUP>
            obj.defineModel();
        end

        function set.transparency(obj, transparency)
            obj.transparency = transparency;
            obj.modelDefined = false; %#ok<MCSUP>
            obj.defineModel();
        end

        function set.color(obj, color)
            obj.color = color;
            obj.modelDefined = false; %#ok<MCSUP>
            obj.defineModel();
        end

        function pointsOut = get.points(obj)
            pointsOut = obj.model.Vertices;
        end

    end

    properties (Access = private)
        model struct = struct("Vertices", [], "Faces", [], "FaceColor", [], "FaceAlpha", []);
        modelDefined logical = false;
    end

    properties (Access = private, NonCopyable, Transient)
        % Not copied when using copy() for handle classes
        % Not saved when saving the object to file or sending to another program
        drawnModel matlab.graphics.primitive.Patch;
    end

    methods (Access = private)
        function defineModel(obj)
            if obj.dimensions == 3
                obj.define3D();
            elseif obj.dimensions == 2
                obj.define2D();
            end
        end

        function define3D(obj)
            %    Lower          Upper
            %  p1*---*p2       p5*---*p6
            %    |   |           |   |
            %    |   |           |   |
            % X  |   |           |   |
            %    |   |           |   |
            %    |   |           |   |
            %  p4*---*p3       p8*---*p7
            %      Y

            % Remove old model if it is drawn
            delete(obj.drawnModel);

            p1 = [0, 0, 0, 1];
            p2 = [obj.width, 0, 0, 1];
            p3 = [obj.width, -obj.length, 0, 1];
            p4 = [0, -obj.length, 0, 1];

            p5 = [0, 0, obj.height, 1];
            p6 = [obj.width, 0, obj.height, 1];
            p7 = [obj.width, -obj.length, obj.height, 1];
            p8 = [0, -obj.length, obj.height, 1];

            vertices = [p1; p2; p3; p4; p5; p6; p7; p8];

            vertices = (obj.tMatrix * vertices')';

            % Patch does not work with 4 dimensional vectors
            vertices(:, 4) = [];

            obj.model.Vertices = vertices;

            faces = [1, 2, 3, 4;
                     5, 6, 7, 8;
                     1, 5, 8, 4;
                     2, 6, 7, 3;
                     1, 2, 6, 5;
                     4, 3, 7, 8];

            obj.model.Faces = faces;
            obj.model.FaceColor = obj.color;
            obj.model.FaceAlpha = obj.transparency;
            obj.modelDefined = true;
        end

        function define2D(obj)
            obj.model.Vertices = obj.length;
            obj.model.Faces = [1, 2, 3, 4];
            obj.model.FaceColor = obj.color;
            obj.model.FaceAlpha = obj.transparency;
            obj.modelDefined = true;
        end

    end

    methods (Access = protected)
        % function cp = copyElement(obj)
        %     % This method is called when the object is copied using built in function copy()
        % end
    end
end
