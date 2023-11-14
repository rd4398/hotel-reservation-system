'''
This file will contain the UI and functionalities associated with customers making reservations at the hotels
'''
import tkinter as tk
from tkinter import messagebox
import connection
import pymysql
import config


def customer_dashboard():
    global customer_dashboard_screen
    global first_name
    global last_name
    global email
    global date_of_birth
    global phone
    global hotel_name
    global num_guests
    global check_in_date
    global check_out_date
    global activity_date
    global activity
    global room_type


    customer_dashboard_screen = tk.Tk()
    customer_dashboard_screen.geometry('800x800')
    customer_dashboard_screen.title('Customer Dashboard')
    menubar = tk.Menu(customer_dashboard_screen)
    customer_dashboard_screen.config(menu=menubar)

    # Customer Menu
    customer_account_menu = tk.Menu(menubar,tearoff=0)
    customer_account_menu.add_command(label='View Account', command=get_account_screen)
    customer_account_menu.add_separator()
    customer_account_menu.add_command(label='Update Account', command=update_account_screen)
    customer_account_menu.add_separator()
    customer_account_menu.add_command(label='Delete Account',command=delete_account_prompt)
    menubar.add_cascade(label="Customer",menu=customer_account_menu)

    # Reservation Menu
    reservation_menu = tk.Menu(menubar,tearoff=0)
    reservation_menu.add_command(label='Get Reservation', command=get_reservation_screen)
    reservation_menu.add_separator()
    reservation_menu.add_command(label='Update Reservation', command=update_reservation_screen)
    reservation_menu.add_separator()
    reservation_menu.add_command(label='Delete Reseravtion',command=delete_reservation_prompt)
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


    
    first_name = tk.StringVar()
    last_name = tk.StringVar()
    email = tk.StringVar()
    date_of_birth = tk.StringVar()
    phone = tk.StringVar()
    hotel_name = tk.StringVar()
    check_in_date = tk.StringVar()
    check_out_date = tk.StringVar()
    activity_date = tk.StringVar()
    room_type = tk.StringVar()
    activity = tk.StringVar()
    num_guests = tk.IntVar()
    hotel_list = []
    room_types = []
    activity_list = []

    mysql_creds = config.get_mysql_creds()
    conObj = connection.Connect(mysql_creds)
    con = conObj.make_connection()
    cur = con.cursor()

    hotel_query = 'select name from hotel'
    cur.execute(hotel_query)
    hotel_rows = cur.fetchall()

    room_query = 'select type_name from roomType'
    cur.execute(room_query)
    room_rows = cur.fetchall()

    activity_query = 'select name from activity'
    cur.execute(activity_query)
    activity_rows = cur.fetchall()


    cur.close()
    con.close()

    for r in hotel_rows:
        hotel_list.append(r['name'])

    for r in room_rows:
        room_types.append(r['type_name'])

    for r in activity_rows:
        activity_list.append(r['name'])

   
    first_name_label = tk.Label(customer_dashboard_screen, text='First Name')
    first_name_label.place(x=70, y=100)
    first_name_entry = tk.Entry(customer_dashboard_screen, textvariable=first_name)
    first_name_entry.place(x = 180, y=100)

    last_name_label = tk.Label(customer_dashboard_screen, text='Last Name')
    last_name_label.place(x=70, y=175)
    last_name_entry = tk.Entry(customer_dashboard_screen, textvariable=last_name)
    last_name_entry.place(x = 180, y=175)

    email_label = tk.Label(customer_dashboard_screen, text='Email')
    email_label.place(x=70, y=250)
    email_entry = tk.Entry(customer_dashboard_screen, textvariable=email)
    email_entry.place(x = 180, y=250)

    date_of_birth_label = tk.Label(customer_dashboard_screen, text='Date of Birth')
    date_of_birth_label.place(x=70, y=325)
    date_of_birth_entry = tk.Entry(customer_dashboard_screen, textvariable=date_of_birth)
    date_of_birth_entry.place(x = 180, y=325)

    hotel_name_label = tk.Label(customer_dashboard_screen, text='Hotel Name')
    hotel_name_label.place(x=70, y=400)
    hotel_name_entry = tk.OptionMenu(customer_dashboard_screen, hotel_name, *hotel_list)
    hotel_name.set(hotel_list[0])
    hotel_name_entry.place(x = 180, y=400)

    phone_label = tk.Label(customer_dashboard_screen, text='Phone')
    phone_label.place(x=70, y=475)
    phone_entry = tk.Entry(customer_dashboard_screen, textvariable=phone)
    phone_entry.place(x = 180, y=475)

    checkin_date_label = tk.Label(customer_dashboard_screen, text='Check-in Date')
    checkin_date_label.place(x=360, y=100)
    checkin_date_entry = tk.Entry(customer_dashboard_screen, textvariable=check_in_date)
    checkin_date_entry.place(x = 480, y=100)

    checkout_date_id_label = tk.Label(customer_dashboard_screen, text='Check-out Date')
    checkout_date_id_label.place(x=360, y=175)
    checkout_date_id_entry = tk.Entry(customer_dashboard_screen, textvariable=check_out_date)
    checkout_date_id_entry.place(x = 480, y=175)

    room_type_label = tk.Label(customer_dashboard_screen, text='Room Type')
    room_type_label.place(x=360, y=250)
    room_type_entry = tk.OptionMenu(customer_dashboard_screen, room_type, *room_types)
    room_type.set(room_types[0])
    room_type_entry.place(x = 480, y=250)

    activity_label = tk.Label(customer_dashboard_screen, text='Activity')
    activity_label.place(x=360, y=325)
    activity_entry = tk.OptionMenu(customer_dashboard_screen, activity, *activity_list)
    activity.set(activity_list[0])
    activity_entry.place(x = 480, y=325)

    guest_count_label = tk.Label(customer_dashboard_screen, text='Guest Count')
    guest_count_label.place(x=360, y=400)
    guest_count_entry = tk.Entry(customer_dashboard_screen, textvariable=num_guests)
    guest_count_entry.place(x = 480, y=400)

    activity_date_label = tk.Label(customer_dashboard_screen, text='Activity Date')
    activity_date_label.place(x=360, y=475)
    activity_date_entry = tk.Entry(customer_dashboard_screen, textvariable=activity_date)
    activity_date_entry.place(x = 480, y=475)

    reserve_hotel_button = tk.Button(customer_dashboard_screen, text='Reserve Hotel', width=12, height=1,bg='grey', command=reserve_hotel)
    reserve_hotel_button.place(x=350,y=650)

    

    w = customer_dashboard_screen.winfo_reqwidth()
    h = customer_dashboard_screen.winfo_reqheight()
    ws = customer_dashboard_screen.winfo_screenwidth()
    hs = customer_dashboard_screen.winfo_screenheight()
    x = (ws/2) - (w/2) - 100
    y = (hs/2) - (h/2) - 100 
    customer_dashboard_screen.geometry('+%d+%d' % (x, y))
    customer_dashboard_screen.mainloop()

