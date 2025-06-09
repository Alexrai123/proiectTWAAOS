import asyncpg
import asyncio

async def main():
    try:
        conn = await asyncpg.connect(user='postgres', password='postgres', database='twaaos_sic', host='localhost', port=5432, timeout=5)
        print('OK')
        await conn.close()
    except Exception as e:
        import traceback
        print('FAIL:', repr(e))
        traceback.print_exc()

if __name__ == "__main__":
    asyncio.run(main())
