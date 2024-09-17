cap program drop _all
program define fhetprob, eclass byable(onecall)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun hetprob, mark(CLuster) : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"fhetprob `0'"'
		exit
	}

	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	version 6, missing
	if replay() {
		if "`e(cmd)'" != "fhetprob" {
			error 301
		}
		if _by() { error 190 }
		Display `0'
		exit
	}
	est clear
	`vv' `BY' Estimate `0'
	version 10: ereturn local cmdline `"fhetprob `0'"'
end

program define Estimate, eclass byable(recall)
	version 6, missing
	syntax varlist(ts fv) [if] [in] [fweight pweight iweight] , /*
		*/ het(string)  [Robust CLuster(varname numeric) /*
		*/ SCore(string) OFFset(varname numeric) /*
		*/ FROM(string) noCONstant noLOg /*
		*/ Level(cilevel) MLMethod(string) /*
		*/ DOOPT VCE(passthru) * ]
	
	local fvops = "`s(fvops)'" == "true" | _caller() >= 11

	if _by() {
		_byoptnotallowed score() `"`score'"'
	}

	* always force difficult option 
	local diff "difficult"
	*always force robust for QMLE VCE
	local robust "robust" 
	local p_vars `varlist'
	_get_diopts diopts options, `options'
	mlopts mlopt, `options'
	local coll `s(collinear)'
	local cns `s(constraints)'
	local p_off `offset'
	local p_cons `constan' 

	marksample touse
	
	* think about what other VCE options can be allowed!!!
	if "`weight'" != "" { local wgt [`weight'`exp'] }
	if "`cluster'" != "" { local clopt "cluster(`cluster')" }
        _vce_parse, argopt(CLuster) opt(Robust oim) old: ///
                [`weight'`exp'], `vce' `clopt' `robust'
        local cluster `r(cluster)'
        local robust `r(robust)'
	if "`cluster'" != "" { local clopt "cluster(`cluster')" }
	if "`score'" != "" {
		local wcount : word count `score'
		if `wcount'==1 & substr("`score'",-1,1)=="*" { 
			local score = /*
			*/ substr("`score'",1,length("`score'")-1)
			local score `score'1 `score'2 
			local wcount 2
		}
		if `wcount' != 2 {
			di in red "score() requires two new variable names"
			exit 198
		}
		local s1 : word 1 of `score'
		local s2 : word 2 of `score'
		confirm new var `s1' `s2'
		tempvar sc1 sc2
		local scopt "score(`sc1' `sc2')"
	}

	local 0 `het'
	syntax varlist(numeric min=1 ts fv) [, OFFset(varname numeric) /*
			*/	noCONstant *]
	
	if !`fvops' {
		local fvops = "`s(fvops)'" == "true"
	}
	if `fvops' {
		if _caller() < 11 {
			local vv "version 11:"
		}
		else	local vv : di "version " string(_caller()) ":"
		local mm e2
		local negh negh
		local fvexp expand
		if "`cns'" != "" {
			local cnsopt constraint(`cns') `coll'
		}
	}
	else {
		local vv "version 8.1:"
		local mm d2
	}
	if "`mlmethod'" == "" {
		local mlmetho `mm'
	}

	local heti `varlist'
	local hetf `offset'
	local offset ""
	
	markout `touse' `cluster' `offset' `heti' `hetf', strok
	`vv' ///
	_rmcoll `heti' if `touse', constant `coll' `fvexp'
	local heti "`r(varlist)'"
	
* sanity check hetero arguments 
	if "`constan'`options'" != "" {
		noi di in red "Heteroskedastic option(s) not permitted: " _c
		noi di in red "`constan' `options'"
		exit 101
	}
	
* process hetero offset 
	if "`hetf'" != "" {
		local hetoff "offset(`hetf')"
		markout `touse' `hetf'
	}	

* check predictor equation, do not allow factors and ts ops
	tokenize `p_vars'
	local dep `1'
	_fv_check_depvar `dep'
	tsunab dep : `dep'
	local depn : subinstr local dep "." "_"
	mac shift
	local ind `*'
	if "`p_cons'" == "noconstant" & "`ind'" == "" {
		noi di in red "independent varlist required with " _c
		noi di in red "noconstant option."
		exit 100
	}
	
* predictor offset 
	if "`p_off'" != "" {
		local offset "offset(`p_off')"
		markout `touse' `p_off'
	}
	

* check rhs for collinearity 
	`vv' ///
	noi _rmcoll `ind' if `touse', `p_cons' `coll' `fvexp'
	local ind "`r(varlist)'"
	
