#!/bin/bash
export LC_NUMERIC="C"
################################################################
################################################################
###########                 xsection at LO and NLO                            ####################
###########                 mtp= 1/2, 2/3, 3/4 mWp                            ####################
###########                 make sure that mwp > mtp                      #################### 
###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
### Genrating the process in madgraph in the Benchmark scenario TpZpZH: ################
### import model vlQ-Bs_nloqcd_4f_fgf_UFO_v1                                                ################
### set complex_mass_scheme true                                                                      ################
### generate p p > t b~ h [QCD]                                                                           ################
### add process p p > t~ b h [QCD]                                                                       ################
### add process p p > t b~ z [QCD]                                                                       ################
### add process p p > t~ t z [QCD]                                                                       ################
### output process_name                                                                                      ################
###############################################################
###############################################################
### put the script  "scan_mQ_12_23_34_mWp_2500_3500_4000_LO_NLO.sh" inside process_name ###########
### and run: ./scan_mQ_12_23_34_mWp_2500_3500_4000_LO_NLO.sh                         ###########
###############################################################
###############################################################
# Inputs
# Benchmark scenario TpWpH: set xitpht=1, xitpzt=0 and xitpwt=0
# Benchmark scenario TpWpZ: set xitpht=0, xitpzt=1 and xitpwt=0
# Benchmark scenario TpWpZH: set xitpht=0.5, xitpzt=0.5 and xitpwt=0
xitpht=$(echo "1.0" | bc -l)  # Branching ratio of T---> H t
xitpzt=$(echo "0.0" | bc -l)  # Branching ratio of T---> Z t
xitpwb=$(echo "0.0" | bc -l)  # Branching ratio of T---> W b
# Constants
mb=$(echo "4.18" | bc -l)    # Bottom quark mass in GeV
mw=$(echo "80.379" | bc -l)   # W boson mass in GeV
mz=$(echo "91.1876" | bc -l)  # Z boson mass in GeV
mh=$(echo "125.25" | bc -l)    # Higgs mass in GeV
mt=$(echo "172.76" | bc -l)    # Top mass in GeV
alpha=$(echo "1 / 127.9" | bc -l) # Fine-structure constant
sw2=$(echo "1 - $mw^2 / $mz^2" | bc -l) # sin^2(theta_W) Weinberg angle
pi=$(echo "3.141592653589793238462643383279502884197"| bc -l) # Pi number to 39 decimal 
ee=$(echo "sqrt(4 * $pi * $alpha)" | bc -l) # Electric charge
gw=$(echo "sqrt($ee^2 / $sw2)" | bc -l)    # Weak coupling constant
#vev=$(echo "246.22" | bc -l)  # Higgs vacuum expectation value
vev=$(echo "2*$mw*sqrt($sw2)/$ee"| bc -l)

# wp masses:
mwps=(2500.0 3500.0 4000.0)
# coeff: mtp = coeff mwp
coeff=(0.5 0.666666666667 0.75)

######################################################
###################### LO  and NLO calculation  ################
######################################################
for mwp in "${mwps[@]}"
do
for coeffs in "${coeff[@]}"
do
mtp=$(echo "$coeffs*$mwp" | bc -l)  # T mass in GeV
echo "mtp = $mtp"

# Function to calculate lambda(a,b,c)
lambda() {
    a=$1
    b=$2
    c=$3
    echo "$a^2 + $b^2 + $c^2 - 2*$a*$b - 2*$a*$c - 2*$b*$c" | bc -l
}

###############################################################
###############################################################
###########                                                                                  #################### 
###########  T vector-quark decay part: T ---> H t + Z t + W b  ####################
###########                                                                                  #################### 
###############################################################
###############################################################

# Kinematic function for T---> H t
Gamtpht=$(echo "sqrt($(lambda $(echo "1.0" | bc -l)  $(echo "$mh^2/$mtp^2" | bc -l) $(echo "$mt^2/$mtp^2" | bc -l))) * \
    (1 + ($mt^2/$mtp^2) - ($mh^2/$mtp^2))/2" | bc -l) 
