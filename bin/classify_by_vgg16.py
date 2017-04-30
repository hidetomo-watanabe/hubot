import sys
import os
import numpy as np
from keras.models import load_model
from keras.applications.vgg16 import VGG16
from keras.applications.vgg16 import preprocess_input
from keras.applications.vgg16 import decode_predictions
from keras.preprocessing import image

if __name__ == '__main__':
    os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
    filename = sys.argv[1]
    """
    model = VGG16(
        include_top=True,
        weights='imagenet',
        input_tensor=None,
        input_shape=None)
    model.save('data/vgg16.h5')
    """
    model = load_model('data/vgg16.h5')
    img = image.load_img(filename, target_size=(224, 224))
    x = image.img_to_array(img)
    x = np.expand_dims(x, axis=0)

    preds = model.predict(preprocess_input(x))
    result = decode_predictions(preds, top=1)[0][0]
    print('%s, %s' % (result[1], result[2]))
    import gc; gc.collect()
