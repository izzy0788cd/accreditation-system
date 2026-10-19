"""Run this import's SQL using the existing Npgsql loader; never print credentials."""
import os
import pathlib
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parents[3]
DIRECTORY = pathlib.Path(__file__).resolve().parent
values = {}
for line in (ROOT / '.env').read_text(encoding='utf-8-sig').splitlines():
    if '=' in line and not line.lstrip().startswith('#'):
        key, value = line.split('=', 1)
        values[key.strip()] = value.strip().strip('"').strip("'")
env = os.environ.copy()
env['ConnectionStrings__AppDbContext'] = (
    'Host=localhost;Port=5432;Database=' + values['POSTGRES_DB']
    + ';Username=' + values['POSTGRES_USER'] + ';Password=' + values['POSTGRES_PASSWORD']
)
sql = DIRECTORY / sys.argv[1]
if sql.resolve().parent != DIRECTORY or sql.suffix != '.sql':
    raise ValueError('Only SQL files in this import directory are allowed')
result = subprocess.run(
    ['dotnet', str(ROOT / 'data/dummy-survey/loader/bin/Debug/net10.0/loader.dll'), str(sql)],
    cwd=ROOT, env=env, capture_output=True, text=True, encoding='utf-8', timeout=90,
)
if result.returncode:
    raise RuntimeError(result.stderr[:2000])
print(result.stdout)
if sql.name == 'import.sql':
    (DIRECTORY / 'import-receipt.jsonl').write_text(result.stdout, encoding='utf-8')