echo "Gamtpht = $Gamtpht"

# Kinematic function for T---> Z t
Gamtpzt=$(echo "sqrt($(lambda $(echo "1.0" | bc -l)  $(echo "$mz^2/$mtp^2" | bc -l) $(echo "$mt^2/$mtp^2" | bc -l))) * \
    ((1-$mt^2/$mtp^2)^2 + $mz^2/$mtp^2 - 2*$mz^4/$mtp^4 + $mt^2*$mz^2/$mtp^4)/2" | bc -l) 
echo "Gamtpzt = $Gamtpzt"
    
# Kinematic function for T---> W b
Gamtpwb=$(echo "sqrt($(lambda $(echo "1.0" | bc -l)  $(echo "$mw^2/$mtp^2" | bc -l) $(echo "$mb^2/$mtp^2" | bc -l))) * \
    ((1-$mb^2/$mtp^2)^2 + $mw^2/$mtp^2 - 2*$mw^4/$mtp^4 + $mb^2*$mw^2/$mtp^4)" | bc -l)
echo "Gamtpwb = $Gamtpwb"

ktp=$(echo "0.1" | bc -l)
    echo "ktp = $ktp"
    
# Couplings of T to Bpp-q
# The coupling T-H-t:
kpthl3=$(echo "$ktp*$mtp/$vev*sqrt($xitpht/$Gamtpht)" | bc -l)
    echo "kpthl3 = $kpthl3"

# The coupling T-Z-t:
kptzl3=$(echo "$ktp*sqrt($xitpzt/$Gamtpzt)" | bc -l)
    echo "kptzl3 = $kptzl3"
    
# The coupling T-W-b:
kptwl3=$(echo "$ktp*sqrt($xitpwb/$Gamtpwb)" | bc -l)
    echo "kptwl3 = $kptwl3"

# Partial Width of T ---> Bpp q
# Partial Width of T ---> H t
PartWidtpht=$(echo "$kpthl3^2*$vev^2/$mtp^2*$gw^2*$mtp^3/(64*$pi*$mw^2)*$Gamtpht" | bc -l)
    echo "PartWidtpht = $PartWidtpht"
    
# Partial Width of T ---> Z t
PartWidtpzt=$(echo "$kptzl3^2*$gw^2*$mtp^3/(64*$pi*$mw^2)*$Gamtpzt" | bc -l)
    echo "PartWidtpzt = $PartWidtpzt"

# Partial Width of T ---> W b
PartWidtpwb=$(echo "$kptwl3^2*$gw^2*$mtp^3/(64*$pi*$mw^2)*$Gamtpwb" | bc -l)
    echo "PartWidtpwb = $PartWidtpwb"

# Total Width of T ---> H t +Z t + W b
TotWidtp=$(echo "$PartWidtpht+$PartWidtpzt+$PartWidtpwb" | bc -l)
    echo "TotWidtp = $TotWidtp"

TotWidtpOvermtp=$(echo "$TotWidtp/$mtp*100" | bc -l)
    echo "TotWidtpOvermtp = $TotWidtpOvermtp"

###############################################################
###############################################################
###########                                                                                    ################### 
###########  Wp vector-quark decay part: T ---> H t + Z t + W b  ###################
###########                                                                                    ################### 
###############################################################
###############################################################

# Branching ratio of Wp ---> T b
xiwptpb=$(echo "0.2" | bc -l)
echo "xiwptpb = $xiwptpb"
# Branching ratio of Wp ---> l lv
xiwplvl=$(echo "(1-$xiwptpb)/12" | bc -l)
echo "xiwplvl = $xiwplvl"
   # SSM model parameters: xiwp and thwp 
    xiwp=$(echo "0.5" | bc -l)
    thwp=$xiwp  # thwp is equal to xiwp
    echo "xiwp = $xiwp"
    echo "thwp = $thwp"
