#!/bin/bash

# File path for animal records CSV
CSV_FILE=~/212Proj/animalrecords

# Function to clear the screen and show the welcome page
welcome_page() {
    clear
    echo "********************************************"
    echo "*                                          *"
    echo "*    ANIMAL SHELTER AND ADOPTION SYSTEM    *"
    echo "*                                          *"
    echo "********************************************"
    echo ""
    echo "           Bringing Order to Care           "
    echo "      Helping Animals Find Their Home!      "
    echo ""
    echo "********************************************"
    echo "        Press any key to continue...        "
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
        echo "| 6. Search for a Specific Animal          |"
        echo "| 7. Exit                                  |"
        echo "============================================"
        echo -n "Choose an option (1-7): "
        read main_choice
        case $main_choice in
            1) register_animal ;;
            2) update_animal ;;
            3) remove_animal ;;
            4) view_all_animals ;;
            5) analyze_statistics ;;
            6) search_animal ;;
            7) exit_program ;;
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
    echo "|                                          |"
    
    # Input animal information with design
    echo "| Please enter the following information:  |"
    echo "|------------------------------------------|"
    echo -n "| Animal: "
    read animal
    echo -n "| Identification ID: "
    read id

    # Check if the animal already exists based on the ID or name
    if grep -q "$id" "$CSV_FILE" || grep -q "$animal" "$CSV_FILE"; then
        echo "|                                          "
        echo "============================================"
        echo "|       ERROR: Animal already exists!      |"
        echo "============================================"
        pause_and_return
        return
    fi

    # Continue if no match is found
    echo -n "| Breed: "
    read breed
    echo -n "| Category: "
    read category
    echo -n "| Sex (Male/Female/NA): "
    read sex
    echo -n "| Size (in kg): "
    read size
    
    # Health Status Input
    echo "| (Healthy/In Treatment/With Special Needs)"
    echo -n "| Health Status: "
    read health_status
    if [ "$health_status" == "With Special Needs" ]; then
        echo "|------------------------------------------|"
        echo "| Please specify the type of special need: |"
        echo "| 1) Deaf                                  "
        echo "| 2) Blind                                 "
        echo "| 3) Missing a Limb                        "
        echo -n "| Choose an option (1-3): "
        read special_needs_choice
        case $special_needs_choice in
            1) health_status="With Special Needs - Deaf" ;;
            2) health_status="With Special Needs - Blind" ;;
            3) health_status="With Special Needs - Missing a Limb" ;;
            *) echo "| Invalid option, defaulting to 'With Special Needs'." ;;
        esac
    fi

    echo "|------------------------------------------|"
    # Continue with the rest of the registration process
    echo -n "| Arrival Date (YYYY-MM-DD): "
    read arrival_date
    echo "| (Adopted/Available)"
    echo -n "| Adoption Status: "
    read adoption_status
    if [ "$adoption_status" == "Adopted" ]; then
        echo -n "| Adoption Date (YYYY-MM-DD): "
        read adoption_date
        echo -n "| Adopter Name: "
        read adopter_name
    else
        adoption_date=""
        adopter_name=""
    fi
    
    # Append the new animal record to the CSV file
    echo "$animal,$id,$breed,$category,$sex,$size,$health_status,$arrival_date,$adoption_status,$adoption_date,$adopter_name" >> $CSV_FILE
    echo "|                                           "
    echo "============================================"
    echo "|    NEW ANIMAL REGISTERED SUCCESSFULLY!   |"
    echo "============================================"
    
    pause_and_return
}

