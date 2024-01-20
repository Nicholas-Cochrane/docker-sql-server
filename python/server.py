import psycopg2
conn = psycopg2.connect(dbname="sensors", user="postgres", password="rozemyne", host="db")
cur = conn.cursor()
cur.execute("SELECT * FROM readings;")
cur.commit()
cur.close()
conn.close()
