#!/bin/csh

#input: spice netlist of schematic where all transistors have m=1(multipliers) and nf=1(fingers)
#output: spice netlist of schematic with transistors that have same voltage on source and drain ( or source-drain and drain-source) combined to a single transistor with multipliers count updated
#note: i am not an expert in shell script there maybe more effecient ways of solving this problem, i have broken down the problem into parts and have taken help from metaAI for these smaller parts

file_name=$1
echo $1

#--------------------------------------------------------------------

#first occurance between these patterns
awk '/ends/ {exit} /subckt/ {f=1; next} f' $file_name>file_rand

#search and replace \ followed by newline by no charac
sed -e :a -e '/\\$/{$!N;s/\n//;};ta' file_rand >file_rand1

#search and replace multiple space
sed 's/  */ /g' file_rand1_2 > file_rand1_3

#exit 0
#seperate lines with resistor and fet
cat file_rand1_3 | grep -v 3t_ckt > file_rand_m

cat file_rand1_3 | grep 3t_ckt >file_rand_r

#search and replace open and closed brackets
sed 's/(//g' file_rand_m > file_rand_m1
sed 's/)//g' file_rand_m1 > file_rand_m2

#remove transistor name present in first coloumn
#awk '{print $2, $3, $4, $5, $6, $7, $8, $9}' file_rand_m1 > file_rand_m2
awk '{for (i=2;i<=NF;i++) print $i " ";print ""}' file_rand_m2 > file_rand_m3

#part-1: when drain source not interchanged
#--------------------------------------------------------------------
#remove empty lines and nt25ll_ckt fets
sed '/^$/d' file_rand_m3 | grep -v nt25ll_ckt > file_rand_m4

#exit 0
#sort files with source and drain matching
sort file_rand_m4 | uniq -c | awk '$26="mr="$1' | awk '{for (i=2;i<=NF;i++) printf $i " ";print ""}' > file_rand1_2

#sed -i '1d' file_rand1_2

cp file_rand1_2 file_rand2

cp file_rand1_2 file_rand1_21

#--------------------------------------------------------------------

#remove empty lines and keep nt25ll_ckt fets
sed '/^$/d' file_rand_m3 | grep nt25ll_ckt > file_rand_n4

#sort files with source and drain matching
sort file_rand_n4 | uniq -c | awk '$20="mr="$1' | awk '{for (i=2;i<=NF;i++) print $i " "print ""}' > file_randn2

#-------------------------------------------------------------------------
#part-2a : when source drain interchanged for nt25ll
cp file_randn2 file_randn4

#add open brackets

awk '{$19=substr($19,4); print}' file_randn4_1 | awk '$19="m=("$19' | awk '$6="f"$6' > file_randn4_3

