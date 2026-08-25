import os
import pandas as pd
from PIL import Image
from torch.utils.data import Dataset, DataLoader
import torch
from torchvision import transforms

class BreastCancerDataset(Dataset):
    def __init__(self, csv_file, jpeg_root_dir, dicom_info_csv, transform=None, use_metadata=True):
        self.data = pd.read_csv(csv_file)
        self.jpeg_root_dir = jpeg_root_dir
        self.transform = transform
        self.use_metadata = use_metadata
        self.labels = self.data["label"].values.astype("float32")
        self.dicom_info = pd.read_csv(dicom_info_csv)

        self.image_uids = self.data["image file path"].apply(self.extract_uid).tolist()
        self.image_paths = self.map_uids_to_jpeg_paths(self.image_uids, image_type="full mammogram images")

        if self.use_metadata:
            drop_cols = ["image file path", "label"]
            self.metadata = self.data.drop(columns=drop_cols)
            self.metadata = self.metadata.select_dtypes(include=["float32", "float64", "int64", "int32"]).values.astype("float32")

    def extract_uid(self, path):
        parts = path.split("/")
        return parts[2] if len(parts) >= 3 else None

    def map_uids_to_jpeg_paths(self, uid_list, image_type):
        paths = []
        for uid in uid_list:
            match = self.dicom_info[
                (self.dicom_info["image_path"].str.contains(uid, na=False)) &
                (self.dicom_info["SeriesDescription"] == image_type)
            ]
            if not match.empty:
                jpeg_rel_path = match.iloc[0]["image_path"]
                jpeg_rel_path = jpeg_rel_path.split("CBIS-DDSM/jpeg/")[-1]
                full_path = os.path.join(self.jpeg_root_dir, jpeg_rel_path)
                paths.append(full_path)
            else:
                paths.append(None)
        return paths

    def __len__(self):
        return len(self.data)

    def __getitem__(self, idx):
        img_path = self.image_paths[idx]
        image = Image.open(img_path).convert("RGB") if img_path else Image.new("RGB", (224, 224))

        if self.transform:
            image = self.transform(image)

        label = torch.tensor(self.labels[idx], dtype=torch.float32)

        if self.use_metadata:
            meta_tensor = torch.tensor(self.metadata[idx], dtype=torch.float32)
            return image, label, meta_tensor, img_path
        else:
            return image, label, img_path

# Örnek kullanım
if __name__ == "__main__":
    base_dir = "C:/Users/beyza/Desktop/CBIS-DDSM/csv"
    jpeg_dir = "C:/Users/beyza/Desktop/CBIS-DDSM/jpeg"

    csv_path = os.path.join(base_dir, "metadata_encoded.csv")
    dicom_path = os.path.join(base_dir, "temizlenen_csvler", "dicom_info_temizlendi.csv")

    transform_ops = transforms.Compose([
        transforms.Resize((224, 224)),
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406],
                             [0.229, 0.224, 0.225])
    ])

    dataset = BreastCancerDataset(
        csv_file=csv_path,
        jpeg_root_dir=jpeg_dir,
        dicom_info_csv=dicom_path,
        transform=transform_ops,
        use_metadata=True
    )

    dataloader = DataLoader(dataset, batch_size=4, shuffle=True)

    for images, labels, metadata, paths in dataloader:
        print("Bir batch başarıyla yüklendi!")
        print("Görüntü boyutu:", images.shape)
        print("Etiketler:", labels)
        print("Metadata shape:", metadata.shape)

        print("\nİlk örnek detayları:")
        print("- Image Path :", paths[0])
        print("- Label      :", labels[0].item())
        print("- Metadata   :", metadata[0][:5])
        break