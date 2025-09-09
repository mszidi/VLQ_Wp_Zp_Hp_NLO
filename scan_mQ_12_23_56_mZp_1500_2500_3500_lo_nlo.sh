#!/bin/bash
export LC_NUMERIC="C"
###############################################################
###############################################################
###########                xsection at LO and NLO                                  #################### 
###########                mtp= 1/2, 2/3, 5/6 mZp                                  ####################
###########                make sure that mzp > mtp                             #################### 
###############################################################
###############################################################
###############################################################
### Genrating the process in madgraph in the Benchmark scenario TpZpZH: ################
### import model vlQ-Bs_nloqcd_4f_fgf_UFO_v1                                                ################
### set complex_mass_scheme true                                                                      ################
### generate p p > t t~ h [QCD]                                                                           ################
### add process p p > t t~ z [QCD]                                                                       ################
### output process_name                                                                                      ################
###############################################################
###############################################################
### put the script "scan_mQ_12_23_56_mZp_1500_2500_3500_LO_NLO.sh" inside process_name ####
### and run: ./scan_mQ_12_23_56_mZp_1500_2500_3500_LO_NLO.sh                          ###########
###############################################################
###############################################################
# Inputs
# Benchmark scenario TpZpH: set xitpht=1, xitpzt=0 and xitpwt=0                                 
# Benchmark scenario TpZpZ: set xitpht=0, xitpzt=1 and xitpwt=0                                  
# Benchmark scenario TpZpZH: set xitpht=0.5, xitpzt=0.5 and xitpwt=0                         
xitpht=$(echo "0.0" | bc -l)  # Branching ratio of T---> H t
xitpzt=$(echo "1.0" | bc -l)  # Branching ratio of T---> Z t
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
gVu=$(echo "1/4.0 - 2.0*$sw2/3.0" | bc -l)
gAu=$(echo "-1/4.0" | bc -l)
#gmzp=(0.005 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.2  0.3 0.4 0.5)
#gmtp=(0.005 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.2  0.3 0.4 0.5)
#coeff=(0.5 0.6666666666667 0.8333333333333)
coeff=(0.5 0.666666666667 0.833333333333)
######################################################
###################### NLO calculation  ######################
######################################################
for ii in $(seq 0 1 2); do
mzp=$(echo "1500.0+$ii*1000.0" | bc -l)
for coeffs in "${coeff[@]}"
do
mtp=$(echo "$coeffs*$mzp" | bc -l)  # T mass in GeV
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
###########  Zp vector-quark decay part: T ---> H t + Z t + W b  ###################
###########                                                                                    ################### 
###############################################################
###############################################################

for j in $(seq 4 1 4); do
# Branching ratio of Zp ---> T t
xizptpt=$(echo "0.096 + 0.00 * $j" | bc -l)
xizpuu=$xizptpt
echo "xizptpt = $xizptpt"
echo "xizpuu = $xizpuu"

   # SSM model parameters: xiwp and thwp 
    xizp=$(echo "1.0" | bc -l)
    #xizp=$(echo "2.0 + 0.00 * $k" | bc -l)
    thzp=$xizp  # thwp is equal to xiwp
    echo "xizp = $xizp"
    echo "thzp = $thzp"
Gamzpuu=$(echo "$gVu^2+$gAu^2" | bc -l)
    echo "gamzpuu = $gamzpuu"
# Function to calculate kzp
kzp=$(echo "$xizp*sqrt($Gamzpuu/$xizpuu)" | bc -l)
echo "kzp = $kzp"
# Kinematic function for Zp ---> T b
Gamzptpt=$(echo "0.25*sqrt($(lambda $(echo "1.0" | bc -l)  $(echo "$mtp^2/$mzp^2" | bc -l) $(echo "$mt^2/$mzp^2" | bc -l))) * \
     (1-1/2*($mtp^2+$mt^2)/$mzp^2-1/2*(($mtp^2-$mt^2)^2/$mzp^4))" | bc -l)
echo "Gamzptpt = $Gamzptpt"
# Coupling Wp-T-b
kptzpl3=$(echo "$kzp*sqrt($xizptpt/$Gamzptpt)" | bc -l)
echo "kptwpl3 = $kptwpl3"
# Partial width of Zp --- > T b
PartWidzptpt=$(echo "3 * ($kptzpl3^2 * $gw^2 * $mzp) / (12 * $pi*(1-$sw2)) * $Gamzptpt" | bc -l)
echo "PartWidzptpt = $PartWidzptpt"
# Total width of Wp
TotWidzp=$(echo "$PartWidzptpt/$xizptpt" | bc -l)
echo "TotWidzp = $TotWidzp"
# Total width over mass of Wp
TotWidzpOvermzp=$(echo "$TotWidzp/$mzp*100" | bc -l)
    echo "TotWidzpOvermzp = $TotWidzpOvermzp"
        # MadGraph run tag
        tag="mQ122356mWp_xizp${xizp}_xizptpt${xizptpt}_TZpZH_LO_mtp${mtp}_mzp${mzp}"
        # Run MadGraph and set the run_card and param_card  parameters
        ./bin/generate_events <<EOF
        order=LO
        fixed_order=ON
	0
        set run_tag $tag
	set req_acc_fo 0.01
        set xizp $xizp
        set thzp $thzp
        set kptzpl3 $kptzpl3
        set kpthl3 $kpthl3
        set kptzl3 $kptzl3
        set mzp $mzp
        set mtp $mtp
	set wzp $TotWidzp
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
	set req_acc_fo 0.01
        set xizp $xizp
        set thzp $thzp
        set kptzpl3 $kptzpl3
        set kpthl3 $kpthl3
        set kptzl3 $kptzl3
        set mzp $mzp
        set mtp $mtp
	set wzp $TotWidzp
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
ggamwp=$(echo "$k*100" | bc -l)
ggamtp=$(echo "$i*100" | bc -l)    
    echo "$mzp $mtp $ktp $xizp $xizptpt $kzp $Gamzptpt $kpthl3 $kptzl3 $kptzpl3 $TotWidzp $TotWidtp $TotWidzpOvermzp $TotWidtpOvermtp $sigma" >> scan_mQ_12_23_56_mZp_1500_2500_3500_LO_NLO_results.txt
        else
            echo "Warning: No summary.txt found in $run_folder"
        fi
         done
      done
   done

