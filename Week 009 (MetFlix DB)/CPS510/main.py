import oracledb
from flask import Flask, render_template, redirect, url_for, request, session
from flask_session import Session
from flask_bootstrap import Bootstrap5
import os
from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField
from wtforms.validators import DataRequired
import requests

USERNAME = os.environ['USERNAME']
PASSWORD = os.environ['PASSWORD']

API_KEY = "1da3cf985092bd6072ac2c523c02b371"
TMDB_URL = "https://api.themoviedb.org/3/search/movie"

try:
    connection = oracledb.connect(
        user=USERNAME,
        password=PASSWORD,
        dsn="(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle12c.scs.ryerson.ca)(Port=1521))(CONNECT_DATA=(SID=orcl12c)))"
    )
    # print("Successfully connected to Oracle Database")
    cursor = connection.cursor()

    actor_db_list = [row for row in cursor.execute("SELECT * FROM actor")]
    customer_db_list = [row for row in cursor.execute("SELECT * FROM customer")]
    membership_db_list = [row for row in cursor.execute("SELECT * FROM membership")]
    admin_db_list = [row for row in cursor.execute("SELECT * FROM admin")]
    payment_db_list = [row for row in cursor.execute('SELECT * FROM payment')]
    movie_db_list = [row for row in cursor.execute("SELECT * FROM movie")]
    account_db_list = [row for row in cursor.execute("SELECT * FROM account")]

    # cursor.execute("SELECT table_name FROM user_tables") THIS IS THE FORMAT

    # Close cursor and connection
    # (keep things open for now)
    # cursor.close()
    # connection.close()

except oracledb.DatabaseError as e:
    print(f"Error: {str(e)}")

app = Flask(__name__)
app.config['SECRET_KEY'] = '8BYkEfBA6O6donzWlSihBXox7C0sKR6b'
Bootstrap5(app)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)


## TIME to start puttingin the UI

@app.route('/',methods=['GET','POST'])
def sign_in():
    session.clear()
    if request.method =='POST':
        USERNAME = request.form['username']
        PASSWORD = request.form['password']

        cursor.execute("SELECT * FROM account WHERE username=:1 AND password=:2", (USERNAME, PASSWORD))
        verify = cursor.fetchall()
        if verify:
            if cursor.execute("SELECT * FROM admin WHERE adminID=:1", [verify[0][0]]).fetchall():
                session['admin'] = True
            return redirect('home')


        for account in account_db_list:
            if account[1] == USERNAME and account[2] == PASSWORD:
                return redirect('home')

    return render_template('loginpage.html',account_db_list=account_db_list)

@app.route('/home')
def edit():
    return render_template('home.html',movie_db_list=movie_db_list)

@app.route('/movie/<int:movieID>')
def movie(movieID):
    actor_query = """
    SELECT actorfirstname, actorlastname, actorimage FROM actor a
    JOIN movie_actor ma ON a.actorID= ma.actorID
    JOIN movie m ON m.movieID = ma.movieID
    WHERE m.movieID = :1
    """
    director_query = """
    SELECT d.directorFirstName, d.directorLastName
    FROM movie m
    JOIN movie_director md ON m.movieID = md.movieID
    JOIN director d ON d.directorID = md.directorID
    WHERE md.movieID = :1
    """
    genre_query = """
    SELECT g.genreName
    FROM genre g
    JOIN movie_genre mg ON g.genreID = mg.genreID
    WHERE mg.movieID = :1
    """

    cursor.execute("SELECT * FROM movie WHERE movieID=:1", [movieID])
    movie_info = cursor.fetchall()
    cursor.execute(actor_query, [movie_info[0][0]])
    actor_info = cursor.fetchall()
    cursor.execute(director_query, [movie_info[0][0]])
    director_info = cursor.fetchall()
    cursor.execute(genre_query, [movie_info[0][0]])
    genre_info = cursor.fetchall()

    print (movie_info[0])
    return render_template('movie.html', movie_info=movie_info[0], actors=actor_info, directors=director_info, genres=genre_info)
    # return render_template('movie.html')

#TODO create update.html --> page with forms to update a movie
@app.route('/update/<int:movieID>', methods=['GET', 'POST'])
def update(movieID):
    if request.method == 'POST':
        title = request.form['title']
        description = request.form['description']
        poster = request.form['poster']
        rating = request.form['rating']
        year = request.form['year']

        # potentially blank forms means individual if checks are needed
        if title:
            cursor.execute("UPDATE movie SET movieName = :1 WHERE movieID = :2", [title, movieID])
        if description:
            cursor.execute("UPDATE movie SET movieDescription = :1 WHERE movieID = :2", [description, movieID])
        if poster:
            cursor.execute("UPDATE movie SET moviePoster = :1 WHERE movieID = :2", [poster, movieID])
        if rating:
            cursor.execute("UPDATE movie SET movieRating = :1 WHERE movieID = :2", [rating, movieID])
        if year:
            cursor.execute("UPDATE movie SET movieRating = :1 WHERE movieID = :2", [year, movieID])
        return render_template(f'/movie/{movieID}')
    else:
        render_template(f'/update/{movieID}')

#TODO create delete.html --> confirmation page for deletion
@app.route('/delete/<int:movieID>', methods=['GET', 'POST'])
def delete(movieID):
    if request.method == 'POST':
        # Delete related entries in foreign key tables first
        cursor.execute("DELETE FROM movie_actor WHERE movieID = :1", [movieID])
        cursor.execute("DELETE FROM movie_director WHERE movieID = :1", [movieID])
        cursor.execute("DELETE FROM movie_genre WHERE movieID = :1", [movieID])

        # Delete the movie from the main table
        cursor.execute("DELETE FROM movie WHERE movieID = :1", [movieID])
        connection.commit()

        # Refresh the movie list after deletion
        global movie_db_list
        movie_db_list = [row for row in cursor.execute("SELECT * FROM movie")]

        return redirect('/home')
    else:
        cursor.execute("SELECT movieName FROM movie WHERE movieID = :1", [movieID])
        movie_title = cursor.fetchone()[0]
        return render_template('delete.html', movie_title=movie_title, movieID=movieID)


#TODO make add.html
@app.route('/add', methods=['GET', 'POST'])
def add():
    if request.method == 'POST':
        title = request.form['title']
        poster = request.form['poster']
        description = request.form['description']
        rating = request.form['rating']
        year = request.form['year']

        add_query = """
            INSERT INTO movie (movieName, moviePoster, movieDescription, movieRating, movieYear) 
            VALUES (:1, :2, :3, :4, :5)
        """
        cursor.execute(add_query, [title, poster, description, rating, year])
        connection.commit()
        return redirect('/home')
    return render_template('add.html')

@app.route('/search', methods=['POST'])
def search():
    search_query = request.form['search_query'].strip().lower()

    # Filter movies based on the search query
    filtered_movies = [
        movie for movie in movie_db_list
        if search_query in movie[1].lower()  # Check if the search query is in the movie title
    ]

    return render_template('home.html', movie_db_list=filtered_movies)







if __name__ == '__main__':
    app.run(debug=True)
