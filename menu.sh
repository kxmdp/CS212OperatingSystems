#!/bin/bash

# File path for animal records CSV
CSV_FILE=~/212Proj/animalrecords

# Color
WHITE="\e[97m"
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
CYAN="\e[36m"
RESET="\e[0m"

# Function to clear the screen and show the welcome page
welcome_page() {
    clear
    echo "********************************************"
    echo "*                                          *"
    echo "*    ${WHITE}ANIMAL SHELTER AND ADOPTION SYSTEM${RESET}    *"
    echo "*                                          *"
    echo "********************************************"
    echo ""
    echo "           ${WHITE}Bringing Order to Care${RESET}           "
    echo "      ${WHITE}Helping Animals Find Their Home!${RESET}      "
    echo ""
    echo "********************************************"
    echo "        ${GREEN}Press any key to continue...${RESET}        "
    echo "********************************************"
    read -n 1 -s
}

# Function to show the main menu
main_menu() {
    while true; do
        clear
        echo "============================================"
        echo "|     ANIMAL SHELTER AND ADOPTION MENU     |"
        echo "============================================"
        echo "| 1. Register a New Animal                 |"
        echo "| 2. Update Animal Information             |"
        echo "| 3. Remove Animal from Records            |"
        echo "| 4. View All Animal Records               |"
        echo "| 5. Analyze Animal Statistics             |"
        echo "| 6. Exit                                  |"
        echo "============================================"
        echo -n "Choose an option (1-6): "
        read main_choice
        case $main_choice in
            1) register_animal ;;
            2) update_animal ;;
            3) remove_animal ;;
            4) view_all_animals ;;
            5) analyze_statistics ;;
            6) exit_program ;;
            *) echo "Invalid option. Please try again." ; sleep 1 ;;
        esac
    done
}

# Function to register a new animal (append to CSV file)
register_animal() {
    clear
    echo "============================================"
    echo "|           REGISTER A NEW ANIMAL          |"
    echo "============================================"
    echo ""
    echo "Register a New Animal:"
    
    # Input animal information
    echo -n "Animal: "
    read animal
    echo -n "ID: "
    read id
    
    # Check if the animal already exists based on the ID or name
    if grep -q "$id" "$CSV_FILE" || grep -q "$animal" "$CSV_FILE"; then
        echo "Error: An animal with the same ID or Name already exists in the records."
        pause_and_return
        return
    fi

    # Continue if no match is found
    echo -n "Breed: "
    read breed
    echo -n "Category: "
    read category
    echo -n "Sex (Male/Female/NA): "
    read sex
    echo -n "Size (in kg): "
    read size
    
    # Health Status Input
    echo -n "Health Status (Healthy/In Treatment/With Special Needs): "
    read health_status
    if [ "$health_status" == "With Special Needs" ]; then
        echo "Please specify the type of special need:"
        echo "1) Deaf"
        echo "2) Blind"
        echo "3) Missing a Limb"
        echo -n "Choose an option (1-3): "
        read special_needs_choice
        case $special_needs_choice in
            1) health_status="With Special Needs - Deaf" ;;
            2) health_status="With Special Needs - Blind" ;;
            3) health_status="With Special Needs - Missing a Limb" ;;
            *) echo "Invalid option, defaulting to 'With Special Needs'." ;;
        esac
    fi

    # Continue with the rest of the registration process
    echo -n "Arrival Date (YYYY-MM-DD): "
    read arrival_date
    echo -n "Adoption Status (Adopted/Available): "
    read adoption_status
    if [ "$adoption_status" == "Adopted" ]; then
        echo -n "Adoption Date (YYYY-MM-DD): "
        read adoption_date
        echo -n "Adopter Name: "
        read adopter_name
    else
        adoption_date=""
        adopter_name=""
    fi
    
    # Append the new animal record to the CSV file
    echo "$animal,$id,$breed,$category,$sex,$size,$health_status,$arrival_date,$adoption_status,$adoption_date,$adopter_name" >> $CSV_FILE
    echo "New animal registered successfully!"
    pause_and_return
}

