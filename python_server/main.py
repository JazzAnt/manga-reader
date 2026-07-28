from fastapi import FastAPI, File, UploadFile
from services.ocr_service import recognize_text

app = FastAPI()

@app.get("/")
def root():
    return {"message": "Hello World"}

@app.post("/ocr")
async def ocr(
        image: UploadFile = File(...),
):
    image_bytes = await image.read()
    recognized_text = recognize_text(image_bytes)

    return {
        "text": recognized_text,
    }