def reserve_hotel():
    first_name_data = first_name.get()
    last_name_data = last_name.get()
    email_data = email.get()
    date_of_birth_data = date_of_birth.get()
    phone_data = phone.get()
    hotel_name_data = hotel_name.get()
    check_in_date_data = check_in_date.get()
    check_out_date_data = check_out_date.get()
    room_type_data = room_type.get()
    activity_data = activity.get()
    activity_date_data = activity_date.get()
    num_guests_data = num_guests.get()

    try:

        mysql_creds = config.get_mysql_creds()
        conObj = connection.Connect(mysql_creds)
        con = conObj.make_connection()
        cur = con.cursor()
        cur.callproc("AddCustomer", (first_name_data, last_name_data, email_data, phone_data, date_of_birth_data,))
        con.commit()

        get_last_query = "SELECT customer_id FROM customer ORDER BY customer_id DESC LIMIT 1"
        cur.execute(get_last_query)
        rows = cur.fetchall()
        cust_id = rows[0]['customer_id']
        

        hotel_id_query = "select hotel_id from hotel where name=%s"
        cur.execute(hotel_id_query, hotel_name_data)
        rows = cur.fetchall()
        htel_id = rows[0]['hotel_id']
        


        insert_reservation_query = "insert into `reservation` (`hotel_id`, `customer_id`, `checkin_date`, `checkout_date`, `total_price`, `guest_count`) values (%s,%s,%s,%s,%s,%s)"
        cur.execute(insert_reservation_query, (htel_id, cust_id, check_in_date_data, check_out_date_data, 500, num_guests_data,))
        con.commit()

        get_resv_id = "SELECT reservation_id FROM reservation ORDER BY reservation_id DESC LIMIT 1"
        cur.execute(get_resv_id)
        rows = cur.fetchall()
        resv_id = rows[0]['reservation_id']

        rm_id_query = 'select rm.room_id from room rm inner join roomType rt on rt.room_type_id = rm.room_type_id where rt.type_name = %s limit 1'
        cur.execute(rm_id_query, room_type_data)
        rows = cur.fetchall()
        rm_id = rows[0]['room_id']


        insert_reservation_detail_query = "insert into `reservationDetails` (`reservation_id`, `room_id`, `guest_count`) values (%s,%s,%s)"
        cur.execute(insert_reservation_detail_query, (resv_id, rm_id, num_guests_data))
        con.commit()

        activity_id_query = "select activity_id from activity where name=%s"
        cur.execute(activity_id_query, activity_data)
        rows = cur.fetchall()
        act_id = rows[0]['activity_id']

        insert_activity_booking_query = "insert into `activityBooking` (`activity_id`, `customer_id`, `date`) values (%s,%s,%s)"
        cur.execute(insert_activity_booking_query, (act_id, cust_id, activity_date_data))
        con.commit()
        cur.close()
        con.close()

    except pymysql.err.OperationalError as e:
        print('Error is: '+ str(e))

    messagebox.showinfo(title='Confirmation', message='Customer ID: '+str(cust_id)+'\n'+ 'Reservation ID: '+str(resv_id))
    first_name.set('')
    last_name.set('')
    email.set('')
    date_of_birth.set('')
    phone.set('')
    hotel_name.set('The Golden Gate Hotel')
    check_in_date.set('')
    check_out_date.set('')
    room_type.set('Standard')
    activity.set('')
    activity_date.set('')
    num_guests.set('')


