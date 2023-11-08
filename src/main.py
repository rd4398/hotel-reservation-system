'''
The main file where we invoke our application
'''

import config
import connection
import login

# Get mysql creds from config file
mysql_creds = config.get_mysql_creds()
# Create the object for connection
conObj = connection.Connect(mysql_creds)
# Make connection with mysql
conn = conObj.make_connection()
# Start the app
login.launch_app()