from fastapi import FastAPI, File, UploadFile, HTTPException
from services.ocr_service import recognize_text, ocr_is_ready

app = FastAPI()

@app.get("/health")
def health():
    if not ocr_is_ready():
        raise HTTPException(status_code=503, detail="OCR model not ready")

    return {"ok": True}

@app.post("/ocr")
async def ocr(image: UploadFile = File(...)):
    if not ocr_is_ready():
        raise HTTPException(status_code=503, detail="OCR model not ready")

    # TODO: handle other types of exceptions such as uploading non-image file
    # TODO: or OCR failure, or file too large

    image_bytes = await image.read()
    recognized_text = recognize_text(image_bytes)

    return {
        "text": recognized_text,
    }
