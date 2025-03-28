import cv2
import numpy as np
from PIL import Image

def preprocess_image(image_path):
    try:
        # Load the image using PIL and convert to a NumPy array
        image = Image.open(image_path)
        image = np.array(image)
        
        # Convert the image to grayscale
        gray = cv2.cvtColor(image, cv2.COLOR_RGB2GRAY)
        
        # Apply CLAHE to enhance the contrast
        clahe = cv2.createCLAHE(clipLimit=3.0, tileGridSize=(8, 8))
        enhanced = clahe.apply(gray)
        
        # Apply adaptive thresholding to binarize the image
        adaptive_thresh = cv2.adaptiveThreshold(enhanced, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 11, 2)
        
        # Find coordinates of non-zero pixels
        coords = np.column_stack(np.where(adaptive_thresh > 0))
        
        # Calculate the skew angle of the text
        angle = cv2.minAreaRect(coords)[-1]
        if angle < -45:
            angle = -(90 + angle)
        else:
            angle = -angle
        
        # Deskew the image using affine transformation
        (h, w) = adaptive_thresh.shape[:2]
        center = (w // 2, h // 2)
        M = cv2.getRotationMatrix2D(center, angle, 1.0)
        deskewed = cv2.warpAffine(adaptive_thresh, M, (w, h), flags=cv2.INTER_CUBIC, borderMode=cv2.BORDER_REPLICATE)
        
        return deskewed
    except Exception as e:
        print(f"Error processing image: {e}")
        return None