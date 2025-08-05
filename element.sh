#!/bin/bash 

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

INPUT="$1"

if [[ -z $INPUT ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

if [[ $INPUT =~ ^[0-9]+$ ]]; then
  ELEMENT_DATA=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number=$INPUT;")
else
  ELEMENT_DATA=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol='$INPUT' OR name='$INPUT';")
fi

if [[ -z $ELEMENT_DATA ]]; then
  echo "I could not find that element in the database."
else
  echo "$ELEMENT_DATA" | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done 
fi