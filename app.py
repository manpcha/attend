import json
import os
from pathlib import Path

from fastapi import FastAPI, Request
from fastapi.responses import FileResponse, JSONResponse, PlainTextResponse

BASE_DIR = Path(__file__).parent
DATA_DIR = Path(os.environ.get("DATA_DIR", "/data"))

DEFAULT_WORK = {
    "화": {"in": "송정용", "out": "김영구"},
    "수": {"in": "차준호", "out": "양준모"},
    "목": {"in": "선형종", "out": "박진배"},
}
DEFAULT_RULE = {
    "odd": "화/수/목 (1,3,5주)",
    "even": "수/목 (2,4주)",
}
DEFAULT_SETTINGS = {
    "geminiKeyEncoded": "",
    "geminiModel": "gemini-2.5-flash",
}

app = FastAPI(title="근태 시스템")


def ensure_data_dir() -> None:
    DATA_DIR.mkdir(parents=True, exist_ok=True)


def read_json(path: Path, default: dict) -> dict:
    if not path.exists():
        return default
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def write_json(path: Path, data: dict) -> None:
    with path.open("w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)


@app.on_event("startup")
def on_startup() -> None:
    ensure_data_dir()


@app.get("/")
async def root():
    return FileResponse(BASE_DIR / "index.html")


@app.get("/index.html")
async def index_html():
    return FileResponse(BASE_DIR / "index.html")


@app.get("/api/notes")
async def get_notes():
    path = DATA_DIR / "notes.txt"
    if not path.exists():
        return PlainTextResponse("")
    return PlainTextResponse(path.read_text(encoding="utf-8"))


@app.post("/api/notes")
async def post_notes(request: Request):
    text = (await request.body()).decode("utf-8")
    ensure_data_dir()
    (DATA_DIR / "notes.txt").write_text(text, encoding="utf-8")
    return {"ok": True}


@app.get("/api/work")
async def get_work():
    return read_json(DATA_DIR / "work.json", DEFAULT_WORK)


@app.post("/api/work")
async def post_work(data: dict):
    ensure_data_dir()
    write_json(DATA_DIR / "work.json", data)
    return {"ok": True}


@app.get("/api/rule")
async def get_rule():
    return read_json(DATA_DIR / "rule.json", DEFAULT_RULE)


@app.post("/api/rule")
async def post_rule(data: dict):
    ensure_data_dir()
    write_json(DATA_DIR / "rule.json", data)
    return {"ok": True}


@app.get("/api/settings")
async def get_settings():
    return read_json(DATA_DIR / "settings.json", DEFAULT_SETTINGS)


@app.post("/api/settings")
async def post_settings(data: dict):
    ensure_data_dir()
    write_json(DATA_DIR / "settings.json", data)
    return {"ok": True}
