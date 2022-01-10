#!/usr/bin/bash

# given a prefix, a pad amount, and a list of directories,
#   number all files in the given directories and rename them
#   to prefix_paddedNum.txt where paddedNum is a file's
#   number padded with 0's to $pad digits
# if the mode is -r, only rename the files
# if the mode is -c, copy all the files to a given destination
#   with new names
# note: also runs dos2unix on all files to ensure unix newlines

# example:
# prefix_rename h 5 -c exEmailsOneDir hamDir1 hamDir2 hamDir3
# numbers and copies all files in directories hamDir1, hamDir2,
#   and hamDir3 to exEmailsOnedir with new names h_paddedNum.txt
#   where paddedNum is a file's number padded to 5 digits with 0's

prefix=$1
pad=$2
mode=$3

case $mode in
    # rename files and keep in same location
    '-r')
        shift 3
        ;;
    # copy to destination with new name
    '-c')
        destination=$4
        shift 4
        ;;
    *)
        echo 'Invalid mode, quitting'
        exit 1
esac

directories=( "$@" )


rename_files()
{
    directory=$1
    while IFS= read -r -d '' file; do
            
        echo "processing $file"

        # ensure newlines are linefeeds instead of carriage return + line feed
        dos2unix "$file"

        # pad file number with 0's for a total of $pad digits
        new_name="$prefix"_$(printf "%0${pad}d" "$file_num").txt

        # rename files
        if [[ $mode == '-r' ]]
        then
            dir_path=$(dirname "$file")
            mv "$file" "$dir_path"/"$new_name"
        # rename and copy files
        elif [[ $mode == '-c' ]]
        then
            cp "$file" "$destination"/"$new_name"
        fi

        file_num=$((file_num+1))

    done< <(find "$directory" -type f -print0)
}


# start numbering files starting at 1
file_num=1

# for each directory given, call rename_files
for d in "${directories[@]}"
do
    rename_files "$d"
done

echo $((file_num-1)) 'files renamed'