# Function to update animal information
update_animal() {
    clear
    echo "============================================"
    echo "|         UPDATE ANIMAL INFORMATION        |"
    echo "============================================"
    
    # Prompt the user for the animal ID to update
    echo "|------------------------------------------|"
    echo -n "| Enter Animal ID: "
    read id
    
    # Check if the animal exists in the CSV file
    if ! grep -q "$id" "$CSV_FILE"; then
        echo "|                                          "
        echo "======================================================"
        echo "| ERROR: No animal with ID $id found in the records. |"
        echo "======================================================"
        pause_and_return
        return
    fi
    
    # If animal exists, retrieve the line and display original details
    animal_record=$(grep "$id" "$CSV_FILE")
    
    IFS=',' read -r animal id breed category sex size health_status arrival_date adoption_status adoption_date adopter_name <<< "$animal_record"
    
    echo "|------------------------------------------|"
    echo "| Animal $id Record Found:                 |"
    echo "|------------------------------------------|"
    echo "| Animal: $animal                         "
    echo "| Animal ID: $id                          "
    echo "| Breed: $breed                           "
    echo "| Category: $category                     "
    echo "| Sex: $sex                               "
    echo "| Size (kg): $size                        "
    echo "| Health Status: $health_status           "
    echo "| Arrival Date: $arrival_date             "
    echo "| Adoption Status: $adoption_status       "
    echo "| Adoption Date: $adoption_date           "
    echo "| Adopter Name: $adopter_name             "
    echo "|------------------------------------------|"
    
    # Show options for the user to choose what to edit
    update
    
    echo "|                                          |"
    echo "============================================"
    pause_and_return
}

# Show options for the user to choose what to edit
update() {
    echo "|------------------------------------------|"
    echo "|       WHAT WOULD YOU LIKE TO UPDATE?     |"
    echo "|------------------------------------------|"
    echo "[1] Size in Kilograms"
    echo "[2] Health Status"
    echo "[3] Status of Adoption"
    echo -n "| Choose an option (1-3): "
    read update_choice

    echo "|"
    
    case $update_choice in
        1)
            # Update size in kilograms
            echo -n "| Enter new size (in kg): "
            read new_size
            size=$new_size
            ;;
        2)
            # Update health status
            echo "| (Healthy/In Treatment/With Special Needs)"
            echo -n "| Enter new health status: "
            read new_health_status
            if [ "$new_health_status" == "With Special Needs" ]; then
                echo "| Please specify the type of special need: |"
                echo "| 1) Deaf                                  |"
                echo "| 2) Blind                                 |"
                echo "| 3) Missing a Limb                        |"
                echo -n "| Choose an option (1-3): "
                read special_needs_choice
                case $special_needs_choice in
                    1) new_health_status="With Special Needs - Deaf" ;;
                    2) new_health_status="With Special Needs - Blind" ;;
                    3) new_health_status="With Special Needs - Missing a Limb" ;;
                    *) echo "| Invalid option, defaulting to 'With Special Needs'." ;;
                esac
            fi
            health_status=$new_health_status
            ;;
        3)
            # Update adoption status
            echo "| (Adopted/Available)"
            echo -n "| Enter new adoption status: "
            read new_adoption_status
            if [ "$new_adoption_status" == "Adopted" ]; then
                echo -n "| Enter adoption date (YYYY-MM-DD): "
                read new_adoption_date
                echo -n "| Enter adopter's name: "
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
            echo "| Invalid option. Returning to the main menu.|"
            pause_and_return
            return
            ;;
    esac

    # Remove the old record and append the updated one
    sed -i "/$id/d" "$CSV_FILE"  # Remove the old record from the file
    echo "$animal,$id,$breed,$category,$sex,$size,$health_status,$arrival_date,$adoption_status,$adoption_date,$adopter_name" >> "$CSV_FILE"
    
    echo "|                                          |"
    echo "============================================"
    echo "| ANIMAL INFORMATION UPDATED SUCCESSFULLY! |"
    echo "============================================"
    
    pause_and_return
}



# Function to remove an animal from records
remove_animal() {
    clear
    echo "============================================"
    echo "|        REMOVE ANIMAL FROM RECORDS        |"
    echo "============================================"
    echo "|                                          "
    echo -n "| Enter the ID: "
    read id

    # Check if the animal exists in the CSV file
    if ! grep -q "$id" "$CSV_FILE"; then
        echo "|                                          "
        echo "======================================================"
        echo "| ERROR: No animal with ID $id found in the records. |"
        echo "======================================================"
        pause_and_return
        return
    fi

    # If the animal exists, confirm removal
    echo "|                                          "
    echo "============================================"
    echo "| Animal with ID $id found.                 "
    echo "|                                          "
    
    # Call the remove function to proceed with removal
    remove
}


 remove() {
    echo -n "| Are you sure you want to remove? (y/n): "
    read confirmation

    if [ "$confirmation" == "y" ]; then
        # Remove the record by filtering out the matching ID
        awk -F, -v id="$id" '$2 != id' "$CSV_FILE" > temp.csv && mv temp.csv "$CSV_FILE"
        echo "|                                          "
        echo "==================================================="
        echo "|    ANIMAL WITH ID $id REMOVED SUCCESSFULLY!  |"
        echo "==================================================="
    else
        echo "|                                          "
        echo "======================================================="
        echo "|    OPERATION CANCELLED. ANIMAL RECORD NOT REMOVED.  |"
        echo "======================================================="
    fi

    pause_and_return
}


