function align_axes(axes_handle)
% function align_axes(axes_handle)
% Set the x and y axis labels of the current axes to be aligned to the orientation of the axes.

% (c) M. Arthington; modified by M. Zhong

[az,el]    = view;
Raz        = [cosd(az), sind(az), 0; -sind(az), cosd(az),         0; 0,        0,       1];
Rel        = [1,               0, 0;         0, cosd(el), -sind(el); 0, sind(el), cosd(el)];
u          = get(axes_handle, 'CameraUpVector');

if ~(u(1)==0 && u(2)==0 && u(3)==1)
  p      = get(axes_handle, 'CameraPosition');
  t      = get(axes_handle, 'CameraTarget');
  v      = (p - t);
  v      = v/norm(v);                                                                               % View vector from camera to target
  u      = u/norm(u);                                                                               % Camera up vector
  q      = cross(v,u);
  q      = q/norm(q);

% Get the x axis's projection into the view plane and then find its angle wrt the up vector
  xH     = cross([1; 0; 0], v);
  xH     = xH/norm(xH);
  xH     = cross(xH,v);
  thetax = -acosd(dot(xH,u)) + 90;

% Check which way the label needs to be rotated
  if dot(q, xH) > 0, thetax = -thetax; end

% Get the y axis's projection into the view plane and then find its angle wrt the up vector
  yH     = cross([0;1;0],v);
  yH     = yH/norm(yH);
  yH     = cross(yH,v);
  thetay = -acosd(dot(yH, u)) + 90;
  if dot(q,yH) > 0, thetay = -thetay; end

% Get the z axis's projection into the view plane and then find its angle wrt the up vector
  zH     = cross([0;0;1],v);
  zH     = zH/norm(zH);
  zH     = cross(zH,v);
  thetaz = -acosd(dot(zH, u)) + 90;

  if dot(q,zH) > 0, thetaz = -thetaz; end
else % When rotate3d has been used, the up vector isn't set by matlab correctly
% Calculate current orientation of x and y axes in view coordinates
  xax    = Rel * Raz * [1; 0; 0];
  yax    = Rel * Raz * [0; 1; 0];

% Project x and y into current viewing plane
  n1     = cross(xax, [0; 1; 0]);
  x      = cross([0; 1; 0], n1);

  n1     = cross(yax,[0;1;0]);
  y      = cross([0;1;0],n1);

  thetax = atand(x(3)/x(1));
  thetay = atand(y(3)/y(1));
  if ~any(x), thetax = 0; end
  if ~any(y), thetay = 0; end
  thetaz = 90;
end
  %Orientate these labels to be aligned with the axis directions.
  set(get(axes_handle, 'xlabel'), 'rotation', thetax);
  set(get(axes_handle, 'ylabel'), 'rotation', thetay);
  set(get(axes_handle, 'zlabel'), 'rotation', thetaz);
end