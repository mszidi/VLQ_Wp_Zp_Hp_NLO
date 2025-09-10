#!/bin/bash
export LC_NUMERIC="C"
###############################################################
###############################################################
###########                                                                                  #################### 
###########      Comparaison with SM counterpart: VLQBp                       ####################
###########                                                                                  #################### 
###############################################################
###############################################################
# set xiwp and thwp 1.0 for s-chanell Wp 
# set xizp and thzp 1.0 for s-chanell Zp 

#############################################################
### To reproduce Table 3, page 9 in arXiv:2506.14663: finite and zero width, SM masses  ######
##############################################################
# inputs
mw=$(echo "80.379" | bc -l)   # W boson mass in GeV
mz=$(echo "91.1876" | bc -l)  # Z boson mass in GeV
mh=$(echo "125.25" | bc -l)    # Higgs mass in GeV
mt=$(echo "172.76" | bc -l)     # top quark mass in GeV
mwp=$(echo "$mw" | bc -l)   # Wp boson mass in GeV
mzp=$(echo "$mz" | bc -l)  # Zp boson mass in GeV
mhp=$(echo "$mh" | bc -l)    # Hp mass in GeV
mtp=$(echo "$mt" | bc -l)   # T mass in GeV
gfsm="1.205450e-05"  # Fermic constant for sw2 = 1 - mWsm^2/mZsm^2

coeffwidth=(1.0 0.0)

for multiplier in "${coeffwidth[@]}"
do
### 1 % width times coefwidth ###
wt=$(echo "scale=4; 1.50834*$multiplier" | bc)
wtp=$(echo "scale=4; $wt" | bc)
wz=$(echo "scale=4; 2.4952*$multiplier" | bc)
wzp=$(echo "scale=4; $wz" | bc)
ww=$(echo "scale=4; 2.085*$multiplier" | bc)
wwp=$(echo "scale=4; $ww" | bc)
wh=$(echo "scale=4; 0.00407*$multiplier" | bc)
whp=$(echo "scale=4; $wh" | bc)

sw2=$(echo "scale=4; 1.0-$mw^2/$mz^2" | bc)

        ./bin/generate_events <<EOF
        order=LO
        fixed_order=ON
	0
        set req_acc_FO 0.005
	set kpthl3 0.713304
	set kpthr3 0.713304
	set kptzl3 7.026670e-01
	set kptzr3 -2.973330e-01
	set mt $mt
	set mtp $mtp
	set mz $mz
	set mzp $mzp
	set mw $mw
	set mwp $mwp
	set mh $mh
	set mhp $mhp
	set gf $gfsm
        set wt $wt
        set wtp $wtp
        set wz $wz
        set wzp $wzp
        set ww $ww
        set wwp $wwp
        set wh $wh 
        set whp $whp 
        0
EOF

        ./bin/generate_events <<EOF
        order=NLO
        fixed_order=ON
	0
        set req_acc_FO 0.005
	set kpthl3 0.713304
	set kpthr3 0.713304
	set kptzl3 7.026670e-01
	set kptzr3 -2.973330e-01
	set mt $mt
	set mtp $mtp
	set mz $mz
	set mzp $mzp
	set mw $mw
	set mwp $mwp
	set mh $mh
	set mhp $mhp
	set gf $gfsm
        set wt $wt
        set wtp $wtp
        set wz $wz
        set wzp $wzp
        set ww $ww
        set wwp $wwp
        set wh $wh 
        set whp $whp  
        0
EOF

echo "mt=$mt mtp=$mtp wt=$wt wtp=$wtp " >> test_light_Ts_mass_width.txt
echo "mw=$mw mwp=$mwp ww=$ww wwp=$wwp " >> test_light_Ws_mass_width.txt
echo "mz=$mz mzp=$mzp wz=$wz wzp=$wzp " >> test_light_Zs_mass_width.txt
echo "mh=$mh mhp=$mhp wh=$wh whp=$whp " >> test_light_Hs_mass_width.txt
echo "gfsm=$gfsm sw2=$sw2" >> test_light_Gfs_sw2_constants.txt
done 


#############################################################
### To reproduce Table 12, page 41 in arXiv:2506.14663: \Gamma/m=1, 3, 6, 10, 30\%    ######
##############################################################
# inputs
### Light masses ###
mw=$(echo "80.379" | bc -l)   # W boson mass in GeV
mz=$(echo "91.1876" | bc -l)  # Z boson mass in GeV
mh=$(echo "125.25" | bc -l)    # Higgs mass in GeV
mt=$(echo "172.76" | bc -l)     # top quark mass in GeV
mwp=$(echo "$mw" | bc -l)   # Wp boson mass in GeV
mzp=$(echo "$mz" | bc -l)  # Zp boson mass in GeV
mhp=$(echo "$mh" | bc -l)    # Hp mass in GeV
mtp=$(echo "$mt" | bc -l)   # T mass in GeV
gfsm="1.205450e-05"  # Fermic constant for sw2 = 1 - mWsm^2/mZsm^2

coeffwidth=(0.01 0.03 0.06 0.1 0.3)

for multiplier in "${coeffwidth[@]}"
do
### 1 % width times coefwidth ###
wt=$(echo "scale=4; $mt*$multiplier" | bc)
wtp=$(echo "scale=4; $wt" | bc)
wz=$(echo "scale=4; $mz*$multiplier" | bc)
wzp=$(echo "scale=4; $wz" | bc)
ww=$(echo "scale=4; $mw*$multiplier" | bc)
wwp=$(echo "scale=4; $ww" | bc)
wh=$(echo "scale=4; $mh*$multiplier" | bc)
whp=$(echo "scale=4; $wh" | bc)

