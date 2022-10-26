# ustawienie zmiennej pomocniczej ? krok czasu wymusze?
set t 100
# kompilacja plików VHDL do biblioteki domy?lnej, std.2008
vcom -2008 gates.vhd devices.vhd struct_licznik_141256.vhd
# za?adowanie symulacji modelu mod_141256x1 z biblioteki work
vsim -voptargs=+acc -debugDB work.mod_141256x1
# wy?wietlanie wszystkich sygna?ów z poziomu g?ównego hierarchii
add wave *
# zdefiniowanie wymusze? okresowych dla wszystkich wej??
force clk 0 0, 1 [expr 1*$t]ns -r [expr 2*$t]ns
force reset 1 50ns, 0 65ns 
force ce 1
# uruchomienie symulacji na czas wyliczony na podstawie zmiennej t
run [expr 1005000*$t]ns
# skalowanie przebiegów czasowych w oknie wave
wave zoom full
# generacja schematu dla modelu mod_141256x1 z aktualnie za?adowanej symulacji
add schematic -full sim:/mod_141256x1