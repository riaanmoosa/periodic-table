#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# If no argument is given
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# Search by atomic number if input is a number
if [[ $1 =~ ^[0-9]+$ ]]
then
  RESULT=$($PSQL "SELECT atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $1")
else
  # Search by symbol or name
  RESULT=$($PSQL "SELECT atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE symbol = INITCAP('$1') OR name = INITCAP('$1')")
fi

# Check if result is empty
if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
  exit
fi

# Parse and format result
IFS="|" read ATOMIC_NUMBER NAME SYMBOL MASS MELT BOIL TYPE <<< "$RESULT"
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."