* check doesn't vary and warn to use offical cmds
	qui count if `dep' == 0 & `touse'
	local nneg = r(N)
	qui count if `dep' == 1 & `touse'
	local npos = r(N)	
	local ntot = `npos' + `nneg'	
	qui count if `touse'
	if r(N) == `ntot' {
		noi di _n in ye "The dependent variable is binary and not a fractional response. Consider using" 
		noi di _c in ye "the official 'hetprob' command instead. The fhetprob program does not verify"
		noi di _n in ye "if the outcome variable is specified correctly for the binary response case." 	
	}
 
* iteration log: quitely or noisily
	if "`log'" != "" { 
		local log quietly 
	}
	else {
		local log noisily
	}
	
	local continu "wald(1)"

	if "`from'" != "" {
		local init "init(`from')"
	}

	`log' display _n in gr "Fitting QMLE model (option " in ye "difficult" in gr " implied):"
	#delimit ;
	`vv'
	`log' ml model `mlmethod' fhetprobit_d2 
		(`depn': `dep' = `ind', `p_cons' `offset') 
		(lnsigma2: `heti', nocons `hetoff') if `touse' `wgt', 
		max missing nopreserve `mlopt' `continu' search(off)
		`clopt' `scopt' `robust' nooutput `init' `diff' `negh' ;
	#delimit cr

	if "`scopt'" != "" {
		rename `sc1' `s1'
		if "`s2'" != "" {
			rename `sc2' `s2'
		}
		est local scorevars `s1' `s2'
	}

	qui test [lnsigma2]
	est scalar chi2_c = r(chi2)
	est scalar df_m_c = r(df)
	est scalar p_c    = r(p)
	est scalar aic 	  = -2*e(ll) + 2*e(k)

	est local method "ml"
	est local predict "fhetprob_p"
	est local cmd "fhetprob"

	Display, level(`level') `diopts'
end

program define Display
	if "`e(prefix)'" == "svy" {
		_prefix_display `0'
		exit
	}
	syntax [, Level(cilevel) *]

	_get_diopts diopts, `options'
	local crtype = upper(substr(`"`e(crittype)'"',1,1)) + /*
		*/ substr(`"`e(crittype)'"',2,.)

	di in gr _n "Heteroskedastic fractional probit model" _col(49) /*
		*/ "Number of obs     =" in ye _col(70) %9.0g e(N)
	if !missing(e(df_r)) {
		di in gr _col(49) "F(" %4.0f in ye `e(df_m)' /*
			*/ in gr "," in ye %7.0f e(df_r) /*
			*/ in gr ")" _col(67) "=" in ye _col(70) %9.2f e(F) 
		di in gr "`crtype' = " in ye %9.0g e(ll) /*
			*/ in gr _col(49) "Prob > F" _col(67) "=" /*
			*/ in ye _col(70) /*
			*/ in ye %9.4f Ftail(e(df_m),e(df_r),e(F)) _n
	}
	else {
		if "`e(chi2type)'" == "Wald" & missing(e(chi2)) {
			di in smcl _col(49) 				/*
*/ "{help j_robustsingular##|_new:Wald chi2(`e(df_m)'){col 67}= }"	/*
*/				in ye _col(70) %9.2f e(chi2)
		}
		else {
		      di in gr _col(49) "`e(chi2type)' chi2(" in ye `e(df_m)' /*
			*/ in gr ")" _col(67) "=" in ye _col(70) %9.2f e(chi2) 
		}
		di in gr "`crtype' = " in ye %9.0g e(ll) /*
			*/ in gr _col(49) "Prob > chi2" _col(67) "=" /*
			*/ in ye _col(70) /*
			*/ in ye %9.4f chiprob(e(df_m),e(chi2)) _n
	}

	version 10: ml di, noheader level(`level') `diopts'
        di in gr "Wald test of lnsigma2=0:             " _c
	di in gr "chi2(" in ye "`e(df_m_c)'" in gr ") = " in ye %8.2f e(chi2_c) _c
	di in gr "   Prob > chi2 = " in ye %6.4f chiprob(e(df_m_c),e(chi2_c))
	if (e(vce) != "oim" &  e(vce) != "cluster") {
	di in gr _n "For fractional responses oim SEs are too big, " in ye "robust" in gr " option implied to correct" 
	di in gr _c "bias. For binary responses non-robust SEs can be obtain with option vce(oim)." _n
	}
end
