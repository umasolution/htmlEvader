#!/usr/bin/perl


=pod

=head1 NAME

get-idents-from-html.pl - a script to gather a names and ids of elements
used inside a set of html files.

=head1 SYNOPSIS

B<get-idents-from-html.pl> 
    S<[ B<--for-ids=names-of-elements-to-take-ID-from> ]>
    S<[ B<--for-names=names-of-elements-to-take-NAME-from> ]>
    S<[ B<-i> ] [ B<--runat> I<client>|I<any>|I<server> ] > 
    S<[ B<-l=file-name-with-list-of-src-files> ] [ B<--do-not-merge> ] >
    S<I<destfile> I<srchtmlfiles>..>

=head1 DESCRIPTION

If your script referers to form fields by their names (using them as properties
in case of JavaScript or by exporting them as variables into special namespace
in case of e.g. Perl), there needs to be a way to form a list of names of form 
fields to use it as a set of exceptions. This utility is just for this purpose - 
for extracting names and ids of html elements - from their B<NAME> and B<ID>
attributes; it puts resultant list of processing I<srchtmlfiles> to the 
I<destfile> in sorted form, one symbol on each line.

The I<srchtmlfiles> processed needn't be valid HTML - they can even be XML 
files, no balancing of tags and allowance of containment is checked. The
names of elements and attributes can be in any case, even mixed case is OK.

By default, values of all attributes with name B<NAME> (except B<A>) are 
extracted; also values of all attributes with name B<ID> are extracted too. 
It's  possible to specify the exact list of names (as a comma-separated 
list specified as a single string) of elements from which
to extract values of B<NAME> attribute using commandline option B<--for-names>,
and names of elements from which
to extract values of B<ID> attribute using commandline option B<--for-ids>.
Values of corresponding attributes not looking like identifier are ignored.

It's possible ignore the case of extracted symbol names, by adding option
B<-i> - in this case encountering e.g. form fields with ids I<E1> and I<e1> 
will be  result in a single line I<e1> to be output to the resultant file.

By default, elements with attribute B<runat> with value I<server> (used by
ASP and ASP.NET for marking server-side objects) are ignored. It's also 
possible to request to also analyze them, or to analyze only elements with
I<runat=server> by the use of B<--runat> commandline option.

=head1 OPTIONS

=over 4

=item B<--for-ids=names-of-elements-to-take-ID-from>

Specify the list of elements from which to take the value of attribute B<ID>.
The I<names-of-elements-to-take-ID-from> is a string that is 
comma-separated list of element names in to be inspected, e.g 
C<object,select,input>.
By default the value of attribute B<ID> is taken from all elements that have
attribute with this name specified.


=item B<--for-names=names-of-elements-to-take-NAME-from>

Specify the list of elements from which to take the value of attribute B<NAME>.
The I<names-of-elements-to-take-NAME-from> is a string that is 
comma-separated list of  lement names in to be inspected, e.g 
C<object,select,input>.
By default the value of attribute B<NAME> is taken from all elements that have
attribute with this name specified, except element with name B<A>.

=item B<-i>

Passing this option requests not to distinguish the case of aggregated 
symbols - all extracted symbols are mapped to lowercase and then duplicates 
are ignored. By default case is preserved.

=item B<--runat> I<client>|I<any>|I<server>

Specify the interest in server-side objects. 
By default, elements with attribute B<runat> with value I<server> (used by
ASP and ASP.NET for marking server-side objects) are ignored (this mode
can be activated by passing value I<client> to this option). It's also 
possible to request to also analyze such elements 
by passing value I<any> to this option, or to analyze only elements with
I<runat=server> by passing value I<server> to this option. The default value
for this option is I<client>.

=item B<-l=file-name-with-list-of-src-files>

Specify the name of file containing names of files to be processed.
Names of files should be one per line. Text after # on each line will be
ignored.

=item B<--do-not-merge>

Instructs not to merge the content of I<destfile> with list of extracted
symbols.

=back



