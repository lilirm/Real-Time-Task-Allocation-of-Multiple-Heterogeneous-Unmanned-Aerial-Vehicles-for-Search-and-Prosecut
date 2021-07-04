function uavPlot(pos, psi, col)
% pos = [20 30]';
% psi = 2.45;
% col = 'b';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% uavPlot(handle, agent, P, dir) - updates the plot of each agent
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SIZE = 1;
ap = translate(rotate(SIZE*apData,psi),pos);
handle=fill(ap(1,:),ap(2,:),col);
set(handle,'XData',ap(1,:),'YData',ap(2,:));
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% apData - data points of the plane
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ap = apData
% apData:  define the points on the aircraft 
%   ap = [...
% 	 5,0;...      0,0;...
% 	-5,-5;...   -10,-5;...
% 	-2,0;...     -7,0;...    
% 	-5,5;...    -10,5;...   
% 	 5,0;...      0,0;...       
%   ]';
ap = 2*[...
    10,0;
    -10,-10;
    -5,0;
    -5,5;
    10,0;]';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rotate(data, phi) - rotates data by angle phi and returns the results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = rotate(data,phi)
% rotate:  rotate data by phi
   R   = [cos(phi) -sin(phi); sin(phi) cos(phi)];
   out = R*data;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% translate(data, r) - translates data to point defined by r and returns
% the results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = translate(data,r)
% translate:  translate data by r
   out = data + r*ones(1,length(data));

