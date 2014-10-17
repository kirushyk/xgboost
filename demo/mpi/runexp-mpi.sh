#!/bin/bash
if [[ $# -ne 1 ]]
then
    echo "Usage: nprocess"
    exit -1
fi

rm -rf train.col*
k=$1

# split the lib svm file into k subfiles
python splitsvm.py ../data/agaricus.txt.train train $k

# run xgboost mpi
mpirun -n $k ../../xgboost-mpi  mpi.conf 

# the model can be directly loaded by single machine xgboost solver, as usuall
../../xgboost mpi.conf task=dump model_in=0002.model fmap=../data/featmap.txt name_dump=dump.nice.$k.txt
cat dump.nice.$k.txt
