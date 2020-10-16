#! /bin/bash
# You need to ensure that jq is installed before using this script.

dirname=mirror-download
downloadlist=downloadlist.json

if [ ! -d $dirname ];then
    mkdir $dirname
    echo $dirname created successfully!
else
    echo $dirname exist
fi

if [ ! -f $downloadlist ];then
    continue
else
    rm $downloadlist
fi

wget https://mirror-download.xcpcio.com/downloadlist.json

arr=( $(jq -r '.' $downloadlist) )

cd $dirname

fileNameListCnt=0
fileNameList=()

# download
for (( i = 1; i + 1 < ${#arr[@]}; i += 2))
do
    key=${arr[i]:1:${#arr[i]} - 3}
    value=${arr[i + 1]:1:${#arr[i + 1]} - 3}
    fileNameList[$fileNameListCnt]=$key
    ((fileNameListCnt++))
    if [ ! -f $key ];then
        wget -O $key $value
    fi
done

# delete
for file in *
do
    if test -f $file
    then
        if [[ ! " ${fileNameList[@]} " =~ " ${file} " ]]; then
            echo $file deleting...
            rm $file
            echo $file deleted successfully! 
        fi
    fi
done
