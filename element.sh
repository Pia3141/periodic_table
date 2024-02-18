#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"

OUTPUT(){
  GET_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number='$1' OR symbol='$1' OR name='$1'")
  GET_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number='$1' OR symbol='$1' OR name='$1'")
  GET_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number='$1' OR symbol='$1' OR name='$1'")
  GET_TYPE=$($PSQL "SELECT type FROM properties WHERE atomic_number=$GET_ATOMIC_NUMBER")
  GET_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$GET_ATOMIC_NUMBER")
  GET_MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$GET_ATOMIC_NUMBER")
  GET_BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$GET_ATOMIC_NUMBER")
  echo -e "\nThe element with atomic number $GET_ATOMATIC_NUMBER is $GET_NAME ($GET_SYMBOL). It's a $GET_TYPE, with a mass of $GET_MASS amu. $GET_NAME has a melting point of $GET_MELTING celsius and a boiling point of $GET_BOILING celsius."
 
}

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
echo $1
  OUTPUT
fi

