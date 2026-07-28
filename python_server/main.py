from fastapi import FastAPI, File, UploadFile

app = FastAPI()

@app.get("/")
def root():
    return {"message": "Hello World"}

@app.post("/ocr")
async def ocr(
        image: UploadFile = File(...),
):
    image_bytes = await image.read()

    return {
        "text": "ろれむいぷしゅむ", # change with OCR later
    }