# Function to update animal information
update_animal() {
    clear
    echo "============================================"
    echo "|         UPDATE ANIMAL INFORMATION        |"
    echo "============================================"
    
    # Prompt the user for the animal ID to update
    echo -n "Enter Animal ID to update: "
    read id
    
    # Check if the animal exists in the CSV file
    if ! grep -q "$id" "$CSV_FILE"; then
        echo "Error: No animal with ID $id found in the records."
        pause_and_return
        return
    fi
    
    # If animal exists, retrieve the line and display original details
    animal_record=$(grep "$id" "$CSV_FILE")
    
    IFS=',' read -r animal id breed category sex size health_status arrival_date adoption_status adoption_date adopter_name <<< "$animal_record"
    
    echo ""
    echo "Animal $id Record Found:"
    echo "--------------------------------------------"
    echo "Animal: $animal"
    echo "Animal ID: $id"
    echo "Breed: $breed"
    echo "Category: $category"
    echo "Sex: $sex"
    echo "Size (kg): $size"
    echo "Health Status: $health_status"
    echo "Arrival Date: $arrival_date"
    echo "Adoption Status: $adoption_status"
    echo "Adoption Date: $adoption_date"
    echo "Adopter Name: $adopter_name"
    echo "--------------------------------------------"
    
    # Show options for the user to choose what to edit
    echo "What would you like to update?"
    echo "[1] Size in Kilograms"
    echo "[2] Health Status"
    echo "[3] Status of Adoption"
    echo -n "Choose an option (1-3): "
    read update_choice
    
    case $update_choice in
        1)
            # Update size in kilograms
            echo -n "Enter new size (in kg): "
            read new_size
            size=$new_size
            ;;
        2)
            # Update health status
            echo -n "Enter new health status (Healthy/In Treatment/With Special Needs): "
            read new_health_status
            if [ "$new_health_status" == "With Special Needs" ]; then
                echo "Please specify the type of special need:"
                echo "1) Deaf"
                echo "2) Blind"
                echo "3) Missing a Limb"
                echo -n "Choose an option (1-3): "
                read special_needs_choice
                case $special_needs_choice in
                    1) new_health_status="With Special Needs - Deaf" ;;
                    2) new_health_status="With Special Needs - Blind" ;;
                    3) new_health_status="With Special Needs - Missing a Limb" ;;
                    *) echo "Invalid option, defaulting to 'With Special Needs'." ;;
                esac
            fi
            health_status=$new_health_status
            ;;
        3)
            # Update adoption status
            echo -n "Enter new adoption status (Adopted/Available): "
            read new_adoption_status
            if [ "$new_adoption_status" == "Adopted" ]; then
                echo -n "Enter adoption date (YYYY-MM-DD): "
                read new_adoption_date
                echo -n "Enter adopter's name: "
                read new_adopter_name
                adoption_status=$new_adoption_status
                adoption_date=$new_adoption_date
                adopter_name=$new_adopter_name
            else
                adoption_status=$new_adoption_status
                adoption_date=""
                adopter_name=""
            fi
            ;;
        *)
            echo "Invalid option. Returning to the main menu."
            pause_and_return
            return
            ;;
    esac

    # Remove the old record and append the updated one
    sed -i "/$id/d" "$CSV_FILE"  # Remove the old record from the file
    echo "$animal,$id,$breed,$category,$sex,$size,$health_status,$arrival_date,$adoption_status,$adoption_date,$adopter_name" >> "$CSV_FILE"
    
    echo "Animal information updated successfully!"
    pause_and_return
}

# Function to remove an animal from records
remove_animal() {
    clear
    echo "============================================"
    echo "|        REMOVE ANIMAL FROM RECORDS        |"
    echo "============================================"
    echo ""
    echo -n "Enter the ID of the animal: "
    read id

    # Check if the animal exists in the CSV file
    if ! grep -q "$id" "$CSV_FILE"; then
        echo "Error: No animal with ID $id found in the records."
        pause_and_return
        return
    fi

    # If the animal exists, confirm removal
    echo "Animal with ID $id found."
    echo "Are you sure you want to remove this animal from the records? (y/n): "
    read confirmation

    if [ "$confirmation" == "y" ]; then
        # Remove the record by filtering out the matching ID
        awk -F, -v id="$id" '$2 != id' "$CSV_FILE" > temp.csv && mv temp.csv "$CSV_FILE"
        echo "Animal with ID $id removed successfully!"
    else
        echo "Operation cancelled. Animal record not removed."
    fi

    pause_and_return
}

# Function to view all animal records
view_all_animals() {
    clear
    echo "============================================"
    echo "|            ALL ANIMAL RECORDS            |"
    echo "============================================"
    echo "All Animal Records:"
    column -t -s, $CSV_FILE
    pause_and_return
}

# Function to analyze animal statistics
analyze_statistics() {
    clear
    echo "============================================="
    echo "|         ANIMAL STATISTICS ANALYSIS        |"
    echo "============================================="
    echo "| 1. Total Number of Animals and by Category|"
    echo "| 2. Adoption Status Overview and Summary   |"
    echo "| 3. Health Status Overview and Summary     |"
    echo "| 4. Animal List and Record Highlights      |"
    echo "| 5. Arrival and Retrieval Date Summary     |"
    echo "| 6. Return to Main Menu                    |"
    echo "============================================="
    echo -n "Choose an option (1-6): "
    read stats_choice
    case $stats_choice in
        1) total_animals ;;
        2) adoption_status ;;
        3) health_status ;;
        4) animal_list ;;
        5) date_summary ;;
        6) main_menu ;;
        *) echo "Invalid option. Please try again." ; analyze_statistics ;;
    esac
}

# CRANE
# Function to show total number of animals and by category
total_animals() {
    clear
    echo "============================================"
    echo "|    TOTAL NUMBER OF ANIMALS & CATEGORY    |"
    echo "============================================"
    # code here
    pause_and_return
}

# ALVIN
# Function to show adoption status overview
adoption_status() {
    clear
    echo "============================================"
    echo "|   ADOPTION STATUS OVERVIEW AND SUMMARY   |"
    echo "============================================"
    # code here
    pause_and_return
}

# LANDER
# Function to show health status overview
health_status() {
    clear
    echo "============================================"
    echo "|    HEALTH STATUS OVERVIEW AND SUMMARY    |"
    echo "============================================"
    # code here
    pause_and_return
}

# BYRON
# Function to list animals and record highlights
animal_list() {
    clear
    echo "============================================"
    echo "|     ANIMAL LIST AND RECORD HIGHLIGHTS    |"
    echo "============================================"
    # code here
    pause_and_return
}

# FRANCIS
# Function to show arrival and retrieval date summary
date_summary() {
    clear
    echo "============================================"
    echo "|    ARRIVAL AND RETRIEVAL DATE SUMMARY    |"
    echo "============================================"
    # code here
    pause_and_return
}

# Utility function to pause and return to the main menu
pause_and_return() {
    echo ""
    echo "Press Enter to return to the main menu..."
    read
    main_menu
}

# Utility function to pause and return to the statistics menu
pause_and_return_analyze() {
    echo ""
    echo "Press Enter to return to the statistics menu..."
    read
    analyze_statistics
}

exit_program() {
    clear
    echo "Thank you for using the Animal Shelter System!"
    echo "Goodbye!"
    exit 0
}

# Start the script by displaying the welcome page and main menu
welcome_page
main_menu
