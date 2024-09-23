#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

SERVICES=$($PSQL "SELECT service_id, name FROM services")

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    if [[ ! $SERVICE_ID =~ ^[0-9]+$ ]]
    then
      tumbal="tumbal"
    else
      echo "$SERVICE_ID) $NAME"
    fi
  done

  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) CUT_SERVICE "$SERVICE_ID_SELECTED" ;;
    2) COLOR_SERVICE ;;
    3) PERM_SERVICE ;;
    4) STYLE_SERVICE ;;
    5) TRIM_SERVICE ;;
    *) MAIN_MENU "I could not find that service. What would you like today?"
  esac
}

CUT_SERVICE(){

  SERVICE_ID_SELECTED="$1"

  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  AVAILABLE_CUSTOMER=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ $AVAILABLE_CUSTOMER == *"(0 rows)"* ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi

  CUST_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'" | sed -n '3p')
  CUST_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'" | sed -n '3p')
  CUST_NAME_FORMATTED=$(echo $CUST_NAME | sed 's/^ //')
  
  echo -e "\nWhat time would you like your cut, $CUST_NAME_FORMATTED?"
  read SERVICE_TIME

  INSERT_APPOINTMENTS=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUST_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  echo -e "\nI have put you down for a cut at $SERVICE_TIME, $CUST_NAME_FORMATTED."
}

MAIN_MENU
