import torch
import torch.nn as nn
from torchvision.models import vgg16

class CombinedVGG16(nn.Module):
    def __init__(self, metadata_dim: int):
        super().__init__()

      
        self.base_model = vgg16(weights=None)
        self.base_model.classifier = nn.Identity()

       
        self.metadata_fc = nn.Sequential(
            nn.Linear(metadata_dim, 128),
            nn.ReLU(),
            nn.Dropout(0.4),
            nn.Linear(128, 64),
            nn.ReLU()
        )

        # Görsel + metadata birleşimi sonrası sınıflandırma
        self.classifier = nn.Sequential(
            nn.Linear(25088 + 64, 128),
            nn.ReLU(),
            nn.Dropout(0.5),
            nn.Linear(128, 1)
        )

    def forward(self, image, metadata):
        # Görsel öznitelikleri çıkar
        x_img = self.base_model.features(image)
        x_img = torch.flatten(x_img, 1)

        # Metadata öznitelikleri çıkar
        x_meta = self.metadata_fc(metadata)

        # Birleştir ve sınıflandır
        combined = torch.cat((x_img, x_meta), dim=1)
        output = self.classifier(combined)
        return output