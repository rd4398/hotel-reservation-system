'''
The main file which acts as the entry point of the application.
'''

# Import the necessary modules
import config
import connection
import login
import visualization
import pymysql
from datetime import date


# Get mysql creds from config file
mysql_creds = config.get_mysql_creds()
# Create the object for connection
conObj = connection.Connect(mysql_creds)
# Make connection with mysql
conn = conObj.make_connection()

# Run a while loop for choice between admin flow, customer flow or exit the application
while True:
    choice = input("Are you a customer or admin: ?\nEnter c for customer, a for admin or e to exit: ")

    # if the user enters c, launch the UI for customer
    if choice.lower() == 'c':
        # Start the app
        login.launch_app()

    # If the customer enters a, start the command line admin menu
    elif choice.lower() == 'a':
        # Run the while loop for admin features till user exits the code. 
        while True:
            print("1. Get Analysis")
            print("2. Get Final Bill for Customer")
            print("3. View Employees")
            print("4. Increment Employee Salary")
            print("5. Exit")
            op = input("Enter the digit for operation you want to perform: ")

            # Get the analysis for the data generated by the system
            if op == '1':
                visualization.get_analysis()
            
            # Calculate the total bill for the customer
            elif op == '2':
                customer_id = int(input("Enter the customer id: "))
                checkin_date = input("Enter checkin date: ")
                checkout_date = input("Enter checkout date: ")

                try:
                    cur = conn.cursor()
                    func_call = 'select CALCULATE_TOTAL_BILL(%s,%s,%s) as total_bill'
                    cur.execute(func_call, (customer_id, checkin_date, checkout_date,))
                    conn.commit()
                    result = cur.fetchone()
                    bill = result['total_bill']
                    print("The total bill for customer is: ", str(bill))
                    payment_type = input("Enter the payment type (credit card / cash): ")

                    insert_payment_query = 'insert into `payment` (`customer_id`,`amount`,`type`, `date`) values (%s, %s,%s,%s)'
                    cur.execute(insert_payment_query, (customer_id, bill, payment_type, str(date.today())))
                    conn.commit()
                    cur.close()

                except pymysql.err.OperationalError as e:
                    print('Error is: '+ str(e))

            # Get the employees that work in hotels
            elif op == '3':
                employees = []
                try:
                    cur = conn.cursor()
                    query = 'select name from employee'
                    cur.execute(query)
                    conn.commit()
                    result = cur.fetchall()
                    for r in result:
                        employees.append(r['name'])

                    cur.close()
                    print("The employee names are: \n", employees)

                except pymysql.err.OperationalError as e:
                    print('Error is: '+ str(e))

            # Increment the salary for the employee    
            elif op == '4':
                employee_id = int(input("Enter the Employee Id: "))
                try:
                    cur = conn.cursor()
                    func_call = 'select INCREMENT_SALARY(%s) as new_salary'
                    cur.execute(func_call, (employee_id,))
                    conn.commit()
                    result = cur.fetchone()
                    cur.close()
                    print("The updated Salary is: ", str(result['new_salary']))

                except pymysql.err.OperationalError as e:
                    print('Error is: '+ str(e))
            # Exit the admin features menu
            elif op == '5':
                print("Exiting....\n")
                conn.close()
                break
            else:
                print("Invalid Option. Please enter a digit from above mentioned options\n")
                
    # Exit the code
    elif choice.lower() == 'e':
        exit()