#part-2b : when source drain interchanged #use nested while loop
line_number_ref=1
line_number_chk=0
total_line=$(cat file_rand2 | wc - l)
#echo "$total_line"
while read -r line_ref; do
  #echo "$line ref"
  drain_ref=$(echo Sline_ref | awk '{print $1)' )
  gate_ref=$(echo Sline_ref | awk '{print $2}') 
  source_ref=$(echo Sline_ref | awk '{print $3}' ) 
  body_ref=$(echo Sline_ref | awk '{print $4}' ) 
  dev_typ_ref=$(echo $line_ref | awk '{print $5}')
  w_ref=$(echo $line _ref | awk '{print $6)' )
  l_ ref=$(echo $line_ref | awk '{print $7}' ) 
  nf_ref=$(echo $line_ref | awk '{print $8}' )
  as_ref=$(echo $line_ref | awk '{print $9}' )
  ad_ref=$(echo $line_ref | awk '{print $10}' )
  ps_ref=$(echo $line_ref | awk '{print $11}' )
  pd_ref=$(echo $line_ref | awk '{print $12}' )
  nrd_ref=$(echo $line_ref | awk '{print $13}' )
  nrs_ref=$(echo $line_ref | awk '{print $14}' ) 
  sa_ref=$(echo $line_ref | awk '{print $15}' ) 
  sb_ref=$(echo $line_ref | awk '(print $16}' )
  sd_ref=$(echo $line_ref | awk 'fprint $17}' )
  sca_ref=$(echo $line_ref | awk '{print $18)' ) 
  scb_ref=$(echo $line_ref | awk '{print $19}' ) 
  scc_ref=$(echo $line_ref | awk '{print $20}' )
  DCN_ref=$(echo $line_ref | awk '{print $21}' )
  DPS_ref=$(echo $line_ref | awk '{print $22}' )
  DPCS_ref=$(echo $line_ref | awk '{print $23}')
  DSTS_ref=$(echo $line_ref | awk '{print $24}' ) 
  mr_ref=$(echo $line_ref | awk '{print $25}' ) 
  mismod_ref=$(echo $line_ref | awk '{print $26}' ) 
  globalmod_ref=$(echo $line_ref | awk '{print $27}' ) 
  prelayout_ref=$(echo $line_ref | awk '{print $28}' )
  LEMOD_ref=$(echo $line_ref | awk '{print $29}' )

  line number_chk=0
  while read -r line_chk; do
    line_number_chk=$((line_number_chk+1))

    #echo "$line_chk"
  drain_chk=$(echo line_chk | awk '{print $1}' ) 
  gate_chk=$(echo Sline_chk | awk '{print $2}') 
  source_chk=$(echo Sline_chk | awk '{print $3}' ) 
  body_chk=$(echo $line_chk | awk '{print $4}' ) 
  dev_typ_chk=$(echo line_chk | awk '{print $5}' )
  w_chk=$(echo $line_chk | awk '{print $6}' )
  1_chk=$(echo $line_chk | awk '{print $7}' )
  nf_chk=$(echo $line_chk | awk '{print $8}' )
  as_chk=$(echo $line_chk | awk '{print $9}' )
  ad_chk=$(echo $line_chk | awk '(print $10}' )
  ps_chk=$(echo $line_chk | awk '{print $11}' ) 
  pd_chk=$(echo $line_chk | awk '{print $12}' )
  nrd_chk=$(echo $line_chk | awk '{print $13}' )
  nrs_chk=$(echo $line_chk | awk '{print $14}' ) 
  sa_chk=$(echo $line_chk | awk '{print $15}' ) 
  sb_chk=$(echo $line_chk | awk '{print $16}' ) 
  sd_chk=$(echo $line_chk | awk '{print $17}' ) 
  sca_chk=$(echo $line_chk | awk '{print $18}' ) 
  scb_chk=$(echo $line_chk | awk '{print $19}' )
  scc_chk=$(echo $line_chk | awk '{print $20}' )
  DCN_chk=$(echo $line_chk | awk '{print $21}' )
  DPS_chk=$(echo $line_chk | awk '{print $22}' )
  DPCS_chk=$(echo $line_chk | awk '{print $23}' )
  DSTS_chk=$(echo $line_chk | awk '{print $24}' ) 
  mr_chk=$(echo $line_chk | awk '{print $25}' ) 
  mismod_chk=$(echo $line_chk | awk '{print $26}' ) 
  globalmod_chk=$(echo $line_chk | awk '{print $27}' ) 
  prelayout_chk=$(echo $line_chk | awk '{print $28}' )
  LPEMOD_chk=$(echo $line_chk | awk '{print $29}' )

  
  if [ "${body_ref}" == "${body_chk}" ] && [ "${gate_ref}" == "${gate_chk}" ] && [ "${source_ref}" == "${drain_chk}" ] && [ "${drain_ref}" == "${source_chk}" ] &&
       [ "${dev_typ_ref}" == "${dev_typ_chk}" ] && [ "${w_ref}" == "${w_chk}" ] && [ "${l_ref}" == "${l_chk}" ] && [ "${nf_ref}" == "${nf_chk}" ] && 
       [ "${as_ref}" == "${as_chk}" ] && ["${ad_ref}" == "${ad_chk}" ] && [ "${ps_ref}" == "${ps_chk}" ] && [ "${pd_ref}" == "${pd_chk}" ] && [ "${nrd_ref}" == "${nrd_chk}" ] 
       && [ "${nrs_ref}" == "${nrs_chk}" ] && [ "${sca_ref}" == "${sca_chk}" ] && [ "${scb_ref}" == "${scb_chk}" ] && [ "${scc_ref}" == "${scc_chk}" ] 
       && [ "${DCN_ref}" == "${DCN_chk}" ] && [ "${DPS_ref}" == "${DPS_chk}" ] && [ "${DPCS_ref}" == "${DPCS_chk}" ] && [ "${DSTS_ref}" == "${DSTS_chk}" ] 
       && [ "${mismod_ref}" == "${mismod_chk}" ] && [ "${globalmod_ref}" == "${globalmod_chk}" ] && [ "${prelayout_ref}" == "${prelayout_chk}" ]
       && [ "${LPEMOD_ref}" == "${LPEMOD_chk}" ] ; then
       sed -i "${line_number_chk}s/.*/ignore/" file_rand2
       #echo "$line_number_chk"
       echo -e "${line_ref} ${mr_chk} ${line_chk}" >>file_rand3

       fi

  done < file_rand1_21
