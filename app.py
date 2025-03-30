from flask import Flask, render_template, request
import os
import subprocess


app = Flask(__name__)


# Ensuring if folder exist or not
os.makedirs("generated_files", exist_ok=True)
os.makedirs("old_version", exist_ok=True)


@app.route('/', methods=['GET' , 'POST'])

def index():

    if request.method == 'POST':
     filename = request.form['filename']
     extension = request.form['extension']
     description = request.form['description']
     #Shell script
     script_path = "./script/smart_code.sh"
     #result = subprocess.run([script_path, filename,extension,descripsion], capture_output=True, text=True)
     #result = subprocess.run([script_path, filename, extension, descripsion], stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
     #result = subprocess.run([script_path, filename, extension, descripsion], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
     #return f"<h2>{result.stdout}</h2>"
     result = subprocess.run(
                [script_path, filename, extension, description], 
                stdout=subprocess.PIPE, 
                stderr=subprocess.PIPE, 
                universal_newlines=True
                )
     output = result.stdout.replace("\n", "<br>")
     error = result.stderr.replace("\n", "<br>")
     #return f"<h2>{result.stdout}</h2><br><h3>{result.stderr}</h3>"
     #return f"<pre>{result.stdout}</pre><br><pre>{result.stderr}</pre>"
     return f"<pre style='font-size:20px;'>{result.stdout}</pre><br><pre style='font-size:20px;'>{result.stderr}</pre>"



    return render_template("index.html")

@app.route('/get_template/<ext>')
def get_template(ext):
    template_path = f"./precode/{ext}"
    if os.path.exists(template_path):
        with open(template_path, "r") as file:
            return file.read()
    return "⚡ No template found for this language."


if __name__ ==  '__main__':
    app.run(debug=True, host="0.0.0.0")



