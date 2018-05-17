function plot_ellipse(x,y,theta,a,b,color)
    np = 200;
    ang = [0:np]*2*pi/np;
    pts = [x;y]*ones(size(ang)) + [cos(theta) -sin(theta); sin(theta) cos(theta)]*[cos(ang)*a; sin(ang)*b];
    plot( pts(1,:), pts(2,:) , 'Color', color );
end