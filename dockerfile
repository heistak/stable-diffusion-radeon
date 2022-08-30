# Edit this in accordance with your graphics card, from the list of images in the URL
# お持ちのグラフィックカードに合わせて、以下のイメージリストの中のどれかに出発点のイメージ名を書き換えてください
# https://hub.docker.com/r/rocm/pytorch/tags
FROM rocm/pytorch:rocm5.2_ubuntu20.04_py3.7_pytorch_1.11.0_navi21

# The actual work should be done on the shared /dockerx/rocm/stable-diffusion directory, 
# but we need to clone the repo on the container side to setup the conda env (move it manually later)
# 実際の生成はローカルからマウントされた/dockerx/rocm/stable-diffusionディレクトリで行うが、
# conda環境の初期セットアップのためにとりあえず先に別の場所にgit cloneしてしまう（後で手動で移動してください）

RUN git clone https://github.com/CompVis/stable-diffusion.git /root/stable-diffusion
COPY environment2.yaml /root/stable-diffusion/

WORKDIR /root/stable-diffusion/
RUN conda env create -f /root/stable-diffusion/environment2.yaml && conda init bash && echo "cd /dockerx/rocm/stable-diffusion/; conda activate ldm" >> /root/.bashrc

# Since we just appended to .bashrc to activate the conda environment, 
# you should be able to start generating right after logging into the container
# .bashrc末尾にconda環境の有効化コマンドを書き込んであるので、
# コンテナに入った直後からStable Diffusionのスクリプトが動く状態になっているはず

# Sample syntax:
# python3 scripts/txt2img.py --prompt "A beautiful sunset on the ocean horizon" --H 512 --W 512 --n_iter 1 --ddim_steps 50 --n_samples 1