def get_reservation_screen():
    global lookup_reservation_screen
    lookup_reservation_screen = tk.Toplevel(customer_dashboard_screen)
    lookup_reservation_screen.geometry('400x200')
    lookup_reservation_screen.title('Get Reservation')
    global resv_id 
    resv_id = tk.IntVar()

    lookup_c_id_label = tk.Label(lookup_reservation_screen, text='Candidate Id')
    lookup_c_id_label.place(x=40, y=30)
    lookup_c_id_entry = tk.Entry(lookup_reservation_screen, textvariable=resv_id)
    lookup_c_id_entry.place(x = 140, y=30)

    lookup_candidate_button = tk.Button(lookup_reservation_screen, text='Get', width=10, height=1,bg='grey', command=get_reservation)
    lookup_candidate_button.place(x=150,y=150)

    w =lookup_reservation_screen.winfo_reqwidth()
    h =lookup_reservation_screen.winfo_reqheight()
    ws=lookup_reservation_screen.winfo_screenwidth()
    hs =lookup_reservation_screen.winfo_screenheight()
    x = (ws/2) - (w/2) - 100
    y = (hs/2) - (h/2) - 100 
    lookup_reservation_screen.geometry('+%d+%d' % (x, y))
    lookup_reservation_screen.mainloop()

def get_reservation_helper():
    resv_id_data = resv_id.get()
    global f_name
    global l_name
    global h_name
    global hotel_address
    global rm_type
    global rm_num
    global chkindate
    global chkoutdate
    flag = ''

    f_name = tk.StringVar()
    l_name = tk.StringVar()
    h_name = tk.StringVar()
    hotel_address = tk.StringVar()
    rm_type = tk.StringVar()
    rm_num = tk.IntVar()
    chkindate = tk.StringVar()
    chkoutdate = tk.StringVar()

    try:
        mysql_creds = config.get_mysql_creds()
        conObj = connection.Connect(mysql_creds)
        con = conObj.make_connection()
        cur = con.cursor()
        cur.callproc("GetCustomerReservationDetails", (resv_id_data,))
        rows = cur.fetchall()
        if not rows:
            messagebox.showinfo(title='Conflict', message='Reservation Not found')
            flag = 'Fail'
        else:
            flag = 'Pass'
            f_name.set(rows[0]['first_name'])
            l_name.set(rows[0]['last_name'])
            h_name.set(rows[0]['hotel_name'])
            hotel_address.set(rows[0]['hotel_address'])
            rm_type.set(rows[0]['room_type'])
            rm_num.set(rows[0]['room_number'])
            chkindate.set(rows[0]['checkin_date'])
            chkoutdate.set(rows[0]['checkout_date'])

    except pymysql.err.OperationalError as e:
        print('Error is: '+ str(e))
    return flag

