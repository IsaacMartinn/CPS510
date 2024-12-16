import oracledb
import os

USERNAME = os.environ['USERNAME']
PASSWORD = os.environ['PASSWORD']


try:
    connection = oracledb.connect(
        user=USERNAME,
        password=PASSWORD,
        dsn="(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle12c.scs.ryerson.ca)(Port=1521))(CONNECT_DATA=(SID=orcl12c)))"
    )
    # print("Successfully connected to Oracle Database")
    cursor = connection.cursor()

    movie_db_list = [row for row in cursor.execute("SELECT * FROM account")]


    print(movie_db_list[0])
    username= movie_db_list[0][1]
    password= movie_db_list[0][2]




    # cursor.execute("SELECT table_name FROM user_tables") THIS IS THE FORMAT

    # Close cursor and connection
    cursor.close()
    connection.close()

except oracledb.DatabaseError as e:
    print(f"Error: {str(e)}")