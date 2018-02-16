%% savgol
% Savitzky-Golay filter, for data smoothing and derivatives
%
%% Syntax
%     y=savgol(x, pol_degree, win_size, deriv, rate)
%
%% Input Arguments
% * x -- Input data (vector or column matrix)
% * pol_degree -- Degree of polynomial
% * win_size -- Window-size (has to be uneven!)
% * deriv -- Order of derivative ("0" for smoothing, "1" for first
% derivative, etc.). Default is "0"
% * rate -- Sample rate [Hz]. Default is "1"
%
%% Output Arguments
% * y -- Filtered data 
% 
%% Notes
%  "Cutoff-frequencies":
%
% for smoothing (deriv=0), the frequency where
% the amplitude is reduced by 10% is approximately given by
%
%    f_cutoff = sampling_rate / (1.5 * look)
%
% for the first derivative (deriv=1), the frequency where 
% the amplitude is reduced by 10% is approximately given by
%
%    f_cutoff = sampling_rate / (4 * look)
%	
% Coefficients:
%
%    C(i,k) = i! / delta_sample * SUM(j=0,..,n) { s_inv[i][j] * k^j }
%
% with i = 0,.., n (= degree of polinomial fitted)
%
% k = -m,..,m (= number of points taken for the fit)
%
% $$S(i,j) = \sum_{k=-m}^{m} k^{i+j}$$
%
% with i,j = 0,..,n
%
%
%% Literature
%
% * Siegmund Brandt, Datenanalyse, pp 435
% * Press et al., Numerical Recipes, 2nd ed, pp 650
% * Savitzky and Golay: Analytical Chemistry, Vol.36, No.8, Jul 64, 1627 ff
%
%% Examples
%    smoothed = SAVGOL(x, 3, 7, 0);  % smooth data, with a cubic polynomial and a window-size of 7
%    acc = SAVGOL(pos, 3, 11, 2, 10) % calculate the second derivative of 10-Hz data 
%
%% See Also
% sgolay, sgolayfilt, filter

% --------------
% author: ThH

function y=savgol(x, pol_degree, win_size, deriv, rate)

% Set the default values if necessary:
if (nargin==1)
	pol_degree=2
	win_size=3
	deriv=0
	rate=1;
elseif (nargin==2)
	win_size=3
	deriv=0
	rate=1;
elseif (nargin==3)
	deriv=0
	rate=1;
elseif (nargin==4)
	rate=1;
	if deriv > 0
		disp(['Default sampling rate: ' num2str(rate)]);
	end
end

% Check the input format:
[n_rows, n_cols] = size(x);
if n_rows == 1
    row_flag = 1;
else
    row_flag = 0;
end
[x, num_row, num_col] = check_input(x, win_size, pol_degree, deriv);
look = (win_size-1)/2;

% Construct Vandermonde matrix:
[a, pa, p] = get_vandermonde(win_size, pol_degree, look, deriv, rate);

% Get the coefficients for the fits at the beginning and at the end of the data:
coefs = (0:pol_degree).^sign(deriv);
coef_mat = zeros(pol_degree+1);
row = 1;
for i=deriv+1:pol_degree+1
	coef = coefs(i);
	for j=1:(deriv-1)
		coef = coef * (coefs(i)-j);
	end
	coef_mat(row,row+deriv) = coef;
	row = row + 1;
end;
coef_mat = coef_mat * rate^deriv;

% Add the first and the last point "look"-times, and handle NaNs
[x_calc, nan_index] = prepare_data(x, look);

% filter the data:
% for the convolution, the filter coefficients have to be inverted
p = p(length(p):-1:1);
y_filt = [];
for i=1:num_col
	y_filt = [y_filt; filter(p,1,x_calc(i,:))];	% watch out, the data are transposed!
end

% chop away intermediate data ...
y = y_filt(:, win_size:win_size-1+num_row)';

% ...and adjust the first and the last few data:

% filtering for the first few datapoints
y(1:look,:)=a(1:look,:)*coef_mat*pa*x(1:win_size,:);

% % smoothing for the inner interval points
% for i=look+1:n-look
%   y(i,:)=p*x(i-look:i+look,:);
% end

% filtering for the last few datapoints
y(num_row-look+1:num_row,:)=a(look+2:win_size,:)*coef_mat*pa*x(num_row-win_size+1:num_row,:);

% Put back the NaNs where they were:
if ~isempty(nan_index)
	y(nan_index) = NaN;
end

if row_flag == 1
    y = y';
end
% ============================= THE END =======================================

% Check the form of the input data
function [x_out, num_row, num_col] = check_input(x_in, win_size, pol_degree, deriv)
% Determine the size of the data:
[num_row, num_col]=size(x_in);

% If necessary, bring them in column form:
if num_row < num_col 
	x_out = x_in';
	[num_row,num_col]=size(x_out);
else
	x_out = x_in;
end
clear x_in;

% Check input arguments:
if (win_size>num_row) 
	disp('Not enough data points!');
	disp('Unless you make "win_size" smaller, the output is empty.');
	y=[];
	return;
end
if (win_size-1<pol_degree)
	disp('The "pol_degree" of the polynomial is too high!');
	disp('Unless you make the "pol_degree" smaller, or increase "look", the output is empty.');
	y=[];
	return;
end
if (pol_degree<=deriv)	% The "=" is only to avoid non-sensible output. The
	% code would not crash.
	disp('The "deriv" of the polynomial is too high!');
	disp('Unless you make the "deriv" smaller, or increase "pol_degree", the output is empty.');
	y=[];
	return;
end

if ~mod(win_size, 2)
	disp('WIN_SIZE has to be odd!');
	return;
end

% ===================================================================================================
function [a, pa, p] = get_vandermonde(win_size, pol_degree, look, deriv, rate)
a   = zeros(win_size,pol_degree+1);
for ii=1:win_size
	for jj=1:pol_degree+1
		a(ii,jj) = (ii-1-look)^(jj-1);
	end
end

pa = pinv(a);
p = prod(1:deriv) * rate^deriv * pa(deriv+1,:);  % Savitzky-Golay Coefficients
% ===================================================================================================
function [x_ext, nan_index] = prepare_data(x, look)

[num_row, num_col] = size(x);

% Start and End-appendices:
x_start = zeros(num_col, look);
x_end   = zeros(num_col, look);

% Handle NaNs: --------------------------------------
if any(isnan(x))
	no_num.index = isnan(x);
	no_num.start = find(diff(no_num.index)== 1);
	no_num.stop  = find(diff(no_num.index)==-1)+1;

	if no_num.start(1) < no_num.stop(1)
		no_num.correct_start = 0;
	else
		no_num.correct_start = 1;
	end

	if no_num.stop(end) > no_num.start(end)
		no_num.correct_stop = 0;
	else
		no_num.correct_stop = 1;
	end

	stop_length = length(no_num.stop)-no_num.correct_start;
	for ii = 1:stop_length
		start_ind = no_num.start(ii);
		stop_ind = no_num.stop(ii+no_num.correct_start);
		x(start_ind:stop_ind) = linspace(x(start_ind), x(stop_ind), stop_ind-start_ind+1)';
	end
	% Pass back the required variables
	nan_index = no_num.index;
else
	nan_index = [];
end
% For start and end: --------------------------------------
for ii = 1:look
	x_start(ii) = x(1);
	x_end(ii) = x(num_row);
end

x_ext = [x_start x' x_end];

% ===================================================================================================
