import torch
from torch.utils.data import Sampler
import random
from collections import defaultdict

class BalancedBatchSampler(Sampler):
    """
    Her batch'te eşit sayıda benign ve malignant örneği olacak şekilde sampler.
    Epoch uzunluğu azınlık sınıfına göre ayarlanır.
    """

    def __init__(self, labels, batch_size, max_batches=64):
        self.labels = labels
        self.batch_size = batch_size
        self.max_batches = max_batches

        self.num_classes = len(set(labels))
        assert batch_size % self.num_classes == 0

        self.samples_per_class = batch_size // self.num_classes

        from collections import defaultdict
        self.class_indices = defaultdict(list)
        for idx, label in enumerate(labels):
            self.class_indices[label].append(idx)

        self.min_class_len = min(len(idxs) for idxs in self.class_indices.values())
        self.num_batches = self.min_class_len // self.samples_per_class

        if self.max_batches is not None:
            self.num_batches = min(self.num_batches, self.max_batches)

        print(">>> min_class_len:", self.min_class_len)
        print(">>> samples_per_class:", self.samples_per_class)
        print(">>> num_batches:", self.num_batches)
        
    def __iter__(self):
        shuffled_class_indices = {
            label: random.sample(indices, len(indices))
            for label, indices in self.class_indices.items()
        }

        batch_indices = []

        for batch_idx in range(self.num_batches):
            batch = []
            for label in self.class_indices:
                start = batch_idx * self.samples_per_class
                end = start + self.samples_per_class
                batch.extend(shuffled_class_indices[label][start:end])
            random.shuffle(batch)
            batch_indices.append(batch)

        return iter([idx for batch in batch_indices for idx in batch])

    def __len__(self):
        return self.num_batches
