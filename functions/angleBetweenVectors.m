function angleOut = angleBetweenVectors(vec1,vec2,options)
% angleOut returns angle between 2 vectors
%
% angleOut Arguments:
%   vec1 - first vector
%   vec2 - second vector
%
% angleOut name-value arguments (optional)
%   unit - "rad" or "deg", defaults to "rad"
%           Units to return the angle value  
%
%   cos - false or true, defaults to false
%         If true returns cosine value cos(theta) and not acos(theta)
arguments
    vec1 (:,1) {mustBeNumeric,mustBeFinite,mustBeNonempty,mustBeNonNan,mustBeNonmissing};
    vec2 (:,1) {mustBeNumeric,mustBeFinite,mustBeNonempty,mustBeNonNan,mustBeNonmissing};
    options.unit {mustBeMember(options.unit,["deg","rad"])} = "rad";
    options.cos (1,1) logical = false;
end

theta = real(dot(vec1,vec2))/(norm(vec1)*norm(vec2));

if options.cos
    angleOut = theta;
    return;
end

if strcmp(options.unit,"deg")
    angleOut = rad2deg(acos(theta));
    return;
end
angleOut = acos(theta);
end