from PIL import Image
import torch
from torchvision import transforms
import io
import pandas as pd
import numpy as np


# Görüntüyü dönüştür
def preprocess_image(image_bytes):
    image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
    transform = transforms.Compose([
        transforms.Resize((224, 224)),
        transforms.ToTensor(),
        transforms.Normalize([0.5, 0.5, 0.5], [0.5, 0.5, 0.5])
    ])
    return transform(image).unsqueeze(0)  # (1, C, H, W)

def preprocess_metadata_csv(csv_file):
    # CSV'yi oku
    df = pd.read_csv(csv_file)

    # Kullanılacak sütunlar
    selected_cols = ['assessment', 'subtlety', 'breast_density']

    # Eksik sütunları sıfırla (eğer başlık yanlış yazılmışsa hata almayalım)
    for col in selected_cols:
        if col not in df.columns:
            df[col] = 0

    # Sadece bu 3 sütunu al
    df = df[selected_cols]

    # Sayıya dönüştür, NaN'leri sıfırla
    df = df.apply(pd.to_numeric, errors='coerce').fillna(0)

    # Torch tensöre dönüştür
    return torch.tensor(df.to_numpy(dtype=np.float32))