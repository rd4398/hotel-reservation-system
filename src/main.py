'''
The main file where we invoke our application
'''

import config
import connection
import login
import visualization
import pymysql


# Get mysql creds from config file
mysql_creds = config.get_mysql_creds()
# Create the object for connection
conObj = connection.Connect(mysql_creds)
# Make connection with mysql
conn = conObj.make_connection()
while True:
    choice = input("Are you a customer or admin: ?\nEnter c for customer, a for admin or e to exit: ")
    if choice.lower() == 'c':
        # Start the app
        login.launch_app()


    elif choice.lower() == 'a':
        while True:
            print("1. Get Analysis")
            print("2. Get Final Bill for Customer")
            print("3. View Employees")
            print("4. Increment Employee Salary")
            print("5. Exit")
            op = input("Enter the digit for operation you want to perform: ")

            if op == '1':
                visualization.get_analysis()

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
                    cur.close()
                    print("The total bill for customer is: ", str(bill))

                except pymysql.err.OperationalError as e:
                    print('Error is: '+ str(e))

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

            elif op == '5':
                print("Exiting....\n")
                conn.close()
                break
            else:
                print("Invalid Option. Please enter a digit from above mentioned options\n")

    elif choice.lower() == 'e':
        exit()