from torchvision import transforms
from PIL import ImageOps

class EqualizeTransform:
    def __call__(self, img):
        img = img.convert("RGB") 
        return ImageOps.equalize(img)

# Eğitim verisi için transform
def get_train_transform():
    return transforms.Compose([
        transforms.Resize((224, 224)),
        EqualizeTransform(),
        transforms.RandomResizedCrop(224, scale=(0.9, 1.0), ratio=(0.9, 1.1)),
        transforms.RandomHorizontalFlip(p=0.5),
        # transforms.RandomVerticalFlip(p=0.3),
        transforms.RandomRotation(degrees=15),
        transforms.RandomAffine(degrees=10, translate=(0.05, 0.05), scale=(0.95, 1.05)),
        # transforms.ColorJitter(brightness=0.2, contrast=0.2),
        # transforms.RandomApply([transforms.GaussianBlur(kernel_size=(3, 3))], p=0.2),
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406],
                             [0.229, 0.224, 0.225]),
        # transforms.RandomErasing(p=0.1, scale=(0.02, 0.1), ratio=(0.3, 3.3), value=0)
    ])

# Validasyon verisi için transform
def get_val_transform():
    return transforms.Compose([
        transforms.Resize((224, 224)),
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406],
                             [0.229, 0.224, 0.225])
    ])