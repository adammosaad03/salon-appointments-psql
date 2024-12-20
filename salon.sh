#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~"
if [[ $1 ]]
then
echo -e "\n$1"
fi
MAIN_MENU(){
echo -e "\nWelcome to My Salon, how can I help you?"
SERVICES=$($PSQL "SELECT service_id, name FROM services") 

echo "1) haircut
2) trim 
3) groom"
read SERVICE_ID_SELECTED
if [[ ! $SERVICE_ID_SELECTED =~ ^[1-3]$ ]]
then 
MAIN_MENU "I could not find that service. What would you like today?\n"
else
APPOINTMENT "$SERVICE_ID_SELECTED"
fi

}
APPOINTMENT(){
  
  
  echo "What's your phone number?"
read CUSTOMER_PHONE
PHONE=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")
if [[ -z $PHONE ]]
then
echo "I don't have a record for that phone number, what's your name?"
read CUSTOMER_NAME 

CUSTOMER_NAME_GET=$($PSQL "SELECT name from customers where phone='$CUSTOMER_PHONE'")

INSERT_NUMBER=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")

GET_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

INSERT_APPO=$($PSQL "INSERT INTO appointments(customer_id,service_id) VALUES($GET_ID,$SERVICE_ID_SELECTED)")

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='${1}'")
SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed -E 's/ //g')
 echo -e "I added you as a new customer"
echo -e "\nWhat time would you like your $SERVICE_NAME_FORMATTED, $CUSTOMER_NAME?"
read SERVICE_TIME  CUSTOMER_ID 
INSERT_APP=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($GET_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")

echo -e "\nI have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME."
fi
}
MAIN_MENU
