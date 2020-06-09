str="trues 0x59087b4316666e53eb4ffcf198b1d4e6d078aeb2d33c2562eb122ba631fe9917" 
reg='0[xX][0-9a-fA-F]+'
ADDRESS=`echo $str | sed 's/.*\(0[xX][0-9a-fA-F]\+\).*/\1/'`
echo $ADDRESS
