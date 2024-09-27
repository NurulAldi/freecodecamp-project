#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"



if [[ $1 ]]
then
  
  ELEMENT=$($PSQL "SELECT * FROM elements WHERE atomic_number::TEXT = '$1' OR symbol = '$1' OR name LIKE '$1'")
  
  if [[ -z $ELEMENT ]]
  then
    echo -e "I could not find that element in the database."
  else
    
    IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME <<< "$ELEMENT"
    PROPERTIES=$($PSQL "SELECT type_id, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER ")
    IFS='|' read -r TYPE_ID ATMASS MELT_POINT BOIL_POINT <<< "$PROPERTIES"
    TYPES=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPES, with a mass of $ATMASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius."
  fi
else
  echo -e "Please provide an element as an argument."
fi