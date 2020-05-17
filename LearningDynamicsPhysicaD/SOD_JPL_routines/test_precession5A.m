function test_precession5A()
    [sun_x, merc_x] = load_planet_trajP();
    num_mercury_days = 88;
    total_mercury_years       = 950;%600
    true_thetas2               = zeros(1, total_mercury_years-1);
    peri_points               = zeros(3, size(1:88:size(merc_x,2),2)); %Store the perihelion points.    
    j=1;
    for i = 1:88:size(merc_x,2)
        if i == max(1:88:size(merc_x,2))
            %Do no calculation of an angle.             
        else  
        ind                  = [i:i+87 i];  %[i:i+87] default, adding initial point closes the ellipse  
        diff_x                  = merc_x(:, ind); %subset to get the desired points
        
        spline3 = cscvn(diff_x);  %Fit the spline    
        %fnplt(spline3) %Plot the spline fit to the data if desired. 
        %Find and test the spline points
        points_check    =  linspace(0, spline3.breaks(end),500000);%500000=564arcsec %Finely grid the spline
        points  = fnval(spline3, points_check);
        pointnorms = sum(points.^2).^(0.5);
        [~,idxm] = min(pointnorms);        
%         figure;
%         scatter3(diff_x(1,:),diff_x(2,:),diff_x(3,:))
%         hold on;
%         scatter3(peripoint(1),peripoint(2),peripoint(3),'r')        
        peripoint = points(:,idxm); %This is the point of perihelion (approximated) for the orbit. 
        peri_points(:,j) = peripoint;
        j = j+1;
       end
    end
    for year_idx = 2:total_mercury_years
        u = peri_points(:,1);
        v = peri_points(:, year_idx);
        true_thetas2(year_idx-1) = atan2d(norm(cross(u, v)), dot(u, v));%acosd(dot(u, v)/(norm(u) * norm(v)));
        %atan2d(norm(cross(u, v)), dot(u, v)); 
    end
    plot(1:length(true_thetas2(1:end)), true_thetas2(1:end),'bo')
    plot(1:length(true_thetas2(1:500)), true_thetas2(1:500),'bo')
    X = 1:size(true_thetas2(1:550),2);  
    y = true_thetas2(1:550);
    modelfun = @(b,x)b(1) + b(2)*X(1,:)'  + b(3)*X(1,:).^2' ...
        + b(4)*sin(b(6)*X(1,:)') + b(5)*cos(b(6)*X(1,:)') ...
       + b(7)*sin(b(9)*X(1,:)') + b(8)*cos(b(9)*X(1,:)') ...
         + b(10)*sin(b(12)*X(1,:)') + b(11)*cos(b(12)*X(1,:)') ...
         + b(13)*sin(b(15)*X(1,:)') + b(14)*cos(b(15)*X(1,:)') ...
         + b(16)*sin(b(18)*X(1,:)') + b(17)*cos(b(18)*X(1,:)')...
        + b(19)*sin(b(21)*X(1,:)') + b(20)*cos(b(21)*X(1,:)')...
         + b(22)*sin(b(24)*X(1,:)') + b(23)*cos(b(24)*X(1,:)');
       % + b(25)*sin(b(27)*X(1,:)') + b(26)*cos(b(27)*X(1,:)')...
       % + b(28)*sin(b(30)*X(1,:)') + b(29)*cos(b(30)*X(1,:)');
    beta0 = ones(1,24);
    mdl = fitnlm(X,y,modelfun,beta0)
    coeffs = mdl.Coefficients.Variables;
    coeffs(2,1)*3600*415  %Get the calculated precession rate in arcsec/century.
    

end