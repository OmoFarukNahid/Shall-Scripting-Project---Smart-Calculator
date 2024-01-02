#!/bin/bash

# Function to display menu options
show_menu() {
 echo "=============================="
  echo " Welcome to Smart Calculator App "
  echo "=============================="
  echo "Smart Calculator Menu:"
  echo "1. Basic Arithmetic"
  echo "2. Trigonometric Functions"
  echo "3. Get Current Temperature"
  echo "4. Fitness Calculator"
  echo "5. Date Time"
  echo "6. Others"
  echo "7. Exit"
}

# Function to perform basic arithmetic operations
basic_operations() {
  read -p "Enter first number: " num1
  read -p "Enter second number: " num2
  echo "Select operation:"
  echo "1. Addition"
  echo "2. Subtraction"
  echo "3. Multiplication"
  echo "4. Division"
  read -p "Enter your choice: " operation
  case $operation in
    1) result=$(echo "$num1 + $num2" | bc);;
    2) result=$(echo "$num1 - $num2" | bc);;
    3) result=$(echo "$num1 * $num2" | bc);;
    4) result=$(echo "scale=2; $num1 / $num2" | bc);;
    *) echo "Invalid choice";;
  esac
  echo "Result: $result"
}

# Function to perform trigonometric functions
trig_functions() {
  echo "Trigonometric Functions:"
  echo "1. Sine"
  echo "2. Cosine"
  echo "3. Tangent"
  read -p "Enter your choice: " trig_choice
  case $trig_choice in
    1) read -p "Enter angle in radians: " angle
       result=$(echo "s($angle)" | bc -l);;
    2) read -p "Enter angle in radians: " angle
       result=$(echo "c($angle)" | bc -l);;
    3) read -p "Enter angle in radians: " angle
       result=$(echo "s($angle)/c($angle)" | bc -l);;
    *) echo "Invalid choice";;
  esac
  echo "Result: $result"
}

# Function to fetch current temperature using curl and jq
get_temperature() {
 
     location="Dhaka"  # Replace with your city name or use a location fetch API

    temperature=$(curl -s "wttr.in/$location?format=%t")
    echo "Current temperature in $location: $temperature"
}

# Function for Fitness Calculator (BMI, Calorie, Body Fat)
fitness_calculator() {
  echo "Fitness Calculator:"
  echo "1. BMI Calculator"
  
  read -p "Enter your choice: " fitness_choice
  case $fitness_choice in
    1) bmi_calculator;;
   
    *) echo "Invalid choice";;
  esac
}

# Function for BMI Calculator
bmi_calculator() {
  read -p "Enter weight in kilograms: " weight
  read -p "Enter height in feet: " height_feet
  read -p "Enter height in inches: " height_inches
  read -p "Enter age in years: " age

  total_height_inches=$(echo "$height_feet * 12 + $height_inches" | bc)
  height_in_meters=$(echo "scale=2; $total_height_inches * 0.0254" | bc)

  bmi=$(echo "scale=2; $weight / ($height_in_meters * $height_in_meters)" | bc)

  echo "BMI: $bmi"

  if (( $age >= 18 )); then
    if (( $(echo "$bmi < 18.5" | bc) )); then
      echo "Category: Underweight"
    elif (( $(echo "$bmi >= 18.5 && $bmi < 25" | bc) )); then
      echo "Category: Normal weight"
    elif (( $(echo "$bmi >= 25 && $bmi < 30" | bc) )); then
      echo "Category: Overweight"
    else
      echo "Category: Obesity"
    fi
  else
    echo "Hazardous...... Please consult a healthcare professional."
  fi
}


# Function for Date Time calculations (Age Calculator, Date Difference Calculator)
date_time_calculations() {
  echo "Date Time Calculations:"
  echo "1. Age Calculator"
  read -p "Enter your choice: " date_choice
  case $date_choice in
    1) age_calculator;;
    *) echo "Invalid choice";;
  esac
}

# Function for Age Calculator
age_calculator() {
  read -p "Enter your date of birth (YYYY-MM-DD): " dob

  # Get current date and time
  current_datetime=$(date +"%Y-%m-%d %H:%M:%S")

  # Calculate age
  dob_timestamp=$(date -d "$dob" +"%s")
  current_timestamp=$(date -d "$current_datetime" +"%s")

  age_seconds=$((current_timestamp - dob_timestamp))

  # Calculate years, months, and days
  age_years=$((age_seconds / 31536000))  # 31536000 seconds in a year
  remaining_seconds=$((age_seconds % 31536000))

  age_months=$((remaining_seconds / 2628000))  # 2628000 seconds in a month
  remaining_seconds=$((remaining_seconds % 2628000))

  age_days=$((remaining_seconds / 86400))  # 86400 seconds in a day

  echo "Your age is: $age_years years, $age_months months, and $age_days days"
}


# Function for Other Calculations (CGPA, Prime Number, Discount)
other_calculations() {
  echo "Other Calculations:"
  echo "1. CGPA Calculation"
  echo "2. Prime Number Calculator"
  echo "3. Discount Calculator"
  read -p "Enter your choice: " other_choice
  case $other_choice in
    1) cgpa_calculator;;
    2) prime_number_calculator;;
    3) discount_calculator;;
    *) echo "Invalid choice";;
  esac
}

# Function for CGPA Calculation
cgpa_calculator() {
  declare -a grades   # Array to store grade points
  declare -a credits  # Array to store credits
  total_courses=0     # Total number of courses
  total_grade_point_credit=0
  total_credits=0

  read -p "Enter the number of courses: " total_courses

  for ((i = 1; i <= total_courses; i++)); do
    read -p "Enter grade point for course $i: " grade_point
    grades+=("$grade_point")

    read -p "Enter credits for course $i: " credit
    credits+=("$credit")

    total_grade_point_credit=$(echo "$total_grade_point_credit + (${grade_point} * ${credit})" | bc)
    total_credits=$(echo "$total_credits + ${credit}" | bc)
  done

  cgpa=$(echo "scale=2; $total_grade_point_credit / $total_credits" | bc)
  echo "CGPA: $cgpa"
}


# Function for Prime Number Calculator
prime_number_calculator() {

  read -p "Enter a number: " n

  if [ $n -lt 2 ]; then
    echo "$n is not a prime number"
    return
  fi

  prime="true"
  for (( i=2; i<=n/2; i++ )); do
    if [ $((n%i)) -eq 0 ]; then
      prime="false"
      break
    fi
  done

  if [ "$prime" = "true" ]; then
    echo "$n is a prime number"
  else
    echo "$n is not a prime number"
  fi
}


# Function for Discount Calculator
discount_calculator() {

 read -p "Enter total purchase amount: " total_amount
  read -p "Enter discount percentage: " discount_percentage

  if (( $discount_percentage <= 0 )); then
    echo "Invalid discount percentage. Please enter a positive value."
    return
  fi

  discount=$(echo "scale=2; $total_amount * $discount_percentage / 100" | bc)
  discounted_amount=$(echo "scale=2; $total_amount - $discount" | bc)

  echo "Total Purchase Amount: $total_amount"
  echo "Applied Discount Percentage: $discount_percentage%"
  echo "Discount: $discount"
  echo "Discounted Amount: $discounted_amount"
}


while true; do
  show_menu
  read -p "Enter your choice: " choice
  case $choice in
    1) basic_operations;;
    2) trig_functions;;
    3) get_temperature;;
    4) fitness_calculator;;
    5) date_time_calculations;;
    6) other_calculations;;
    7) echo "Exiting..."; break;;
    *) echo "Invalid choice";;
  esac
done
