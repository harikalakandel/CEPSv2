%% licence

% Copyright (c) 2006, Phillip M. Feldman
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.


function RMS= rms(varargin)
%
% Written by Phillip M. Feldman  March 31, 2006
%
% rms computes the root-mean-square (RMS) of values supplied as a
% vector, matrix, or list of discrete values (scalars).  If the input is
% a matrix, rms returns a row vector containing the RMS of each column.

% David Feldman proposed the following simpler function definition:
%
%    RMS = sqrt(mean([varargin{:}].^2))
%
% With this definition, the function accepts ([1,2],[3,4]) as input,
% producing 2.7386 (this is the same result that one would get with
% input of (1,2,3,4).  I'm not sure how the function should behave for
% input of ([1,2],[3,4]).  Probably it should produce the vector
% [rms(1,3) rms(2,4)].  For the moment, however, my code simply produces
% an error message when the input is a list that contains one or more
% non-scalars.

if (nargin == 0)
   error('Missing input.');
end


% Section 1: Restructure input to create x vector.

if (nargin == 1)
   x= varargin{1};

else

   for i= 1 : size(varargin,2)
      if (prod(size(varargin{i})) ~= 1)
         error(['When input is provided as a list, ' ...
                'list elements must be scalar.']);
      end

      x(i)= varargin{i};
   end
end


% Section 2: Compute RMS value of x.

RMS= sqrt (mean (x .^2) );
