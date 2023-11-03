'''
This file contains the configuration for mysql connection. The username is set to root by default.
You can change it if you have a different username. We take the password from the user and use the getpass
module to do it.
'''
from getpass import getpass

'''
This function returns the mysql credentials required for login.
'''
def get_mysql_creds():

    username = 'root'                                       # Your MySQL username here
    password = getpass("Enter your mysql password: ")       # Your MySQL password here
    hostname = 'localhost'
    dbname = 'hotels'                                       # This is the DB name
    charset = 'utf8mb4'

    return {'username':username, 
            'password':password,
            'hostname':hostname, 
            'dbname': dbname, 
            'charset': charset
            }