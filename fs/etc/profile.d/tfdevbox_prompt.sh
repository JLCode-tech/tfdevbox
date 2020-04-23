if [ "$UID" = 0 ]; then
	PS1="[\u@/home/tfdevbox] [\w] # "
else
	PS1="[\u@/home/tfdevbox] [\w] $ "
fi