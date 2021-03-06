function [in] = mod_brach_trig() 
% 
% This function creates input for the optimization problem,  
% which is later used by other functions  
% 
% input : void 
% output : in [structure] 
% Developed by : Dr. K. Mall and Dr. M.J. Grant
% Last modified: Mar 23, 2019

%%%%%%%%%%%%%%%%%%%%%%% 
%% Execution Control %% 
%%%%%%%%%%%%%%%%%%%%%%% 

% Set desired tolerances for the solvers 
in.oc.writeEquations = true;

%%%%%%%%%%%%%
%% Scaling %%
%%%%%%%%%%%%%

% Doubles must be equal to one (not dynamically updated during continuation)
in.autoScale = true;
in.scale = {'m',1; ...
			's',1; ...
            'rad',1;...
			'nd',1}; % nd = nondimensional

%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Independent Variable %%
%%%%%%%%%%%%%%%%%%%%%%%%%%
% e.g., time

in.oc.independentVariable = {'t','s'}; % time

%%%%%%%%%%%%
%% States %%
%%%%%%%%%%%%

in.oc.state = {'x','m'; ... % position 
               'y','m'; ... % position 
			   'v','m/s';...% velocity
               'alfa','rad'}; 

%%%%%%%%%%%%%%%%%%%%%%%%%
%% Equations of Motion %%
%%%%%%%%%%%%%%%%%%%%%%%%%

in.oc.stateRate = {'v*sin(alfa)'; ...
                   'v*cos(alfa)';...
                   'g*cos(alfa)';...
				   'alfarate*sin(bcmodtrig)'}; 

%%%%%%%%%%%%%
%% Control %%
%%%%%%%%%%%%%

in.oc.control = {'bcmodtrig','rad'};

in.oc.assumptions.control = ''; % assumptions for Mathematica when solving for control

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Objective Information %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Path cost
in.oc.cost.path     = {'alfa^2/2 + epsilon*cos(bcmodtrig)','rad^2'}; 

% Terminal cost 
in.oc.cost.terminal = {'0','rad^2*s'}; 

% Initial cost 
in.oc.cost.initial  = {'0','rad^2*s'}; 

%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Endpoint Constraints %%
%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initial constraint 
in.oc.constraint.initial = {'x-x0(1)','m'; ...
                            'y-x0(2)','m'; ...
							'v-x0(3)','m/s'};
													 
% Terminal constraint
in.oc.constraint.terminal = {'x-xf(1)','m'; ...
							 'y-xf(2)','m'};
% Constants
in.const.alfarate = {pi,'rad'};  
in.const.g        = {9.80665,'m/s^2'};
in.const.epsilon  = {0.1,'nd'};
in.const.tol      = {1e-6,'nd'}; 
in.const.NMax     = {1e7,'nd'}; 

%%%%%%%%%%%%%%%%%%%
%% Initial Guess %%
%%%%%%%%%%%%%%%%%%%

% in.oc.initialGuessFunc = @getInitialGuess;
in.oc.guess.mode = 'auto';
in.oc.guess.timeIntegrate = 0.1; % 0.1 leads to local min

% % Use automatic init
% Conditions at entry
in.oc.guess.initial.x = 0;
in.oc.guess.initial.y = 0;
in.oc.guess.initial.v = 0;
in.oc.guess.initial.alfa = 0;
in.oc.costates = -0.1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Continuation Execution %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ind = 0;

%%%%%%%%%%%%%%%%%%%%%%
%% Continuation Set %%
%%%%%%%%%%%%%%%%%%%%%%

ind = ind+1;
in.cont.method(ind) = 1;
in.CONT{ind}.numCases = 10;% 7 Number of steps in the continuation set 

in.CONT{ind}.constraint.terminal.x = 2;
in.CONT{ind}.constraint.terminal.y = 2;

%%%%%%%%%%%%%%%%%%%%%%
%% Continuation Set %%
%%%%%%%%%%%%%%%%%%%%%%
ind = ind + 1;
in.cont.method(ind) = 1;
in.CONT{ind}.numCases = 10;% Number of steps in the continuation set 
in.CONT{ind}.const.epsilon = linspace(0,-(0.1-0.001),in.CONT{ind}.numCases);
return