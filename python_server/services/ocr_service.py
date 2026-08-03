from PIL import Image
import io
from manga_ocr import MangaOcr

manga_ocr = None
error_message = "MangaOrc model still loading"

try:
    manga_ocr = MangaOcr()
except Exception as e:
    error_message = str(e)

def ocr_is_ready() -> bool:
    return manga_ocr is not None

def recognize_text(image_bytes : bytes) -> str:
    if manga_ocr is None:
        raise RuntimeError(f"MangaOcr is not loaded: ${error_message}")

    image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
    return manga_ocr(image)