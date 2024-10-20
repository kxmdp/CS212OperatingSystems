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
update
    }
    
    
    # Show options for the user to choose what to edit
update() {
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
    echo -n "Enter the ID: "
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

search_animal() {
    clear
    echo "============================================"
    echo "|          SEARCH FOR AN ANIMAL            |"
    echo "============================================"
    echo ""
    echo -n "Enter the ID: "
    read id

    # Check if the animal exists in the CSV file
    if ! grep -q "$id" "$CSV_FILE"; then
        echo "Error: No animal with ID $id found in the records."
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
echo
echo
echo "Do you want to update this animal?"
read choicee
if [ "$choicee" == "yes" ]; then
echo "1.update_animal"
echo "2.remove_animal"
read want
case "$want" in
1)
update
;;
2)
remove
;;
*)
echo "Not in the choices"
;;
esac
fi
    fi
if [ "$adoption_status" == "Available" ]; then
echo
echo
echo "Do you want to update this animal?"
read updates
if [ "$updates" == "yes" ]; then
echo "1.update_animal"
echo "2.remove_animal"
read updatess
case "$updatess" in
1)
update
;;
2)
remove
;;
*)
echo "Not in choices"
;;
esac
else

    echo "============================================"
  fi  
    pause_and_return
fi
}

# CRANE
# Function to show total number of animals and by category
total_animals() {
clear
echo "============================================"
echo "|    TOTAL NUMBER OF ANIMALS & CATEGORY    |"
echo "============================================"
echo -e "\e[1;34m"

if [[ ! -f "$CSV_FILE" ]]; then
    echo -e "\e[1;31mError: CSV file not found!\e[0m"
    pause_and_return
    return
fi
CATEGORY_COLUMN=${1:-4}
total=$(wc -l < "$CSV_FILE")
echo -e "\e[1;32mTotal number of animals: $((total - 1))\e[0m"

echo -e "\n\e[1;33mNumber of animals by category:\e[0m"
cut -d',' -f"$CATEGORY_COLUMN" "$CSV_FILE" | tail -n +2 | sort | uniq -c | while read -r count category; do
    echo -e "\e[1;36m$category:\e[0m \e[1;35m$count\e[0m"
done

echo -e "\e[0m"
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
        echo "No animal records available."
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
    echo "Adoption Status:"
    echo "--------------------------------------------"
    echo "Number of adopted animals: $adopted_count"
    echo "Number of available animals: $available_count"
    echo "Total rate of adoption: $adoption_rate%"

    
    # code here
    pause_and_return
}

