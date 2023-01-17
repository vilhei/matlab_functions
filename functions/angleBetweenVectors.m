function angleOut = angleBetweenVectors(vec1,vec2,options)
arguments
    vec1 (:,1) {mustBeNumeric,mustBeFinite,mustBeNonempty,mustBeNonNan,mustBeNonmissing};
    vec2 (:,1) {mustBeNumeric,mustBeFinite,mustBeNonempty,mustBeNonNan,mustBeNonmissing};
    options.unit {mustBeMember(options.unit,["deg","rad"])} = "rad"
end

angle = real(dot(vec1,vec2))/(norm(vec1)*norm(vec2));

if strcmp(options.unit,"deg")
    angleOut = rad2deg(acos(angle));
    return;
end
angleOut = acos(angle);
end