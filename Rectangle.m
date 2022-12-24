classdef Rectangle < matlab.mixin.Copyable
    %Rectangle Defines one rectangle in 3D space
    %  12/2022 - Ville Heikkinen
    %  On default lower top left corner is at origin.
    %  It is possible to supply transformation matrix to transform the rectangle
    %  Use draw command to draw the rectangle in the axes supplied as argument
    %  rectangle.draw(axes)
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
    %   Offsets move the rectangle before transform matrix. E.g. move the rectangle origin in reality
    %
    %   tMatrix, defaults to eye(4)
    %   rectangle is multiplied with tMatrix when the model is defined. 4x4 Transform matrix
    %
    %   rigCoordinates, defaults to false.
    %   If true then the model is additionally transformed by rotation around z axis (-90 degrees).
    %   This is to make rig coordinate system the base system.

    properties (Access = public)
        length (1, 1) {mustBeNonnegative, mustBeFinite, mustBeReal};
        width (1, 1) {mustBeNonnegative, mustBeFinite, mustBeReal};
        height (1, 1) {mustBeNonnegative, mustBeFinite, mustBeReal};
        tMatrix (4, 4) {mustBeFinite, mustBeReal, mustBeNonmissing};

        xOffset (1, 1) {mustBeNumeric, mustBeFinite};
        yOffset (1, 1) {mustBeNumeric, mustBeFinite};
        zOffset (1, 1) {mustBeNumeric, mustBeFinite};

        color;
    end

    methods (Access = public)
        function obj = Rectangle(length, width, height, options)
            %Rectangle Construct an instance of this class
            %   Detailed explanation goes here
            arguments
                length;
                width;
                height;
                options.tMatrix = eye(4);
                options.xOffset = 0;
                options.yOffset = 0;
                options.zOffset = 0;
                options.rigCoordinates logical = false;
                options.color = [0.8500 0.3250 0.0980];
            end

            obj.length = length;
            obj.width = width;
            obj.height = height;

            obj.color = options.color;

            toRig = eye(4);
            if options.rigCoordinates
                toRig = trotz(-90, 'deg');
            end

            obj.tMatrix = options.tMatrix * toRig;
            obj.xOffset = options.xOffset;
            obj.yOffset = options.yOffset;
            obj.zOffset = options.zOffset;

            obj.defineModel();
        end

        function draw(obj, ax)
            arguments
                obj Rectangle;
                ax matlab.graphics.axis.Axes;
            end
            % If rectangle was already drawn delete it.
            % So only one instance of this rectangle can be drawn.
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
            obj.defineModel();
        end

        function set.width(obj, width)
            obj.width = width;
            obj.defineModel();
        end

        function set.height(obj, height)
            obj.height = height;
            obj.defineModel();
        end

        function set.tMatrix(obj, matrix)
            obj.tMatrix = matrix;
            obj.defineModel();
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
            %    Lower          Upper
            %  p1*---*p2       p5*---*p6
            %    |   |           |   |
            %    |   |           |   |
            % X  |   |           |   |
            %    |   |           |   |
            %    |   |           |   |
            %  p4*---*p3       p8*---*p7
            %      Y

            p1 = [0, 0, 0, 1];
            p2 = [obj.width, 0, 0, 1];
            p3 = [obj.width, -obj.length, 0, 1];
            p4 = [0, -obj.length, 0, 1];

            p5 = [0, 0, obj.height, 1];
            p6 = [obj.width, 0, obj.height, 1];
            p7 = [obj.width, -obj.length, obj.height, 1];
            p8 = [0, -obj.length, obj.height, 1];

            vertices = [p1; p2; p3; p4; p5; p6; p7; p8];
            vertices(:, 1) = vertices(:, 1) + obj.xOffset;
            vertices(:, 2) = vertices(:, 2) + obj.yOffset;
            vertices(:, 3) = vertices(:, 3) + obj.zOffset;

            % vertices = (toRig * vertices')';
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
            obj.model.FaceAlpha = 0.1;
            obj.modelDefined = true;
        end

    end

    methods (Access = protected)
        % function cp = copyElement(obj)
        %     % This method is called when the object is copied using built in function copy()
        % end
    end
end
