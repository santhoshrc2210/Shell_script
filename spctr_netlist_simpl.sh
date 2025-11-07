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




