done < file_rand1_2

cat file_rand3 | wc - l

#removing the mr= part, sa parameter taking different value awk awk
awk '{$25=substr($25, 4); print}' file_rand3 > file_rand3_1
awk '{$30=substr($30,4); print}' file _rand3_1 > file_rand3_2
awk '{$55=substr($55,4); print}' file_rand3_2 > file _rand3_3

#add $15=$15+$6
awk '{$55=$55+$25; print}' file_rand3_3 > file_rand3_4

#add $6=$15
awk '{$25=$55; print}' file_rand3_4 > file_rand3_5

#find lines with repeating source values and repeating drain values and remove
#-------------------------------------------------------------------------------
mkdir temp_rand 
cd temp_rand 
line srted num=0
while read -r line_srted; do
  line_srted_1=$(echo ${line_srted} | awk '{for (i=1;i<=29;i++) printf $i " ";print ""}' )
  line_srted_2=$(echo ${line_srted} | awk '{for (i=31;i<=NF;i++) printf $i " ";print ""}' )
  echo "$line_srted_1" > file rand temp_$line_srted_num 
  echo "$line_srted_1" > file_rand_temp_$line_srted_num
  sort file_rand_ temp_${line_srted_num} > file_rand_temp_${line_srted_num}_1
  rm file_rand_temp_${line_srted_num}
  line_srted_num=$((line_srted_num+1))
done < ../file_rand3_5
cd ../

for file_temp in $(ls temp_rand/)
do
  cat temp_rand/${file_temp} | head -n1 >>file_rand3_5_1
done

sort file_rand3_5_1 | uniq > file_rand3_5_2
cat file_rand3_5_2 | wc - 1
rm -rf temp rand

#mult adding the mr= part, print 29 coloumns
cat file_rand3_5_2 | awk '$25="mr="$25' | awk '{for (i=1; i<=29; i++)printf "%s ", $i; print ""}' > file_rand3_7


grep -v "ignore" file rand2 > file_rand4 
cat file_rand3_7 >>file_rand4

#add closed brackets 
cat file_rand4 | awk '$1="("$1' | awk '$4=$4") "' | awk '$25=$25") "' | awk '$23=$23") "' > file_rand4_1

#add open brackets awk
awk '{$23=substr($23,6); print}' file_rand4_1 | awk '$23="DPCS=("$23' > file_rand4_2
awk '{$25=substr($25,4); print}' file_rand4_2 | awk '$25="m=("$25' | awk '$6="f"$6' > file_rand4_3

#--------------------------------------------------------------------------------------------
#part-3
#add lines with transistors
cat file_rand4_3 > file_rand7
cat file_rand4_3 >>file_rand7
#add transistor name in format to first coloumn

fet num=1
total_fet_num=$(cat file_rand7 | wc -l)
while | "Sfet_num" -le "Stotal_fet_num" ] 
do
  echo "XXX_Sfet_num" >>file_rand5
((fet_num=fet_num+1))
done

paste -d ' ' file_rand5 file_rand7 > file_rand5_1
#add line with resistor 
cat file_rand_r >> file_rand5_1
#add space to the first coloumn 
sed 's/^/    /' file_rand5_1 > file_rand5_5
#add the header and tail part 
#remove include statements in header part 
sed 'subckt/g' $file_name | grep -v include > file_rand6
cat file_rand5_5 > file_rand6

echo "" >> file_rand6
sed -n '/ends/,$p' ${file_name} >> file_rand6 
cp file_rand6 ${file_name}_rdcd

rm file rand*
#debug by counting all multipliers











