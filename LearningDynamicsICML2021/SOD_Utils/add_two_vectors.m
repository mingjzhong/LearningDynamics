function vec3 = add_two_vectors(vec1, vec2)
% function vec3 = add_two_vectors(vec1, vec2)

% (C) M. Zhong

validateattributes(vec1, {'numeric'}, {'vector'}, 'add_two_vectors', 'vec1', 1);
validateattributes(vec2, {'numeric'}, {'vector'}, 'add_two_vectors', 'vec2', 2);
if ~isrow(vec1), vec1 = vec1'; end
if ~isrow(vec2), vec2 = vec2'; end
vec3 = vec1 + vec2;
end