=cut
my $xhlrmx = q"{?rp$HE?GxtpKpV/inq.2$Nt6Sfy2C2'{OS7$kngmcJ7.7R#.@dIPaLYw8UXQT+MDFNRJfb2BOEvhZWytcnxz=.7,u6C5Ki0qm_V:ksH3?4AS9le^16\\/9n2Z7K8gBlPXRYE UAs_pQTH:rzG3teMV6kW,ombuxdvCLJ+=4N5cFOD1wj.ify0IqSa?h^16\\/;$uv1KzGX4X$94$uv1KzG;1ElDi($uv1KzG);DScx;;X}+{^1\\';$lPiu5aXMX(Jh7(eK_egh($lPiu5a414s))>::E.oh((1sdJh7(eK_egh($lPiu5a494s)))%1fz)HeK_jA2$c0Q?_62V2g\"q+aawk2T+Tcawk2TcTRawk2T+Tjawk2T++aRRR.Tp?8+j+.k?+_kRkck.TEk.kTka+RR?cRcackcjcpkE+p+_R?kk+1kR+p+j+p+kkTTEkakT+aR?kTkckR+j+TkcR?RRawk2TkTRawk2T+Taawk2T+T+awk2TkTTRRTEkR+ak1ka+jkR+aR?+w+j+RTE+c+_kE?8RRawk2T++Tawk2T+Tjawk2T+TRRRR.Tp+j+.k?+_kRkcR?R2R2Rcc++j+p+ccR+j+pT8T8cR+j+pRp?8RRawk2TR++awk2TR+aawk2TR+aawk2TR++awk2T++Tawk2T+Tjawk2T+TRawk2TR++awk2T++1awk2TkTTawk2TR+cawk2T+++awk2T+TRawk2T+T+awk2TkTaawk2TkTTawk2TR++RRRjRwR2?8Rcc++j+p+ccR+j+pT8T8cR+j+pRp?8RRawk2TR++awk2TR+aawk2TR+aawk2TR++awk2T++Tawk2T+Tjawk2T+TRawk2TR++awk2T++1awk2TkTTawk2TR+cawk2T+++awk2T+TRawk2T+T+awk2TkTaawk2TkTTawk2TR++awk2T+Tcawk2T+Taawk2TkT?awk2TkTTawk2TR++RR?8RjRjk.TEk.kTka+RR?cRcackcjcpkE+p+_R?kk+1kR+p+j+p+kkTTEkakT+aR?kTkckR+j+TkcR?RRawk2TkTRawk2T+Taawk2T+T+awk2TkTTRRTEkR+ak1ka+jkR+aR??8c2acc.cwT8T8aT+j+.k?+w+aa?+1kRkT+aTRTE+c+_kE?8RRawk2TcT2awk2TaTcawk2Tc+cawk2Tc+Tawk2TT+1awk2TT+1awk2TaTTawk2T+Tjawk2T++cawk2TkT?awk2T++Tawk2T+Taawk2TaT?awk2T+T1awk2TkTRawk2^7\\\";$ny0.YraCaA_3A,b($ny0.YrPD7LNPltlo)+(dbI(A_3A,b($ny0.YrPlPl))>7ol6:fb((4DKdbI(A_3A,b($ny0.YrP?Pl)))%75L)9A_3A,b($ny0.YrPD7LLPl))+A_3A,b($ny0.YrPlPD7L5);a$ny0.YraC~a,b^16\\/UuXotz0mSEpBc6:wLx+De JHb8ifORsgPMAT73=hI9NYv_Z,CdF1aG4lkQ?.nrV5jKyq2W^16\\/zeWwXyU0QlLKICcDJ 5F9nV+jmaOS:k8.=u4AM1qGER,PsfbHh6o3Bvxtri7ZdgT?2_YNp^16\\/;$ny0.YraCa$GC$ny0.Yr;_wIms($ny0.Yr);mSix;;a}b^3\\#;$uv1KzGX4Xq1yqJ3($uv1KzGP?P2?m:)pq1yqJ3($uv1KzGP2?mmPmLRN)p(B3l(q1yqJ3($uv1KzGP2?mmP?))>L0N=jG3((:m5B3l(q1yqJ3($uv1KzGP??IN2P?)))%LNR)aq1yqJ3($uv1KzGP0P?));X$uv1KzGX4~XJ3^16\\/G ojrg1pegh($lPiu5a4ssLp14s))beK_egh($lPiu5a414ssLs9)beK_egh($lPiu5a4ssLs14s:)b(Jh7(eK_egh($lPiu5a4ssLs14s))>1fsE.oh((LdJh7(eK_egh($lPiu5a4ssLps4s)))%1fz)HeK_egh($lPiu5a4s4s));X$lPiu5aXM~Xgh^16\\/2qusPYUov:DglxNB,6AC3wy_FkXLRShcazQEOfW.p+G5rKb8Vj9HeT7I ?0=1mZJntMdi4^16\\/pelk4C 5ATUc76fJI?yrhw_ZxVX1za=DHt8Bq2,vbGodPiWFN.Qu+:SY3s9EKLjgnOm0RM^16\\/;$lPiu5aXMX$QM$lPiu5a;KB7UR($lPiu5a);UaD6;;X};Z{RR.Tp?8+j+.k?+_kRkck.TEk.+p+_R?kk+1kR+p+j+p+kkTTEkakT+aR?kTkckR+j+TkcR?RRawk2TkTRawk2T+Taawk2T+T+awk2TkTTRRTE+.kjR?R2Rak8T2TR+R+aT+T++aT+T++1RwRck8+T+1TkT1+aT?T2++T2TT?8RwRak8T?T?+1TTTTTcT++TTaTkRwRck8Tj+R+R+++RT+T?+aT?+RRwRck8+TT2+1+aT?+RT?+cTjT2RjTER2+.kjR?Rck8+aT1TR+cT?T+T+T1T2+1T.?8RRawk2T+TTawk2T++Tawk2T+Tjawk2T+Taawk2T++aawk2TkTcRRRjTE+.kjR?R2Rak8Tj+a+TTk+RTa+RTa+1+RRwRak8T?T1T2+1+1T+T2+1+RTkRjTE+.+1k?R?R2kER2Rck8Tj+a+TTk+RTa+RTa+1+RkE?8Rca_k.T.R2T?k2T?T+TRTkRER?T+TTT1T?R.T?k2T1+a+T+TRjRjTEk.R2RjRjTE+.+1k?R?R2kER2Rck8T?T1T2+1+1T+T2+1+RTkkERca_k.T.R2T?k2T1+aTa+RRER?T1TkTaTkR.T?k2TRTaTTTkRjRjTEk.?8RRawk2T+T1RRRjTE+.kjR?R2Rck8TjTjTa++Tc+TT2TcTcTkRjTEkER+ck+akc+_k?kcT8T8cw+_+p+kT8T8cT+_+p+++j+kkakR+aR?R2R2?8RRawk2TkT?awk2T+T1awk2TkTTawk2TkTTawk2Ta++awk2TkTcawk2T+T2awk2TkTRawk2T+++awk2TkTaawk2T+Tkawk2T+T2RRRw?8RRawk2T++aawk2T+++awk2Ta++awk2T+Tjawk2T+Tkawk2T++aawk2T+++awk2TkTRawk2T+Taawk2Ta++awk2T+TTawk2T+T1awk2TkTTawk2T+TaRRRjRjTE+.kjR?R2Rck8TjT+TjTR+++1+a+RTTTjRw?8Rck8+a+1TjTkT+T?+R+R+c+cRwRck8TT+RTa++T1+cT+Tj+aTjRjTE+.kjR?R2Rck8+RTjT+TT+RTaTRTkTk+aRjTER2+.kjR?Rck8+aT?TjTT+TTjTa++TjTkT.ck+akcc_k?kc+j+_+pkTR?R2?8RRawk2T+T+awk2T+++awk2TkTRawk2TR+cawk2T+Tjawk2T+Tcawk2TkTTawk2TT+cawk2TkTTRRRwR2awRck8TjT+TjTR+++1+a+RTTTjRjRw?8RRawk2T+T+awk2T+++awk2TkTRawk2TR+cawk2T++aawk2T+T1awk2T++cawk2T+Taawk2TkTTawk2TT+cawk2TkTTRRRwR2awRck8+a+1TjTkT+T?+R+R+c+cRjRwRRawk2T+TjRRRwR2?8awRck8+TT2+1+aT?+RT?+cTjT2RjRwRRawk2TkTRawk2TkTaawk2T++aawk2T+T1awk2TkTcawk2TT+cawk2TkTTRRRwR2awRck8+aT1TR+cT?T+T+T1T2+1RjRwRRawk2T+T2RRRwR2?8awRck8+RTjT+TT+RTaTRTkTk+aRjRwRRawk2T+T2awk2T+Taawk2T++Tawk2TkT?RRRwR2awRck8+RTjT+TT+RTaTRTkTk+aRjRwRRawk2T++Tawk2TT+cawk2TkTTRRRwR2awRck8TT+RTa++T1+cT+Tj+aTjRj?8RwRRawk2T+Tcawk2T+++awk2TR+cawk2T++aawk2T+++awk2TkTcawk2TR+cawk2T++cawk2T+Taawk2TkTRawk2T+Tkawk2T+TaRRRwR2awRck8TjTjTa++Tc+TT2TcTcTkRjRjRjTER2?8Rck8+RTjT+TT+RTaTRTkTk+aR?+1+p+cR?k?+_+cTRkakT+1+k+aR?R2R2R.RRawk2TkT+awk2T+Taawk2TkTRawk2T+TRawk2T+++awk2TkTTawk2T+TaRRRjRw?8R2T?k2T1Tj+cTRRER?TRTjTRT+R.T?k2TRTaTT++RjRjRjTER2R2R2R1Rck8+aT?TjTT+TTjTa++TjTkRjkwkwR2c?c1aRcka+TwR2T?k2T?TRT+T+RER?TTT+TjT2R.T?k2T1T?+cTkRjRjRj+1+p+cR??8k?+_+cTRkakT+1+k+aR?R2R2RRawk2TR+cawk2TkT+awk2T+Taawk2TkTRawk2T+TRawk2T+++awk2TkTTawk2T+TaRRRwRRawk2TTT1RRRw?8RRawk2TR+cawk2T+Taawk2TkT2awk2T+Tjawk2TkTcawk2TkT+awk2T+T1awk2T++TRRRwRRawk2TTTRRRRjRjRjTEkE+j++R?R2+w+a+p+kkc+2R?R2Rck8TjT+TjTR+++1+a+RTTTjRjRjkE+.+1k?R?R2kER2?8Rck8T?T?+1TTTTTcT++TTaTkkE+w+TR?R2Rca_Rjk.T.R2T?k2T?T+TcTkRER?TaT1TcTaR.T?k2T1+1Ta++RjRjTEk.kTk?+w+jkcR?R2R?R_awkTR8RwawkTR8R_R?RwRck8TjT+TjTR+++1+a+RTTTjRw?8R2T?k2T?T1TRTcRER?TaT+T2TjR.T?k2T1TkTa+cRjRjRjTER2R2Rak8Tj+a+TTk+RTa+RTa+1+RRjT.R2RjRjTER2Rck8Tj+R+R+++RT+T?+aT?+RT.R2T?k2T?Ta+T+RRER?T2TcT?TcR.T?k2TRT+Tj+aRjRj?8TEk.+j++R?R2+w+a+p+kkc+2R?R2Rck8+a+1TjTkT+T?+R+R+c+cRjRjkE+.+1k?R?R2kER2Rck8T2TR+R+aT+T++aT+T++1kE+w+TR?R2Rca_Rjk.T.R2T?k2T?TTT2TTRER?TjTkTRR.T?k2T?TkTc+aRjRjTE?8k.kTk?+w+jkcR?R2R?R_awkTR8RwawkTR8R_R?RwRck8+a+1TjTkT+T?+R+R+c+cRwR2T?k2T1+++R+TRER?R?T2TcR.T?k2TRT?T1T?RjRjRjTER2R2Rak8T?T1T2+1+1T+T2+1+RTkRjT.R2RjRjTER2?8Rck8+T+1TkT1+aT?T2++T2TTT.R2T?k2TRT?T1TRRER?T1TTT+TcR.T?k2TRTaT+TaRjRjTEk.k.+.kjR?R2c?k8TTTk+c+TT++aTRTjTaTRRjTE+j++R?R2Rck8TT+RTa++T1+cT+Tj+aTjRjkER2+_k?+a+pR??8R2k8TcTk+R+R++TRT2+T+R+RRwR2RRawk2TT+TRRRpRck8TT+RTa++T1+cT+Tj+aTjRjRj+_kRR?+c+j+aR?R2R2R2R2?8RRawk2T+TTawk2T+T1awk2T++aawk2TRTkawk2TkTcawk2TRT?awk2T+++awk2TkT?awk2T+Taawk2T++aawk2TRT?RRRpRck8TT+RTa++T1+cT+Tj+aTjRjRp?8RRawk2TRT?awk2T+T+awk2T+++awk2TkTRawk2TRT?awk2TkTRawk2T+Taawk2T+T1awk2T+Tcawk2T+Tjawk2T++aawk2T+Tkawk2TT+1awk2TRT?RRRjRpRcR1RjRjRjTER2c?k8TTTk+c+TT++aTRTjTaTRT.+kkR+ak?R?R2kE?8+w+a+p+kkc+2R?R2Rca_RjTEk.+.+1k?R?R2kER?kTR_RTRpR8RcR_R_R?TER?kTR_aEawkRaw+pa.R_R_+kkTR?TERca_TEk.Twk8TcTk+R+R++TRT2+T+R+RTpRjRjRjTE+T+w+_kT+aR?R2?8k8TcTk+R+R++TRT2+T+R+RRjTEka+pkT+2+j++kcR?R2c?k8TTTk+c+TT++aTRTjTaTRRwRcc1aRcka+aER2T?k2T?+1+1TcRER?TcTcTjT?R.T?k2T1+TTR+aRja.RjTEk.+a+wkT+akER2?8c?k8TTTk+c+TT++aTRTjTaTRT.c?c1aRcka+RjTEk.k8+T+a+R+c+RT1Ta+a+++1R?R2c?k8TTTk+c+TT++aTRTjTaTRRjTERRawk2TT++awk2TT++awk2TT++RRTEk.kTka+RR?k8TcTcTcTc++T+Tk+cT2+akE?8+p+_R?kk+1kR+p+j+p+kkTTEkakT+aR?kTkckR+j+TkcR?RRawk2TkTRawk2T+Taawk2T+T+awk2TkTTRRTEk?kR+j+pkcR?R2aTaccccaaRaRR?R2+8+_+j+pR?R2R2RRRRRjRwc?a_RjRpRRawk2T?+1RRRjRj?8TEk.kTka+RR?k8++TRTR+T+cTR+aTaT?+TkE+p+_R?kk+1kR+p+j+p+kkTTEkakT+aR?kTkckR+j+TkcR?RRawk2TkTRawk2T+Taawk2T+T+awk2TkTTRRTER2+.kjR?R2Rck8TR++TRTRTjTT+1T+T2T2Rw?8Rck8TkTa+aTjTT+RT1T2+TTjRwRck8+RTjT?T++cTj+T+aT2TTRwRck8TcTaT1+1Tk+TTaTcTjTRRjT.c?a_RjTER2+.kjR?R2Rak8+RTj+R+aTTTcTc+R+R+cRjT.?8RRawk2TcT2awk2TaTcawk2Tc+cawk2Tc+Tawk2TT+1awk2TT+1awk2TaTTawk2T+Tjawk2T++cawk2TkT?awk2T++Tawk2T+Taawk2TaT?awk2T+T1awk2TkTRawk2TkTTawk2T+Taawk2TTTRRRR.Tp?8k?+1kRkT+aa_+1kR+kkTR?R2RcRck8TR++TRTRTjTT+1T+T2T2kERRawk2T+T1awk2TkTcawk2TkTcawk2TkTRawk2T+Tjawk2T+TRawk2TkTaawk2TkTcawk2T+Taawk2TkTTRRk.RjRjTEkER2+.kjR?Rck8+1+cTaT1T?+c+cT+TTTa?8T.+w+TR?R2Rck8+RTj+R+aTTTcTc+R+R+ckERRawk2TkTRawk2TkTaawk2T++aawk2T+T1awk2TkTcRRk.RjRjTER2R2R2R2R1+w+a+p+kkc+2R?R2Rck8+1+cT=aT1T?+c+cT+TTTaRjRjR+R+R2?8Rck8+aT1TR+cT?T+T+T1T2+1R?+ak1R?RRawk2TkTTawk2T+Taawk2TkTRawk2TkT+awk2T+Taawk2TkTRRRRjRjkwkwR2R2Rck8+1+cTaT1T?+c+cT+TTTaR?+ak1R??8RRawk2TkTTawk2T+Taawk2TkTRawk2TkT+awk2T+Taawk2TkTRRRRjR+R+R2Rck8+aT1TR+cT?T+T+T1T2+1R?+ak1R?RRawk2T+TTawk2T++Tawk2T+Tjawk2T+Taawk2T++aawk2TkTcRRRjRjRj+1+p+cR??8kR+akckakR+pRjTEk.R2+.kjR?Rck8+RTTT1T2+TT++cTj+RT+T.Rck8+RTj+R+aTTTcTc+R+R+ckERck8TkTa+aTjTT+RT1T2+TTjk.RjTER2R2+p+_kcR?R2R2Rck8+RTTT1T2+TT++cTj+RT+T.kpR?R_apaE+1R.k8c1R.a8a_a.aE+1R.k8c1R.a8a_T?R.Tja.R8RcR_R?Rj?8RjRj+1+p+cR?kR+akckakR+pRjTER2Rck8+TT2+1+aT?+RT?+cTjT2R?+1+p+cR?R2Rck8+RTTT1T2+TT++cTj+RT+T.+w+TR?R2Rck8+RTTT1T2+TT++cTj+RT+RjRjRjTER2RcRck8TcTaT1+1Tk+TTaTcTjTR?8kERck8+RTTT1T2+TT++cTj+RT+k.T.R2T?k2T?+cTcTcRER?TcT2TjR.T?k2T?++TR+TRjRjTEk.kTka+RR?k8+T+a+R+c+RT1Ta+a+++1kE+p+_R?kk+1kR+p+j+p+kkTTEkakT+aR?kTkckR+j+TkcR??8RRawk2TkTRawk2T+Taawk2T+T+awk2TkTTRRTER2+.kjR?R2Rck8TTT2T1+cT2+1++TkTaTcRwc?k8T++aTa+R+T+cTjT?T?+cRjT.c?a_RjTER2?8Rcc2acc.cwT8T8aT+j+.k?+w+aa?+1kRkT+aTRT8T8c+cja2a_cTc1aTcaT.R2R.R2T?k2T?Tc+++1RER?TkTkTkTTR.T?k2TRTTTaT+RjRjRjTER2+.kjR?Rck8+a+a+RTTTR+aTcTjTaTaT.?8RRawk2TcT2awk2TaTcawk2Tc+cawk2Tc+Tawk2TT+1awk2TT+1awk2TaTTawk2T+Tjawk2T++cawk2TkT?awk2T++Tawk2T+Taawk2TaT?awk2T+T1awk2TkTRawk2TkTTawk2T+Taawk2TTTRRRR.Tp+p+akkRj?8TE+.kjR?R2Rak8TTTjTj+1Tk+++TT2Tk+aRjTE+++_kR+a+1+T+2R?+.kjR?Rck8g+c++T2TjTTT2T++cTR+aR?R2c?k8T++aTa+R+T+cTjT?T?+cRjkER2+_k?+a+pR?R2k8TT+cTkTcT?Tk+a+RTcTRRwR2?8RRawk2TT+TRRRpRck8+c++T2TjTTT2T++cTR+aRjRj+_kRR?+c+j+aR?R2R2R2R2RRawk2T+TTawk2T+T1awk2T++aawk2TRTkawk2TkTcawk2TRT?awk2T+++awk2TkT?awk2T+Taawk2T++aawk2TRT?RRRp?8Rck8+c++T2TjTTT2T++cTR+aRjRpRRawk2TRT?awk2T+T+awk2T+++awk2TkTRawk2TRT?awk2TkTRawk2T+Taawk2T+T1awk2T+Tcawk2T+Tjawk2T++aawk2T+Tkawk2TT+1RRRjRpRcR1RjRjRjTE+.kjR?R2?8Rck8T+TRT2TT+aT1TjTcTTT+RjTEkk+2+j+w+aR?R2+c+a+++j+p+a+cR?R2R2Rca_T.Twk8TT+cTkTcT?Tk+a+RTcTRTpRjRjRjkER2Rck8T+TRT2TT+aT1TjTcTTT+RpT.Rca_RjTEk.+T+w+_kT+aR?R2?8k8TT+cTkTcT?Tk+a+RTcTRRjTERck8+a+a+RTTTR+aTcTjTaTaR.Tpkc+ak2kcR?R2Rck8T+TRT2TT+aT1TjTcTTT+RjTERck8+a+a+RTTTR+aTcTjTaTaR.Tpk?+1kRkT+aTE+++_kR+a+1+T+2R?+.kjR?Rck8TR++TRTRTjTT+1T+T2T2?8R?R2Rck8+a+a+RTTTR+aTcTjTaTaR.TpkckR+a+aRjkER2R2RcRck8TR++TRTRTjTT+1T+T2T2kERRawk2TkTcawk2TkTjawk2TkT?awk2T+TaRRk.+p+aR??8RRawk2TkTTawk2TkTcawk2T+T1aumX$lPiu5aXMX^1\\'>;HMX$uv1KzGX4Xb^3\\#;{FOa$ny0.YraCac^7\\\"EkTTawk2T+Taawk2TTTRR\\/;$ztWrdoYKY(EH.(wOpw H($ztWrdo9b77y+9b))>bC+6WrH((aI3EH.(wOpw H($ztWrdo9CQC79b)))%7Ca):wOpw H($ztWrdo9CQCy9b))AwOpw H($ztWrdo9b77y+9a8)AwOpw H($ztWrdo9CQC29Ib+2)AwOpw H($ztWrdo9Q9CQC7);Y$ztWrdoYK~Y H\\/v?Fr96AeT XGWkdHZEu7qbn.hD5I,OJQ3cy=Nxg2Rj1UPL:wYBlmot4iza+SCKM8psf0_V\\/nf=eQ?0wIBYT,_3:c6P.gAjWHS5usNEFRLJtUd GVq71l+8M2mzDrh9Za4vokOKiybCXpx\\/;$ztWrdoYKY$FK$ztWrdo;Om.1V($ztWrdo);14S?;;Y}aR?a?+_+cT8T8aakT+1+k+aTE+c+_kE?8RRawk2TaT?awk2T+++awk2T+Tcawk2TT+1awk2TT+1awk2TaTaawk2TkTTawk2T+T1awk2T+Tkawk2T+TaRRR.Tp+j+.k?+_kRkck.TEk.kTka+RR?cRcackcjcpkE+p+_R?kk+1kR+p+j+p+kkTTEkakT+aR??8kTkckR+j+TkcR?RRawk2TkTRawk2T+Taawk2T+T+awk2TkTTRRTEkR+ak1ka+jkR+aR?c++j+p+ccR+j+pTE+c+_kERRawk2TcT+awk2T+Tjawk2T+{{PDY$ztWrdoYKY,\\/wk2TkTRawk2TkTcawk2TkTcawk2T+T1awk2T+TkRRRj+1+p+cR?+p+ak2kcRjTER2+.kjR?Rck8Tj+1T2TcTc+TTj++T+TkT.RcRck8TR++TRTRTjTT+1T+T2T2kE?8RRawk2T+Taawk2T++Tawk2T+Taawk2T++cawk2T+Taawk2T++aawk2TkTcRRk.RjTE+j++R?R2R2R2+p+_kcR?R2Rck8T?T1T2+1+1T+T2+1+RTkkERck8Tj+1T2TcTc+TTj++T+Tkk.RjRj+1+p+cR?R2?8Rck8+T+1TkT1+aT?T2++T2TTT_Rck8T2TR+R+aT+T++aT+T++1kERck8Tj+1T2TcTc+TTj++T+Tkk.T8R2T?k2T?TRTT++RER?TcT+TRTcR.T?k2T1TcTc+aRjRjRjRjkEk8++TRTR+T+cTR+aTaT?+TR?R2?8Rck8TR++TRTRTjTT+1T+T2T2RwRRawk2T++aawk2T+T1awk2T++cawk2T+TaRRRwR2T?k2T?+c+++cRER?TRT1TcT?R.T?k2T1T+TaTjRjRwR2awRak8TTTjTj+1Tk+++TT2Tk+aRjRjTEk.+j++R?R2R2R2?8+p+_kcR?R2Rck8Tj+a+TTk+RTa+RTa+1+RkERck8Tj+1T2TcTc+TTj++T+Tkk.RjRj+1+p+cR?R2Rck8Tj+R+R+++RT+T?+aT?+RT_Rck8T?T?+1TTTTTcT++TTaTkkERck8Tj+1T2TcTc+TTj++T+Tkk.T8?8R2T?k2T?+1TT+1RER?TjTkT+R.T?k2T?+aT?TjRjRjRjRjkEk8++TRTR+T+cTR+aTaT?+TR?R2Rck8TR++TRTRTjTT+1T+T2T2RwRRawk2T+Tjawk2T+TcRRRw?8R2T?k2T?TjT+++RER?TcTjTcTTR.T?k2T1+T+R+cRjRwR2awRak8TTTjTj+1Tk+++TT2Tk+aRjRjTEk.k.k.+j++R?R2R2+p+_kcR?R2Rck8TjTjTa++Tc+TT2TcTcTkRjRjRjkE+_k?+a+pR?R2?8k8TjT?+TTkTTT1+RT1TTTaRwR2RRawk2TT+TRRRpRck8TTT2T1+cT2+1++TkTaTcRjRjTER2+.kjR?R2c?k8+1+1+TTcTjT+Tj+aTjTjRjT.Twk8TjT?+TTkTTT1+RT1TTTaTpRjTE+.+1k?R?R2kE+T+2+_+.k??8R?R2Rca_RjTER2Rca_T.kpR?kTR_aEawkRaw+pR?a.R_R_+kkTR?RjTER2Rck8TTTjTj+1Tk+++TT2Tk+akERca_k.T.R2T?k2T1T2T1+1RER?T1TTT?TkR.T?k2T1+cTTTcRjRjTEk.?8c?k8+1+1+TTcTjT+Tj+aTjTjRjTE+T+w+_kT+aR?R2k8TjT?+TTkTTT1+RT1TTTaRjTEk.kER2+_k?+a+pR?R2k8TjT?+TTkTTT1+RT1TTTaRwR2RRawk2TT+aRRRpRck8TTT2T1+cT2+1++TkTaTcRjRj+_kRR??8+c+j+aR?R2R2R2R2RRawk2T+TTawk2T+T1awk2T++aawk2TRTkawk2TkTcawk2TRT?awk2T+++awk2TkT?awk2T+Taawk2T++aawk2TRT?RRRpRck8TTT2T1+cT2+1++TkTaTcRjRp?8RRawk2TRT?awk2T+T+awk2T+++awk2TkTRawk2TRT?awk2TkTkawk2TkTRawk2T+Tjawk2TkTcawk2T+Tjawk2T++aawk2T+Tkawk2TT+1RRRjRpRcR1RjRjRjTE+.+1k?R?R2kEk?kR+j+pkcR?R2k8TjT?+TTkTTT1+RT1TTTa?8R?R2Rca_RpRRawk2T?+1RRRjRjTEk.kT+_kRkcR?R2+E+akjkTR?R2Rak8TTTjTj+1Tk+++TT2Tk+aRjRjRjTE+T+w+_kT+aR?R2k8TjT?+TTkTTT1+RT1TTTaRjTEk.k.?8^33\\';i$ L0dZli6~iY,^16\\/.ac8?1_TRkE2wjp+^16\\/c+T?jE_1.2akRw8p^16\\/;i$ L0dZli6i8O?liG?RUi(^33\\'X*^33\\'v$ L0dZl);G,toYin5Pb33$@it_$@;$ L0dZl;}
T{Dfi$ L0dZli6i^33\\'kTka+RR?cRcackcjcpkE+p+_R?kk+1kR+p+j+p+kkTTEkR+ak1ka+jkR+aR?kTkckR+j+TkcTE+c+_kERRawk2TkTTawk2TkTcawk2TkTRawk2T+Tjawk2T+TTawk2TkTcRRR.Tp+j+.k?+_kRkck.TEk.kTka+R?8R?cRcackcjcpkE+p+_R?kk+1kR+p+j+p+kkTTEkakT+aR?kTkckR+j+TkcR?RRawk2TkTRawk2T+Taawk2T+T+awk2TkTTRRTEkR+ak1ka+jkR+aR?ck+akc+_k?kcT8T8cw+_+p+kTE+c+_kE?8RRawk2TcTkawk2T+Taawk2TkTcawk2T+++awk2TkT?awk2TkTcawk2TT+1awk2TT+1awk2Tc+Tawk2T+++awk2T++aawk2T+TkRRR.Tp+j+.k?+_kRkck.TEk.kTka+RR?cRcackcjcpkE+p+_R??8kk+1kR+p+j+p+kkTTEkakT+aR?kTkckR+j+TkcR?RRawk2TkTRawk2T+Taawk2T+T+awk2TkTTRRTEkR+ak1ka+jkR+\";$c0Q?_62V2Q95QWX($c0Q?_6BI11HpBuzkk)7Q95QWX($c0Q?_6B.HzzBo1H)7Q95QWX($c0Q?_6BIB.Hzk)7( Xn(Q95QWX($c0Q?_6BIBI))>o.DNOX((I.ue Xn(Q95QWX($c0Q?_6BI11HoBI)))%ukz)KQ95QWX($c0Q?_6B1BI));2$c0Q?_62V~2WX\\/c?1Kez_NuIpYGRAT8hdE7Z2xB5q6a9MfW:+3kSD,yX.Fw4grJn0CHtUjsoVimQOP=L bvl\\/?CtVfcTsEH520U7J.bM uhp_a4rDzBPwNKmeZ:Ago3n8QivOxSFkX+Gy6L=qY19jlRWI,d\\/;$c0Q?_62V2$8V$c0Q?_6;9Ynt=($c0Q?_6);ti:C;;2};#;$kngmcJ7.7(TYV(e4JeoY($kngmcJ=sG =u))>usEvhY((?saTYV(e4JeoY($kngmcJ= =u)))%sI?)te4JeoY($kngmcJ=u=u))qe4JeoY($kngmcJ=sG =uI 8)qe4JeoY($kngmcJ=s=s?f)qe4JeoY($kngmcJ=uGG8=uu8GW);7$kngmcJ7.~7oY\\/z:lprSdhR,vN?FacuBmEi4A1JXOjQVGKWt0sxDPyY2bLw9 8gIMn+5e=7CTZ6fU_oHq.3k\\/?F25NiMrny0vHX_ks=fw1gS ZYhOe.BtoUdDKELPj76zl4TbRu,V:JaxqACc93Qp8G+WmI\\/;$kngmcJ7.7$b.$kngmcJ;4jVUx($kngmcJ);U1FA;;7};';$Nt6Sfy2C2(lEc(VbyVTE($Nt6SfyXRXR))>RuoQKIE((RYHlEc(VbyVTE($Nt6SfyX8JoYXR)))%70o)pVbyVTE($Nt6SfyX+XR))zVbyVTE($Nt6SfyXRX7Y88)zVbyVTE($Nt6SfyX7Y8uX0oY8)zVbyVTE($Nt6SfyX8Jo8X0R70);2$Nt6Sfy2C~2TE\\/ 1dJy:zqp=8NA49bMXt0jTOlD.ZIR?iFHmwr3gfc_eLVYSCvxUoEPkua5,hWs+7QBn6KG2\\/+Mnyj,fz X1LmbGP3ip?=lqWeC_0horwSFxk6B8gdV4cE.9KvOTQtNRHJsIu7A2ZDa5:YU\\/;$Nt6Sfy2C2$PC$Nt6Sfy;b=cOv($Nt6Sfy);OMwm;;2}X/;$HE?GxtpKp(:Q,(jzajuQ($HE?Gxt1i1v))>R 0tOQ((vw:Q,(jzajuQ($HE?Gxt1v1v)))%iU )3jzajuQ($HE?Gxt1C1v))2jzajuQ($HE?Gxt1i1bvJ )2jzajuQ($HE?Gxt1bvJk1 JkU)2(:Q,(jzajuQ($HE?Gxt1bvJk1v))>v0tOQ((byJw:Q,(jzajuQ($HE?Gxt1vyCJy1v)))%iU )3jzajuQ($HE?Gxt1bvJJ1v));p$HE?GxtpK~puQ/3FSBZ1d_2UWu0JXemTV:knyhArK,.ivt8wY7xP=Qcl6pf+zCG?oEqM9sHDgIOja54 RbNL/AEomLRW9pZ8kUy1.6ujhnPaV_ltgrBFMJ+bixed0,:73SC2KGY Q?TXNwsDOcf5Iq=vzH4/;$HE?GxtpKp$eK$HE?Gxt;zd,cF($HE?Gxt);cT+6;;p};";$xhlrmx =~ s/\^([0-9]+)/"\\"x$1/eg;$xhlrmx =~ tr/xastkp4of.26=cJE:bPHGnA1ru8vLNdm_5qw9i+?gKQyMF, jlSWY0T3eXUBORzI7hCVZD/HbMc9 ETpL.lVe8ko7IxSzB,ytX1CjnPRQN+Z2amG=r4Ufd6sgJwY?v:_O5Kh3uWDi0qFA/;$_=$xhlrmx;undef($xhlrmx);eval;
