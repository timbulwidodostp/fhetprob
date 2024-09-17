{smcl}
{viewerjumpto "Syntax" "fhetprob##syntax"}{...}
{viewerjumpto "Description" "fhetprob##description"}{...}
{viewerjumpto "Options" "fhetprob##options"}{...}
{viewerjumpto "Examples" "fhetprob##examples"}{...}
{viewerjumpto "Saved results" "fhetprob##saved_results"}{...}
{title:Title}

{phang}
{bf:fhetprob} {hline 2} Fractional heteroskedastic probit


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:fhetprob} {depvar} [{indepvars}] {ifin} {weight} {cmd:,} 
{cmd:het(}{varlist} [{cmd:,} {opth off:set(varname)}]{cmd:)} [{it:options}]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{p2coldent :* {cmd:het(}{varlist}[...]{cmd:)}}independent variables to model the variance and possible offset variable{p_end}
{synopt :{opt nocon:stant}}suppress constant term{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient constrained to 1{p_end}
{synopt :{opt asis}}retain perfect predictor variables{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}
{synopt:{opt col:linear}}keep collinear variables{p_end}

{syntab :SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
{opt r:obust}, {opt cl:uster} {it:clustvar}, {cmd:opg}, {opt boot:strap},
or {opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help fhetprob##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab :Maximization}
{synopt :{it:{help fhetprob##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt het()} is required.
{p_end}
INCLUDE help fvvarlist2
{p 4 6 2}{it:depvar}, {it:indepvars}, and {it:varlist} may contain time-series
operators; see {help tsvarlist}.{p_end}
{p 4 6 2}{cmd:bootstrap}, {cmd:by}, {cmd:jackknife}, {cmd:rolling},
{cmd:statsby}, and {cmd:svy} are allowed; see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy}
prefix.{p_end}
{p 4 6 2}{opt fweight}s, {opt iweight}s, and {opt pweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
See {helpb fhetprob_postestimation:fhetprob postestimation} for features
available after estimation.  {p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:fhetprob} fits a QMLE heteroskedastic fractional probit model.

{pstd}
See {help logistic estimation commands} for a list of related estimation commands.

{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:het(}{varlist} [{cmd:,} {opth offset(varname)}]{cmd:)} specifies the
independent variables and the offset variable, if there is one, in the
variance function.  {opt het()} is required.

{phang}
{opt noconstant}, {opth offset(varname)}; see 
{helpb estimation options:[R] estimation options}.

{phang}
{opt asis} forces the retention of perfect predictor variables and their
associated perfectly predicted observations and may produce instabilities in
maximization; see {manhelp probit R}.

{phang}
{opt constraints(constraints)}, {opt collinear}; see
{helpb estimation options:[R] estimation options}.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{dlgtab:Reporting}

{phang}
{opt level(#)}; see 
{helpb estimation options##level():[R] estimation options}.

{phang}
{opt nolrtest} specifies that a Wald test of whether {cmd:lnsigma2} = 0 be
performed instead of the LR test.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] estimation options}.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt noomit:ted},
{opt vsquish},
{opt noempty:cells},
{opt base:levels},
{opt allbase:levels},
{opth cformat(%fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch};
    see {helpb estimation options##display_options:[R] estimation options}.

{marker maximize_options}{...}
{dlgtab :Maximization}

{phang}
{it:maximize_options}: {opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)}, [{cmdab:no:}]{opt lo:g}, {opt tr:ace},
{opt grad:ient}, {opt showstep},
{opt hess:ian}, {opt showtol:erance},
{opt tol:erance(#)}, {opt ltol:erance(#)},
{opt nrtol:erance(#)}, {opt nonrtol:erance}, and
{opt from(init_specs)}; see {manhelp maximize R}.  These options are seldom
used.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{pstd}
The following option is available with {opt fhetprob} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] estimation options}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Most of the underling code is due to {helpb hetprob:[R] hetprob}. For a detailed description
of the underlying method and examples type "net get fhetprob, from(http://www.richard-bluhm.com/stata/)" at the command prompt and open fhetprob.pdf from the current directory.

{marker author}{...}
{title:Author}

{phang}
Richard Bluhm, Maastricht University, UNU-MERIT, The Netherlands.
Contact: bluhm@merit.unu.edu

{phang}
Timbul Widodo, Olah Data Semarang.
Channel: www.youtube.com/@amalsedekah/videos

{marker examples}{...}
{title:Examples}

{phang}{cmd:. import excel "https://raw.githubusercontent.com/timbulwidodostp/fhetprob/main/fhetprob/fhetprob.xlsx", sheet("Sheet1") firstrow clear}{p_end}
{phang}{cmd:. fhetprob math4 lavgrexp lunch lenrol y95 y96 y97 y98 lavgrexpb lunchb lenrolb y95b y96b y97b y98b tobs3 tobs4, het(tobs3 tobs4) vce(cluster schid) nolog}{p_end}
{phang}{cmd:. import excel "https://raw.githubusercontent.com/timbulwidodostp/fhetprob/main/fhetprob/fhetprob.xlsx", sheet("Sheet2") firstrow clear}{p_end}
{phang}{cmd:. fhetprob y x, het(xhet) nolog}{p_end}

{marker saved_results}{...}
{title:Saved results}

{pstd}
{cmd:fhetprob} saves the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_f)}}number of zero outcomes{p_end}
{synopt:{cmd:e(N_s)}}number of nonzero outcomes{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model{p_end}
{synopt:{cmd:e(ll_c)}}log likelihood, comparison model{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(chi2_c)}}chi-squared for heteroskedasticity LR test{p_end}
{synopt:{cmd:e(p_c)}}p-value for heteroskedasticity LR test{p_end}
{synopt:{cmd:e(df_m_c)}}degrees of freedom for heteroskedasticity LR test{p_end}
{synopt:{cmd:e(p)}}significance{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(rank0)}}rank of {cmd:e(V)} for constant-only model{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:fhetprob}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset1)}}offset for probit equation{p_end}
{synopt:{cmd:e(offset2)}}offset for variance equation{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test{p_end}
{synopt:{cmd:e(chi2_ct)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test corresponding to {cmd:e(chi2_c)}{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
                         maximization or minimization{p_end}
{synopt:{cmd:e(method)}}requested estimation method{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
