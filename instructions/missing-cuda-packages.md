# Missing CUDA/PyTorch Python Packages

52 Python packages from the top 3000 PyPI that require CUDA or PyTorch and are not yet available in ekapkgs.

These packages are blocked on the CUDA repository being integrated.

| Rank | Package | Version | Blocked by | Description |
|------|---------|---------|------------|-------------|
| 335 | `python3Packages.torch` | N/A | `torch` | PyTorch deep learning framework |
| 462 | `python3Packages.triton` | 3.7.0 | `addDriverRunpath`, `cudaPackages`, `cudaSupport`, `rocmPackages` | Language and compiler for writing highly efficient custom Deep-Learning primitiv |
| 575 | `python3Packages.cuda-bindings` | unknown | `addDriverRunpath`, `cudaPackages` | Standard set of low-level interfaces, providing access to the CUDA host APIs fro |
| 636 | `python3Packages.torchvision` | 0.27.0 | `torch` | PyTorch vision library |
| 798 | `python3Packages.sentence-transformers` | 5.4.1 | `torch` | Multilingual Sentence & Image Embeddings with BERT |
| 815 | `python3Packages.lightgbm` | unknown | `cudaPackages`, `cudaSupport` | Fast, distributed, high performance gradient boosting (GBDT, GBRT, GBM or MART)  |
| 843 | `python3Packages.accelerate` | 1.13.0 | `cudatoolkit`, `torch`, `torchvision` | Simple way to train and use PyTorch models with multi-GPU, TPU, mixed-precision |
| 1015 | `python3Packages.nvidia-ml-py` | 13.610.43 | `addDriverRunpath`, `cudaPackages` | Python Bindings for the NVIDIA Management Library |
| 1026 | `python3Packages.tensorflow` | 2.13.0 | `addDriverRunpath`, `cudaPackages`, `cudaSupport` | Computation using data flow graphs for scalable machine learning |
| 1061 | `python3Packages.keras` | 3.15.1 | `torch` | Multi-backend implementation of the Keras API, with support for TensorFlow, JAX, |
| 1084 | `python3Packages.gradio` | 6.20.0 | `torch` | Python library for easily interacting with trained machine learning models |
| 1189 | `python3Packages.timm` | 1.0.27 | `torch`, `torchvision` | PyTorch image models, scripts, and pretrained weights |
| 1325 | `python3Packages.torchaudio` | 2.11.0 | `cudaSupport`, `rocmSupport`, `torch`, `torchaudio`, `torchcodec` | PyTorch audio library |
| 1331 | `python3Packages.torchmetrics` | 1.9.0 | `torch`, `torchmetrics` | Machine learning metrics for distributed, scalable PyTorch applications (used in |
| 1378 | `python3Packages.peft` | 0.18.1 | `torch` | State-of-the art parameter-efficient fine tuning |
| 1406 | `python3Packages.pytorch-lightning` | 2.6.5 | `torch`, `torchmetrics` | Lightweight PyTorch wrapper for machine learning researchers |
| 1437 | `python3Packages.quack-kernels` | 0.5.3 | `torch` | Quirky Assortment of CuTe Kernels |
| 1440 | `python3Packages.ctranslate2` | unknown | `torch` | Fast inference engine for Transformer models |
| 1488 | `python3Packages.tensorflow-estimator` | N/A | `tensorflow` | TensorFlow Estimator |
| 1571 | `python3Packages.ultralytics` | 8.4.51 | `torch`, `torchvision` | Train YOLO models for computer vision tasks |
| 1611 | `python3Packages.gluonts` | 0.16.3 | `torch` | Probabilistic time series modeling in Python |
| 1728 | `python3Packages.xgrammar` | 0.1.33 | `torch` | Efficient, Flexible and Portable Structured Generation |
| 1753 | `python3Packages.compressed-tensors` | 0.17.1 | `torch` | Safetensors extension to efficiently store sparse quantized tensors on disk |
| 1907 | `python3Packages.ultralytics-thop` | 2.0.19 | `torch` | Profile PyTorch models by computing the number of Multiply-Accumulate Operations |
| 1944 | `python3Packages.nvidia-cutlass-dsl-libs-base` | 4.6.0.dev0 | `autoAddDriverRunpath` | Bundled MLIR/CUDA runtime libraries and Python sources for the NVIDIA CUTLASS DS |
| 2011 | `python3Packages.bitsandbytes` | 0.49.2 | `cudaPackages`, `cudaSupport`, `rocmPackages`, `rocmSupport`, `torch` | 8-bit CUDA functions for PyTorch |
| 2030 | `python3Packages.cuda-core` | 1.0.1 | `cudaPackages`, `cudaSupport` | Pythonic interface to the CUDA runtime |
| 2084 | `python3Packages.unstructured` | 0.18.31 | `torch` | Open source libraries and APIs to build custom preprocessing pipelines for label |
| 2124 | `python3Packages.outlines-core` | 0.2.14 | `torch` | Structured text generation (core) |
| 2233 | `python3Packages.torch-c-dlpack-ext` | unknown | `torch` | Ahead-Of-Time (AOT) compiled module to support faster DLPack conversion in DLPac |
| 2292 | `python3Packages.nvidia-cudnn-frontend` | unknown | `cudaPackages`, `torch` |  |
| 2300 | `python3Packages.fireworks-ai` | 1.2.0 | `torch` | Client library for Fireworks.ai |
| 2355 | `python3Packages.openai-whisper` | 20250625 | `torch` | General-purpose speech recognition model |
| 2362 | `python3Packages.torchcodec` | 0.14.0 | `cudaSupport`, `rocmSupport`, `torch`, `torchvision` | PyTorch media decoding and encoding |
| 2387 | `python3Packages.pylance` | 8.0.0 | `torch` | Python wrapper for Lance columnar format |
| 2477 | `python3Packages.easyocr` | 1.7.2 | `torch`, `torchvision` | Ready-to-use OCR with 80+ supported languages and all popular writing scripts |
| 2498 | `python3Packages.cuda-tile` | 1.4.0 | `cudaPackages`, `torch` | Programming model for writing parallel kernels for NVIDIA GPUs |
| 2509 | `python3Packages.rembg` | 2.0.77 | `cudaSupport` | Tool to remove background from images |
| 2522 | `python3Packages.torchao` | 0.17.0 | `torch`, `torchvision` | PyTorch native quantization and sparsity for training and inference |
| 2526 | `python3Packages.pytorch-metric-learning` | 2.9.0 | `cudaSupport`, `torch`, `torchvision` | Metric learning library for PyTorch |
| 2579 | `python3Packages.onnxscript` | 0.7.1 | `cudaSupport`, `torch`, `torchvision` | Naturally author ONNX functions and models using a subset of Python |
| 2595 | `python3Packages.docling-ibm-models` | 3.13.2 | `torch`, `torchvision` | Docling IBM models |
| 2603 | `python3Packages.pynvml` | 13.0.1 | `cudaPackages` | Unofficial Python bindings for the NVIDIA Management Library |
| 2700 | `python3Packages.open-clip-torch` | 3.3.0 | `torch`, `torchvision` | Open source implementation of CLIP |
| 2702 | `python3Packages.pymatting` | 1.1.15 | `cudaSupport` | Python library for alpha matting |
| 2748 | `python3Packages.onnx-ir` | 0.2.1 | `torch` | Efficient in-memory representation for ONNX, in Python |
| 2749 | `python3Packages.kornia` | 0.8.2 | `torch` | Differentiable computer vision library |
| 2791 | `python3Packages.rerun-sdk` | unknown | `torch`, `torchvision` | Python bindings for `rerun` (an interactive visualization tool for stream data) |
| 2819 | `python3Packages.iopath` | 0.1.10 | `torch` | Python library that provides common I/O interface across different storage backe |
| 2893 | `python3Packages.tilelang` | 0.1.11 | `cudaPackages`, `cudaSupport`, `torch` | Tile level programming language to generate high performance code |
| 2913 | `python3Packages.julius` | 0.2.7 | `torch` | Nice DSP sweets: resampling, FFT Convolutions. All with PyTorch, differentiable  |
| 2967 | `python3Packages.tensordict` | 0.13.0 | `torch` | Pytorch dedicated tensor container |
