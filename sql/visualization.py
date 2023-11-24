#!/usr/bin/env python
# coding: utf-8

# In[6]:


import mysql.connector
import matplotlib.pyplot as plt

host = input("host? ")
user = input("username ?")
password = input("Password ?")
database = input("Schema name ?")

#connection to the MySQL server
connection = mysql.connector.connect(
    host=host,
    user=user,
    password=password,
    database=database
)

cursor = connection.cursor()


cursor.execute("SELECT * FROM highestRatedHotels")
result_hotels = cursor.fetchall()

cursor.execute("SELECT * FROM mostBookedActivities")
result_activities = cursor.fetchall()


hotel_names = [row[0] for row in result_hotels]
average_ratings = [row[1] for row in result_hotels]

activity_names = [row[0] for row in result_activities]
times_booked = [row[1] for row in result_activities]

plt.figure(figsize=(12, 6))

# Plot for highest rated hotels
plt.subplot(1, 2, 1)
plt.barh(hotel_names, average_ratings, color='skyblue')
plt.xlabel('Average Rating')
plt.title('Highest Rated Hotels')

# Plot for most booked activities
plt.subplot(1, 2, 2)
plt.barh(activity_names, times_booked, color='lightcoral')
plt.xlabel('Times Booked')
plt.title('Most Booked Activities')

plt.tight_layout()
plt.show()
cursor.close()
connection.close()


# In[ ]:




