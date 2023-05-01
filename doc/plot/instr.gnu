reset session

set terminal png size 900, 400
set output "instr.png"
set key autotitle columnhead
set key off

set datafile separator ","


set style fill solid 1.0 border -1 
set boxwidth 0.5
set bmargin 8

set title "Occurence rate of each instruction"
set xlabel "Instruction type"
set xtics rotate
set ylabel "Occurence rate" 

set grid y


plot "instr.csv" u 1:xticlabels(2) w boxes
