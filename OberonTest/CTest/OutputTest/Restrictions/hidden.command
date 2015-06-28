#
dir=`pwd`

rm $dir/out/* 2>/dev/null
rm $dir/*.ob2_errors 2>/dev/null
rm $dir/differences 2>/dev/null

for i in *.ob2 
do
   OC -nc $i >$dir/out/$i.out
done
