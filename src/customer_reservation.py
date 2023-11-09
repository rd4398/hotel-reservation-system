'''
This file will contain the UI and functionalities associated with customers making reservations at the hotels
'''
import tkinter as tk
from tkinter import messagebox
import connection
import pymysql

def customer_dashboard():
    global customer_dashboard_screen
    customer_dashboard_screen = tk.Tk()
    customer_dashboard_screen.geometry('1200x800')
    customer_dashboard_screen.title('Customer Dashboard')
    menubar = tk.Menu(customer_dashboard_screen)
    customer_dashboard_screen.config(menu=menubar)

    # Customer Menu
    customer_account_menu = tk.Menu(menubar,tearoff=0)
    customer_account_menu.add_command(label='Update Account', command=update_account_screen)
    customer_account_menu.add_separator()
    customer_account_menu.add_command(label='Delete Account',command=delete_account_prompt)
    menubar.add_cascade(label="Customer",menu=customer_account_menu)

    # Reservation Menu
    reservation_menu = tk.Menu(menubar,tearoff=0)
    reservation_menu.add_command(label='Update Reservation', command=register_staff_screen)
    reservation_menu.add_separator()
    reservation_menu.add_command(label='Delete Reseravtion',command=lookup_staff_prompt)
    menubar.add_cascade(label="Reservation",menu=reservation_menu)

    # Review Menu
    review_menu = tk.Menu(menubar,tearoff=0)
    review_menu.add_command(label='Add Review', command=add_review_screen_launch)
    menubar.add_cascade(label="Review",menu=review_menu)

    # Payment Menu
    payment_menu = tk.Menu(menubar,tearoff=0)
    payment_menu.add_command(label='Make Payment',command=payment_screen_launch)
    menubar.add_cascade(label="Payment",menu=payment_menu)

    # Logout Menu
    logout_menu = tk.Menu(menubar,tearoff=0)
    logout_menu.add_command(label='Exit',command=kill_customer_dashboard)
    menubar.add_cascade(label="Logout",menu=logout_menu)

    

    w = customer_dashboard_screen.winfo_reqwidth()
    h = customer_dashboard_screen.winfo_reqheight()
    ws = customer_dashboard_screen.winfo_screenwidth()
    hs = customer_dashboard_screen.winfo_screenheight()
    x = (ws/2) - (w/2) - 100
    y = (hs/2) - (h/2) - 100 
    customer_dashboard_screen.geometry('+%d+%d' % (x, y))
    customer_dashboard_screen.mainloop()

def update_account_screen():
    # TODO 
    pass

def delete_account_prompt():
    # TODO 
    pass

def register_staff_screen():
    # TODO 
    pass

def lookup_staff_prompt():
    # TODO 
    pass

def add_review_screen_launch():
    # TODO 
    pass

def payment_screen_launch():
    # TODO
    pass

def kill_customer_dashboard():
    customer_dashboard_screen.destroy()