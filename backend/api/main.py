from fastapi import FastAPI, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from api.model_loader import load_model
from api.mammography_metadata import preprocess_image, preprocess_metadata_csv
import torch

app = FastAPI()

# CORS ayarları )
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Model
model = load_model("models/best_models/vgg16.pth", device="cpu")
model.eval()

@app.post("/predict")
async def predict(
    image: UploadFile = File(...),
    metadata: UploadFile = File(...)
):
    try:
       
        image_bytes = await image.read()
        image_tensor = preprocess_image(image_bytes)

      
        metadata_tensor = preprocess_metadata_csv(metadata.file)


        with torch.no_grad():
            output = model(image_tensor, metadata_tensor)
            prob = torch.sigmoid(output).item()
            predicted = 1 if prob >= 0.5 else 0
            label = "malignant" if predicted == 1 else "benign"
            confidence = prob

        return {
            "result": predicted,
            "label": label,
            "confidence": confidence
        }

    except Exception as e:
      import traceback
      traceback.print_exc()
      return JSONResponse(status_code=500, content={"error": str(e)})