sw2=$(echo "scale=4; 1.0-$mw^2/$mz^2" | bc)

        ./bin/generate_events <<EOF
        order=LO
        fixed_order=ON
	0
        set req_acc_FO 0.005
	set kpthl3 0.713304
	set kpthr3 0.713304
	set kptzl3 7.026670e-01
	set kptzr3 -2.973330e-01
	set mt $mt
	set mtp $mtp
	set mz $mz
	set mzp $mzp
	set mw $mw
	set mwp $mwp
	set mh $mh
	set mhp $mhp
	set gf $gfsm
        set wt $wt
        set wtp $wtp
        set wz $wz
        set wzp $wzp
        set ww $ww
        set wwp $wwp
        set wh $wh 
        set whp $whp 
        0
EOF

        ./bin/generate_events <<EOF
        order=NLO
        fixed_order=ON
	0
        set req_acc_FO 0.005
	set kpthl3 0.713304
	set kpthr3 0.713304
	set kptzl3 7.026670e-01
	set kptzr3 -2.973330e-01
	set mt $mt
	set mtp $mtp
	set mz $mz
	set mzp $mzp
	set mw $mw
	set mwp $mwp
	set mh $mh
	set mhp $mhp
	set gf $gfsm
        set wt $wt
        set wtp $wtp
        set wz $wz
        set wzp $wzp
        set ww $ww
        set wwp $wwp
        set wh $wh 
        set whp $whp  
        0
EOF

echo "mt=$mt mtp=$mtp wt=$wt wtp=$wtp " >> test_light_Ts_mass_width.txt
echo "mw=$mw mwp=$mwp ww=$ww wwp=$wwp " >> test_light_Ws_mass_width.txt
echo "mz=$mz mzp=$mzp wz=$wz wzp=$wzp " >> test_light_Zs_mass_width.txt
echo "mh=$mh mhp=$mhp wh=$wh whp=$whp " >> test_light_Hs_mass_width.txt
echo "gfsm=$gfsm sw2=$sw2" >> test_light_Gfs_sw2_constants.txt
done 

#############################################################
### To reproduce Table 13, page 42 in arXiv:2506.14663: \Gamma/m=1, 3, 6, 10, 30\%    ######
##############################################################
# inputs
### Heavy masses ###
mw=$(echo "1205.690" | bc -l)   # W boson mass in GeV
mz=$(echo "1367.814" | bc -l)  # Z boson mass in GeV
mh=$(echo "125.25" | bc -l)    # Higgs mass in GeV
mt=$(echo "1000.0" | bc -l)     # top quark mass in GeV
mwp=$(echo "$mw" | bc -l)   # Wp boson mass in GeV
mzp=$(echo "$mz" | bc -l)  # Zp boson mass in GeV
mhp=$(echo "$mh" | bc -l)    # Hp mass in GeV
mtp=$(echo "$mt" | bc -l)   # T mass in GeV
gfnp="5.35755e-08"   # Fermic constant for sw2 = 1 - mWp^2/mZp^2

coeffwidth=(0.01 0.03 0.06 0.1 0.3)

for multiplier in "${coeffwidth[@]}"
do
### 1 % width times coefwidth ###
wt=$(echo "scale=4; $mt*$multiplier" | bc)
wtp=$(echo "scale=4; $wt" | bc)
wz=$(echo "scale=4; $mz*$multiplier" | bc)
wzp=$(echo "scale=4; $wz" | bc)
ww=$(echo "scale=4; $mw*$multiplier" | bc)
wwp=$(echo "scale=4; $ww" | bc)
wh=$(echo "scale=4; $mh*$multiplier" | bc)
whp=$(echo "scale=4; $wh" | bc)
sw2=$(echo "scale=4; 1.0-$mw^2/$mz^2" | bc)

        ./bin/generate_events <<EOF
        order=LO
        fixed_order=ON
	0
        set req_acc_FO 0.005
	set kpthl3 0.275258
	set kpthr3 0.275258
	set kptzl3 7.026670e-01
	set kptzr3 -2.973330e-01
	set mt $mt
	set mtp $mtp
	set mz $mz
	set mzp $mzp
	set mw $mw
	set mwp $mwp
	set mh $mh
	set mhp $mhp
	set gf $gfnp
        set wt $wt
        set wtp $wtp
        set wz $wz
        set wzp $wzp
        set ww $ww
        set wwp $wwp
        set wh $wh 
        set whp $whp 
        0
EOF

        ./bin/generate_events <<EOF
        order=NLO
        fixed_order=ON
	0
        set req_acc_FO 0.005
	set kpthl3 0.275258
	set kpthr3 0.275258
	set kptzl3 7.026670e-01
	set kptzr3 -2.973330e-01
	set mt $mt
	set mtp $mtp
	set mz $mz
	set mzp $mzp
	set mw $mw
	set mwp $mwp
	set mh $mh
	set mhp $mhp
	set gf $gfnp
        set wt $wt
        set wtp $wtp
        set wz $wz
        set wzp $wzp
        set ww $ww
        set wwp $wwp
        set wh $wh 
        set whp $whp  
        0
EOF

echo "mt=$mt mtp=$mtp wt=$wt wtp=$wtp " >> test_heavy_Ts_mass_width.txt
echo "mw=$mw mwp=$mwp ww=$ww wwp=$wwp " >> test_heavy_Ws_mass_width.txt
echo "mz=$mz mzp=$mzp wz=$wz wzp=$wzp " >> test_heavy_Zs_mass_width.txt
echo "mh=$mh mhp=$mhp wh=$wh whp=$whp " >> test_heavy_Hs_mass_width.txt
echo "gfnp=$gfnp sw2=$sw2" >> test_heavy_Gfs_sw2_constants.txt
done 