# Function to view all animal records
view_all_animals() {
    clear
    echo "============================================"
    echo "|            ALL ANIMAL RECORDS            |"
    echo "============================================"
    echo ""
    
    # Print animal records from the CSV file
    while IFS=',' read -r animal id breed category sex size health_status arrival_date adoption_status adoption_date adopter_name; do
        printf "%-12s %-10s %-12s %-11s %-8s %-10s %-15s %-15s %-15s %-20s %-35s\n" \
            "$animal" "$id" "$breed" "$category" "$sex" "$size" "$arrival_date" "$adoption_status" "$adoption_date" "$adopter_name" "$health_status"
    done < "$CSV_FILE"

    echo ""
    echo "============================================"
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

search_animal() {
    clear
    echo "============================================"
    echo "|          SEARCH FOR AN ANIMAL            |"
    echo "============================================"
    echo ""
    echo -n "Enter the ID: "
    read id

    # Check if the animal exists in the CSV file
    if ! grep -q ",$id," "$CSV_FILE"; then
        echo ""
        echo "============================================"
        echo "|             ANIMAL NOT FOUND             |"
        echo "============================================"
        pause_and_return
        return
    fi

    # If the animal is found, extract the details and display them
    animal_details=$(grep ",$id," "$CSV_FILE")
    IFS=',' read -r animal animal_id breed category sex size health_status arrival_date adoption_status adoption_date adopter_name <<< "$animal_details"

    echo ""
    echo "============================================"
    echo "|             ANIMAL DETAILS               |"
    echo "============================================"
    echo "| Animal:           $animal"
    echo "| Animal ID:        $animal_id"
    echo "| Breed:            $breed"
    echo "| Category:         $category"
    echo "| Sex:              $sex"
    echo "| Size (kg):        $size"
    echo "| Health Status:    $health_status"
    echo "| Arrival Date:     $arrival_date"
    echo "| Adoption Status:  $adoption_status"
    
    if [ "$adoption_status" == "Adopted" ]; then
        echo "| Adoption Date:    $adoption_date"
        echo "| Adopter Name:     $adopter_name"
    fi

    echo "============================================"
    echo ""

    # Prompt user if they want to update or remove the animal
    echo -n "| Do you want to modify? (yes/no): "
    read choice
    if [ "$choice" == "yes" ]; then
        echo ""
        echo "1. Update Animal"
        echo "2. Remove Animal"
        echo -n "Enter your choice (1/2): "
        read action_choice
        
        case "$action_choice" in
            1)
                update
                ;;
            2)
                remove
                ;;
            *)
                echo "Invalid choice. Returning to the main menu."
                ;;
        esac
    fi

    pause_and_return
}

# CRANE
# Function to show total number of animals and by category
total_animals() {
    clear
    echo "============================================"
    echo "|    TOTAL NUMBER OF ANIMALS & CATEGORY    |"
    echo "============================================"
    echo ""

    if [[ ! -f "$CSV_FILE" ]]; then
        echo "|                                          |"
        echo "============================================"
        echo "|        ERROR: CSV file not found!        |"
        echo "============================================"
        pause_and_return
        return
    fi
    
    CATEGORY_COLUMN=${1:-4}
    total=$(wc -l < "$CSV_FILE")
    echo "| Total number of animals: $((total - 1))  "
    echo ""

    echo "| Number of animals by category:            "
    echo "--------------------------------------------"
    
    cut -d',' -f"$CATEGORY_COLUMN" "$CSV_FILE" | tail -n +2 | sort | uniq -c | while read -r count category; do
        echo "|   $category: $count                     "
    done

    echo "--------------------------------------------"
    echo "|                                          |"
    echo "============================================"
    pause_and_return
}