# LANDER
# Function to show health status overview and summary
health_status() {
    clear
    echo "============================================"
    echo "|    HEALTH STATUS OVERVIEW AND SUMMARY    |"
    echo "============================================"

    # Check if the CSV file is empty
    if [ ! -s "$CSV_FILE" ]; then
        echo "No animal records available."
        pause_and_return_analyze
        return
    fi

    # Variables to track counts
    healthy_count=0
    treatment_count=0
    special_needs_count=0
    deaf_count=0
    blind_count=0
    missing_limb_count=0

    # Loop through the records and count the different health statuses
    while IFS=',' read -r animal id breed category sex size health_status arrival_date adoption_status adoption_date adopter_name; do
        case "$health_status" in
            "Healthy")
                ((healthy_count++))
                ;;
            "In Treatment")
                ((treatment_count++))
                ;;
            "With Special Needs - Deaf")
                ((special_needs_count++))
                ((deaf_count++))
                ;;
            "With Special Needs - Blind")
                ((special_needs_count++))
                ((blind_count++))
                ;;
            "With Special Needs - Missing a Limb")
                ((special_needs_count++))
                ((missing_limb_count++))
                ;;
            *)
                ;;
        esac
    done < "$CSV_FILE"

    # Display results
    echo "Number of Healthy Animals: $healthy_count"
    echo "Number of Animals in Treatment: $treatment_count"
    echo "Number of Animals with Special Needs: $special_needs_count"
    echo "    * Number of Deaf Animals: $deaf_count"
    echo "    * Number of Blind Animals: $blind_count"
    echo "    * Number of Animals Missing a Limb: $missing_limb_count"
    
    pause_and_return_analyze
}
#BYRON
animal_list() {
    # Clear the screen
    clear
    echo "============================================"
    echo "|     ANIMAL LIST AND RECORD HIGHLIGHTS    |"
    echo "============================================"

    # Function to display animals that lived the longest in the shelter
    display_longest_lived_animals() {
        echo "======== Animals that lived the longest in the shelter ========"
        printf "%-3s %-9s %-17s %-13s %-13s %-10s\n" "No." "Animal ID" "Name of Animal" "Arrival Date" "Adoption Date" "Status"
        printf "%-3s %-8s %-16s %-14s %-13s %-10s\n" "---" "---------" "----------------" "-------------" "-------------" "-----"

        awk -F, '
        NR > 1 {
            status = ($9 == "Adopted" ? "Adopted" : "Available"); # Determine status based on adoption column
            # Print formatted output for each row with arrival and adoption dates
            printf("%-3d %-9s %-17s %-13s %-13s %-10s\n", NR-1, $2, $1, $8, ($9 == "Adopted" ? $10 : "N/A"), status);
        }' $CSV_FILE | sort -k4,4 | head -n 10 | awk '{printf "%-3d %-9s %-17s %-13s %-13s %-10s\n", NR, $2, $3, $4, $5, $6}'
    }

    # Function to display recently arrived animals in the shelter
    display_recently_arrived_animals() {
        echo "=== Animals that have recently arrived in the shelter ==="
        printf "%-5s %-10s %-20s %-15s\n" "No." "Animal ID" "Name of Animal" "Date of Arrival"
        printf "%-5s %-10s %-20s %-15s\n" "----" "----------" "-------------------" "---------------"

        # Extract relevant fields, sort by arrival date in reverse (most recent), and display the top 10
        awk -F, 'NR > 1 {printf "%s,%s,%s,%s\n", $2, $3, $1, $8}' $CSV_FILE | \
        sort -t, -k4,4r | head -n 10 | \
        awk -F, '{printf "%-5d %-10s %-20s %-15s\n", NR, $1, $2, $4}'
    }

    # Function to display recently adopted animals
    display_recently_adopted_animals() {
        echo "=== Animals that have recently been adopted ==="
        printf "%-5s %-10s %-20s %-15s\n" "No." "Animal ID" "Name of Animal" "Adoption Date"
        printf "%-5s %-10s %-20s %-15s\n" "----" "----------" "-------------------" "---------------"

        # Extract relevant fields for adopted animals, sort by adoption date, and display the top 10
        awk -F, 'NR > 1 && $9 == "Adopted" {printf "%s,%s,%s,%s\n", $2, $3, $1, $10}' $CSV_FILE | \
        sort -t, -k4,4r | head -n 10 | \
        awk -F, '{printf "%-5d %-10s %-20s %-15s\n", NR, $1, $2, $4}'
    }

    # Menu loop
    while true; do
        # Show choices
        echo "Choices to show: "
        echo "[1] Animals that lived the longest in the shelter"
        echo "[2] Animals that have recently arrived in the shelter"
        echo "[3] Animals that have recently been adopted"
        
        # Prompt the user for a choice
        echo -n "Enter chosen number (1-3): "
        read choice

        # Execute the function based on the user's choice
        case $choice in
            1) display_longest_lived_animals ;;  # Call function to display longest lived animals
            2) display_recently_arrived_animals ;;  # Call function to display recent arrivals
            3) display_recently_adopted_animals ;;  # Call function to display recent adoptions
            *) echo "Invalid choice. Please enter a number between 1 and 3." ;;  # Invalid choice message
        esac

        # Ask the user if they want to make another choice
        echo -n "Do you want to make another choice? (y/n): "
        read continue
        if [[ "$continue" != "y" ]]; then
            break  # Exit the loop if the user enters anything other than 'y'
        fi
    done
    pause_and_return
}



# Function to show arrival and retrieval date summary
date_summary() {
    clear
    echo "============================================"
    echo "|    ARRIVAL AND RETRIEVAL DATE SUMMARY    |"
    echo "============================================"

    # Check if the CSV file is empty
    if [ ! -s "$CSV_FILE" ]; then
        echo "No animal records available."
        pause_and_return
        return
    fi
    
    # Calculate earliest and latest arrival dates (8th column), excluding the header
    earliest_arrival=$(tail -n +2 "$CSV_FILE" | cut -d',' -f8 | sort -t'/' -k3,3 -k1,1n -k2,2n | head -n 1)
    latest_arrival=$(tail -n +2 "$CSV_FILE" | cut -d',' -f8 | sort -t'/' -k3,3 -k1,1n -k2,2n | tail -n 1)

    echo "Earliest Arrival Date: $earliest_arrival"
    echo "Latest Arrival Date: $latest_arrival"
    echo ""

    # Extract valid adoption dates (10th column), excluding the header
    adoption_dates=$(tail -n +2 "$CSV_FILE" | cut -d',' -f10 | grep -E '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}' | sort -t'/' -k3,3 -k1,1n -k2,2n)

    # Get earliest and latest adoption dates
    earliest_adoption=$(echo "$adoption_dates" | head -n 1)
    latest_adoption=$(echo "$adoption_dates" | tail -n 1)

    # Check if adoption dates are found
    if [ -z "$earliest_adoption" ]; then
        earliest_adoption="No valid adoption dates"
    fi

    if [ -z "$latest_adoption" ]; then
        latest_adoption="No valid adoption dates"
    fi

    echo "Earliest Adoption Date: $earliest_adoption"
    echo "Latest Adoption Date: $latest_adoption"
    echo ""

    # Count the number of adopted animals, excluding the header
    adopted_count=$(tail -n +2 "$CSV_FILE" | cut -d',' -f9 | grep -c 'Adopted')

    # Count the number of available animals, excluding the header
    available_count=$(tail -n +2 "$CSV_FILE" | cut -d',' -f9 | grep -c 'Available')

    echo "Number of Animals Adopted: $adopted_count"
    echo "Number of Available Animals: $available_count"
    echo ""

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
