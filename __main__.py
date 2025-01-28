import requests

def get_genshin_codes():
    url = "https://api.ennead.cc/mihoyo/genshin/codes"
    try:
        response = requests.get(url)
        response.raise_for_status()
        data = response.json()
        
        active_codes = data.get('active', [])
        
        print("Active Genshin Impact Codes:")
        print("-" * 50)
        for code_data in active_codes:
            code = code_data['code']
            rewards = ', '.join(code_data['rewards'])
            print(f"Code: {code} Rewards: {rewards}")
            
    except requests.RequestException as e:
        print(f"Error fetching codes: {e}")

if __name__ == "__main__":
    get_genshin_codes()
    print("\nThis script is only for testing, here will be the main script")