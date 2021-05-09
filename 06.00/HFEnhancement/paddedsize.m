function PQ = paddedsize(AB, CD, PARAM)
if nargin == 1
    PQ = 2 * AB;
elseif nargin == 2 && ~ischar(CD)
    PQ = AB + CD - 1;
    PQ = 2 * ceil(PQ / 2);
elseif nargin == 2
    m = max(AB);
    P = z ^ nextpower(2 * m);
    PQ = [P, P];
elseif nargin == 3
    m = max([AB, CD]);
    P = 2 ^ nextpower(2 * m);
    PQ = [P, P];
else
    error('Wrong number inputs.')
end