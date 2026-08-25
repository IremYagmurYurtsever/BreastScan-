import torch
from models.CombinedVgg16 import CombinedVGG16

def load_model(model_path="models/best_models/vgg16.pth", device="cpu"):
    metadata_dim = 3
    model = CombinedVGG16(metadata_dim=metadata_dim)

    checkpoint = torch.load(model_path, map_location=device, weights_only=False)
    model.load_state_dict(checkpoint["model_state_dict"])  

    model.to(device)
    model.eval()
    return model
