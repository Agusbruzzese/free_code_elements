#!/bin/bash
#Este programa se usa para mostrar los elementos
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ -z $1 ]]
then
    echo "Please provide an element as an argument."
else
    CHOICE=$1

    # Si es número
    if [[ $CHOICE =~ ^[0-9]+$ ]]
    then
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $CHOICE")

    # Si es símbolo (1 o 2 letras)
    elif [[ $CHOICE =~ ^[a-zA-Z]{1,2}$ ]]
    then
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol ILIKE '$CHOICE'")

    # Si es nombre completo
    elif [[ $CHOICE =~ ^[a-zA-Z]+$ ]]
    then
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name ILIKE '$CHOICE'")
    fi

    if [[ -z $ATOMIC_NUMBER ]]
    then
        echo "I could not find that element in the database."
    else
        NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
        SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
        TYPE=$($PSQL "SELECT t.type FROM properties p JOIN types t ON p.type_id = t.type_id WHERE p.atomic_number = $ATOMIC_NUMBER")
        MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
        MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
        BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")

        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    fi
fi
