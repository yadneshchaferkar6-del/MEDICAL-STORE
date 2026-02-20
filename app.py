from flask import Flask, render_template, request, redirect, session
import sqlite3

app = Flask(__name__)
app.secret_key = "secret123"

# ---------- DATABASE SETUP ----------
def init_db():
    conn = sqlite3.connect("database.db")
    cur = conn.cursor()

    cur.execute("""
    CREATE TABLE IF NOT EXISTS users(
        id INTEGER PRIMARY KEY,
        username TEXT,
        password TEXT
    )
    """)

    cur.execute("""
    CREATE TABLE IF NOT EXISTS medicines(
        id INTEGER PRIMARY KEY,
        name TEXT,
        price INTEGER
    )
    """)

    cur.execute("""
    CREATE TABLE IF NOT EXISTS cart(
        id INTEGER PRIMARY KEY,
        name TEXT,
        price INTEGER
    )
    """)

    # Insert sample user
    cur.execute("DELETE FROM users")
    cur.execute("INSERT INTO users(username,password) VALUES('admin','1234')")

    # Insert medicines
    cur.execute("DELETE FROM medicines")
    cur.executemany("INSERT INTO medicines(name,price) VALUES (?,?)",[
        ("Paracetamol",20),
        ("Cough Syrup",75),
        ("Vitamin C",50),
        ("Antibiotic",120)
    ])

    conn.commit()
    conn.close()

init_db()


# ---------- LOGIN ----------
@app.route("/login", methods=["GET","POST"])
def login():
    if request.method == "POST":
        user = request.form["username"]
        pwd = request.form["password"]

        conn = sqlite3.connect("database.db")
        cur = conn.cursor()
        cur.execute("SELECT * FROM users WHERE username=? AND password=?", (user,pwd))
        result = cur.fetchone()
        conn.close()

        if result:
            session["user"] = user
            return redirect("/")
        else:
            return "Invalid Login"

    return render_template("login.html")


# ---------- LOGOUT ----------
@app.route("/logout")
def logout():
    session.pop("user", None)
    return redirect("/login")


# ---------- HOME ----------
@app.route("/")
def home():
    if "user" not in session:
        return redirect("/login")

    conn = sqlite3.connect("database.db")
    cur = conn.cursor()
    cur.execute("SELECT * FROM medicines")
    meds = cur.fetchall()
    conn.close()

    return render_template("index.html", meds=meds, user=session["user"])


# ---------- ADD TO CART ----------
@app.route("/add/<name>/<int:price>")
def add(name, price):
    conn = sqlite3.connect("database.db")
    cur = conn.cursor()
    cur.execute("INSERT INTO cart(name,price) VALUES (?,?)",(name,price))
    conn.commit()
    conn.close()
    return redirect("/")


# ---------- CART + TOTAL ----------
@app.route("/cart")
def cart():
    conn = sqlite3.connect("database.db")
    cur = conn.cursor()
    cur.execute("SELECT * FROM cart")
    items = cur.fetchall()

    total = sum([i[2] for i in items])

    conn.close()
    return render_template("cart.html", items=items, total=total)


if __name__ == "__main__":
    app.run(debug=True)