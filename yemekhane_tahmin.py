from flask import Flask, render_template, request
import numpy as np
import joblib

app = Flask(__name__)
model = joblib.load('C:/Python/adaboost_model.pkl')  

@app.route('/')
def home():
    return render_template('form.html')

@app.route('/tahmin', methods=['POST'])
def tahmin():
    try:
        data = request.get_json()

        veri = [
            int(data['kayitli']),
            int(data['mevcut']),
            int(data['izinli']),
            int(data['haftasonu']),
            int(data['dusuk']),
            int(data['yuksek']),
            int(data['tavuk']),
            int(data['et']),
            int(data['ogun']),
            int(data['tatli'])
        ]
    except (ValueError, KeyError, TypeError):
        return {"hata": "Veriler eksik veya hatalı"}, 400

    tahmin = model.predict(np.array([veri]))[0]
    return {"giris_durumu": int(tahmin)}, 200


if __name__ == '__main__':
   app.run(debug=True,host='0.0.0.0',port=5000)