# ALVIN
# Function to show adoption status overview
adoption_status() {
    clear
    echo "============================================"
    echo "|   ADOPTION STATUS OVERVIEW AND SUMMARY   |"
    echo "============================================"

    # Check if the CSV file is empty
    if [ ! -s "$CSV_FILE" ]; then
        echo "|                                          |"
        echo "============================================"
        echo "|    ERROR: No animal records available.   |"
        echo "============================================"
        pause_and_return
        return
    fi

    # Extract the counts for adopted and available animals (9th column)
    adopted_count=$(awk -F, '$9 ~ /Adopted/ {count++} END {print count+0}' "$CSV_FILE")
    available_count=$(awk -F, '$9 ~ /Available/ {count++} END {print count+0}' "$CSV_FILE")

    # Calculate the total adoption rate (%)
    total_count=$((adopted_count + available_count))
    if [ $total_count -eq 0 ]; then
        adoption_rate=0
    else
        adoption_rate=$(echo "scale=2; ($adopted_count / $total_count) * 100" | bc)
    fi

    # Output
    echo "|                                          "
    echo "| Number of adopted animals: $adopted_count "
    echo "| Number of available animals: $available_count "
    echo "| Total rate of adoption: $adoption_rate%   "
    echo "|                                          "
    echo "============================================"

    pause_and_return
}


# LANDER
# Function to show health status overview and detailed table
health_status() {
    clear
    echo "============================================"
    echo "|    HEALTH STATUS OVERVIEW AND SUMMARY    |"
    echo "============================================"

    # Check if the CSV file is empty
    if [ ! -s "$CSV_FILE" ]; then
        echo "|                                          |"
        echo "============================================"
        echo "|    ERROR: No animal records available.   |"
        echo "============================================"
        pause_and_return
        return
    fi

    # Variables to track counts
    healthy_count=0
    treatment_count=0
    special_needs_count=0
    deaf_count=0
    blind_count=0
    missing_limb_count=0

    # Temporary files to hold the respective tables
    healthy_file=$(mktemp)
    treatment_file=$(mktemp)
    special_needs_file=$(mktemp)

    # Loop through the records and count the different health statuses
    while IFS=',' read -r animal id breed category sex size health_status arrival_date adoption_status adoption_date adopter_name; do
        case "$health_status" in
            "Healthy")
                ((healthy_count++))
                echo "$animal,$id,$breed,$category,$sex,$size,$arrival_date,$adoption_status" >> "$healthy_file"
                ;;
            "In Treatment")
                ((treatment_count++))
                echo "$animal,$id,$breed,$category,$sex,$size,$arrival_date,$adoption_status" >> "$treatment_file"
                ;;
            "Special Needs - Deaf"|"Special Needs - Blind"|"Special Needs - Missing a Limb")
                ((special_needs_count++))
                echo "$animal,$id,$breed,$category,$sex,$size,$arrival_date,$adoption_status,$health_status" >> "$special_needs_file"
                case "$health_status" in
                    "Special Needs - Deaf") ((deaf_count++)) ;;
                    "Special Needs - Blind") ((blind_count++)) ;;
                    "Special Needs - Missing a Limb") ((missing_limb_count++)) ;;
                esac
                ;;
        esac
    done < "$CSV_FILE"

    # Display counts
    echo "| Number of Healthy Animals: $healthy_count "
    echo "| Number of Animals in Treatment: $treatment_count "
    echo "| Number of Animals with Special Needs: $special_needs_count "
    echo "|    * Number of Deaf Animals: $deaf_count "
    echo "|    * Number of Blind Animals: $blind_count "
    echo "|    * Number of Animals Missing a Limb: $missing_limb_count "
    echo "|                                          "
    echo "============================================"

    # Show detailed tables based on user choice
    echo "Choose what to display:"
    echo "[1] Show Healthy Animals Table"
    echo "[2] Show Animals in Treatment Table"
    echo "[3] Show Animals with Special Needs Table"
    echo "[4] Return to Main Menu"
    read -p "Enter option (1-4): " option

    case $option in
        1) 
            echo "Healthy Animals:"
            column -t -s',' "$healthy_file"
            ;;
        2) 
            echo "Animals in Treatment:"
            column -t -s',' "$treatment_file"
            ;;
        3) 
            echo "Animals with Special Needs:"
            column -t -s',' "$special_needs_file"
            ;;
        4) 
            main_menu
            ;;
        *) 
            echo "Invalid option."
            ;;
    esac

    rm "$healthy_file" "$treatment_file" "$special_needs_file"
    pause_and_return
}

