import cx_Oracle
import os

# Set the Oracle Client path using DYLD_LIBRARY_PATH
os.environ["DYLD_LIBRARY_PATH"] = "/Users/isaacmartin/Downloads/instantclient_19_8"

# Initialize Oracle Client
cx_Oracle.init_oracle_client(lib_dir="/Users/isaacmartin/Downloads/instantclient_19_8")

# Database credentials
username = os.environ['USERNAME']
password = os.environ['PASSWORD']

# Establish the connection
try:
    # Use a well-formatted DSN
    dsn = cx_Oracle.makedsn("oracle.scs.ryerson.ca", 1521, sid="orcl")
    connection = cx_Oracle.connect(
        user=username,
        password=password,
        dsn=dsn
    )
    print("Connection successful!")
except cx_Oracle.DatabaseError as e:
    print("There was an error connecting to the database:", e)
finally:
    if 'connection' in locals() and connection:
        connection.close()
        print("Connection closed.")
