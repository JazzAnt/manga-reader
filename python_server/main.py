from fastapi import FastAPI, File, UploadFile

app = FastAPI()

@app.get("/")
def root():
    return {"message": "Hello World"}

@app.post("/upload")
async def upload(
        image: UploadFile = File(...),
):
    image_bytes = await image.read()

    return {
        "filename": image.filename,
        "content_type": image.content_type,
        "size": len(image_bytes),
    }
