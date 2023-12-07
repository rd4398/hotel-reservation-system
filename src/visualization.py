'''
This file contains python script to generate the bar graphs as part of the data analysis
for the hotel reservation system. It uses the SQL views to plot the graphs. 
'''
# Import the required libraries like matplotlib
import pymysql
import matplotlib.pyplot as plt
import config
import connection

def get_analysis():
    '''
    Connect to MySQL, get the data required for the plots
    '''
    try:
        mysql_creds = config.get_mysql_creds()
        conObj = connection.Connect(mysql_creds)
        con = conObj.make_connection()
        cursor = con.cursor()
        cursor.execute("SELECT * FROM highestRatedHotels")
        result_hotels = cursor.fetchall()
        cursor.execute("SELECT * FROM mostBookedActivities")
        result_activities = cursor.fetchall()

        hotel_names = [row['hotel_name'] for row in result_hotels]
        average_ratings = [row['average_rating'] for row in result_hotels]

        activity_names = [row['activity_name'] for row in result_activities]
        times_booked = [row['times_booked'] for row in result_activities]

        # Plot the figure for highest rated hotels

        plt.figure(figsize=(12, 6))

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
        con.close()

    except pymysql.err.OperationalError as e:
        print('Error is: ' + str(e))
