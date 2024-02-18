#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
ARG=$1
CHECK_INPUT(){
  SYMB_REGEX=^[A-Z][a-z]?$
  NUMB_REGEX=[0-9]+

  if [[ $ARG =~ $SYMB_REGEX ]]
  then
    GET_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE Symbol='$ARG'")
  elif [[ $ARG =~ $NUMB_REGEX ]]
  then
    GET_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$ARG")
  else
    GET_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$ARG'")
  fi

}

OUTPUT(){
  CHECK_INPUT
  
  if [[ -z $GET_ATOMIC_NUMBER ]]
  then
    echo I could not find that element in the database.
  else
  GET_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$GET_ATOMIC_NUMBER")
  GET_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$GET_ATOMIC_NUMBER")
  GET_TYPE=$($PSQL "SELECT type FROM properties INNER JOIN types USING(type_id) WHERE atomic_number=$GET_ATOMIC_NUMBER")
  GET_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$GET_ATOMIC_NUMBER")
  GET_MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$GET_ATOMIC_NUMBER")
  GET_BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$GET_ATOMIC_NUMBER")
  echo -e "\nThe element with atomic number $GET_ATOMIC_NUMBER is $GET_NAME ($GET_SYMBOL). It's a $GET_TYPE, with a mass of $GET_MASS amu. $GET_NAME has a melting point of $GET_MELTING celsius and a boiling point of $GET_BOILING celsius."
  fi
}

if [[ -z $ARG ]]
then
  echo Please provide an element as an argument.
else
  OUTPUT
fi

