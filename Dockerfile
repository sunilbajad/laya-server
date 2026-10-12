FROM python:3.11-slim
ENV PIP_NO_CACHE_DIR=1 PYTHONUNBUFFERED=1 HF_HOME=/models \
    LAYA_REVISION=7b928d828b7b0e022f929d9bd2e44165aa270148

RUN pip install --index-url https://download.pytorch.org/whl/cpu torch \
 && pip install "laya[serve]==0.4.1"

# Sirf multilingual model (~650 MB) image mein daalo, Hinglish bhi yahi samajhta hai
RUN python -c "from huggingface_hub import snapshot_download; snapshot_download('convaiinnovations/laya', revision='7b928d828b7b0e022f929d9bd2e44165aa270148', allow_patterns=['multilingual/*'])"

ENV HF_HUB_OFFLINE=1 LAYA_HOST=0.0.0.0 LAYA_MODELS=multilingual \
    LAYA_DEFAULT_MODEL=multilingual LAYA_MAX_LOADED=1 LAYA_THREADS=2
CMD ["sh", "-c", "LAYA_PORT=${PORT:-10000} exec laya-serve"]
