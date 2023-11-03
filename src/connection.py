import pymysql

# class creates connection to mysql using pymysql
class Connect:

    '''
    The constructor of the class. It initializes the credentials required for mysql
    '''
    def __init__(self, mysql_creds):
        self.username = mysql_creds['username']
        self.password = mysql_creds['password']
        self.dbname = mysql_creds['dbname']
        self.charset = mysql_creds['charset']
        self.hostname = mysql_creds['hostname']

    '''
    This function makes connection with mysql and return the connection object
    '''
    def make_connection(self):
        try:
            con = pymysql.connect(host=self.hostname, user=self.username,
                          password=self.password,
                      db=self.dbname, charset=self.charset,
                          cursorclass=pymysql.cursors.DictCursor)
            print('Successfully connected to the database')
            return con

        except pymysql.err.OperationalError as e:
            print('Error is: %d: %s'% (e.args[0], e.args[1]))