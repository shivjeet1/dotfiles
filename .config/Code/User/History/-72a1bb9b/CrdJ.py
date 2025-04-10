import sys
import cv2
import easyocr
import numpy as np
from PyQt6.QtWidgets import QApplication, QLabel, QPushButton, QFileDialog, QTextEdit, QVBoxLayout, QWidget, QComboBox
from PyQt6.QtGui import QPixmap
from PyQt6.QtCore import Qt
from docx import Document
from fpdf import FPDF
from PIL import Image

reader = easyocr.Reader(['en'], gpu=True)

def preprocess_image(image_path):
    image = cv2.imread(image_path)
    if image is None:
        return None
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    blurred = cv2.GaussianBlur(gray, (5, 5), 0)
    adaptive_thresh = cv2.adaptiveThreshold(blurred, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 11, 2)
    kernel = np.ones((2, 2), np.uint8)
    morph = cv2.morphologyEx(adaptive_thresh, cv2.MORPH_CLOSE, kernel)
    return morph

def extract_text(image_path):
    processed_image = preprocess_image(image_path)
    if processed_image is None:
        return "Error: Could not process image."
    pil_image = Image.fromarray(processed_image)
    results = reader.readtext(np.array(pil_image), detail=1, text_threshold=0.7, low_text=0.4, canvas_size=800, batch_size=2)
    filtered_text = [text for _, text, conf in results if conf >= 0.7]
    return "\n".join(filtered_text) if filtered_text else "No text detected."

class OCRApp(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("OCR Tool - EasyOCR (Optimized)")
        self.setGeometry(100, 100, 800, 600)
        self.setStyleSheet("background-color: #2b2b2b; color: #ffffff;")
        self.layout = QVBoxLayout()
        self.image_label = QLabel("Drop an image or select one")
        self.image_label.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.image_label.setStyleSheet("border: 2px dashed #ffffff; padding: 10px;")
        self.layout.addWidget(self.image_label)
        self.select_button = QPushButton("Select Image")
        self.select_button.setStyleSheet("background-color: #444; padding: 8px;")
        self.select_button.clicked.connect(self.load_image)
        self.layout.addWidget(self.select_button)
        self.ocr_result = QTextEdit()
        self.ocr_result.setReadOnly(True)
        self.ocr_result.setStyleSheet("background-color: #1e1e1e; color: #ffffff;")
        self.layout.addWidget(self.ocr_result)
        self.format_selector = QComboBox()
        self.format_selector.addItems(["txt", "docx", "pdf"])
        self.format_selector.setStyleSheet("background-color: #444; padding: 5px; color: white;")
        self.layout.addWidget(self.format_selector)
        self.save_button = QPushButton("Save Text")
        self.save_button.setStyleSheet("background-color: #555; padding: 8px;")
        self.save_button.clicked.connect(self.save_text)
        self.layout.addWidget(self.save_button)
        self.close_button = QPushButton("Close Application")
        self.close_button.setStyleSheet("background-color: #aa4444; padding: 8px;")
        self.close_button.clicked.connect(self.close_application)
        self.layout.addWidget(self.close_button)
        self.setAcceptDrops(True)
        self.setLayout(self.layout)
    
    def dragEnterEvent(self, event):
        if event.mimeData().hasUrls():
            event.acceptProposedAction()
    
    def dropEvent(self, event):
        file_path = event.mimeData().urls()[0].toLocalFile()
        self.process_image(file_path)
    
    def load_image(self):
        file_path, _ = QFileDialog.getOpenFileName(self, "Select Image", "", "Images (*.png *.jpg *.jpeg)")
        if file_path:
            self.process_image(file_path)
    
    def process_image(self, file_path):
        pixmap = QPixmap(file_path)
        if not pixmap.isNull():
            self.image_label.setPixmap(pixmap.scaled(400, 300, Qt.AspectRatioMode.KeepAspectRatio))
            self.image_label.setText("")
        text = extract_text(file_path)
        if text.strip() and "Error" not in text:
            self.ocr_result.setText(text)
        else:
            self.ocr_result.setText("No text detected or processing error.")
    
    def save_text(self):
        file_format = self.format_selector.currentText()
        file_path, _ = QFileDialog.getSaveFileName(self, "Save File", "", f"*.{file_format}")
        if file_path:
            text = self.ocr_result.toPlainText()
            if text.strip():
                if file_format == "txt":
                    with open(file_path, "w", encoding="utf-8") as file:
                        file.write(text)
                elif file_format == "docx":
                    doc = Document()
                    doc.add_paragraph(text)
                    doc.save(file_path)
                elif file_format == "pdf":
                    pdf = FPDF()
                    pdf.add_page()
                    pdf.set_auto_page_break(auto=True, margin=15)
                    try:
                        pdf.add_font("DejaVu", "", "/usr/share/fonts/TTF/DejaVuSans.ttf", uni=True)
                    except RuntimeError:
                        pdf.set_font("Arial", size=14)
                    else:
                        pdf.set_font("DejaVu", size=14)
                    pdf.multi_cell(0, 10, text)
                    pdf.output(file_path)
    
    def close_application(self):
        QApplication.instance().quit()

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = OCRApp()
    window.show()
    sys.exit(app.exec())
