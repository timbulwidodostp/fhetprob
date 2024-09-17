program define fhetprob_p
	version 6, missing

	syntax [anything] [if] [in] [, SCores * ]
	if `"`scores'"' != "" {
		ml score `0'
		exit
	}

	local myopts "Pr Sigma"
	
	_pred_se "`myopts'" `0'
	if `s(done)' { exit }
	local vtyp  `s(typ)'
	local varn `s(varn)'
	local 0 `"`s(rest)'"'

	syntax [if] [in] [, `myopts' noOFFset]

	if "`sigma'" != "" {
		tempvar lnvar
		_predict double `lnvar' `if' `in', xb eq(#2) `offset'
		qui gen `vtyp' `varn' = exp(`lnvar')
		label var `varn' "Sigma"
	}
	else {
		if "`pr'"=="" {
		   noi di in gr "(option pr assumed; fractional response E[`e(depvar)'|x] or binary Pr(`e(depvar)'))"
		}
		tempvar num denom
	        _predict double `num' `if' `in', xb eq(#1) `offset'
		_predict double `denom' `if' `in', xb eq(#2) `offset'
		qui replace `denom' = exp(`denom')
		qui gen `vtyp' `varn' = normal(`num'/`denom')
		label var `varn' "E[`e(depvar)'|x]"
	}
end
