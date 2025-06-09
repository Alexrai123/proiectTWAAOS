import httpx
import json

ids = [1, 3211, 874, 1107, 1511, 9999]
BASE = 'https://orar.usv.ro/orar/vizualizare/data/'
results = {}
with httpx.Client(timeout=20) as client:
    for i in ids:
        url = f'{BASE}orarSPG.php?ID={i}&mod=grupa&json'
        try:
            resp = client.get(url)
            try:
                data = resp.json()
            except Exception as e:
                data = f'JSON decode error: {e} (raw: {resp.text[:200]})'
            results[str(i)] = data
        except Exception as e:
            results[str(i)] = f'HTTP error: {e}'
with open('api_samples.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, indent=2, ensure_ascii=False)
print('Done. Sample responses written to api_samples.json')
