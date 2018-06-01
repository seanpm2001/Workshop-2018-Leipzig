newPackage(
        "Reduction",
        Version => "0.1", 
        Date => "May 31, 2018",
        Authors => {{Name => "Dylan Peifer", 
                     Email => "djp282@cornell.edu", 
                     HomePage => "https://www.math.cornell.edu/~djp282"}},
        Headline => "Interface to Groebner basis reduction tools in the engine",
        DebuggingMode => true
        )

export {"divAlg"}

debug Core; -- for rawDivisionAlgorithm

divAlg = method()
divAlg(Matrix, Matrix) := Matrix => (f, g) -> (
    -- f = a matrix over a polynomial ring
    -- g = a matrix over the same ring as f
    -- returns a matrix containing remainders when each column of f is reduced via
    --     polynomial long division by columns of g

    map(target f, source f, rawDivisionAlgorithm(raw f, raw g, 0))
    )

divide = method()
divide(RingElement, List) := RingElement => (g, F) -> (
    -- g = a polynomial
    -- F = a list of polynomials
    -- returns a remainder when g is divided by F

    r := 0;
    while g != 0 do (
	lg := leadTerm g;

	-- try to remove lead term by some f
	for i from 0 to #F-1 do (
	    f := F#i;
	    lf := leadTerm f;
	    if (lg % lf) == 0 then (
		g = g - (lg//lf) * f;
		lg = 0;
		break;
		);
	    );

	-- add lead term to remainder if it is still nonzero
	r = r + lg;
	g = g - lg;
	);
    r
    )

interreduce = method()
interreduce(List) := List => (F) -> (
    -- F = a list of polynomials forming a minimal Groebner basis
    -- returns the interreduction of F

    G := {};
    for f in F do (
	g := divide(f, delete(f, F));
	G = append(G, 1/(leadCoefficient g) * g);
	);
    G
    )

minimalize = method()
minimalize(List) := List => (F) -> (
    -- F = a list of polynomials forming a Groebner basis
    -- returns a minimal Groebner basis from F

    G := {};
    for f in F do (
	if all(G, g -> (leadTerm f) % (leadTerm g) != 0) then (
	    G = select(G, g -> (leadTerm g) % (leadTerm f) != 0);
	    G = append(G, f);
	    );
	);
    G
    )

beginDocumentation()

end--

doc ///
Key
  Reduction
Headline
Description
  Text
  Example
Caveat
SeeAlso
///

doc ///
Key
Headline
Usage
Inputs
Outputs
Consequences
Description
  Text
  Example
  Code
  Pre
Caveat
SeeAlso
///

TEST ///
-- test code and assertions here
-- may have as many TEST sections as needed
///