# Add the new option in the analyze_statistics menu
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
        3) show_health_status ;;  # Added this line
        4) animal_list ;;
        5) date_summary ;;
        6) main_menu ;;
        *) echo "Invalid option. Please try again." ; analyze_statistics ;;
    esac
}




date_summary() {
    clear  # Clear the terminal screen for better readability
    echo "============================================"
    echo "|    ARRIVAL AND RETRIEVAL DATE SUMMARY    |"
    echo "============================================"

    # Prompt the user to choose between retrieving arrival or adoption data
    echo "| Choose an option to retrieve:            |"
    echo "| 1. Number of Animals that Arrived        |"
    echo "| 2. Number of Animals that Were Adopted   |"
    echo "============================================"
    read -p "| Enter your choice (1 or 2): " choice
    echo "============================================"

    case $choice in
        1)  # If the user chooses option 1
            echo "| Choose a filter:                         |"
            echo "| a. By Month                              |"
            echo "| b. By Year                               |"
            echo "============================================"
            read -p "| Enter your choice (a or b): " arrival_filter
            
            # If filtering by month
            if [ "$arrival_filter" == "a" ]; then
                read -p "| Enter the Month (MM): " month
                read -p "| Enter the Year (YYYY): " year
                # Use awk to count the number of animals that arrived in the specified month and year
                count=$(awk -F, -v month="$year-$month" '$8 ~ month {count++} END {print count}' "$CSV_FILE")
                echo "============================================"
                echo "| $count animals arrived in $month/$year.     "
                echo "============================================"
            
            # If filtering by year
            elif [ "$arrival_filter" == "b" ]; then
                read -p "| Enter the Year (YYYY): " year
                # Use awk to count the number of animals that arrived in the specified year
                count=$(awk -F, -v year="$year" '$8 ~ year {count++} END {print count}' "$CSV_FILE")
                echo "============================================"
                echo "| $count animals arrived in year $year.     "
                echo "============================================"
            else
                echo "============================================"
                echo "| Invalid choice.                          |"  # Handle invalid filter choice
                echo "============================================"
            fi
            ;;
        
        2)  # If the user chooses option 2
            echo "| Choose a filter:                         |"
            echo "| a. By Month                              |"
            echo "| b. By Year                               |"
            echo "============================================"
            read -p "| Enter your choice (a or b): " adoption_filter
            
            # If filtering by month
            if [ "$adoption_filter" == "a" ]; then
                read -p "| Enter the Month (MM): " month
                read -p "| Enter the Year (YYYY): " year
                # Use awk to count the number of animals that were adopted in the specified month and year
                count=$(awk -F, -v month="$year-$month" '$10 ~ month {count++} END {print count}' "$CSV_FILE")
                echo "============================================"
                echo "| $count animals were adopted in $month/$year."
                echo "============================================"
            
            # If filtering by year
            elif [ "$adoption_filter" == "b" ]; then
                read -p "| Enter the Year (YYYY): " year
                # Use awk to count the number of animals that were adopted in the specified year
                count=$(awk -F, -v year="$year" '$10 ~ year {count++} END {print count}' "$CSV_FILE")
                echo "============================================"
                echo "| $count animals were adopted in year $year."
                echo "============================================"
            else
                echo "============================================"
                echo "| Invalid choice.                          |"  # Handle invalid filter choice
                echo "============================================"
            fi
            ;;
        
        *)  # Handle invalid main option choice
            echo "============================================"
            echo "| Invalid choice.                          |"
            echo "============================================"
            ;;
    esac

    pause_and_return  # Call a function to pause and return to the main menu
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
    echo "============================================"
    echo "|      ANIMAL SHELTER SYSTEM TERMINATION    |"
    echo "============================================"
    echo "|                                          |"
    echo "|          Thank you for using the         |"
    echo "|     Animal Shelter Management System!    |"
    echo "|                                          |"
    echo "|                 Goodbye!                 |"
    echo "============================================"
    echo "|      We hope to see you again soon!      |"
    echo "============================================"
    echo ""
    sleep 2  # Optional: pause for 2 seconds before exiting
    exit 0
}


# Start the script by displaying the welcome page and main menu
welcome_page
main_menu
