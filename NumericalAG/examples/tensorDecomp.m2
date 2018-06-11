restart
dimSlices=(2,2,2) -- tensor format
d=#dimSlices
L=toList dimSlices
r=ceiling((product L)/(1-d+sum L))

-- IN: s, a sequence giving the tensor format
-- OUT: indices for the tensor's entries
makeParameterIndices = s -> (
    d:=#s;
    if d==1 then return toList apply(0..(first s-1),i->sequence(i))
    else (
	r:=makeParameterIndices(drop(s,-1));
	flatten apply(last s,i->toList apply(r,t->append(t,i)))
	)
    )

-- example
makeParameterIndices dimSlices

-- IN: s, a sequence giving the tensor format,
--     j, indexing a rank-1 tensor appearing in a rank decomposition
-- OUT: variable indices in the format (summand, slice, entry)
-- in each summand, we normalize the first coordinate of all but the last factor
-- to remove trivial degrees of freedom
makeVariableIndices = (s,j) -> (
    d:=#s;
    flatten apply(d,n-> (
	    if n==d-1 then start:=0 else start=1;
	    apply(toList(start..(s#n-1)),i->(j,n,i)
	    )))
	)

-- example    
makeVariableIndices(dimSlices,0)

--paramter ring generated by the coordinate of a generic tensor of given format
w=symbol w
S=CC[apply(makeParameterIndices dimSlices,ind->w_ind)]

--variable ring generated by coordinates of a factorization
L=apply(r,j->makeVariableIndices(dimSlices,j))
x=symbol x
R=S[apply(flatten L,ind->x_ind)]

--get equations for decomposition
ind=last baseName (gens S)#3
equation = ind -> (
    w_ind_R - sum apply(r,i-> (
	    	    product apply(d,k-> (
		    	    if ind#k < dimSlices#k-1 and k<d-1 then return 1
			    else return x_(i,k,ind#k)_R)))))

pIndices=apply(makeParameterIndices dimSlices,ind->equation ind)
netList pIndices

-- parametric solver?
needsPackage "MonodromySolver"
(V,npaths)=monodromySolve(polySystem pIndices)