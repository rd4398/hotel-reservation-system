'''
Customer register and login UI Window.
'''

import tkinter as tk
from tkinter import messagebox
import config
import connection
import customer_dashboard

'''
This method spins up the UI and starts the application. It asks the customer to register (create account) for the
portal by requesting a username and password or login if user has already registered.
'''
def launch_app():
    global screen
    screen = tk.Tk()
    screen.geometry('300x250')
    screen.title("Welcome!")
    tk.Label(text= 'Hotel Reservation System', bg = 'grey', width='300', height='2', font=('Calibri',13)).pack()
    tk.Label(text='').pack()
    tk.Button(text='Login', height='2', width='30',command=login_window).pack()
    tk.Label(text='').pack()
    tk.Button(text='Register', height='2', width='30',command=register_window).pack()
    center_screen()
    screen.mainloop()

'''
This method is used to place the GUI window at the center of our screen
'''
def center_screen():
        w = screen.winfo_reqwidth()
        h = screen.winfo_reqheight()
        ws = screen.winfo_screenwidth()
        hs = screen.winfo_screenheight()
        x = (ws/2) - (w/2) - 100
        y = (hs/2) - (h/2) - 100
        screen.geometry('+%d+%d' % (x, y))

'''
This method is used to create the window for customer account registration. The customer will enter the username and 
password for the account on this screen.
'''
def register_window():
        global register_screen
        global password
        global username
        
        password = tk.StringVar()
        username = tk.StringVar()

        register_screen = tk.Toplevel(screen)
        register_screen.title('Register Customer')
        register_screen.geometry('400x400')

        tk.Label(register_screen, text= 'Please enter your details', bg = 'grey', width='300', height='2', font=('Calibri',10)).pack()
        tk.Label(register_screen, text='').pack()

        user_label = tk.Label(register_screen, text='Username')
        user_label.place(x=70, y=100)
        user_entry = tk.Entry(register_screen, textvariable=username)
        user_entry.place(x = 180, y=100)

        pass_label = tk.Label(register_screen, text='Password')
        pass_label.place(x=70, y=175)
        pass_entry = tk.Entry(register_screen, textvariable=password, show='*')
        pass_entry.place(x = 180, y=175)

        register_button = tk.Button(register_screen, text='Register', width=10, height=1,bg='grey', command=register)
        register_button.place(x=150,y=325)

        w = register_screen.winfo_reqwidth()
        h = register_screen.winfo_reqheight()
        ws = register_screen.winfo_screenwidth()
        hs = register_screen.winfo_screenheight()
        x = (ws/2) - (w/2) - 100
        y = (hs/2) - (h/2) - 100
        register_screen.geometry('+%d+%d' % (x, y))
        register_screen.mainloop()

'''
This method performs the functionality to register or create account for the customer. It takes the username and 
password entered by the user and stores in the database in the auth table.
'''
def register():
        username_data = username.get()
        password_data = password.get()
        mysql_creds = config.get_mysql_creds()
        conObj = connection.Connect(mysql_creds)
        con = conObj.make_connection()
        cur = con.cursor()
        create_table = 'Create table if not exists auth(username varchar(50) primary key, password varchar(50) not null)'
        cur.execute(create_table)
        insert_query = "insert into `auth` (`username`, `password`) values (%s,%s)"
        cur.execute(insert_query,(username_data, password_data))
        con.commit()
        cur.close()
        con.close()
        
        username.set("")
        password.set("")
        
        messagebox.showinfo(title='Confirmation', message='Customer Registration successful')
        register_screen.withdraw()
        
'''
This method is used to create the window for customer login. The customer will enter the username and 
password for the account on this screen and if successful, will be able to proceed. If the credentials are wrong,
appropriate message is displayed.
'''    
def login_window():
        global login_screen
        login_screen = tk.Toplevel(screen)
        login_screen.title('Customer Login')
        login_screen.geometry('400x400')
        global uname
        global pwd
        uname = tk.StringVar()
        pwd = tk.StringVar()
        tk.Label(login_screen, text= 'Please enter your credentials', bg = 'grey', width='300', height='2', font=('Calibri',10)).pack()
        tk.Label(login_screen, text='').pack()
        uname_label = tk.Label(login_screen, text='User name')
        uname_label.place(x=40, y=150)
        uname_entry = tk.Entry(login_screen, textvariable=uname)
        uname_entry.place(x = 150, y=150)
        pwd_label = tk.Label(login_screen, text='Password')
        pwd_label.place(x=40, y=250)
        pwd_entry = tk.Entry(login_screen, textvariable=pwd, show='*')
        pwd_entry.place(x = 150, y=250)
        login_button = tk.Button(login_screen, text='Login', width=10, height=1,bg='grey', command=login)
        login_button.place(x=145, y=350)
        w = login_screen.winfo_reqwidth()
        h = login_screen.winfo_reqheight()
        ws = login_screen.winfo_screenwidth()
        hs = login_screen.winfo_screenheight()
        x = (ws/2) - (w/2) - 100
        y = (hs/2) - (h/2) - 100
        login_screen.geometry('+%d+%d' % (x, y))
        login_screen.mainloop()    

'''
This method performs the functionality to login for the customer. It takes the username and 
password entered by the user and validates it by fetching the creds from the database using the auth table.
'''
def login():
        temp = []
        global uname_data
        uname_data = uname.get()
        pwd_data = pwd.get()
        mysql_creds = config.get_mysql_creds()
        conObj = connection.Connect(mysql_creds)
        con = conObj.make_connection()
        cur = con.cursor()
        select_query = 'select * from auth'
        cur.execute(select_query)
        rows = cur.fetchall()
        cur.close()
        con.close()
        uname.set("")
        pwd.set("")
        for row in rows:
            if row['username'] == uname_data:
               if row['password'] == pwd_data:
                        flag = 'Success'
                        temp.append(row)
                        break

            flag = 'Fail'        
        
        if flag == 'Success':
                login_screen.destroy()
                screen.destroy()
        
        else:
                messagebox.showinfo(title='Warning', message='Customer Login Failed')
        
        customer_dashboard.customer_dashboard()

def get_uname():
        return uname_data