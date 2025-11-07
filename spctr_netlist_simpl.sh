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


















