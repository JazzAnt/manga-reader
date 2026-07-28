from PIL import Image
import io
from manga_ocr import MangaOcr

manga_ocr = MangaOcr()

def recognize_text(image_bytes : bytes) -> str:
    image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
    recognized_text = manga_ocr(image)
    return recognized_text