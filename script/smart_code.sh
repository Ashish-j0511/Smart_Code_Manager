#!/bin/bash

#get arguments from flask here

filename=$1
extension=$2
description=$3

#Ensuring filename is provided

if [[ "$filename" == 'none' ]]
then
	echo "Error : No Filename Provided!"
	exit 1
fi

#Detecting Extention 
nopath=$(basename "$filename")
extension="${extension,,}" # converting to lower case

declare -a extensions=(c java cpp py html js sh php asm swift)
declare -a languages=(C JAVA C++ PYTHON3 HTML JAVASCRIPT SHELL PHP ASSEMBLY SWIFT )
declare -a comments=("//" "//" "//" "#" "<!-- -->" "//" "#" ";" "#" "//")

#finding extension
extension_idx="none"
i=0
for ext in "${extensions[@]}"
do
	if [[ "$extension" == "$ext" ]]
	then
		extension_idx=$i
		break
	fi
	let i=i+1
done

#set language and comment style

if [[ ! "$extension_idx" == 'none' ]]
then
	language=${languages[$extension_idx]}
	comment="${comments[$extension_idx]}"
else
	language="unknown"
	comment="//"
fi

output_dir="generated_files"
backup_dir="old_versions"
mkdir -p "$output_dir" "$backup_dir"

file_path="$output_dir/$filename.$extension"
this_date=$(date +"%d-%m-%y %H:%M:%S")
escaped_date=$(echo "$this_date" | sed 's/\//\\\//g')
# If the file already exists, move it to old_versions before modification
if [[ -f "$file_path" ]]; then
	sed -i "s|$comment 🔄 Last Updated.*|$comment 🔄 Last Updated : $escaped_date|" "$file_path"
    timestamp=$(date +"%d-%m-%y_%H-%M-%S")
    backup_file="$backup_dir/${filename}_$timestamp.$extension"  # Define backup_file
    cp "$file_path" "$backup_dir/${filename}_$timestamp.$extension"
    echo -e "📂 File '$filename.$extension' already exists. A backup has been created!\n "
    echo -e "💾 Backup saved at: 🗄️ $backup_file\n"
fi

# Create a new file if it doesn't exist
if [[ ! -f "$file_path" ]]; then
    echo -e "📂 Your File Is Being Created: $(basename "$file_path")_ _ _ _ _ _\n"
    touch "$file_path"
fi

#Add header

this_date=$(date +"%d-%m-%y %H:%M:%S")

# Write header only if the file is newly created
if [[ ! -s "$file_path" ]]; then
    {
        echo "$comment ================== HEADER =================="
        echo "$comment 📌 File Name    : $filename.$extension"
        echo "$comment 📝 Description  : $description"
        echo "$comment 💻 Language     : $language"
        echo "$comment 🕒 Created At   : $this_date"
        echo "$comment 🔄 Last Updated : $this_date"
        echo "$comment ==========================================="
    } > "$file_path" # Use '>' to overwrite, ensuring the header is written only once
fi

template_file="./precode/$extension"


if [[ -f "$template_file" ]]
then
    if ! grep -Fxq "$(head -n 1 "$template_file")" "$file_path"
    then
        cat "$template_file" >> "$file_path"
        echo -e "📝 Template from '$template_file' added successfully.\n"
    else
        echo -e "⚠️ No changes to the template – it was already present.\n"
    fi
else
    echo -e "⚠️ No predefined template found for $language.\n"
fi

#this_date=$(date +"%d-%m-%y %H:%M:%S")
#escaped_date=$(echo "$this_date" | sed 's/\//\\\//g')
#sed -i "s/^$comment Last Updated   :.*/$comment Last Updated   : $this_date/" "$file_path"
#sed -i "s|Last Updated.*|Last Updated   : $escaped_date|" "$file_path"
#sed -i "s|$comment 🔄 Last Updated.*|$comment 🔄 Last Updated : $escaped_date|" "$file_path"


echo -e "🎉 File $filename.$extension Created Successfully! 🎉"



