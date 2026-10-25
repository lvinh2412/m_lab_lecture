database -open -shm -into waves.shm waves -default
probe -create -database waves hw_top -depth all -all
run
exit