# Function to calculate kwp
kwp=$(echo "$xiwp / sqrt(3*$xiwplvl)" | bc -l)
echo "kwp = $kwp"
# Kinematic function for Wp ---> T b
Gamwptpb=$(echo "sqrt($(lambda $(echo "1.0" | bc -l)  $(echo "$mtp^2/$mwp^2" | bc -l) $(echo "$mb^2/$mwp^2" | bc -l))) * \
     (1-1/2*($mtp^2+$mb^2)/$mwp^2-1/2*(($mtp^2-$mb^2)^2/$mwp^4))" | bc -l)
echo "Gamwptpb = $Gamwptpb"
# Coupling Wp-T-b
kptwpl3=$(echo "$kwp*sqrt($xiwptpb/$Gamwptpb)" | bc -l)
echo "kptwpl3 = $kptwpl3"
# Partial width of Wp --- > T b
PartWidwptpb=$(echo "3 * ($kptwpl3^2 * $gw^2 * $mwp) / (48 * $pi) * $Gamwptpb" | bc -l)
echo "PartWidwptpb = $PartWidwptpb"
# Total width of Wp
TotWidwp=$(echo "$PartWidwptpb/$xiwptpb" | bc -l)
echo "TotWidwp = $TotWidwp"
# Total width over mass of Wp
TotWidwpOvermwp=$(echo "$TotWidwp/$mwp*100" | bc -l)
    echo "TotWidwpOvermwp = $TotWidwpOvermwpp"
        # MadGraph run tag
        tag="mQ12mWp_xiwp${xiwp}_xiwptpb${xiwptpb}_TWpZH_LO_mtp${mtp}_mwp${mwp}"
        # Run MadGraph and set the run_card and param_card  parameters
        ./bin/generate_events <<EOF
        order=LO
        fixed_order=ON
	0
        set run_tag $tag
	set req_acc_fo 0.001
        set xiwp $xiwp
        set thwp $thwp
        set kptwpl3 $kptwpl3
        set kpthl3 $kpthl3
        set kptzl3 $kptzl3
        set mwp $mwp
        set mtp $mtp
	set wwp $TotWidwp
        set wtp $TotWidtp
	set muR_over_ref 1.0
	set muF_over_ref 1.0
        0
EOF

        ./bin/generate_events <<EOF
        order=NLO
        fixed_order=ON
	0
        set run_tag $tag
	set req_acc_fo 0.001
        set xiwp $xiwp
        set thwp $thwp
        set kptwpl3 $kptwpl3
        set kpthl3 $kpthl3
        set kptzl3 $kptzl3
        set mwp $mwp
        set mtp $mtp
	set wwp $TotWidwp
        set wtp $TotWidtp
	set muR_over_ref 1.0
	set muF_over_ref 1.0
        0
EOF
        # Extract the cross section in pb from "Events/run_..."
        run_folder=$(ls -td Events/run_* | head -1)
        # Check if the run folder exists and contains the summary.txt file
        if [ -f "$run_folder/summary.txt" ]; then
	# Extract the cross section value from summary.txt
	sigma=$(grep "Total cross section" "$run_folder/summary.txt" | awk '{print $4}')
	# Save sigma and some parameters to "...._results.txt"
            echo "mtp=$mtp mwp=$mwp ktp=$ktp xiwp=$xiwp xiwptpb=$xiwptpb kwp=$kwp Gamwptpb=$Gamwptpb kpthl3=$kpthl3 kptzl3=$kptzl3 kptwpl3=$kptwpl3 TotWidwp=$TotWidwp TotWidtp=$TotWidtp TotWidwpOvermwp=$TotWidwpOvermwp TotWidtpOvermtp=$TotWidtpOvermtp sigma=$sigma" >> scan_mQ_12_23_34_mWp_mWpvars_LO_results.txt
        else
            echo "Warning: No summary.txt found in $run_folder"
        fi
	done
	done
	