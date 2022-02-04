import tensorflow as tf
from PIL import  Image
import numpy as np
from flask import Flask,jsonify,request
import werkzeug
import os



app = Flask(__name__)


newsize = (299,299)
value_lookup = {
    0 : 'No DR',
    1 : 'Mild',
    2 : 'Moderate',
    3 : 'Severe',
    4 : 'Proliferative DR'
}

@app.route('/upload',methods = ['POST'])
def upload():
    if(request.method == 'POST'):
        imagefile = request.files['image']
        filename = werkzeug.utils.secure_filename(imagefile.filename)
        imagefile.save('uploadedimages/'+filename)
        s = os.listdir("./uploadedimages")
        file_ = "./uploadedimages/" + s[0]
        test_single = Image.open(file_)
        test_single = test_single.resize(newsize)
        test_single = np.asarray(test_single)
        test_single = test_single* (1. / 255)
        test_single = test_single.reshape(1,299, 299, 3)
        Xmodel = tf.keras.models.load_model('./work.h5')
        pred = Xmodel.predict(test_single)
        result = np.argmax(pred)
        os.remove(file_)
        os.remove("./flk/detect.jpg")
        return jsonify({'result':result})

if __name__ == "__main__":
    app.run(port=4000,debug=True,host="0.0.0.0")