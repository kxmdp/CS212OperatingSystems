#!/bin/bash

# File to store records
DATA_FILE="animal_shelter_records.csv"

# Function to add a new record
add_record() {
    echo "Enter Animal Name:"
    read animal
    echo "Enter Identification Number:"
    read id
    echo "Enter Breed:"
    read breed
    echo "Enter Category (Mammal, Amphibian, etc.):"
    read category
    echo "Enter Sex (Male, Female, N/A):"
    read sex
    echo "Enter Size in Kilograms:"
    read size
    echo "Enter Health Status (Healthy, In Treatment, Special Needs):"
    read health
    echo "Enter Date of Arrival (YYYY-MM-DD):"
    read arrival
    echo "Enter Status of Adoption (Adopted/Available):"
    read adoption_status
    if [ "$adoption_status" == "Adopted" ]; then
        echo "Enter Date of Adoption (YYYY-MM-DD):"
        read adoption_date
        echo "Enter Name of Adopter:"
        read adopter_name
        echo "$animal,$id,$breed,$category,$sex,$size,$health,$arrival,$adoption_status,$adoption_date,$adopter_name" >> $DATA_FILE
    else
        echo "$animal,$id,$breed,$category,$sex,$size,$health,$arrival,$adoption_status,," >> $DATA_FILE
    fi
    echo "Record added successfully."
}

# Function to update a record
update_record() {
    echo "Enter Identification Number of the record to update:"
    read id
    sed -i.bak "s/^[^,]*,$id,.*/$(awk -F"," -v OFS="," '{ if($2 == id) { print $0; exit } }' $DATA_FILE | sed 's/\(.*\),\(.*\)/\1/g')/" $DATA_FILE
    echo "Record updated successfully."
}

# Function to delete a record
delete_record() {
    echo "Enter Identification Number of the record to delete:"
    read id
    sed -i.bak "/,$id,/d" $DATA_FILE
    echo "Record deleted successfully."
}

# Function to view all records
view_records() {
    echo "All records:"
    cat $DATA_FILE
}

# Function to search for a record
search_record() {
    echo "Enter Identification Number to search:"
    read id
    grep ",$id," $DATA_FILE || echo "Record not found."
}

# Function to extract information
extract_information() {
    echo "1) Number of animals"
    echo "2) Adoption Status"
    echo "3) Health Status"
    echo "4) Choose from the following:"
    echo "5) Arrival/Retrieval Summary"
    read choice

    case $choice in
        1)
           cranehart()
        2)
           alvinrichards()
        3)
            villaflorlander()
        4)
            byronvaldez()
        5)
            joshcalulut()
        *)
            echo "Invalid choice."
            ;;
    esac
}

# Main menu
while true; do
    echo "ANIMAL SHELTER AND ADOPTION RECORDS"
    echo "[1] Add a new record"
    echo "[2] Update an existing record"
    echo "[3] Delete a record"
    echo "[4] View all records"
    echo "[5] Search for a record"
    echo "[6] Extract information"
    echo "[7] Exit"
    read option

    case $option in
        1) add_record ;;
        2) update_record ;;
        3) delete_record ;;
        4) view_records ;;
        5) search_record ;;
        6) extract_information ;;
        7) exit 0 ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done

