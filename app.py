from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)

# Dummy login credentials
USERNAME = "admin"
PASSWORD = "1234"

@app.route("/", methods=["GET","POST"])
def login():
    if request.method == "POST":
        user = request.form["username"]
        pwd = request.form["password"]

        if user == USERNAME and pwd == PASSWORD:
            return redirect(url_for("index"))
        else:
            return render_template("login.html", error="Invalid Login")

    return render_template("login.html")


@app.route("/index", methods=["GET","POST"])
def index():

    medicines = [
        "Paracetamol",
        "Ibuprofen",
        "Amoxicillin",
        "Cetirizine",
        "Metformin",
        "Aspirin",
        "Azithromycin",
        "Vitamin C",
        "Dolo 650",
        "ORS Packet"
    ]

    total = None

    if request.method == "POST":
        total = 0

        for i in range(len(medicines)):
            qty = int(request.form.get(f"qty{i}",0))
            price = float(request.form.get(f"price{i}",0))
            total += qty * price

    return render_template("index.html", medicines=medicines, total=total)


if __name__ == "__main__":
    app.run(debug=True)
