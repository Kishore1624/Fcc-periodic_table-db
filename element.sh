#!/bin/bash

# Database connection command
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if an argument is provided
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
else
  # Query the database for the element
  if [[ $1 =~ ^[0-9]+$ ]]; then
    # If the argument is a number, treat it as atomic_number
    RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
    FROM elements 
    INNER JOIN properties USING(atomic_number) 
    INNER JOIN types USING(type_id) 
    WHERE atomic_number = $1;")
  else
    # Otherwise, treat it as symbol or name
    RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
    FROM elements 
    INNER JOIN properties USING(atomic_number) 
    INNER JOIN types USING(type_id) 
    WHERE symbol = '$1' OR name = '$1';")
  fi

  # Check if the result is empty
  if [[ -z $RESULT ]]; then
    echo "I could not find that element in the database."
  else
    # Parse and display the result
    echo $RESULT | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELT BOIL; do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  fi
fi
