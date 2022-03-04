# -*- coding: utf-8 -*-
"""
Created on Fri Mar  4 13:04:35 2022

@author: Ragaa
"""

from flask import Flask
from flask import jsonify
from flask import request
from PIL import Image
from io import BytesIO
import base64

app = Flask(__name__)

# @app.route('/hello', methods=['GET'])
# def helloWorldFunction():
#     return "Hello World!"

# @app.route('/hello/<string:name>', methods=['GET'])
# def helloNameFunction(name):
#     return "Hello " + name

# @app.route('/hello/<string:name>/<string:address>', methods=['GET'])
# def returnJsonFunction(name, address):
#     return jsonify(
#         {
#             'name': name,
#             'address':address
#         }
#     )

# @app.route('/hello', methods=['POST'])
# def postRequestFunction():
#     return request.json

@app.route('/image', methods=['Post'])
def sendImagePostRequestFunction():
    data = request.json['image']
    try:
        image = Image.open(BytesIO(base64.b64decode(data)))
        return jsonify(
            {
                "status": "Image Opened"
            }
        )
    except:
        return jsonify(
            {
                "status": "Image Error"
            }
        )


        


if __name__ == '__main__':
    app.run(host='192.168.1.9', port=8003)