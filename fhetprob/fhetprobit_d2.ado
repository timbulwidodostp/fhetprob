cap program drop fhetprobit_d2
program fhetprobit_d2
	version 7.0
	args todo b lnf g negH g1 g2
	tempvar xb zg t s q 
	mleval `xb' = `b', eq(1)
	mleval `zg' = `b', eq(2)
	local y "$ML_y1"
	local ny "(1-$ML_y1)"	
	quietly {
		gen double `t' = `xb'*exp(-`zg')
		mlsum `lnf' = `y'*ln(normal(`t'))+`ny'*ln(1-normal(`t'))
		if (`todo'==0 | `lnf'>=.) { exit }
		gen double `s' = normalden(`t')/normal(`t')
		gen double `q' = normalden(`t')/normal(-`t')
		replace `g1' = (`y'*`s' + `ny'*-`q')*exp(-`zg')
		replace `g2' = (`y'*`s' + `ny'*-`q')*-`t'
		tempname d1 d2
		mlvecsum `lnf' `d1'  = `g1', eq(1)
		mlvecsum `lnf' `d2'  = `g2', eq(2)
		matrix `g' = (`d1',`d2')
		if (`todo'==1 | `lnf'>=.) { exit }
		tempname t2 s2 q2 left right d11 d12 d22
		gen double `t2' = `t'*`t'
		gen double `s2' = `s'*`s'
		gen double `q2' = `q'*`q'
		gen double `left' = `s'*(`t2'-1)+`t'*`s2'
		gen double `right' = `q'*(1-`t2')+`t'*`q2'
		mlmatsum `lnf' `d11' = -(`y'*(-`t'*`s'-`s2')+`ny'*(`t'*`q'-`q2'))*exp(-2*`zg')	, eq(1)
		mlmatsum `lnf' `d12' = -(`y'*`left'+`ny'*`right')*exp(-`zg')			, eq(1,2)
		mlmatsum `lnf' `d22' = -(`y'*`left'+`ny'*`right')*-`t'				, eq(2)
		matrix `negH' = (`d11',`d12' \ `d12'',`d22')
	}
end