def get_reservation():
    lookup_reservation_screen.destroy()
    result = get_reservation_helper()

    if result == 'Pass':

        global lookup_result_screen
        lookup_result_screen = tk.Toplevel(customer_dashboard_screen)
        lookup_result_screen.geometry('800x500')
        lookup_result_screen.title('Lookup Reservation')


        f_name_label = tk.Label(lookup_result_screen, text='First Name')
        f_name_label.place(x=70, y=100)
        f_name_entry = tk.Entry(lookup_result_screen, textvariable=f_name)
        f_name_entry.place(x = 180, y=100)

        l_name_label = tk.Label(lookup_result_screen, text='Last Name')
        l_name_label.place(x=70, y=175)
        l_name_entry = tk.Entry(lookup_result_screen, textvariable=l_name)
        l_name_entry.place(x = 180, y=175)

        h_name_label = tk.Label(lookup_result_screen, text='Hotel Name')
        h_name_label.place(x=70, y=250)
        h_name_entry = tk.Entry(lookup_result_screen, textvariable=h_name)
        h_name_entry.place(x = 180, y=250)

        hotel_address_label = tk.Label(lookup_result_screen, text='Hotel Address')
        hotel_address_label.place(x=70, y=325)
        hotel_address_entry = tk.Entry(lookup_result_screen, textvariable=hotel_address)
        hotel_address_entry.place(x = 180, y=325)

        rm_type_label = tk.Label(lookup_result_screen, text='Room Type')
        rm_type_label.place(x=360, y=100)
        rm_type_entry = tk.Entry(lookup_result_screen, textvariable=rm_type)
        rm_type_entry.place(x = 480, y=100)

        rm_num_label = tk.Label(lookup_result_screen, text='Room Number')
        rm_num_label.place(x=360, y=175)
        rm_num_entry = tk.Entry(lookup_result_screen, textvariable=rm_num)
        rm_num_entry.place(x = 480, y=175)

        chkindate_label = tk.Label(lookup_result_screen, text='Checkin Date')
        chkindate_label.place(x=360, y=250)
        chkindate_entry = tk.Entry(lookup_result_screen, textvariable=chkindate)
        chkindate_entry.place(x = 480, y=250)

        chkoutdate_label = tk.Label(lookup_result_screen, text='Checkout Date')
        chkoutdate_label.place(x=360, y=325)
        chkoutdate_entry = tk.Entry(lookup_result_screen, textvariable=chkoutdate)
        chkoutdate_entry.place(x = 480, y=325)


        w =lookup_result_screen.winfo_reqwidth()
        h =lookup_result_screen.winfo_reqheight()
        ws=lookup_result_screen.winfo_screenwidth()
        hs =lookup_result_screen.winfo_screenheight()
        x = (ws/2) - (w/2) - 100
        y = (hs/2) - (h/2) - 100 
        lookup_result_screen.geometry('+%d+%d' % (x, y))
        lookup_result_screen.mainloop()

def get_account_screen():
    pass

def update_account_screen():
    # TODO 
    pass

def delete_account_prompt():
    # TODO 
    pass

def update_reservation_screen():
    # TODO 
    pass

def delete_reservation_prompt():
    global delete_reservation_screen
    delete_reservation_screen = tk.Toplevel(customer_dashboard_screen)
    delete_reservation_screen.geometry('400x200')
    delete_reservation_screen.title('Delete Reservation')
    global del_resv_id
    del_resv_id = tk.IntVar()

    del_resv_id_label = tk.Label(delete_reservation_screen, text='Reservation Id')
    del_resv_id_label.place(x=40, y=30)
    del_resv_id_entry = tk.Entry(delete_reservation_screen, textvariable=del_resv_id)
    del_resv_id_entry.place(x = 140, y=30)

    delete_reservation_button = tk.Button(delete_reservation_screen, text='Delete', width=10, height=1,bg='grey', command=delete_reservation)
    delete_reservation_button.place(x=150,y=150)

    w =delete_reservation_screen.winfo_reqwidth()
    h =delete_reservation_screen.winfo_reqheight()
    ws=delete_reservation_screen.winfo_screenwidth()
    hs =delete_reservation_screen.winfo_screenheight()
    x = (ws/2) - (w/2) - 100
    y = (hs/2) - (h/2) - 100 
    delete_reservation_screen.geometry('+%d+%d' % (x, y))
    delete_reservation_screen.mainloop()

def delete_reservation():
    del_resv_id_data = del_resv_id.get()
    try:
        mysql_creds = config.get_mysql_creds()
        conObj = connection.Connect(mysql_creds)
        con = conObj.make_connection()
        cur = con.cursor()
        delete_query = 'delete from reservation where reservation_id=%s'
        cur.execute(delete_query,del_resv_id_data)
        con.commit()
        cur.close()
        con.close()
        messagebox.showinfo(title='Confirmation', message='Reservation Deleted Successfully')
    except pymysql.err.OperationalError as e:
        print('Error is: ')
    
    del_resv_id.set(0)
    delete_reservation_screen.destroy()

def add_review_screen_launch():
    # TODO 
    pass

def payment_screen_launch():
    # TODO
    pass

def kill_customer_dashboard():
    customer_dashboard_screen.destroy()