from flask import Flask, render_template, request

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def home():
  if request.method == 'POST':
    number1 = request.form.get('number1')
    number2 = request.form.get('number2')
    sum = int(number1) + int(number2)
    return render_template('index.html', sum=sum)
  return render_template('index.html')

@app.route('/about')
def about():
  return render_template('about.html')

if __name__ == '__main__':
  app.run(debug=True)